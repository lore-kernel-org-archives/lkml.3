Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaKEXJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 18:09:59 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:51551 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaKEXJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:09:57 -0500
Date: Wed, 5 Nov 2014 16:09:52 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch Part2 v4 21/31] PCI/MSI: enhance PCI MSI core to support
 hierarchy irqdomain
Message-ID: <20141105230952.GH6168@google.com>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
 <1415102525-9898-22-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415102525-9898-22-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 08:01:55PM +0800, Jiang Liu wrote:

In your topic:

  PCI/MSI: enhance PCI MSI core to support hierarchy irqdomain

There's no need to repeat "PCI MSI".  Please run "git log --oneline
drivers/pci/msi.c" and make your similar (capitalize the first word).

> Enhance PCI MSI core to support hierarchy irqdomain, so the common
> code could be shared among architectures.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/pci/Kconfig |    4 ++
>  drivers/pci/msi.c   |  126 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/msi.h |   11 +++++
>  3 files changed, 141 insertions(+)
> 
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index b9db0f2ce11f..022e89745f86 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -16,6 +16,10 @@ config PCI_MSI
>  
>  	   If you don't know what to do here, say Y.
>  
> +config PCI_MSI_IRQ_DOMAIN
> +	bool
> +	depends on PCI_MSI && IRQ_DOMAIN_HIERARCHY
> +
>  config PCI_DEBUG
>  	bool "PCI Debugging"
>  	depends on PCI && DEBUG_KERNEL
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index da181c59394b..7423ee16972f 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -19,6 +19,7 @@
>  #include <linux/errno.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
> +#include <linux/irqdomain.h>
>  
>  #include "pci.h"
>  
> @@ -1098,3 +1099,128 @@ int pci_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
>  	return nvec;
>  }
>  EXPORT_SYMBOL(pci_enable_msix_range);
> +
> +#ifdef	CONFIG_PCI_MSI_IRQ_DOMAIN

Space, not tab.

> +static inline irq_hw_number_t
> +msi_get_hwirq(struct pci_dev *pdev, struct msi_desc *msidesc)

The convention in this file is "struct pci_dev *dev".  And "struct msi_desc
*desc" (or maybe "*entry").  Try to converge things, not diverge them.

