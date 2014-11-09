Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaKIOpK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 09:45:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:9864 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbaKIOpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 09:45:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="485940477"
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
Subject: [Patch Part3 V7 6/8] iommu/vt-d: Enhance error recovery in function intel_enable_irq_remapping()
Date: Sun,  9 Nov 2014 22:48:01 +0800
Message-Id: <1415544483-27990-7-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415544483-27990-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415544483-27990-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance error recovery in function intel_enable_irq_remapping()
by tearing down all created data structures.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Reviewed-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/iommu/intel_irq_remapping.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 7af0b56dc2d1..27541d440849 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -702,9 +702,11 @@ static int __init intel_enable_irq_remapping(void)
 	return eim ? IRQ_REMAP_X2APIC_MODE : IRQ_REMAP_XAPIC_MODE;
 
 error:
-	/*
-	 * handle error condition gracefully here!
-	 */
+	for_each_iommu(iommu, drhd)
+		if (ecap_ir_support(iommu->ecap)) {
+			iommu_disable_irq_remapping(iommu);
+			intel_teardown_irq_remapping(iommu);
+		}
 
 	if (x2apic_present)
 		pr_warn("Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.\n");
-- 
1.7.10.4

