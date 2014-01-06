Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbaAFGSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:18:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:13062 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbaAFGSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:18:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,611,1384329600"; 
   d="scan'208";a="401364833"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part1 V3 04/20] iommu/vt-d: fix resource leakage on error recovery path in iommu_init_domains()
Date: Mon,  6 Jan 2014 14:18:11 +0800
Message-Id: <1388989107-4795-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1388989107-4795-1-git-send-email-jiang.liu@linux.intel.com>
References: <1388989107-4795-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Release allocated resources on error recovery path in function
iommu_init_domains().

Also improve printk messages in iommu_init_domains().

Acked-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index b8e3b48..e32d815 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1255,8 +1255,8 @@ static int iommu_init_domains(struct intel_iommu *iommu)
 	unsigned long nlongs;
 
 	ndomains = cap_ndoms(iommu->cap);
-	pr_debug("IOMMU %d: Number of Domains supported <%ld>\n", iommu->seq_id,
-			ndomains);
+	pr_debug("IOMMU%d: Number of Domains supported <%ld>\n",
+		 iommu->seq_id, ndomains);
 	nlongs = BITS_TO_LONGS(ndomains);
 
 	spin_lock_init(&iommu->lock);
@@ -1266,13 +1266,17 @@ static int iommu_init_domains(struct intel_iommu *iommu)
 	 */
 	iommu->domain_ids = kcalloc(nlongs, sizeof(unsigned long), GFP_KERNEL);
 	if (!iommu->domain_ids) {
-		printk(KERN_ERR "Allocating domain id array failed\n");
+		pr_err("IOMMU%d: allocating domain id array failed\n",
+		       iommu->seq_id);
 		return -ENOMEM;
 	}
 	iommu->domains = kcalloc(ndomains, sizeof(struct dmar_domain *),
 			GFP_KERNEL);
 	if (!iommu->domains) {
-		printk(KERN_ERR "Allocating domain array failed\n");
+		pr_err("IOMMU%d: allocating domain array failed\n",
+		       iommu->seq_id);
+		kfree(iommu->domain_ids);
+		iommu->domain_ids = NULL;
 		return -ENOMEM;
 	}
 
-- 
1.7.10.4

