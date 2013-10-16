Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256Ab3JPRNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:13:22 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:56142
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752298Ab3JPRNV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:13:21 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6hbe9i1155h)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: Sethi Varun-B16395 <B16395@freescale.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Subject: RE: [PATCH 2/3 v2] iommu/fsl: Enable default DMA window for PCIe
 devices
Thread-Topic: [PATCH 2/3 v2] iommu/fsl: Enable default DMA window for PCIe
 devices
Thread-Index: AQHOymPvVc07lznlt0aYYYFZf3eo7Zn3ijsAgAAFUoCAAABWEA==
Date: Wed, 16 Oct 2013 17:13:15 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D071C09E2@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1381922582-28724-1-git-send-email-Varun.Sethi@freescale.com>
 <1381922582-28724-3-git-send-email-Varun.Sethi@freescale.com>
 <6A3DF150A5B70D4F9B66A25E3F7C888D071C0835@039-SN2MPN1-013.039d.mgd.msft.net>
 <C5ECD7A89D1DC44195F34B25E172658D0A5426C6@039-SN2MPN1-013.039d.mgd.msft.net>
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D0A5426C6@039-SN2MPN1-013.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [122.176.232.193]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> >
> >
> > > -----Original Message-----
> > > From: Sethi Varun-B16395
> > > Sent: Wednesday, October 16, 2013 4:53 PM
> > > To: joro@8bytes.org; iommu@lists.linux-foundation.org; linuxppc-
> > > dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Yoder
> > > Stuart-B08248; Wood Scott-B07421; alex.williamson@redhat.com;
> > > Bhushan
> > > Bharat-R65777
> > > Cc: Sethi Varun-B16395
> > > Subject: [PATCH 2/3 v2] iommu/fsl: Enable default DMA window for
> > > PCIe devices
> > >
> > > Once the PCIe device assigned to a guest VM (via VFIO) gets detached
> > > from the iommu domain (when guest terminates), its PAMU table entry
> > > is disabled. So, this would prevent the device from being used once
> > > it's
> > assigned back to the host.
> > >
> > > This patch allows for creation of a default DMA window corresponding
> > > to the device and subsequently enabling the PAMU table entry. Before
> > > we enable the entry, we ensure that the device's bus master
> > > capability is disabled (device quiesced).
> > >
> > > Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> > > ---
> > >  drivers/iommu/fsl_pamu.c        |   43 ++++++++++++++++++++++++++++---
> > -----
> > >  drivers/iommu/fsl_pamu.h        |    1 +
> > >  drivers/iommu/fsl_pamu_domain.c |   46
> > ++++++++++++++++++++++++++++++++++++---
> > >  3 files changed, 78 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/drivers/iommu/fsl_pamu.c b/drivers/iommu/fsl_pamu.c
> > > index
> > > cba0498..fb4a031 100644
> > > --- a/drivers/iommu/fsl_pamu.c
> > > +++ b/drivers/iommu/fsl_pamu.c
> > > @@ -225,6 +225,21 @@ static struct paace *pamu_get_spaace(struct
> > > paace *paace,
> > > u32 wnum)
> > >  	return spaace;
> > >  }
> > >
> > > +/*
> > > + * Defaul PPAACE settings for an LIODN.
> > > + */
> > > +static void setup_default_ppaace(struct paace *ppaace) {
> > > +	pamu_init_ppaace(ppaace);
> > > +	/* window size is 2^(WSE+1) bytes */
> > > +	set_bf(ppaace->addr_bitfields, PPAACE_AF_WSE, 35);
> > > +	ppaace->wbah = 0;
> > > +	set_bf(ppaace->addr_bitfields, PPAACE_AF_WBAL, 0);
> > > +	set_bf(ppaace->impl_attr, PAACE_IA_ATM,
> > > +		PAACE_ATM_NO_XLATE);
> > > +	set_bf(ppaace->addr_bitfields, PAACE_AF_AP,
> > > +		PAACE_AP_PERMS_ALL);
> > > +}
> > >  /**
> > >   * pamu_get_fspi_and_allocate() - Allocates fspi index and reserves
> > subwindows
> > >   *                                required for primary PAACE in the
> > secondary
> > > @@ -253,6 +268,24 @@ static unsigned long
> > > pamu_get_fspi_and_allocate(u32
> > > subwin_cnt)
> > >  	return (spaace_addr - (unsigned long)spaact) / (sizeof(struct
> > > paace));  }
> > >
> > > +/* Reset the PAACE entry to the default state */ void
> > > +enable_default_dma_window(int liodn) {
> > > +	struct paace *ppaace;
> > > +
> > > +	ppaace = pamu_get_ppaace(liodn);
> > > +	if (!ppaace) {
> > > +		pr_debug("Invalid liodn entry\n");
> > > +		return;
> > > +	}
> > > +
> > > +	memset(ppaace, 0, sizeof(struct paace));
> > > +
> > > +	setup_default_ppaace(ppaace);
> > > +	mb();
> > > +	pamu_enable_liodn(liodn);
> > > +}
> > > +
> > >  /* Release the subwindows reserved for a particular LIODN */  void
> > > pamu_free_subwins(int liodn)  { @@ -752,15 +785,7 @@ static void
> > > __init
> > > setup_liodns(void)
> > >  				continue;
> > >  			}
> > >  			ppaace = pamu_get_ppaace(liodn);
> > > -			pamu_init_ppaace(ppaace);
> > > -			/* window size is 2^(WSE+1) bytes */
> > > -			set_bf(ppaace->addr_bitfields, PPAACE_AF_WSE, 35);
> > > -			ppaace->wbah = 0;
> > > -			set_bf(ppaace->addr_bitfields, PPAACE_AF_WBAL, 0);
> > > -			set_bf(ppaace->impl_attr, PAACE_IA_ATM,
> > > -				PAACE_ATM_NO_XLATE);
> > > -			set_bf(ppaace->addr_bitfields, PAACE_AF_AP,
> > > -				PAACE_AP_PERMS_ALL);
> > > +			setup_default_ppaace(ppaace);
> > >  			if (of_device_is_compatible(node, "fsl,qman-portal"))
> > >  				setup_qbman_paace(ppaace, QMAN_PORTAL_PAACE);
> > >  			if (of_device_is_compatible(node, "fsl,qman")) diff --
> > git
> > > a/drivers/iommu/fsl_pamu.h b/drivers/iommu/fsl_pamu.h index
> > > 8fc1a12..0edcbbbb
> > > 100644
> > > --- a/drivers/iommu/fsl_pamu.h
> > > +++ b/drivers/iommu/fsl_pamu.h
> > > @@ -406,5 +406,6 @@ void get_ome_index(u32 *omi_index, struct device
> > > *dev);  int pamu_update_paace_stash(int liodn, u32 subwin, u32
> > > value); int pamu_disable_spaace(int liodn, u32 subwin);
> > >  u32 pamu_get_max_subwin_cnt(void);
> > > +void enable_default_dma_window(int liodn);
> > >
> > >  #endif  /* __FSL_PAMU_H */
> > > diff --git a/drivers/iommu/fsl_pamu_domain.c
> > > b/drivers/iommu/fsl_pamu_domain.c index 966ae70..dd6cafc 100644
> > > --- a/drivers/iommu/fsl_pamu_domain.c
> > > +++ b/drivers/iommu/fsl_pamu_domain.c
> > > @@ -340,17 +340,57 @@ static inline struct device_domain_info
> > > *find_domain(struct device *dev)
> > >  	return dev->archdata.iommu_domain;  }
> > >
> > > +/* Disable device DMA capability and enable default DMA window */
> > > +static void disable_device_dma(struct device_domain_info *info,
> > > +				int enable_dma_window)
> > > +{
> > > +#ifdef CONFIG_PCI
> > > +	if (info->dev->bus == &pci_bus_type) {
> > > +		struct pci_dev *pdev = NULL;
> > > +		pdev = to_pci_dev(info->dev);
> > > +		if (pci_is_enabled(pdev))
> > > +			pci_disable_device(pdev);
> > > +	}
> > > +#endif
> > > +
> > > +	if (enable_dma_window)
> > > +		enable_default_dma_window(info->liodn);
> > > +}
> > > +
> > > +static int check_for_shared_liodn(struct device_domain_info *info) {
> > > +	struct device_domain_info *tmp;
> > > +
> > > +	/*
> > > +	 * Sanity check, to ensure that this is not a
> > > +	 * shared LIODN. In case of a PCIe controller
> > > +	 * it's possible that all PCIe devices share
> > > +	 * the same LIODN.
> > > +	 */
> > > +	list_for_each_entry(tmp, &info->domain->devices, link) {
> > > +		if (info->liodn == tmp->liodn)
> > > +			return 1;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > >  static void remove_device_ref(struct device_domain_info *info, u32
> > win_cnt)  {
> > >  	unsigned long flags;
> > > +	int enable_dma_window = 0;
> > >
> > >  	list_del(&info->link);
> > >  	spin_lock_irqsave(&iommu_lock, flags);
> > > -	if (win_cnt > 1)
> > > -		pamu_free_subwins(info->liodn);
> > > -	pamu_disable_liodn(info->liodn);
> > > +	if (!check_for_shared_liodn(info)) {
> >
> > One query; Do we really need to check for this?
> >
> [Sethi Varun-B16395] Yes, just a sanity check to ensure that there are no more
> devices linked to this LIODN and we can disable it.

Varun, trying to understand this; say there are two device under a PCI controller which share the LIODN of PCI controller,
So both of the device must be unbound from kernel driver and then bind both to VFIO.

Now when guest terminated then remove_device_ref() will be called for both of device but the sanity check will pass for the one which will be called later, is this right? 

Thanks
-Bharat


> 
> -Varun
> 
> > Otherwise this patch series looks good to me.
> >
> > Thanks
> > -Bharat
> >
> > > +		if (win_cnt > 1)
> > > +			pamu_free_subwins(info->liodn);
> > > +		pamu_disable_liodn(info->liodn);
> > > +		enable_dma_window = 1;
> > > +	}
> > >  	spin_unlock_irqrestore(&iommu_lock, flags);
> > >  	spin_lock_irqsave(&device_domain_lock, flags);
> > > +	disable_device_dma(info, enable_dma_window);
> > >  	info->dev->archdata.iommu_domain = NULL;
> > >  	kmem_cache_free(iommu_devinfo_cache, info);
> > >  	spin_unlock_irqrestore(&device_domain_lock, flags);
> > > --
> > > 1.7.9.5


