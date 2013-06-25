Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab3FYE5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 00:57:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab3FYE5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 00:57:07 -0400
Message-ID: <1372136211.30572.377.camel@ul30vt.home>
Subject: Re: [PATCH 3/3 v16] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
From: Alex Williamson <alex.williamson@redhat.com>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: joro@8bytes.org, iommu@lists.linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, galak@kernel.crashing.org,
        stuart.yoder@freescale.com, scottwood@freescale.com,
        Timur Tabi <timur@tabi.org>
Date: Mon, 24 Jun 2013 22:56:51 -0600
In-Reply-To: <1371744089-17780-2-git-send-email-Varun.Sethi@freescale.com>
References: <1371744089-17780-1-git-send-email-Varun.Sethi@freescale.com>
	 <1371744089-17780-2-git-send-email-Varun.Sethi@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 21:31 +0530, Varun Sethi wrote:

> +#define REQ_ACS_FLAGS	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
> +
> +static struct iommu_group *get_device_iommu_group(struct device *dev)
> +{
> +	struct iommu_group *group;
> +
> +	group = iommu_group_get(dev);
> +	if (!group)
> +		group = iommu_group_alloc();
> +
> +	return group;
> +}
> +
[snip]
> +

This really gets parent or peer, right?

> +static struct iommu_group *get_peer_pci_device_group(struct pci_dev *pdev)
> +{
> +	struct iommu_group *group = NULL;
> +
> +	/* check if this is the first device on the bus*/
> +	if (pdev->bus_list.next == pdev->bus_list.prev) {

It's a list_head, use list functions.  The list implementation should be
treated as opaque.

if (list_is_singular(&pdev->bus_list))

> +		struct pci_bus *bus = pdev->bus->parent;
> +		/* Traverese the parent bus list to get
> +		 * pdev & dev for the sibling device.
> +		 */
> +		while (bus) {
> +			if (!list_empty(&bus->devices)) {
> +				pdev = container_of(bus->devices.next,
> +					            struct pci_dev, bus_list);

pdev = list_first_entry(&bus->devices, struct pci_dev, bus_list);

> +				group = iommu_group_get(&pdev->dev);
> +				break;
> +			} else
> +				bus = bus->parent;

Is this ever reached?  Don't you always have bus->self?

> +		}
> +	} else {
> +		/*
> +		 * Get the pdev & dev for the sibling device
> +		 */
> +		pdev = container_of(pdev->bus_list.prev,
> +				    struct pci_dev, bus_list);

How do you know if you're at the head or tail of the list?

struct pci_dev *tmp;
list_for_each_entry(tmp, &pdev->bus_list, bus_list) {
	if (tmp == pdev)
		continue;

	group = iommu_group_get(&tmp->dev);
	break;
}

> +		group = iommu_group_get(&pdev->dev);
> +	}
> +
> +	return group;
> +}
> +
> +static struct iommu_group *get_pci_device_group(struct pci_dev *pdev)
> +{
> +	struct iommu_group *group = NULL;
> +	struct pci_dev *bridge, *dma_pdev = NULL;
> +	struct pci_controller *pci_ctl;
> +	bool pci_endpt_partioning;
> +
> +	pci_ctl = pci_bus_to_host(pdev->bus);
> +	pci_endpt_partioning = check_pci_ctl_endpt_part(pci_ctl);
> +	/* We can partition PCIe devices so assign device group to the device */
> +	if (pci_endpt_partioning) {
> +		bridge = pci_find_upstream_pcie_bridge(pdev);
> +		if (bridge) {
> +			if (pci_is_pcie(bridge))
> +				dma_pdev = pci_get_domain_bus_and_slot(
> +						pci_domain_nr(pdev->bus),
> +						bridge->subordinate->number, 0);
> +			if (!dma_pdev)
> +				dma_pdev = pci_dev_get(bridge);
> +		} else
> +			dma_pdev = pci_dev_get(pdev);
> +
> +		/* Account for quirked devices */
> +		swap_pci_ref(&dma_pdev, pci_get_dma_source(dma_pdev));
> +
> +		/*
> +		 * If it's a multifunction device that does not support our
> +		 * required ACS flags, add to the same group as function 0.
> +		 */

See c14d2690 in Joerg's next tree, using function 0 was a poor
assumption.

> +		if (dma_pdev->multifunction &&
> +		    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS))
> +			swap_pci_ref(&dma_pdev,
> +				     pci_get_slot(dma_pdev->bus,
> +						  PCI_DEVFN(PCI_SLOT(dma_pdev->devfn),
> +						  0)));
> +
> +		group = get_device_iommu_group(&pdev->dev);
> +		pci_dev_put(pdev);

What was the point of all the above if we use pdev here instead of
dma_pdev?  Wrong device and broken reference counting.  This also isn't
testing ACS all the way up to the root complex or controller.

> +		/*
> +		 * PCIe controller is not a paritionable entity
> +		 * free the controller device iommu_group.
> +		 */
> +		if (pci_ctl->parent->iommu_group)
> +			iommu_group_remove_device(pci_ctl->parent);
> +	} else {
> +		/*
> +		 * All devices connected to the controller will share the
> +		 * PCI controllers device group. If this is the first
> +		 * device to be probed for the pci controller, copy the
> +		 * device group information from the PCI controller device
> +		 * node and remove the PCI controller iommu group.
> +		 * For subsequent devices, the iommu group information can
> +		 * be obtained from sibling devices (i.e. from the bus_devices
> +		 * link list).
> +		 */
> +		if (pci_ctl->parent->iommu_group) {
> +			group = get_device_iommu_group(pci_ctl->parent);
> +			iommu_group_remove_device(pci_ctl->parent);
> +		} else
> +			group = get_peer_pci_device_group(pdev);
> +	}
> +
> +	return group;
> +}
> +
> +static int fsl_pamu_add_device(struct device *dev)
> +{
> +	struct iommu_group *group = NULL;
> +	struct pci_dev *pdev;
> +	const u32 *prop;
> +	int ret, len;
> +
> +	/*
> +	 * For platform devices we allocate a separate group for
> +	 * each of the devices.
> +	 */
> +	if (dev->bus == &pci_bus_type) {
> +		pdev = to_pci_dev(dev);
> +		/* Don't create device groups for virtual PCI bridges */
> +		if (pdev->subordinate)
> +			return 0;
> +
> +		group = get_pci_device_group(pdev);
> +
> +	} else {
> +		prop = of_get_property(dev->of_node, "fsl,liodn", &len);
> +		if (prop)
> +			group = get_device_iommu_group(dev);
> +	}
> +
> +	if (!group || IS_ERR(group))
> +		return PTR_ERR(group);
> +
> +	ret = iommu_group_add_device(group, dev);
> +
> +	iommu_group_put(group);
> +	return ret;
> +}
> +
> +static void fsl_pamu_remove_device(struct device *dev)
> +{
> +	iommu_group_remove_device(dev);
> +}


