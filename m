Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181Ab3LBVHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:07:51 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:54462 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759120Ab3LBVHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:07:10 -0500
Date: Mon, 2 Dec 2013 22:07:20 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Matt Sealey <neko@bakuhatsu.net>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, matt.fleming@intel.com,
        Grant Likely <grant.likely@linaro.org>, roy.franz@linaro.org,
        msalter@redhat.com, Patch Tracking <patches@linaro.org>,
        linaro-uefi@lists.linaro.org, Mark Rutland <mark.rutland@arm.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 1/3] Documentation: arm: add UEFI support documentation
Message-ID: <20131202210719.GQ24997@rocoto.smurfnet.nu>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
 <1385656883-4420-2-git-send-email-leif.lindholm@linaro.org>
 <CAHCPf3t5dEzVWbYZ6DWcFCENNO2dbrx-YeZvKRk0MkEsJMTE3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCPf3t5dEzVWbYZ6DWcFCENNO2dbrx-YeZvKRk0MkEsJMTE3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 01:51:22PM -0600, Matt Sealey wrote:
> Here's where I think this whole thing falls down as being the weirdest
> possible implementation of this. It defies logic to put this
> information in the device tree /chosen node while also attempting to
> boot the kernel using an EFI stub; the stub is going to have this
> information because it is going to have the pointer to the system
> System Table (since it was called by StartImage()). Why not stash the
> System Table pointer somewhere safe in the stub?

We do. In the DT.

> The information in the device tree is all accessible from Boot
> Services and as long as the System Table isn't being thrown away (my
> suggestion would be.. stuff it in r2, and set r1 = "EFI\0" then work
> with arch/arm/kernel/head{-common,}.S code to do the right thing)

You left out the bit of redefining the kernel boot protocol to permit
calling it with caches, MMU and interrupts enabled - also known as
before ExitBootServices().

> It seems like the advantages of booting from UEFI and having all this
> information and API around are being thrown away very early, and
> picked up when it's no longer relevant to gain access to the very
> minimal runtime services. What's missing is a UUID for a "Device Tree
> Blob" in the Configuration Table, so you can very easily go grab that
> information from the firmware.

Which is what we are going to implement anyway in order to permit
firmware to supply DT hardware description in the same way as with
ACPI. Yes, we could pass the system table pointer directly - but that
doesn't get us the memory map.

> As implemented, these patches employ a very long-winded and complex
> method of recovering UEFI after throwing the system table pointer away
> early in boot, and then implements an EFI calling convention which
> isn't strictly necessary according to the UEFI spec - the question is,
> is this a workaround for SetVirtualAddressMap() not actually doing the
> right thing on ARM UEFI implementations? If you can't guarantee that
> most of the calls from Boot Services or Runtime Services are going to
> allow this, then having any UEFI support in the kernel at all seems
> rather weird.

No, it is a workaround for it being explicitly against the kernel boot
protocol (not to mention slightly hairy) to enter head.S with MMU and
caches enabled and interrupts firing.

The EFI calling convention (as pointed out in the patch itself) is
there in order to not have to duplicate code already there for x86.

> What I'm worried about is that this is basically a hack to try and
> shoehorn an existing UEFI implementation to an existing Linux boot
> method - and implements it in a way nobody is ever going to be able to
> justify improving. Part of the reason the OpenFirmware CIF got thrown
> away early in SPARC/PowerPC boot (after "flattening" the device tree
> using the CIF calls to parse it out) was because you had to disable
> the MMU, caches, interrupts etc. which caused all kinds of slow
> firmware code to be all kinds of extra-slow.

I prefer to see it as a way to not reinvent things that do not need
reinventing, while not adding more special-case code to the kernel.

> What that meant is nobody bothered to implement working, re-entrant,
> re-locatable firmware to a great degree. This ended up being a
> self-fulfilling prophecy of "don't trust the bootloader" and "get rid
> of it as soon as we can," which essentially meant Linux never took
> advantage of the resources available. In OF's case, the CIF sucked by
> specification. In UEFI's case here, it's been implemented in Linux in
> such a way that guarantees poor-performing firmware code with huge
> penalties to call them, which isn't even required by UEFI if the
> earlier boot code did the right things in the first place.

I don't follow. In which way does this implementation result in poor
performance or reduced functionality?

We deal with a highly quirky set of requirements for calling
SetVirtualAddressMap() in a clunky way - after which calls into UEFI
are direct and cachable.

/
    Leif
