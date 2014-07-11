Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaGKGR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 02:17:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:55697 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbaGKGRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 02:17:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,642,1400050800"; 
   d="scan'208";a="560333218"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [Patch Part3 V4 09/21] iommu/vt-d: Change iommu_enable/disable_translation to return void
Date: Fri, 11 Jul 2014 14:19:33 +0800
Message-Id: <1405059585-10620-10-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405059585-10620-1-git-send-email-jiang.liu@linux.intel.com>
References: <1405059585-10620-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify error handling path by changing iommu_{enable|disable}_translation
to return void.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 5d7383775bf1..0ba078bc0f32 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1389,7 +1389,7 @@ static void iommu_disable_protect_mem_regions(struct intel_iommu *iommu)
 	raw_spin_unlock_irqrestore(&iommu->register_lock, flags);
 }
 
-static int iommu_enable_translation(struct intel_iommu *iommu)
+static void iommu_enable_translation(struct intel_iommu *iommu)
 {
 	u32 sts;
 	unsigned long flags;
@@ -1403,10 +1403,9 @@ static int iommu_enable_translation(struct intel_iommu *iommu)
 		      readl, (sts & DMA_GSTS_TES), sts);
 
 	raw_spin_unlock_irqrestore(&iommu->register_lock, flags);
-	return 0;
 }
 
-static int iommu_disable_translation(struct intel_iommu *iommu)
+static void iommu_disable_translation(struct intel_iommu *iommu)
 {
 	u32 sts;
 	unsigned long flag;
@@ -1420,7 +1419,6 @@ static int iommu_disable_translation(struct intel_iommu *iommu)
 		      readl, (!(sts & DMA_GSTS_TES)), sts);
 
 	raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
-	return 0;
 }
 
 
@@ -2860,11 +2858,7 @@ static int __init init_dmars(void)
 
 		iommu->flush.flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL);
 		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH);
-
-		ret = iommu_enable_translation(iommu);
-		if (ret)
-			goto free_iommu;
-
+		iommu_enable_translation(iommu);
 		iommu_disable_protect_mem_regions(iommu);
 	}
 
@@ -3578,10 +3572,8 @@ static int init_iommu_hw(void)
 
 		iommu->flush.flush_context(iommu, 0, 0, 0,
 					   DMA_CCMD_GLOBAL_INVL);
-		iommu->flush.flush_iotlb(iommu, 0, 0, 0,
-					 DMA_TLB_GLOBAL_FLUSH);
-		if (iommu_enable_translation(iommu))
-			return 1;
+		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH);
+		iommu_enable_translation(iommu);
 		iommu_disable_protect_mem_regions(iommu);
 	}
 
-- 
1.7.10.4

