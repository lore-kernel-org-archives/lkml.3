Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbaKCJuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:50:54 -0500
Received: from service87.mimecast.com ([91.220.42.44]:57633 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaKCJuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:50:51 -0500
Message-ID: <54574FF7.706@arm.com>
Date: Mon, 03 Nov 2014 09:50:47 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [V9 PATCH 2/2] irqchip: gicv2m: Add supports for ARM GICv2m MSI(-X)
References: <1414743990-28421-1-git-send-email-suravee.suthikulpanit@amd.com> <1414743990-28421-3-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1414743990-28421-3-git-send-email-suravee.suthikulpanit@amd.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 03 Nov 2014 09:50:48.0011 (UTC) FILETIME=[A50379B0:01CFF74B]
X-MC-Unique: 114110309504803801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suravee,

On 31/10/14 08:26, suravee.suthikulpanit@amd.com wrote:
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
> Cc: Marc Zyngier <Marc.Zyngier@arm.com>
> Cc: Mark Rutland <Mark.Rutland@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Will Deacon <Will.Deacon@arm.com>
> Cc: Catalin Marinas <Catalin.Marinas@arm.com>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> ---
>  Documentation/devicetree/bindings/arm/gic.txt |  53 ++++
>  arch/arm64/Kconfig                            |   1 +
>  drivers/irqchip/Kconfig                       |   5 +
>  drivers/irqchip/Makefile                      |   1 +
>  drivers/irqchip/irq-gic-v2m.c                 | 395 ++++++++++++++++++++++++++
>  drivers/irqchip/irq-gic-v2m.h                 |   7 +
>  drivers/irqchip/irq-gic.c                     |  21 +-
>  7 files changed, 479 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
> index c7d2fa1..ebf976a 100644
> --- a/Documentation/devicetree/bindings/arm/gic.txt
> +++ b/Documentation/devicetree/bindings/arm/gic.txt
> @@ -96,3 +96,56 @@ Example:
>                       <0x2c006000 0x2000>;
>                 interrupts = <1 9 0xf04>;
>         };
> +
> +
> +* GICv2m extension for MSI/MSI-x support (Optional)
> +
> +Certain revisions of GIC-400 supports MSI/MSI-x via V2M register frame(s).
> +This is enabled by specifying v2m sub-node(s).
> +
> +Required properties:
> +
> +- compatible        : The value here should contain "arm,gic-v2m-frame".
> +
> +- msi-controller    : Identifies the node as an MSI controller.
> +
> +- reg               : GICv2m MSI interface register base and size
> +
> +Optional properties:
> +
> +- arm,msi-base-spi  : When the MSI_TYPER register contains an incorrect
> +                      value, this property should contain the SPI base of
> +                      the MSI frame, overriding the HW value.
> +
> +- arm,msi-num-spis  : When the MSI_TYPER register contains an incorrect
> +                      value, this property should contain the number of
> +                      SPIs assigned to the frame, overriding the HW value.
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
> +               v2m0: v2m@0x8000 {
> +                       compatible = "arm,gic-v2m-frame";
> +                       msi-controller;
> +                       reg = <0x0 0x80000 0 0x1000>;
> +               };
> +
> +               ....
> +
> +               v2mN: v2m@0x9000 {
> +                       compatible = "arm,gic-v2m-frame";
> +                       msi-controller;
> +                       reg = <0x0 0x90000 0 0x1000>;
> +               };
> +       };
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index cde2f72..cbcde2d 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -12,6 +12,7 @@ config ARM64
>         select ARM_ARCH_TIMER
>         select ARM_GIC
>         select AUDIT_ARCH_COMPAT_GENERIC
> +       select ARM_GIC_V2M
>         select ARM_GIC_V3
>         select BUILDTIME_EXTABLE_SORT
>         select CLONE_BACKWARDS
> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> index 2a48e0a..39ce065 100644
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -8,6 +8,11 @@ config ARM_GIC
>         select IRQ_DOMAIN_HIERARCHY
>         select MULTI_IRQ_HANDLER
> 
> +config ARM_GIC_V2M
> +       bool
> +       depends on ARM_GIC
> +       depends on PCI && PCI_MSI
> +
>  config GIC_NON_BANKED
>         bool
> 
> diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
> index 73052ba..3bda951 100644
> --- a/drivers/irqchip/Makefile
> +++ b/drivers/irqchip/Makefile
> @@ -17,6 +17,7 @@ obj-$(CONFIG_ARCH_SUNXI)              += irq-sun4i.o
>  obj-$(CONFIG_ARCH_SUNXI)               += irq-sunxi-nmi.o
>  obj-$(CONFIG_ARCH_SPEAR3XX)            += spear-shirq.o
>  obj-$(CONFIG_ARM_GIC)                  += irq-gic.o irq-gic-common.o
> +obj-$(CONFIG_ARM_GIC_V2M)              += irq-gic-v2m.o
>  obj-$(CONFIG_ARM_GIC_V3)               += irq-gic-v3.o irq-gic-common.o
>  obj-$(CONFIG_ARM_NVIC)                 += irq-nvic.o
>  obj-$(CONFIG_ARM_VIC)                  += irq-vic.o
> diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
> new file mode 100644
> index 0000000..d82b668
> --- /dev/null
> +++ b/drivers/irqchip/irq-gic-v2m.c
> @@ -0,0 +1,395 @@
> +/*
> + * ARM GIC v2m MSI(-X) support
> + * Support for Message Signaled Interrupts for systems that
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
> +#define pr_fmt(fmt) "GICv2m: " fmt
> +
> +#include <linux/bitmap.h>
> +#include <linux/irq.h>
> +#include <linux/irqdomain.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_address.h>
> +#include <linux/of_pci.h>
> +#include <linux/pci.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +
> +#include <asm/hardirq.h>
> +#include <asm/irq.h>
> +
> +#include "irqchip.h"
> +#include "irq-gic-v2m.h"
> +
> +/*
> +* MSI_TYPER:
> +*     [31:26] Reserved
> +*     [25:16] lowest SPI assigned to MSI
> +*     [15:10] Reserved
> +*     [9:0]   Numer of SPIs assigned to MSI
> +*/
> +#define V2M_MSI_TYPER                  0x008
> +#define V2M_MSI_TYPER_BASE_SHIFT       16
> +#define V2M_MSI_TYPER_BASE_MASK                0x3FF
> +#define V2M_MSI_TYPER_NUM_MASK         0x3FF
> +#define V2M_MSI_SETSPI_NS              0x040
> +#define V2M_MIN_SPI                    32
> +#define V2M_MAX_SPI                    1019
> +
> +#define V2M_MSI_TYPER_BASE_SPI(x)      \
> +               (((x) >> V2M_MSI_TYPER_BASE_SHIFT) & V2M_MSI_TYPER_BASE_MASK)
> +
> +#define V2M_MSI_TYPER_NUM_SPI(x)       ((x) & V2M_MSI_TYPER_NUM_MASK)
> +
> +struct v2m_data {
> +       struct list_head list;
> +       spinlock_t msi_cnt_lock;
> +       struct msi_chip msi_chip;
> +       struct resource res;      /* GICv2m resource */
> +       void __iomem *base;       /* GICv2m virt address */
> +       unsigned int spi_start;   /* The SPI number that MSIs start */
> +       unsigned int nr_spis;     /* The number of SPIs for MSIs */
> +       unsigned long *bm;        /* MSI vector bitmap */
> +       struct irq_domain *domain;
> +};
> +
> +static struct irq_chip v2m_chip;
> +
> +/*
> + * alloc_msi_irq - Allocate MSIs from available MSI bitmap.
> + * @data: Pointer to v2m_data
> + * @nvec: Number of interrupts to allocate
> + * @irq: Pointer to the allocated irq
> + *
> + * Allocates interrupts only if the contiguous range of MSIs
> + * with specified nvec are available. Otherwise return the number
> + * of available interrupts. If none are available, then returns -ENOENT.
> + */
> +static int alloc_msi_irq(struct v2m_data *data, int nvec, int *irq)
> +{
> +       int size = data->nr_spis;
> +       int next = size, i = nvec, ret;
> +
> +       /* We should never allocate more than available nr_spis */
> +       if (i >= size)
> +               i = size;
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
> +       if (i != nvec) {
> +               ret = i ? : -ENOENT;
> +       } else {
> +               bitmap_set(data->bm, next, nvec);
> +               *irq = data->spi_start + next;
> +               ret = 0;
> +       }
> +
> +       spin_unlock(&data->msi_cnt_lock);
> +
> +       return ret;
> +}
> +
> +static void gicv2m_teardown_msi_irq(struct msi_chip *chip, unsigned int irq)
> +{
> +       int pos;
> +       struct v2m_data *data = container_of(chip, struct v2m_data, msi_chip);
> +
> +       spin_lock(&data->msi_cnt_lock);
> +
> +       pos = irq - data->spi_start;
> +       if (pos >= 0 && pos < data->nr_spis)
> +               bitmap_clear(data->bm, pos, 1);
> +
> +       spin_unlock(&data->msi_cnt_lock);
> +}
> +
> +static int gicv2m_setup_msi_irq(struct msi_chip *chip, struct pci_dev *pdev,
> +                               struct msi_desc *desc)
> +{
> +       int hwirq = 0, virq, avail;
> +       struct v2m_data *v2m = container_of(chip, struct v2m_data, msi_chip);
> +
> +       if (!desc) {
> +               dev_err(&pdev->dev,
> +                       "MSI setup failed. Invalid msi descriptor\n");
> +               return -EINVAL;
> +       }
> +
> +       avail = alloc_msi_irq(v2m, 1, &hwirq);
> +       if (avail != 0) {
> +               dev_err(&pdev->dev,
> +                       "MSI setup failed. Cannnot allocate IRQ\n");
> +               return -ENOSPC;
> +       }
> +
> +       virq = __irq_domain_alloc_irqs(v2m->domain, hwirq,
> +                                      1, NUMA_NO_NODE, v2m, true);
> +       if (virq < 0)
> +               return -EINVAL;
> +
> +       irq_domain_set_hwirq_and_chip(v2m->domain, virq, hwirq,
> +                               &v2m_chip, v2m);
> +
> +
> +       irq_set_msi_desc(hwirq, desc);
> +       irq_set_irq_type(hwirq, IRQ_TYPE_EDGE_RISING);
> +
> +       return 0;
> +}
> +
> +static int gicv2m_domain_activate(struct irq_domain *domain,
> +                                     struct irq_data *data)
> +{
> +       struct msi_msg msg;
> +       struct v2m_data *v2m;
> +       phys_addr_t addr;
> +
> +       v2m = container_of(data->chip_data, struct v2m_data, msi_chip);
> +       addr = v2m->res.start + V2M_MSI_SETSPI_NS;
> +
> +       msg.address_hi = (u32)(addr >> 32);
> +       msg.address_lo = (u32)(addr);
> +       msg.data = data->irq;
> +       write_msi_msg(data->irq, &msg);
> +
> +       return 0;
> +}
> +
> +static int gicv2m_domain_deactivate(struct irq_domain *domain,
> +                                   struct irq_data *data)
> +{
> +       struct msi_msg msg;
> +
> +       memset(&msg, 0, sizeof(msg));
> +       write_msi_msg(data->irq, &msg);
> +
> +       return 0;
> +}
> +
> +static int gicv2m_domain_alloc(struct irq_domain *d, unsigned int virq,
> +                              unsigned int nr_irqs, void *arg)
> +{
> +       int i, ret, irq;
> +
> +       for (i = 0; i < nr_irqs; i++) {
> +               irq = virq + i;
> +               set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
> +               irq_set_chip_and_handler_name(irq, &v2m_chip,
> +                       handle_fasteoi_irq, v2m_chip.name);
> +       }
> +
> +       ret = irq_domain_alloc_irqs_parent(d, virq, nr_irqs, NULL);
> +       if (ret < 0)
> +               pr_err("Failed to allocate parent IRQ domain\n");
> +
> +       return ret;
> +}
> +
> +static void gicv2m_domain_free(struct irq_domain *d, unsigned int virq,
> +                              unsigned int nr_irqs)
> +{
> +       int i, irq;
> +
> +       for (i = 0; i < nr_irqs; i++) {
> +               irq = virq + i;
> +               irq_set_handler(irq, NULL);
> +               irq_domain_set_hwirq_and_chip(d, irq, 0, NULL, NULL);
> +       }
> +
> +       irq_domain_free_irqs_parent(d, virq, nr_irqs);
> +}
> +
> +static bool is_msi_spi_valid(u32 base, u32 num)
> +{
> +       if (base < V2M_MIN_SPI) {
> +               pr_err("Invalid MSI base SPI (base:%u)\n", base);
> +               return false;
> +       }
> +
> +       if ((num == 0) || (base + num > V2M_MAX_SPI)) {
> +               pr_err("Number of SPIs (%u) exceed maximum (%u)\n",
> +                      num, V2M_MAX_SPI - V2M_MIN_SPI + 1);
> +               return false;
> +       }
> +
> +       return true;
> +}
> +
> +static void gicv2m_mask_irq(struct irq_data *d)
> +{
> +       irq_chip_mask_parent(d);
> +       if (d->msi_desc)
> +               mask_msi_irq(d);
> +}
> +
> +static void gicv2m_unmask_irq(struct irq_data *d)
> +{
> +       irq_chip_unmask_parent(d);
> +       if (d->msi_desc)
> +               unmask_msi_irq(d);
> +}
> +
> +static struct irq_chip v2m_chip = {
> +       .name             = "GICv2m",
> +       .irq_mask         = gicv2m_mask_irq,
> +       .irq_unmask       = gicv2m_unmask_irq,
> +       .irq_eoi          = irq_chip_eoi_parent,
> +       .irq_set_type     = irq_chip_set_type_parent,
> +
> +#ifdef CONFIG_SMP
> +       .irq_set_affinity = irq_chip_set_affinity_parent,
> +#endif
> +};
> +
> +static const struct irq_domain_ops gicv2m_domain_ops = {
> +       .alloc      = gicv2m_domain_alloc,
> +       .free       = gicv2m_domain_free,
> +       .activate   = gicv2m_domain_activate,
> +       .deactivate = gicv2m_domain_deactivate,
> +};
> +
> +static int __init
> +gicv2m_init_one(struct device_node *node,
> +               struct v2m_data **v,
> +               struct irq_domain *parent)
> +{
> +       int ret;
> +       struct v2m_data *v2m;
> +
> +       *v = kzalloc(sizeof(struct v2m_data), GFP_KERNEL);
> +       if (!*v) {
> +               pr_err("Failed to allocate struct v2m_data.\n");
> +               return -ENOMEM;
> +       }
> +
> +       v2m = *v;
> +       v2m->msi_chip.owner = THIS_MODULE;
> +       v2m->msi_chip.of_node = node;
> +       v2m->msi_chip.setup_irq = gicv2m_setup_msi_irq;
> +       v2m->msi_chip.teardown_irq = gicv2m_teardown_msi_irq;
> +       ret = of_address_to_resource(node, 0, &v2m->res);
> +       if (ret) {
> +               pr_err("Failed to allocate v2m resource.\n");
> +               goto err_out;
> +       }
> +
> +       v2m->base = ioremap(v2m->res.start, resource_size(&v2m->res));
> +       if (!v2m->base) {
> +               pr_err("Failed to map GICv2m resource\n");
> +               ret = -EINVAL;
> +               goto err_out;
> +       }
> +
> +       ret = of_pci_msi_chip_add(&v2m->msi_chip);
> +       if (ret) {
> +               pr_info("Failed to add msi_chip.\n");
> +               goto err_out;
> +       }
> +
> +       if (!of_property_read_u32(node, "arm,msi-base-spi", &v2m->spi_start) &&
> +           !of_property_read_u32(node, "arm,msi-num-spis", &v2m->nr_spis)) {
> +               pr_info("Overriding V2M MSI_TYPER (base:%u, num:%u)\n",
> +                       v2m->spi_start, v2m->nr_spis);
> +       } else {
> +               u32 typer = readl_relaxed(v2m->base + V2M_MSI_TYPER);
> +
> +               v2m->spi_start = V2M_MSI_TYPER_BASE_SPI(typer);
> +               v2m->nr_spis = V2M_MSI_TYPER_NUM_SPI(typer);
> +       }
> +
> +       if (!is_msi_spi_valid(v2m->spi_start, v2m->nr_spis)) {
> +               ret = -EINVAL;
> +               goto err_out;
> +       }
> +
> +       v2m->bm = kzalloc(sizeof(long) * BITS_TO_LONGS(v2m->nr_spis),
> +                         GFP_KERNEL);
> +       if (!v2m->bm) {
> +               pr_err("Failed to allocate MSI bitmap\n");
> +               ret = -ENOMEM;
> +               goto err_out;
> +       }
> +
> +       v2m->domain = irq_domain_add_simple(node, v2m->nr_spis, v2m->spi_start,
> +                                           &gicv2m_domain_ops, v2m);
> +       if (!v2m->domain) {
> +               pr_err("Failed to create GICv2m domain\n");
> +               ret = -EINVAL;
> +               goto err_out;
> +       }
> +
> +       v2m->domain->parent = parent;
> +
> +       spin_lock_init(&v2m->msi_cnt_lock);
> +
> +       pr_info("Node %s: range[%#lx:%#lx], SPI[%d:%d]\n", node->name,
> +               (unsigned long)v2m->res.start, (unsigned long)v2m->res.end,
> +               v2m->spi_start, (v2m->spi_start + v2m->nr_spis));
> +
> +       return 0;
> +err_out:
> +       of_pci_msi_chip_remove(&v2m->msi_chip);
> +       if (v2m->base)
> +               iounmap(v2m->base);
> +       if (v2m->bm)
> +               kzfree(v2m->bm);
> +       kfree(v2m);
> +       return ret;
> +}
> +
> +int __init gicv2m_of_init(struct device_node *node,
> +                         struct irq_domain *parent,
> +                         struct list_head *v2m_list)
> +{
> +       int ret = 0;
> +       struct v2m_data *v2m;
> +       struct device_node *child = NULL;
> +
> +       INIT_LIST_HEAD(v2m_list);
> +
> +       for (;;) {
> +               child = of_get_next_child(node, child);
> +               if (!child)
> +                       break;
> +
> +               if (!of_device_is_compatible(child, "arm,gic-v2m-frame"))
> +                       continue;
> +
> +               if (!of_find_property(child, "msi-controller", NULL))
> +                       continue;
> +
> +               ret = gicv2m_init_one(child, &v2m, parent);
> +               if (ret) {
> +                       of_node_put(node);
> +                       break;
> +               }
> +
> +               list_add_tail(&v2m->list, v2m_list);
> +       }
> +
> +       if (ret && list_empty(v2m_list)) {
> +               pr_warn("Warning: Failed to enable GICv2m support.\n");
> +               return -EINVAL;
> +       }
> +
> +       return ret;
> +}
> diff --git a/drivers/irqchip/irq-gic-v2m.h b/drivers/irqchip/irq-gic-v2m.h
> new file mode 100644
> index 0000000..b5ae787
> --- /dev/null
> +++ b/drivers/irqchip/irq-gic-v2m.h
> @@ -0,0 +1,7 @@
> +#ifndef _IRQ_GIC_V2M_H_
> +#define _IRQ_GIC_V2M_H_
> +
> +extern int gicv2m_of_init(struct device_node *node, struct irq_domain *parent,
> +                         struct list_head *v2m_list) __init;
> +
> +#endif /* _IRQ_GIC_V2M_H_ */
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index a99c211..4069eb3 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -46,6 +46,7 @@
>  #include <asm/smp_plat.h>
> 
>  #include "irq-gic-common.h"
> +#include "irq-gic-v2m.h"
>  #include "irqchip.h"
> 
>  union gic_base {
> @@ -68,6 +69,9 @@ struct gic_chip_data {
>  #ifdef CONFIG_GIC_NON_BANKED
>         void __iomem *(*get_base)(union gic_base *);
>  #endif
> +#ifdef CONFIG_ARM_GIC_V2M
> +       struct list_head v2m_list;
> +#endif

Can't that be something private to the v2m widget driver? I don't think
it brings anything to the main GIC driver.

>  };
> 
>  static DEFINE_RAW_SPINLOCK(irq_controller_lock);
> @@ -843,10 +847,14 @@ static int gic_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
>         unsigned int type = IRQ_TYPE_NONE;
>         struct of_phandle_args *irq_data = arg;
> 
> -       ret = gic_irq_domain_xlate(domain, irq_data->np, irq_data->args,
> -                                  irq_data->args_count, &hwirq, &type);
> -       if (ret)
> -               return ret;
> +       if (irq_data) {
> +               ret = gic_irq_domain_xlate(domain, irq_data->np, irq_data->args,
> +                                          irq_data->args_count, &hwirq, &type);
> +               if (ret)
> +                       return ret;
> +       } else {
> +               hwirq = virq;
> +       }

I'm slightly puzzled here. What's the purpose of this? The whole goal of
the domain hierarchy is to avoid that kind of thing. Also, you should
never have to call xlate on an MSI, because it should never be described
in the device tree the first place.

>         for (i = 0; i < nr_irqs; i++)
>                 gic_irq_domain_map(domain, virq+i, hwirq+i);
> @@ -1055,6 +1063,11 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>                 irq = irq_of_parse_and_map(node, 0);
>                 gic_cascade_irq(gic_cnt, irq);
>         }
> +
> +       if (IS_ENABLED(CONFIG_ARM_GIC_V2M))
> +               gicv2m_of_init(node, gic_data[gic_cnt].domain,
> +                              &gic_data[gic_cnt].v2m_list);
> +
>         gic_cnt++;
>         return 0;
>  }

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

