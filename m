Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab3F1SVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:21:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab3F1SVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:21:24 -0400
Message-ID: <1372443669.30572.771.camel@ul30vt.home>
Subject: Re: [PATCH 3/3 v17] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
From: Alex Williamson <alex.williamson@redhat.com>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: joro@8bytes.org, iommu@lists.linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, galak@kernel.crashing.org,
        stuart.yoder@freescale.com, scottwood@freescale.com,
        Timur Tabi <timur@tabi.org>
Date: Fri, 28 Jun 2013 12:21:09 -0600
In-Reply-To: <1372405132-14170-1-git-send-email-Varun.Sethi@freescale.com>
References: <1372405132-14170-1-git-send-email-Varun.Sethi@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 13:08 +0530, Varun Sethi wrote:
> Following is a brief description of the PAMU hardware:
> PAMU determines what action to take and whether to authorize the action on
> the basis of the memory address, a Logical IO Device Number (LIODN), and
> PAACT table (logically) indexed by LIODN and address. Hardware devices which
> need to access memory must provide an LIODN in addition to the memory address.
> 
> Peripheral Access Authorization and Control Tables (PAACTs) are the primary
> data structures used by PAMU. A PAACT is a table of peripheral access
> authorization and control entries (PAACE).Each PAACE defines the range of
> I/O bus address space that is accessible by the LIOD and the associated access
> capabilities.
> 
> There are two types of PAACTs: primary PAACT (PPAACT) and secondary PAACT
> (SPAACT).A given physical I/O device may be able to act as one or more
> independent logical I/O devices (LIODs). Each such logical I/O device is
> assigned an identifier called logical I/O device number (LIODN). A LIODN is
> allocated a contiguous portion of the I/O bus address space called the DSA window
> for performing DSA operations. The DSA window may optionally be divided into
> multiple sub-windows, each of which may be used to map to a region in system
> storage space. The first sub-window is referred to as the primary sub-window
> and the remaining are called secondary sub-windows.
> 
> This patch provides the PAMU driver (fsl_pamu.c) and the corresponding IOMMU
> API implementation (fsl_pamu_domain.c). The PAMU hardware driver (fsl_pamu.c)
> has been derived from the work done by Ashish Kalra and Timur Tabi.
[snip]
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
> +static  bool check_pci_ctl_endpt_part(struct pci_controller *pci_ctl)
> +{
> +	u32 version;
> +
> +	/* Check the PCI controller version number by readding BRR1 register */
> +	version = in_be32(pci_ctl->cfg_addr + (PCI_FSL_BRR1 >> 2));
> +	version &= PCI_FSL_BRR1_VER;
> +	/* If PCI controller version is >= 0x204 we can partition endpoints*/
> +	if (version >= 0x204)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +/* Get iommu group information from peer devices or devices on the parent bus */
> +static struct iommu_group *get_peer_pci_device_group(struct pci_dev *pdev)
> +{
> +	struct pci_dev *tmp;
> +	struct iommu_group *group = NULL;
> +
> +	/* check if this is the first device on the bus*/
> +	if (list_is_singular(&pdev->bus_list)) {
> +		struct pci_bus *bus = pdev->bus->parent;
> +		/* Traverese the parent bus list to get
> +		 * the iommu group for devices on the
> +		 * parent bus.
> +		 */
> +		while (bus && !group) {
> +			list_for_each_entry(tmp, &bus->devices, bus_list) {
> +				group = iommu_group_get(&tmp->dev);
> +				if (group)
> +					break;
> +			}
> +
> +			bus = bus->parent;
> +		}
> +	} else {
> +		/*
> +		 * Get the iommu group for the sibling device
> +		 */
> +		list_for_each_entry(tmp, &pdev->bus_list, bus_list) {
> +			if (tmp == pdev)
> +				continue;
> +			group = iommu_group_get(&tmp->dev);
> +			if (group)
> +				break;
> +		}
> +	}
> +
> +	return group;

Can't we handle both of these with one loop?

struct pci_bus *bus = pdev->bus;
while (bus) {
	list_for_each_entry(tmp, &bus->devices, bus_list) {
		if (tmp == pdev)
			continue;
		group = iommu_group_get(&tmp->dev);
		if (group)
			return group;
	}
	bus = bus->parent;
}
return NULL;

get_shared_pci_device_group() might be another naming option.

> +}
> +
> +static struct iommu_group *get_pci_device_group(struct pci_dev *pdev)
> +{
> +	struct pci_controller *pci_ctl;
> +	bool pci_endpt_partioning;
> +	struct iommu_group *group = NULL;
> +	struct pci_dev *bridge, *dma_pdev = NULL;
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
> +		 * required ACS flags, add to the same group as lowest numbered
> +		 * function that also does not suport the required ACS flags.
> +		 */
> +		if (dma_pdev->multifunction &&
> +		    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS)) {
> +			u8 i, slot = PCI_SLOT(dma_pdev->devfn);
> +
> +			for (i = 0; i < 8; i++) {
> +				struct pci_dev *tmp;
> +
> +				tmp = pci_get_slot(dma_pdev->bus, PCI_DEVFN(slot, i));
> +				if (!tmp)
> +					continue;
> +
> +				if (!pci_acs_enabled(tmp, REQ_ACS_FLAGS)) {
> +					swap_pci_ref(&dma_pdev, tmp);
> +					break;
> +				}
> +				pci_dev_put(tmp);
> +			}
> +		}
> +
> +		/*
> +		 * Devices on the root bus go through the iommu.  If that's not us,
> +	 	 * find the next upstream device and test ACS up to the root bus.
> +		 * Finding the next device may require skipping virtual buses.
> +		 */
> +		while (!pci_is_root_bus(dma_pdev->bus)) {
> +			struct pci_bus *bus = dma_pdev->bus;
> +
> +			while (!bus->self) {
> +				if (!pci_is_root_bus(bus))
> +					bus = bus->parent;
> +				else
> +					goto root_bus;
> +			}
> +
> +			if (pci_acs_path_enabled(bus->self, NULL, REQ_ACS_FLAGS))
> +				break;
> +
> +			swap_pci_ref(&dma_pdev, pci_dev_get(bus->self));
> +		}
> +
> +root_bus:
> +		group = get_device_iommu_group(&dma_pdev->dev);
> +		pci_dev_put(dma_pdev);
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

Seems ok otherwise.  Thanks,

Alex

