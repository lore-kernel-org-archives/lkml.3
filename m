Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbaGBQju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:39:50 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39619 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755974AbaGBQjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:39:47 -0400
Date: Wed, 2 Jul 2014 17:39:03 +0100
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
Subject: Re: [PATCH 3/3 V2] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
Message-ID: <20140702163903.GA26903@leverpostej>
References: <1404314544-7762-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404314544-7762-1-git-send-email-suravee.suthikulpanit@amd.com>
Thread-Topic: [PATCH 3/3 V2] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 04:22:23PM +0100, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> ARM GICv2m specification extends GICv2 to support MSI(-X) with
> a new set of register frames. This patch introduces support for
> the non-secure GICv2m register frame.
>
> The driver currently matchs "arm,gic-400-plus" in device tree binding,
> which implements GICv2m.

As far as I am aware, "GIC 400 plus" is not a product name.

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
>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> ---
>  Documentation/devicetree/bindings/arm/gic.txt |  19 +-
>  drivers/irqchip/Kconfig                       |   6 +
>  drivers/irqchip/Makefile                      |   1 +
>  drivers/irqchip/irq-gic-v2m.c                 | 248 ++++++++++++++++++++++++++
>  drivers/irqchip/irq-gic-v2m.h                 |  13 ++
>  5 files changed, 284 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/irqchip/irq-gic-v2m.c
>  create mode 100644 drivers/irqchip/irq-gic-v2m.h
>
> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
> index 5573c08..9e46f7f 100644
> --- a/Documentation/devicetree/bindings/arm/gic.txt
> +++ b/Documentation/devicetree/bindings/arm/gic.txt
> @@ -12,11 +12,13 @@ Main node required properties:
>
>  - compatible : should be one of:
>         "arm,gic-400"
> +       "arm,gic-400-plus"

I am not keen on this name.

>         "arm,cortex-a15-gic"
>         "arm,cortex-a9-gic"
>         "arm,cortex-a7-gic"
>         "arm,arm11mp-gic"
>  - interrupt-controller : Identifies the node as an interrupt controller
> +
>  - #interrupt-cells : Specifies the number of cells needed to encode an
>    interrupt source.  The type shall be a <u32> and the value shall be 3.

Random (inconsistent) whitespace change?

> @@ -37,9 +39,16 @@ Main node required properties:
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

As far as I am aware, the MSI interface is completely orthogonal to
having a GICH and GICV.

We should figure out how we expect to handle that (zero-sized reg
entries? reg-names?).

>
>  Optional
>  - interrupts   : Interrupt source of the parent interrupt controller on
> @@ -55,6 +64,10 @@ Optional
>                   by a crossbar/multiplexer preceding the GIC. The GIC irq
>                   input line is assigned dynamically when the corresponding
>                   peripheral's crossbar line is mapped.
> +
> +- msi-controller : Identifies the node as an MSI controller.  This requires
> +  the register region index 4.

That last clarifying comment is more confusing than helpful.

[...]

> +#define GIC_V2M_MIN_SPI                        32
> +#define GIC_V2M_MAX_SPI                        1024

GIC interrupt IDs 1020 and above are reserved, no?

Surely the max ID an SPI can take is 1019?

> +#define GIC_OF_MSIV2M_RANGE_INDEX      4
> +
> +/**
> + * alloc_msi_irq - Allocate MSIs from avaialbe MSI bitmap.
> + * @data: Pointer to v2m_data
> + * @nvec: Number of interrupts to allocate
> + * @irq: Pointer to the allocated irq
> + *
> + * Allocates interrupts only if the contiguous range of MSIs
> + * with specified nvec are available. Otherwise return the number
> + * of available interrupts. If none are available, then returns -ENOENT.
> + */

This function is overly complicated, and pointlessly so.

It doesn't achieve anything useful as it returns the size of the _last_
contiguous block rather than the _largest_ contiguous block, and the
only caller (gicv2m_setup_msi_irq) doesn't even care.

Simplify this to just return an error code if allocation is impossible.

