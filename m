Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaLDH3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 02:29:15 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49365 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbaLDH3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 02:29:11 -0500
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Preeti U. Murthy" <preeti@linux.vnet.ibm.com>,
        "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 2/4] powerpc/powernv: Enable Offline CPUs to enter deep idle states
Date: Thu,  4 Dec 2014 12:58:21 +0530
Message-Id: <1417678103-32571-3-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417678103-32571-1-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1417678103-32571-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120407-0029-0000-0000-0000014ED97B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Preeti U. Murthy" <preeti@linux.vnet.ibm.com>

The secondary threads should enter deep idle states so as to gain maximum
powersavings when the entire core is offline. To do so the offline path
must be made aware of the available deepest idle state. Hence probe the
device tree for the possible idle states in powernv core code and
expose the deepest idle state through flags.

Since the  device tree is probed by the cpuidle driver as well, move
the parameters required to discover the idle states into an appropriate
common place to both the driver and the powernv core code.

Another point is that fastsleep idle state may require workarounds in
the kernel to function properly. This workaround is introduced in the
subsequent patches. However neither the cpuidle driver or the hotplug
path need be bothered about this workaround.

They will be taken care of by the core powernv code.

Originally-by: Srivatsa S. Bhat <srivatsa@mit.edu>
Signed-off-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: linux-pm@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/include/asm/opal.h          |  8 ++++++
 arch/powerpc/platforms/powernv/powernv.h |  2 ++
 arch/powerpc/platforms/powernv/setup.c   | 49 ++++++++++++++++++++++++++++++++
 arch/powerpc/platforms/powernv/smp.c     |  7 ++++-
 drivers/cpuidle/cpuidle-powernv.c        |  9 ++----
 5 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/opal.h b/arch/powerpc/include/asm/opal.h
index 9124b0e..f8b95c0 100644
--- a/arch/powerpc/include/asm/opal.h
+++ b/arch/powerpc/include/asm/opal.h
@@ -155,6 +155,14 @@ struct opal_sg_list {
 #define OPAL_REGISTER_DUMP_REGION		101
 #define OPAL_UNREGISTER_DUMP_REGION		102
 
+/* Device tree flags */
+
+/* Flags set in power-mgmt nodes in device tree if
+ * respective idle states are supported in the platform.
+ */
+#define OPAL_PM_NAP_ENABLED	0x00010000
+#define OPAL_PM_SLEEP_ENABLED	0x00020000
+
 #ifndef __ASSEMBLY__
 
 #include <linux/notifier.h>
diff --git a/arch/powerpc/platforms/powernv/powernv.h b/arch/powerpc/platforms/powernv/powernv.h
index 6c8e2d1..604c48e 100644
--- a/arch/powerpc/platforms/powernv/powernv.h
+++ b/arch/powerpc/platforms/powernv/powernv.h
@@ -29,6 +29,8 @@ static inline u64 pnv_pci_dma_get_required_mask(struct pci_dev *pdev)
 }
 #endif
 
+extern u32 pnv_get_supported_cpuidle_states(void);
+
 extern void pnv_lpc_init(void);
 
 bool cpu_core_split_required(void);
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 3f9546d..34c6665 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -290,6 +290,55 @@ static void __init pnv_setup_machdep_rtas(void)
 }
 #endif /* CONFIG_PPC_POWERNV_RTAS */
 
