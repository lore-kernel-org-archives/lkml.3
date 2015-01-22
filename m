Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbbAVO1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:27:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57872 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbbAVO1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:27:01 -0500
Date: Thu, 22 Jan 2015 06:26:35 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-55eae7de727e9ecc814853ec364fbbb352c337df@git.kernel.org>
Cc: mingo@kernel.org, tony.luck@intel.com, hpa@zytor.com, joro@8bytes.org,
        tglx@linutronix.de, jiang.liu@linux.intel.com, bp@alien8.de,
        linux-kernel@vger.kernel.org
Reply-To: hpa@zytor.com, tony.luck@intel.com, mingo@kernel.org, bp@alien8.de,
        linux-kernel@vger.kernel.org, jiang.liu@linux.intel.com,
        joro@8bytes.org, tglx@linutronix.de
In-Reply-To: <20150115211702.795388613@linutronix.de>
References: <20150115211702.795388613@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/x2apic: Move code in conditional region
Git-Commit-ID: 55eae7de727e9ecc814853ec364fbbb352c337df
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

Commit-ID:  55eae7de727e9ecc814853ec364fbbb352c337df
Gitweb:     http://git.kernel.org/tip/55eae7de727e9ecc814853ec364fbbb352c337df
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:19 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:54 +0100

x86/x2apic: Move code in conditional region

No point in having try_to_enable_x2apic() outside of the
CONFIG_X86_X2APIC section and having inline functions and more ifdefs
to deal with it. Move the code into the existing ifdef section and
remove the inline cruft.

Fixup the printk about not enabling interrupt remapping as suggested
by Boris.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/20150115211702.795388613@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h | 24 +++-------------
 arch/x86/kernel/apic/apic.c | 67 ++++++++++++++++++++++-----------------------
 2 files changed, 37 insertions(+), 54 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index ca8deb4..951caa1 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -186,27 +186,11 @@ static inline int x2apic_enabled(void)
 }
 
 #define x2apic_supported()	(cpu_has_x2apic)
-static inline void x2apic_force_phys(void)
-{
-	x2apic_phys = 1;
-}
 #else
-static inline void disable_x2apic(void)
-{
-}
-static inline void check_x2apic(void)
-{
-}
-static inline void enable_x2apic(void)
-{
-}
-static inline int x2apic_enabled(void)
-{
-	return 0;
-}
-static inline void x2apic_force_phys(void)
-{
-}
+static inline void disable_x2apic(void) { }
+static inline void check_x2apic(void) { }
+static inline void enable_x2apic(void) { }
+static inline int x2apic_enabled(void) { return 0; }
 
 #define x2apic_mode		(0)
 #define	x2apic_supported()	(0)
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d5c3534..bda56ee 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1561,41 +1561,8 @@ void enable_x2apic(void)
 	}
 }
 
-void __init check_x2apic(void)
-{
-	if (x2apic_enabled()) {
-		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
-		x2apic_mode = 1;
-	}
-}
-#else /* CONFIG_X86_X2APIC */
-static int __init validate_x2apic(void)
-{
-	if (!apic_is_x2apic_enabled())
-		return 0;
-	/*
-	 * Checkme: Can we simply turn off x2apic here instead of panic?
-	 */
-	panic("BIOS has enabled x2apic but kernel doesn't support x2apic, please disable x2apic in BIOS.\n");
-}
-early_initcall(validate_x2apic);
-#endif /* !CONFIG_X86_X2APIC */
-
-static int __init try_to_enable_IR(void)
-{
-#ifdef CONFIG_X86_IO_APIC
-	if (!x2apic_enabled() && skip_ioapic_setup) {
-		pr_info("Skipped enabling intr-remap because of skipping "
-			"io-apic setup\n");
-		return -1;
-	}
-#endif
-	return irq_remapping_enable();
-}
-
 static __init void try_to_enable_x2apic(int ir_stat)
 {
-#ifdef CONFIG_X86_X2APIC
 	if (!x2apic_supported())
 		return;
 
@@ -1615,7 +1582,7 @@ static __init void try_to_enable_x2apic(int ir_stat)
 		 * without IR all CPUs can be addressed by IOAPIC/MSI
 		 * only in physical mode
 		 */
-		x2apic_force_phys();
+		x2apic_phys = 1;
 	}
 
 	if (!x2apic_mode) {
@@ -1623,7 +1590,39 @@ static __init void try_to_enable_x2apic(int ir_stat)
 		enable_x2apic();
 		pr_info("Enabled x2apic\n");
 	}
+}
+
+void __init check_x2apic(void)
+{
+	if (x2apic_enabled()) {
+		pr_info("x2apic: enabled by BIOS, switching to x2apic ops\n");
+		x2apic_mode = 1;
+	}
+}
+#else /* CONFIG_X86_X2APIC */
+static int __init validate_x2apic(void)
+{
+	if (!apic_is_x2apic_enabled())
+		return 0;
+	/*
+	 * Checkme: Can we simply turn off x2apic here instead of panic?
+	 */
+	panic("BIOS has enabled x2apic but kernel doesn't support x2apic, please disable x2apic in BIOS.\n");
+}
+early_initcall(validate_x2apic);
+
+static inline void try_to_enable_x2apic(int ir_stat) { }
+#endif /* !CONFIG_X86_X2APIC */
+
+static int __init try_to_enable_IR(void)
+{
+#ifdef CONFIG_X86_IO_APIC
+	if (!x2apic_enabled() && skip_ioapic_setup) {
+		pr_info("Not enabling interrupt remapping due to skipped IO-APIC setup\n");
+		return -1;
+	}
 #endif
+	return irq_remapping_enable();
 }
 
 void __init enable_IR_x2apic(void)
