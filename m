Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbbAOMgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:36:19 -0500
Received: from service87.mimecast.com ([91.220.42.44]:35577 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbbAOMgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:36:16 -0500
From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: leo.yan@linaro.org, yexl@marvell.com, Will.Deacon@arm.com,
        Catalin.Marinas@arm.com, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org,
        "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Subject: [PATCH 2/3] arm64: Consolidate hotplug notifier for instruction emulation
Date: Thu, 15 Jan 2015 12:36:05 +0000
Message-Id: <1421325366-13263-3-git-send-email-suzuki.poulose@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421325366-13263-1-git-send-email-suzuki.poulose@arm.com>
References: <1421325366-13263-1-git-send-email-suzuki.poulose@arm.com>
X-OriginalArrivalTime: 15 Jan 2015 12:36:14.0342 (UTC) FILETIME=[D9B92260:01D030BF]
X-MC-Unique: 115011512361502301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id t0FCaNPC014009

From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>

As of now each insn_emulation has a cpu hotplug notifier that
enables/disables the CPU feature bit for the functionality. This
patch re-arranges the code, such that there is only one notifier
that runs through the list of registered emulation hooks and runs
their corresponding set_hw_mode.

We do nothing when a CPU is dying as we will set the appropriate bits
as it comes back online based on the state of the hooks.

Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 Documentation/arm64/legacy_instructions.txt |    4 +
 arch/arm64/include/asm/cpufeature.h         |    2 +
 arch/arm64/kernel/armv8_deprecated.c        |  113 +++++++++++++++------------
 3 files changed, 69 insertions(+), 50 deletions(-)

diff --git a/Documentation/arm64/legacy_instructions.txt b/Documentation/arm64/legacy_instructions.txt
index a3b3da2..0a4dc26 100644
--- a/Documentation/arm64/legacy_instructions.txt
+++ b/Documentation/arm64/legacy_instructions.txt
@@ -27,6 +27,10 @@ behaviours and the corresponding values of the sysctl nodes -
   instructions. Using hardware execution generally provides better
   performance, but at the loss of ability to gather runtime statistics
   about the use of the deprecated instructions.
+  Note: Emulation of a deprecated instruction depends on the availability
+  of the feature on all the active CPUs. In case of CPU hotplug, if a new
+  CPU doesn't support a feature, it could result in the abortion of the
+  hotplug operation.
 
 The default mode depends on the status of the instruction in the
 architecture. Deprecated instructions should default to emulation
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index c7f68d1..a56b45f 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -29,6 +29,8 @@
 #define ID_AA64MMFR0_EL1_BigEndEL0	(0x1UL << 16)
 #define ID_AA64MMFR0_EL1_BigEnd		(0x1UL << 8)
 
+#define SCTLR_EL1_CP15BEN 	(1 << 5)
+
 #ifndef __ASSEMBLY__
 
 extern DECLARE_BITMAP(cpu_hwcaps, ARM64_NCAPS);
diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
index c363671..be64218 100644
--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -19,6 +19,7 @@
 #include <asm/system_misc.h>
 #include <asm/traps.h>
 #include <asm/uaccess.h>
+#include <asm/cpufeature.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace-events-emulation.h"
@@ -46,7 +47,7 @@ struct insn_emulation_ops {
 	const char		*name;
 	enum legacy_insn_status	status;
 	struct undef_hook	*hooks;
-	int			(*set_hw_mode)(bool enable);
+	int			(*set_hw_mode)(void *enable);
 };
 
 struct insn_emulation {
@@ -85,6 +86,40 @@ static void remove_emulation_hooks(struct insn_emulation_ops *ops)
 	pr_notice("Removed %s emulation handler\n", ops->name);
 }
 
+/* Run set_hw_mode(mode) on all active CPUs */
+static int run_all_cpu_set_hw_mode(struct insn_emulation *insn, bool enable)
+{
+	void (*set_hw_mode)(void *) = (void (*) (void *))insn->ops->set_hw_mode;
+	if (!set_hw_mode)
+		return -EINVAL;
+	on_each_cpu(set_hw_mode, (void *)enable, true);
+	return 0;
+}
+
+/*
+ * Run set_hw_mode for all insns on a starting CPU.
+ * Returns:
+ *  0 		- If all the hooks ran successfully.
+ * -EINVAL	- At least one hook is not supported by the CPU.
+ *		  abort the hotplug.
+ */
+static int run_all_insn_set_hw_mode(void)
+{
+	int rc = 0;
+	unsigned long flags;
+	struct insn_emulation *insn;
+
+	raw_spin_lock_irqsave(&insn_emulation_lock, flags);
+	list_for_each_entry(insn, &insn_emulation, node) {
+		bool hw_mode = (insn->current_mode == INSN_HW);
+		if (insn->ops->set_hw_mode &&
+			insn->ops->set_hw_mode((void*)hw_mode))
+			rc = -EINVAL;
+	}
+	raw_spin_unlock_irqrestore(&insn_emulation_lock, flags);
+	return rc;
+}
+
 static int update_insn_emulation_mode(struct insn_emulation *insn,
 				       enum insn_emulation_mode prev)
 {
@@ -97,10 +132,8 @@ static int update_insn_emulation_mode(struct insn_emulation *insn,
 		remove_emulation_hooks(insn->ops);
 		break;
 	case INSN_HW:
-		if (insn->ops->set_hw_mode) {
-			insn->ops->set_hw_mode(false);
+		if (!run_all_cpu_set_hw_mode(insn, false))
 			pr_notice("Disabled %s support\n", insn->ops->name);
-		}
 		break;
 	}
 
@@ -111,10 +144,9 @@ static int update_insn_emulation_mode(struct insn_emulation *insn,
 		register_emulation_hooks(insn->ops);
 		break;
 	case INSN_HW:
-		if (insn->ops->set_hw_mode && insn->ops->set_hw_mode(true))
+		ret = run_all_cpu_set_hw_mode(insn, true);
+		if (!ret)
 			pr_notice("Enabled %s support\n", insn->ops->name);
-		else
-			ret = -EINVAL;
 		break;
 	}
 
@@ -133,6 +165,8 @@ static void register_insn_emulation(struct insn_emulation_ops *ops)
 	switch (ops->status) {
 	case INSN_DEPRECATED:
 		insn->current_mode = INSN_EMULATE;
+		/* Disable the HW mode if it was turned on at early boot time */
+		run_all_cpu_set_hw_mode(insn, false);
 		insn->max = INSN_HW;
 		break;
 	case INSN_OBSOLETE:
@@ -453,8 +487,6 @@ ret:
 	return 0;
 }
 
-#define SCTLR_EL1_CP15BEN (1 << 5)
-
 static inline void config_sctlr_el1(u32 clear, u32 set)
 {
 	u32 val;
@@ -465,48 +497,13 @@ static inline void config_sctlr_el1(u32 clear, u32 set)
 	asm volatile("msr sctlr_el1, %0" : : "r" (val));
 }
 
-static void enable_cp15_ben(void *info)
-{
-	config_sctlr_el1(0, SCTLR_EL1_CP15BEN);
-}
-
-static void disable_cp15_ben(void *info)
+static int cp15_barrier_set_hw_mode(void *enable)
 {
-	config_sctlr_el1(SCTLR_EL1_CP15BEN, 0);
-}
-
-static int cpu_hotplug_notify(struct notifier_block *b,
-			      unsigned long action, void *hcpu)
-{
-	switch (action) {
-	case CPU_STARTING:
-	case CPU_STARTING_FROZEN:
-		enable_cp15_ben(NULL);
-		return NOTIFY_DONE;
-	case CPU_DYING:
-	case CPU_DYING_FROZEN:
-		disable_cp15_ben(NULL);
-		return NOTIFY_DONE;
-	}
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block cpu_hotplug_notifier = {
-	.notifier_call = cpu_hotplug_notify,
-};
-
-static int cp15_barrier_set_hw_mode(bool enable)
-{
-	if (enable) {
-		register_cpu_notifier(&cpu_hotplug_notifier);
-		on_each_cpu(enable_cp15_ben, NULL, true);
-	} else {
-		unregister_cpu_notifier(&cpu_hotplug_notifier);
-		on_each_cpu(disable_cp15_ben, NULL, true);
-	}
-
-	return true;
+	if (enable)
+		config_sctlr_el1(0, SCTLR_EL1_CP15BEN);
+	else
+		config_sctlr_el1(SCTLR_EL1_CP15BEN, 0);
+	return 0;
 }
 
 static struct undef_hook cp15_barrier_hooks[] = {
@@ -534,6 +531,21 @@ static struct insn_emulation_ops cp15_barrier_ops = {
 	.set_hw_mode = cp15_barrier_set_hw_mode,
 };
 
+static int insn_cpu_hotplug_notify(struct notifier_block *b,
+			      unsigned long action, void *hcpu)
+{
+	int rc = 0;
+	if ((action & ~CPU_TASKS_FROZEN) == CPU_STARTING)
+		rc = run_all_insn_set_hw_mode();
+
+	/* Abort the CPU hotplug if there is an incompatibility */
+	return notifier_from_errno(rc);
+}
+
+static struct notifier_block insn_cpu_hotplug_notifier = {
+	.notifier_call = insn_cpu_hotplug_notify,
+};
+
 /*
  * Invoked as late_initcall, since not needed before init spawned.
  */
@@ -545,6 +557,7 @@ static int __init armv8_deprecated_init(void)
 	if (IS_ENABLED(CONFIG_CP15_BARRIER_EMULATION))
 		register_insn_emulation(&cp15_barrier_ops);
 
+	register_cpu_notifier(&insn_cpu_hotplug_notifier);
 	register_insn_emulation_sysctl(ctl_abi);
 
 	return 0;
-- 
1.7.9.5


