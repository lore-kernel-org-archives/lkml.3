Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbaCRVse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:48:34 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:34476 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaCRVsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:48:31 -0400
MIME-Version: 1.0
In-Reply-To: <1395178831.2967.29.camel@deneb.redhat.com>
References: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
	<1394750828-16351-12-git-send-email-leif.lindholm@linaro.org>
	<20140318120919.GG13200@arm.com>
	<1395153629.2967.10.camel@deneb.redhat.com>
	<20140318182826.GC20497@arm.com>
	<1395178831.2967.29.camel@deneb.redhat.com>
Date: Tue, 18 Mar 2014 14:48:30 -0700
Message-ID: <CAFECyb_NuHBQD3zPouDde3WTyz8RrUu1OWFOt6VWX_U5n1g8MA@mail.gmail.com>
Subject: Re: [PATCH v2 11/15] arm64: add EFI stub
From: Roy Franz <roy.franz@linaro.org>
To: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 2:40 PM, Mark Salter <msalter@redhat.com> wrote:
> On Tue, 2014-03-18 at 18:28 +0000, Catalin Marinas wrote:
>> On Tue, Mar 18, 2014 at 02:40:29PM +0000, Mark Salter wrote:
>> > On Tue, 2014-03-18 at 12:09 +0000, Catalin Marinas wrote:
>> > > On Thu, Mar 13, 2014 at 10:47:04PM +0000, Leif Lindholm wrote:
>> > > > --- /dev/null
>> > > > +++ b/arch/arm64/kernel/efi-entry.S
>> > > > @@ -0,0 +1,93 @@
>> > > > +/*
>> > > > + * EFI entry point.
>> > > > + *
>> > > > + * Copyright (C) 2013 Red Hat, Inc.
>> > > > + * Author: Mark Salter <msalter@redhat.com>
>> > > > + *
>> > > > + * This program is free software; you can redistribute it and/or modify
>> > > > + * it under the terms of the GNU General Public License version 2 as
>> > > > + * published by the Free Software Foundation.
>> > > > + *
>> > > > + */
>> > > > +#include <linux/linkage.h>
>> > > > +#include <linux/init.h>
>> > > > +
>> > > > +#include <asm/assembler.h>
>> > > > +
>> > > > +#define EFI_LOAD_ERROR 0x8000000000000001
>> > > > +
>> > > > +       __INIT
>> > > > +
>> > > > +       /*
>> > > > +        * We arrive here from the EFI boot manager with:
>> > > > +        *
>> > > > +        *    * MMU on with identity-mapped RAM.
>> > > > +        *    * Icache and Dcache on
>> > > > +        *
>> > > > +        * We will most likely be running from some place other than where
>> > > > +        * we want to be. The kernel image wants to be placed at TEXT_OFFSET
>> > > > +        * from start of RAM.
>> > > > +        */
>> > > > +ENTRY(efi_stub_entry)
>> > > > +       stp     x29, x30, [sp, #-32]!
>> > > > +
>> > > > +       /*
>> > > > +        * Call efi_entry to do the real work.
>> > > > +        * x0 and x1 are already set up by firmware. Current runtime
>> > > > +        * address of image is calculated and passed via *image_addr.
>> > > > +        *
>> > > > +        * unsigned long efi_entry(void *handle,
>> > > > +        *                         efi_system_table_t *sys_table,
>> > > > +        *                         unsigned long *image_addr) ;
>> > > > +        */
>> > > > +       adrp    x8, _text
>> > > > +       add     x8, x8, #:lo12:_text
>> > > > +       add     x2, sp, 16
>> > > > +       str     x8, [x2]
>> > > > +       bl      efi_entry
>> > > > +       cmn     x0, #1
>> > > > +       b.eq    efi_load_fail
>> > > > +
>> > > > +       /*
>> > > > +        * efi_entry() will have relocated the kernel image if necessary
>> > > > +        * and we return here with device tree address in x0 and the kernel
>> > > > +        * entry point stored at *image_addr. Save those values in registers
>> > > > +        * which are preserved by __flush_dcache_all.
>> > > > +        */
>> > > > +       ldr     x1, [sp, #16]
>> > > > +       mov     x20, x0
>> > > > +       mov     x21, x1
>> > > > +
>> > > > +       /* Turn off Dcache and MMU */
>> > > > +       mrs     x0, CurrentEL
>> > > > +       cmp     x0, #PSR_MODE_EL2t
>> > > > +       ccmp    x0, #PSR_MODE_EL2h, #0x4, ne
>> > > > +       b.ne    1f
>> > > > +       mrs     x0, sctlr_el2
>> > > > +       bic     x0, x0, #1 << 0 // clear SCTLR.M
>> > > > +       bic     x0, x0, #1 << 2 // clear SCTLR.C
>> > > > +       msr     sctlr_el2, x0
>> > > > +       isb
>> > > > +       b       2f
>> > > > +1:
>> > > > +       mrs     x0, sctlr_el1
>> > > > +       bic     x0, x0, #1 << 0 // clear SCTLR.M
>> > > > +       bic     x0, x0, #1 << 2 // clear SCTLR.C
>> > > > +       msr     sctlr_el1, x0
>> > > > +       isb
>> > > > +2:
>> > > > +       bl      __flush_dcache_all
>> > >
>> > > In linux-next I'm pushing a patch which no longer exports the
>> > > __flush_dcache_all function. The reason is that it doesn't really work
>> > > if you have a (not fully transparent) external cache like on the Applied
>> > > Micro boards. There other issues when running as a guest as well.
>> > >
>> > > If you know exactly what needs to be flushed here, can you use a range
>> > > (MVA) operation?
>> >
>> > This is just before the EFI stub jumps to kernel proper. The only things
>> > in the dcache would be from identity mapped references to RAM used by
>> > UEFI. The booting.txt doc says dcache should be off and invalidated. I
>> > am just wanting to comply with that. The code here doesn't really know
>> > the extent of DRAM to flush by address.
>>
>> Does UEFI do anything with the caches before invoking the EFI_STUB code?
>> I guess it doesn't since that's just another application for it. Can
>> UEFI flush the caches via exit boot? When is this called?
>>
>> As I said, we have a real problem here since the EFI_STUB call does not
>> have information about the SoC to be able to flush all the caches. But
>> UEFI should know more about the hardware.
>>
>> If UEFI doesn't handle the caches, the only thing left to EFI_STUB is to
>> flush by MVA. We don't need to flush the whole DRAM (and I would even
>> recommend it) but at least the relevant kernel code/data touched with
>> the MMU disabled.
>>
>
> So, it goes like this:
>
>   1) UEFI calls stub with MMU/Caches on. Stub/kernel can be anywhere.
>   2) Stub runs and relocates kernel to the desired runtime location
>      but continues to execute from wherever UEFI loaded it until just
>      after ExitBootServices().
>   3) After ExitBootServices, efi_entry() returns relocated entry point
>      for kernel to efi_stub_entry() in efi-entry.S where the Dcache and
>      MMU are turned off, the __flush_dcache_all is called, then the
>      code jumps to the kernel proper entry point.
>
> It isn't clear to me if UEFI does cache flushing at ExitBootServices
> time, but even so, at least stack use will get cached between then and
> the kernel entry point. The stub could conceivably get its hands on the
> EFI memmap and invalidate dcache using address ranges from UEFI memory
> descriptors so maybe that is the way we should do it.
>

I looked at the UEFI spec and there is no mention of cache flushing in
ExitBootServices(),
so it seems it is up to the OS to do any cache management.

Roy
