Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbaGaJxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:53:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55567 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbaGaJxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:53:39 -0400
Date: Thu, 31 Jul 2014 10:53:36 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Ganapatrao Kulkarni <gpkulkarni@gmail.com>
Cc: Robert Richter <rric@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/5] arm64, thunder: Add initial dts for Cavium Thunder
 SoC
Message-ID: <20140731095336.GB21850@leverpostej>
References: <1406732794-20920-1-git-send-email-rric@kernel.org>
 <1406732794-20920-3-git-send-email-rric@kernel.org>
 <20140730154626.GD20162@leverpostej>
 <CAFpQJXWKybVUxpHg8MVrVMjLj3swuxLGo_9r1tL+gZ4hxUHTzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFpQJXWKybVUxpHg8MVrVMjLj3swuxLGo_9r1tL+gZ4hxUHTzQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 09:41:10AM +0100, Ganapatrao Kulkarni wrote:
>    On Wed, Jul 30, 2014 at 9:16 PM, Mark Rutland <[1]mark.rutland@arm.com>
>    wrote:
> 
>      Hi,
>      On Wed, Jul 30, 2014 at 04:06:31PM +0100, Robert Richter wrote:
>      > From: Radha Mohan Chintakuntla <[2]rchintakuntla@cavium.com>
>      >
>      > Add initial device tree nodes for Cavium Thunder SoCs with support of
>      > 48 cores and gicv3. The dts file requires further changes, esp. for
>      > pci, gicv3-its and smmu. This changes will be added later together
>      > with the device drivers.
>      >
>      > Signed-off-by: Radha Mohan Chintakuntla <[3]rchintakuntla@cavium.com>
>      > Signed-off-by: Robert Richter <[4]rrichter@cavium.com>
>      > ---
>      >  arch/arm64/boot/dts/Makefile         |   1 +
>      >  arch/arm64/boot/dts/thunder-88xx.dts | 387
>      +++++++++++++++++++++++++++++++++++
>      >  2 files changed, 388 insertions(+)
>      >  create mode 100644 arch/arm64/boot/dts/thunder-88xx.dts
>      >
>      > diff --git a/arch/arm64/boot/dts/Makefile
>      b/arch/arm64/boot/dts/Makefile
>      > index c52bdb051f66..f8001a62029c 100644
>      > --- a/arch/arm64/boot/dts/Makefile
>      > +++ b/arch/arm64/boot/dts/Makefile
>      > @@ -1,3 +1,4 @@
>      > +dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
>      >  dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
>      >  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
>      >
>      > diff --git a/arch/arm64/boot/dts/thunder-88xx.dts
>      b/arch/arm64/boot/dts/thunder-88xx.dts
>      > new file mode 100644
>      > index 000000000000..4cf20ac9138b
>      > --- /dev/null
>      > +++ b/arch/arm64/boot/dts/thunder-88xx.dts
>      > @@ -0,0 +1,387 @@
>      > +/*
>      > + * Cavium Thunder DTS file
>      > + *
>      > + * Copyright (C) 2013, Cavium Inc.
>      > + *
>      > + * This program is free software; you can redistribute it and/or
>      > + * modify it under the terms of the GNU General Public License as
>      > + * published by the Free Software Foundation; either version 2 of
>      > + * the License, or (at your option) any later version.
>      > + */
>      > +/dts-v1/;
>      > +
>      > +/* Reserving first 12MB of DDR for firmware */
>      > +/memreserve/ 0x00000000 0x00c00000;
> 
>      What exactly is this memreserve intended to protect at runtime?
>      Yes, this 12 MB is reserved for ATF and UEFI boot and run-time services.

If booted as an EFI application Linux will use the UEFI memory map.
Anything UEFI needs to have kept around will be marked as such, so
there's no need to memreserve that.

I was under the impression that the ARM Trusted Firmware didn't need
anything resident on the non-secure side, so I don't see why that needs
a memreserve -- Linux should not be able to address anything it has
resident.

>      The only item of runtime firmware I see in use below is PSCI on the
>      secure side.
> 
>      How is the kernel booted on this platform? UEFI?
> 
>    Boot sequence tried is ATF->UEFI->Linux  and ATF->UEFI->GRUB->Linux 

As I've just had it explained to me, in either of those cases we should
enter Linux via the EFI stub. So we should be using the UEFI memory map
regardless.

Thanks,
Mark.
