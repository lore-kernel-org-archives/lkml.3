Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab3FCPKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:10:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab3FCPKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:10:51 -0400
Message-ID: <1370272217.30975.283.camel@ul30vt.home>
Subject: Re: [PATCH] iommu: amd/intel: Remove multifunction assumption
 around	grouping
From: Alex Williamson <alex.williamson@redhat.com>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 03 Jun 2013 09:10:17 -0600
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D56A9F4@039-SN2MPN1-013.039d.mgd.msft.net>
References: <20130530183855.14612.15585.stgit@bling.home>
	 <C5ECD7A89D1DC44195F34B25E172658D56A9F4@039-SN2MPN1-013.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 07:28 +0000, Sethi Varun-B16395 wrote:
> > -----Original Message-----
> > From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> > bounces@lists.linux-foundation.org] On Behalf Of Alex Williamson
> > Sent: Friday, May 31, 2013 12:09 AM
> > To: iommu@lists.linux-foundation.org; dwmw2@infradead.org;
> > joro@8bytes.org
> > Cc: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: [PATCH] iommu: amd/intel: Remove multifunction assumption around
> > grouping
> > 
> > If a device is multifunction and does not have ACS enabled then we assume
> > that the entire package lacks ACS and use function 0 as the base of the
> > group.  The PCIe spec however states that components are permitted to
> > implement ACS on some, none, or all of their applicable functions.  It's
> > therefore conceivable that function 0 may be fully independent and
> > support ACS while other functions do not.  Instead use the lowest
> > function of the slot that does not have ACS enabled as the base of the
> > group.  This may be the current device, which is intentional.  So long as
> > we use a consistent algorithm, all the non-ACS functions will be grouped
> > together and ACS functions will get separate groups.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/iommu/amd_iommu.c   |   25 +++++++++++++++++++------
> >  drivers/iommu/intel-iommu.c |   25 +++++++++++++++++++------
> >  2 files changed, 38 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c index
> > 1d84be1..565c745 100644
> > --- a/drivers/iommu/amd_iommu.c
> > +++ b/drivers/iommu/amd_iommu.c
> > @@ -287,14 +287,27 @@ static struct pci_dev *get_isolation_root(struct
> > pci_dev *pdev)
> > 
> >  	/*
> >  	 * If it's a multifunction device that does not support our
> > -	 * required ACS flags, add to the same group as function 0.
> > +	 * required ACS flags, add to the same group as lowest numbered
> > +	 * function that also does not suport the required ACS flags.
> >  	 */
> >  	if (dma_pdev->multifunction &&
> > -	    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS))
> > -		swap_pci_ref(&dma_pdev,
> > -			     pci_get_slot(dma_pdev->bus,
> > -					  PCI_DEVFN(PCI_SLOT(dma_pdev->devfn),
> > -					  0)));
> > +	    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS)) {
> > +		u8 i, slot = PCI_SLOT(dma_pdev->devfn);
> > +
> > +		for (i = 0; i < 8; i++) {
> > +			struct pci_dev *tmp;
> > +
> > +			tmp = pci_get_slot(dma_pdev->bus, PCI_DEVFN(slot, i));
> > +			if (!tmp)
> > +				continue;
> > +
> > +			if (!pci_acs_enabled(tmp, REQ_ACS_FLAGS)) {
> > +				swap_pci_ref(&dma_pdev, tmp);
> > +				break;
> > +			}
> > +			pci_dev_put(tmp);
> > +		}
> > +	}
> > 
> >  	/*
> >  	 * Devices on the root bus go through the iommu.  If that's not us,
> > diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> > index b4f0e28..eec0d3e 100644
> > --- a/drivers/iommu/intel-iommu.c
> > +++ b/drivers/iommu/intel-iommu.c
> > @@ -4182,14 +4182,27 @@ static int intel_iommu_add_device(struct device
> > *dev)
> > 
> >  	/*
> >  	 * If it's a multifunction device that does not support our
> > -	 * required ACS flags, add to the same group as function 0.
> > +	 * required ACS flags, add to the same group as lowest numbered
> > +	 * function that also does not suport the required ACS flags.
> >  	 */
> >  	if (dma_pdev->multifunction &&
> > -	    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS))
> > -		swap_pci_ref(&dma_pdev,
> > -			     pci_get_slot(dma_pdev->bus,
> > -					  PCI_DEVFN(PCI_SLOT(dma_pdev->devfn),
> > -					  0)));
> > +	    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS)) {
> > +		u8 i, slot = PCI_SLOT(dma_pdev->devfn);
> > +
> > +		for (i = 0; i < 8; i++) {
> [Sethi Varun-B16395] A macro like PCI_MAX_FUNCTIONS would improve code readability.

Ok, I see a couple defines of PCI_MAX_FUNCTION, I guess we could add one
to iommu/pci.h too.

> > +			struct pci_dev *tmp;
> > +
> > +			tmp = pci_get_slot(dma_pdev->bus, PCI_DEVFN(slot, i));
> > +			if (!tmp)
> > +				continue;
> > +
> > +			if (!pci_acs_enabled(tmp, REQ_ACS_FLAGS)) {
> > +				swap_pci_ref(&dma_pdev, tmp);
> > +				break;
> > +			}
> > +			pci_dev_put(tmp);
> > +		}
> > +	}
> 
> It would be nice if this code could be represented as a function in a common file like iommu/pci.c.

I agree, but I haven't gotten any feedback on iommu/pci.c yet and didn't
want this patch to depend on that series.  There are probably more
opportunities to consolidate there.  Thanks,

Alex


