Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaKYKYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:24:07 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38693 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaKYKYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:24:04 -0500
Message-ID: <547458B9.2000805@arm.com>
Date: Tue, 25 Nov 2014 10:23:53 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "arnd@arndb.de" <arnd@arndb.de>, Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
CC: "robherring2@gmail.com" <robherring2@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>
Subject: Re: [PATCH V4] arm64: amd-seattle: Adding device tree for AMD Seattle
 platform
References: <1416865877-8347-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1416865877-8347-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suravee,

Just spotted a small issue below (looks like a recurring mistake in a
number of DTs I've seem lately):

On 24/11/14 21:51, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> Initial revision of device tree for AMD Seattle platform.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Signed-off-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
> Signed-off-by: Joel Schopp <Joel.Schopp@amd.com>
> ---
> V4 Changes:
>     * Remove unnecessary smb layer and move motherbord to top level
>     * Move include dtsi to top level
>     * Remove apb_pclk from sata0 and i2c
>     * Fix GIC Virtual Maintanance Interrupt from PPI24 (8) to PPI25 (9)
>     * Add 40-bit dma-ranges for motherboard (simple-bus)
>     * Remove dma0 (pl330) entry for now since it only supports 32-bit DMA.
>       It is basically not used at the moment. It would also need SMMU
>       to allow dma remapping to 40-bit DMA range.
>     * Add phandle spi0 and spi1
>     * Hook up gpio0 pin 7 with MMC Card Detection (CD) support.
>     * Changes in pcie0 entry:
>         - Add 40-bit dma-ranges
>         - Remove interrupts property
>         - Add interrupt-map/mask property
>         - Fix PCI I/O range 
>         - Merge PCI 32-bit ranges
>         - Merge PCI 64-bit ranges
> 
> NOTE: I am not add a new compatible ID for the sata0 as Rob Herring
>       suggested since there is no need at the momement, and I am trying
>       to avoid introducing ID unnecessarily.
> 
>  arch/arm64/Kconfig                          |   5 +
>  arch/arm64/boot/dts/Makefile                |   1 +
>  arch/arm64/boot/dts/amd-seattle-periph.dtsi | 156 ++++++++++++++++++++++++++++
>  arch/arm64/boot/dts/amd-seattle.dts         |  89 ++++++++++++++++
>  4 files changed, 251 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/amd-seattle-periph.dtsi
>  create mode 100644 arch/arm64/boot/dts/amd-seattle.dts
> 

[...]

> diff --git a/arch/arm64/boot/dts/amd-seattle.dts b/arch/arm64/boot/dts/amd-seattle.dts
> new file mode 100644
> index 0000000..d5fc482
> --- /dev/null
> +++ b/arch/arm64/boot/dts/amd-seattle.dts
> @@ -0,0 +1,89 @@
> +/*
> + * DTS file for AMD Seattle
> + *
> + * Copyright (C) 2014 Advanced Micro Devices, Inc.
> + */
> +
> +/dts-v1/;
> +
> +/include/ "amd-seattle-periph.dtsi"
> +
> +/ {
> +	compatible = "amd,seattle";
> +	interrupt-parent = <&gic>;
> +	#address-cells = <2>;
> +	#size-cells = <2>;
> +
> +	chosen {
> +		stdout-path = &serial0;
> +		linux,pci-probe-only;
> +	};
> +
> +	gic: interrupt-controller@e1101000 {
> +		compatible = "arm,gic-400", "arm,cortex-a15-gic";
> +		interrupt-controller;
> +		#interrupt-cells = <3>;
> +		#address-cells = <2>;
> +		#size-cells = <2>;
> +		reg = <0x0 0xe1110000 0 0x1000>,
> +		      <0x0 0xe112f000 0 0x2000>,
> +		      <0x0 0xe1140000 0 0x10000>,
> +		      <0x0 0xe1160000 0 0x10000>;
> +		interrupts = <1 9 0xf04>;
> +		ranges;
> +		v2m0: v2m@e1180000 {
> +			compatible = "arm,gic-v2m-frame";
> +			msi-controller;
> +			arm,msi-base-spi = <64>;
> +			arm,msi-num-spis = <256>;
> +			reg = <0x0 0xe1180000 0 0x1000>;
> +		};
> +	};
> +
> +	timer {
> +		compatible = "arm,armv8-timer";
> +		interrupts = <1 13 0xff01>,
> +			     <1 14 0xff01>,
> +			     <1 11 0xff01>,
> +			     <1 10 0xff01>;
> +	};

The Cortex-A57 TRM clearly states that these interrupts are level triggered.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
