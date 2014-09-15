Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaIOTln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:41:43 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33095 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbaIOTlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:41:36 -0400
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
Subject: Re: [PATCH 2/2 V6] irqchip: gicv2m: Add support for multiple MSI for ARM64 GICv2m
In-Reply-To: <1410676216-27953-3-git-send-email-suravee.suthikulpanit@amd.com>
	(suravee's message of "Sun, 14 Sep 2014 07:30:16 +0100")
Organization: ARM Ltd
References: <1410676216-27953-1-git-send-email-suravee.suthikulpanit@amd.com>
	<1410676216-27953-3-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Mon, 15 Sep 2014 20:41:22 +0100
Message-ID: <86egvcn02l.fsf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14 2014 at 07:30:16 AM, "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com> wrote:
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
>  arch/arm64/kernel/Makefile    |  1 +
>  arch/arm64/kernel/msi.c       | 41 ++++++++++++++++++++
>  drivers/irqchip/irq-gic-v2m.c | 87 ++++++++++++++++++++++++++++++++++++++-----
>  3 files changed, 119 insertions(+), 10 deletions(-)
>  create mode 100644 arch/arm64/kernel/msi.c
>
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index df7ef87..a921c42 100644
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
> index 0000000..a295862
> --- /dev/null
> +++ b/arch/arm64/kernel/msi.c
> @@ -0,0 +1,41 @@
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
> +/*
> + * ARM64 function for seting up MSI irqs.
> + * Based on driver/pci/msi.c: arch_setup_msi_irqs().
> + *
> + * Note:
> + * Current implementation assumes that all interrupt controller used in
> + * ARM64 architecture _MUST_ supports multi-MSI.
> + */
> +int arm64_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> +{
> +	struct msi_desc *entry;
> +	int ret;
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
> diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
> index 499bfb9..4ddb47d 100644
> --- a/drivers/irqchip/irq-gic-v2m.c
> +++ b/drivers/irqchip/irq-gic-v2m.c
> @@ -99,13 +99,26 @@ static void gicv2m_teardown_msi_irq(struct msi_chip *chip, unsigned int irq)
>  	spin_unlock(&data->msi_cnt_lock);
>  }
>  
> +static int gicv2m_msi_get_vec_count(struct pci_dev *pdev, struct msi_desc *desc)
> +{
> +	int ret = -EINVAL;
> +#ifdef CONFIG_PCI_MSI
> +	if (desc->msi_attrib.is_msix)
> +		ret = pci_msix_vec_count(pdev);
> +	else
> +		ret = pci_msi_vec_count(pdev);
> +#endif
> +	return ret;
> +}
> +

Since I also have:
https://git.kernel.org/cgit/linux/kernel/git/maz/arm-platforms.git/tree/drivers/irqchip/irq-gic-v3-its.c?h=gicv3/its-split#n1107

Maybe it would be a good thing to make this a core thing (not something
we have to do now though).

>  static int gicv2m_setup_msi_irq(struct msi_chip *chip,
>  				struct pci_dev *pdev,
>  				struct msi_desc *desc)
>  {
> -	int irq, avail;
> +	int i, irq, nvec, avail;
>  	struct msi_msg msg;
>  	phys_addr_t addr;
> +	struct msi_desc *entry;
>  	struct v2m_data *data = container_of(chip, struct v2m_data, msi_chip);
>  
>  	if (!desc) {
> @@ -114,16 +127,70 @@ static int gicv2m_setup_msi_irq(struct msi_chip *chip,
>  		return -EINVAL;
>  	}
>  
> -	avail = alloc_msi_irq(data, 1, &irq);
> -	if (avail != 0) {
> -		dev_err(&pdev->dev,
> -			"GICv2m: MSI setup failed. Cannnot allocate IRQ\n");
> -		return -ENOSPC;
> -	}
> +	if (desc->msi_attrib.is_msix) {
> +		/**
> +		 * For MSIx:
> +		 * We allocate one irq at a time
> +		 */
> +		avail = alloc_msi_irq(data, 1, &irq);
> +		if (avail != 0) {
> +			dev_err(&pdev->dev,
> +				"GICv2m: MSI setup failed. Cannnot allocate IRQ\n");
> +			return -ENOSPC;
> +		}
>  
> -	irq_set_chip_data(irq, chip);
> -	irq_set_msi_desc(irq, desc);
> -	irq_set_irq_type(irq, IRQ_TYPE_EDGE_RISING);
> +		irq_set_chip_data(irq, chip);
> +		irq_set_msi_desc(irq, desc);
> +		irq_set_irq_type(irq, IRQ_TYPE_EDGE_RISING);
> +	} else {
> +		/**
> +		 * For MSI and Multi-MSI:
> +		 * All requested irqs are allocated and setup at
> +		 * once. Subsequent calls to this function would simply return
> +		 * success. This is to avoid having to implement a separate
> +		 * function for setting up multiple irqs.
> +		 */
> +		BUG_ON(list_empty(&pdev->msi_list));
> +		WARN_ON(!list_is_singular(&pdev->msi_list));
> +
> +		nvec = gicv2m_msi_get_vec_count(pdev, desc);
> +		if (WARN_ON(nvec <= 0))
> +			return nvec;
> +
> +		entry = list_first_entry(&pdev->msi_list,
> +					 struct msi_desc, list);
> +
> +		if ((nvec > 1) && (entry->msi_attrib.multiple))
> +			return 0;
> +
> +		avail = alloc_msi_irq(data, nvec, &irq);
> +		if (avail != 0) {
> +			dev_err(&pdev->dev,
> +				"GICv2m: Failed to allocate %d irqs.\n", nvec);
> +			return avail;
> +		}
> +
> +		if (nvec > 1) {
> +			/* Set lowest of the new interrupts assigned
> +			 * to the PCI device
> +			 */
> +			entry->nvec_used = nvec;
> +			entry->msi_attrib.multiple = ilog2(
> +						__roundup_pow_of_two(nvec));
> +		}
> +
> +		for (i = 0; i < nvec; i++) {
> +			irq_set_chip_data(irq+i, chip);
> +			if (irq_set_msi_desc_off(irq, i, entry)) {
> +				dev_err(&pdev->dev,
> +					"GICv2m: Failed to set up MSI irq %d\n",
> +					(irq+i));
> +				return -EINVAL;
> +			}
> +
> +			irq_set_irq_type((irq+i), IRQ_TYPE_EDGE_RISING);
> +		}
> +	}
>  
>  	addr = data->res.start + V2M_MSI_SETSPI_NS;
>  	msg.address_hi = (u32)(addr >> 32);

Overall, I think you should move this "msi > 1" code directly into the
first patch (not sure the intermediate implementation adds much to the
understanding of the whole driver).

You can then have the arm64-specific code as your second patch.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
