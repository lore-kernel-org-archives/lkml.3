Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbbAONSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:18:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50358 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbbAONSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:18:39 -0500
Date: Thu, 15 Jan 2015 05:01:07 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-2966d9566beb39c53477c96525820b9415de7a7d@git.kernel.org>
Cc: bp@alien8.de, joro@8bytes.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, yinghai@kernel.org, hpa@zytor.com,
        mingo@kernel.org, jiang.liu@linux.intel.com, jroedel@suse.de,
        tony.luck@intel.com, benh@kernel.crashing.org
Reply-To: bp@alien8.de, joro@8bytes.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, tony.luck@intel.com, jroedel@suse.de,
        benh@kernel.crashing.org, yinghai@kernel.org,
        jiang.liu@linux.intel.com, mingo@kernel.org, hpa@zytor.com
In-Reply-To: <1420615903-28253-9-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-9-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/vt-d:
  Prepare for killing function irq_remapping_supported()
Git-Commit-ID: 2966d9566beb39c53477c96525820b9415de7a7d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2966d9566beb39c53477c96525820b9415de7a7d
Gitweb:     http://git.kernel.org/tip/2966d9566beb39c53477c96525820b9415de7a7d
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Wed, 7 Jan 2015 15:31:35 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Jan 2015 11:24:23 +0100

iommu/vt-d: Prepare for killing function irq_remapping_supported()

Prepare for killing function irq_remapping_supported() by moving code
from intel_irq_remapping_supported() into intel_prepare_irq_remapping().

Combined with patch from Joerg at https://lkml.org/lkml/2014/12/15/487,
so assume an signed-off from Joerg.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1420615903-28253-9-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/intel_irq_remapping.c | 58 ++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 33 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 1e7e093..8ccc7aa 100644
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
