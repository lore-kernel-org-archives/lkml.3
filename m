Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbbAGQRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:17:22 -0500
Received: from service87.mimecast.com ([91.220.42.44]:33938 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbbAGQRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:17:21 -0500
From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: leo.yan@linaro.org, yexl@marvell.com, will.deacon@arm.com,
        mark.rultand@arm.com, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org,
        "Suzuki K. Poulose" <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 1/2] arm64: Consolidate hotplug notifier for instruction emulation
Date: Wed,  7 Jan 2015 16:16:44 +0000
Message-Id: <1420647405-3907-2-git-send-email-suzuki.poulose@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420647405-3907-1-git-send-email-suzuki.poulose@arm.com>
References: <1420647405-3907-1-git-send-email-suzuki.poulose@arm.com>
X-OriginalArrivalTime: 07 Jan 2015 16:17:17.0644 (UTC) FILETIME=[67F668C0:01D02A95]
X-MC-Unique: 115010716171901601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id t07GHP8m024508

From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>

As of now each insn_emulation has a cpu hotplug notifier that
enables/disables the CPU feature bit for the functionality. This
patch re-arranges the code, such that there is only one notifier
that runs through the list of registered emulation hooks and runs
their corresponding set_hw_mode.

We do nothing when a CPU is dying as we will set the appropriate bits
when it comes back online based on the state of the hooks.

Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/kernel/armv8_deprecated.c |   99 +++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 49 deletions(-)

diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
index c363671..9054447 100644
--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -46,7 +46,7 @@ struct insn_emulation_ops {
 	const char		*name;
 	enum legacy_insn_status	status;
 	struct undef_hook	*hooks;
-	int			(*set_hw_mode)(bool enable);
+	void			(*set_hw_mode)(void *enable);
 };
 
 struct insn_emulation {
@@ -85,6 +85,30 @@ static void remove_emulation_hooks(struct insn_emulation_ops *ops)
 	pr_notice("Removed %s emulation handler\n", ops->name);
 }
 
+/* Run set_hw_mode(action) on all active CPUs */
+static int run_all_cpu_set_hw_mode(struct insn_emulation *insn, bool action)
+{
+	if (!insn->ops->set_hw_mode)
+		return -EINVAL;
+	on_each_cpu(insn->ops->set_hw_mode, (void *)action, true);
+	return 0;
+}
+
+/* Run set_hw_mode for all insns on a starting CPU */
+static void run_all_insn_set_hw_mode(void)
+{
+	unsigned long flags;
+	struct insn_emulation *insn;
+
+	raw_spin_lock_irqsave(&insn_emulation_lock, flags);
+	list_for_each_entry(insn, &insn_emulation, node) {
+		bool hw_mode = (insn->current_mode == INSN_HW);
+		if (insn->ops->set_hw_mode)
+			insn->ops->set_hw_mode((void *)hw_mode);
+	}
+	raw_spin_unlock_irqrestore(&insn_emulation_lock, flags);
+}
+
 static int update_insn_emulation_mode(struct insn_emulation *insn,
 				       enum insn_emulation_mode prev)
 {
@@ -97,10 +121,8 @@ static int update_insn_emulation_mode(struct insn_emulation *insn,
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
 
@@ -111,10 +133,9 @@ static int update_insn_emulation_mode(struct insn_emulation *insn,
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
 
@@ -133,6 +154,8 @@ static void register_insn_emulation(struct insn_emulation_ops *ops)
 	switch (ops->status) {
 	case INSN_DEPRECATED:
 		insn->current_mode = INSN_EMULATE;
+		/* Disable the HW mode if it was turned on at early boot time */
+		run_all_cpu_set_hw_mode(insn, false);
 		insn->max = INSN_HW;
 		break;
 	case INSN_OBSOLETE:
@@ -453,7 +476,7 @@ ret:
 	return 0;
 }
 
-#define SCTLR_EL1_CP15BEN (1 << 5)
+#define SCTLR_EL1_CP15BEN 	(1 << 5)
 
 static inline void config_sctlr_el1(u32 clear, u32 set)
 {
@@ -465,48 +488,12 @@ static inline void config_sctlr_el1(u32 clear, u32 set)
 	asm volatile("msr sctlr_el1, %0" : : "r" (val));
 }
 
-static void enable_cp15_ben(void *info)
+static void cp15_barrier_set_hw_mode(void *enable)
 {
-	config_sctlr_el1(0, SCTLR_EL1_CP15BEN);
-}
-
-static void disable_cp15_ben(void *info)
-{
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
 }
 
 static struct undef_hook cp15_barrier_hooks[] = {
@@ -534,6 +521,19 @@ static struct insn_emulation_ops cp15_barrier_ops = {
 	.set_hw_mode = cp15_barrier_set_hw_mode,
 };
 
+static int insn_cpu_hotplug_notify(struct notifier_block *b,
+			      unsigned long action, void *hcpu)
+{
+	if ((action & ~CPU_TASKS_FROZEN) == CPU_STARTING)
+		run_all_insn_set_hw_mode();
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block insn_cpu_hotplug_notifier = {
+	.notifier_call = insn_cpu_hotplug_notify,
+};
+
 /*
  * Invoked as late_initcall, since not needed before init spawned.
  */
@@ -545,6 +545,7 @@ static int __init armv8_deprecated_init(void)
 	if (IS_ENABLED(CONFIG_CP15_BARRIER_EMULATION))
 		register_insn_emulation(&cp15_barrier_ops);
 
+	register_cpu_notifier(&insn_cpu_hotplug_notifier);
 	register_insn_emulation_sysctl(ctl_abi);
 
 	return 0;
-- 
1.7.9.5


