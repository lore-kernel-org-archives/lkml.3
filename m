Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398AbaJaNRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:17:51 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57932 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684AbaJaNRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:17:49 -0400
From: Eternal <eternal.n08@gmail.com>
X-Google-Original-From: Eternal Night@MJJ-LAPTOP.i-did-not-set--mail-host-address--so-tickle-me
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Junjie Mao <eternal.n08@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Vivek Goyal <vgoyal@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH v2] x86, kaslr: Prevent .bss from overlaping initrd
References: <20141030195239.GA12768@www.outflux.net>
Date: Fri, 31 Oct 2014 21:17:35 +0800
In-Reply-To: <20141030195239.GA12768@www.outflux.net> (Kees Cook's message of
	"Thu, 30 Oct 2014 12:52:39 -0700")
Message-ID: <86y4rwwf80.fsf@MJJ-LAPTOP.i-did-not-set--mail-host-address--so-tickle-me>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (windows-nt)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> From: Junjie Mao <eternal.n08@gmail.com>
>
> When choosing a random address, the current implementation does not take into
> account the reversed space for .bss and .brk sections. Thus the relocated kernel
> may overlap other components in memory, e.g. the initrd image:
>
> +-------------------+
> |   decompressed    |
> |      kernel       |
> |   (relocated)     |
> +-------------------+--
> |   relocs table    |  \
> +-------------------+   |
> |                   |   .bss and .brk section
> +-------------------+   |
> |                   |  /
> |      initrd       |--
> |                   |
> +-------------------+
>
> Here is an example of the overlap from a x86_64 kernel in qemu (the ranges of
> physical addresses are presented):
>
> compressed kernel:      [0x0449626e, 0x04e30aa3]
> initrd:                 [0x13ce6000, 0x13fef373]
> relocated kernel:       [0x0fe00000, 0x13c1c2bb]
> .bss and .brk sections: [0x13c1c2bc, 0x148262bb]
>
> The initrd image will then be overwritten by the memset during early
> initialization:
>
> [    1.655204] Unpacking initramfs...
> [    1.662831] Initramfs unpacking failed: junk in compressed archive
>
> This patch prevents the above situation by requiring a larger space when looking
> for a random kernel base, so that existing logic can effectively avoids the
> overlap.
>
> Fixes: 82fa9637a2 ("x86, kaslr: Select random position from e820 maps")
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Junjie Mao <eternal.n08@gmail.com>
> [kees: switched to perl to avoid hex translation pain in mawk vs gawk]
> [kees: calculated overlap without relocs table]
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org
> ---
> Junjie, does this work for you? I switched to Perl to avoid mawk vs gawk
> issues, and based the run size on the actual kernel size, not the kernel
> plus relocation tables, plus added a little more documentation.
>
> Thanks again for tracking this down!

Many thanks for correcting the patch! I've tested the patch with both
i386 and x86_64 build and it works fine!

At the same time, I want to fix the incorrect documentation in my
previous commit log, especially the figure and the memory layout
example. I'll come up with another version of the patch.

Best Regards
Junjie Mao

