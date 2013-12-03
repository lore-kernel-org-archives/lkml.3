Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3LCSPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:15:32 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:59581 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028Ab3LCSP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:15:29 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(z579ehz98dI9371I936eI542I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh109h2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2184h21a6h2216h22d0h2336hbe9i1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "joro@8bytes.org" <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        Bharat Bhushan <Bharat.Bhushan@freescale.com>
Subject: RE: [PATCH 2/3 v2] iommu/fsl: Enable default DMA window for PCIe
 devices
Thread-Topic: [PATCH 2/3 v2] iommu/fsl: Enable default DMA window for PCIe
 devices
Thread-Index: AQHOymPvu85gT59p8kGDzd1pRpqO7JpBt4gAgAFW2cA=
Date: Tue, 3 Dec 2013 18:15:22 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D0A606B8F@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1381922582-28724-1-git-send-email-Varun.Sethi@freescale.com>
	 <1381922582-28724-3-git-send-email-Varun.Sethi@freescale.com>
 <1386020016.25738.240.camel@ul30vt.home>
In-Reply-To: <1386020016.25738.240.camel@ul30vt.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.124]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB3IFcmB027321



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Tuesday, December 03, 2013 3:04 AM
> To: Sethi Varun-B16395
> Cc: joro@8bytes.org; iommu@lists.linux-foundation.org; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Yoder Stuart-B08248;
> Wood Scott-B07421; Bhushan Bharat-R65777
> Subject: Re: [PATCH 2/3 v2] iommu/fsl: Enable default DMA window for PCIe
> devices
> 
> On Wed, 2013-10-16 at 16:53 +0530, Varun Sethi wrote:
> > Once the PCIe device assigned to a guest VM (via VFIO) gets detached
> > from the iommu domain (when guest terminates), its PAMU table entry is
> > disabled. So, this would prevent the device from being used once it's
> assigned back to the host.
> >
> > This patch allows for creation of a default DMA window corresponding
> > to the device and subsequently enabling the PAMU table entry. Before
> > we enable the entry, we ensure that the device's bus master capability
> is disabled (device quiesced).
> >
> > Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> > ---
> >  drivers/iommu/fsl_pamu.c        |   43 ++++++++++++++++++++++++++++---
> -----
> >  drivers/iommu/fsl_pamu.h        |    1 +
> >  drivers/iommu/fsl_pamu_domain.c |   46
> ++++++++++++++++++++++++++++++++++++---
> >  3 files changed, 78 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/iommu/fsl_pamu.c b/drivers/iommu/fsl_pamu.c index
> > cba0498..fb4a031 100644
> > --- a/drivers/iommu/fsl_pamu.c
> > +++ b/drivers/iommu/fsl_pamu.c
> > @@ -225,6 +225,21 @@ static struct paace *pamu_get_spaace(struct paace
> *paace, u32 wnum)
> >  	return spaace;
> >  }
> >
> > +/*
> > + * Defaul PPAACE settings for an LIODN.
> > + */
> > +static void setup_default_ppaace(struct paace *ppaace) {
> > +	pamu_init_ppaace(ppaace);
> > +	/* window size is 2^(WSE+1) bytes */
> > +	set_bf(ppaace->addr_bitfields, PPAACE_AF_WSE, 35);
> > +	ppaace->wbah = 0;
> > +	set_bf(ppaace->addr_bitfields, PPAACE_AF_WBAL, 0);
> > +	set_bf(ppaace->impl_attr, PAACE_IA_ATM,
> > +		PAACE_ATM_NO_XLATE);
> > +	set_bf(ppaace->addr_bitfields, PAACE_AF_AP,
> > +		PAACE_AP_PERMS_ALL);
> > +}
> >  /**
> >   * pamu_get_fspi_and_allocate() - Allocates fspi index and reserves
> subwindows
> >   *                                required for primary PAACE in the
> secondary
> > @@ -253,6 +268,24 @@ static unsigned long
> pamu_get_fspi_and_allocate(u32 subwin_cnt)
> >  	return (spaace_addr - (unsigned long)spaact) / (sizeof(struct
> > paace));  }
> >
> > +/* Reset the PAACE entry to the default state */ void
> > +enable_default_dma_window(int liodn) {
> > +	struct paace *ppaace;
> > +
> > +	ppaace = pamu_get_ppaace(liodn);
> > +	if (!ppaace) {
> > +		pr_debug("Invalid liodn entry\n");
> > +		return;
> > +	}
> > +
> > +	memset(ppaace, 0, sizeof(struct paace));
> > +
> > +	setup_default_ppaace(ppaace);
> > +	mb();
> > +	pamu_enable_liodn(liodn);
> > +}
> > +
> >  /* Release the subwindows reserved for a particular LIODN */  void
> > pamu_free_subwins(int liodn)  { @@ -752,15 +785,7 @@ static void
> > __init setup_liodns(void)
> >  				continue;
> >  			}
> >  			ppaace = pamu_get_ppaace(liodn);
> > -			pamu_init_ppaace(ppaace);
> > -			/* window size is 2^(WSE+1) bytes */
> > -			set_bf(ppaace->addr_bitfields, PPAACE_AF_WSE, 35);
> > -			ppaace->wbah = 0;
> > -			set_bf(ppaace->addr_bitfields, PPAACE_AF_WBAL, 0);
> > -			set_bf(ppaace->impl_attr, PAACE_IA_ATM,
> > -				PAACE_ATM_NO_XLATE);
> > -			set_bf(ppaace->addr_bitfields, PAACE_AF_AP,
> > -				PAACE_AP_PERMS_ALL);
> > +			setup_default_ppaace(ppaace);
> >  			if (of_device_is_compatible(node, "fsl,qman-portal"))
> >  				setup_qbman_paace(ppaace, QMAN_PORTAL_PAACE);
> >  			if (of_device_is_compatible(node, "fsl,qman")) diff --
> git
> > a/drivers/iommu/fsl_pamu.h b/drivers/iommu/fsl_pamu.h index
> > 8fc1a12..0edcbbbb 100644
> > --- a/drivers/iommu/fsl_pamu.h
> > +++ b/drivers/iommu/fsl_pamu.h
> > @@ -406,5 +406,6 @@ void get_ome_index(u32 *omi_index, struct device
> > *dev);  int  pamu_update_paace_stash(int liodn, u32 subwin, u32
> > value);  int pamu_disable_spaace(int liodn, u32 subwin);
> >  u32 pamu_get_max_subwin_cnt(void);
> > +void enable_default_dma_window(int liodn);
> >
> >  #endif  /* __FSL_PAMU_H */
> > diff --git a/drivers/iommu/fsl_pamu_domain.c
> > b/drivers/iommu/fsl_pamu_domain.c index 966ae70..dd6cafc 100644
> > --- a/drivers/iommu/fsl_pamu_domain.c
> > +++ b/drivers/iommu/fsl_pamu_domain.c
> > @@ -340,17 +340,57 @@ static inline struct device_domain_info
> *find_domain(struct device *dev)
> >  	return dev->archdata.iommu_domain;
> >  }
> >
> > +/* Disable device DMA capability and enable default DMA window */
> > +static void disable_device_dma(struct device_domain_info *info,
> > +				int enable_dma_window)
> 
> nit, bool?
> 
> > +{
> > +#ifdef CONFIG_PCI
> > +	if (info->dev->bus == &pci_bus_type) {
> > +		struct pci_dev *pdev = NULL;
> 
> nit, unnecessary initialization
> 
> > +		pdev = to_pci_dev(info->dev);
> > +		if (pci_is_enabled(pdev))
> > +			pci_disable_device(pdev);
> 
> This looks suspicious.  What's the case where you're finding devices
> where this is needed?  Logically the driver that called
> pci_enable_device() should also call pci_disabled_device() when it's
> done.  Maybe there's a case to be made that we can't rely on the driver,
> but then maybe there should be a pr_debug/info here to notify that
> somebody left the device running.  There might also be the question of
> whether you should test the busmaster bit in the command register rather
> than trusting these indirect paths if it's really for cleanup.  Thanks,
> 
Once the device is detached from the domain, we enable a default DMA window for the device. Before enabling the default window, I want to ensure that device DMA is disabled. VFIO subsystem handles this for vfio-pci. But, can we assume that this would always be the case?

-Varun


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
