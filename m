Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaIBNBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:01:32 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34198 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbaIBNB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:01:29 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>, Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v11 05/19] arm: KGDB/KDB FIQ support
Date: Tue,  2 Sep 2014 14:00:39 +0100
Message-Id: <1409662853-29313-6-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org>
 <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FIQ debugger may be used to debug situations when the kernel stuck
in uninterruptable sections, e.g. the kernel infinitely loops or
deadlocked in an interrupt or with interrupts disabled.

Credit:

    This patch is a near complete re-write of a patch originally
    provided by Anton Vorontsov. Today only a couple of comments and
    other small fragments still survive, however without Anton's work
    to build from this patch would not exist.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Omar Sandoval <osandov@osandov.com>
---
 arch/arm/Kconfig            |   2 +
 arch/arm/Kconfig.debug      |  19 ++++++++
 arch/arm/include/asm/kgdb.h |   5 ++
 arch/arm/kernel/fiq.c       |   4 +-
 arch/arm/kernel/kgdb.c      | 112 +++++++++++++++++++++++++++++++++++++++++---
 5 files changed, 135 insertions(+), 7 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c49a775..e6380b3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -305,6 +305,7 @@ choice
 config ARCH_MULTIPLATFORM
 	bool "Allow multiple platforms to be selected"
 	depends on MMU
+	select ARCH_MIGHT_HAVE_KGDB_FIQ
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARM_HAS_SG_CHAIN
 	select ARM_PATCH_PHYS_VIRT
@@ -352,6 +353,7 @@ config ARCH_REALVIEW
 
 config ARCH_VERSATILE
 	bool "ARM Ltd. Versatile family"
+	select ARCH_MIGHT_HAVE_KGDB_FIQ
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARM_AMBA
 	select ARM_TIMER_SP804
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index b11ad54..df3f0bf 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -2,6 +2,25 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
+config ARCH_MIGHT_HAVE_KGDB_FIQ
+	bool
+
+config KGDB_FIQ
+	bool "KGDB FIQ support"
+	depends on KGDB_KDB && ARCH_MIGHT_HAVE_KGDB_FIQ && !THUMB2_KERNEL
+	select FIQ
+	help
+	  The FIQ debugger may be used to debug situations when the
+	  kernel stuck in uninterruptable sections, e.g. the kernel
+	  infinitely loops or deadlocked in an interrupt or with
+	  interrupts disabled.
+
+	  By default KGDB FIQ is disabled at runtime, but can be enabled
+	  by setting the console to ttyNMI0 (and choosing the underlying
+	  serial port using kgdboc)
+
+	  If unsure, say N.
+
 config ARM_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
diff --git a/arch/arm/include/asm/kgdb.h b/arch/arm/include/asm/kgdb.h
index 0a9d5dd..cb5ccd6 100644
--- a/arch/arm/include/asm/kgdb.h
+++ b/arch/arm/include/asm/kgdb.h
@@ -11,7 +11,9 @@
 #define __ARM_KGDB_H__
 
 #include <linux/ptrace.h>
+#include <linux/linkage.h>
 #include <asm/opcodes.h>
+#include <asm/exception.h>
 
 /*
  * GDB assumes that we're a user process being debugged, so
@@ -48,6 +50,9 @@ static inline void arch_kgdb_breakpoint(void)
 extern void kgdb_handle_bus_error(void);
 extern int kgdb_fault_expected;
 
+extern int kgdb_register_fiq(unsigned int fiq);
+extern void kgdb_handle_fiq(struct pt_regs *regs);
+
 #endif /* !__ASSEMBLY__ */
 
 /*
diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index 77c62b2..c6b3bed 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -229,7 +229,9 @@ asmlinkage void __exception_irq_entry fiq_nmi_handler(struct pt_regs *regs)
 	 * order to ensure code review happens (drivers cannot "secretly"
 	 * employ FIQ without modifying this chain of calls).
 	 */
-	/* list is currently empty */
+#ifdef CONFIG_KGDB_FIQ
+	kgdb_handle_fiq(regs);
+#endif
 
 	nmi_exit();
 	set_irq_regs(old_regs);
diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index a74b53c..630a3ef 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -12,8 +12,11 @@
 #include <linux/irq.h>
 #include <linux/kdebug.h>
 #include <linux/kgdb.h>
+#include <asm/fiq.h>
 #include <asm/traps.h>
 
