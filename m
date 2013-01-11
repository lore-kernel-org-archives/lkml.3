Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab3AKAWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 19:22:36 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52675 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3AKAWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 19:22:34 -0500
Message-ID: <50EF5B46.8010806@wwwdotorg.org>
Date: Thu, 10 Jan 2013 17:22:30 -0700
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
Subject: Re: [PATCH 12/14] ARM: tegra: tec: Add PCIe support
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <1357764194-12677-13-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1357764194-12677-13-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 01:43 PM, Thierry Reding wrote:
> Enable the first PCIe root port which is connected to an FPGA on the
> Tamonten Evaluation Carrier and add device nodes for each of the PCI
> endpoints available in the standard configuration.

> diff --git a/arch/arm/boot/dts/tegra20-tec.dts b/arch/arm/boot/dts/tegra20-tec.dts

> +	pcie-controller {
> +		vdd-supply = <&pci_vdd_reg>;
> +		pex-clk-supply = <&pci_clk_reg>;
> +		status = "okay";

Sorry this is also really picky. I'd prefer properties that exist in
/include/d files and are overidden here to appear first, followed by new
properties. In other words, move the status property to be first. I
believe/hope all the other (Tegra) .dts files follow this convention.

> +		pci@1,0 {
> +			bus-range = <0x01 0x0a>;
> +			status = "okay";
> +
> +			pci@0,0 {
> +				reg = <0x010000 0 0 0 0>;

Hmm. The unit address in that node name doesn't match the address in the
reg property, although I suppose there's nothing we can do about it
since those formats are both defined by the standard PCI binding?

What do the numbers "0,0" represent here; device/function? Is the same
true for the "0,0" in the child nodes?

> +				bus-range = <0x02 0x0a>;
> +
> +				compatible = "plda,pcie";

Are there DT binding documents for all these devices; plda,pcie,
ad,pcie, ad,pcie-test, etc.?

> +				pci@4,0 {
> +					reg = <0x022000 0 0 0 0>;
> +					bus-range = <0x07 0x07>;
> +
> +					compatible = "ad,pcie";
> +					device_type = "pci";
> +
> +					#address-cells = <3>;
> +					#size-cells = <2>;
> +
> +					pci@0,0 {
> +						compatible = "opencores,uart";
> +						reg = <0x070000 0 0 0 0>;
> +					};
> +				};

Do you need to include a node for the UART; I can see you need to for
the SPI/I2C controllers so you can instantiate the appropriate devices
on non-probe-able buses, but I think you can just let regular PCI device
probing find the UART, Ethernet MAC, etc., can't you?
