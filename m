Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbbAGHaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:30:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:2508 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbbAGHaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:30:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,713,1413270000"; 
   d="scan'208";a="665634234"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: [Patch v2 15/16] iommu/irq_remapping: Change variable disable_irq_remap to be static
Date: Wed,  7 Jan 2015 15:31:42 +0800
Message-Id: <1420615903-28253-16-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change variable disable_irq_remap to be static and simplify the code.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/amd_iommu_init.c      |    6 +-----
 drivers/iommu/intel_irq_remapping.c |    5 -----
 drivers/iommu/irq_remapping.c       |    3 +--
 drivers/iommu/irq_remapping.h       |    2 --
 4 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 970979ecbebb..e430dc8dffdf 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -2014,9 +2014,6 @@ static bool detect_ivrs(void)
 	/* Make sure ACS will be enabled during PCI probe */
 	pci_request_acs();
 
-	if (!disable_irq_remap)
-		amd_iommu_irq_remap = true;
-
 	return true;
 }
 
@@ -2123,8 +2120,7 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
 #ifdef CONFIG_IRQ_REMAP
 int __init amd_iommu_prepare(void)
 {
-	if (!amd_iommu_irq_remap)
-		return -1;
+	amd_iommu_irq_remap = true;
 
 	return iommu_go_to_state(IOMMU_ACPI_FINISHED);
 }
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index fb72bd5f438c..14de1ab223c8 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -588,10 +588,6 @@ static int __init intel_prepare_irq_remapping(void)
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu;
 
-	/* First check whether IRQ remapping should be enabled */
-	if (disable_irq_remap)
-		return -ENODEV;
-
 	if (irq_remap_broken) {
 		printk(KERN_WARNING
 			"This system BIOS has enabled interrupt remapping\n"
@@ -600,7 +596,6 @@ static int __init intel_prepare_irq_remapping(void)
 			"interrupt remapping is being disabled.  Please\n"
 			"contact your BIOS vendor for an update\n");
 		add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
-		disable_irq_remap = 1;
 		return -ENODEV;
 	}
 
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 7d85d2ba0e8b..5585c4e17e39 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -17,12 +17,11 @@
 #include "irq_remapping.h"
 
 int irq_remapping_enabled;
-
-int disable_irq_remap;
 int irq_remap_broken;
 int disable_sourceid_checking;
 int no_x2apic_optout;
 
+static int disable_irq_remap;
 static struct irq_remap_ops *remap_ops;
 
 static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec);
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index a8edfea0ab5d..c448eb48340a 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -31,7 +31,6 @@ struct cpumask;
 struct pci_dev;
 struct msi_msg;
 
-extern int disable_irq_remap;
 extern int irq_remap_broken;
 extern int disable_sourceid_checking;
 extern int no_x2apic_optout;
@@ -86,7 +85,6 @@ extern struct irq_remap_ops amd_iommu_irq_ops;
 #else  /* CONFIG_IRQ_REMAP */
 
 #define irq_remapping_enabled 0
-#define disable_irq_remap     1
 #define irq_remap_broken      0
 
 #endif /* CONFIG_IRQ_REMAP */
-- 
1.7.10.4