> +{
> +	return (irq_hw_number_t)msidesc->msi_attrib.entry_nr |
> +		PCI_DEVID(pdev->bus->number, pdev->devfn) << 11 |
> +		(pci_domain_nr(pdev->bus) & 0xFFFFFFFF) << 27;

Where does this bit layout come from?  Is this defined in the spec
somewhere?  A reference would help.

> +}
> +
> +static int msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
> +			    unsigned int nr_irqs, void *arg)
> +{
> +	int i, ret;
> +	irq_hw_number_t hwirq = arch_msi_irq_domain_get_hwirq(arg);
> +
> +	if (irq_find_mapping(domain, hwirq) > 0)
> +		return -EEXIST;
> +
> +	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
> +	if (ret >= 0)

	if (ret < 0)
		return ret;

and un-indent the mainline code below.  Then it's obvious that this is the
normal case, not the error case.

> +		for (i = 0; i < nr_irqs; i++) {
> +			irq_domain_set_hwirq_and_chip(domain, virq + i,
> +					hwirq + i, &msi_chip, (void *)(long)i);
> +			__irq_set_handler(virq + i, handle_edge_irq, 0, "edge");
> +		}
> +
> +	return ret;
> +}
> +
> +static void msi_domain_free(struct irq_domain *domain, unsigned int virq,
> +			    unsigned int nr_irqs)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_irqs; i++) {
> +		struct msi_desc *msidesc = irq_get_msi_desc(virq);
> +
> +		if (msidesc)
> +			msidesc->irq = 0;
> +	}
> +	irq_domain_free_irqs_top(domain, virq, nr_irqs);
> +}
> +
> +static int msi_domain_activate(struct irq_domain *domain,
> +			       struct irq_data *irq_data)
> +{
> +	int ret = 0;
> +	struct msi_msg msg;
> +
> +	/*
> +	 * irq_data->chip_data is MSI/MSIx offset.

"MSI-X", as you wrote on the next line.

> +	 * MSI-X message is written per-IRQ, the offset is always 0.
> +	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
> +	 */
> +	if (!irq_data->chip_data) {

	if (irq_data->chip_data)
		return 0;

and un-indent the mainline code below, and drop the "ret = 0" init above.

> +		ret = irq_chip_compose_msi_msg(irq_data, &msg);
> +		if (ret == 0)

	if (ret)
		return ret;

> +			write_msi_msg(irq_data->irq, &msg);
> +	}
> +
> +	return ret;
	return 0;
> +}
> +
> +static int msi_domain_deactivate(struct irq_domain *domain,
> +				 struct irq_data *irq_data)
> +{
> +	struct msi_msg msg;
> +
> +	if (irq_data->chip_data) {
> +		memset(&msg, 0, sizeof(msg));
> +		write_msi_msg(irq_data->irq, &msg);
> +	}
> +
> +	return 0;
> +}
> +
> +static struct irq_domain_ops msi_domain_ops = {
> +	.alloc = msi_domain_alloc,
> +	.free = msi_domain_free,
> +	.activate = msi_domain_activate,
> +	.deactivate = msi_domain_deactivate,
> +};
> +
> +struct irq_domain *msi_create_irq_domain(struct irq_domain *parent)
> +{
> +	struct irq_domain *domain;
> +
> +	domain = irq_domain_add_tree(NULL, &msi_domain_ops, NULL);
> +	if (domain)

	if (!domain)
		return NULL;

and un-indent this:

> +		domain->parent = parent;
> +
> +	return domain;
> +}
> +
> +int msi_irq_domain_alloc_irqs(struct irq_domain *domain, int type,
> +			      struct pci_dev *dev, void *arg)
> +{
> +	int i, virq;
> +	struct msi_desc *msidesc;
> +	int node = dev_to_node(&dev->dev);
> +
> +	list_for_each_entry(msidesc, &dev->msi_list, list) {
> +		arch_msi_irq_domain_set_hwirq(arg, msi_get_hwirq(dev, msidesc));
> +		virq = irq_domain_alloc_irqs(domain, msidesc->nvec_used,
> +					     node, arg);
> +		if (virq < 0) {
> +			/* Special handling for pci_enable_msi_range(). */
> +			return (type == PCI_CAP_ID_MSI &&
> +				msidesc->nvec_used > 1) ?  1 : -ENOSPC;	

I think "if" would be easier to read than this ternary expression.

> +		}
> +		for (i = 0; i < msidesc->nvec_used; i++)
> +			irq_set_msi_desc_off(virq + i, i, msidesc);
> +	}
> +
> +	list_for_each_entry(msidesc, &dev->msi_list, list)
> +		if (msidesc->nvec_used == 1)
> +			dev_dbg(&dev->dev, "irq %d for MSI/MSI-X\n", virq);
> +		else
> +			dev_dbg(&dev->dev, "irq [%d-%d] for MSI/MSI-X\n",
> +				virq, virq + msidesc->nvec_used - 1);
> +
> +	return 0;
> +}
> +#endif	/* CONFIG_PCI_MSI_IRQ_DOMAIN */
> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index 44f4746d033b..05dcd425f82b 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -75,4 +75,15 @@ struct msi_chip {
>  	void (*teardown_irq)(struct msi_chip *chip, unsigned int irq);
>  };
>  
> +#ifdef	CONFIG_PCI_MSI_IRQ_DOMAIN

Use a space here, not a tab.

> +extern struct irq_chip msi_chip;

I don't think "msi_chip" is a good name.  "Chip" only hints that it's a
semiconductor integrated circuit; it doesn't say anything about what it
does.  I've suggested "msi_controller" elsewhere.

Why does this need to be exported?  And why should there be only one in a
system?

> +extern struct irq_domain *msi_create_irq_domain(struct irq_domain *parent);
> +extern int msi_irq_domain_alloc_irqs(struct irq_domain *domain, int type,
> +				     struct pci_dev *dev, void *arg);
> +
> +extern irq_hw_number_t arch_msi_irq_domain_get_hwirq(void *arg);
> +extern void arch_msi_irq_domain_set_hwirq(void *arg, irq_hw_number_t hwirq);

Look at the rest of the file and notice that the existing code does not use
"extern" on function declarations.

> +#endif	/* CONFIG_PCI_MSI_IRQ_DOMAIN */

Use a space here (not a tab), like the #endif just below.

>  #endif /* LINUX_MSI_H */
> -- 
> 1.7.10.4
> 
