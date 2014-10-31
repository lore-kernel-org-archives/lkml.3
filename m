Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422705AbaJaHUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:20:49 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:37892 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758961AbaJaHUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:20:47 -0400
From: Eternal <eternal.n08@gmail.com>
X-Google-Original-From: Eternal Night@MJJ-LAPTOP.i-did-not-set--mail-host-address--so-tickle-me
To: Kees Cook <keescook@chromium.org>
Cc: Junjie Mao <eternal.n08@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, kaslr: Prevent .bss from overlaping initrd
References: <1414672901-29118-1-git-send-email-eternal.n08@gmail.com>
	<CAGXu5jLG_c8vZ5_v7WMaZxKgLdJXhorarCFGcB4fFLUYmLK--Q@mail.gmail.com>
Date: Fri, 31 Oct 2014 15:20:37 +0800
Message-ID: <86lhnw66yi.fsf@MJJ-LAPTOP.i-did-not-set--mail-host-address--so-tickle-me>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (windows-nt)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> Ah! Thank you for tracking this bug down. I had never been able to reproduce it!
>
> On Thu, Oct 30, 2014 at 5:41 AM, Junjie Mao <eternal.n08@gmail.com> wrote:
>> When choosing a random address, the current implementation does not take into
>> account the reversed space for .bss and .brk sections. Thus the relocated kernel
>> may overlap other components in memory, e.g. the initrd image:
>>
>> +-------------------+
>> |   decompressed    |
>> |      kernel       |
>> |   (relocated)     |
>
> Strictly speaking, the relocation table follows the decompressed
> kernel, though it is part of the decompressed data. It isn't in use
> once the kernel starts. Does (should) .bss overlap it?

Thanks for pointing this out! I'm not that familiar with the internals
of kaslr and the previous analysis is not accurate. Terribly sorry for
that...

The relocation table is overlapped by .bss. Here's the memory layout I
have dumped in another run with the error:

size of vmlinux.bin:       60217456 == 0x0396d870
size of vmlinux.relocs:    4909624 == 0x4aea38

compressed kernel:         [0x0449526e, 0x04e306e1]
initrd:                    [0x13ce6000, 0x13fef373]
relocated kernel (elf):    [0x0fe00000, 0x1376d869]
  (0x0fe00000 + 0x0396d870 - 1 = 0x1376d869)
relocation table:          [0x1376d870, 0x13c1c2a7]
  (0x1376d870 + 0x4aea38 - 1 = 0x13c1c2a7)
relocated kernel (binary): [0x0fe00000, 0x1336cfff]
.bss:                      [0x1336d000, 0x13f50fff]
  (overlaps the relocation table)
.brk:                      [0x13f51000, 0x13f77000]

>
>> +-------------------+--
>> |                   |  \
>> +-------------------+   .bss and .brk section
>> |                   |  /
>> |      initrd       |--
>> |                   |
>> +-------------------+
>>
>> Here is an example of the overlap from a x86_64 kernel in qemu (the ranges of
>> physical addresses are presented):
>>
>> compressed kernel:      [0x0449626e, 0x04e30aa3]
>> initrd:                 [0x13ce6000, 0x13fef373]
>> relocated kernel:       [0x0fe00000, 0x13c1c2bb]
>> .bss and .brk sections: [0x13c1c2bc, 0x148262bb]
>
> What did you use to instrument this? I'd be curious to see how large
> the relocation table is too.

I use the following function to print an arbitrary number in hexadecimal
in aslr.c and misc.c:

void print_hex(unsigned long value) {
        char c[2];
        int i;

        c[1] = '\0';
        for (i = 60; i >= 0; i -= 4) {
                unsigned long digit = (addr >> i) & 0xf;
                if (digit <= 9) {
                        c[0] = '0' + digit;
                } else {
                        c[0] = 'a' + (digit - 10);
                }
                debug_putstr(c);
        }
}

