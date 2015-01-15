Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbbAONEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:04:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50172 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbbAONEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:04:11 -0500
Date: Thu, 15 Jan 2015 05:01:45 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-13d09b6603df9df3aa3e410bc2a876889a55c744@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, yinghai@kernel.org,
        hpa@zytor.com, tglx@linutronix.de, joro@8bytes.org,
        benh@kernel.crashing.org, mingo@kernel.org, jiang.liu@linux.intel.com,
        bp@alien8.de
Reply-To: bp@alien8.de, mingo@kernel.org, jiang.liu@linux.intel.com,
        yinghai@kernel.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, joro@8bytes.org, tglx@linutronix.de,
        hpa@zytor.com
In-Reply-To: <1420615903-28253-11-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-11-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/vt-d:
  Allow IR works in XAPIC mode though CPU works in X2APIC mode
Git-Commit-ID: 13d09b6603df9df3aa3e410bc2a876889a55c744
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

Commit-ID:  13d09b6603df9df3aa3e410bc2a876889a55c744
Gitweb:     http://git.kernel.org/tip/13d09b6603df9df3aa3e410bc2a876889a55c744
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Wed, 7 Jan 2015 15:31:37 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Jan 2015 11:24:23 +0100

iommu/vt-d: Allow IR works in XAPIC mode though CPU works in X2APIC mode

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
Tested-by: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1420615903-28253-11-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/intel_irq_remapping.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 137663b..9d67c12 100644
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
