Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab3LFDXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 22:23:31 -0500
Received: from mga03.intel.com ([143.182.124.21]:56623 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722Ab3LFDVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 22:21:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,838,1378882800"; 
   d="scan'208";a="325986963"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [Patch Part1 V2 14/20] iommu/vt-d: avoid double free in error recovery path
Date: Fri,  6 Dec 2013 11:21:17 +0800
Message-Id: <1386300083-6882-15-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
References: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The g_iommus array will be freed twice when failed to initialize IOMMU
devices, which will cause system panic.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index cbdb1ff..1a20171 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1293,19 +1293,10 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
 	iommu->domains = NULL;
 	iommu->domain_ids = NULL;
 
-	g_iommus[iommu->seq_id] = NULL;
-
-	/* if all iommus are freed, free g_iommus */
-	for (i = 0; i < g_num_of_iommus; i++) {
-		if (g_iommus[i])
-			break;
-	}
-
-	if (i == g_num_of_iommus)
-		kfree(g_iommus);
-
 	/* free context mapping */
 	free_context_table(iommu);
+
+	g_iommus[iommu->seq_id] = NULL;
 }
 
 static struct dmar_domain *alloc_domain(void)
@@ -2621,6 +2612,7 @@ error:
 	for_each_active_iommu(iommu, drhd)
 		free_dmar_iommu(iommu);
 	kfree(g_iommus);
+	g_iommus = NULL;
 	return ret;
 }
 
-- 
1.7.10.4

