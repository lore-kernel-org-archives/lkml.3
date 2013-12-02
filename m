Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab3LBTvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:51:31 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:60839 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab3LBTvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:51:23 -0500
MIME-Version: 1.0
In-Reply-To: <1385656883-4420-2-git-send-email-leif.lindholm@linaro.org>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
	<1385656883-4420-2-git-send-email-leif.lindholm@linaro.org>
Date: Mon, 2 Dec 2013 13:51:22 -0600
Message-ID: <CAHCPf3t5dEzVWbYZ6DWcFCENNO2dbrx-YeZvKRk0MkEsJMTE3A@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] Documentation: arm: add UEFI support documentation
From: Matt Sealey <neko@bakuhatsu.net>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, matt.fleming@intel.com,
        Grant Likely <grant.likely@linaro.org>, roy.franz@linaro.org,
        msalter@redhat.com, Patch Tracking <patches@linaro.org>,
        linaro-uefi@linaro.org, Mark Rutland <mark.rutland@arm.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +UEFI kernel support on ARM
> +==========================
> +UEFI kernel support on the ARM architectures (arm and arm64) is only available
> +when boot is performed through the stub.
> +
> +The stub populates the FDT /chosen node with (and the kernel scans for) the
> +following parameters:
> +________________________________________________________________________________
> +Name                      | Size   | Description
> +================================================================================
> +linux,uefi-system-table   | 64-bit | Physical address of the UEFI System Table.
> +--------------------------------------------------------------------------------
> +linux,uefi-mmap-start     | 64-bit | Physical address of the UEFI memory map,
> +                          |        | populated by the UEFI GetMemoryMap() call.
> +--------------------------------------------------------------------------------
> +linux,uefi-mmap-size      | 32-bit | Size in bytes of the UEFI memory map
> +                          |        | pointed to in previous entry.
> +--------------------------------------------------------------------------------
> +linux,uefi-mmap-desc-size | 32-bit | Size in bytes of each entry in the UEFI
> +                          |        | memory map.
> +--------------------------------------------------------------------------------
> +linux,uefi-mmap-desc-ver  | 32-bit | Version of the mmap descriptor format.
> +--------------------------------------------------------------------------------
> +linux,uefi-stub-kern-ver  | string | Copy of linux_banner from build.
> +--------------------------------------------------------------------------------

This flies in the face of actually using #address-cells and
#size-cells to define how big addresses and sizes are. You're limited
here by the root node definitions... that's the spec.

Here's where I think this whole thing falls down as being the weirdest
possible implementation of this. It defies logic to put this
information in the device tree /chosen node while also attempting to
boot the kernel using an EFI stub; the stub is going to have this
information because it is going to have the pointer to the system
System Table (since it was called by StartImage()). Why not stash the
System Table pointer somewhere safe in the stub?

The information in the device tree is all accessible from Boot
Services and as long as the System Table isn't being thrown away (my
suggestion would be.. stuff it in r2, and set r1 = "EFI\0" then work
with arch/arm/kernel/head{-common,}.S code to do the right thing)

It seems like the advantages of booting from UEFI and having all this
information and API around are being thrown away very early, and
picked up when it's no longer relevant to gain access to the very
minimal runtime services. What's missing is a UUID for a "Device Tree
Blob" in the Configuration Table, so you can very easily go grab that
information from the firmware.

As implemented, these patches employ a very long-winded and complex
method of recovering UEFI after throwing the system table pointer away
early in boot, and then implements an EFI calling convention which
isn't strictly necessary according to the UEFI spec - the question is,
is this a workaround for SetVirtualAddressMap() not actually doing the
right thing on ARM UEFI implementations? If you can't guarantee that
most of the calls from Boot Services or Runtime Services are going to
allow this, then having any UEFI support in the kernel at all seems
rather weird.

What I'm worried about is that this is basically a hack to try and
shoehorn an existing UEFI implementation to an existing Linux boot
method - and implements it in a way nobody is ever going to be able to
justify improving. Part of the reason the OpenFirmware CIF got thrown
away early in SPARC/PowerPC boot (after "flattening" the device tree
using the CIF calls to parse it out) was because you had to disable
the MMU, caches, interrupts etc. which caused all kinds of slow
firmware code to be all kinds of extra-slow.

What that meant is nobody bothered to implement working, re-entrant,
re-locatable firmware to a great degree. This ended up being a
self-fulfilling prophecy of "don't trust the bootloader" and "get rid
of it as soon as we can," which essentially meant Linux never took
advantage of the resources available. In OF's case, the CIF sucked by
specification. In UEFI's case here, it's been implemented in Linux in
such a way that guarantees poor-performing firmware code with huge
penalties to call them, which isn't even required by UEFI if the
earlier boot code did the right things in the first place.

Ta,
Matt Sealey <neko@bakuhatsu.net>
