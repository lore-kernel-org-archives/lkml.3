Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab3JDPpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:45:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab3JDPpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:45:22 -0400
Message-ID: <1380901507.2673.204.camel@ul30vt.home>
Subject: Re: [PATCH 2/7] iommu: add api to get iommu_domain of a device
From: Alex Williamson <alex.williamson@redhat.com>
To: Bhushan Bharat-R65777 <R65777@freescale.com>
Cc: "joro@8bytes.org" <joro@8bytes.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Date: Fri, 04 Oct 2013 09:45:07 -0600
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D0718FD1C@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1379575763-2091-3-git-send-email-Bharat.Bhushan@freescale.com>
	 <1380127533.3030.319.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0718FD1C@039-SN2MPN1-011.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-04 at 09:54 +0000, Bhushan Bharat-R65777 wrote:
> 
> > -----Original Message-----
> > From: linux-pci-owner@vger.kernel.org [mailto:linux-pci-owner@vger.kernel.org]
> > On Behalf Of Alex Williamson
> > Sent: Wednesday, September 25, 2013 10:16 PM
> > To: Bhushan Bharat-R65777
> > Cc: joro@8bytes.org; benh@kernel.crashing.org; galak@kernel.crashing.org; linux-
> > kernel@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; linux-
> > pci@vger.kernel.org; agraf@suse.de; Wood Scott-B07421; iommu@lists.linux-
> > foundation.org; Bhushan Bharat-R65777
> > Subject: Re: [PATCH 2/7] iommu: add api to get iommu_domain of a device
> > 
> > On Thu, 2013-09-19 at 12:59 +0530, Bharat Bhushan wrote:
> > > This api return the iommu domain to which the device is attached.
> > > The iommu_domain is required for making API calls related to iommu.
> > > Follow up patches which use this API to know iommu maping.
> > >
> > > Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
> > > ---
> > >  drivers/iommu/iommu.c |   10 ++++++++++
> > >  include/linux/iommu.h |    7 +++++++
> > >  2 files changed, 17 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c index
> > > fbe9ca7..6ac5f50 100644
> > > --- a/drivers/iommu/iommu.c
> > > +++ b/drivers/iommu/iommu.c
> > > @@ -696,6 +696,16 @@ void iommu_detach_device(struct iommu_domain
> > > *domain, struct device *dev)  }
> > > EXPORT_SYMBOL_GPL(iommu_detach_device);
> > >
> > > +struct iommu_domain *iommu_get_dev_domain(struct device *dev) {
> > > +	struct iommu_ops *ops = dev->bus->iommu_ops;
> > > +
> > > +	if (unlikely(ops == NULL || ops->get_dev_iommu_domain == NULL))
> > > +		return NULL;
> > > +
> > > +	return ops->get_dev_iommu_domain(dev); }
> > > +EXPORT_SYMBOL_GPL(iommu_get_dev_domain);
> > 
> > What prevents this from racing iommu_domain_free()?  There's no references
> > acquired, so there's no reason for the caller to assume the pointer is valid.
> 
> Sorry for late query, somehow this email went into a folder and escaped;
> 
> Just to be sure, there is not lock at generic "struct iommu_domain", but IP specific structure (link FSL domain) linked in iommu_domain->priv have a lock, so we need to ensure this race in FSL iommu code (say drivers/iommu/fsl_pamu_domain.c), right?

No, it's not sufficient to make sure that your use of the interface is
race free.  The interface itself needs to be designed so that it's
difficult to use incorrectly.  That's not the case here.  This is a
backdoor to get the iommu domain from the iommu driver regardless of who
is using it or how.  The iommu domain is created and managed by vfio, so
shouldn't we be looking at how to do this through vfio?  It seems like
you'd want to use your device to get a vfio group reference, from which
you could do something with the vfio external user interface and get the
iommu domain reference.  Thanks,

Alex
 
> > >  /*
> > >   * IOMMU groups are really the natrual working unit of the IOMMU, but
> > >   * the IOMMU API works on domains and devices.  Bridge that gap by
> > > diff --git a/include/linux/iommu.h b/include/linux/iommu.h index
> > > 7ea319e..fa046bd 100644
> > > --- a/include/linux/iommu.h
> > > +++ b/include/linux/iommu.h
> > > @@ -127,6 +127,7 @@ struct iommu_ops {
> > >  	int (*domain_set_windows)(struct iommu_domain *domain, u32 w_count);
> > >  	/* Get the numer of window per domain */
> > >  	u32 (*domain_get_windows)(struct iommu_domain *domain);
> > > +	struct iommu_domain *(*get_dev_iommu_domain)(struct device *dev);
> > >
> > >  	unsigned long pgsize_bitmap;
> > >  };
> > > @@ -190,6 +191,7 @@ extern int iommu_domain_window_enable(struct iommu_domain
> > *domain, u32 wnd_nr,
> > >  				      phys_addr_t offset, u64 size,
> > >  				      int prot);
> > >  extern void iommu_domain_window_disable(struct iommu_domain *domain,
> > > u32 wnd_nr);
> > > +extern struct iommu_domain *iommu_get_dev_domain(struct device *dev);
> > >  /**
> > >   * report_iommu_fault() - report about an IOMMU fault to the IOMMU framework
> > >   * @domain: the iommu domain where the fault has happened @@ -284,6
> > > +286,11 @@ static inline void iommu_domain_window_disable(struct
> > > iommu_domain *domain,  {  }
> > >
> > > +static inline struct iommu_domain *iommu_get_dev_domain(struct device
> > > +*dev) {
> > > +	return NULL;
> > > +}
> > > +
> > >  static inline phys_addr_t iommu_iova_to_phys(struct iommu_domain
> > > *domain, dma_addr_t iova)  {
> > >  	return 0;
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pci" in the body
> > of a message to majordomo@vger.kernel.org More majordomo info at
> > http://vger.kernel.org/majordomo-info.html
> 



