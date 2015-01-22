Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbbAVO2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:28:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57921 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbbAVO2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:28:33 -0500
Date: Thu, 22 Jan 2015 06:28:07 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-659006bf3ae37a08706907ce1a36ddf57c9131d2@git.kernel.org>
Cc: tony.luck@intel.com, bp@alien8.de, hpa@zytor.com,
        jiang.liu@linux.intel.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@kernel.org, linux-kernel@vger.kernel.org
Reply-To: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        bp@alien8.de, tony.luck@intel.com, tglx@linutronix.de, joro@8bytes.org,
        jiang.liu@linux.intel.com
In-Reply-To: <20150115211703.129287153@linutronix.de>
References: <20150115211703.129287153@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/x2apic: Split enable and setup function
Git-Commit-ID: 659006bf3ae37a08706907ce1a36ddf57c9131d2
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

Commit-ID:  659006bf3ae37a08706907ce1a36ddf57c9131d2
Gitweb:     http://git.kernel.org/tip/659006bf3ae37a08706907ce1a36ddf57c9131d2
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:26 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:55 +0100

x86/x2apic: Split enable and setup function

enable_x2apic() is a convoluted unreadable mess because it is used for
both enablement in early boot and for setup in cpu_init().

Split the code into x2apic_enable() for enablement and x2apic_setup()
for setup of (secondary cpus). Make use of the new state tracking to
simplify the logic.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/20150115211703.129287153@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h  |  4 +--
 arch/x86/kernel/apic/apic.c  | 63 ++++++++++++++++++++++++++------------------
 arch/x86/kernel/cpu/common.c |  2 +-
 3 files changed, 41 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 5d7488e..ac60c60 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -179,7 +179,7 @@ static inline u64 native_x2apic_icr_read(void)
 extern int x2apic_mode;
 extern int x2apic_phys;
 extern void __init check_x2apic(void);
-extern void enable_x2apic(void);
+extern void x2apic_setup(void);
 static inline int x2apic_enabled(void)
 {
 	return cpu_has_x2apic && apic_is_x2apic_enabled();
@@ -188,7 +188,7 @@ static inline int x2apic_enabled(void)
 #define x2apic_supported()	(cpu_has_x2apic)
 #else
 static inline void check_x2apic(void) { }
-static inline void enable_x2apic(void) { }
+static inline void x2apic_setup(void) { }
 static inline int x2apic_enabled(void) { return 0; }
 
 #define x2apic_mode		(0)
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 90b8ac5..0ee96b9 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1488,6 +1488,9 @@ static inline void __x2apic_disable(void)
 {
 	u64 msr;
 
+	if (cpu_has_apic)
+		return;
+
 	rdmsrl(MSR_IA32_APICBASE, msr);
 	if (!(msr & X2APIC_ENABLE))
 		return;
@@ -1497,6 +1500,17 @@ static inline void __x2apic_disable(void)
 	printk_once(KERN_INFO "x2apic disabled\n");
 }
 
+static inline void __x2apic_enable(void)
+{
+	u64 msr;
+
+	rdmsrl(MSR_IA32_APICBASE, msr);
+	if (msr & X2APIC_ENABLE)
+		return;
+	wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
+	printk_once(KERN_INFO "x2apic enabled\n");
+}
+
 static int __init setup_nox2apic(char *str)
 {
 	if (x2apic_enabled()) {
@@ -1517,6 +1531,20 @@ static int __init setup_nox2apic(char *str)
 }
 early_param("nox2apic", setup_nox2apic);
 
+/* Called from cpu_init() to enable x2apic on (secondary) cpus */
+void x2apic_setup(void)
+{
+	/*
+	 * If x2apic is not in ON state, disable it if already enabled
+	 * from BIOS.
+	 */
+	if (x2apic_state != X2APIC_ON) {
+		__x2apic_disable();
+		return;
+	}
+	__x2apic_enable();
+}
+
 static __init void x2apic_disable(void)
 {
 	u64 msr;
@@ -1541,30 +1569,19 @@ static __init void x2apic_disable(void)
 	x2apic_state = X2APIC_DISABLED;
 }
 
-void enable_x2apic(void)
+static __init void x2apic_enable(void)
 {
-	u64 msr;
-
-	if (x2apic_state == X2APIC_DISABLED) {
-		__x2apic_disable();
-		x2apic_mode = 0;
-		return;
-	}
-
-	if (!x2apic_mode)
+	if (x2apic_state != X2APIC_OFF)
 		return;
 
-	rdmsrl(MSR_IA32_APICBASE, msr);
-	if (!(msr & X2APIC_ENABLE)) {
-		printk_once(KERN_INFO "Enabling x2apic\n");
-		wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
-	}
+	x2apic_mode = 1;
 	x2apic_state = X2APIC_ON;
+	__x2apic_enable();
 }
 
 static __init void try_to_enable_x2apic(int remap_mode)
 {
-	if (!x2apic_supported())
+	if (x2apic_state == X2APIC_DISABLED)
 		return;
 
 	if (remap_mode != IRQ_REMAP_X2APIC_MODE) {
@@ -1585,12 +1602,7 @@ static __init void try_to_enable_x2apic(int remap_mode)
 		 */
 		x2apic_phys = 1;
 	}
-
-	if (!x2apic_mode) {
-		x2apic_mode = 1;
-		enable_x2apic();
-		pr_info("Enabled x2apic\n");
-	}
+	x2apic_enable();
 }
 
 void __init check_x2apic(void)
@@ -1616,6 +1628,7 @@ static int __init validate_x2apic(void)
 early_initcall(validate_x2apic);
 
 static inline void try_to_enable_x2apic(int remap_mode) { }
+static inline void __x2apic_enable(void) { }
 #endif /* !CONFIG_X86_X2APIC */
 
 static int __init try_to_enable_IR(void)
@@ -2357,9 +2370,9 @@ static void lapic_resume(void)
 	mask_ioapic_entries();
 	legacy_pic->mask_all();
 
-	if (x2apic_mode)
-		enable_x2apic();
-	else {
+	if (x2apic_mode) {
+		__x2apic_enable();
+	} else {
 		/*
 		 * Make sure the APICBASE points to the right address
 		 *
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c604965..cb56925 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1332,7 +1332,7 @@ void cpu_init(void)
 	barrier();
 
 	x86_configure_nx();
-	enable_x2apic();
+	x2apic_setup();
 
 	/*
 	 * set up and load the per-CPU TSS
