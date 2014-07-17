Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679AbaGQNSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:18:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56806 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932498AbaGQNSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:18:47 -0400
Date: Thu, 17 Jul 2014 14:17:58 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/4 V3] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
Message-ID: <20140717131758.GK30313@leverpostej>
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1404947104-21345-4-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404947104-21345-4-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suravee,

Apologies for the late reply on this one. I was hoping that Marc would
be able to take another look at this, but he's away at present.

On Thu, Jul 10, 2014 at 12:05:03AM +0100, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> ARM GICv2m specification extends GICv2 to support MSI(-X) with
> a new set of register frames. This patch introduces support for
> the non-secure GICv2m register frame.
> 
> The driver currently matchs "arm,gic-400-plus" in device tree binding,
> which implements GICv2m.
> 
> The "msi-controller" keyword in ARM GIC devicetree binding is used to indentify
> GIC driver that it should enable MSI(-X) support, The region of GICv2m MSI
> register frame is specified using the register frame index 4 in the device tree.
> MSI support is optional.
> 
> Each GIC maintains an "msi_chip" structure. To discover the msi_chip,
> PCI host driver can do the following:
> 
>     struct device_node *gic_node = of_irq_find_parent(pdev->dev.of_node);
>     pcie_bus->msi_chip = of_pci_find_msi_chip_by_node(gic_node);
> 
> Cc: Mark Rutland <Mark.Rutland@arm.com>
> Cc: Marc Zyngier <Marc.Zyngier@arm.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Catalin Marinas <Catalin.Marinas@arm.com>
> Cc: Will Deacon <Will.Deacon@arm.com>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> ---
>  Documentation/devicetree/bindings/arm/gic.txt |  20 +-
>  arch/arm64/Kconfig                            |   1 +
>  drivers/irqchip/Kconfig                       |   7 +
>  drivers/irqchip/Makefile                      |   1 +
>  drivers/irqchip/irq-gic-v2m.c                 | 251 ++++++++++++++++++++++++++
>  drivers/irqchip/irq-gic-v2m.h                 |  13 ++
>  drivers/irqchip/irq-gic.c                     |  23 ++-
>  drivers/irqchip/irq-gic.h                     |  31 +++-
>  8 files changed, 334 insertions(+), 13 deletions(-)
>  create mode 100644 drivers/irqchip/irq-gic-v2m.c
>  create mode 100644 drivers/irqchip/irq-gic-v2m.h
> 
> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
> index 5573c08..d2eea0b 100644
> --- a/Documentation/devicetree/bindings/arm/gic.txt
> +++ b/Documentation/devicetree/bindings/arm/gic.txt
> @@ -12,11 +12,14 @@ Main node required properties:
> 
>  - compatible : should be one of:
>         "arm,gic-400"
> +       "arm,gic-400-v2m"

I'm still not entirely comfortable about this, as I was under the
impression that the MSI frame was a block on the side of the GIC rather
than being a composite entity with the rest of the GIC.

Which means that it would be entirely possible to attach multiple copies
of that block, which this binding doesn't cover.

>         "arm,cortex-a15-gic"
>         "arm,cortex-a9-gic"
>         "arm,cortex-a7-gic"
>         "arm,arm11mp-gic"
> +
>  - interrupt-controller : Identifies the node as an interrupt controller
> +
>  - #interrupt-cells : Specifies the number of cells needed to encode an
>    interrupt source.  The type shall be a <u32> and the value shall be 3.
> 
> @@ -37,9 +40,16 @@ Main node required properties:
>         the 8 possible cpus attached to the GIC.  A bit set to '1' indicated
>         the interrupt is wired to that CPU.  Only valid for PPI interrupts.
> 
> -- reg : Specifies base physical address(s) and size of the GIC registers. The
> -  first region is the GIC distributor register base and size. The 2nd region is
> -  the GIC cpu interface register base and size.
> +- reg : Specifies base physical address(s) and size of the GIC register frames.
> +
> +  Region | Description
> +  Index  |
> +  -------------------------------------------------------------------
> +     0   | GIC distributor register base and size
> +     1   | GIC cpu interface register base and size
> +     2   | VGIC interface control register base and size (Optional)
> +     3   | VGIC CPU interface register base and size (Optional)
> +     4   | GICv2m MSI interface register base and size (Optional)

And describing it as a separate (but related) component would get around
the issue of orthogonality with the GICV and GICH registers.

Nit: can we use the architected prefixes here please? GICC, GICD, GICH,
and GICV respectively for indexes 0-3.

Cheers,
Mark.
