Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936281Ab3DKVBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:01:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9226 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935765Ab3DKUtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:19 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=HPjWLyn84rgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=o8KakoJLEi4A:10 a=tA7aZXjiAAAA:8 a=VwQbUJbxAAAA:8 a=mK_AVkanAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=qM0ISud-tAQA:10 a=9xyTavCNlvEA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202601.390713986@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andreas Degert <andreas.degert@googlemail.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [ 093/171 ] iommu/amd: Make sure dma_ops are set for hotplug devices
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0093-iommu-amd-Make-sure-dma_ops-are-set-for-hotplug-devi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joro@8bytes.org>

[ Upstream commit c2a2876e863356b092967ea62bebdb4dd663af80 ]

There is a bug introduced with commit 27c2127 that causes
devices which are hot unplugged and then hot-replugged to
not have per-device dma_ops set. This causes these devices
to not function correctly. Fixed with this patch.

Cc: stable@vger.kernel.org
Reported-by: Andreas Degert <andreas.degert@googlemail.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/iommu/amd_iommu.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index e89daf1..c698cf6 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2337,18 +2337,16 @@ static int device_change_notifier(struct notifier_block *nb,
 
 		/* allocate a protection domain if a device is added */
 		dma_domain = find_protection_domain(devid);
-		if (dma_domain)
-			goto out;
-		dma_domain = dma_ops_domain_alloc();
-		if (!dma_domain)
-			goto out;
-		dma_domain->target_dev = devid;
-
-		spin_lock_irqsave(&iommu_pd_list_lock, flags);
-		list_add_tail(&dma_domain->list, &iommu_pd_list);
-		spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
-
-		dev_data = get_dev_data(dev);
+		if (!dma_domain) {
+			dma_domain = dma_ops_domain_alloc();
+			if (!dma_domain)
+				goto out;
+			dma_domain->target_dev = devid;
+
+			spin_lock_irqsave(&iommu_pd_list_lock, flags);
+			list_add_tail(&dma_domain->list, &iommu_pd_list);
+			spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
+		}
 
 		dev->archdata.dma_ops = &amd_iommu_dma_ops;
 
-- 
1.7.10.4


