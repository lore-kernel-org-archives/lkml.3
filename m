Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaLJKau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:30:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52796 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaLJKat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:30:49 -0500
Message-ID: <1418207427.7616.5.camel@pengutronix.de>
Subject: Re: [PATCH 1/4] pci: iProc: define Broadcom iProc PCIe binding
From: Lucas Stach <l.stach@pengutronix.de>
To: Ray Jui <rjui@broadcom.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org
Date: Wed, 10 Dec 2014 11:30:27 +0100
In-Reply-To: <1418169871-19232-2-git-send-email-rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
	 <1418169871-19232-1-git-send-email-rjui@broadcom.com>
	 <1418169871-19232-2-git-send-email-rjui@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 09.12.2014, 16:04 -0800 schrieb Ray Jui:
> Document the PCIe device tree binding for Broadcom iProc family of SoCs
> 
> Signed-off-by: Ray Jui <rjui@broadcom.com>
> Reviewed-by: Scott Branden <sbranden@broadcom.com>
> ---
>  .../devicetree/bindings/pci/brcm,iproc-pcie.txt    |   62 ++++++++++++++++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pci/brcm,iproc-pcie.txt
> 
> diff --git a/Documentation/devicetree/bindings/pci/brcm,iproc-pcie.txt b/Documentation/devicetree/bindings/pci/brcm,iproc-pcie.txt
> new file mode 100644
> index 0000000..2467628
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pci/brcm,iproc-pcie.txt
> @@ -0,0 +1,62 @@
> +* Broadcom iProc PCIe controller
> +
> +Required properties:
> +- compatible: Must be "brcm,iproc-pcie"
> +- reg: base address and length of the PCIe controller and the MDIO interface
> +  that controls the PCIe PHY
> +- interrupts: interrupt IDs
> +- bus-range: PCI bus numbers covered
> +- #address-cells: set to <3>
> +- #size-cells: set to <2>
> +- device_type: set to "pci"
> +- ranges: ranges for the PCI memory and I/O regions
> +- phy-addr: MDC/MDIO adddress of the PCIe PHY
> +- have-msi-inten-reg: Required for legacy iProc PCIe controllers that need the
> +  MSI interrupt enable register to be set explicitly
> +
> +The Broadcom iProc PCie driver adapts the multi-domain structure, i.e., each
> +interface has its own domain and therefore has its own device node
> +Example:
> +
> +SoC specific DT Entry:
> +
> +	pcie0: pcie@18012000 {
> +		compatible = "brcm,iproc-pcie";
> +		reg = <0x18012000 0x1000>,
> +			<0x18002000 0x1000>;
> +		interrupts = <GIC_SPI 96 IRQ_TYPE_NONE>,
> +			     <GIC_SPI 97 IRQ_TYPE_NONE>,
> +			     <GIC_SPI 98 IRQ_TYPE_NONE>,
> +			     <GIC_SPI 99 IRQ_TYPE_NONE>,
> +			     <GIC_SPI 100 IRQ_TYPE_NONE>,
> +			     <GIC_SPI 101 IRQ_TYPE_NONE>;

This is missing the interrupt-map and interrupt-map-mask for the legacy
INTx interrupts. If you add this you don't need to have a special map
function in your driver, but can just use the standard
of_irq_parse_and_map_pci() function.

Regards,
Lucas

> +		bus-range = <0x00 0xFF>;
> +
> +		#address-cells = <3>;
> +		#size-cells = <2>;
> +		device_type = "pci";
> +		ranges = <0x81000000 0 0	  0x28000000 0 0x00010000   /* downstream I/O */
> +			  0x82000000 0 0x20000000 0x20000000 0 0x04000000>; /* non-prefetchable memory */
> +		phy-addr = <5>;
> +	};
> +
> +	pcie1: pcie@18013000 {
> +		compatible = "brcm,iproc-pcie";
> +		reg = <0x18013000 0x1000>,
> +			<0x18002000 0x1000>;
> +
> +		interrupts = <GIC_SPI 102 IRQ_TYPE_NONE>,
> +			     <GIC_SPI 103 IRQ_TYPE_NONE>,
> +			     <GIC_SPI 104 IRQ_TYPE_NONE>,
> +			     <GIC_SPI 105 IRQ_TYPE_NONE>,
> +			     <GIC_SPI 106 IRQ_TYPE_NONE>,
> +			     <GIC_SPI 107 IRQ_TYPE_NONE>;
> +		bus-range = <0x00 0xFF>;
> +
> +		#address-cells = <3>;
> +		#size-cells = <2>;
> +		device_type = "pci";
> +		ranges = <0x81000000 0 0	  0x48000000 0 0x00010000   /* downstream I/O */
> +			  0x82000000 0 0x40000000 0x40000000 0 0x04000000>; /* non-prefetchable memory */
> +		phy-addr = <6>;
> +	};

-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

