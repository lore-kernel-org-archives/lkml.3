Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967647AbaLLMTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 07:19:17 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:53327 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967625AbaLLMTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:19:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Ray Jui <rjui@broadcom.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Hauke Mehrtens <hauke@hauke-m.de>, devicetree@vger.kernel.org,
        Scott Branden <sbranden@broadcom.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v2 1/4] pci: iProc: define Broadcom iProc PCIe binding
Date: Fri, 12 Dec 2014 13:14:58 +0100
Message-ID: <3375037.6pjWmlOLA3@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418351817-14898-2-git-send-email-rjui@broadcom.com>
References: <1418351817-14898-2-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:rSZ/VY24gr5zMg35FbDKMyJ0oNRzwtgmB4/swL28xWWzsNtIQs/
 HDOQ2wJERErXTju9d9rSrtPUpvKKeUKDTr7ONsPEs0B6GX73qp1Yv6jdhb0KXuKN/YIALIp
 ACyB4lJA6UweKYy4f2PLSEP4c/eFVhwehGSjwd+3RO/MPj1nHPjGy3gFcqoSh55VFiIPtK4
 iULWrEk7BMFKfwizN+7wA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 December 2014 18:36:54 Ray Jui wrote:
> index 0000000..040bc0f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pci/brcm,iproc-pcie.txt
> @@ -0,0 +1,74 @@
> +* Broadcom iProc PCIe controller
> +
> +Required properties:
> +- compatible: Must be "brcm,iproc-pcie"
> +- reg: base address and length of the PCIe controller and the MDIO interface
> +  that controls the PCIe PHY
> +- #interrupt-cells: set to <1>
> +- interrupts: interrupt IDs

How many, and what are they?

> +- interrupt-map-mask and interrupt-map, standard PCI properties to define the
> +  mapping of the PCIe interface to interrupt numbers
> +- bus-range: PCI bus numbers covered
> +- #address-cells: set to <3>
> +- #size-cells: set to <2>
> +- device_type: set to "pci"
> +- ranges: ranges for the PCI memory and I/O regions
> +- phy-addr: MDC/MDIO adddress of the PCIe PHY

It looks like the phy controller is separate from the PCI controller,
and you even list the same register range for both PHYs. Better make
that a separate driver and put the phy address into the "phys" reference.

> +- have-msi-inten-reg: Required for legacy iProc PCIe controllers that need the
> +  MSI interrupt enable register to be set explicitly
> +
> +The Broadcom iProc PCie driver adapts the multi-domain structure, i.e., each
> +interface has its own domain and therefore has its own device node
> +Example:
> +
> +SoC specific DT Entry:
> +
> +       pcie0: pcie@18012000 {
> +               compatible = "brcm,iproc-pcie";
> +               reg = <0x18012000 0x1000>,
> +                       <0x18002000 0x1000>;

I guess the addresses should be relative to the BCMA bus, and this node
get moved under that. Please see Hauke's patch series, we've discussed
this in great length already.

> +               #interrupt-cells = <1>;
> +               interrupts = <GIC_SPI 96 IRQ_TYPE_NONE>,
> +                            <GIC_SPI 97 IRQ_TYPE_NONE>,
> +                            <GIC_SPI 98 IRQ_TYPE_NONE>,
> +                            <GIC_SPI 99 IRQ_TYPE_NONE>,
> +                            <GIC_SPI 100 IRQ_TYPE_NONE>,
> +                            <GIC_SPI 101 IRQ_TYPE_NONE>;



> +               interrupt-map-mask = <0 0 0 0>;
> +               interrupt-map = <0 0 0 0 &gic GIC_SPI 100 IRQ_TYPE_NONE>;

This interrupt is also listed in the "interrupts" above, which is
probably a mistake, unless the IRQ line is shared between all PCI
devices and the PCI host itself.

> +               bus-range = <0x00 0xFF>;
> +
> +               #address-cells = >;
> +               #size-cells = <2>;
> +               device_type = "pci";
> +               ranges = <0x81000000 0 0          0x28000000 0 0x00010000   /* downstream I/O */
> +                         0x82000000 0 0x20000000 0x20000000 0 0x04000000>; /* non-prefetchable memory */
> +               phy-addr = <5>;
> +       };
> 

	Arnd
