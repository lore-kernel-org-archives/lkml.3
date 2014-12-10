Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbaLJGp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 01:45:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:60546 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbaLJGpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 01:45:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,550,1413270000"; 
   d="scan'208";a="645283214"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Beulich <JBeulich@suse.com>, Richard Weinberger <richard@nod.at>,
        Oren Twaig <oren@scalemp.com>
Cc: Tony Luck <tony.luck@intel.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC Patch V1 3/9] x86, apic: Refine enable_IR_x2apic() and related functions
Date: Wed, 10 Dec 2014 14:47:45 +0800
Message-Id: <1418194071-13785-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1418194071-13785-1-git-send-email-jiang.liu@linux.intel.com>
References: <1418194071-13785-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refine enable_IR_x2apic() and related functions for better maintenence.
It also changes the way to treat IR in XAPIC mode as the same as IR is
disabled when enabling X2APIC.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/apic.c |   78 ++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b6c473b97c5c..2a9bac837be4 100644
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
@@ -1585,44 +1585,18 @@ int __init enable_IR(void)
 			"io-apic setup\n");
 		return -1;
 	}
+#endif
 
 	return irq_remapping_enable();
-#endif
-	return -1;
 }
 
-void __init enable_IR_x2apic(void)
+static __init void try_to_enable_x2apic(int ir_stat)
 {
-	unsigned long flags;
-	int ret;
-	int hardware_init_ret;
-
-	hardware_init_ret = irq_remapping_prepare();
-	if (hardware_init_ret && !x2apic_supported())
-		return;
-
-	ret = save_ioapic_entries();
-	if (ret) {
-		pr_info("Saving IO-APIC state failed: %d\n", ret);
-		return;
-	}
-
-	local_irq_save(flags);
-	legacy_pic->mask_all();
-	mask_ioapic_entries();
-
-	if (x2apic_preenabled && nox2apic)
-		disable_x2apic();
-
-	if (hardware_init_ret)
-		ret = -1;
-	else
-		ret = enable_IR();
-
+#ifdef CONFIG_X86_X2APIC
 	if (!x2apic_supported())
-		goto skip_x2apic;
+		return;
 
-	if (ret < 0) {
+	if (ir_stat != IRQ_REMAP_X2APIC_MODE) {
 		/* IR is required if there is APIC ID > 255 even when running
 		 * under KVM
 		 */
@@ -1630,8 +1604,9 @@ void __init enable_IR_x2apic(void)
 		    !hypervisor_x2apic_available()) {
 			if (x2apic_preenabled)
 				disable_x2apic();
-			goto skip_x2apic;
+			return;
 		}
+
 		/*
 		 * without IR all CPUs can be addressed by IOAPIC/MSI
 		 * only in physical mode
@@ -1639,19 +1614,40 @@ void __init enable_IR_x2apic(void)
 		x2apic_force_phys();
 	}
 
-	if (ret == IRQ_REMAP_XAPIC_MODE) {
-		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
-		goto skip_x2apic;
-	}
-
-	if (x2apic_supported() && !x2apic_mode) {
+	if (!x2apic_mode) {
 		x2apic_mode = 1;
 		enable_x2apic();
 		pr_info("Enabled x2apic\n");
 	}
+#endif
+}
+
+void __init enable_IR_x2apic(void)
+{
+	unsigned long flags;
+	int ret, ir_stat;
+
+	ir_stat = irq_remapping_prepare();
+	if (ir_stat < 0 && !x2apic_supported())
+		return;
+
+	ret = save_ioapic_entries();
+	if (ret) {
+		pr_info("Saving IO-APIC state failed: %d\n", ret);
+		return;
+	}
+
+	local_irq_save(flags);
+	legacy_pic->mask_all();
+	mask_ioapic_entries();
+
+	if (x2apic_preenabled && nox2apic)
+		disable_x2apic();
+	if (ir_stat >= 0)
+		ir_stat = try_to_enable_IR();
+	try_to_enable_x2apic(ir_stat);
 
-skip_x2apic:
-	if (ret < 0) /* IR enabling failed */
+	if (ir_stat < 0) /* IR enabling failed */
 		restore_ioapic_entries();
 	legacy_pic->restore_mask();
 	local_irq_restore(flags);
-- 
1.7.10.4

