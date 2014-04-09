Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582AbaDIOU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:20:56 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52710 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932866AbaDIOUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:20:54 -0400
Date: Wed, 9 Apr 2014 15:20:13 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v3 06/10] arm64: efi: add EFI stub
Message-ID: <20140409142013.GC26210@e106331-lin.cambridge.arm.com>
References: <1396637113-22790-1-git-send-email-leif.lindholm@linaro.org>
 <1396637113-22790-7-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396637113-22790-7-git-send-email-leif.lindholm@linaro.org>
Thread-Topic: [PATCH v3 06/10] arm64: efi: add EFI stub
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leif,

On Fri, Apr 04, 2014 at 07:45:09PM +0100, Leif Lindholm wrote:
> From: Mark Salter <msalter@redhat.com>
>
> This patch adds PE/COFF header fields to the start of the Image
> so that it appears as an EFI application to EFI firmware. An EFI
> stub is included to allow direct booting of the kernel Image.
> Support in the COFF header for signed images was provided by
> Ard Biesheuvel.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Mark Salter <msalter@redhat.com>
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/arm64/Kconfig              |   14 +++
>  arch/arm64/kernel/Makefile      |    3 +
>  arch/arm64/kernel/efi-entry.S   |  100 ++++++++++++++++
>  arch/arm64/kernel/efi-stub.c    |   97 +++++++++++++++
>  arch/arm64/kernel/head.S        |  112 ++++++++++++++++++
>  drivers/firmware/efi/arm-stub.c |  248 +++++++++++++++++++++++++++++++++++++++
>  6 files changed, 574 insertions(+)
>  create mode 100644 arch/arm64/kernel/efi-entry.S
>  create mode 100644 arch/arm64/kernel/efi-stub.c
>  create mode 100644 drivers/firmware/efi/arm-stub.c
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index d9f23ad..791ec61 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -280,6 +280,20 @@ config CMDLINE_FORCE
>           This is useful if you cannot or don't want to change the
>           command-line options your boot loader passes to the kernel.
>
> +config EFI
> +       bool "UEFI firmware support"
> +       depends on OF

I note we're not depending on !CPU_BIG_ENDIAN here, and it looks like
the implementation is not endian-clean (I've pointed out a few issues
below).

We need to fix that up for CPU_BIG_ENDIAN. For the moment we could
depend on !CPU_BIG_ENDIAN which would at least to make it clear we don't
support EFI && CPU_BIG_ENDIAN yet. The commit message should be updated
to mention that.

[...]

> diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
> new file mode 100644
> index 0000000..d99a034e
> --- /dev/null
> +++ b/arch/arm64/kernel/efi-entry.S
> @@ -0,0 +1,100 @@
> +/*
> + * EFI entry point.
> + *
> + * Copyright (C) 2013, 2014 Red Hat, Inc.
> + * Author: Mark Salter <msalter@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +#include <linux/linkage.h>
> +#include <linux/init.h>
> +
> +#include <asm/assembler.h>
> +
> +#define EFI_LOAD_ERROR 0x8000000000000001
> +
> +       __INIT
> +
> +       /*
> +        * We arrive here from the EFI boot manager with:
> +        *
> +        *    * MMU on with identity-mapped RAM.
> +        *    * Icache and Dcache on

I assume we always enter with the CPU in little-endian mode? It would be
nice to note that here if so, or otherwise if not

> +        *
> +        * We will most likely be running from some place other than where
> +        * we want to be. The kernel image wants to be placed at TEXT_OFFSET
> +        * from start of RAM.
> +        */
> +ENTRY(efi_stub_entry)
> +       stp     x29, x30, [sp, #-32]!

A comment as to what the additional space is for would be nice. It seems
to be the relocated kernel address and padding for the required
alignment?

[...]

> +/*
> + * AArch64 requires the DTB to be 8-byte aligned in the first 512MiB from
> + * start of kernel and may not cross a 2MiB boundary. We set alignment to
> + * 2MiB so we know it won't cross a 2MiB boundary.
> + */

Nit: the booting documentation is poor here, but the actual requirement
is slightly different than that described. We currently need the DTB to
be within the same naturally-aligned 512 MiB region as the kernel,
though that restriction could be lifted with some rework of the initial
page tables.

[...]

>From here on in, all comments are regarding endianness issues and how we
can fix them. If you do not care about BE, stop reading here. ;)

> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 1fe5d8d..2aee658 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -107,8 +107,18 @@
>         /*
>          * DO NOT MODIFY. Image header expected by Linux boot-loaders.
>          */
> +#ifdef CONFIG_EFI
> +       /*
> +        * Magic "MZ" signature for PE/COFF
> +        * Little Endian:  add x13, x18, #0x16
> +        */
> +efi_head:
> +       .long   0x91005a4d

As .long will emit the value in native endianness, this will only work
for LE kernels. In BE this will be backwards (which looks to be an
undefined instruction).

> +       b       stext
> +#else
>         b       stext                           // branch to kernel start, magic
>         .long   0                               // reserved
> +#endif
>         .quad   TEXT_OFFSET                     // Image load offset from start of RAM

This also needs to be fixed up endianness wise; I have a series for that
which I'll post shortly.

>         .quad   0                               // reserved
>         .quad   0                               // reserved
> @@ -119,7 +129,109 @@
>         .byte   0x52
>         .byte   0x4d
>         .byte   0x64
> +#ifdef CONFIG_EFI
> +       .long   pe_header - efi_head            // Offset to the PE header.

Likewise this will be backwards. Unfortunately values derived from
calculations involving symbols can't be endian-swapped here due to lack
of a suitable relocation -- we'll have to get the linker to do the
endianness swap for us.

I have a patch enabling the linker to endian-swap such values for us for
64-bit values, but it looks like we'll need other sizes too (for the
shorts below). To prevent vast swathes of symbols appearing in the main
linker script we could have a header to gather those into a
FIXED_ENDIAN_SYMBOLS macro or similar.

> +#else
>         .word   0                               // reserved
> +#endif
> +
> +#ifdef CONFIG_EFI
> +       .align 3
> +pe_header:
> +       .ascii  "PE"
> +       .short  0
> +coff_header:
> +       .short  0xaa64                          // AArch64
> +       .short  2                               // nr_sections
> +       .long   0                               // TimeDateStamp
> +       .long   0                               // PointerToSymbolTable
> +       .long   1                               // NumberOfSymbols

Everything here but the string will be the wrong way around on BE.

We could add .{short,int,long}_le macros to do the endianness swapping
of these values for us (which would also help to document the
endianness).

All other uses of {short,int,long} for non-zero values will need
endianness correction.

> +       .short  section_table - optional_header // SizeOfOptionalHeader

This might need the linker's help to swap unless the assembler resolves
the difference at assemble time.

> +       .long   efi_stub_entry - efi_head       // AddressOfEntryPoint
> +       .long   stext - efi_head                // BaseOfCode

Likewise.

> +       .long   _edata - efi_head               // SizeOfImage

This will definitely require the help of the linker for endianness
swapping.

> +       // Everything before the kernel image is considered part of the header
> +       .long   stext - efi_head                        // SizeOfHeaders

And this.

[...]

> +       .long   _edata - stext          // VirtualSize
> +       .long   stext - efi_head        // VirtualAddress
> +       .long   _edata - stext          // SizeOfRawData
> +       .long   stext - efi_head        // PointerToRawData

And these.

Cheers,
Mark.
