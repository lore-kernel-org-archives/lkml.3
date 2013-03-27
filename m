Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3C0Muw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:50:52 -0400
Received: from smtp.citrix.com ([66.165.176.89]:61256 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab3C0Muv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:50:51 -0400
X-IronPort-AV: E=Sophos;i="4.84,919,1355097600"; 
   d="scan'208";a="15851339"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <arnd@arndb.de>,
        <will.deacon@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <marc.zyngier@arm.com>, <linux@arm.linux.org.uk>, <nico@linaro.org>
Subject: [PATCH v3] [RFC] arm: use PSCI if available
Date: Wed, 27 Mar 2013 12:50:39 +0000
Message-ID: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for the presence of PSCI before setting smp_ops, use PSCI if it is
available.

This is useful because at least when running on Xen it's possible to have a
PSCI node for example on a Versatile Express or an Exynos5 machine. In these
cases the PSCI SMP calls should be the ones to be called.

Remove virt_smp_ops and platsmp.c from mach-virt because they aren't needed
anymore.



This patch was originally part of this series:

http://marc.info/?l=linux-arm-kernel&m=136430903110734&w=2

I am keeping it separate now since it is the only non-obvious change and
it is not Xen related.




Changes in v3:
- move the call to psci_init to setup_arch;
- export psci_smp_ops from psci.h;
- introduce psci_smp_available;
- introduce stub functions for psci_init and psci_smp_available ifndef
CONFIG_ARM_PSCI;
- only compile psci_smp functions ifdef CONFIG_SMP.


Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: will.deacon@arm.com
CC: arnd@arndb.de
CC: marc.zyngier@arm.com
CC: linux@arm.linux.org.uk
CC: nico@linaro.org
---
 arch/arm/include/asm/psci.h  |    9 ++++
 arch/arm/kernel/psci.c       |   97 ++++++++++++++++++++++++++++++++++--------
 arch/arm/kernel/setup.c      |    7 +++-
 arch/arm/mach-virt/Makefile  |    1 -
 arch/arm/mach-virt/platsmp.c |   58 -------------------------
 arch/arm/mach-virt/virt.c    |    3 -
 6 files changed, 94 insertions(+), 81 deletions(-)
 delete mode 100644 arch/arm/mach-virt/platsmp.c

diff --git a/arch/arm/include/asm/psci.h b/arch/arm/include/asm/psci.h
index ce0dbe7..ddef231 100644
--- a/arch/arm/include/asm/psci.h
+++ b/arch/arm/include/asm/psci.h
@@ -32,5 +32,14 @@ struct psci_operations {
 };
 
 extern struct psci_operations psci_ops;
+extern struct smp_operations psci_smp_ops;
+
+#ifdef CONFIG_ARM_PSCI
+int psci_init(void);
+bool psci_smp_available(void);
+#else
+static inline int psci_init(void) { return -ENODEV; }
+static inline bool psci_smp_available(void) { return false; }
+#endif
 
 #endif /* __ASM_ARM_PSCI_H */
diff --git a/arch/arm/kernel/psci.c b/arch/arm/kernel/psci.c
index 3653164..90f0839 100644
--- a/arch/arm/kernel/psci.c
+++ b/arch/arm/kernel/psci.c
@@ -16,6 +16,7 @@
 #define pr_fmt(fmt) "psci: " fmt
 
 #include <linux/init.h>
+#include <linux/irqchip/arm-gic.h>
 #include <linux/of.h>
 
 #include <asm/compiler.h>
@@ -23,8 +24,9 @@
 #include <asm/opcodes-sec.h>
 #include <asm/opcodes-virt.h>
 #include <asm/psci.h>
+#include <asm/smp_plat.h>
 
-struct psci_operations psci_ops;
+extern void secondary_startup(void);
 
 static int (*invoke_psci_fn)(u32, u32, u32, u32);
 
@@ -36,7 +38,11 @@ enum psci_function {
 	PSCI_FN_MAX,
 };
 
-static u32 psci_function_id[PSCI_FN_MAX];
+struct psci_function_desc {
+	enum psci_function func;
+	bool valid;
+};
+static struct psci_function_desc psci_function_id[PSCI_FN_MAX];
 
 #define PSCI_RET_SUCCESS		0
 #define PSCI_RET_EOPNOTSUPP		-1
@@ -116,7 +122,10 @@ static int psci_cpu_suspend(struct psci_power_state state,
 	int err;
 	u32 fn, power_state;
 
-	fn = psci_function_id[PSCI_FN_CPU_SUSPEND];
+	if (!psci_function_id[PSCI_FN_CPU_SUSPEND].valid)
+		return -ENOSYS;
+
+	fn = psci_function_id[PSCI_FN_CPU_SUSPEND].func;
 	power_state = psci_power_state_pack(state);
 	err = invoke_psci_fn(fn, power_state, entry_point, 0);
 	return psci_to_linux_errno(err);
@@ -127,7 +136,10 @@ static int psci_cpu_off(struct psci_power_state state)
 	int err;
 	u32 fn, power_state;
 
-	fn = psci_function_id[PSCI_FN_CPU_OFF];
+	if (!psci_function_id[PSCI_FN_CPU_OFF].valid)
+		return -ENOSYS;
+
+	fn = psci_function_id[PSCI_FN_CPU_OFF].func;
 	power_state = psci_power_state_pack(state);
 	err = invoke_psci_fn(fn, power_state, 0, 0);
 	return psci_to_linux_errno(err);
@@ -138,7 +150,10 @@ static int psci_cpu_on(unsigned long cpuid, unsigned long entry_point)
 	int err;
 	u32 fn;
 
-	fn = psci_function_id[PSCI_FN_CPU_ON];
+	if (!psci_function_id[PSCI_FN_CPU_ON].valid)
+		return -ENOSYS;
+
+	fn = psci_function_id[PSCI_FN_CPU_ON].func;
 	err = invoke_psci_fn(fn, cpuid, entry_point, 0);
 	return psci_to_linux_errno(err);
 }
@@ -148,25 +163,64 @@ static int psci_migrate(unsigned long cpuid)
 	int err;
 	u32 fn;
 
-	fn = psci_function_id[PSCI_FN_MIGRATE];
+	if (!psci_function_id[PSCI_FN_MIGRATE].valid)
+		return -ENOSYS;
+
+	fn = psci_function_id[PSCI_FN_MIGRATE].func;
 	err = invoke_psci_fn(fn, cpuid, 0, 0);
 	return psci_to_linux_errno(err);
 }
 
