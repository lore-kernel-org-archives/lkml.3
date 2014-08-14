Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbaHNLQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 07:16:10 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:57775 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbaHNLQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 07:16:06 -0400
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
        Nicolas Pitre <nico@linaro.org>
Subject: [RFC PATCH 2/3] arm: kgdb: Add support for IPI FIQ roundup
Date: Thu, 14 Aug 2014 12:15:50 +0100
Message-Id: <1408014951-24820-3-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408014951-24820-1-git-send-email-daniel.thompson@linaro.org>
References: <53EC9404.5010908@linaro.org>
 <1408014951-24820-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rounding up the other CPUs using FIQ improves debugger robustness.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/include/asm/kgdb.h |  1 +
 arch/arm/kernel/kgdb.c      | 20 ++++++++++++++++----
 arch/arm/kernel/kgdb_fiq.c  |  7 ++++++-
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/kgdb.h b/arch/arm/include/asm/kgdb.h
index 5de21f01..ceb466f 100644
--- a/arch/arm/include/asm/kgdb.h
+++ b/arch/arm/include/asm/kgdb.h
@@ -50,6 +50,7 @@ static inline void arch_kgdb_breakpoint(void)
 extern void kgdb_handle_bus_error(void);
 extern int kgdb_fault_expected;
 
+extern int kgdb_fiq_enabled;
 extern char kgdb_fiq_handler;
 extern char kgdb_fiq_handler_end;
 asmlinkage void __exception_irq_entry kgdb_fiq_do_handle(struct pt_regs *regs);
diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index a74b53c..e5c3ec0 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -175,14 +175,26 @@ static struct undef_hook kgdb_compiled_brkpt_hook = {
 
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
+#ifdef CONFIG_FIQ
+	struct cpumask mask;
+
+	if (kgdb_fiq_enabled) {
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
diff --git a/arch/arm/kernel/kgdb_fiq.c b/arch/arm/kernel/kgdb_fiq.c
index a894dde..f7a2c3d 100644
--- a/arch/arm/kernel/kgdb_fiq.c
+++ b/arch/arm/kernel/kgdb_fiq.c
@@ -24,7 +24,7 @@
 #include <asm/fiq.h>
 #include <asm/exception.h>
 
-static int kgdb_fiq_enabled;
+int kgdb_fiq_enabled;
 module_param_named(enable, kgdb_fiq_enabled, int, 0600);
 MODULE_PARM_DESC(enable, "set to 1 to enable FIQ KGDB");
 
@@ -40,6 +40,11 @@ asmlinkage void __exception_irq_entry kgdb_fiq_do_handle(struct pt_regs *regs)
 {
 	int actual;
 
+	if (!kgdb_nmicallback(raw_smp_processor_id(), regs)) {
+		handle_IPI_FIQ(regs);
+		return;
+	}
+
 	nmi_enter();
 	actual = ack_fiq(kgdb_fiq);
 	WARN_ON(actual != kgdb_fiq);
-- 
1.9.3

