Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaLQEdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 23:33:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:36936 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbaLQEdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 23:33:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="429971389"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: [Patch v1 10/17] iommu/vt-d: Allocate IRQ remapping data structures only for all IOMMUs
Date: Wed, 17 Dec 2014 12:35:41 +0800
Message-Id: <1418790948-22804-11-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1418790948-22804-1-git-send-email-jiang.liu@linux.intel.com>
References: <1418790948-22804-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

IRQ remapping is only supported when all IOMMUs in the
system support it. So check if all IOMMUs in the system
support IRQ remapping before doing the allocations.

[Jiang]
1) Rebased onto v3.19.
2) Remove redundant check of ecap_ir_support(iommu->ecap) in function
   intel_enable_irq_remapping().

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel_irq_remapping.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index b7ce4f458b29..a47cb31f198e 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -619,10 +619,16 @@ static int __init intel_prepare_irq_remapping(void)
 		goto error;
 	}
 
+	/* First make sure all IOMMUs support IRQ remapping */
 	for_each_iommu(iommu, drhd)
-		if (!ecap_ir_support(iommu->ecap) ||
-		    intel_setup_irq_remapping(iommu))
+		if (!ecap_ir_support(iommu->ecap))
+			goto error;
+
+	/* Do the allocations early */
+	for_each_iommu(iommu, drhd)
+		if (intel_setup_irq_remapping(iommu))
 			goto error;
+
 	return 0;
 
 error:
@@ -673,16 +679,12 @@ static int __init intel_enable_irq_remapping(void)
 	/*
 	 * check for the Interrupt-remapping support
 	 */
-	for_each_iommu(iommu, drhd) {
-		if (!ecap_ir_support(iommu->ecap))
-			continue;
-
+	for_each_iommu(iommu, drhd)
 		if (eim && !ecap_eim_support(iommu->ecap)) {
 			printk(KERN_INFO "DRHD %Lx: EIM not supported by DRHD, "
 			       " ecap %Lx\n", drhd->reg_base_addr, iommu->ecap);
 			goto error;
 		}
-	}
 
 	/*
 	 * Enable queued invalidation for all the DRHD's.
@@ -702,9 +704,6 @@ static int __init intel_enable_irq_remapping(void)
 	 * Setup Interrupt-remapping for all the DRHD's now.
 	 */
 	for_each_iommu(iommu, drhd) {
-		if (!ecap_ir_support(iommu->ecap))
-			continue;
-
 		iommu_set_irq_remapping(iommu, eim);
 		setup = 1;
 	}
-- 
1.7.10.4