+static unsigned int kgdb_fiq;
+
 struct dbg_reg_def_t dbg_reg_def[DBG_MAX_REG_NUM] =
 {
 	{ "r0", 4, offsetof(struct pt_regs, ARM_r0)},
@@ -175,14 +178,26 @@ static struct undef_hook kgdb_compiled_brkpt_hook = {
 
 static void kgdb_call_nmi_hook(void *ignored)
 {
-       kgdb_nmicallback(raw_smp_processor_id(), get_irq_regs());
+	kgdb_nmicallback(raw_smp_processor_id(), get_irq_regs());
 }
 
 void kgdb_roundup_cpus(unsigned long flags)
 {
-       local_irq_enable();
-       smp_call_function(kgdb_call_nmi_hook, NULL, 0);
-       local_irq_disable();
+#if defined CONFIG_KGDB_FIQ && defined CONFIG_SMP
+	struct cpumask mask;
+
+	if (in_nmi()) {
+		cpumask_copy(&mask, cpu_online_mask);
+		cpumask_clear_cpu(raw_smp_processor_id(), &mask);
+		if (!cpumask_empty(&mask))
+			send_fiq_ipi_mask(&mask);
+		return;
+	}
+#endif
+
+	local_irq_enable();
+	smp_call_function(kgdb_call_nmi_hook, NULL, 0);
+	local_irq_disable();
 }
 
 static int __kgdb_notify(struct die_args *args, unsigned long cmd)
@@ -244,6 +259,43 @@ void kgdb_arch_exit(void)
 	unregister_die_notifier(&kgdb_notifier);
 }
 
+/**
+ * kgdb_fiq_enable_nmi - Manage NMI-triggered entry to KGDB
+ * @on: Flag to either enable or disable an NMI
+ *
+ * The call counts disable requests, and thus allows to nest disables. But
+ * trying to enable already enabled NMI is an error.
+ */
+static void kgdb_fiq_enable_nmi(bool on)
+{
+	if (!kgdb_fiq)
+		return;
+
+#ifdef CONFIG_KGDB_FIQ
+	static atomic_t cnt;
+	int ret;
+
+	if (on) {
+		ret = atomic_add_return(1, &cnt);
+		if (ret == 1)
+			enable_fiq(kgdb_fiq);
+
+		/*
+		 * There should be only one instance that calls this function
+		 * in "enable, disable" order. All other users must call
+		 * disable first, then enable. If not, something is wrong.
+		 */
+		if (WARN_ON(ret > 1))
+			return;
+	} else {
+		ret = atomic_add_return(-1, &cnt);
+		if (ret == 0)
+			disable_fiq(kgdb_fiq);
+	}
+#endif
+}
+
+
 /*
  * Register our undef instruction hooks with ARM undef core.
  * We regsiter a hook specifically looking for the KGB break inst
@@ -252,8 +304,56 @@ void kgdb_arch_exit(void)
  */
 struct kgdb_arch arch_kgdb_ops = {
 #ifndef __ARMEB__
-	.gdb_bpt_instr		= {0xfe, 0xde, 0xff, 0xe7}
+	.gdb_bpt_instr		= {0xfe, 0xde, 0xff, 0xe7},
 #else /* ! __ARMEB__ */
-	.gdb_bpt_instr		= {0xe7, 0xff, 0xde, 0xfe}
+	.gdb_bpt_instr		= {0xe7, 0xff, 0xde, 0xfe},
 #endif
+	.enable_nmi		= kgdb_fiq_enable_nmi
 };
+
+#ifdef CONFIG_KGDB_FIQ
+void kgdb_handle_fiq(struct pt_regs *regs)
+{
+	int actual;
+
+	if (!kgdb_fiq)
+		return;
+
+	if (!kgdb_nmicallback(raw_smp_processor_id(), regs))
+		return NOTIFY_OK;
+
+	actual = ack_fiq(kgdb_fiq);
+	WARN_ON(actual != kgdb_fiq);
+
+	/* there's no harm in doing this regardless of the above WARN_ON() */
+	if (kgdb_nmi_poll_knock())
+		kgdb_handle_exception(1, 0, 0, regs);
+
+	eoi_fiq(actual);
+
+	return NOTIFY_OK;
+}
+
+int kgdb_register_fiq(unsigned int fiq)
+{
+	static struct fiq_handler kgdb_fiq_desc = { .name = "kgdb", };
+	int err;
+
+	if (!has_fiq(fiq)) {
+		pr_warn(
+		    "%s: Cannot register %u (no FIQ with this number)\n",
+		    __func__, fiq);
+		return -ENODEV;
+	}
+
+	err = claim_fiq(&kgdb_fiq_desc);
+	if (err) {
+		pr_warn("%s: unable to claim fiq", __func__);
+		return err;
+	}
+
+	kgdb_fiq = fiq;
+
+	return 0;
+}
+#endif
-- 
1.9.3

