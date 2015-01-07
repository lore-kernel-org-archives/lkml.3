Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbbAGH3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:29:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:14996 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206AbbAGH3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:29:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,713,1413270000"; 
   d="scan'208";a="665633849"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: [Patch v2 10/16] iommu/vt-d: Allow IR works in XAPIC mode though CPU works in X2APIC mode
Date: Wed,  7 Jan 2015 15:31:37 +0800
Message-Id: <1420615903-28253-11-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if CPU supports X2APIC, IR hardware must work in X2APIC mode
or disabled. Change the code to support IR working in XAPIC mode when
CPU supports X2APIC. Then the CPU APIC driver will decide how to handle
such as configuration by:
1) Disabling X2APIC mode
2) Forcing X2APIC physical mode

This change also fixes a live locking when
1) BIOS enables CPU X2APIC
2) DMAR table disables X2APIC mode or IR hardware doesn't support X2APIC
with following messages:
[   37.863463] dmar: INTR-REMAP: Request device [[f0:1f.7] fault index 2
[   37.863463] INTR-REMAP:[fault reason 36] Detected reserved fields in the IRTE entry
[   37.879372] dmar: INTR-REMAP: Request device [[f0:1f.7] fault index 2
[   37.879372] INTR-REMAP:[fault reason 36] Detected reserved fields in the IRTE entry
[   37.895282] dmar: INTR-REMAP: Request device [[f0:1f.7] fault index 2
[   37.895282] INTR-REMAP:[fault reason 36] Detected reserved fields in the IRTE entry
[   37.911192] dmar: INTR-REMAP: Request device [[f0:1f.7] fault index 2

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel_irq_remapping.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 137663bd5da2..9d67c12c2ffb 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -32,8 +32,9 @@ struct hpet_scope {
 };
 
 #define IR_X2APIC_MODE(mode) (mode ? (1 << 11) : 0)
-#define IRTE_DEST(dest) ((x2apic_mode) ? dest : dest << 8)
+#define IRTE_DEST(dest) ((eim_mode) ? dest : dest << 8)
 
+static int __read_mostly eim_mode;
 static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static struct hpet_scope ir_hpet[MAX_HPET_TBS];
 
@@ -644,8 +645,6 @@ static int __init intel_enable_irq_remapping(void)
 	int eim = 0;
 
 	if (x2apic_supported()) {
-		pr_info("Queued invalidation will be enabled to support x2apic and Intr-remapping.\n");
-
 		eim = !dmar_x2apic_optout();
 		if (!eim)
 			printk(KERN_WARNING
@@ -683,8 +682,11 @@ static int __init intel_enable_irq_remapping(void)
 		if (eim && !ecap_eim_support(iommu->ecap)) {
 			printk(KERN_INFO "DRHD %Lx: EIM not supported by DRHD, "
 			       " ecap %Lx\n", drhd->reg_base_addr, iommu->ecap);
-			goto error;
+			eim = 0;
 		}
+	eim_mode = eim;
+	if (eim)
+		pr_info("Queued invalidation will be enabled to support x2apic and Intr-remapping.\n");
 
 	/*
 	 * Enable queued invalidation for all the DRHD's.
-- 
1.7.10.4

