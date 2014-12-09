Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbaLIMP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:15:28 -0500
Received: from 8bytes.org ([81.169.241.247]:44545 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257AbaLIMP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:15:27 -0500
Date: Tue, 9 Dec 2014 13:15:25 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Myron Stowe <mstowe@redhat.com>
Subject: Re: [PATCH 2/2] iommu/vt-d: Only remove domain when device is removed
Message-ID: <20141209121525.GM3762@8bytes.org>
References: <1412074923-6342-1-git-send-email-joro@8bytes.org>
 <1412074923-6342-3-git-send-email-joro@8bytes.org>
 <1415117537.27420.428.camel@ul30vt.home>
 <20141106125405.GI8354@suse.de>
 <1415290565.16601.92.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415290565.16601.92.camel@ul30vt.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 09:16:05AM -0700, Alex Williamson wrote:
> But the domains are unlinked from device_domain_list using
> unlink_domain_info() which is called from both domain_remove_dev_info()
> and domain_remove_one_dev_info() which are both part of that more
> likely, unlikely branch in intel_iommu_attach_device().  So it seems
> like any time we switch a device from the DMA-API to the IOMMU-API, we
> lose the reference to the domain.  Is that incorrect?  I'll try to test.

Okay, I thought a while about that and it looks like a real fix needs a
rewrite of the domain handling code in the VT-d driver to better handle
domain lifetime. We'll get this for free when we add default domains and
more domain handling logic to the iommu core, so I think we don't need
to start rewriting the VT-d driver for this.
But for the time being, here is a simple fix for the leak in
iommu_attach_domain:

>From d65b236d0f27fe3ef7ac4d12cceb0da67aec86ce Mon Sep 17 00:00:00 2001
From: Joerg Roedel <jroedel@suse.de>
Date: Tue, 9 Dec 2014 12:56:45 +0100
Subject: [PATCH] iommu/vt-d: Fix dmar_domain leak in iommu_attach_device

Since commit 1196c2f a domain is only destroyed in the
notifier path if it is hot-unplugged. This caused a
domain leakage in iommu_attach_device when a driver was
unbound from the device and bound to VFIO. In this case the
device is attached to a new domain and unlinked from the old
domain. At this point nothing points to the old domain
anymore and its memory is leaked.
Fix this by explicitly freeing the old domain in
iommu_attach_domain.

Fixes: 1196c2f 'iommu/vt-d: Only remove domain when device is removed'
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/intel-iommu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 1232336..9ef8e89 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4424,10 +4424,13 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 
 		old_domain = find_domain(dev);
 		if (old_domain) {
-			if (domain_type_is_vm_or_si(dmar_domain))
+			if (domain_type_is_vm_or_si(dmar_domain)) {
 				domain_remove_one_dev_info(old_domain, dev);
-			else
+			} else {
 				domain_remove_dev_info(old_domain);
+				if (list_empty(&old_domain->devices))
+					domain_exit(old_domain);
+			}
 		}
 	}
 
-- 
1.8.4.5

