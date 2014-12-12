Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030279AbaLLP43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:56:29 -0500
Received: from 8bytes.org ([81.169.241.247]:38528 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364AbaLLP42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:56:28 -0500
Date: Fri, 12 Dec 2014 16:56:26 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jerry Hoemann <jerry.hoemann@hp.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <jroedel@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Myron Stowe <mstowe@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [PATCH 2/2] iommu/vt-d: Only remove domain when device is removed
Message-ID: <20141212155626.GA24292@8bytes.org>
References: <1412074923-6342-1-git-send-email-joro@8bytes.org>
 <1412074923-6342-3-git-send-email-joro@8bytes.org>
 <1415117537.27420.428.camel@ul30vt.home>
 <20141106125405.GI8354@suse.de>
 <1415290565.16601.92.camel@ul30vt.home>
 <20141209121525.GM3762@8bytes.org>
 <20141211163534.GA4765@anatevka.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141211163534.GA4765@anatevka.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jerry,

On Thu, Dec 11, 2014 at 09:35:34AM -0700, Jerry Hoemann wrote:
> On Tue, Dec 09, 2014 at 01:15:25PM +0100, Joerg Roedel wrote:
> > >From d65b236d0f27fe3ef7ac4d12cceb0da67aec86ce Mon Sep 17 00:00:00 2001
> > From: Joerg Roedel <jroedel@suse.de>
> > Date: Tue, 9 Dec 2014 12:56:45 +0100
> > Subject: [PATCH] iommu/vt-d: Fix dmar_domain leak in iommu_attach_device
> > 
> > Since commit 1196c2f a domain is only destroyed in the
> > notifier path if it is hot-unplugged. This caused a
> > domain leakage in iommu_attach_device when a driver was
> > unbound from the device and bound to VFIO. In this case the
> > device is attached to a new domain and unlinked from the old
> > domain. At this point nothing points to the old domain
> > anymore and its memory is leaked.
> > Fix this by explicitly freeing the old domain in
> > iommu_attach_domain.
> > 
> > Fixes: 1196c2f 'iommu/vt-d: Only remove domain when device is removed'
> > Signed-off-by: Joerg Roedel <jroedel@suse.de>
> > ---
> >  drivers/iommu/intel-iommu.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> > index 1232336..9ef8e89 100644
> > --- a/drivers/iommu/intel-iommu.c
> > +++ b/drivers/iommu/intel-iommu.c
> > @@ -4424,10 +4424,13 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
> >  
> >  		old_domain = find_domain(dev);
> >  		if (old_domain) {
> > -			if (domain_type_is_vm_or_si(dmar_domain))
> > +			if (domain_type_is_vm_or_si(dmar_domain)) {
> 
> 
> JAH>  This path is executed when starting the VM.
> 
> 
> >  				domain_remove_one_dev_info(old_domain, dev);
> > -			else
> > +			} else {
> 
> 
> JAH>  I don't see this path being executed.
> 
> >  				domain_remove_dev_info(old_domain);
> > +				if (list_empty(&old_domain->devices))
> > +					domain_exit(old_domain);
> > +			}

You are right, thanks for testing. The reason is that the check for
domain_type_is_vm_or_si(dmar_domain) uses the new domain and not the old
one. I'll post a new patch.


	Joerg