+struct psci_operations psci_ops = {
+	.cpu_suspend = psci_cpu_suspend,
+	.cpu_off     = psci_cpu_off,
+	.cpu_on      = psci_cpu_on,
+	.migrate     = psci_migrate,
+};
+
+#ifdef CONFIG_SMP
+static void __init psci_smp_init_cpus(void)
+{
+}
+
+static void __init psci_smp_prepare_cpus(unsigned int max_cpus)
+{
+}
+
+static int __cpuinit psci_boot_secondary(unsigned int cpu,
+					 struct task_struct *idle)
+{
+	return psci_cpu_on(cpu_logical_map(cpu), __pa(secondary_startup));
+}
+
+static void __cpuinit psci_secondary_init(unsigned int cpu)
+{
+	gic_secondary_init(0);
+}
+
+struct smp_operations __initdata psci_smp_ops = {
+	.smp_init_cpus		= psci_smp_init_cpus,
+	.smp_prepare_cpus	= psci_smp_prepare_cpus,
+	.smp_secondary_init	= psci_secondary_init,
+	.smp_boot_secondary	= psci_boot_secondary,
+};
+#endif
+
 static const struct of_device_id psci_of_match[] __initconst = {
 	{ .compatible = "arm,psci",	},
 	{},
 };
 
-static int __init psci_init(void)
+int __init psci_init(void)
 {
 	struct device_node *np;
 	const char *method;
 	u32 id;
+	int rc = -EINVAL;
 
 	np = of_find_matching_node(NULL, psci_of_match);
 	if (!np)
-		return 0;
+		return -ENODEV;
 
 	pr_info("probing function IDs from device-tree\n");
 
@@ -185,27 +239,34 @@ static int __init psci_init(void)
 	}
 
 	if (!of_property_read_u32(np, "cpu_suspend", &id)) {
-		psci_function_id[PSCI_FN_CPU_SUSPEND] = id;
-		psci_ops.cpu_suspend = psci_cpu_suspend;
+		psci_function_id[PSCI_FN_CPU_SUSPEND].func = id;
+		psci_function_id[PSCI_FN_CPU_SUSPEND].valid = true;
 	}
 
 	if (!of_property_read_u32(np, "cpu_off", &id)) {
-		psci_function_id[PSCI_FN_CPU_OFF] = id;
-		psci_ops.cpu_off = psci_cpu_off;
+		psci_function_id[PSCI_FN_CPU_OFF].func = id;
+		psci_function_id[PSCI_FN_CPU_OFF].valid = true;
 	}
 
 	if (!of_property_read_u32(np, "cpu_on", &id)) {
-		psci_function_id[PSCI_FN_CPU_ON] = id;
-		psci_ops.cpu_on = psci_cpu_on;
+		psci_function_id[PSCI_FN_CPU_ON].func = id;
+		psci_function_id[PSCI_FN_CPU_ON].valid = true;
 	}
 
 	if (!of_property_read_u32(np, "migrate", &id)) {
-		psci_function_id[PSCI_FN_MIGRATE] = id;
-		psci_ops.migrate = psci_migrate;
+		psci_function_id[PSCI_FN_MIGRATE].func = id;
+		psci_function_id[PSCI_FN_MIGRATE].valid = true;
 	}
 
