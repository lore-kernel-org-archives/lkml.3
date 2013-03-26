Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934543Ab3CZOmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:42:18 -0400
Received: from smtp.citrix.com ([66.165.176.89]:17058 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933490Ab3CZOmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:42:15 -0400
X-IronPort-AV: E=Sophos;i="4.84,911,1355097600"; 
   d="scan'208";a="15626930"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <will.deacon@arm.com>, <arnd@arndb.de>, <marc.zyngier@arm.com>,
        <linux@arm.linux.org.uk>, <nico@linaro.org>
Subject: [PATCH v2 6/6] [RFC] arm: use PSCI if available
Date: Tue, 26 Mar 2013 14:41:15 +0000
Message-ID: <1364308875-26484-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1303261423530.4430@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1303261423530.4430@kaball.uk.xensource.com>
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


Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: will.deacon@arm.com
CC: arnd@arndb.de
CC: marc.zyngier@arm.com
CC: linux@arm.linux.org.uk
CC: nico@linaro.org
---
 arch/arm/include/asm/psci.h  |    1 +
 arch/arm/kernel/psci.c       |   42 +++++++++++++++++++++++++++---
 arch/arm/kernel/smp.c        |    7 ++++-
 arch/arm/mach-virt/Makefile  |    1 -
 arch/arm/mach-virt/platsmp.c |   58 ------------------------------------------
 arch/arm/mach-virt/virt.c    |    3 --
 6 files changed, 45 insertions(+), 67 deletions(-)
 delete mode 100644 arch/arm/mach-virt/platsmp.c

diff --git a/arch/arm/include/asm/psci.h b/arch/arm/include/asm/psci.h
index ce0dbe7..e64ea84 100644
--- a/arch/arm/include/asm/psci.h
+++ b/arch/arm/include/asm/psci.h
@@ -32,5 +32,6 @@ struct psci_operations {
 };
 
 extern struct psci_operations psci_ops;
+int psci_init(struct smp_operations *ops);
 
 #endif /* __ASM_ARM_PSCI_H */
diff --git a/arch/arm/kernel/psci.c b/arch/arm/kernel/psci.c
index 3653164..6f66d93 100644
--- a/arch/arm/kernel/psci.c
+++ b/arch/arm/kernel/psci.c
@@ -16,6 +16,7 @@
 #define pr_fmt(fmt) "psci: " fmt
 
 #include <linux/init.h>
+#include <linux/irqchip/arm-gic.h>
 #include <linux/of.h>
 
 #include <asm/compiler.h>
@@ -23,7 +24,9 @@
 #include <asm/opcodes-sec.h>
 #include <asm/opcodes-virt.h>
 #include <asm/psci.h>
+#include <asm/smp_plat.h>
 
+extern void secondary_startup(void);
 struct psci_operations psci_ops;
 
 static int (*invoke_psci_fn)(u32, u32, u32, u32);
@@ -153,20 +156,50 @@ static int psci_migrate(unsigned long cpuid)
 	return psci_to_linux_errno(err);
 }
 
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
+struct smp_operations __initdata psci_smp_ops = {
+	.smp_init_cpus		= psci_smp_init_cpus,
+	.smp_prepare_cpus	= psci_smp_prepare_cpus,
+	.smp_secondary_init	= psci_secondary_init,
+	.smp_boot_secondary	= psci_boot_secondary,
+};
+
 static const struct of_device_id psci_of_match[] __initconst = {
 	{ .compatible = "arm,psci",	},
 	{},
 };
 
-static int __init psci_init(void)
+int __init psci_init(struct smp_operations *ops)
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
 
@@ -203,9 +236,10 @@ static int __init psci_init(void)
 		psci_function_id[PSCI_FN_MIGRATE] = id;
 		psci_ops.migrate = psci_migrate;
 	}
+	*ops = psci_smp_ops;
+	rc = 0;
 
 out_put_node:
 	of_node_put(np);
-	return 0;
+	return rc;
 }
-early_initcall(psci_init);
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 31644f1..09eda3c 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -38,6 +38,7 @@
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/processor.h>
+#include <asm/psci.h>
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
 #include <asm/ptrace.h>
@@ -74,7 +75,11 @@ static struct smp_operations smp_ops;
 
 void __init smp_set_ops(struct smp_operations *ops)
 {
-	if (ops)
+	int rc = -ENODEV;
+#ifdef CONFIG_ARM_PSCI
+	rc = psci_init(&smp_ops);
+#endif
+	if (rc && ops)
 		smp_ops = *ops;
 };
 
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

