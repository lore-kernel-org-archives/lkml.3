Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbaLJGq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 01:46:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:60546 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756614AbaLJGpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 01:45:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,550,1413270000"; 
   d="scan'208";a="645283242"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC Patch V1 4/9] iommu/vt-d: Prepare for killing function irq_remapping_supported()
Date: Wed, 10 Dec 2014 14:47:46 +0800
Message-Id: <1418194071-13785-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1418194071-13785-1-git-send-email-jiang.liu@linux.intel.com>
References: <1418194071-13785-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for killing function irq_remapping_supported() by moving code
from intel_irq_remapping_supported() into intel_prepare_irq_remapping().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel_irq_remapping.c |   54 ++++++++++++++---------------------
 1 file changed, 21 insertions(+), 33 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index ff35b0336d2b..9e102168d8ae 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -512,30 +512,6 @@ static int __init dmar_x2apic_optout(void)
 
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
 
@@ -560,26 +536,38 @@ static int __init intel_prepare_irq_remapping(void)
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu;
 
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

