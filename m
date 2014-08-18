Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaHRNlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:41:35 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:62815 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaHRNla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:41:30 -0400
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
Subject: [PATCH v9 05/16] arm: KGDB/KDB FIQ support
Date: Mon, 18 Aug 2014 14:40:53 +0100
Message-Id: <1408369264-14242-6-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408369264-14242-1-git-send-email-daniel.thompson@linaro.org>
References: <1404979427-12943-1-git-send-email-daniel.thompson@linaro.org>
 <1408369264-14242-1-git-send-email-daniel.thompson@linaro.org>
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
 arch/arm/include/asm/kgdb.h |   4 ++
 arch/arm/kernel/kgdb.c      | 115 +++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 134 insertions(+), 6 deletions(-)

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
index f304694..a99f8d2 100644
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
index 0a9d5dd..6563da0 100644
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
@@ -48,6 +50,8 @@ static inline void arch_kgdb_breakpoint(void)
 extern void kgdb_handle_bus_error(void);
 extern int kgdb_fault_expected;
 
+extern int kgdb_register_fiq(unsigned int fiq);
+
 #endif /* !__ASSEMBLY__ */
 
 /*
diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index a74b53c..928c205 100644
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
@@ -244,6 +259,41 @@ void kgdb_arch_exit(void)
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
+	/* warn if ttyNMI0 is active but brings no benefit */
+	if (WARN_ONCE(!kgdb_fiq, "kgdb: no FIQ available\n"))
+		return;
+
+#ifdef CONFIG_KGDB_FIQ
+	static atomic_t cnt;
+	int ret;
+
+	ret = atomic_add_return(on ? 1 : -1, &cnt);
+
+	/*
+	 * There should be only one instance that calls this function
+	 * in "enable, disable" order. All other users must call
+	 * disable first, then enable. If not, something is wrong.
+	 */
+	if (WARN_ON(ret > 1 && on))
+		return;
+
+	if (ret > 0)
+		enable_fiq(kgdb_fiq);
+	else
+		disable_fiq(kgdb_fiq);
+#endif
+}
+
+
 /*
  * Register our undef instruction hooks with ARM undef core.
  * We regsiter a hook specifically looking for the KGB break inst
@@ -252,8 +302,61 @@ void kgdb_arch_exit(void)
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
+static int kgdb_handle_fiq(struct notifier_block *nb, unsigned long arg,
+			   void *data)
+{
+	struct pt_regs *regs = (void *) arg;
+	int actual;
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
+static struct notifier_block kgdb_fiq_notifier = {
+	.notifier_call = kgdb_handle_fiq,
+	.priority = 100,
+};
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
+	register_fiq_nmi_notifier(&kgdb_fiq_notifier);
+
+	return 0;
+}
+#endif
-- 
1.9.3