>
> -Kees
> ---
>  arch/x86/boot/compressed/Makefile  |  4 +++-
>  arch/x86/boot/compressed/head_32.S |  5 +++--
>  arch/x86/boot/compressed/head_64.S |  5 ++++-
>  arch/x86/boot/compressed/misc.c    | 13 ++++++++++---
>  arch/x86/boot/compressed/mkpiggy.c |  9 +++++++--
>  arch/x86/tools/calc_run_size.pl    | 30 ++++++++++++++++++++++++++++++
>  6 files changed, 57 insertions(+), 9 deletions(-)
>  create mode 100644 arch/x86/tools/calc_run_size.pl
>
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index 704f58aa79cd..be1e07d4b596 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -76,8 +76,10 @@ suffix-$(CONFIG_KERNEL_XZ)	:= xz
>  suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
>  suffix-$(CONFIG_KERNEL_LZ4) 	:= lz4
>  
> +RUN_SIZE = $(shell objdump -h vmlinux | \
> +	     perl $(srctree)/arch/x86/tools/calc_run_size.pl)
>  quiet_cmd_mkpiggy = MKPIGGY $@
> -      cmd_mkpiggy = $(obj)/mkpiggy $< > $@ || ( rm -f $@ ; false )
> +      cmd_mkpiggy = $(obj)/mkpiggy $< $(RUN_SIZE) > $@ || ( rm -f $@ ; false )
>  
>  targets += piggy.S
>  $(obj)/piggy.S: $(obj)/vmlinux.bin.$(suffix-y) $(obj)/mkpiggy FORCE
> diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
> index cbed1407a5cd..1d7fbbcc196d 100644
> --- a/arch/x86/boot/compressed/head_32.S
> +++ b/arch/x86/boot/compressed/head_32.S
> @@ -207,7 +207,8 @@ relocated:
>   * Do the decompression, and jump to the new kernel..
>   */
>  				/* push arguments for decompress_kernel: */
> -	pushl	$z_output_len	/* decompressed length */
> +	pushl	$z_run_size	/* size of kernel with .bss and .brk */
> +	pushl	$z_output_len	/* decompressed length, end of relocs */
>  	leal	z_extract_offset_negative(%ebx), %ebp
>  	pushl	%ebp		/* output address */
>  	pushl	$z_input_len	/* input_len */
> @@ -217,7 +218,7 @@ relocated:
>  	pushl	%eax		/* heap area */
>  	pushl	%esi		/* real mode pointer */
>  	call	decompress_kernel /* returns kernel location in %eax */
> -	addl	$24, %esp
> +	addl	$28, %esp
>  
>  /*
>   * Jump to the decompressed kernel.
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index 2884e0c3e8a5..6b1766c6c082 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -402,13 +402,16 @@ relocated:
>   * Do the decompression, and jump to the new kernel..
>   */
>  	pushq	%rsi			/* Save the real mode argument */
> +	movq	$z_run_size, %r9	/* size of kernel with .bss and .brk */
> +	pushq	%r9
>  	movq	%rsi, %rdi		/* real mode address */
>  	leaq	boot_heap(%rip), %rsi	/* malloc area for uncompression */
>  	leaq	input_data(%rip), %rdx  /* input_data */
>  	movl	$z_input_len, %ecx	/* input_len */
>  	movq	%rbp, %r8		/* output target address */
> -	movq	$z_output_len, %r9	/* decompressed length */
> +	movq	$z_output_len, %r9	/* decompressed length, end of relocs */
>  	call	decompress_kernel	/* returns kernel location in %rax */
> +	popq	%r9
>  	popq	%rsi
>  
>  /*
> diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> index 57ab74df7eea..30dd59a9f0b4 100644
> --- a/arch/x86/boot/compressed/misc.c
> +++ b/arch/x86/boot/compressed/misc.c
> @@ -358,7 +358,8 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
>  				  unsigned char *input_data,
>  				  unsigned long input_len,
>  				  unsigned char *output,
> -				  unsigned long output_len)
> +				  unsigned long output_len,
> +				  unsigned long run_size)
>  {
>  	real_mode = rmode;
>  
> @@ -381,8 +382,14 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
>  	free_mem_ptr     = heap;	/* Heap */
>  	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
>  
> -	output = choose_kernel_location(input_data, input_len,
> -					output, output_len);
> +	/*
> +	 * The memory hole needed for the kernel is the larger of either
> +	 * the entire decompressed kernel plus relocation table, or the
> +	 * entire decompressed kernel plus .bss and .brk sections.
> +	 */
> +	output = choose_kernel_location(input_data, input_len, output,
> +					output_len > run_size ? output_len
> +							      : run_size);
>  
>  	/* Validate memory location choices. */
>  	if ((unsigned long)output & (MIN_KERNEL_ALIGN - 1))
> diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
> index b669ab65bf6c..d8222f213182 100644
> --- a/arch/x86/boot/compressed/mkpiggy.c
> +++ b/arch/x86/boot/compressed/mkpiggy.c
> @@ -36,11 +36,13 @@ int main(int argc, char *argv[])
>  	uint32_t olen;
>  	long ilen;
>  	unsigned long offs;
> +	unsigned long run_size;
>  	FILE *f = NULL;
>  	int retval = 1;
>  
> -	if (argc < 2) {
> -		fprintf(stderr, "Usage: %s compressed_file\n", argv[0]);
> +	if (argc < 3) {
> +		fprintf(stderr, "Usage: %s compressed_file run_size\n",
> +				argv[0]);
>  		goto bail;
>  	}
>  
> @@ -74,6 +76,7 @@ int main(int argc, char *argv[])
>  	offs += olen >> 12;	/* Add 8 bytes for each 32K block */
>  	offs += 64*1024 + 128;	/* Add 64K + 128 bytes slack */
>  	offs = (offs+4095) & ~4095; /* Round to a 4K boundary */
> +	run_size = atoi(argv[2]);
>  
>  	printf(".section \".rodata..compressed\",\"a\",@progbits\n");
>  	printf(".globl z_input_len\n");
> @@ -85,6 +88,8 @@ int main(int argc, char *argv[])
>  	/* z_extract_offset_negative allows simplification of head_32.S */
>  	printf(".globl z_extract_offset_negative\n");
>  	printf("z_extract_offset_negative = -0x%lx\n", offs);
> +	printf(".globl z_run_size\n");
> +	printf("z_run_size = %lu\n", run_size);
>  
>  	printf(".globl input_data, input_data_end\n");
>  	printf("input_data:\n");
> diff --git a/arch/x86/tools/calc_run_size.pl b/arch/x86/tools/calc_run_size.pl
> new file mode 100644
> index 000000000000..0b0b124d3ece
> --- /dev/null
> +++ b/arch/x86/tools/calc_run_size.pl
> @@ -0,0 +1,30 @@
> +#!/usr/bin/perl
> +#
> +# Calculate the amount of space needed to run the kernel, including room for
> +# the .bss and .brk sections.
> +#
> +# Usage:
> +# objdump -h a.out | perl calc_run_size.pl
> +use strict;
> +
> +my $mem_size = 0;
> +my $file_offset = 0;
> +
> +my $sections=" *[0-9]+ \.(?:bss|brk) +";
> +while (<>) {
> +	if (/^$sections([0-9a-f]+) +(?:[0-9a-f]+ +){2}([0-9a-f]+)/) {
> +		my $size = hex($1);
> +		my $offset = hex($2);
> +		$mem_size += $size;
> +		if ($file_offset == 0) {
> +			$file_offset = $offset;
> +		} elsif ($file_offset != $offset) {
> +			die ".bss and .brk lack common file offset\n";
> +		}
> +	}
> +}
> +
> +if ($file_offset == 0) {
> +	die "Never found .bss or .brk file offset\n";
> +}
> +printf("%d\n", $mem_size + $file_offset);
> -- 
> 1.9.1
