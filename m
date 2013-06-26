Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3FZTPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:15:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab3FZTO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:14:59 -0400
Message-ID: <1372274083.30572.577.camel@ul30vt.home>
Subject: Re: [PATCH 3/3 v16] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
From: Alex Williamson <alex.williamson@redhat.com>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: "joro@8bytes.org" <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>, Timur Tabi <timur@tabi.org>
Date: Wed, 26 Jun 2013 13:14:43 -0600
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D5DD70C@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1371744089-17780-1-git-send-email-Varun.Sethi@freescale.com>
	 <1371744089-17780-2-git-send-email-Varun.Sethi@freescale.com>
	 <1372136211.30572.377.camel@ul30vt.home>
	 <C5ECD7A89D1DC44195F34B25E172658D5DD70C@039-SN2MPN1-011.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 06:24 +0000, Sethi Varun-B16395 wrote:
> 
> > -----Original Message-----
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Tuesday, June 25, 2013 10:27 AM
> > To: Sethi Varun-B16395
> > Cc: joro@8bytes.org; iommu@lists.linux-foundation.org; linuxppc-
> > dev@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> > benh@kernel.crashing.org; galak@kernel.crashing.org; Yoder Stuart-B08248;
> > Wood Scott-B07421; Timur Tabi
> > Subject: Re: [PATCH 3/3 v16] iommu/fsl: Freescale PAMU driver and iommu
> > implementation.
> > 
> > On Thu, 2013-06-20 at 21:31 +0530, Varun Sethi wrote:
> > 
> > > +#define REQ_ACS_FLAGS	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR |
> > PCI_ACS_UF)
> > > +
> > > +static struct iommu_group *get_device_iommu_group(struct device *dev)
> > > +{
> > > +	struct iommu_group *group;
> > > +
> > > +	group = iommu_group_get(dev);
> > > +	if (!group)
> > > +		group = iommu_group_alloc();
> > > +
> > > +	return group;
> > > +}
> > > +
> > [snip]
> > > +
> > 
> > This really gets parent or peer, right?
> > 
> > > +static struct iommu_group *get_peer_pci_device_group(struct pci_dev
> > > +*pdev) {
> > > +	struct iommu_group *group = NULL;
> > > +
> > > +	/* check if this is the first device on the bus*/
> > > +	if (pdev->bus_list.next == pdev->bus_list.prev) {
> > 
> > It's a list_head, use list functions.  The list implementation should be
> > treated as opaque.
> > 
> > if (list_is_singular(&pdev->bus_list))
> > 
> > > +		struct pci_bus *bus = pdev->bus->parent;
> > > +		/* Traverese the parent bus list to get
> > > +		 * pdev & dev for the sibling device.
> > > +		 */
> > > +		while (bus) {
> > > +			if (!list_empty(&bus->devices)) {
> > > +				pdev = container_of(bus->devices.next,
> > > +					            struct pci_dev, bus_list);
> > 
> > pdev = list_first_entry(&bus->devices, struct pci_dev, bus_list);
> > 
> > > +				group = iommu_group_get(&pdev->dev);
> > > +				break;
> > > +			} else
> > > +				bus = bus->parent;
> > 
> > Is this ever reached?  Don't you always have bus->self?
> > 
> [Sethi Varun-B16395] Not sure I understand. Trying to get the group
> information from the parent bus, if there are no sibling devices on
> the current bus.

I assume there's always a bridge on a bus, but maybe that bridge
(parent->self) is not in the list of parent->devices?  Is that the case?
If not, then there's always a device on the bus, the bridge that created
it.

> > > +		}
> > > +	} else {
> > > +		/*
> > > +		 * Get the pdev & dev for the sibling device
> > > +		 */
> > > +		pdev = container_of(pdev->bus_list.prev,
> > > +				    struct pci_dev, bus_list);
> > 
> > How do you know if you're at the head or tail of the list?
> > 
> > struct pci_dev *tmp;
> > list_for_each_entry(tmp, &pdev->bus_list, bus_list) {
> > 	if (tmp == pdev)
> > 		continue;
> > 
> > 	group = iommu_group_get(&tmp->dev);
> > 	break;
> > }
> > 
> > > +		group = iommu_group_get(&pdev->dev);
> > > +	}
> > > +
> > > +	return group;
> > > +}
> > > +
> > > +static struct iommu_group *get_pci_device_group(struct pci_dev *pdev)
> > > +{
> > > +	struct iommu_group *group = NULL;
> > > +	struct pci_dev *bridge, *dma_pdev = NULL;
> > > +	struct pci_controller *pci_ctl;
> > > +	bool pci_endpt_partioning;
> > > +
> > > +	pci_ctl = pci_bus_to_host(pdev->bus);
> > > +	pci_endpt_partioning = check_pci_ctl_endpt_part(pci_ctl);
> > > +	/* We can partition PCIe devices so assign device group to the
> > device */
> > > +	if (pci_endpt_partioning) {
> > > +		bridge = pci_find_upstream_pcie_bridge(pdev);
> > > +		if (bridge) {
> > > +			if (pci_is_pcie(bridge))
> > > +				dma_pdev = pci_get_domain_bus_and_slot(
> > > +						pci_domain_nr(pdev->bus),
> > > +						bridge->subordinate->number, 0);
> > > +			if (!dma_pdev)
> > > +				dma_pdev = pci_dev_get(bridge);
> > > +		} else
> > > +			dma_pdev = pci_dev_get(pdev);
> > > +
> > > +		/* Account for quirked devices */
> > > +		swap_pci_ref(&dma_pdev, pci_get_dma_source(dma_pdev));
> > > +
> > > +		/*
> > > +		 * If it's a multifunction device that does not support our
> > > +		 * required ACS flags, add to the same group as function 0.
> > > +		 */
> > 
> > See c14d2690 in Joerg's next tree, using function 0 was a poor
> > assumption.
> [Sethi Varun-B16395] ok.
> 
> > 
> > > +		if (dma_pdev->multifunction &&
> > > +		    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS))
> > > +			swap_pci_ref(&dma_pdev,
> > > +				     pci_get_slot(dma_pdev->bus,
> > > +						  PCI_DEVFN(PCI_SLOT(dma_pdev-
> > >devfn),
> > > +						  0)));
> > > +
> > > +		group = get_device_iommu_group(&pdev->dev);
> > > +		pci_dev_put(pdev);
> > 
> > What was the point of all the above if we use pdev here instead of
> > dma_pdev?  Wrong device and broken reference counting.
> [Sethi Varun-B16395] Will fix this
> 
>   This also isn't
> > testing ACS all the way up to the root complex or controller.
> [Sethi Varun-B16395] In our case the IOMMU can differentiate
> transactions based on the LIODN. The PCIe controller can generate a
> unique LIODN based on the bus,device,function number. I believe this
> would even be true for devices connected to a PCIe bridge (and not on
> the root bus). So, do we still need to check for ACS up to the root
> node?

ACS is the PCI capability that tells us whether a device allows
peer-to-peer or requires all DMA to be forwarded upstream.  At any step
along the way from an endpoint to the IOMMU the transaction can be
re-routed.  We therefore need to test the ACS property not only of the
endpoint, but every device between the endpoint and the IOMMU to form
the IOMMU groups.  An IOMMU cannot isolate a device if a DMA access is
re-routed by a link in the topology that prevents the IOMMU from even
being part of the transaction.  Thanks,

Alex


