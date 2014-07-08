Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbaGHPmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:42:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131AbaGHPmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:42:21 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [RESEND PATCH] iommu/intel: GAW only gets smaller by adding devices
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Tue, 08 Jul 2014 09:41:31 -0600
Message-ID: <20140708154018.14842.34903.stgit@gimli.home>
User-Agent: StGIT/0.14.3
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
Tested-by: mspeder@users.sourceforge.net
Cc: David Woodhouse <dwmw2@infradead.org>
---

I can't find any evidence that this got picked, resending.

 drivers/iommu/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 6ad29ed..3458bc8 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4309,7 +4309,7 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 		       __func__, addr_width, dmar_domain->max_addr);
 		return -EFAULT;
 	}
-	dmar_domain->gaw = addr_width;
+	dmar_domain->gaw = min(addr_width, dmar_domain->gaw);
 
 	/*
 	 * Knock out extra levels of page tables if necessary

