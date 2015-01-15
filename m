Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbbAONDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:03:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50155 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbbAONDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:03:50 -0500
Date: Thu, 15 Jan 2015 05:03:22 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-7fa1c842caca3b1d8a55a64033403cab8ca8583a@git.kernel.org>
Cc: yinghai@kernel.org, jiang.liu@linux.intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org,
        benh@kernel.crashing.org, tglx@linutronix.de, bp@alien8.de,
        tony.luck@intel.com, joro@8bytes.org
Reply-To: tglx@linutronix.de, bp@alien8.de, joro@8bytes.org,
        tony.luck@intel.com, jiang.liu@linux.intel.com, yinghai@kernel.org,
        hpa@zytor.com, benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org
In-Reply-To: <1420615903-28253-16-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-16-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/irq_remapping:
  Change variable disable_irq_remap to be static
Git-Commit-ID: 7fa1c842caca3b1d8a55a64033403cab8ca8583a
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

Commit-ID:  7fa1c842caca3b1d8a55a64033403cab8ca8583a
Gitweb:     http://git.kernel.org/tip/7fa1c842caca3b1d8a55a64033403cab8ca8583a
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Wed, 7 Jan 2015 15:31:42 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Jan 2015 11:24:24 +0100

iommu/irq_remapping: Change variable disable_irq_remap to be static

Change variable disable_irq_remap to be static and simplify the code.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Tested-by: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1420615903-28253-16-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/amd_iommu_init.c      | 6 +-----
 drivers/iommu/intel_irq_remapping.c | 5 -----
 drivers/iommu/irq_remapping.c       | 3 +--
 drivers/iommu/irq_remapping.h       | 2 --
 4 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 970979e..e430dc8 100644
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
index fb72bd5..14de1ab 100644
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
index 7d85d2b..5585c4e 100644
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
index a8edfea..c448eb4 100644
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
