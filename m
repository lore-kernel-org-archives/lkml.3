Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbaFXKMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:12:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53556 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713AbaFXKM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:12:29 -0400
Date: Tue, 24 Jun 2014 11:11:11 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] arm/gic: Add supports for GICv2m MSI(-X)
Message-ID: <20140624101111.GD5856@leverpostej>
References: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1403569980-12913-3-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403569980-12913-3-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 01:33:00AM +0100, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> GICv2m extends GICv2 to support MSI(-X) with a new set of register frames.
> 
> This patch introduces support for the non-secure GICv2m register frame.
> This is optional. It uses the "msi-controller" keyword in ARM GIC
> devicetree binding to indentify GIC driver that it should enable MSI(-X)
> support, The region of GICv2m MSI register frame is specified using the register
> frame index 4 in the device tree.
> 
> Each GIC maintains an "msi_chip" structure. To discover the msi_chip,
> PCI host driver can do the following:
> 
>     struct device_node *gic_node = of_irq_find_parent(pdev->dev.of_node);
>     pcie_bus->msi_chip = of_pci_find_msi_chip_by_node(gic_node);
> 
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> ---
>  Documentation/devicetree/bindings/arm/gic.txt |  18 +-
>  drivers/irqchip/Kconfig                       |   6 +
>  drivers/irqchip/Makefile                      |   1 +
>  drivers/irqchip/gic-msi-v2m.c                 | 249 ++++++++++++++++++++++++++
>  drivers/irqchip/gic-msi-v2m.h                 |  20 +++
>  drivers/irqchip/irq-gic.c                     |  21 ++-
>  6 files changed, 311 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/irqchip/gic-msi-v2m.c
>  create mode 100644 drivers/irqchip/gic-msi-v2m.h
> 
> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
> index 5573c08..ee4bc02 100644
> --- a/Documentation/devicetree/bindings/arm/gic.txt
> +++ b/Documentation/devicetree/bindings/arm/gic.txt
> @@ -17,6 +17,7 @@ Main node required properties:
>         "arm,cortex-a7-gic"
>         "arm,arm11mp-gic"
>  - interrupt-controller : Identifies the node as an interrupt controller
> +
>  - #interrupt-cells : Specifies the number of cells needed to encode an
>    interrupt source.  The type shall be a <u32> and the value shall be 3.
> 
> @@ -37,9 +38,16 @@ Main node required properties:
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
> 
>  Optional
>  - interrupts   : Interrupt source of the parent interrupt controller on
> @@ -55,6 +63,10 @@ Optional
>                   by a crossbar/multiplexer preceding the GIC. The GIC irq
>                   input line is assigned dynamically when the corresponding
>                   peripheral's crossbar line is mapped.
> +
> +- msi-controller : Identifies the node as an MSI controller.  This requires
> +  the register region index 4.
> +
>  Example:
> 
>         intc: interrupt-controller@fff11000 {
> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> index bbb746e..a36bf94 100644
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -7,6 +7,12 @@ config ARM_GIC
>         select IRQ_DOMAIN
>         select MULTI_IRQ_HANDLER
> 
> +config ARM_GIC_MSI_V2M
> +       bool
> +       select IRQ_DOMAIN
> +       select MULTI_IRQ_HANDLER
> +       depends on PCI && PCI_MSI
> +
>  config GIC_NON_BANKED
>         bool
> 
> diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
> index 62a13e5..d43f904 100644
> --- a/drivers/irqchip/Makefile
> +++ b/drivers/irqchip/Makefile
> @@ -16,6 +16,7 @@ obj-$(CONFIG_ARCH_SUNXI)              += irq-sun4i.o
>  obj-$(CONFIG_ARCH_SUNXI)               += irq-sunxi-nmi.o
>  obj-$(CONFIG_ARCH_SPEAR3XX)            += spear-shirq.o
>  obj-$(CONFIG_ARM_GIC)                  += irq-gic.o
> +obj-$(CONFIG_ARM_GIC_MSI_V2M)          += gic-msi-v2m.o
>  obj-$(CONFIG_ARM_NVIC)                 += irq-nvic.o
>  obj-$(CONFIG_ARM_VIC)                  += irq-vic.o
>  obj-$(CONFIG_IMGPDC_IRQ)               += irq-imgpdc.o
> diff --git a/drivers/irqchip/gic-msi-v2m.c b/drivers/irqchip/gic-msi-v2m.c
> new file mode 100644
> index 0000000..e5c0f79
> --- /dev/null
> +++ b/drivers/irqchip/gic-msi-v2m.c
> @@ -0,0 +1,249 @@
> +/*
> + * ARM GIC v2m MSI support
> + * Support for Message Signalelled Interrupts for systems that
> + * implement ARM Generic Interrupt Controller: GICv2m.
> + *
> + * Copyright (C) 2014 Advanced Micro Devices, Inc.
> + * Authors: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> + *          Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>
> + *          Brandon Anderson <brandon.anderson@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pci.h>
> +#include <linux/irq.h>
> +#include <linux/spinlock.h>
> +#include <linux/slab.h>
> +#include <linux/of_address.h>
> +#include <linux/bitmap.h>
> +
> +#include "gic-msi-v2m.h"
> +
> +/* GICv2m MSI Registers */
> +#define MSI_TYPER                      0x008
> +#define MSI_SETSPI_NS                  0x040
> +#define GIC_V2M_MIN_SPI                        32
> +#define GIC_V2M_MAX_SPI                        1024
> +#define GIC_OF_MSIV2M_RANGE_INDEX      4
> +
> +extern struct irq_chip gic_arch_extn;

Shouldn't this have come from a header somewhere?

> +
> +/**
> + * alloc_msi_irq - Allocate MSIs from avaialbe MSI bitmap.
> + * @data: Pointer to gicv2m_msi_data
> + * @nvec: Number of interrupts to allocate
> + * @irq: Pointer to the allocated irq
> + *
> + * Allocates interrupts only if the contiguous range of MSIs
> + * with specified nvec are avaiable. Otherwise return the number
> + * of avaiable interrupts. If none is avaiable, then returns -ENOENT.

%s/avaiable/available/

s/none is/none are/

> + */
> +static int alloc_msi_irq(struct gicv2m_msi_data *data, int nvec, int *irq)
> +{
> +       int size = sizeof(unsigned long) * data->bm_sz;

You already have the precise number you need: data->max_spi_cnt.

> +       int next = size, ret, num;
> +
> +       spin_lock(&data->msi_cnt_lock);
> +
> +       for (num = nvec; num > 0; num--) {

s/num/i/

> +               next = bitmap_find_next_zero_area(data->bm,
> +                                       size, 0, num, 0);
> +               if (next < size)
> +                       break;
> +       }

If max_spi_cnt is not a multiple of BITS_PER_LONG, this can allocate a
number greater or equal to max_spi_cnt, but below size. We should never
allocate max_spi_cnt or above.

> +
> +       if (next < size) {
> +               bitmap_set(data->bm, next, nvec);
> +               *irq = data->spi_start + next;
> +               ret = 0;
> +       } else if (num != 0) {
> +               ret = num;
> +       } else {
> +               ret = -ENOENT;
> +       }
> +
> +

Nit: extraneous whitespace.

> +       spin_unlock(&data->msi_cnt_lock);
> +
> +       return ret;
> +}
> +
> +static void free_msi_irq(struct gicv2m_msi_data *data, unsigned int irq)
> +{
> +       int pos;
> +
> +       spin_lock(&data->msi_cnt_lock);
> +
> +       pos = irq - data->spi_start;
> +       if (pos >= 0 && pos < data->max_spi_cnt)

Should either of these cases ever happen?

> +               bitmap_clear(data->bm, pos, 1);
> +
> +       spin_unlock(&data->msi_cnt_lock);
> +}
> +
> +static inline struct gicv2m_msi_data *to_gicv2m_msi_data(struct msi_chip *chip)
> +{
> +       return container_of(chip, struct gicv2m_msi_data, chip);
> +}
> +
> +static void gicv2m_teardown_msi_irq(struct msi_chip *chip, unsigned int irq)
> +{
> +       free_msi_irq(to_gicv2m_msi_data(chip), irq);
> +}
> +
> +static int gicv2m_setup_msi_irq(struct msi_chip *chip, struct pci_dev *pdev,
> +                     struct msi_desc *desc)
> +{
> +       int avail, irq = 0;
> +       struct msi_msg msg;
> +       phys_addr_t addr;
> +       struct gicv2m_msi_data *data = to_gicv2m_msi_data(chip);
> +
> +       if (data == NULL) {

If container_of returns NULL, you have bigger problems.

> +               dev_err(&pdev->dev,
> +                       "GICv2m: MSI setup failed. Invalid platform data\n");
> +               return -EINVAL;
> +       }
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
> +
> +       irq_set_msi_desc(irq, desc);
> +       irq_set_irq_type(irq, IRQ_TYPE_EDGE_RISING);
> +
> +       addr = (unsigned long)(data->paddr64 + MSI_SETSPI_NS);

Why the cast?

> +       msg.address_hi = (unsigned int)(addr >> 32);
> +       msg.address_lo = (unsigned int)(addr);

Use u32, it makes this clearer (and matches the types in the definition
of struct msi_msg).

> +       msg.data = irq;
> +#ifdef CONFIG_PCI_MSI
> +       write_msi_msg(irq, &msg);
> +#endif
> +
> +       return 0;
> +}
> +
> +static void gicv2m_mask_msi(struct irq_data *d)
> +{
> +       if (d->msi_desc)
> +               mask_msi_irq(d);
> +}
> +
> +static void gicv2m_unmask_msi(struct irq_data *d)
> +{
> +       if (d->msi_desc)
> +               unmask_msi_irq(d);
> +}
> +
> +int __init gicv2m_msi_init(struct device_node *node,
> +                          struct gicv2m_msi_data *msi)
> +{
> +       unsigned int val;
> +       const __be32 *msi_be;

Every time I see a __be32* in a DT probe function I weep. There is no
need to deal with the internal details of the DTB.

> +
> +       msi_be = of_get_address(node, GIC_OF_MSIV2M_RANGE_INDEX, NULL, NULL);
> +       if (!msi_be) {
> +               pr_err("GICv2m failed. Fail to locate MSI base.\n");
> +               return -EINVAL;
> +       }
> +
> +       msi->paddr64 = of_translate_address(node, msi_be);
> +       msi->base = of_iomap(node, GIC_OF_MSIV2M_RANGE_INDEX);

You can instead use of_address_to_resource to query the address from the
DTB once, without having to muck about with endianness conversion
manually. Take a look at what of_iomap does.

I'm surprised we don't have an ioremap_resource given we have a devm_
variant.

> +
> +       /*
> +       * MSI_TYPER:
> +       *     [31:26] Reserved
> +       *     [25:16] lowest SPI assigned to MSI
> +       *     [15:10] Reserved
> +       *     [9:0]   Numer of SPIs assigned to MSI
> +       */
> +       val = __raw_readl(msi->base + MSI_TYPER);

Are you sure you want to use __raw_readl?

> +       if (!val) {
> +               pr_warn("GICv2m: Failed to read MSI_TYPER register\n");
> +               return -EINVAL;
> +       }
> +
> +       msi->spi_start = (val >> 16) & 0x3ff;
> +       msi->max_spi_cnt = val & 0x3ff;
> +
> +       pr_debug("GICv2m: SPI = %u, cnt = %u\n",
> +               msi->spi_start, msi->max_spi_cnt);
> +
> +       if (msi->spi_start < GIC_V2M_MIN_SPI ||
> +               msi->max_spi_cnt >= GIC_V2M_MAX_SPI) {
> +                       pr_err("GICv2m: Init failed\n");
> +                       return -EINVAL;
> +       }
> +
> +       msi->bm_sz = BITS_TO_LONGS(msi->max_spi_cnt);

So msi->bm_sz is msi->max_spi_cnt in _longs_ (rounded up)...

> +       msi->bm = kzalloc(msi->bm_sz, GFP_KERNEL);

...yet we allocate that many _bytes_?

> +       if (!msi->bm)
> +               return -ENOMEM;
> +
> +       spin_lock_init(&msi->msi_cnt_lock);
> +
> +       msi->chip.owner = THIS_MODULE;
> +       msi->chip.of_node = node;
> +       msi->chip.setup_irq = gicv2m_setup_msi_irq;
> +       msi->chip.teardown_irq = gicv2m_teardown_msi_irq;
> +
> +       pr_info("GICv2m: SPI range [%d:%d]\n",
> +               msi->spi_start, (msi->spi_start + msi->max_spi_cnt));

You have a (redundant) pr_debug for this above.

> +
> +       gic_arch_extn.irq_mask = gicv2m_mask_msi;
> +       gic_arch_extn.irq_unmask = gicv2m_unmask_msi;

I'll leave others to comment on the validity of this...

> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(gicv2m_msi_init);

Why?

> +
> +
> +
> +/**
> + * Override arch_setup_msi_irq in drivers/pci/msi.c
> + * since we don't want to change the chip_data
> + */
> +int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
> +{
> +       struct msi_chip *chip = pdev->bus->msi;
> +
> +       if (!chip || !chip->setup_irq)
> +               return -EINVAL;
> +
> +       return chip->setup_irq(chip, pdev, desc);
> +}
> +
> +/**
> + * Override arch_teardown_msi_irq in drivers/pci/msi.c
> + */
> +void arch_teardown_msi_irq(unsigned int irq)
> +{
> +       struct msi_desc *desc;
> +       struct msi_chip *chip;
> +
> +       desc = irq_get_msi_desc(irq);
> +       if (!desc)
> +               return;
> +
> +       chip = desc->dev->bus->msi;
> +       if (!chip)
> +               return;
> +
> +       chip->teardown_irq(chip, irq);
> +}
> diff --git a/drivers/irqchip/gic-msi-v2m.h b/drivers/irqchip/gic-msi-v2m.h
> new file mode 100644
> index 0000000..164d929
> --- /dev/null
> +++ b/drivers/irqchip/gic-msi-v2m.h
> @@ -0,0 +1,20 @@
> +#ifndef GIC_MSI_V2M_H
> +#define GIC_MSI_V2M_H
> +
> +#include <linux/msi.h>
> +
> +struct gicv2m_msi_data {
> +       struct msi_chip chip;
> +       spinlock_t msi_cnt_lock;
> +       u64 paddr64;              /* GICv2m phys address */

phys_addr_t?

> +       void __iomem *base;       /* GICv2m virt address */
> +       unsigned int spi_start;   /* The SPI number that MSIs start */
> +       unsigned int max_spi_cnt; /* The number of SPIs for MSIs */
> +       unsigned long *bm;        /* MSI vector bitmap */
> +       unsigned long bm_sz;      /* MSI bitmap size */

It's a bit odd in my mind that this is in longs. Why not just use
max_spi_cnt, which you can trivially use to determine bytes or longs?

Also, s/max_spi_cnt/nr_spis/. 

> +};
> +
> +extern int gicv2m_msi_init(struct device_node *node,
> +                          struct gicv2m_msi_data *msi) __init;
> +
> +#endif /*GIC_MSI_V2M_H*/
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index adc86de..dcff99b 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -35,6 +35,7 @@
>  #include <linux/of.h>
>  #include <linux/of_address.h>
>  #include <linux/of_irq.h>
> +#include <linux/of_pci.h>
>  #include <linux/irqdomain.h>
>  #include <linux/interrupt.h>
>  #include <linux/percpu.h>
> @@ -48,6 +49,10 @@
> 
>  #include "irqchip.h"
> 
> +#ifdef CONFIG_ARM_GIC_MSI_V2M
> +#include "gic-msi-v2m.h"
> +#endif
> +
>  union gic_base {
>         void __iomem *common_base;
>         void __percpu * __iomem *percpu_base;
> @@ -68,6 +73,9 @@ struct gic_chip_data {
>  #ifdef CONFIG_GIC_NON_BANKED
>         void __iomem *(*get_base)(union gic_base *);
>  #endif
> +#ifdef CONFIG_ARM_GIC_MSI_V2M
> +       struct gicv2m_msi_data msi_data;
> +#endif
>  };
> 
>  static DEFINE_RAW_SPINLOCK(irq_controller_lock);
> @@ -246,7 +254,8 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
>                             bool force)
>  {
>         void __iomem *reg = gic_dist_base(d) + GIC_DIST_TARGET + (gic_irq(d) & ~3);
> -       unsigned int cpu, shift = (gic_irq(d) % 4) * 8;
> +       unsigned int shift = (gic_irq(d) % 4) * 8;
> +       unsigned int cpu = cpumask_any_and(mask_val, cpu_online_mask);

Unrelated change?

>         u32 val, mask, bit;
> 
>         if (!force)
> @@ -1047,6 +1056,7 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>         void __iomem *dist_base;
>         u32 percpu_offset;
>         int irq;
> +       struct gic_chip_data *gic;
> 
>         if (WARN_ON(!node))
>                 return -ENODEV;
> @@ -1068,6 +1078,15 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>                 irq = irq_of_parse_and_map(node, 0);
>                 gic_cascade_irq(gic_cnt, irq);
>         }
> +
> +#ifdef CONFIG_ARM_GIC_MSI_V2M
> +       if (of_find_property(node, "msi-controller", NULL)) {

Use of_property_read_bool for booleans.

Thanks,
Mark.
