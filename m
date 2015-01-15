Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbbAONBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:01:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50052 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbbAONBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:01:35 -0500
Date: Thu, 15 Jan 2015 05:00:31 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-07806c50bddd2f0493f97584198733946952409c@git.kernel.org>
Cc: joro@8bytes.org, tony.luck@intel.com, mingo@kernel.org, bp@alien8.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, JBeulich@suse.com,
        jiang.liu@linux.intel.com, rientjes@google.com, yinghai@kernel.org,
        oren@scalemp.com, richard@nod.at, tglx@linutronix.de,
        benh@kernel.crashing.org, hpa@linux.intel.com,
        d.hatayama@jp.fujitsu.com
Reply-To: hpa@zytor.com, JBeulich@suse.com, mingo@kernel.org, bp@alien8.de,
        linux-kernel@vger.kernel.org, tony.luck@intel.com, joro@8bytes.org,
        benh@kernel.crashing.org, hpa@linux.intel.com,
        d.hatayama@jp.fujitsu.com, richard@nod.at, tglx@linutronix.de,
        yinghai@kernel.org, oren@scalemp.com, jiang.liu@linux.intel.com,
        rientjes@google.com
In-Reply-To: <1420615903-28253-8-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-8-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Refine enable_IR_x2apic()
  and related functions
Git-Commit-ID: 07806c50bddd2f0493f97584198733946952409c
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

Commit-ID:  07806c50bddd2f0493f97584198733946952409c
Gitweb:     http://git.kernel.org/tip/07806c50bddd2f0493f97584198733946952409c
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Wed, 7 Jan 2015 15:31:34 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Jan 2015 11:24:23 +0100

x86/apic: Refine enable_IR_x2apic() and related functions

Refine enable_IR_x2apic() and related functions for better readability.

[ tglx: Removed the XAPIC mode change and split it out into a seperate
  	patch. Added comments. ]

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Rientjes <rientjes@google.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Oren Twaig <oren@scalemp.com>
Link: http://lkml.kernel.org/r/1420615903-28253-8-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c | 92 +++++++++++++++++++++++----------------------
 1 file changed, 47 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 11358df..fa77be8 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1573,7 +1573,7 @@ void enable_x2apic(void)
 }
 #endif /* CONFIG_X86_X2APIC */
 
-int __init enable_IR(void)
+static int __init try_to_enable_IR(void)
 {
 #ifdef CONFIG_IRQ_REMAP
 	if (!irq_remapping_supported()) {
@@ -1586,17 +1586,51 @@ int __init enable_IR(void)
 			"io-apic setup\n");
 		return -1;
 	}
-
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
+	if (ir_stat < 0) {
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
+
+	} else if (ir_stat == IRQ_REMAP_XAPIC_MODE) {
+		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
+		return;
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
@@ -1606,8 +1640,8 @@ void __init enable_IR_x2apic(void)
 			panic("BIOS has enabled x2apic but kernel doesn't support x2apic, please disable x2apic in BIOS.\n");
 	}
 
-	hardware_init_ret = irq_remapping_prepare();
-	if (hardware_init_ret && !x2apic_supported())
+	ir_stat = irq_remapping_prepare();
+	if (ir_stat < 0 && !x2apic_supported())
 		return;
 
 	ret = save_ioapic_entries();
@@ -1622,45 +1656,13 @@ void __init enable_IR_x2apic(void)
 
 	if (x2apic_preenabled && nox2apic)
 		disable_x2apic();
+	/* If irq_remapping_prepare() succeded, try to enable it */
+	if (ir_stat >= 0)
+		ir_stat = try_to_enable_IR();
+	/* ir_stat contains the remap mode or an error code */
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
+	if (ir_stat < 0)
 		restore_ioapic_entries();
 	legacy_pic->restore_mask();
 	local_irq_restore(flags);
