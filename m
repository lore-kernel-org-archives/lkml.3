Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3C2QnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:43:07 -0400
Received: from smtp.citrix.com ([66.165.176.89]:51862 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab3C2QnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:43:03 -0400
X-IronPort-AV: E=Sophos;i="4.87,373,1363132800"; 
   d="scan'208";a="16409688"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <will.deacon@arm.com>, <arnd@arndb.de>, <marc.zyngier@arm.com>,
        <linux@arm.linux.org.uk>, <nico@linaro.org>
Subject: [PATCH v4 1/2] arm: introduce psci_smp_ops
Date: Fri, 29 Mar 2013 16:42:49 +0000
Message-ID: <1364575371-8926-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename virt_smp_ops to psci_smp_ops and move them to arch/arm/kernel/psci_smp.c.
Remove mach-virt/platsmp.c, now unused.
Compile psci_smp if CONFIG_ARM_PSCI and CONFIG_SMP.

Add a cpu_die smp_op based on psci_ops.cpu_off.

Initialize PSCI before setting smp_ops in setup_arch.
Use psci_smp_ops if the platform doesn't provide its own smp_ops.


Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: will.deacon@arm.com
CC: arnd@arndb.de
CC: marc.zyngier@arm.com
CC: linux@arm.linux.org.uk
CC: nico@linaro.org
---
 arch/arm/include/asm/psci.h  |    9 +++++
 arch/arm/kernel/Makefile     |    5 ++-
 arch/arm/kernel/psci.c       |    3 +-
 arch/arm/kernel/psci_smp.c   |   67 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/setup.c      |    7 ++++-
 arch/arm/mach-virt/Makefile  |    1 -
 arch/arm/mach-virt/platsmp.c |   58 ------------------------------------
 arch/arm/mach-virt/virt.c    |    3 --
 8 files changed, 87 insertions(+), 66 deletions(-)
 create mode 100644 arch/arm/kernel/psci_smp.c
 delete mode 100644 arch/arm/mach-virt/platsmp.c

diff --git a/arch/arm/include/asm/psci.h b/arch/arm/include/asm/psci.h
index ce0dbe7..4134dda 100644
--- a/arch/arm/include/asm/psci.h
+++ b/arch/arm/include/asm/psci.h
@@ -32,5 +32,14 @@ struct psci_operations {
 };
 
 extern struct psci_operations psci_ops;
+extern struct smp_operations psci_smp_ops;
 
+#ifdef CONFIG_ARM_PSCI
+int psci_init(void);
+bool psci_smp_available(void);
+#else
+static inline int psci_init(void) { return -ENODEV; }
+static inline bool psci_smp_available(void) { return false; }
+#endif
+ 
 #endif /* __ASM_ARM_PSCI_H */
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 5f3338e..dd9d90a 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -82,6 +82,9 @@ obj-$(CONFIG_DEBUG_LL)	+= debug.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
 obj-$(CONFIG_ARM_VIRT_EXT)	+= hyp-stub.o
-obj-$(CONFIG_ARM_PSCI)		+= psci.o
+ifeq ($(CONFIG_ARM_PSCI),y)
+obj-y				+= psci.o
+obj-$(CONFIG_SMP)		+= psci_smp.o
+endif
 
 extra-y := $(head-y) vmlinux.lds
diff --git a/arch/arm/kernel/psci.c b/arch/arm/kernel/psci.c
index 3653164..acb968b 100644
--- a/arch/arm/kernel/psci.c
+++ b/arch/arm/kernel/psci.c
@@ -158,7 +158,7 @@ static const struct of_device_id psci_of_match[] __initconst = {
 	{},
 };
 
-static int __init psci_init(void)
+int __init psci_init(void)
 {
 	struct device_node *np;
 	const char *method;
@@ -208,4 +208,3 @@ out_put_node:
 	of_node_put(np);
 	return 0;
 }
-early_initcall(psci_init);
diff --git a/arch/arm/kernel/psci_smp.c b/arch/arm/kernel/psci_smp.c
new file mode 100644
index 0000000..66b0f77
--- /dev/null
+++ b/arch/arm/kernel/psci_smp.c
@@ -0,0 +1,67 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Copyright (C) 2012 ARM Limited
+ *
+ * Author: Will Deacon <will.deacon@arm.com>
+ */
+
+#include <linux/init.h>
+#include <linux/irqchip/arm-gic.h>
+#include <linux/smp.h>
+#include <linux/of.h>
+
+#include <asm/psci.h>
+#include <asm/smp_plat.h>
+
+extern void secondary_startup(void);
+
+static int __cpuinit psci_boot_secondary(unsigned int cpu,
+					 struct task_struct *idle)
+{
+	if (psci_ops.cpu_on)
+		return psci_ops.cpu_on(cpu_logical_map(cpu),
+				       __pa(secondary_startup));
+	return -ENODEV;
+}
+
+static void __cpuinit psci_secondary_init(unsigned int cpu)
+{
+	gic_secondary_init(0);
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+void __ref psci_cpu_die(unsigned int cpu)
+{
+       const struct psci_power_state ps = {
+               .type = PSCI_POWER_STATE_TYPE_POWER_DOWN,
+       };
+
+       if (psci_ops.cpu_off)
+               psci_ops.cpu_off(ps);
+
+       /* We should never return */
+       panic("psci: cpu %d failed to shutdown\n", cpu);
+}
+#else
+#define psci_cpu_die NULL
+#endif
+
+bool __init psci_smp_available(void)
+{
+	/* is cpu_on available at least? */
+	return (psci_ops.cpu_on != NULL);
+}
+
+struct smp_operations __initdata psci_smp_ops = {
+	.smp_secondary_init	= psci_secondary_init,
+	.smp_boot_secondary	= psci_boot_secondary,
+	.cpu_die		= psci_cpu_die,
+};
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3f6cbb2..341efaa 100644
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
+		if (mdesc->smp)
+			smp_set_ops(mdesc->smp);
+		else if (psci_smp_available())
+			smp_set_ops(&psci_smp_ops);
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

