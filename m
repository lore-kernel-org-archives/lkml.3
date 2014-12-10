Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbaLJGpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 01:45:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:21063 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbaLJGpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 01:45:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,550,1413270000"; 
   d="scan'208";a="645283381"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC Patch V1 7/9] iommu/irq_remapping: Change variable disable_irq_remap to be static
Date: Wed, 10 Dec 2014 14:47:49 +0800
Message-Id: <1418194071-13785-8-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1418194071-13785-1-git-send-email-jiang.liu@linux.intel.com>
References: <1418194071-13785-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change variable disable_irq_remap to be static for easy maintenance.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/amd_iommu_init.c      |    5 ++---
 drivers/iommu/intel_irq_remapping.c |    1 -
 drivers/iommu/irq_remapping.c       |    3 +--
 drivers/iommu/irq_remapping.h       |    2 --
 4 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index fc047a4ee661..e6c34966cdc2 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -2018,9 +2018,6 @@ static bool detect_ivrs(void)
 	/* Make sure ACS will be enabled during PCI probe */
 	pci_request_acs();
 
-	if (!disable_irq_remap)
-		amd_iommu_irq_remap = true;
-
 	return true;
 }
 
@@ -2127,6 +2124,8 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
 #ifdef CONFIG_IRQ_REMAP
 int __init amd_iommu_prepare(void)
 {
+	amd_iommu_irq_remap = true;
+
 	return iommu_go_to_state(IOMMU_ACPI_FINISHED);
 }
 
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index c2255927766b..fba4f7f789a5 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -539,7 +539,6 @@ static int __init intel_prepare_irq_remapping(void)
 			"interrupt remapping is being disabled.  Please\n"
 			"contact your BIOS vendor for an update\n");
 		add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
-		disable_irq_remap = 1;
 		return -ENODEV;
 	}
 
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index a28001af4e15..fbd585e49ebd 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -18,12 +18,11 @@
 #include "irq_remapping.h"
 
 int irq_remapping_enabled;
-
-int disable_irq_remap;
 int irq_remap_broken;
 int disable_sourceid_checking;
 int no_x2apic_optout;
 
+static int disable_irq_remap;
 static struct irq_remap_ops *remap_ops;
 
 static void irq_remapping_disable_io_apic(void)
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index 961dc49305e1..8621173c7fcb 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -29,7 +29,6 @@ struct msi_msg;
 struct irq_domain;
 struct irq_alloc_info;
 
-extern int disable_irq_remap;
 extern int irq_remap_broken;
 extern int disable_sourceid_checking;
 extern int no_x2apic_optout;
@@ -66,7 +65,6 @@ extern void ir_ack_apic_edge(struct irq_data *data);
 #else  /* CONFIG_IRQ_REMAP */
 
 #define irq_remapping_enabled 0
-#define disable_irq_remap     1
 #define irq_remap_broken      0
 
 #endif /* CONFIG_IRQ_REMAP */
-- 
1.7.10.4

