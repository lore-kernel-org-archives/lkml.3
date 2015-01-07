Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbbAGH3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:29:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:14996 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbbAGH3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:29:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,713,1413270000"; 
   d="scan'208";a="665633785"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Joerg Roedel <jroedel@suse.de>
Subject: [Patch v2 08/16] iommu/vt-d: Prepare for killing function irq_remapping_supported()
Date: Wed,  7 Jan 2015 15:31:35 +0800
Message-Id: <1420615903-28253-9-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for killing function irq_remapping_supported() by moving code
from intel_irq_remapping_supported() into intel_prepare_irq_remapping().

Combined with patch from Joerg at https://lkml.org/lkml/2014/12/15/487,
so assume an signed-off from Joerg.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/intel_irq_remapping.c |   58 +++++++++++++++--------------------
 1 file changed, 25 insertions(+), 33 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 1e7e09327753..8ccc7aa7e43a 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -568,30 +568,6 @@ static int __init dmar_x2apic_optout(void)
 
 static int __init intel_irq_remapping_supported(void)
 {
-	struct dmar_drhd_unit *drhd;
-	struct intel_iommu *iommu;
-
-	if (disable_irq_remap)
-		return 0;
-	if (irq_remap_broken) {
-		printk(KERN_WARNING
-			"This system BIOS has enabled interrupt remapping\n"
-			"on a chipset that contains an erratum making that\n"
-			"feature unstable.  To maintain system stability\n"
-			"interrupt remapping is being disabled.  Please\n"
-			"contact your BIOS vendor for an update\n");
-		add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
-		disable_irq_remap = 1;
-		return 0;
-	}
-
-	if (!dmar_ir_support())
-		return 0;
-
-	for_each_iommu(iommu, drhd)
-		if (!ecap_ir_support(iommu->ecap))
-			return 0;
-
 	return 1;
 }
 
@@ -616,26 +592,42 @@ static int __init intel_prepare_irq_remapping(void)
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu;
 
+	/* First check whether IRQ remapping should be enabled */
+	if (disable_irq_remap)
+		return -ENODEV;
+
+	if (irq_remap_broken) {
+		printk(KERN_WARNING
+			"This system BIOS has enabled interrupt remapping\n"
+			"on a chipset that contains an erratum making that\n"
+			"feature unstable.  To maintain system stability\n"
+			"interrupt remapping is being disabled.  Please\n"
+			"contact your BIOS vendor for an update\n");
+		add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
+		disable_irq_remap = 1;
+		return -ENODEV;
+	}
+
 	if (dmar_table_init() < 0)
-		return -1;
+		return -ENODEV;
+
+	if (!dmar_ir_support())
+		return -ENODEV;
 
 	if (parse_ioapics_under_ir() != 1) {
 		printk(KERN_INFO "Not enabling interrupt remapping\n");
 		goto error;
 	}
 
-	for_each_iommu(iommu, drhd) {
-		if (!ecap_ir_support(iommu->ecap))
-			continue;
-
-		/* Do the allocations early */
-		if (intel_setup_irq_remapping(iommu))
+	for_each_iommu(iommu, drhd)
+		if (!ecap_ir_support(iommu->ecap) ||
+		    intel_setup_irq_remapping(iommu))
 			goto error;
-	}
 	return 0;
+
 error:
 	intel_cleanup_irq_remapping();
-	return -1;
+	return -ENODEV;
 }
 
 static int __init intel_enable_irq_remapping(void)
-- 
1.7.10.4

