Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbbAGH3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:29:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:14996 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbbAGH3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:29:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,713,1413270000"; 
   d="scan'208";a="665633812"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: [Patch v2 09/16] iommu/vt-d: Allocate IRQ remapping data structures only for all IOMMUs
Date: Wed,  7 Jan 2015 15:31:36 +0800
Message-Id: <1420615903-28253-10-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
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
index 8ccc7aa7e43a..137663bd5da2 100644
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