+	rc = 0;
+
 out_put_node:
 	of_node_put(np);
-	return 0;
+	return rc;
+}
+
+bool __init psci_smp_available(void)
+{
+	/* is cpu_on available at least? */
+	return psci_function_id[PSCI_FN_CPU_ON].valid;
 }
-early_initcall(psci_init);
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3f6cbb2..c7e50dd 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -36,6 +36,7 @@
 #include <asm/cputype.h>
 #include <asm/elf.h>
 #include <asm/procinfo.h>
+#include <asm/psci.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/smp_plat.h>
@@ -766,9 +767,13 @@ void __init setup_arch(char **cmdline_p)
 	unflatten_device_tree();
 
 	arm_dt_init_cpu_maps();
+	psci_init();
 #ifdef CONFIG_SMP
 	if (is_smp()) {
-		smp_set_ops(mdesc->smp);
+		if (psci_smp_available())
+			smp_set_ops(&psci_smp_ops);
+		else
+			smp_set_ops(mdesc->smp);
 		smp_init_cpus();
 	}
 #endif
diff --git a/arch/arm/mach-virt/Makefile b/arch/arm/mach-virt/Makefile
index 042afc1..7ddbfa6 100644
--- a/arch/arm/mach-virt/Makefile
+++ b/arch/arm/mach-virt/Makefile
@@ -3,4 +3,3 @@
 #
 
 obj-y					:= virt.o
-obj-$(CONFIG_SMP)			+= platsmp.o
diff --git a/arch/arm/mach-virt/platsmp.c b/arch/arm/mach-virt/platsmp.c
deleted file mode 100644
index 8badaab..0000000
--- a/arch/arm/mach-virt/platsmp.c
+++ /dev/null
@@ -1,58 +0,0 @@
-/*
- * Dummy Virtual Machine - does what it says on the tin.
- *
- * Copyright (C) 2012 ARM Ltd
- * Author: Will Deacon <will.deacon@arm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <linux/init.h>
-#include <linux/smp.h>
-#include <linux/of.h>
-
-#include <linux/irqchip/arm-gic.h>
-
-#include <asm/psci.h>
-#include <asm/smp_plat.h>
-
-extern void secondary_startup(void);
-
-static void __init virt_smp_init_cpus(void)
-{
-}
-
-static void __init virt_smp_prepare_cpus(unsigned int max_cpus)
-{
-}
-
-static int __cpuinit virt_boot_secondary(unsigned int cpu,
-					 struct task_struct *idle)
-{
-	if (psci_ops.cpu_on)
-		return psci_ops.cpu_on(cpu_logical_map(cpu),
-				       __pa(secondary_startup));
-	return -ENODEV;
-}
-
-static void __cpuinit virt_secondary_init(unsigned int cpu)
-{
-	gic_secondary_init(0);
-}
-
-struct smp_operations __initdata virt_smp_ops = {
-	.smp_init_cpus		= virt_smp_init_cpus,
-	.smp_prepare_cpus	= virt_smp_prepare_cpus,
-	.smp_secondary_init	= virt_secondary_init,
-	.smp_boot_secondary	= virt_boot_secondary,
-};
diff --git a/arch/arm/mach-virt/virt.c b/arch/arm/mach-virt/virt.c
index 528c05e..c417752 100644
--- a/arch/arm/mach-virt/virt.c
+++ b/arch/arm/mach-virt/virt.c
@@ -44,12 +44,9 @@ static const char *virt_dt_match[] = {
 	NULL
 };
 
-extern struct smp_operations virt_smp_ops;
-
 DT_MACHINE_START(VIRT, "Dummy Virtual Machine")
 	.init_irq	= irqchip_init,
 	.init_time	= virt_timer_init,
 	.init_machine	= virt_init,
-	.smp		= smp_ops(virt_smp_ops),
 	.dt_compat	= virt_dt_match,
 MACHINE_END
-- 
1.7.2.5