+static u32 supported_cpuidle_states;
+
+u32 pnv_get_supported_cpuidle_states(void)
+{
+	return supported_cpuidle_states;
+}
+
+static int __init pnv_init_idle_states(void)
+{
+	struct device_node *power_mgt;
+	int dt_idle_states;
+	const __be32 *idle_state_flags;
+	u32 len_flags, flags;
+	int i;
+
+	supported_cpuidle_states = 0;
+
+	if (cpuidle_disable != IDLE_NO_OVERRIDE)
+		return 0;
+
+	if (!firmware_has_feature(FW_FEATURE_OPALv3))
+		return 0;
+
+	power_mgt = of_find_node_by_path("/ibm,opal/power-mgt");
+	if (!power_mgt) {
+		pr_warn("opal: PowerMgmt Node not found\n");
+		return 0;
+	}
+
+	idle_state_flags = of_get_property(power_mgt,
+			"ibm,cpu-idle-state-flags", &len_flags);
+	if (!idle_state_flags) {
+		pr_warn("DT-PowerMgmt: missing ibm,cpu-idle-state-flags\n");
+		return 0;
+	}
+
+	dt_idle_states = len_flags / sizeof(u32);
+
+	for (i = 0; i < dt_idle_states; i++) {
+		flags = be32_to_cpu(idle_state_flags[i]);
+		supported_cpuidle_states |= flags;
+	}
+
+	return 0;
+}
+
+subsys_initcall(pnv_init_idle_states);
+
+
 static int __init pnv_probe(void)
 {
 	unsigned long root = of_get_flat_dt_root();
diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
index 4753958..3dc4cec 100644
--- a/arch/powerpc/platforms/powernv/smp.c
+++ b/arch/powerpc/platforms/powernv/smp.c
@@ -149,6 +149,7 @@ static int pnv_smp_cpu_disable(void)
 static void pnv_smp_cpu_kill_self(void)
 {
 	unsigned int cpu;
+	u32 idle_states;
 
 	/* Standard hot unplug procedure */
 	local_irq_disable();
@@ -159,13 +160,17 @@ static void pnv_smp_cpu_kill_self(void)
 	generic_set_cpu_dead(cpu);
 	smp_wmb();
 
+	idle_states = pnv_get_supported_cpuidle_states();
 	/* We don't want to take decrementer interrupts while we are offline,
 	 * so clear LPCR:PECE1. We keep PECE2 enabled.
 	 */
 	mtspr(SPRN_LPCR, mfspr(SPRN_LPCR) & ~(u64)LPCR_PECE1);
 	while (!generic_check_cpu_restart(cpu)) {
 		ppc64_runlatch_off();
-		power7_nap(1);
+		if (idle_states & OPAL_PM_SLEEP_ENABLED)
+			power7_sleep();
+		else
+			power7_nap(1);
 		ppc64_runlatch_on();
 
 		/* Clear the IPI that woke us up */
diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
index 7d3a349..0a7d827 100644
--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -16,13 +16,10 @@
 
 #include <asm/machdep.h>
 #include <asm/firmware.h>
+#include <asm/opal.h>
 #include <asm/runlatch.h>
 
-/* Flags and constants used in PowerNV platform */
-
 #define MAX_POWERNV_IDLE_STATES	8
-#define IDLE_USE_INST_NAP	0x00010000 /* Use nap instruction */
-#define IDLE_USE_INST_SLEEP	0x00020000 /* Use sleep instruction */
 
 struct cpuidle_driver powernv_idle_driver = {
 	.name             = "powernv_idle",
@@ -198,7 +195,7 @@ static int powernv_add_idle_states(void)
 		 * target residency to be 10x exit_latency
 		 */
 		latency_ns = be32_to_cpu(idle_state_latency[i]);
-		if (flags & IDLE_USE_INST_NAP) {
+		if (flags & OPAL_PM_NAP_ENABLED) {
 			/* Add NAP state */
 			strcpy(powernv_states[nr_idle_states].name, "Nap");
 			strcpy(powernv_states[nr_idle_states].desc, "Nap");
@@ -211,7 +208,7 @@ static int powernv_add_idle_states(void)
 			nr_idle_states++;
 		}
 
-		if (flags & IDLE_USE_INST_SLEEP) {
+		if (flags & OPAL_PM_SLEEP_ENABLED) {
 			/* Add FASTSLEEP state */
 			strcpy(powernv_states[nr_idle_states].name, "FastSleep");
 			strcpy(powernv_states[nr_idle_states].desc, "FastSleep");
-- 
1.9.3

