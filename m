Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbaAGJAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:00:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:3277 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549AbaAGJAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:00:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,617,1384329600"; 
   d="scan'208";a="454740121"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part2 V1 13/14] iommu/vt-d: update device to static identity domain mapping for PCI hotplug
Date: Tue,  7 Jan 2014 17:00:33 +0800
Message-Id: <1389085234-22296-14-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
References: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When PCI device hotplug event happen, we need to update device to
static identity domain mapping relationship to maintain correct
device to domain mapping.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 6a9a314..83e3ed4 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3659,13 +3659,26 @@ static int device_notifier(struct notifier_block *nb,
 		return 0;
 
 	down_read(&dmar_global_lock);
-	if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through) {
-		domain_remove_one_dev_info(domain, pdev);
+	switch (action) {
+	case BUS_NOTIFY_ADD_DEVICE:
+		if (iommu_should_identity_map(pdev, 1))
+			domain_add_dev_info(si_domain, pdev,
+					    hw_pass_through ?
+					    CONTEXT_TT_PASS_THROUGH :
+					    CONTEXT_TT_MULTI_LEVEL);
+		break;
 
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		if (iommu_pass_through)
+			break;
+		/* fall through */
+	case BUS_NOTIFY_DEL_DEVICE:
+		domain_remove_one_dev_info(domain, pdev);
 		if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) &&
 		    !(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY) &&
 		    list_empty(&domain->devices))
 			domain_exit(domain);
+		break;
 	}
 	up_read(&dmar_global_lock);
 
-- 
1.7.10.4

