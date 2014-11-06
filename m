Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaKFREj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:04:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbaKFQnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:43:46 -0500
Message-ID: <1415292194.16601.96.camel@ul30vt.home>
Subject: Re: [PATCH 2/2] iommu/vt-d: Only remove domain when device is
 removed
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <jroedel@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Myron Stowe <mstowe@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Date: Thu, 06 Nov 2014 09:43:14 -0700
In-Reply-To: <1415290565.16601.92.camel@ul30vt.home>
References: <1412074923-6342-1-git-send-email-joro@8bytes.org>
	 <1412074923-6342-3-git-send-email-joro@8bytes.org>
	 <1415117537.27420.428.camel@ul30vt.home> <20141106125405.GI8354@suse.de>
	 <1415290565.16601.92.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-06 at 09:16 -0700, Alex Williamson wrote:
> On Thu, 2014-11-06 at 13:54 +0100, Joerg Roedel wrote:
> > Hi Alex,
> > 
> > On Tue, Nov 04, 2014 at 09:12:17AM -0700, Alex Williamson wrote:
> > > I haven't tested it, but I'm concerned whether this has introduced a
> > > domain leak.  If we think about the case of unbinding a device from a
> > > host driver and attaching it to a domain through the IOMMU API, I think
> > > we used to count on this path to call domain_exit(), which made the
> > > domain_context_mapped() in intel_iommu_attach_device() "unlikely".  With
> > > this change, isn't the test in intel_iommu_attach_device() now neither
> > > likely nor unlikely and we're only removing the dev_info from the domain
> > > and not destroying the domain itself?  Thanks,
> > 
> > As I see it, there is no leak. The DMA-API domains are kept in the
> > device_domain_list and re-used when the device driver re-attaches. But
> > your are right that the unlikely in intel_iommu_attach_device() isn't
> > true anymore. We could probably remove it.
> 
> But the domains are unlinked from device_domain_list using
> unlink_domain_info() which is called from both domain_remove_dev_info()
> and domain_remove_one_dev_info() which are both part of that more
> likely, unlikely branch in intel_iommu_attach_device().  So it seems
> like any time we switch a device from the DMA-API to the IOMMU-API, we
> lose the reference to the domain.  Is that incorrect?  I'll try to test.

Trying the simple approach, a printk in each of alloc_domain() and
free_domain_mem(), this is what I see when I start and stop a VM with an
assigned device:

alloc_domain(): ffff8801e22ac000
free_domain_mem(ffff8801e22ac000)
alloc_domain(): ffff8801e3425c80

The IOMMU API domain is alloc'd and free'd, then a new DMA-API domain is
alloc'd.  There are no frees of the DMA-API domain.  Thanks,

Alex

