Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934348AbaLKQfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 11:35:40 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:57666 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933436AbaLKQfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 11:35:39 -0500
Date: Thu, 11 Dec 2014 09:35:34 -0700
From: Jerry Hoemann <jerry.hoemann@hp.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <jroedel@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Myron Stowe <mstowe@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [PATCH 2/2] iommu/vt-d: Only remove domain when device is removed
Message-ID: <20141211163534.GA4765@anatevka.fc.hp.com>
Reply-To: Jerry.Hoemann@hp.com
References: <1412074923-6342-1-git-send-email-joro@8bytes.org>
 <1412074923-6342-3-git-send-email-joro@8bytes.org>
 <1415117537.27420.428.camel@ul30vt.home>
 <20141106125405.GI8354@suse.de>
 <1415290565.16601.92.camel@ul30vt.home>
 <20141209121525.GM3762@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209121525.GM3762@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 01:15:25PM +0100, Joerg Roedel wrote:
> On Thu, Nov 06, 2014 at 09:16:05AM -0700, Alex Williamson wrote:
> > But the domains are unlinked from device_domain_list using
> > unlink_domain_info() which is called from both domain_remove_dev_info()
> > and domain_remove_one_dev_info() which are both part of that more
> > likely, unlikely branch in intel_iommu_attach_device().  So it seems
> > like any time we switch a device from the DMA-API to the IOMMU-API, we
> > lose the reference to the domain.  Is that incorrect?  I'll try to test.
> 
> Okay, I thought a while about that and it looks like a real fix needs a
> rewrite of the domain handling code in the VT-d driver to better handle
> domain lifetime. We'll get this for free when we add default domains and
> more domain handling logic to the iommu core, so I think we don't need
> to start rewriting the VT-d driver for this.
> But for the time being, here is a simple fix for the leak in
> iommu_attach_domain:


Joerg,

This patch doesn't seem to be fixing the memory leak.

I am testing with a 3.18.0-rc7 kernel applied to a RHEL 7.0 system.

I added printk in free_domain_mem and alloc_domain to first reproduce
Alex's observation.  I created a VM and assigned a PCI NIC w/ no associated
RMRR to the VM.

The pattern I see is when starting the VM is:
alloc_domain -> X

When powering off the VM:
free_domain_mem(X)
alloc_domain -> Y

I then applied the patch below and I still see the same pattern of two
alloc_domain and one free_domain_mem when powering on/off the VM.

I added some additional instrumentation and I do not see the new call
to domain_exit being executed.  (See inline comments below.)



Jerry


> 
> >From d65b236d0f27fe3ef7ac4d12cceb0da67aec86ce Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <jroedel@suse.de>
> Date: Tue, 9 Dec 2014 12:56:45 +0100
> Subject: [PATCH] iommu/vt-d: Fix dmar_domain leak in iommu_attach_device
> 
> Since commit 1196c2f a domain is only destroyed in the
> notifier path if it is hot-unplugged. This caused a
> domain leakage in iommu_attach_device when a driver was
> unbound from the device and bound to VFIO. In this case the
> device is attached to a new domain and unlinked from the old
> domain. At this point nothing points to the old domain
> anymore and its memory is leaked.
> Fix this by explicitly freeing the old domain in
> iommu_attach_domain.
> 
> Fixes: 1196c2f 'iommu/vt-d: Only remove domain when device is removed'
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  drivers/iommu/intel-iommu.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 1232336..9ef8e89 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -4424,10 +4424,13 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
>  
>  		old_domain = find_domain(dev);
>  		if (old_domain) {
> -			if (domain_type_is_vm_or_si(dmar_domain))
> +			if (domain_type_is_vm_or_si(dmar_domain)) {


JAH>  This path is executed when starting the VM.


>  				domain_remove_one_dev_info(old_domain, dev);
> -			else
> +			} else {


JAH>  I don't see this path being executed.

>  				domain_remove_dev_info(old_domain);
> +				if (list_empty(&old_domain->devices))
> +					domain_exit(old_domain);
> +			}
>  		}
>  	}
>  
> -- 
> 1.8.4.5
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu

-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard

3404 E Harmony Rd. MS 36                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-0707
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------