> +static int alloc_msi_irq(struct v2m_data *data, int nvec, int *irq)
> +{
> +       int size = data->nr_spis;
> +       int next = size, i = nvec, ret;

Initialise ret to -ENOENT here...

> +
> +       /* We should never allocate more than available nr_spis */
> +       if (i >= size)
> +               i = size - 1;

...return -ENOENT here...

> +
> +       spin_lock(&data->msi_cnt_lock);
> +
> +       for (; i > 0; i--) {
> +               next = bitmap_find_next_zero_area(data->bm,
> +                                       size, 0, i, 0);
> +               if (next < size)
> +                       break;
> +       }
> +
> +       if (next >= size || i != nvec) {
> +               ret = i ? : -ENOENT;
> +       } else {
> +               bitmap_set(data->bm, next, nvec);
> +               *irq = data->spi_start + next;
> +               ret = 0;
> +       }

...and change this if-else block to:

        if (next < size) {
                bitmap_set(data->bm, next, nvec);
                *irq = data->spi_start + next;
                ret = 0;
        }

> +
> +       spin_unlock(&data->msi_cnt_lock);
> +
> +       return ret;
> +}


[...]

> +static int gicv2m_setup_msi_irq(struct msi_chip *chip, struct pci_dev *pdev,
> +                     struct msi_desc *desc)
> +{
> +       int avail, irq = 0;
> +       struct msi_msg msg;
> +       phys_addr_t addr;
> +       struct v2m_data *data = to_v2m_data(chip);
> +
> +       if (!desc) {
> +               dev_err(&pdev->dev,
> +                       "GICv2m: MSI setup failed. Invalid msi descriptor\n");
> +               return -EINVAL;
> +       }
> +
> +       avail = alloc_msi_irq(data, 1, &irq);
> +       if (avail != 0) {
> +               dev_err(&pdev->dev,
> +                       "GICv2m: MSI setup failed. Cannnot allocate IRQ\n");
> +               return -ENOSPC;
> +       }

As mentioned above, in all failure cases for alloc_msi_irq we simply
return -ENOSPC here, so there's no need for alloc_msi_irq to be so
complicated.

We can move the alloc_msi_irq() call into the test, and get rid of the
avail variable.

> +       irq_set_chip_data(irq, chip);
> +       irq_set_msi_desc(irq, desc);
> +       irq_set_irq_type(irq, IRQ_TYPE_EDGE_RISING);
> +
> +       addr = data->res.start + MSI_SETSPI_NS;
> +
> +       msg.address_hi = (u32)(addr >> 32);
> +       msg.address_lo = (u32)(addr);
> +       msg.data = irq;
> +#ifdef CONFIG_PCI_MSI
> +       write_msi_msg(irq, &msg);
> +#endif

Is it worth doing any of the above if !CONFIG_PCI_MSI?

> +       return 0;
> +}
> +
> +static int __init
> +gicv2m_msi_init(struct device_node *node, struct v2m_data *v2m)
> +{
> +       unsigned int val;
> +
> +       if (of_address_to_resource(node, GIC_OF_MSIV2M_RANGE_INDEX,
> +                                  &v2m->res)) {
> +               pr_err("GICv2m: Failed locate GICv2m MSI register frame\n");
> +               return -EINVAL;
> +       }
> +
> +       v2m->base = of_iomap(node, GIC_OF_MSIV2M_RANGE_INDEX);

of_iomap can return NULL...

> +       /*
> +       * MSI_TYPER:
> +       *     [31:26] Reserved
> +       *     [25:16] lowest SPI assigned to MSI
> +       *     [15:10] Reserved
> +       *     [9:0]   Numer of SPIs assigned to MSI
> +       */
> +       val = readl_relaxed(v2m->base + MSI_TYPER);
> +       if (!val) {
> +               pr_warn("GICv2m: Failed to read MSI_TYPER register\n");
> +               return -EINVAL;
> +       }
> +
> +       v2m->spi_start = (val >> 16) & 0x3ff;
> +       v2m->nr_spis = val & 0x3ff;

Rather than have the comment above the readl_relaxed, Why not define
some macros for these magic numbers and keep the comment with them?

> +
> +       if (v2m->spi_start < GIC_V2M_MIN_SPI ||
> +               v2m->nr_spis >= GIC_V2M_MAX_SPI) {
> +                       pr_err("GICv2m: Init failed\n");
> +                       return -EINVAL;
> +       }

It would be nice to point out why we failed here: the hardware reported
bad values.

> +       v2m->bm = kzalloc(sizeof(long) * BITS_TO_LONGS(v2m->nr_spis),
> +                         GFP_KERNEL);

This looks better than last time :)

[...]

> +       ret = of_pci_msi_chip_add(&gic->msi_chip);
> +       if (ret) {
> +               /* MSI is optional and not supported here */
> +               pr_warn("GICv2m: MSI is not supported.\n");
> +               return 0;
> +       }

Why not pr_info?

Thanks,
Mark.
