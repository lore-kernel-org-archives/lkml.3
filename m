Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbaHONcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:32:00 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:51140 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751176AbaHONb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 09:31:57 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: "suravee.suthikulpanit\@amd.com" <suravee.suthikulpanit@amd.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        "jason\@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "Harish.Kasiviswanathan\@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2 V4] irqchip: gicv2m: Add support for multiple MSI for ARM64 GICv2m
In-Reply-To: <1407942041-3291-3-git-send-email-suravee.suthikulpanit@amd.com>
	(suravee's message of "Wed, 13 Aug 2014 16:00:41 +0100")
Organization: ARM Ltd
References: <1407942041-3291-1-git-send-email-suravee.suthikulpanit@amd.com>
	<1407942041-3291-3-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Fri, 15 Aug 2014 14:31:51 +0100
Message-ID: <87k369ri9k.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suravee,

On Wed, Aug 13 2014 at  4:00:41 pm BST, "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com> wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> This patch extend GICv2m MSI to support multiple MSI in ARM64.
>
> This requires the common arch_setup_msi_irqs() to be overwriten
> with ARM64 version which does not return 1 for PCI_CAP_ID_MSI and
> nvec > 1.
>
> Cc: Mark Rutland <Mark.Rutland@arm.com>
> Cc: Marc Zyngier <Marc.Zyngier@arm.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Catalin Marinas <Catalin.Marinas@arm.com>
> Cc: Will Deacon <Will.Deacon@arm.com>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> ---
>  arch/arm64/include/asm/msi.h  | 15 ++++++++
>  arch/arm64/kernel/Makefile    |  1 +
>  arch/arm64/kernel/msi.c       | 57 +++++++++++++++++++++++++++++++
>  drivers/irqchip/irq-gic-v2m.c | 79 +++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 152 insertions(+)
>  create mode 100644 arch/arm64/include/asm/msi.h
>  create mode 100644 arch/arm64/kernel/msi.c
>
> diff --git a/arch/arm64/include/asm/msi.h b/arch/arm64/include/asm/msi.h
> new file mode 100644
> index 0000000..2a0944a
> --- /dev/null
> +++ b/arch/arm64/include/asm/msi.h
> @@ -0,0 +1,15 @@
> +#ifndef _ASM_ARM64_MSI_H_
> +#define _ASM_ARM64_MSI_H_
> +
> +struct pci_dev;
> +struct msi_desc;
> +
> +struct arm64_msi_ops {
> +	int (*setup_msi_irqs)(struct pci_dev *dev, int nvec, int type);
> +	void (*teardown_msi_irqs)(struct pci_dev *dev);
> +};
> +
> +extern struct arm64_msi_ops arm64_msi;
> +extern int arm64_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
> +
> +#endif /* _ASM_ARM64_MSI_H_ */
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index cdaedad..0636e27 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -29,6 +29,7 @@ arm64-obj-$(CONFIG_ARM64_CPU_SUSPEND)	+= sleep.o suspend.o
>  arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
>  arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
>  arm64-obj-$(CONFIG_EFI)			+= efi.o efi-stub.o efi-entry.o
> +arm64-obj-$(CONFIG_PCI_MSI)		+= msi.o
>  
>  obj-y					+= $(arm64-obj-y) vdso/
>  obj-m					+= $(arm64-obj-m)
> diff --git a/arch/arm64/kernel/msi.c b/arch/arm64/kernel/msi.c
> new file mode 100644
> index 0000000..ed62397
> --- /dev/null
> +++ b/arch/arm64/kernel/msi.c
> @@ -0,0 +1,57 @@
> +/*
> + * ARM64 architectural MSI implemention
> + *
> + * Support for Message Signalelled Interrupts for systems that
> + * implement ARM Generic Interrupt Controller: GICv2m.
> + *
> + * Copyright (C) 2014 Advanced Micro Devices, Inc.
> + * Authors: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + */
> +
> +#include <linux/irq.h>
> +#include <linux/msi.h>
> +#include <linux/pci.h>
> +
> +#include <asm/msi.h>
> +
> +/*
> + * ARM64 function for seting up MSI irqs.
> + * Copied from driver/pci/msi.c: arch_setup_msi_irqs().
> + */
> +int arm64_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> +{
> +	struct msi_desc *entry;
> +	int ret;
> +
> +	if (type == PCI_CAP_ID_MSI && nvec > 1)
> +		return 1;
> +
> +	list_for_each_entry(entry, &dev->msi_list, list) {
> +		ret = arch_setup_msi_irq(dev, entry);
> +		if (ret < 0)
> +			return ret;
> +		if (ret > 0)
> +			return -ENOSPC;
> +	}
> +
> +	return 0;
> +}

I'm going to reiterate what I said last time: Why do we need this?

So far, we have two MSI-capable controllers on their way upstream:
GICv2m and GICv3. Both are perfectly capable of handling more than a
single MSI per device.

So why should we cater for this? My gut feeling is that we should just
have:

int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
{
        struct msi_desc *entry;
        int ret;

        /*
         * So far, all our MSI controllers are capable of handling more
         * than a single MSI per device. Should we encounter less
         * capable devices, we'll consider doing something special for
         * them.
         */
        list_for_each_entry(entry, &dev->msi_list, list) {
                ret = arch_setup_msi_irq(dev, entry);
                if (ret < 0)
                        return ret;
                if (ret > 0)
                        return -ENOSPC;
        }

        return 0;
}

and nothing else. Your driver should be able to retrieve the number of
MSI needed by the device, and allocate them. GICv3 manages it, and so
should GICv2m.

> +
> +struct arm64_msi_ops arm64_msi = {
> +	.setup_msi_irqs         = arm64_setup_msi_irqs,
> +	.teardown_msi_irqs      = default_teardown_msi_irqs,
> +};
> +
> +int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> +{
> +	return arm64_msi.setup_msi_irqs(dev, nvec, type);
> +}
> +
> +void arch_teardown_msi_irqs(struct pci_dev *dev)
> +{
> +	arm64_msi.teardown_msi_irqs(dev);
> +}
> diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
> index 1ac0ace..21221e9 100644
> --- a/drivers/irqchip/irq-gic-v2m.c
> +++ b/drivers/irqchip/irq-gic-v2m.c
> @@ -24,6 +24,10 @@
>  #include <linux/of_pci.h>
>  #include <linux/bitmap.h>
>  
> +#ifdef CONFIG_ARM64
> +#include <asm/msi.h>
> +#endif
> +
>  #include "irqchip.h"
>  #include "irq-gic.h"
>  
> @@ -146,6 +150,79 @@ static void gicv2m_unmask_irq(struct irq_data *d)
>  		unmask_msi_irq(d);
>  }
>  
> +/*
> + * _gicv2m_setup_msi_irqs - Setup MSI interrupts for the given PCI device.
> + * This overrides the weak definition in ./drivers/pci/msi.c.
> + * If nvec interrupts are irqable, then assign it to PCI device.
> + * Otherwise return error.
> + *
> + * @pdev: PCI device which is requesting to enable MSI
> + * @nvec: number of MSI vectors
> + */
> +static int _gicv2m_setup_msi_irqs(struct pci_dev *pdev, int nvec)
> +{
> +	int irq = 0, nvec_pow2 = 0, avail;
> +	int i = 0;
> +	struct msi_msg msg;
> +	phys_addr_t addr;
> +	struct msi_desc *entry;
> +	struct msi_chip *chip = pdev->bus->msi;
> +	struct v2m_data *data = container_of(chip, struct v2m_data, msi_chip);
> +
> +	BUG_ON(list_empty(&pdev->msi_list));
> +	WARN_ON(!list_is_singular(&pdev->msi_list));
> +
> +	entry = list_first_entry(&pdev->msi_list, struct msi_desc, list);
> +	WARN_ON(entry->irq);
> +	WARN_ON(entry->msi_attrib.multiple);
> +	WARN_ON(entry->nvec_used);
> +	WARN_ON(!entry->dev);
> +
> +	avail = alloc_msi_irq(data, nvec, &irq);
> +	if (avail != 0) {
> +		dev_err(&pdev->dev,
> +			"GICv2m: Failed to allocate %d irqs.\n", nvec);
> +		return avail;
> +	}
> +
> +	/* Set lowest of the new interrupts assigned to the PCI device */
> +	nvec_pow2 = __roundup_pow_of_two(nvec);
> +	entry->nvec_used = nvec;
> +	entry->msi_attrib.multiple = ilog2(nvec_pow2);
> +
> +	for (i = 0; i < nvec; i++) {
> +		irq_set_chip_data(irq+i, chip);
> +		if (irq_set_msi_desc_off(irq, i, entry)) {
> +			dev_err(&pdev->dev,
> +				"GICv2m: Failed to set up MSI irq %d\n",
> +				(irq+i));
> +			return -EINVAL;
> +		}
> +
> +		irq_set_irq_type((irq+i), IRQ_TYPE_EDGE_RISING);
> +	}
> +
> +	addr = data->res.start + V2M_MSI_SETSPI_NS;
> +	msg.address_hi = (u32)(addr >> 32);
> +	msg.address_lo = (u32)(addr);
> +	msg.data = irq;
> +	write_msi_msg(irq, &msg);
> +
> +	return 0;
> +}
> +
> +static int
> +gicv2m_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
> +{
> +	int ret;
> +
> +	if (type == PCI_CAP_ID_MSI)
> +		ret = _gicv2m_setup_msi_irqs(pdev, nvec);
> +	else
> +		ret = arm64_setup_msi_irqs(pdev, nvec, type);
> +	return ret;
> +}

And this should go away as a consequence of the above.

> +
>  static struct irq_chip gicv2m_chip;
>  
>  #ifdef CONFIG_OF
> @@ -156,6 +233,8 @@ gicv2m_of_init(struct device_node *node, struct gic_chip_data *gic)
>  	unsigned int val;
>  	struct v2m_data *v2m = &gic->v2m_data;
>  
> +	arm64_msi.setup_msi_irqs = &gicv2m_setup_msi_irqs;
> +
>  	v2m->msi_chip.owner = THIS_MODULE;
>  	v2m->msi_chip.of_node = node;
>  	v2m->msi_chip.setup_irq = gicv2m_setup_msi_irq;

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
