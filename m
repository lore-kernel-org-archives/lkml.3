Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031020AbaLLRPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:15:23 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:52469 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030752AbaLLRPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:15:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ray Jui <rjui@broadcom.com>
Cc: linux-arm-kernel@lists.infradead.org, Bjorn Helgaas <bhelgaas@google.com>,
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
Date: Fri, 12 Dec 2014 18:14:32 +0100
Message-ID: <3907917.zNo7yttzkh@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <548B1D98.6030400@broadcom.com>
References: <1418351817-14898-2-git-send-email-rjui@broadcom.com> <3375037.6pjWmlOLA3@wuerfel> <548B1D98.6030400@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:rht4jkvuRqCl5KIdWaAHS1116JDpqBqGo6JhTanWU7Ek5iiE1Pt
 EVPzIjS53ahFK3CL2Fw91wQkMIlQZEsxHQFyWt7drwkV6TzBWTO/77/VEodfr7W2AZ13cyn
 F1a2TXxiKR9CwZXRYjUKflGF+4e/1orZDhUXpv/UOKlp6sdc2WhCt6R7QCquLc+rPu3lJVD
 HfK1m87qRo1/NTA8TLGYw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 December 2014 08:53:44 Ray Jui wrote:
> 
> On 12/12/2014 4:14 AM, Arnd Bergmann wrote:
> > On Thursday 11 December 2014 18:36:54 Ray Jui wrote:
> >> index 0000000..040bc0f
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/pci/brcm,iproc-pcie.txt
> >> @@ -0,0 +1,74 @@
> >> +* Broadcom iProc PCIe controller
> >> +
> >> +Required properties:
> >> +- compatible: Must be "brcm,iproc-pcie"
> >> +- reg: base address and length of the PCIe controller and the MDIO interface
> >> +  that controls the PCIe PHY
> >> +- #interrupt-cells: set to <1>
> >> +- interrupts: interrupt IDs
> >
> > How many, and what are they?
> >
> Different iProc SoCs might have different number of interrupts. I'll 
> elaborate more on the next patch.

Ok.

> >> +- interrupt-map-mask and interrupt-map, standard PCI properties to define the
> >> +  mapping of the PCIe interface to interrupt numbers
> >> +- bus-range: PCI bus numbers covered
> >> +- #address-cells: set to <3>
> >> +- #size-cells: set to <2>
> >> +- device_type: set to "pci"
> >> +- ranges: ranges for the PCI memory and I/O regions
> >> +- phy-addr: MDC/MDIO adddress of the PCIe PHY
> >
> > It looks like the phy controller is separate from the PCI controller,
> > and you even list the same register range for both PHYs. Better make
> > that a separate driver and put the phy address into the "phys" reference.
> >
> Okay. In this case, I need to create a separate PHY driver under the 
> drivers/phy directory and have the PCIe host driver reference it through 
> the standard PHY API.

Yes, that is what I meant. In particular, that has the advantage of letting
you reuse the two drivers separately if some new SoC comes up that uses
one but not the other. A lot of PHY implementations can support multiple
protocols (e.g. pcie and usb3), but I don't know if yours does.

> >> +- have-msi-inten-reg: Required for legacy iProc PCIe controllers that need the
> >> +  MSI interrupt enable register to be set explicitly
> >> +
> >> +The Broadcom iProc PCie driver adapts the multi-domain structure, i.e., each
> >> +interface has its own domain and therefore has its own device node
> >> +Example:
> >> +
> >> +SoC specific DT Entry:
> >> +
> >> +       pcie0: pcie@18012000 {
> >> +               compatible = "brcm,iproc-pcie";
> >> +               reg = <0x18012000 0x1000>,
> >> +                       <0x18002000 0x1000>;
> >
> > I guess the addresses should be relative to the BCMA bus, and this node
> > get moved under that. Please see Hauke's patch series, we've discussed
> > this in great length already.
> >
> 
> As Arend van Spriel pointed out in the previous discussion:
> 
> BCMA core is the bus driver for discoverable ARM AXI interconnect. Apart 
> from that it also provides drivers for some cores. For the chips to be 
> discoverable it needs additional IP logic.
> 
> Not all iProc family of SoCs have the additional IP logic and for those 
> which don't, they cannot use the BCMA bus.

Ok, but the one from your example almost certainly does because the
addresses are exactly the same ones as on bcm53xx.

The same problem likely occurs on other peripherals, not just PCI,
so we will have to come up with a way to have a common driver for
bcma_bus and platform_bus for USB, SPI, brcmsmac, and likely others
too.

> >> +               #interrupt-cells = <1>;
> >> +               interrupts = <GIC_SPI 96 IRQ_TYPE_NONE>,
> >> +                            <GIC_SPI 97 IRQ_TYPE_NONE>,
> >> +                            <GIC_SPI 98 IRQ_TYPE_NONE>,
> >> +                            <GIC_SPI 99 IRQ_TYPE_NONE>,
> >> +                            <GIC_SPI 100 IRQ_TYPE_NONE>,
> >> +                            <GIC_SPI 101 IRQ_TYPE_NONE>;
> >
> >
> >
> >> +               interrupt-map-mask = <0 0 0 0>;
> >> +               interrupt-map = <0 0 0 0 &gic GIC_SPI 100 IRQ_TYPE_NONE>;
> >
> > This interrupt is also listed in the "interrupts" above, which is
> > probably a mistake, unless the IRQ line is shared between all PCI
> > devices and the PCI host itself.
> >
> interrupts are for MSI interrupt support and interrupt-map is for legacy 
> INTx support. To my best knowledge, MSI and INTx cannot be used at the 
> same time. "nvidia,tegra20-pcie.txt" and "rcar-pci.txt" have similar 
> configurations.

Linux drivers will absolutely use MSI and legacy interrupts together, because
some drivers don't support MSI and others enable it unconditionally.

In both your examples (tegra and rcar), the interrupts that share the same
number are auxiliary and are correctly used with IRQF_SHARED, so that works.
If a device MSI just maps to a host IRQ however, you wouldn't be able to
use IRQF_SHARED.

	Arnd
