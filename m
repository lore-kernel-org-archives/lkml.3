Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbaKUMi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:38:56 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:49644 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaKUMiy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:38:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Schopp, Joel" <Joel.Schopp@amd.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "liviu.dudau@arm.com" <liviu.dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] arm64: amd-seattle: Adding device tree for AMD Seattle platform
Date: Fri, 21 Nov 2014 13:38:48 +0100
Message-ID: <59640336.2Jjg4YGMcT@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5468032C.8020505@amd.com>
References: <5468032C.8020505@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:mLMySVuQsZdBap5NZ9fPgnPI+9YtP0L648EzYM8gYUu
 X6az3C3e4VZOWgcAUUyJvW1SqX+7gFh8ee2DxZ6Bx7mwHevDY7
 vp1DFIgmaOILm73teGrEuqJdKXDaT9PB96vNx2daNgIaWwdKkk
 LIYqR6KH1AODyKOv0XxK/+C7wvB6dRhdGkv0aqSVpnpOwgbQDW
 wP0NYK9//81i1D2MyaxKe/iLv70oNuHwQJ4kCTVwJid+fpX5Cd
 M82EjzcPvj+9q8n3gYT3jU8wbFQISTyiBs26vv8rPNiDBq/kkk
 v5A2QM7wW7tZjb/r4o18/99j59loX0wmsxmK5ahBaa9wsSxg4M
 cBDGxgUBvjLvpgdG4Bek=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 November 2014 01:12:45 Suthikulpanit, Suravee wrote:
> On 11/13/14 18:29, Arnd Bergmann wrote:
> > On Tuesday 28 October 2014 08:36:54 suravee.suthikulpanit@amd.com wrote:
> >> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> >>
> >> Initial revision of device tree for AMD Seattle platform
> >
> > Sorry for not looking at this earlier in enough detail.
> >
> >> +	dma0: dma@0500000 {
> >> +		compatible = "arm,pl330", "arm,primecell";
> >> +		reg = <0 0x0500000 0 0x1000>;
> >> +		interrupts =
> >> +			<0 368 4>,
> >> +			<0 369 4>,
> >> +			<0 370 4>,
> >> +			<0 371 4>,
> >> +			<0 372 4>,
> >> +			<0 373 4>,
> >> +			<0 374 4>,
> >> +			<0 375 4>;
> >> +		clocks = <&dmaclk_500mhz>;
> >> +		clock-names = "apb_pclk";
> >> +		#dma-cells = <1>;
> >> +	};
> >
> > Is this device cache-coherent?
> >
> > Does it support larger than 32-bit DMA addresses?
> 
> The pl330 is only 32-bit DMA addressable, and need to be used with
> the smmu (not yet included here) before it can be used in the system.
> Therefore, it should be cache coherent by the virtue of the SMMU.
> 
> I¹ll remove this until the SMMU stuff is tested and ready.

Ok, makes sense.

> >
> >> +	sata0: sata@00300000 {
> >> +		compatible = "snps,dwc-ahci";
> >> +		reg = <0 0x300000 0 0x800>;
> >> +		interrupts = <0 355 4>;
> >> +		clocks = <&sataclk_333mhz>;
> >> +		clock-names = "apb_pclk";
> >> +		dma-coherent;
> >> +	};
> >
> > Same here: you list it as coherent, but not 64-bit DMA capable.
> > Is that intentional?
> 
> Correct me if I am wrong, but I didn't think that we need to specify
> here since the AHCI platform driver determines the DMA bitness by
> checking struct ahci_host_priv.cap for HOST_CAP_64 (see
> drivers/ata/libahci_platform.c).

No, the actual DMA mask that gets used is the combination of what
the device claims to support and what the bus can do. Without the
dma-ranges property, the bus will be seen as 32-bit only, so we won't
allow high DMA transfers for devices that can do it.

This is the same way we have to treat any PCI device as well, since
a lot of PCI devices can do 64-bit DMA, but they can also be connected
to a pci host bridge that sits on a 32-bit bus and has no supported
IOMMU.

> However, based on the conversation on the IRC, I¹ll add the dma-ranges
> in the motherboard level.

Ok.

> >
> >> +	i2c@1000000 {
> >> +		compatible = "snps,designware-i2c";
> >> +		reg = <0 0x01000000 0 0x1000>;
> >> +		interrupts = <0 357 4>;
> >> +		clocks = <&uartspiclk_100mhz>;
> >> +		clock-names = "apb_pclk";
> >> +	};
> >> +
> >> +	serial0: serial@1010000 {
> >> +		compatible = "arm,pl011", "arm,primecell";
> >> +		reg = <0 0x1010000 0 0x1000>;
> >> +		interrupts = <0 328 4>;
> >> +		clocks = <&uartspiclk_100mhz>, <&uartspiclk_100mhz>;
> >> +		clock-names = "uartclk", "apb_pclk";
> >> +	};
> >> +
> >> +	ssp@1020000 {
> >> +		compatible = "arm,pl022", "arm,primecell";
> >> +		#gpio-cells = <2>;
> >> +		reg = <0 0x1020000 0 0x1000>;
> >> +		spi-controller;
> >> +		interrupts = <0 330 4>;
> >> +		clocks = <&uartspiclk_100mhz>;
> >> +		clock-names = "apb_pclk";
> >> +	};
> >
> > Should these three be connected to the DMA engine?
> 
> It doesn't do DMA. Only PCI devices, XGBE, and SATA do DMA.

What is the pl330 connected to then? It's very common for pl011
and pl022 to be used in combination with a pl330 in order to
do DMA.

> >> +	pcie0: pcie-controller{
> >> +		compatible = "pci-host-ecam-generic";
> >> +		#address-cells = <3>;
> >> +		#size-cells = <2>;
> >> +		device_type = "pci";
> >> +		bus-range = <0 0xff>;
> >> +		reg = <0 0xf0000000 0 0x10000000>;
> >> +		dma-coherent;
> >> +		msi-parent = <&v2m0>;
> >
> > This surely needs a dma-ranges property to allow larger than 32-bit DMA.
> 
> So, I assume this will also need dma-range handling code to be added to
> the PCI generic host driver.

Yes, good point.


> I will made the changes accordingly.

thanks,

	Arnd
