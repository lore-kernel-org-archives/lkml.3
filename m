Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab3AJX4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:56:45 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56735 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab3AJX4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:56:44 -0500
Message-ID: <50EF5537.6080602@wwwdotorg.org>
Date: Thu, 10 Jan 2013 16:56:39 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 14/14] ARM: tegra: trimslice: Initialize PCIe from DT
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <1357764194-12677-15-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1357764194-12677-15-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 01:43 PM, Thierry Reding wrote:
> With the device tree support in place, probe the PCIe controller from
> the device tree and remove the corresponding workaround in the board
> file.

Thierry, there are a couple things missing from this patch; I include a
fixup for you to squash in, but also see beyond that for a problem.

>  arch/arm/boot/dts/tegra20-trimslice.dts |   26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts b/arch/arm/boot/dts/tegra20-trimslice.dts
> index ebb4c17..41fc45b 100644
> --- a/arch/arm/boot/dts/tegra20-trimslice.dts
> +++ b/arch/arm/boot/dts/tegra20-trimslice.dts
> @@ -303,12 +303,10 @@
>  
>  	pcie-controller {
>  		status = "okay";
> +		pex-clk-supply = <&pci_clk_reg>;
> +		vdd-supply = <&pci_vdd_reg>;
>  
> -		pci@0 {
> -			status = "okay";
> -		};
> -
> -		pci@1 {
> +		pci@1,0 {
>  			status = "okay";
>  		};
>  	};
> @@ -366,6 +364,24 @@
>  			regulator-max-microvolt = <1800000>;
>  			regulator-always-on;
>  		};
> +
> +		pci_clk_reg: regulator@2 {
> +			compatible = "regulator-fixed";
> +			reg = <2>;
> +			regulator-name = "pci_clk";
> +			regulator-min-microvolt = <3300000>;
> +			regulator-max-microvolt = <3300000>;
> +			regulator-always-on;
> +		};
> +
> +		pci_vdd_reg: regulator@3 {
> +			compatible = "regulator-fixed";
> +			reg = <3>;
> +			regulator-name = "pci_vdd";
> +			regulator-min-microvolt = <1050000>;
> +			regulator-max-microvolt = <1050000>;
> +			regulator-always-on;
> +		};
>  	};
>  
>  	sound {
> -- 
> 1.7.10.4

However, PCIe still doesn't work on TrimSlice; the device enumeration
fails. The log is below:

> [    0.790425] tegra-pcie 80003000.pcie-controller: link 0 down, retrying
> [    0.801351] tegra-pcie 80003000.pcie-controller: PCI host bridge to bus 0000:00
> [    0.808945] pci_bus 0000:00: root bus resource [io  0x82000000-0x8200ffff]
> [    0.816109] pci_bus 0000:00: root bus resource [mem 0xa0000000-0xafffffff]
> [    0.823303] pci_bus 0000:00: root bus resource [mem 0xb0000000-0xbfffffff pref]
> [    0.830893] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.836728] pci 0000:00:01.0: [10de:0bf0] type 01 class 0x060000
> [    0.843097] pci 0000:00:01.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.850047] PCI: bus0: Fast back to back transfers disabled
> [    0.855853] pci 0000:00:01.0: bridge configuration invalid ([bus 00-00]), reconfiguring
> [    0.864308] tegra-pcie 80003000.pcie-controller: AXI response decoding error, signature: 10010001
> [    0.873489] tegra-pcie 80003000.pcie-controller:   FPCI address: fe10010000

^^^ For some reason, the config register access fails.

> [    0.880760] PCI: bus1: Fast back to back transfers enabled
> [    0.886482] pci_bus 0000:01: busn_res: [bus 01-ff] end is updated to 01
> [    0.893381] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    0.898577] PCI: enabling device 0000:00:01.0 (0140 -> 0143)
> [    0.904535] pci 0000:00:01.0: nv_msi_ht_cap_quirk didn't locate host bridge

With plain next-20130109, the device enumeration succeeds.
