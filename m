Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaHNR4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:56:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60176 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498AbaHNR4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:56:13 -0400
Date: Thu, 14 Aug 2014 18:55:26 +0100
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
Subject: Re: [PATCH 1/2 V4] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
Message-ID: <20140814175525.GI24018@leverpostej>
References: <1407942041-3291-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1407942041-3291-2-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407942041-3291-2-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 04:00:40PM +0100, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> ARM GICv2m specification extends GICv2 to support MSI(-X) with
> a new set of register frame. This patch introduces support for
> the non-secure GICv2m register frame. Currently, GICV2m is available
> in certain version of GIC-400.
> 
> The patch introduces a new property in ARM gic binding, the v2m subnode.
> It is optional.
> 
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Cc: Mark Rutland <Mark.Rutland@arm.com>
> Cc: Marc Zyngier <Marc.Zyngier@arm.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Catalin Marinas <Catalin.Marinas@arm.com>
> Cc: Will Deacon <Will.Deacon@arm.com>
> ---
>  Documentation/devicetree/bindings/arm/gic.txt |  32 ++++
>  drivers/irqchip/Kconfig                       |   7 +
>  drivers/irqchip/Makefile                      |   1 +
>  drivers/irqchip/irq-gic-v2m.c                 | 215 ++++++++++++++++++++++++++
>  drivers/irqchip/irq-gic.c                     |  75 +++++----
>  drivers/irqchip/irq-gic.h                     |  48 ++++++
>  6 files changed, 348 insertions(+), 30 deletions(-)
>  create mode 100644 drivers/irqchip/irq-gic-v2m.c
>  create mode 100644 drivers/irqchip/irq-gic.h
> 
> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
> index 5573c08..8a64179 100644
> --- a/Documentation/devicetree/bindings/arm/gic.txt
> +++ b/Documentation/devicetree/bindings/arm/gic.txt
> @@ -95,3 +95,35 @@ Example:
>                       <0x2c006000 0x2000>;
>                 interrupts = <1 9 0xf04>;
>         };
> +
> +
> +* GICv2m extension for MSI/MSI-x support (Optional)
> +
> +Certain revision of GIC-400 supports MSI/MSI-x via V2M register frame.
> +This is enabled by specifying v2m sub-node.
> +
> +Required properties:
> +
> +- msi-controller : Identifies the node as an MSI controller.
> +
> +- reg : GICv2m MSI interface register base and size
> +
> +Example:
> +
> +       interrupt-controller@e1101000 {
> +               compatible = "arm,gic-400";
> +               #interrupt-cells = <3>;
> +               #address-cells = <2>;
> +               #size-cells = <2>;
> +               interrupt-controller;
> +               interrupts = <1 8 0xf04>;
> +               ranges = <0 0 0 0xe1100000 0 0x100000>;
> +               reg = <0x0 0xe1110000 0 0x01000>,
> +                     <0x0 0xe112f000 0 0x02000>,
> +                     <0x0 0xe1140000 0 0x10000>,
> +                     <0x0 0xe1160000 0 0x10000>;
> +               v2m {
> +                       msi-controller;
> +                       reg = <0x0 0x80000 0 0x1000>;
> +               };
> +       };

[...]

> @@ -1009,6 +1012,16 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>         if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
>                 percpu_offset = 0;
> 
> +       gic_data[gic_cnt].irq_chip = &gic_chip;
> +
> +       /* Currently, we only support one v2m subnode. */
> +       child = of_get_child_by_name(node, "v2m");
> +       if (child) {
> +               ret = gicv2m_of_init(child, &gic_data[gic_cnt]);
> +               if (ret)
> +                       return ret;
> +       }

I can't see how you'd sanely expand this to multiple children, which was
the main point of having a separate node for the M block.

Give the M block a compatible string and look for children with that
string.

Thanks,
Mark.
