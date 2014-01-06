Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaAFGWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:22:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:28563 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbaAFGSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:18:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,611,1384329600"; 
   d="scan'208";a="401364851"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Jiri Kosina <trivial@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part1 V3 07/20] iommu/vt-d, trivial: check suitable flag in function detect_intel_iommu()
Date: Mon,  6 Jan 2014 14:18:14 +0800
Message-Id: <1388989107-4795-8-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1388989107-4795-1-git-send-email-jiang.liu@linux.intel.com>
References: <1388989107-4795-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flag irq_remapping_enabled is only set by intel_enable_irq_remapping(),
which is called after detect_intel_iommu(). So moving pr_info() from
detect_intel_iommu() to intel_enable_irq_remapping(), which also
slightly simplifies implementation.

Reviewed-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/dmar.c                |    8 --------
 drivers/iommu/intel_irq_remapping.c |    2 ++
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index c17dbf7..5e7ba3b 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -556,14 +556,6 @@ int __init detect_intel_iommu(void)
 	if (ret)
 		ret = check_zero_address();
 	{
-		struct acpi_table_dmar *dmar;
-
-		dmar = (struct acpi_table_dmar *) dmar_tbl;
-
-		if (ret && irq_remapping_enabled && cpu_has_x2apic &&
-		    dmar->flags & 0x1)
-			pr_info("Queued invalidation will be enabled to support x2apic and Intr-remapping.\n");
-
 		if (ret && !no_iommu && !iommu_detected && !dmar_disabled) {
 			iommu_detected = 1;
 			/* Make sure ACS will be enabled */
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index deef3d4..2616e8a 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -561,6 +561,8 @@ static int __init intel_enable_irq_remapping(void)
 	}
 
 	if (x2apic_present) {
+		pr_info("Queued invalidation will be enabled to support x2apic and Intr-remapping.\n");
+
 		eim = !dmar_x2apic_optout();
 		if (!eim)
 			printk(KERN_WARNING
-- 
1.7.10.4

