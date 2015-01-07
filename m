Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbbAGH3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:29:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:14996 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbbAGH3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:29:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,713,1413270000"; 
   d="scan'208";a="665633756"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Beulich <JBeulich@suse.com>, Richard Weinberger <richard@nod.at>,
        Oren Twaig <oren@scalemp.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: [Patch v2 07/16] x86/apic: Refine enable_IR_x2apic() and related functions
Date: Wed,  7 Jan 2015 15:31:34 +0800
Message-Id: <1420615903-28253-8-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refine enable_IR_x2apic() and related functions for better readability.

It also changes the way to handle IR in XAPIC mode when enabling X2APIC.
Previously it just skips X2APIC initialization without checking max CPU
APIC ID in system, which may cause problem if system has CPU with APIC
ID bigger than 255. So treat IR in XAPIC mode as same as IR is disabled
when enabling CPU X2APIC.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/apic.c |   85 +++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 8ce2b8236c1b..09ac1e4ef86b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1572,7 +1572,7 @@ void enable_x2apic(void)
 }
 #endif /* CONFIG_X86_X2APIC */
 
-int __init enable_IR(void)
+static int __init try_to_enable_IR(void)
 {
 #ifdef CONFIG_IRQ_REMAP
 	if (!irq_remapping_supported()) {
@@ -1585,17 +1585,48 @@ int __init enable_IR(void)
 			"io-apic setup\n");
 		return -1;
 	}
+#endif
 
 	return irq_remapping_enable();
+}
+
+static __init void try_to_enable_x2apic(int ir_stat)
+{
+#ifdef CONFIG_X86_X2APIC
+	if (!x2apic_supported())
+		return;
+
+	if (ir_stat != IRQ_REMAP_X2APIC_MODE) {
+		/* IR is required if there is APIC ID > 255 even when running
+		 * under KVM
+		 */
+		if (max_physical_apicid > 255 ||
+		    !hypervisor_x2apic_available()) {
+			pr_info("IRQ remapping doesn't support X2APIC mode, disable x2apic.\n");
+			if (x2apic_preenabled)
+				disable_x2apic();
+			return;
+		}
+
+		/*
+		 * without IR all CPUs can be addressed by IOAPIC/MSI
+		 * only in physical mode
+		 */
+		x2apic_force_phys();
+	}
+
+	if (!x2apic_mode) {
+		x2apic_mode = 1;
+		enable_x2apic();
+		pr_info("Enabled x2apic\n");
+	}
 #endif
-	return -1;
 }
 
 void __init enable_IR_x2apic(void)
 {
 	unsigned long flags;
-	int ret;
-	int hardware_init_ret;
+	int ret, ir_stat;
 
 	if (!IS_ENABLED(CONFIG_X86_X2APIC)) {
 		u64 msr;
@@ -1605,8 +1636,8 @@ void __init enable_IR_x2apic(void)
 			panic("BIOS has enabled x2apic but kernel doesn't support x2apic, please disable x2apic in BIOS.\n");
 	}
 
-	hardware_init_ret = irq_remapping_prepare();
-	if (hardware_init_ret && !x2apic_supported())
+	ir_stat = irq_remapping_prepare();
+	if (ir_stat < 0 && !x2apic_supported())
 		return;
 
 	ret = save_ioapic_entries();
@@ -1621,45 +1652,11 @@ void __init enable_IR_x2apic(void)
 
 	if (x2apic_preenabled && nox2apic)
 		disable_x2apic();
+	if (ir_stat >= 0)
+		ir_stat = try_to_enable_IR();
+	try_to_enable_x2apic(ir_stat);
 
-	if (hardware_init_ret)
-		ret = -1;
-	else
-		ret = enable_IR();
-
-	if (!x2apic_supported())
-		goto skip_x2apic;
-
-	if (ret < 0) {
-		/* IR is required if there is APIC ID > 255 even when running
-		 * under KVM
-		 */
-		if (max_physical_apicid > 255 ||
-		    !hypervisor_x2apic_available()) {
-			if (x2apic_preenabled)
-				disable_x2apic();
-			goto skip_x2apic;
-		}
-		/*
-		 * without IR all CPUs can be addressed by IOAPIC/MSI
-		 * only in physical mode
-		 */
-		x2apic_force_phys();
-	}
-
-	if (ret == IRQ_REMAP_XAPIC_MODE) {
-		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
-		goto skip_x2apic;
-	}
-
-	if (x2apic_supported() && !x2apic_mode) {
-		x2apic_mode = 1;
-		enable_x2apic();
-		pr_info("Enabled x2apic\n");
-	}
-
-skip_x2apic:
-	if (ret < 0) /* IR enabling failed */
+	if (ir_stat < 0) /* IR enabling failed */
 		restore_ioapic_entries();
 	legacy_pic->restore_mask();
 	local_irq_restore(flags);
-- 
1.7.10.4

