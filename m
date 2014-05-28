Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaE1Enb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 00:43:31 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40240 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbaE1En3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 00:43:29 -0400
Subject: [PATCH 2/6] powerpc, powernv,
 CPU hotplug: Put offline CPUs in Fast-Sleep instead of Nap
To: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        svaidyan@in.ibm.com, paulus@samba.org,
        srivatsa.bhat@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 28 May 2014 10:08:56 +0530
Message-ID: <20140528043856.15676.35844.stgit@preeti.in.ibm.com>
In-Reply-To: <20140528043703.15676.58580.stgit@preeti.in.ibm.com>
References: <20140528043703.15676.58580.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052804-9332-0000-0000-000000EB1E0F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

The offline cpus are put to fast sleep if the idle state is discovered in the
device tree. This is to gain maximum powersavings in the offline state.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
[ Changelog added by <preeti@linux.vnet.ibm.com> ]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/include/asm/processor.h |    8 +++++
 arch/powerpc/kernel/idle.c           |   52 ++++++++++++++++++++++++++++++++++
 arch/powerpc/platforms/powernv/smp.c |   12 +++++++-
 3 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index d922e5c..c5256db 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -449,6 +449,14 @@ static inline unsigned long get_clean_sp(unsigned long sp, int is_32)
 #define IDLE_INST_NAP	0x00010000 /* nap instruction can be used */
 #define IDLE_INST_SLEEP	0x00020000 /* sleep instruction can be used */
 
+/* Flags to indicate which of the CPU idle states are available for use */
+
+#define IDLE_USE_NAP		(1UL << 0)
+#define IDLE_USE_SLEEP		(1UL << 1)
+
+extern unsigned int supported_cpuidle_states;
+extern unsigned int pnv_get_supported_cpuidle_states(void);
+
 extern unsigned long cpuidle_disable;
 enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_POWERSAVE_OFF};
 
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index d7216c9..e51d574 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -25,6 +25,7 @@
 #include <linux/cpu.h>
 #include <linux/sysctl.h>
 #include <linux/tick.h>
+#include <linux/of.h>
 
 #include <asm/processor.h>
 #include <asm/cputable.h>
@@ -32,6 +33,7 @@
 #include <asm/machdep.h>
 #include <asm/runlatch.h>
 #include <asm/smp.h>
+#include <asm/firmware.h>
 
 
 unsigned long cpuidle_disable = IDLE_NO_OVERRIDE;
@@ -79,6 +81,56 @@ void arch_cpu_idle(void)
 	ppc64_runlatch_on();
 }
 
+#ifdef CONFIG_PPC_POWERNV
+
+unsigned int supported_cpuidle_states = 0;
+
+unsigned int pnv_get_supported_cpuidle_states(void)
+{
+	return supported_cpuidle_states;
+}
+
+static int __init pnv_probe_idle_states(void)
+{
+	struct device_node *power_mgt;
+	struct property *prop;
+	int dt_idle_states;
+	u32 *flags;
+	int i;
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
+	prop = of_find_property(power_mgt, "ibm,cpu-idle-state-flags", NULL);
+	if (!prop) {
+		pr_warn("DT-PowerMgmt: missing ibm,cpu-idle-state-flags\n");
+		return 0;
+	}
+
+	dt_idle_states = prop->length / sizeof(u32);
+	flags = (u32 *) prop->value;
+
+	for (i = 0; i < dt_idle_states; i++) {
+		if (flags[i] & IDLE_INST_NAP)
+			supported_cpuidle_states |= IDLE_USE_NAP;
+
+		if (flags[i] & IDLE_INST_SLEEP)
+			supported_cpuidle_states |= IDLE_USE_SLEEP;
+	}
+
+	return 0;
+}
+
+__initcall(pnv_probe_idle_states);
+#endif
+
+
 int powersave_nap;
 
 #ifdef CONFIG_SYSCTL
diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
index bf5fcd4..fc83006 100644
--- a/arch/powerpc/platforms/powernv/smp.c
+++ b/arch/powerpc/platforms/powernv/smp.c
@@ -31,6 +31,7 @@
 #include <asm/xics.h>
 #include <asm/opal.h>
 #include <asm/runlatch.h>
+#include <asm/processor.h>
 
 #include "powernv.h"
 
@@ -142,6 +143,7 @@ static int pnv_smp_cpu_disable(void)
 static void pnv_smp_cpu_kill_self(void)
 {
 	unsigned int cpu;
+	unsigned long idle_states;
 
 	/* Standard hot unplug procedure */
 	local_irq_disable();
@@ -152,13 +154,21 @@ static void pnv_smp_cpu_kill_self(void)
 	generic_set_cpu_dead(cpu);
 	smp_wmb();
 
+	idle_states = pnv_get_supported_cpuidle_states();
+
 	/* We don't want to take decrementer interrupts while we are offline,
 	 * so clear LPCR:PECE1. We keep PECE2 enabled.
 	 */
 	mtspr(SPRN_LPCR, mfspr(SPRN_LPCR) & ~(u64)LPCR_PECE1);
 	while (!generic_check_cpu_restart(cpu)) {
 		ppc64_runlatch_off();
-		power7_nap();
+
+		/* If sleep is supported, go to sleep, instead of nap */
+		if (idle_states & IDLE_USE_SLEEP)
+			power7_sleep();
+		else
+			power7_nap();
+
 		ppc64_runlatch_on();
 		if (!generic_check_cpu_restart(cpu)) {
 			DBG("CPU%d Unexpected exit while offline !\n", cpu);

