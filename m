Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144Ab3FCH3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:29:03 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:8523
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861Ab3FCH2x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:28:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffhbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] iommu: amd/intel: Remove multifunction assumption
 around	grouping
Thread-Topic: [PATCH] iommu: amd/intel: Remove multifunction assumption
 around	grouping
Thread-Index: AQHOXWU4++EkbVSpikCIcMFQxCTuuZkjjKjQ
Date: Mon, 3 Jun 2013 07:28:26 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D56A9F4@039-SN2MPN1-013.039d.mgd.msft.net>
References: <20130530183855.14612.15585.stgit@bling.home>
In-Reply-To: <20130530183855.14612.15585.stgit@bling.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.132.223]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> bounces@lists.linux-foundation.org] On Behalf Of Alex Williamson
> Sent: Friday, May 31, 2013 12:09 AM
> To: iommu@lists.linux-foundation.org; dwmw2@infradead.org;
> joro@8bytes.org
> Cc: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] iommu: amd/intel: Remove multifunction assumption around
> grouping
> 
> If a device is multifunction and does not have ACS enabled then we assume
> that the entire package lacks ACS and use function 0 as the base of the
> group.  The PCIe spec however states that components are permitted to
> implement ACS on some, none, or all of their applicable functions.  It's
> therefore conceivable that function 0 may be fully independent and
> support ACS while other functions do not.  Instead use the lowest
> function of the slot that does not have ACS enabled as the base of the
> group.  This may be the current device, which is intentional.  So long as
> we use a consistent algorithm, all the non-ACS functions will be grouped
> together and ACS functions will get separate groups.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/iommu/amd_iommu.c   |   25 +++++++++++++++++++------
>  drivers/iommu/intel-iommu.c |   25 +++++++++++++++++++------
>  2 files changed, 38 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c index
> 1d84be1..565c745 100644
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -287,14 +287,27 @@ static struct pci_dev *get_isolation_root(struct
> pci_dev *pdev)
> 
>  	/*
>  	 * If it's a multifunction device that does not support our
> -	 * required ACS flags, add to the same group as function 0.
> +	 * required ACS flags, add to the same group as lowest numbered
> +	 * function that also does not suport the required ACS flags.
>  	 */
>  	if (dma_pdev->multifunction &&
> -	    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS))
> -		swap_pci_ref(&dma_pdev,
> -			     pci_get_slot(dma_pdev->bus,
> -					  PCI_DEVFN(PCI_SLOT(dma_pdev->devfn),
> -					  0)));
> +	    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS)) {
> +		u8 i, slot = PCI_SLOT(dma_pdev->devfn);
> +
> +		for (i = 0; i < 8; i++) {
> +			struct pci_dev *tmp;
> +
> +			tmp = pci_get_slot(dma_pdev->bus, PCI_DEVFN(slot, i));
> +			if (!tmp)
> +				continue;
> +
> +			if (!pci_acs_enabled(tmp, REQ_ACS_FLAGS)) {
> +				swap_pci_ref(&dma_pdev, tmp);
> +				break;
> +			}
> +			pci_dev_put(tmp);
> +		}
> +	}
> 
>  	/*
>  	 * Devices on the root bus go through the iommu.  If that's not us,
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index b4f0e28..eec0d3e 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -4182,14 +4182,27 @@ static int intel_iommu_add_device(struct device
> *dev)
> 
>  	/*
>  	 * If it's a multifunction device that does not support our
> -	 * required ACS flags, add to the same group as function 0.
> +	 * required ACS flags, add to the same group as lowest numbered
> +	 * function that also does not suport the required ACS flags.
>  	 */
>  	if (dma_pdev->multifunction &&
> -	    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS))
> -		swap_pci_ref(&dma_pdev,
> -			     pci_get_slot(dma_pdev->bus,
> -					  PCI_DEVFN(PCI_SLOT(dma_pdev->devfn),
> -					  0)));
> +	    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS)) {
> +		u8 i, slot = PCI_SLOT(dma_pdev->devfn);
> +
> +		for (i = 0; i < 8; i++) {
[Sethi Varun-B16395] A macro like PCI_MAX_FUNCTIONS would improve code readability.

> +			struct pci_dev *tmp;
> +
> +			tmp = pci_get_slot(dma_pdev->bus, PCI_DEVFN(slot, i));
> +			if (!tmp)
> +				continue;
> +
> +			if (!pci_acs_enabled(tmp, REQ_ACS_FLAGS)) {
> +				swap_pci_ref(&dma_pdev, tmp);
> +				break;
> +			}
> +			pci_dev_put(tmp);
> +		}
> +	}

It would be nice if this code could be represented as a function in a common file like iommu/pci.c.

-Varun

