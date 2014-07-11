Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaGKGRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 02:17:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:55697 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbaGKGRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 02:17:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,642,1400050800"; 
   d="scan'208";a="560333146"
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
Subject: [Patch Part3 V4 06/21] iommu/vt-d: Fix possible invalid memory access caused by free_dmar_iommu()
Date: Fri, 11 Jul 2014 14:19:30 +0800
Message-Id: <1405059585-10620-7-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405059585-10620-1-git-send-email-jiang.liu@linux.intel.com>
References: <1405059585-10620-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static identity and virtual machine domains may be cached in
iommu->domain_ids array after corresponding IOMMUs have been removed
from domain->iommu_bmp. So we should check domain->iommu_bmp before
decreasing domain->iommu_count in function free_dmar_iommu(), otherwise
it may cause free of inuse domain data structure.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 968e3d32e305..0984fa58d872 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -425,6 +425,8 @@ static void domain_remove_one_dev_info(struct dmar_domain *domain,
 				       struct device *dev);
 static void iommu_detach_dependent_devices(struct intel_iommu *iommu,
 					   struct device *dev);
+static int domain_detach_iommu(struct dmar_domain *domain,
+			       struct intel_iommu *iommu);
 
 #ifdef CONFIG_INTEL_IOMMU_DEFAULT_ON
 int dmar_disabled = 0;
@@ -1465,8 +1467,7 @@ static int iommu_init_domains(struct intel_iommu *iommu)
 static void free_dmar_iommu(struct intel_iommu *iommu)
 {
 	struct dmar_domain *domain;
-	int i, count;
-	unsigned long flags;
+	int i;
 
 	if ((iommu->domains) && (iommu->domain_ids)) {
 		for_each_set_bit(i, iommu->domain_ids, cap_ndoms(iommu->cap)) {
@@ -1479,11 +1480,7 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
 
 			domain = iommu->domains[i];
 			clear_bit(i, iommu->domain_ids);
-
-			spin_lock_irqsave(&domain->iommu_lock, flags);
-			count = --domain->iommu_count;
-			spin_unlock_irqrestore(&domain->iommu_lock, flags);
-			if (count == 0)
+			if (domain_detach_iommu(domain, iommu) == 0)
 				domain_exit(domain);
 		}
 	}
-- 
1.7.10.4

