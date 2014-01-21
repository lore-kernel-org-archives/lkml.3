Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbaAUNfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:35:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbaAUNfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:35:51 -0500
Message-ID: <1390311348.8705.265.camel@bling.home>
Subject: Re: [RFC PATCH] vfio/iommu_type1: Multi-IOMMU domain support
From: Alex Williamson <alex.williamson@redhat.com>
To: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
Cc: Varun Sethi <Varun.Sethi@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 21 Jan 2014 06:35:48 -0700
In-Reply-To: <4b9118cb4cc744bdb2e9c25fa32d6950@BL2PR03MB259.namprd03.prod.outlook.com>
References: <20140117203126.11429.25235.stgit@gimli.home>
	 <4b9118cb4cc744bdb2e9c25fa32d6950@BL2PR03MB259.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-21 at 07:27 +0000, Bharat.Bhushan@freescale.com wrote:
> > +	domain->domain = iommu_domain_alloc(domain->bus);
> > +	if (!domain->domain) {
> > +		ret = -EIO;
> > +		goto out_free;
> > +	}
> > +
> > +	ret = iommu_attach_group(domain->domain, iommu_group);
> > +	if (ret)
> > +		goto out_domain;
> > +
> > +	INIT_LIST_HEAD(&domain->group_list);
> > +	list_add(&group->next, &domain->group_list);
> > +
> > +	if (!allow_unsafe_interrupts &&
> > +	    !iommu_domain_has_cap(domain->domain, IOMMU_CAP_INTR_REMAP)) {
> > +		pr_warn("%s: No interrupt remapping support.  Use the module param
> > \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
> > +		       __func__);
> > +		ret = -EPERM;
> > +		goto out_detach;
> > +	}
> > +
> > +	if (iommu_domain_has_cap(domain->domain, IOMMU_CAP_CACHE_COHERENCY))
> > +		domain->prot |= IOMMU_CACHE;
> > +
> > +	/* Try to match an existing compatible domain. */
> > +	list_for_each_entry(d, &iommu->domain_list, next) {
> > +		if (d->bus == domain->bus && d->prot == domain->prot) {
> 
> Are not we talking about allowing a domain to support different bus type if domain/iommu-group properties matches.

This is where I was suggesting to Varun that we could test iommu_ops
instead of bus_type.

> > +			iommu_detach_group(domain->domain, iommu_group);
> > +			if (!iommu_attach_group(d->domain, iommu_group)) {
> > +				list_add(&group->next, &d->group_list);
> > +				iommu_domain_free(domain->domain);
> > +				kfree(domain);
> > +				mutex_unlock(&iommu->lock);
> > +				return 0;
> > +			}
> > +
> > +			ret = iommu_attach_group(domain->domain, iommu_group);
> > +			if (ret)
> > +				goto out_domain;
> > +		}
> > +	}
> > +
> > +	/* replay mappings on new domains */
> > +	ret = vfio_iommu_replay(iommu, domain);
> 
> IIUC; We created a new domain because an already existing domain does not have same attribute; say domain->prot;
> But in vfio_iommu_replay() we pick up any domain, first domain, and create mapping accordingly.
> Should not we use attributes of this domain otherwise we may get "reserved bit faults"? 

We use an existing domain to get the iova to physical mappings, should
those not be consistent regardless of the domain we pick?  We're not
using any of the low level attributes that could cause something like a
reserved bit fault.  Thanks,

Alex

