Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab3LFDZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 22:25:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:56623 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab3LFDUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 22:20:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,838,1378882800"; 
   d="scan'208";a="325986886"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [Patch Part1 V2 03/20] iommu/vt-d: fix a race window in allocating domain ID for virtual machines
Date: Fri,  6 Dec 2013 11:21:06 +0800
Message-Id: <1386300083-6882-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
References: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function intel_iommu_domain_init() may be concurrently called by upper
layer without serialization, so use atomic_t to protect domain id
allocation.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 43b9bfe..b8e3b48 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3877,7 +3877,7 @@ static void vm_domain_remove_all_dev_info(struct dmar_domain *domain)
 }
 
 /* domain id for virtual machine, it won't be set in context */
-static unsigned long vm_domid;
+static atomic_t vm_domid = ATOMIC_INIT(0);
 
 static struct dmar_domain *iommu_alloc_vm_domain(void)
 {
@@ -3887,7 +3887,7 @@ static struct dmar_domain *iommu_alloc_vm_domain(void)
 	if (!domain)
 		return NULL;
 
-	domain->id = vm_domid++;
+	domain->id = atomic_inc_return(&vm_domid);
 	domain->nid = -1;
 	memset(domain->iommu_bmp, 0, sizeof(domain->iommu_bmp));
 	domain->flags = DOMAIN_FLAG_VIRTUAL_MACHINE;
-- 
1.7.10.4

