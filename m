Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaKFKCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:02:51 -0500
Received: from www.linutronix.de ([62.245.132.108]:41637 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaKFKCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:02:43 -0500
Date: Thu, 6 Nov 2014 11:01:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch Part2 v4 21/31] PCI/MSI: enhance PCI MSI core to support
 hierarchy irqdomain
In-Reply-To: <1415102525-9898-22-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1411061023400.24960@nanos>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com> <1415102525-9898-22-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2014, Jiang Liu wrote:
> +#ifdef	CONFIG_PCI_MSI_IRQ_DOMAIN
> +static inline irq_hw_number_t
> +msi_get_hwirq(struct pci_dev *pdev, struct msi_desc *msidesc)
> +{
> +	return (irq_hw_number_t)msidesc->msi_attrib.entry_nr |
> +		PCI_DEVID(pdev->bus->number, pdev->devfn) << 11 |
> +		(pci_domain_nr(pdev->bus) & 0xFFFFFFFF) << 27;
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
> +		for (i = 0; i < nr_irqs; i++) {
> +			irq_domain_set_hwirq_and_chip(domain, virq + i,
> +					hwirq + i, &msi_chip, (void *)(long)i);

I think msi_chip being a global unique thing is problematic. It does
not allow multi platform kernels to select a chip at boot time and it
does not allow per domain chip implementations when you have multiple
msi domains. Aside of that msi_chip is a pretty bad name for a global.

The solution is rather simple and msi is wide spread enough to justify
that.

struct irqdomain_msi_data {
       struct irq_chip       *irq_chip;
};

We make that a struct so we can accomodate for other special things
which might be domain rather than architecture specific. One
obvious use case would be to hold the arch_msi_irq_domain_get/set_hwirq
callbacks.

struct irq_domain *msi_create_irq_domain(struct irq_domain *parent,
       		  			 struct irqdomain_msi_data *data)
{
        struct irq_domain *domain;

        domain = irq_domain_add_tree(NULL, &msi_domain_ops, NULL);
        if (domain) {
                domain->parent = parent;
		domain->msi_data = data;
	}
        return domain;
}

Now the above becomes:

    	struct irq_chip *msi_chip = domain->msi_data->irq_chip;

	irq_domain_set_hwirq_and_chip(domain, virq + i,
				      hwirq + i, msi_chip, (void *)(long)i);

> +int msi_irq_domain_alloc_irqs(struct irq_domain *domain, int type,
> +			      struct pci_dev *dev, void *arg)
> +{
> +	int i, virq;
> +	struct msi_desc *msidesc;
> +	int node = dev_to_node(&dev->dev);
> +
> +	list_for_each_entry(msidesc, &dev->msi_list, list) {
> +		arch_msi_irq_domain_set_hwirq(arg, msi_get_hwirq(dev, msidesc));

The arch_xxx callbacks want to be documented. It's not obvious what
they are supposed to do.

Thanks,

	tglx
