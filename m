Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbbAVO2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:28:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57910 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbbAVO2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:28:08 -0500
Date: Thu, 22 Jan 2015 06:27:43 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-44e25ff9e6912347a1a54c757fc75681d0dc42d0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        mingo@kernel.org, bp@alien8.de, joro@8bytes.org, tglx@linutronix.de,
        tony.luck@intel.com
Reply-To: tglx@linutronix.de, joro@8bytes.org, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        bp@alien8.de, mingo@kernel.org
In-Reply-To: <20150115211703.051214090@linutronix.de>
References: <20150115211703.051214090@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/x2apic: Disable x2apic from nox2apic setup
Git-Commit-ID: 44e25ff9e6912347a1a54c757fc75681d0dc42d0
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

Commit-ID:  44e25ff9e6912347a1a54c757fc75681d0dc42d0
Gitweb:     http://git.kernel.org/tip/44e25ff9e6912347a1a54c757fc75681d0dc42d0
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:24 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:55 +0100

x86/x2apic: Disable x2apic from nox2apic setup

There is no point in postponing the hardware disablement of x2apic. It
can be disabled right away in the nox2apic setup function.

Disable it right away and set the state to DISABLED . This allows to
remove all the nox2apic conditionals all over the place.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/20150115211703.051214090@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h |  1 -
 arch/x86/kernel/apic/apic.c | 59 ++++++++++++++++++---------------------------
 2 files changed, 24 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 951caa1..5d7488e 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -187,7 +187,6 @@ static inline int x2apic_enabled(void)
 
 #define x2apic_supported()	(cpu_has_x2apic)
 #else
-static inline void disable_x2apic(void) { }
 static inline void check_x2apic(void) { }
 static inline void enable_x2apic(void) { }
 static inline int x2apic_enabled(void) { return 0; }
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b374b0d..90b8ac5 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1474,12 +1474,8 @@ void __init bsp_end_local_APIC_setup(void)
 
 }
 
-/* Control whether x2APIC mode is enabled or not */
-static bool nox2apic __initdata;
-
 #ifdef CONFIG_X86_X2APIC
 int x2apic_mode;
-static int x2apic_disabled;
 
 enum {
 	X2APIC_OFF,
@@ -1488,6 +1484,19 @@ enum {
 };
 static int x2apic_state;
 
+static inline void __x2apic_disable(void)
+{
+	u64 msr;
+
+	rdmsrl(MSR_IA32_APICBASE, msr);
+	if (!(msr & X2APIC_ENABLE))
+		return;
+	/* Disable xapic and x2apic first and then reenable xapic mode */
+	wrmsrl(MSR_IA32_APICBASE, msr & ~(X2APIC_ENABLE | XAPIC_ENABLE));
+	wrmsrl(MSR_IA32_APICBASE, msr & ~X2APIC_ENABLE);
+	printk_once(KERN_INFO "x2apic disabled\n");
+}
+
 static int __init setup_nox2apic(char *str)
 {
 	if (x2apic_enabled()) {
@@ -1498,28 +1507,17 @@ static int __init setup_nox2apic(char *str)
 				   apicid);
 			return 0;
 		}
-
-		pr_warning("x2apic already enabled. will disable it\n");
-	} else
-		setup_clear_cpu_cap(X86_FEATURE_X2APIC);
-
-	nox2apic = true;
+		pr_warning("x2apic already enabled.\n");
+		__x2apic_disable();
+	}
+	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 	x2apic_state = X2APIC_DISABLED;
+	x2apic_mode = 0;
 	return 0;
 }
 early_param("nox2apic", setup_nox2apic);
 
-/*
- * Need to disable xapic and x2apic at the same time and then enable xapic mode
- */
-static inline void __disable_x2apic(u64 msr)
-{
-	wrmsrl(MSR_IA32_APICBASE,
-	       msr & ~(X2APIC_ENABLE | XAPIC_ENABLE));
-	wrmsrl(MSR_IA32_APICBASE, msr & ~X2APIC_ENABLE);
-}
-
-static __init void disable_x2apic(void)
+static __init void x2apic_disable(void)
 {
 	u64 msr;
 
@@ -1533,20 +1531,13 @@ static __init void disable_x2apic(void)
 		if (x2apic_id >= 255)
 			panic("Cannot disable x2apic, id: %08x\n", x2apic_id);
 
-		pr_info("Disabling x2apic\n");
-		__disable_x2apic(msr);
-
-		if (nox2apic) {
-			clear_cpu_cap(&cpu_data(0), X86_FEATURE_X2APIC);
-			setup_clear_cpu_cap(X86_FEATURE_X2APIC);
-		}
+		__x2apic_disable();
 
 		x2apic_mode = 0;
 
 		register_lapic_address(mp_lapic_addr);
 	}
 
-	x2apic_disabled = 1;
 	x2apic_state = X2APIC_DISABLED;
 }
 
@@ -1554,9 +1545,8 @@ void enable_x2apic(void)
 {
 	u64 msr;
 
-	rdmsrl(MSR_IA32_APICBASE, msr);
-	if (x2apic_disabled) {
-		__disable_x2apic(msr);
+	if (x2apic_state == X2APIC_DISABLED) {
+		__x2apic_disable();
 		x2apic_mode = 0;
 		return;
 	}
@@ -1564,6 +1554,7 @@ void enable_x2apic(void)
 	if (!x2apic_mode)
 		return;
 
+	rdmsrl(MSR_IA32_APICBASE, msr);
 	if (!(msr & X2APIC_ENABLE)) {
 		printk_once(KERN_INFO "Enabling x2apic\n");
 		wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
@@ -1584,7 +1575,7 @@ static __init void try_to_enable_x2apic(int remap_mode)
 		    (IS_ENABLED(CONFIG_HYPERVISOR_GUEST) &&
 		     !hypervisor_x2apic_available())) {
 			pr_info("x2apic: IRQ remapping doesn't support X2APIC mode\n");
-			disable_x2apic();
+			x2apic_disable();
 			return;
 		}
 
@@ -1657,8 +1648,6 @@ void __init enable_IR_x2apic(void)
 	legacy_pic->mask_all();
 	mask_ioapic_entries();
 
-	if (nox2apic)
-		disable_x2apic();
 	/* If irq_remapping_prepare() succeded, try to enable it */
 	if (ir_stat >= 0)
 		ir_stat = try_to_enable_IR();
