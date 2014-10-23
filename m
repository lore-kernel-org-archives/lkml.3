Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbaJWSQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:16:09 -0400
Received: from down.free-electrons.com ([37.187.137.238]:34373 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932139AbaJWSPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:15:07 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ARM: mvebu: Implement CPU hotplug support for Armada 38x
Date: Thu, 23 Oct 2014 20:14:30 +0200
Message-Id: <1414088070-12510-5-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414088070-12510-1-git-send-email-gregory.clement@free-electrons.com>
References: <1414088070-12510-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit implements CPU hotplug support for the Marvell Armada 38x
platform. Similarly to what was done for the Armada XP, this commit:

 * Implements the ->cpu_die() function of SMP operations by calling
   armada_38x_do_cpu_suspend() to enter the deep idle state for
   CPUs going offline.

 * Implements a dummy ->cpu_kill() function, simply needed for the
   kernel to know we have CPU hotplug support.

 * The mvebu_cortex_a9_boot_secondary() function makes sure to wake up
   the CPU if waiting in deep idle state by sending an IPI before
   deasserting the CPUs from reset. This is because
   mvebu_cortex_a9_boot_secondary() is now used in two different
   situations: for the initial boot of secondary CPUs (where CPU reset
   deassert is used to wake up CPUs) and for CPU hotplug (where an IPI
   is used to take CPU out of deep idle).

 * At boot time, we exit from the idle state in the
    ->smp_secondary_init() hook.

This commit has been tested using CPU hotplug through sysfs
(/sys/devices/system/cpu/cpuX/online) and using kexec.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/mach-mvebu/platsmp-a9.c | 53 ++++++++++++++++++++++++++++++++++++++--
 arch/arm/mach-mvebu/pmsu.c       |  2 +-
 arch/arm/mach-mvebu/pmsu.h       |  1 +
 3 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-mvebu/platsmp-a9.c b/arch/arm/mach-mvebu/platsmp-a9.c
index 47a71a924b96..2ec1a42b4321 100644
--- a/arch/arm/mach-mvebu/platsmp-a9.c
+++ b/arch/arm/mach-mvebu/platsmp-a9.c
@@ -43,21 +43,70 @@ static int __cpuinit mvebu_cortex_a9_boot_secondary(unsigned int cpu,
 	else
 		mvebu_pmsu_set_cpu_boot_addr(hw_cpu, mvebu_cortex_a9_secondary_startup);
 	smp_wmb();
+
+	/*
+	 * Doing this before deasserting the CPUs is needed to wake up CPUs
+	 * in the offline state after using CPU hotplug.
+	 */
+	arch_send_wakeup_ipi_mask(cpumask_of(cpu));
+
 	ret = mvebu_cpu_reset_deassert(hw_cpu);
 	if (ret) {
 		pr_err("Could not start the secondary CPU: %d\n", ret);
 		return ret;
 	}
-	arch_send_wakeup_ipi_mask(cpumask_of(cpu));
 
 	return 0;
 }
+/*
+ * When a CPU is brought back online, either through CPU hotplug, or
+ * because of the boot of a kexec'ed kernel, the PMSU configuration
+ * for this CPU might be in the deep idle state, preventing this CPU
+ * from receiving interrupts. Here, we therefore take out the current
+ * CPU from this state, which was entered by armada_38x_cpu_die()
+ * below.
+ */
+static void armada_38x_secondary_init(unsigned int cpu)
+{
+	mvebu_v7_pmsu_idle_exit();
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+static void armada_38x_cpu_die(unsigned int cpu)
+{
+	/*
+	 * CPU hotplug is implemented by putting offline CPUs into the
+	 * deep idle sleep state.
+	 */
+	armada_38x_do_cpu_suspend(true);
+}
+
+/*
+ * We need a dummy function, so that platform_can_cpu_hotplug() knows
+ * we support CPU hotplug. However, the function does not need to do
+ * anything, because CPUs going offline can enter the deep idle state
+ * by themselves, without any help from a still alive CPU.
+ */
+static int armada_38x_cpu_kill(unsigned int cpu)
+{
+	return 1;
+}
+#endif
 
 static struct smp_operations mvebu_cortex_a9_smp_ops __initdata = {
 	.smp_boot_secondary	= mvebu_cortex_a9_boot_secondary,
 };
 
+static struct smp_operations armada_38x_smp_ops __initdata = {
+	.smp_boot_secondary	= mvebu_cortex_a9_boot_secondary,
+	.smp_secondary_init     = armada_38x_secondary_init,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_die		= armada_38x_cpu_die,
+	.cpu_kill               = armada_38x_cpu_kill,
+#endif
+};
+
 CPU_METHOD_OF_DECLARE(mvebu_armada_375_smp, "marvell,armada-375-smp",
 		      &mvebu_cortex_a9_smp_ops);
 CPU_METHOD_OF_DECLARE(mvebu_armada_380_smp, "marvell,armada-380-smp",
-		      &mvebu_cortex_a9_smp_ops);
+		      &armada_38x_smp_ops);
diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
index 5af58927a56d..5a757f929927 100644
--- a/arch/arm/mach-mvebu/pmsu.c
+++ b/arch/arm/mach-mvebu/pmsu.c
@@ -311,7 +311,7 @@ static int armada_370_xp_cpu_suspend(unsigned long deepidle)
 	return cpu_suspend(deepidle, armada_370_xp_pmsu_idle_enter);
 }
 
-static int armada_38x_do_cpu_suspend(unsigned long deepidle)
+int armada_38x_do_cpu_suspend(unsigned long deepidle)
 {
 	unsigned long flags = 0;
 
diff --git a/arch/arm/mach-mvebu/pmsu.h b/arch/arm/mach-mvebu/pmsu.h
index e1eb4959a2d4..c2c95db4f648 100644
--- a/arch/arm/mach-mvebu/pmsu.h
+++ b/arch/arm/mach-mvebu/pmsu.h
@@ -19,4 +19,5 @@ int mvebu_setup_boot_addr_wa(unsigned int crypto_eng_target,
 void mvebu_v7_pmsu_idle_exit(void);
 
 int armada_370_xp_pmsu_idle_enter(unsigned long deepidle);
+int armada_38x_do_cpu_suspend(unsigned long deepidle);
 #endif	/* __MACH_370_XP_PMSU_H */
-- 
1.9.1

