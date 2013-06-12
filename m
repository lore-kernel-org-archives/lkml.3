Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab3FLSNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:13:18 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:39484 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3FLSNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:13:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130611185846.GA23707@www.outflux.net>
References: <20130611185846.GA23707@www.outflux.net>
Date: Wed, 12 Jun 2013 11:13:16 -0700
X-Google-Sender-Auth: nuxt_as5Rwhk3KxyxzmsLCciOTU
Message-ID: <CAE9FiQXgO+yScU2cBazJtX2mFHRMv=wObrTjpFvW5ajFNjBvCA@mail.gmail.com>
Subject: Re: [PATCH] x86, relocs: move ELF relocation handling to C
From: Yinghai Lu <yinghai@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 11:58 AM, Kees Cook <keescook@chromium.org> wrote:
> Moves the relocation handling into C, after decompression. This requires
> that the decompressed size is passed to the decompression routine as
> well so that relocations can be found. Only kernels that need relocation
> support will use the code.
>
> Based on work by Neill Clift and Michael Davidson.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/Kconfig                     |    4 +-
>  arch/x86/Makefile                    |    8 ++--
>  arch/x86/boot/compressed/head_32.S   |   31 ++------------
>  arch/x86/boot/compressed/head_64.S   |    1 +
>  arch/x86/boot/compressed/misc.c      |   77 +++++++++++++++++++++++++++++++++-
>  arch/x86/include/asm/page_32_types.h |    2 +
>  arch/x86/include/asm/page_64_types.h |    5 ---
>  arch/x86/include/asm/page_types.h    |    6 +++
>  8 files changed, 94 insertions(+), 40 deletions(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 685692c..b4797b9 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1695,13 +1695,13 @@ config RELOCATABLE
>           it has been loaded at and the compile time physical address
>           (CONFIG_PHYSICAL_START) is ignored.
>
> -# Relocation on x86-32 needs some additional build support
> +# Relocation on x86 needs some additional build support
>  config X86_NEED_RELOCS
>         def_bool y
>         depends on X86_32 && RELOCATABLE
>
>  config PHYSICAL_ALIGN
> -       hex "Alignment value to which kernel should be aligned" if X86_32
> +       hex "Alignment value to which kernel should be aligned"
>         default "0x1000000"
>         range 0x2000 0x1000000
>         ---help---
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 5c47726..43f8cef 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -16,6 +16,10 @@ endif
>  # e.g.: obj-y += foo_$(BITS).o
>  export BITS
>
> +ifdef CONFIG_X86_NEED_RELOCS
> +        LDFLAGS_vmlinux := --emit-relocs
> +endif
> +
>  ifeq ($(CONFIG_X86_32),y)
>          BITS := 32
>          UTS_MACHINE := i386
> @@ -25,10 +29,6 @@ ifeq ($(CONFIG_X86_32),y)
>          KBUILD_AFLAGS += $(biarch)
>          KBUILD_CFLAGS += $(biarch)
>
> -        ifdef CONFIG_RELOCATABLE
> -                LDFLAGS_vmlinux := --emit-relocs
> -        endif
> -
>          KBUILD_CFLAGS += -msoft-float -mregparm=3 -freg-struct-return
>
>          # Never want PIC in a 32-bit kernel, prevent breakage with GCC built
> diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
> index 1e3184f..5d6f689 100644
> --- a/arch/x86/boot/compressed/head_32.S
> +++ b/arch/x86/boot/compressed/head_32.S
> @@ -181,8 +181,9 @@ relocated:
>  /*
>   * Do the decompression, and jump to the new kernel..
>   */
> -       leal    z_extract_offset_negative(%ebx), %ebp
>                                 /* push arguments for decompress_kernel: */
> +       pushl   $z_output_len   /* decompressed length */
> +       leal    z_extract_offset_negative(%ebx), %ebp
>         pushl   %ebp            /* output address */
>         pushl   $z_input_len    /* input_len */
>         leal    input_data(%ebx), %eax
> @@ -191,33 +192,7 @@ relocated:
>         pushl   %eax            /* heap area */
>         pushl   %esi            /* real mode pointer */
>         call    decompress_kernel
> -       addl    $20, %esp
> -
> -#if CONFIG_RELOCATABLE
> -/*
> - * Find the address of the relocations.
> - */
> -       leal    z_output_len(%ebp), %edi
> -
> -/*
> - * Calculate the delta between where vmlinux was compiled to run
> - * and where it was actually loaded.
> - */
> -       movl    %ebp, %ebx
> -       subl    $LOAD_PHYSICAL_ADDR, %ebx
> -       jz      2f      /* Nothing to be done if loaded at compiled addr. */
> -/*
> - * Process relocations.
> - */
> -
> -1:     subl    $4, %edi
> -       movl    (%edi), %ecx
> -       testl   %ecx, %ecx
> -       jz      2f
> -       addl    %ebx, -__PAGE_OFFSET(%ebx, %ecx)
> -       jmp     1b
> -2:
> -#endif
> +       addl    $24, %esp
>
>  /*
>   * Jump to the decompressed kernel.
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index 16f24e6..6632693 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -340,6 +340,7 @@ relocated:
>         leaq    input_data(%rip), %rdx  /* input_data */
>         movl    $z_input_len, %ecx      /* input_len */
>         movq    %rbp, %r8               /* output target address */
> +       movq    $z_output_len, %r9      /* decompressed length */
>         call    decompress_kernel
>         popq    %rsi
>
> diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> index 7cb56c6..b756a04 100644
> --- a/arch/x86/boot/compressed/misc.c
> +++ b/arch/x86/boot/compressed/misc.c
> @@ -267,6 +267,79 @@ static void error(char *x)
>                 asm("hlt");
>  }
>
> +#if CONFIG_X86_NEED_RELOCS
> +static void handle_relocations(void *output, unsigned long output_len)
> +{
> +       int *reloc;
> +       unsigned long delta, map, ptr;
> +       unsigned long min_addr = (unsigned long)output;
> +       unsigned long max_addr = min_addr + output_len;
> +
> +       /*
> +        * Calculate the delta between where vmlinux was linked to load
> +        * and where it was actually loaded.
> +        */
> +       delta = min_addr - LOAD_PHYSICAL_ADDR;
> +       if (!delta) {
> +               debug_putstr("No relocation needed... ");
> +               return;
> +       }
> +       debug_putstr("Performing relocations... ");
> +
> +       /*
> +        * The kernel contains a table of relocation addresses. Those
> +        * addresses have the final load address of the kernel in virtual
> +        * memory. We are currently working in the self map. So we need to
> +        * create an adjustment for kernel memory addresses to the self map.
> +        * This will involve subtracting out the base address of the kernel.
> +        */
> +       map = delta - __START_KERNEL_map;
> +
> +       /*
> +        * Process relocations: 32 bit relocations first then 64 bit after.
> +        * Two sets of binary relocations are added to the end of the kernel
> +        * before compression. Each relocation table entry is the kernel
> +        * address of the location which needs to be updated stored as a
> +        * 32-bit value which is sign extended to 64 bits.
> +        *
> +        * Format is:
> +        *
> +        * kernel bits...
> +        * 0 - zero terminator for 64 bit relocations
> +        * 64 bit relocation repeated
> +        * 0 - zero terminator for 32 bit relocations
> +        * 32 bit relocation repeated
> +        *
> +        * So we work backwards from the end of the decompressed image.
> +        */
> +       for (reloc = output + output_len - sizeof(*reloc); *reloc; reloc--) {
> +               int extended = *reloc;
> +               extended += map;
> +
> +               ptr = (unsigned long)extended;
> +               if (ptr < min_addr || ptr > max_addr)
> +                       error("32-bit relocation outside of kernel!\n");
> +
> +               *(uint32_t *)ptr += delta;
> +       }
> +#ifdef CONFIG_X86_64
> +       for (reloc--; *reloc; reloc--) {
> +               long extended = *reloc;
> +               extended += map;
> +
> +               ptr = (unsigned long)extended;
> +               if (ptr < min_addr || ptr > max_addr)
> +                       error("64-bit relocation outside of kernel!\n");
> +
> +               *(uint64_t *)ptr += delta;
> +       }
> +#endif

it seems those lines for x86_64 are never used.
as X86_NEED_RELOCS is not defined for x86_64

>  config X86_NEED_RELOCS
>         def_bool y
>         depends on X86_32 && RELOCATABLE


> +}
> +#else
> +static inline void handle_relocations(void *output, unsigned long output_len)
> +{ }
> +#endif

Can you make it clear that this patch only affect x86_32 in patch title?

Yinghai
