Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbaE2UXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 16:23:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbaE2UXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 16:23:52 -0400
Subject: [PATCH] iommu/intel: GAW only gets smaller by adding devices
From: Alex Williamson <alex.williamson@redhat.com>
To: iommu@lists.linux-foundation.org
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        mspeder@users.sourceforge.net
Date: Thu, 29 May 2014 14:23:17 -0600
Message-ID: <20140529202304.10925.20871.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As analyzed in https://bugzilla.kernel.org/show_bug.cgi?id=76331
we can have multiple DRHDs in a system and each may support different
guest address widths.  We can add a device behind a less capable DRHD
to a domain so long as the lesser DRHD can map the existing domain
page table.  We should never increase the address width as a result
of adding a device to the domain.  The current code simply updates
the width to the last added device.  Change to keep it at the
minumum DRHD width.

Reported-by: mspeder@users.sourceforge.net
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/iommu/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index e68f44b..cd41d8d 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4276,7 +4276,7 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 		       __func__, addr_width, dmar_domain->max_addr);
 		return -EFAULT;
 	}
-	dmar_domain->gaw = addr_width;
+	dmar_domain->gaw = min(addr_width, dmar_domain->gaw);
 
 	/*
 	 * Knock out extra levels of page tables if necessary

