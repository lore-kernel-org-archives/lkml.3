Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbaKMLaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:30:22 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:51029 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329AbaKMLaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:30:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: suravee.suthikulpanit@amd.com, mark.rutland@arm.com, will.deacon@arm.com,
        catalin.marinas@arm.com, Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>, marc.zyngier@arm.com,
        liviu.dudau@arm.com, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: Re: [PATCH V3] arm64: amd-seattle: Adding device tree for AMD Seattle platform
Date: Thu, 13 Nov 2014 12:29:40 +0100
Message-ID: <8642876.4lpJWZTuhf@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414503414-3863-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1414503414-3863-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:VJ3JLM5/LKM14WH7bcdCvCEoojOxi2rTYH54NEAVrdg
 ts8a/RHJPYVcOg1vW7RALQYRHoMIV1P2HmfzTwhhyihOPX7mhE
 KlRcvP6bH2cdF3q9UCm2Q2Uwz5c0ResE8TnY3n3kFBGgruGuYR
 VGwQvU7ClOMUDtlYs5MCF2ZNf0BJpMgtoK4fC5j+ME3z7FxLEv
 MD8waORbyWmld9RzlXepHQIKj49MuXzdgsO8Luad77gTMMZcca
 JCEIkztY7M1IhdvHO3NnnJFo/3ijO14AMDfw2f8el2P7mYExzZ
 Dff76MrZo9bCmaGqSPUeYtCDNnhaRx7ahadUGEQaL7659r1BOs
 YwdykKD1xoyl06ULVOXQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 08:36:54 suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> Initial revision of device tree for AMD Seattle platform

Sorry for not looking at this earlier in enough detail.

> +	dma0: dma@0500000 {
> +		compatible = "arm,pl330", "arm,primecell";
> +		reg = <0 0x0500000 0 0x1000>;
> +		interrupts =
> +			<0 368 4>,
> +			<0 369 4>,
> +			<0 370 4>,
> +			<0 371 4>,
> +			<0 372 4>,
> +			<0 373 4>,
> +			<0 374 4>,
> +			<0 375 4>;
> +		clocks = <&dmaclk_500mhz>;
> +		clock-names = "apb_pclk";
> +		#dma-cells = <1>;
> +	};

Is this device cache-coherent?

Does it support larger than 32-bit DMA addresses?

> +	sata0: sata@00300000 {
> +		compatible = "snps,dwc-ahci";
> +		reg = <0 0x300000 0 0x800>;
> +		interrupts = <0 355 4>;
> +		clocks = <&sataclk_333mhz>;
> +		clock-names = "apb_pclk";
> +		dma-coherent;
> +	};

Same here: you list it as coherent, but not 64-bit DMA capable.
Is that intentional?

> +	i2c@1000000 {
> +		compatible = "snps,designware-i2c";
> +		reg = <0 0x01000000 0 0x1000>;
> +		interrupts = <0 357 4>;
> +		clocks = <&uartspiclk_100mhz>;
> +		clock-names = "apb_pclk";
> +	};
> +
> +	serial0: serial@1010000 {
> +		compatible = "arm,pl011", "arm,primecell";
> +		reg = <0 0x1010000 0 0x1000>;
> +		interrupts = <0 328 4>;
> +		clocks = <&uartspiclk_100mhz>, <&uartspiclk_100mhz>;
> +		clock-names = "uartclk", "apb_pclk";
> +	};
> +
> +	ssp@1020000 {
> +		compatible = "arm,pl022", "arm,primecell";
> +		#gpio-cells = <2>;
> +		reg = <0 0x1020000 0 0x1000>;
> +		spi-controller;
> +		interrupts = <0 330 4>;
> +		clocks = <&uartspiclk_100mhz>;
> +		clock-names = "apb_pclk";
> +	};

Should these three be connected to the DMA engine?

> +	ccp: ccp@00100000 {
> +		compatible = "amd,ccp-seattle-v1a";
> +		reg = <0 0x00100000 0 0x10000>;
> +		interrupts = <0 3 4>;
> +		dma-coherent;
> +	};

I see the driver hacks an 48-bit DMA mask into this one.
Please fix the driver and add an appropriate dma-ranges property.

> +	/* This entry is modified by UEFI */

Can you explain which parts are modified by UEFI?

> +	pcie0: pcie-controller{
> +		compatible = "pci-host-ecam-generic";
> +		#address-cells = <3>;
> +		#size-cells = <2>;
> +		device_type = "pci";
> +		bus-range = <0 0xff>;
> +		reg = <0 0xf0000000 0 0x10000000>;
> +		dma-coherent;
> +		msi-parent = <&v2m0>;

This surely needs a dma-ranges property to allow larger than 32-bit DMA.



> +		interrupts =
> +			<0 320 4>, /* ioc_soc_serr */
> +			<0 321 4>; /* ioc_soc_sci */

The pci-host-ecam-generic binding does not allow an interrupts property.

You seem to be missing an interrupt-map property.


> +		ranges =
> +			/* I/O Memory (size=64K) */
> +			<0x01000000 0x00 0xefff0000 0x00 0xefff0000 0x00 0x00010000>,

Are you able to map the I/O space to bus address zero instead in the
firmware? This looks like a firmware bug, I/O space should not
be identity-mapped but is normally expected to have low port numbers.

> +			/* Non-Pref 32-bit MMIO (size=512M) */
> +			<0x02000000 0x00 0x40000000 0x00 0x40000000 0x00 0x20000000>,
> +
> +			/* Non-Pref 32-bit MMIO (size=512M) */
> +			<0x02000000 0x00 0x60000000 0x00 0x60000000 0x00 0x20000000>,
> +
> +			/* Non-Pref 32-bit MMIO (size=512M) */
> +			<0x02000000 0x00 0x80000000 0x00 0x80000000 0x00 0x20000000>,
> +
> +			/* Non-Pref 32-bit MMIO (size=512M) */
> +			<0x02000000 0x00 0xa0000000 0x00 0xa0000000 0x00 0x20000000>,

I don't understand why you use distinct ranges here and below. These are all
contiguous, so why not collapse them into one logical range.

> +	smb {
> +		compatible = "simple-bus";
> +		#address-cells = <2>;
> +		#size-cells = <2>;
> +		ranges = <0 0 0 0xE0000000 0 0x01300000>;
> +
> +		/include/ "amd-seattle-periph.dtsi"
> +	};

I would put the smb node into the other file and move the include statement to the
top level.

Please use lowercase characters for the address.

	Arnd
