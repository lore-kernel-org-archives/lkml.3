Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab3LEO3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:29:24 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:46566 "EHLO
	highbank-bc01-b06.austin.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752266Ab3LEO3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:29:20 -0500
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Dec 2013 09:29:20 EST
Date: Thu, 5 Dec 2013 14:18:53 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>
Subject: Re: [PATCH 1/3] arm64: add EFI stub
Message-ID: <20131205141853.GA974@darko.cambridge.arm.com>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
 <1385762712-17043-2-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385762712-17043-2-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Nov 29, 2013 at 10:05:10PM +0000, Mark Salter wrote:
> This patch adds PE/COFF header fields to the start of the Image
> so that it appears as an EFI application to EFI firmware. An EFI
> stub is included to allow direct booting of the kernel Image. Due
> to EFI firmware limitations, only little endian kernels with 4K
> page sizes are supported at this time.

I don't fully understand the EFI firmware limitations but for big endian
we could have the EFI_STUB wrapper in little endian and get the kernel
to switch to big endian once booted. The image header should always be
little endian.

And I have to dig further into the 4K limitation (or you could give a
quick summary ;)).

> diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
> new file mode 100644
> index 0000000..5f6d179
> --- /dev/null
> +++ b/arch/arm64/kernel/efi-entry.S
> @@ -0,0 +1,81 @@
> +/*
> + * EFI entry point.
> + *
> + * Copyright (C) 2013 Red Hat, Inc.
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

It's defined already but I see why you can't include efi.h here. Maybe a
comment.

> +
> +       __INIT
> +
> +       /*
> +        * We arrive here from the EFI boot manager with:
> +        *
> +        *    * MMU on with identity-mapped RAM.
> +        *    * Icache and Dcache on
> +        *
> +        * We will most likely be running from some place other than where
> +        * we want to be. The kernel image wants to be placed at TEXT_OFFSET
> +        * from start of RAM.
> +        */
> +ENTRY(efi_stub_entry)
> +       stp     x29, x30, [sp, #-32]!
> +
> +       /*
> +        * Call efi_entry to do the real work.
> +        * x0 and x1 are already set up by firmware. Current runtime
> +        * address of image is calculated and passed via *image_addr.
> +        *
> +        * unsigned long efi_entry(void *handle,
> +        *                         efi_system_table_t *sys_table,
> +        *                         unsigned long *image_addr) ;
> +        */
> +       adrp    x8, _text
> +        add    x8, x8, #:lo12:_text

Minor: some wrong whitespace (but I don't trust our incoming mail server
either, it corrupts patches usually).

> +       add     x2, sp, 16
> +       str     x8, [x2]
> +       bl      efi_entry
> +       cmn     x0, #1
> +       b.eq    efi_load_fail
> +
> +       /*
> +        * efi_entry() will have relocated the kernel image if necessary
> +        * and we return here with device tree address in x0 and the kernel
> +        * entry point stored at *image_addr. Save those values in registers
> +        * which are preserved by __flush_dcache_all.
> +        */
> +       ldr     x1, [sp, #16]
> +       mov     x20, x0
> +       mov     x21, x1
> +
> +       bl      __flush_dcache_all

Regarding __flush_dcache_all, I plan to remove it for all cases apart
from power management with the MMU disabled. With MMU enabled, there is
no guarantee that this function does the right thing. It's even worse in
the guest context.

> +       /* Turn off Dcache and MMU */
> +       mrs     x0, sctlr_el1
> +       bic     x0, x0, #1 << 0 // clear SCTLR.M
> +       bic     x0, x0, #1 << 2 // clear SCTLR.C
> +       msr     sctlr_el1, x0
> +       isb

I assume an EFI app is running with the MMU enabled (and UP only). Do we
always run it in EL1? What about EL2 mode (needed by KVM and Xen)?

> +
> +       /* Jump to real entry point */
> +       mov     x0, x20
> +       mov     x1, xzr
> +       mov     x2, xzr
> +       mov     x3, xzr
> +       br      x21
> +
> +efi_load_fail:
> +       mov     x0, EFI_LOAD_ERROR

Needs #EFI_LOAD_ERROR (strange that gas doesn't complain).

> +       ldp     x29, x30, [sp], #32
> +       ret
> +
> +ENDPROC(efi_stub_entry)
> diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
> new file mode 100644
> index 0000000..f000b04
> --- /dev/null
> +++ b/arch/arm64/kernel/efi-stub.c
> @@ -0,0 +1,280 @@
> +/*
> + * linux/arch/arm/boot/compressed/efi-stub.c
> + *
> + * Copyright (C) 2013 Linaro Ltd;  <roy.franz@linaro.org>
> + *
> + * This file implements the EFI boot stub for the arm64 kernel.
> + * Adapted from ARM version by Mark Salter <msalter@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +#include <linux/efi.h>
> +#include <linux/libfdt.h>
> +#include <asm/sections.h>
> +#include <generated/compile.h>
> +#include <linux/uts.h>
> +#include <linux/utsname.h>
> +#include <generated/utsrelease.h>
> +#include <linux/version.h>
> +
> +/* error code which can't be mistaken for valid address */
> +#define EFI_ERROR      (~0UL)
> +
> +/*
> + * EFI function call wrappers. These are not required for arm64, but wrappers
> + * are required for X86 to convert between ABIs. These wrappers are provided
> + * to allow code sharing between X86 and other architectures. Since these
> + * wrappers directly invoke the EFI function pointer, the function pointer
> + * type must be properly defined, which is not the case for X86. One advantage
> + * of this is it allows for type checking of arguments, which is not possible
> + * with the X86 wrappers.
> + */
> +#define efi_call_phys0(f)                      f()
> +#define efi_call_phys1(f, a1)                  f(a1)
> +#define efi_call_phys2(f, a1, a2)              f(a1, a2)
> +#define efi_call_phys3(f, a1, a2, a3)          f(a1, a2, a3)
> +#define efi_call_phys4(f, a1, a2, a3, a4)      f(a1, a2, a3, a4)
> +#define efi_call_phys5(f, a1, a2, a3, a4, a5)  f(a1, a2, a3, a4, a5)
> +
> +/*
> + * AArch64 requires the DTB to be 8-byte aligned in the first 512MiB from
> + * start of kernel and may not cross a 2MiB boundary. We set alignment to
> + * equal max size so we know it won't cross a 2MiB boudary.
> + */
> +#define MAX_DTB_SIZE   0x40000

2MB is 0x200000 (or I don't understand the comment).

> +#define DTB_ALIGN      MAX_DTB_SIZE
> +#define MAX_DTB_OFFSET 0x20000000
> +
> +#define pr_efi(msg)     efi_printk(sys_table, "EFI stub: "msg)
> +#define pr_efi_err(msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
> +
> +struct fdt_region {
> +       u64 base;
> +       u64 size;
> +};
> +
> +/* Include shared EFI stub code */
> +#include "../../../drivers/firmware/efi/efi-stub-helper.c"
> +#include "../../../drivers/firmware/efi/fdt.c"

I don't particularly like .c files inclusion but it looks like x86 does
the same.

> +
> +static unsigned long __init get_dram_base(efi_system_table_t *sys_table)
> +{
> +       efi_status_t status;
> +       unsigned long map_size, desc_size;
> +       unsigned long membase = EFI_ERROR;
> +       efi_memory_desc_t *memory_map;
> +       int i;
> +
> +       status = efi_get_memory_map(sys_table, &memory_map, &map_size,
> +                                   &desc_size, NULL, NULL);
> +       if (status == EFI_SUCCESS) {

Can you exit earlier here if !EFI_SUCCESS? It reduces the indentation
level.

-- 
Catalin
