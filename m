Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaGMXDq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 19:03:46 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:17446 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaGMXDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 19:03:38 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+e871qjp4V2Gc749QrQ7XApGPAZhzpz5M=
X-DKIM: OpenDKIM Filter v2.0.1 titan A7DCB5AA0B9
Date: Sun, 13 Jul 2014 19:03:28 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: suravee.suthikulpanit@amd.com
Cc: marc.zyngier@arm.com, mark.rutland@arm.com, pawel.moll@arm.com,
        Catalin.Marinas@arm.com, Will.Deacon@arm.com, tglx@linutronix.de,
        Harish.Kasiviswanathan@amd.com, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 4/4 V3] irqchip: gicv2m: Add support for multiple MSI
 for ARM64 GICv2m
Message-ID: <20140713230328.GL13108@titan.lakedaemon.net>
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1404947104-21345-5-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404947104-21345-5-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suravee,

If you need to respin this series, please change the subject line to
"irqchip: gic-v2m: ..."  If there are no other changes needed, It can be
fixed up when applied.

thx,

Jason.

On Wed, Jul 09, 2014 at 06:05:04PM -0500, suravee.suthikulpanit@amd.com wrote:
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
>  arch/arm64/kernel/msi.c       | 57 ++++++++++++++++++++++++++++++
>  drivers/irqchip/irq-gic-v2m.c | 80 +++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 153 insertions(+)
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
> index e54ca1d..9d88ad9 100644
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
> @@ -216,6 +220,80 @@ static struct irq_chip gicv2m_chip = {
>  #endif
>  };
>  
> +
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
> +	struct v2m_data *data = to_v2m_data(chip);
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
> +
>  #ifdef CONFIG_OF
>  static int __init
>  gicv2m_of_init(struct device_node *node, struct device_node *parent)
> @@ -229,6 +307,8 @@ gicv2m_of_init(struct device_node *node, struct device_node *parent)
>  		return ret;
>  	}
>  
> +	arm64_msi.setup_msi_irqs = &gicv2m_setup_msi_irqs;
> +
>  	gic->msi_chip.owner = THIS_MODULE;
>  	gic->msi_chip.of_node = node;
>  	gic->msi_chip.setup_irq = gicv2m_setup_msi_irq;
> -- 
> 1.9.0
> 
