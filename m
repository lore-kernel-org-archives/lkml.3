Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139AbaJBGJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 02:09:59 -0400
Received: from ozlabs.org ([103.22.144.67]:34789 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbaJBGJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 02:09:59 -0400
Message-ID: <1412230196.6143.16.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH v2 08/17] powerpc/powerpc: Add new PCIe functions for
 allocating cxl interrupts
From: Michael Neuling <mikey@neuling.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: greg@kroah.com, arnd@arndb.de, benh@kernel.crashing.org, anton@samba.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, jk@ozlabs.org,
        imunsie@au.ibm.com, cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Thu, 02 Oct 2014 16:09:56 +1000
In-Reply-To: <20141002031659.DB564140188@ozlabs.org>
References: <20141002031659.DB564140188@ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 13:16 +1000, Michael Ellerman wrote:
> On Tue, 2014-30-09 at 10:34:57 UTC, Michael Neuling wrote:
> > From: Ian Munsie <imunsie@au1.ibm.com>
> > 
> > This adds a number of functions for allocating IRQs under powernv PCIe for cxl.
> > 
> > diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
> > index 329164f..b0b96f0 100644
> > --- a/arch/powerpc/platforms/powernv/pci-ioda.c
> > +++ b/arch/powerpc/platforms/powernv/pci-ioda.c
> > @@ -503,6 +505,138 @@ static struct pnv_ioda_pe *pnv_ioda_get_pe(struct pci_dev *dev)
> >  		return NULL;
> >  	return &phb->ioda.pe_array[pdn->pe_number];
> >  }
> > +
> > +struct device_node *pnv_pci_to_phb_node(struct pci_dev *dev)
> > +{
> > +        struct pci_controller *hose = pci_bus_to_host(dev->bus);
> > +
> > +        return hose->dn;
> > +}
> > +EXPORT_SYMBOL(pnv_pci_to_phb_node);
> > +
> > +#ifdef CONFIG_CXL_BASE
> > +int pnv_phb_to_cxl(struct pci_dev *dev)
> > +{
> > +	struct pci_controller *hose = pci_bus_to_host(dev->bus);
> > +	struct pnv_phb *phb = hose->private_data;
> > +	struct pnv_ioda_pe *pe;
> > +	int rc;
> > +
> > +	if (!(pe = pnv_ioda_get_pe(dev))) {
> > +		rc = -ENODEV;
> > +		goto out;
> > +	}
> 
> That'd be a lot simpler as:
> 
> 	pe = pnv_ioda_get_pe(dev);
> 	if (!pe)
> 		return -ENODEV;

OK

> > +	pe_info(pe, "switch PHB to CXL\n");
> > +	pe_info(pe, "PHB-ID  : 0x%016llx\n", phb->opal_id);
> > +	pe_info(pe, "     pe : %i\n", pe->pe_number);
> 
> Spacing is a bit weird but maybe it matches something else?

Actually, we switched this to pe_info() based on one of Gavin's reviews,
so the pe_number and opal_id being printed here are not needed anymore.
I'm simplifying this into one line.

	pe_info(pe, "Switching PHB to CXL\n");


> 
> > +
> > +	if ((rc = opal_pci_set_phb_cxl_mode(phb->opal_id, 1, pe->pe_number)))
> > +		dev_err(&dev->dev, "opal_pci_set_phb_cxl_mode failed: %i\n", rc);
> 
> Again why not:
> 
> 	rc = opal_pci_set_phb_cxl_mode(phb->opal_id, 1, pe->pe_number);
> 	if (rc)
> 		dev_err(&dev->dev, "opal_pci_set_phb_cxl_mode failed: %i\n", rc);

Ok.

> > +out:
> > +	return rc;
> > +}
> > +EXPORT_SYMBOL(pnv_phb_to_cxl);
> > +
> 
> > +int pnv_cxl_alloc_hwirq_ranges(struct cxl_irq_ranges *irqs,
> > +			       struct pci_dev *dev, int num)
> 
> This could use some documentation.
> 
> It seems to be that it allocates num irqs in some number of ranges, up to
> CXL_IRQ_RANGES?

OK