>
>> The initrd image will then be overwritten by the memset during early
>> initialization:
>>
>> [    1.655204] Unpacking initramfs...
>> [    1.662831] Initramfs unpacking failed: junk in compressed archive
>>
>> This patch prevents the above situation by requiring a larger space when looking
>> for a random kernel base, so that existing logic can effectively avoids the
>> overlap.
>
> Yes, thank you again for tracking this down!
>
>>
>> Fixes: 82fa9637a2 ("x86, kaslr: Select random position from e820 maps")
>> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>> Signed-off-by: Junjie Mao <eternal.n08@gmail.com>
>
> This should also go to stable:
>
> Cc: stable@vger.kernel.org
>
>> ---
>>  arch/x86/boot/compressed/Makefile  |  3 ++-
>>  arch/x86/boot/compressed/aslr.c    |  5 +++--
>>  arch/x86/boot/compressed/head_32.S |  3 ++-
>>  arch/x86/boot/compressed/head_64.S |  3 +++
>>  arch/x86/boot/compressed/misc.c    |  6 ++++--
>>  arch/x86/boot/compressed/misc.h    |  6 ++++--
>>  arch/x86/boot/compressed/mkpiggy.c |  8 ++++++--
>>  arch/x86/tools/calc_reserved.awk   | 21 +++++++++++++++++++++
>>  8 files changed, 45 insertions(+), 10 deletions(-)
>>  create mode 100644 arch/x86/tools/calc_reserved.awk
>>
>> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
>> index 704f58aa79cd..419e12b203d9 100644
>> --- a/arch/x86/boot/compressed/Makefile
>> +++ b/arch/x86/boot/compressed/Makefile
>> @@ -76,8 +76,9 @@ suffix-$(CONFIG_KERNEL_XZ)    := xz
>>  suffix-$(CONFIG_KERNEL_LZO)    := lzo
>>  suffix-$(CONFIG_KERNEL_LZ4)    := lz4
>>
>> +RESERVED_SIZE = $(shell objdump -h vmlinux | awk -f $(srctree)/arch/x86/tools/calc_reserved.awk)
>>  quiet_cmd_mkpiggy = MKPIGGY $@
>> -      cmd_mkpiggy = $(obj)/mkpiggy $< > $@ || ( rm -f $@ ; false )
>> +      cmd_mkpiggy = $(obj)/mkpiggy $< $(RESERVED_SIZE) > $@ || ( rm -f $@ ; false )
>>
>>  targets += piggy.S
>>  $(obj)/piggy.S: $(obj)/vmlinux.bin.$(suffix-y) $(obj)/mkpiggy FORCE
>> diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
>> index bb1376381985..d4695b022971 100644
>> --- a/arch/x86/boot/compressed/aslr.c
>> +++ b/arch/x86/boot/compressed/aslr.c
>> @@ -298,7 +298,8 @@ static unsigned long find_random_addr(unsigned long minimum,
>>  unsigned char *choose_kernel_location(unsigned char *input,
>>                                       unsigned long input_size,
>>                                       unsigned char *output,
>> -                                     unsigned long output_size)
>> +                                     unsigned long output_size,
>> +                                     unsigned long reserved_size)
>>  {
>>         unsigned long choice = (unsigned long)output;
>>         unsigned long random;
>> @@ -320,7 +321,7 @@ unsigned char *choose_kernel_location(unsigned char *input,
>>                        (unsigned long)output, output_size);
>>
>>         /* Walk e820 and find a random address. */
>> -       random = find_random_addr(choice, output_size);
>> +       random = find_random_addr(choice, output_size + reserved_size);
>>         if (!random) {
>>                 debug_putstr("KASLR could not find suitable E820 region...\n");
>>                 goto out;
>> diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
>> index cbed1407a5cd..06c18f6d1f13 100644
>> --- a/arch/x86/boot/compressed/head_32.S
>> +++ b/arch/x86/boot/compressed/head_32.S
>> @@ -207,6 +207,7 @@ relocated:
>>   * Do the decompression, and jump to the new kernel..
>>   */
>>                                 /* push arguments for decompress_kernel: */
>> +       pushl   $reserved_size
>>         pushl   $z_output_len   /* decompressed length */
>>         leal    z_extract_offset_negative(%ebx), %ebp
>>         pushl   %ebp            /* output address */
>> @@ -217,7 +218,7 @@ relocated:
>>         pushl   %eax            /* heap area */
>>         pushl   %esi            /* real mode pointer */
>>         call    decompress_kernel /* returns kernel location in %eax */
>> -       addl    $24, %esp
>> +       addl    $28, %esp
>>
>>  /*
>>   * Jump to the decompressed kernel.
>> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
>> index 2884e0c3e8a5..02c518f8aca5 100644
>> --- a/arch/x86/boot/compressed/head_64.S
>> +++ b/arch/x86/boot/compressed/head_64.S
>> @@ -402,6 +402,8 @@ relocated:
>>   * Do the decompression, and jump to the new kernel..
>>   */
>>         pushq   %rsi                    /* Save the real mode argument */
>> +       movq    $reserved_size, %r9
>> +       pushq   %r9
>>         movq    %rsi, %rdi              /* real mode address */
>>         leaq    boot_heap(%rip), %rsi   /* malloc area for uncompression */
>>         leaq    input_data(%rip), %rdx  /* input_data */
>> @@ -409,6 +411,7 @@ relocated:
>>         movq    %rbp, %r8               /* output target address */
>>         movq    $z_output_len, %r9      /* decompressed length */
>>         call    decompress_kernel       /* returns kernel location in %rax */
>> +       popq    %r9
>>         popq    %rsi
>>
>>  /*
>> diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
>> index 57ab74df7eea..173062d32898 100644
>> --- a/arch/x86/boot/compressed/misc.c
>> +++ b/arch/x86/boot/compressed/misc.c
>> @@ -358,7 +358,8 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
>>                                   unsigned char *input_data,
>>                                   unsigned long input_len,
>>                                   unsigned char *output,
>> -                                 unsigned long output_len)
>> +                                 unsigned long output_len,
>> +                                 unsigned long reserved_size)
>>  {
>>         real_mode = rmode;
>>
>> @@ -382,7 +383,8 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
>>         free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
>>
>>         output = choose_kernel_location(input_data, input_len,
>> -                                       output, output_len);
>> +                                       output, output_len,
>> +                                       reserved_size);
>>
>>         /* Validate memory location choices. */
>>         if ((unsigned long)output & (MIN_KERNEL_ALIGN - 1))
>> diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
>> index 24e3e569a13c..fae4cef40f1f 100644
>> --- a/arch/x86/boot/compressed/misc.h
>> +++ b/arch/x86/boot/compressed/misc.h
>> @@ -59,7 +59,8 @@ int cmdline_find_option_bool(const char *option);
>>  unsigned char *choose_kernel_location(unsigned char *input,
>>                                       unsigned long input_size,
>>                                       unsigned char *output,
>> -                                     unsigned long output_size);
>> +                                     unsigned long output_size,
>> +                                     unsigned long reserved_size);
>>  /* cpuflags.c */
>>  bool has_cpuflag(int flag);
>>  #else
>> @@ -67,7 +68,8 @@ static inline
>>  unsigned char *choose_kernel_location(unsigned char *input,
>>                                       unsigned long input_size,
>>                                       unsigned char *output,
>> -                                     unsigned long output_size)
>> +                                     unsigned long output_size,
>> +                                     unsigned long reserved_size)
>>  {
>>         return output;
>>  }
>> diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
>> index b669ab65bf6c..a31983ced81b 100644
>> --- a/arch/x86/boot/compressed/mkpiggy.c
>> +++ b/arch/x86/boot/compressed/mkpiggy.c
>> @@ -36,11 +36,12 @@ int main(int argc, char *argv[])
>>         uint32_t olen;
>>         long ilen;
>>         unsigned long offs;
>> +       unsigned long reserved_size;
>>         FILE *f = NULL;
>>         int retval = 1;
>>
>> -       if (argc < 2) {
>> -               fprintf(stderr, "Usage: %s compressed_file\n", argv[0]);
>> +       if (argc < 3) {
>> +               fprintf(stderr, "Usage: %s compressed_file reserved_size\n", argv[0]);
>>                 goto bail;
>>         }
>>
>> @@ -74,6 +75,7 @@ int main(int argc, char *argv[])
>>         offs += olen >> 12;     /* Add 8 bytes for each 32K block */
>>         offs += 64*1024 + 128;  /* Add 64K + 128 bytes slack */
>>         offs = (offs+4095) & ~4095; /* Round to a 4K boundary */
>> +       reserved_size = atoi(argv[2]);
>>
>>         printf(".section \".rodata..compressed\",\"a\",@progbits\n");
>>         printf(".globl z_input_len\n");
>> @@ -85,6 +87,8 @@ int main(int argc, char *argv[])
>>         /* z_extract_offset_negative allows simplification of head_32.S */
>>         printf(".globl z_extract_offset_negative\n");
>>         printf("z_extract_offset_negative = -0x%lx\n", offs);
>> +       printf(".globl reserved_size\n");
>> +       printf("reserved_size = 0x%lx\n", reserved_size);
>>
>>         printf(".globl input_data, input_data_end\n");
>>         printf("input_data:\n");
>> diff --git a/arch/x86/tools/calc_reserved.awk b/arch/x86/tools/calc_reserved.awk
>> new file mode 100644
>> index 000000000000..2ca69682338a
>> --- /dev/null
>> +++ b/arch/x86/tools/calc_reserved.awk
>> @@ -0,0 +1,21 @@
>> +#!/bin/awk -f
>> +#
>> +# Calculate the amount of space that we have to reserve for .bss and .brk
>> +# sections
>> +#
>> +# Usage:
>> +# objdump -h a.out | awk -f calc_reserved.awk
>> +
>> +BEGIN {
>> +       sections = "^.bss$|^.brk$"
>> +       size = 0;
>> +}
>> +
>> +/^ *[0-9]+ [a-z._]+ *[0-9a-f]+/ {
>> +       if (match($2, sections))
>> +               size += strtonum("0x" $3);
>> +}
>> +
>> +END {
>> +       printf("%d\n", size);
>> +}
>> --
>> 1.9.3
>
> Should mkpiggy.c do the work itself instead of taking an argument?

Both ways are ok to me. I'm not sure which way is better, though.

>
> Regardless, I want to make sure we've got the right values here. On
> one of my builds:
>
> vmlinux.bin, size 21186672, "objdump -h" shows:
>
>  25 .bss          00da2000  ffffffff82034000  0000000002034000  01434000  2**12
>                   ALLOC
>  26 .brk          00026000  ffffffff82dd6000  0000000002dd6000  01434000  2**0
>                   ALLOC
>
> vmlinux.relocs, size 1058872
>
> vmlinux.bin.gz, size 7549715, shows a decompressed size of 22245544:
> $ dd if=vmlinux.bin.gz bs=1 skip=7549711 2>/dev/null | hexdump -C
> 00000000  a8 70 53 01                                       |.pS.|
> 00000004
>
> 0x015370a8 == 22245544 == 21186672 + 1058872
>
> This means relocs are overlapping .bss, since .bss starts at
> 0x01434000 (21184512). The actually needed reserved space is
> 0x01434000 + 0x00da2000 + 0x00026000 (35635200), rather than 22245544
> + 0x00da2000 + 0x00026000 (36696232).
>
> So, since z_output_len is really "end of relocs table" and not "end of
> kernel", we actually need two offsets:
>
> - relocs table end (exists already via z_output_len)
> - end of actual kernel plus .bss and .brk, which is the sum of:
>   - actual size of decompressed kernel image (vmlinux.bin: 21186672)
>   - size of .bss + .brk (0x00da2000 + 0x00026000)
>
> And kASLR needs to use the larger of these two values.

I agree. Thanks for the correction again!

Best Regards
Junjie Mao

>
> -Kees
