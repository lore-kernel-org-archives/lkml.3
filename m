Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbaCRMJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:09:50 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:23252 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751184AbaCRMJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:09:48 -0400
Date: Tue, 18 Mar 2014 12:09:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 11/15] arm64: add EFI stub
Message-ID: <20140318120919.GG13200@arm.com>
References: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
 <1394750828-16351-12-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394750828-16351-12-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 10:47:04PM +0000, Leif Lindholm wrote:
> --- /dev/null
> +++ b/arch/arm64/kernel/efi-entry.S
> @@ -0,0 +1,93 @@
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
> +       add     x8, x8, #:lo12:_text
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
> +       /* Turn off Dcache and MMU */
> +       mrs     x0, CurrentEL
> +       cmp     x0, #PSR_MODE_EL2t
> +       ccmp    x0, #PSR_MODE_EL2h, #0x4, ne
> +       b.ne    1f
> +       mrs     x0, sctlr_el2
> +       bic     x0, x0, #1 << 0 // clear SCTLR.M
> +       bic     x0, x0, #1 << 2 // clear SCTLR.C
> +       msr     sctlr_el2, x0
> +       isb
> +       b       2f
> +1:
> +       mrs     x0, sctlr_el1
> +       bic     x0, x0, #1 << 0 // clear SCTLR.M
> +       bic     x0, x0, #1 << 2 // clear SCTLR.C
> +       msr     sctlr_el1, x0
> +       isb
> +2:
> +       bl      __flush_dcache_all

In linux-next I'm pushing a patch which no longer exports the
__flush_dcache_all function. The reason is that it doesn't really work
if you have a (not fully transparent) external cache like on the Applied
Micro boards. There other issues when running as a guest as well.

If you know exactly what needs to be flushed here, can you use a range
(MVA) operation?

> diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
> new file mode 100644
> index 0000000..bf30913
> --- /dev/null
> +++ b/arch/arm64/kernel/efi-stub.c
> @@ -0,0 +1,83 @@
> +/*
> + * linux/arch/arm/boot/compressed/efi-stub.c

Nitpick: arch/arm64/... But we don't really need to write the file name
here, I use a smart editor that tells me which file I'm viewing ;).
Better write a one-line summary of what this file is about.

> + *
> + * Copyright (C) 2013, 2014 Linaro Ltd;  <roy.franz@linaro.org>
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
> +#include <generated/utsrelease.h>
> +
> +/*
> + * EFI function call wrappers. These are not required for arm/arm64, but
> + * wrappers are required for X86 to convert between ABIs. These wrappers are
> + * provided to allow code sharing between X86 and other architectures. Since
> + * these wrappers directly invoke the EFI function pointer, the function
> + * pointer type must be properly defined, which is not the case for X86. One
> + * advantage of this is it allows for type checking of arguments, which is not
> + * possible with the X86 wrappers.
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
> + * 2MiB so we know it won't cross a 2MiB boundary.
> + */
> +#define EFI_FDT_ALIGN  SZ_2M   /* used by allocate_new_fdt_and_exit_boot() */
> +#define MAX_FDT_OFFSET SZ_512M
> +
> +/* Include shared EFI stub code */
> +#include "../../../drivers/firmware/efi/efi-stub-helper.c"

It looks like this is done by x86 as well.

> +#include "../../../drivers/firmware/efi/fdt.c"
> +#include "../../../drivers/firmware/efi/arm-stub.c"

But why do we need to create more stuff like this? Is it because on arm
we need this as part of the decompressor (which would be a good enough
argument)?

-- 
Catalin