> 
> > +{
> > +	struct pci_controller *hose = pci_bus_to_host(dev->bus);
> > +	struct pnv_phb *phb = hose->private_data;
> > +	int range = 0;
> 
> You reinitialise to 1 below?

Oops

> 
> > +	int hwirq;
> > +	int try;
> 
> So these can be:
> 
> 	int hwirq, try, range;
> 
> > +	memset(irqs, 0, sizeof(struct cxl_irq_ranges));
> > +
> > +	for (range = 1; range < CXL_IRQ_RANGES && num; range++) {
> 
> I think this would be clearer if range was just called "i" as usual.

OK

> Why does it start at 1 ?

0 is used by the data storage interrupt. I'll add a comment to clarify.

> 
> > +		try = num;
> > +		while (try) {
> > +			hwirq = msi_bitmap_alloc_hwirqs(&phb->msi_bmp, try);
> > +			if (hwirq >= 0)
> > +				break;
> > +			try /= 2;
> > +		}
> > +		if (!try)
> > +			goto fail;
> > +
> > +		irqs->offset[range] = phb->msi_base + hwirq;
> > +		irqs->range[range] = try;
> 
> irqs->range is irq_hw_number_t but looks like it should just be uint.
> 
> > +		pr_devel("cxl alloc irq range 0x%x: offset: 0x%lx  limit: %li\n",
> > +			 range, irqs->offset[range], irqs->range[range]);
> > +		num -= try;
> > +	}
> > +	if (num)
> > +		goto fail;
> > +
> > +	return 0;
> > +fail:
> > +	for (range--; range >= 0; range--) {
> > +		hwirq = irqs->offset[range] - phb->msi_base;
> > +		msi_bitmap_free_hwirqs(&phb->msi_bmp, hwirq,
> > +				       irqs->range[range]);
> > +		irqs->range[range] = 0;
> > +	}
> 
> Because you zero ranges at the top I think you can replace all of the fail
> logic with a call to pnv_cxl_release_hwirq_ranges().

Nice.  Will change.

> 
> 
> > +	return -ENOSPC;
> > +}
> > +EXPORT_SYMBOL(pnv_cxl_alloc_hwirq_ranges);
> > +
> > +void pnv_cxl_release_hwirq_ranges(struct cxl_irq_ranges *irqs,
> > +				  struct pci_dev *dev)
> > +{
> > +	struct pci_controller *hose = pci_bus_to_host(dev->bus);
> > +	struct pnv_phb *phb = hose->private_data;
> > +	int range = 0;
> 
> Unnecessary init again.

Yep. I'll change to 'i' too.

> > +	int hwirq;
> > +
> > +	for (range = 0; range < 4; range++) {
> 
> Shouldn't 4 be CXL_IRQ_RANGES ?

Yep.

> 
> > +		hwirq = irqs->offset[range] - phb->msi_base;
> 
> That should be inside the if.

Yep.

> 
> Or better do:
> 		if (!irqs->range[range])
> 			continue;
> 		...

Nice.

> 
> > +		if (irqs->range[range]) {
> > +			pr_devel("cxl release irq range 0x%x: offset: 0x%lx  limit: %ld\n",
> > +				 range, irqs->offset[range],
> > +				 irqs->range[range]);
> > +			msi_bitmap_free_hwirqs(&phb->msi_bmp, hwirq,
> > +					       irqs->range[range]);
> > +		}
> > +	}
> > +}
> > +EXPORT_SYMBOL(pnv_cxl_release_hwirq_ranges);
> > +
> > +int pnv_cxl_get_irq_count(struct pci_dev *dev)
> > +{
> > +	struct pci_controller *hose = pci_bus_to_host(dev->bus);
> > +        struct pnv_phb *phb = hose->private_data;
> 
> Indentation is fubar.

OK

> 
> > +	return phb->msi_bmp.irq_count;
> > +}
> > +EXPORT_SYMBOL(pnv_cxl_get_irq_count);
> > +
> > +#endif /* CONFIG_CXL_BASE */
> >  #endif /* CONFIG_PCI_MSI */
> >  
> >  static int pnv_ioda_configure_pe(struct pnv_phb *phb, struct pnv_ioda_pe *pe)
> > @@ -1330,6 +1464,33 @@ static void set_msi_irq_chip(struct pnv_phb *phb, unsigned int virq)
> >  	irq_set_chip(virq, &phb->ioda.irq_chip);
> >  }
> >  
> > +#ifdef CONFIG_CXL_BASE
> 
> Why is this here and not in the previous #ifdef CONFIG_CXL_BASE block ?

I can actually move the rest of the cxl code down here too.  So I'll do
that.

> 
> > +int pnv_cxl_ioda_msi_setup(struct pci_dev *dev, unsigned int hwirq,
> > +			   unsigned int virq)
> > +{
> > +	struct pci_controller *hose = pci_bus_to_host(dev->bus);
> > +	struct pnv_phb *phb = hose->private_data;
> > +	unsigned int xive_num = hwirq - phb->msi_base;
> > +	struct pnv_ioda_pe *pe;
> > +	int rc;
> > +
> > +	if (!(pe = pnv_ioda_get_pe(dev)))
> > +		return -ENODEV;
> > +
> > +	/* Assign XIVE to PE */
> > +	rc = opal_pci_set_xive_pe(phb->opal_id, pe->pe_number, xive_num);
> > +	if (rc) {
> > +		pr_warn("%s: OPAL error %d setting msi_base 0x%x hwirq 0x%x XIVE 0x%x PE\n",
> > +			pci_name(dev), rc, phb->msi_base, hwirq, xive_num);
> 
> dev_warn() ?

I'm going to move it to the pe_warn() we have here.

Cheers,
Mikey
