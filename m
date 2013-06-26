Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab3FZGYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 02:24:32 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:19286 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751683Ab3FZGY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 02:24:29 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI9371I936eI542I1432Id799hzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "joro@8bytes.org" <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>, Timur Tabi <timur@tabi.org>
Subject: RE: [PATCH 3/3 v16] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
Thread-Topic: [PATCH 3/3 v16] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
Thread-Index: AQHObdDbhuzc7AvSqEOMltoXl9mtvJlF5S2AgAGnMnA=
Date: Wed, 26 Jun 2013 06:24:24 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D5DD70C@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1371744089-17780-1-git-send-email-Varun.Sethi@freescale.com>
	 <1371744089-17780-2-git-send-email-Varun.Sethi@freescale.com>
 <1372136211.30572.377.camel@ul30vt.home>
In-Reply-To: <1372136211.30572.377.camel@ul30vt.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.248.162]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5Q6OedK003780



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Tuesday, June 25, 2013 10:27 AM
> To: Sethi Varun-B16395
> Cc: joro@8bytes.org; iommu@lists.linux-foundation.org; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> benh@kernel.crashing.org; galak@kernel.crashing.org; Yoder Stuart-B08248;
> Wood Scott-B07421; Timur Tabi
> Subject: Re: [PATCH 3/3 v16] iommu/fsl: Freescale PAMU driver and iommu
> implementation.
> 
> On Thu, 2013-06-20 at 21:31 +0530, Varun Sethi wrote:
> 
> > +#define REQ_ACS_FLAGS	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR |
> PCI_ACS_UF)
> > +
> > +static struct iommu_group *get_device_iommu_group(struct device *dev)
> > +{
> > +	struct iommu_group *group;
> > +
> > +	group = iommu_group_get(dev);
> > +	if (!group)
> > +		group = iommu_group_alloc();
> > +
> > +	return group;
> > +}
> > +
> [snip]
> > +
> 
> This really gets parent or peer, right?
> 
> > +static struct iommu_group *get_peer_pci_device_group(struct pci_dev
> > +*pdev) {
> > +	struct iommu_group *group = NULL;
> > +
> > +	/* check if this is the first device on the bus*/
> > +	if (pdev->bus_list.next == pdev->bus_list.prev) {
> 
> It's a list_head, use list functions.  The list implementation should be
> treated as opaque.
> 
> if (list_is_singular(&pdev->bus_list))
> 
> > +		struct pci_bus *bus = pdev->bus->parent;
> > +		/* Traverese the parent bus list to get
> > +		 * pdev & dev for the sibling device.
> > +		 */
> > +		while (bus) {
> > +			if (!list_empty(&bus->devices)) {
> > +				pdev = container_of(bus->devices.next,
> > +					            struct pci_dev, bus_list);
> 
> pdev = list_first_entry(&bus->devices, struct pci_dev, bus_list);
> 
> > +				group = iommu_group_get(&pdev->dev);
> > +				break;
> > +			} else
> > +				bus = bus->parent;
> 
> Is this ever reached?  Don't you always have bus->self?
> 
[Sethi Varun-B16395] Not sure I understand. Trying to get the group information from the parent bus, if there are no sibling devices on the current bus.

> > +		}
> > +	} else {
> > +		/*
> > +		 * Get the pdev & dev for the sibling device
> > +		 */
> > +		pdev = container_of(pdev->bus_list.prev,
> > +				    struct pci_dev, bus_list);
> 
> How do you know if you're at the head or tail of the list?
> 
> struct pci_dev *tmp;
> list_for_each_entry(tmp, &pdev->bus_list, bus_list) {
> 	if (tmp == pdev)
> 		continue;
> 
> 	group = iommu_group_get(&tmp->dev);
> 	break;
> }
> 
> > +		group = iommu_group_get(&pdev->dev);
> > +	}
> > +
> > +	return group;
> > +}
> > +
> > +static struct iommu_group *get_pci_device_group(struct pci_dev *pdev)
> > +{
> > +	struct iommu_group *group = NULL;
> > +	struct pci_dev *bridge, *dma_pdev = NULL;
> > +	struct pci_controller *pci_ctl;
> > +	bool pci_endpt_partioning;
> > +
> > +	pci_ctl = pci_bus_to_host(pdev->bus);
> > +	pci_endpt_partioning = check_pci_ctl_endpt_part(pci_ctl);
> > +	/* We can partition PCIe devices so assign device group to the
> device */
> > +	if (pci_endpt_partioning) {
> > +		bridge = pci_find_upstream_pcie_bridge(pdev);
> > +		if (bridge) {
> > +			if (pci_is_pcie(bridge))
> > +				dma_pdev = pci_get_domain_bus_and_slot(
> > +						pci_domain_nr(pdev->bus),
> > +						bridge->subordinate->number, 0);
> > +			if (!dma_pdev)
> > +				dma_pdev = pci_dev_get(bridge);
> > +		} else
> > +			dma_pdev = pci_dev_get(pdev);
> > +
> > +		/* Account for quirked devices */
> > +		swap_pci_ref(&dma_pdev, pci_get_dma_source(dma_pdev));
> > +
> > +		/*
> > +		 * If it's a multifunction device that does not support our
> > +		 * required ACS flags, add to the same group as function 0.
> > +		 */
> 
> See c14d2690 in Joerg's next tree, using function 0 was a poor
> assumption.
[Sethi Varun-B16395] ok.

> 
> > +		if (dma_pdev->multifunction &&
> > +		    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS))
> > +			swap_pci_ref(&dma_pdev,
> > +				     pci_get_slot(dma_pdev->bus,
> > +						  PCI_DEVFN(PCI_SLOT(dma_pdev-
> >devfn),
> > +						  0)));
> > +
> > +		group = get_device_iommu_group(&pdev->dev);
> > +		pci_dev_put(pdev);
> 
> What was the point of all the above if we use pdev here instead of
> dma_pdev?  Wrong device and broken reference counting.
[Sethi Varun-B16395] Will fix this

  This also isn't
> testing ACS all the way up to the root complex or controller.
[Sethi Varun-B16395] In our case the IOMMU can differentiate transactions based on the LIODN. The PCIe controller can generate a unique LIODN based on the bus,device,function number. I believe this would even be true for devices connected to a PCIe bridge (and not on the root bus). So, do we still need to check for ACS up to the root node?

-Varun
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
