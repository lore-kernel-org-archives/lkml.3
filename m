Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaDVHJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:09:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:35927 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbaDVHHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:07:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,902,1389772800"; 
   d="scan'208";a="517082291"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part3 V1 21/22] iommu/vt-d: introduce helper function iova_size() to improve code readability
Date: Tue, 22 Apr 2014 15:07:32 +0800
Message-Id: <1398150453-28141-22-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398150453-28141-1-git-send-email-jiang.liu@linux.intel.com>
References: <1398150453-28141-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |    7 +++----
 include/linux/iova.h        |    5 +++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c4bca2d814c8..6d5b94aaac6e 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3114,10 +3114,10 @@ static void flush_unmaps(void)
 			/* On real hardware multiple invalidations are expensive */
 			if (cap_caching_mode(iommu->cap))
 				iommu_flush_iotlb_psi(iommu, domain->id,
-					iova->pfn_lo, iova->pfn_hi - iova->pfn_lo + 1,
+					iova->pfn_lo, iova_size(iova),
 					!deferred_flush[i].freelist[j], 0);
 			else {
-				mask = ilog2(mm_to_dma_pfn(iova->pfn_hi - iova->pfn_lo + 1));
+				mask = ilog2(mm_to_dma_pfn(iova_size(iova)));
 				iommu_flush_dev_iotlb(deferred_flush[i].domain[j],
 						(uint64_t)iova->pfn_lo << PAGE_SHIFT, mask);
 			}
@@ -4061,8 +4061,7 @@ static int intel_iommu_memory_notifier(struct notifier_block *nb,
 			rcu_read_lock();
 			for_each_active_iommu(iommu, drhd)
 				iommu_flush_iotlb_psi(iommu, si_domain->id,
-					iova->pfn_lo,
-					iova->pfn_hi - iova->pfn_lo + 1,
+					iova->pfn_lo, iova_size(iova),
 					!freelist, 0);
 			rcu_read_unlock();
 			dma_free_pagelist(freelist);
diff --git a/include/linux/iova.h b/include/linux/iova.h
index 3277f4711349..19e81d5ccb6d 100644
--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -34,6 +34,11 @@ struct iova_domain {
 	unsigned long	dma_32bit_pfn;
 };
 
+static inline unsigned long iova_size(struct iova *iova)
+{
+	return iova->pfn_hi - iova->pfn_lo + 1;
+}
+
 struct iova *alloc_iova_mem(void);
 void free_iova_mem(struct iova *iova);
 void free_iova(struct iova_domain *iovad, unsigned long pfn);
-- 
1.7.10.4

