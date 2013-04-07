Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934853Ab3DGXiS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:38:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46759 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934657Ab3DGXbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:31:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Andreas Degert" <andreas.degert@googlemail.com>,
        "Joerg Roedel" <joro@8bytes.org>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.674500187@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [33/74] iommu/amd: Make sure dma_ops are set for hotplug devices
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joro@8bytes.org>

commit c2a2876e863356b092967ea62bebdb4dd663af80 upstream.

There is a bug introduced with commit 27c2127 that causes
devices which are hot unplugged and then hot-replugged to
not have per-device dma_ops set. This causes these devices
to not function correctly. Fixed with this patch.

Reported-by: Andreas Degert <andreas.degert@googlemail.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1874,16 +1874,16 @@ static int device_change_notifier(struct
 
 		/* allocate a protection domain if a device is added */
 		dma_domain = find_protection_domain(devid);
-		if (dma_domain)
-			goto out;
-		dma_domain = dma_ops_domain_alloc();
-		if (!dma_domain)
-			goto out;
-		dma_domain->target_dev = devid;
+		if (!dma_domain) {
+			dma_domain = dma_ops_domain_alloc();
+			if (!dma_domain)
+				goto out;
+			dma_domain->target_dev = devid;
 
-		spin_lock_irqsave(&iommu_pd_list_lock, flags);
-		list_add_tail(&dma_domain->list, &iommu_pd_list);
-		spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
+			spin_lock_irqsave(&iommu_pd_list_lock, flags);
+			list_add_tail(&dma_domain->list, &iommu_pd_list);
+			spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
+		}
 
 		dev->archdata.dma_ops = &amd_iommu_dma_ops;
 

