Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab3AXK5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:57:25 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:33863 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab3AXK5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:57:13 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 62/71] ARC: [Review] Multi-platform image #2: Board callback Infrastructure
Date: Thu, 24 Jan 2013 16:20:37 +0530
Message-ID: <1359024639-21915-24-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The orig platform code orgnaization was singleton design pattern - only
one platform (and board thereof) would build at a time.

Thus any platform/board specific code (e.g. irq init, early init ...)
expected by ARC common code was exported as well defined set of APIs,
with only ONE instance building ever.

Now with multiple-platform build requirement, that design of code no
longer holds - multiple board specific calls need to build at the same
time - so ARC common code can't use the API approach, it needs a
callback based design where each board registers it's specific set of
functions, and at runtime, depending on board detection, the callbacks
are used from the registry.

This commit adds all the infrastructure, where board specific callbacks
are specified as a "machine description".

All the hooks are placed in right spots, no board callbacks registered
yet (with MACHINE_STARt/END constructs) so the hooks will not run.

Next commit will actually convert the platform to this infrastructure.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arc/include/asm/mach_desc.h |   85 ++++++++++++++++++++++++++++++++++++++
 arch/arc/include/asm/prom.h      |    1 -
 arch/arc/kernel/devtree.c        |   47 +++++++++++++++++----
 arch/arc/kernel/irq.c            |    7 +++
 arch/arc/kernel/setup.c          |   28 +++++++++++-
 arch/arc/kernel/smp.c            |    3 +
 arch/arc/kernel/time.c           |    4 ++
 arch/arc/kernel/vmlinux.lds.S    |    6 +++
 8 files changed, 169 insertions(+), 12 deletions(-)
 create mode 100644 arch/arc/include/asm/mach_desc.h

diff --git a/arch/arc/include/asm/mach_desc.h b/arch/arc/include/asm/mach_desc.h
new file mode 100644
index 0000000..eaebaf8
--- /dev/null
+++ b/arch/arc/include/asm/mach_desc.h
@@ -0,0 +1,85 @@
+/*
+ * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * based on METAG mach/arch.h (which in turn was based on ARM)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_MACH_DESC_H_
+#define _ASM_ARC_MACH_DESC_H_
+
+/**
+ * struct machine_desc - Board specific callbacks, called from ARC common code
+ *	Provided by each ARC board using MACHINE_START()/MACHINE_END(), so
+ *	a multi-platform kernel builds with array of such descriptors.
+ *	We extend the early DT scan to also match the DT's "compatible" string
+ *	against the @dt_compat of all such descriptors, and one with highest
+ *	"DT score" is selected as global @machine_desc.
+ *
+ * @name:		Board/SoC name
+ * @dt_compat:		Array of device tree 'compatible' strings
+ * 			(XXX: although only 1st entry is looked at)
+ * @init_early:		Very early callback [called from setup_arch()]
+ * @init_irq:		setup external IRQ controllers [called from init_IRQ()]
+ * @init_smp:		for each CPU (e.g. setup IPI)
+ * 			[(M):init_IRQ(), (o):start_kernel_secondary()]
+ * @init_time:		platform specific clocksource/clockevent registration
+ * 			[called from time_init()]
+ * @init_machine:	arch initcall level callback (e.g. populate static
+ * 			platform devices or parse Devicetree)
+ * @init_late:		Late initcall level callback
+ *
+ */
+struct machine_desc {
+	const char		*name;
+	const char		**dt_compat;
+
+	void			(*init_early)(void);
+	void			(*init_irq)(void);
+#ifdef CONFIG_SMP
+	void			(*init_smp)(unsigned int);
+#endif
+	void			(*init_time)(void);
+	void			(*init_machine)(void);
+	void			(*init_late)(void);
+
+};
+
+/*
+ * Current machine - only accessible during boot.
+ */
+extern struct machine_desc *machine_desc;
+
+/*
+ * Machine type table - also only accessible during boot
+ */
+extern struct machine_desc __arch_info_begin[], __arch_info_end[];
+#define for_each_machine_desc(p)			\
+	for (p = __arch_info_begin; p < __arch_info_end; p++)
+
+static inline struct machine_desc *default_machine_desc(void)
+{
+	/* the default machine is the last one linked in */
+	if (__arch_info_end - 1 < __arch_info_begin)
+		return NULL;
+	return __arch_info_end - 1;
+}
+
+/*
+ * Set of macros to define architecture features.
+ * This is built into a table by the linker.
+ */
+#define MACHINE_START(_type, _name)			\
+static const struct machine_desc __mach_desc_##_type	\
+__used							\
+__attribute__((__section__(".arch.info.init"))) = {	\
+	.name		= _name,
+
+#define MACHINE_END				\
+};
+
+extern struct machine_desc *setup_machine_fdt(void *dt);
+#endif
diff --git a/arch/arc/include/asm/prom.h b/arch/arc/include/asm/prom.h
index f54489b..692d0d0 100644
--- a/arch/arc/include/asm/prom.h
+++ b/arch/arc/include/asm/prom.h
@@ -10,6 +10,5 @@
 #define _ASM_ARC_PROM_H_
 
 #define HAVE_ARCH_DEVTREE_FIXUPS
-extern int __init setup_machine_fdt(void *dt);
 
 #endif
diff --git a/arch/arc/kernel/devtree.c b/arch/arc/kernel/devtree.c
index d2a41be..051ec8b 100644
--- a/arch/arc/kernel/devtree.c
+++ b/arch/arc/kernel/devtree.c
@@ -21,6 +21,7 @@
 #include <linux/of_platform.h>
 #include <asm/prom.h>
 #include <asm/clk.h>
+#include <asm/mach_desc.h>
 
 /* called from unflatten_device_tree() to bootstrap devicetree itself */
 void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
@@ -35,27 +36,57 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
  * If a dtb was passed to the kernel, then use it to choose the correct
  * machine_desc and to setup the system.
  */
-int __init setup_machine_fdt(void *dt)
+struct machine_desc * __init setup_machine_fdt(void *dt)
 {
 	struct boot_param_header *devtree = dt;
+	struct machine_desc *mdesc = NULL, *mdesc_best = NULL;
+	unsigned int score, mdesc_score = ~1;
 	unsigned long dt_root;
-	char *model, *compat;
+	const char *model, *compat;
 	void *clk;
 	char manufacturer[16];
 	unsigned long len;
 
 	/* check device tree validity */
 	if (be32_to_cpu(devtree->magic) != OF_DT_HEADER)
-		return 1;
+		return NULL;
 
-	/* Search the mdescs for the 'best' compatible value match */
 	initial_boot_params = devtree;
 	dt_root = of_get_flat_dt_root();
 
+	/*
+	 * The kernel could be multi-platform enabled, thus could have many
+	 * "baked-in" machine descriptors. Search thru all for the best
+	 * "compatible" string match.
+	 */
+	for_each_machine_desc(mdesc) {
+		score = of_flat_dt_match(dt_root, mdesc->dt_compat);
+		if (score > 0 && score < mdesc_score) {
+			mdesc_best = mdesc;
+			mdesc_score = score;
+		}
+	}
+	if (!mdesc_best) {
+		const char *prop;
+		long size;
+
+		pr_err("\n unrecognized device tree list:\n[ ");
+
+		prop = of_get_flat_dt_prop(dt_root, "compatible", &size);
+		if (prop) {
+			while (size > 0) {
+				printk("'%s' ", prop);
+				size -= strlen(prop) + 1;
+				prop += strlen(prop) + 1;
+			}
+		}
+		printk("]\n\n");
+
+		machine_halt();
+	}
+
 	/* compat = "<manufacturer>,<model>" */
-	compat = of_get_flat_dt_prop(dt_root, "compatible", NULL);
-	if (!compat)
-		compat = "<unknown>";
+	compat =  mdesc_best->dt_compat[0];
 
 	model = strchr(compat, ',');
 	if (model)
@@ -78,5 +109,5 @@ int __init setup_machine_fdt(void *dt)
 	if (clk)
 		arc_set_core_freq(of_read_ulong(clk, len/4));
 
-	return 0;
+	return mdesc_best;
 }
diff --git a/arch/arc/kernel/irq.c b/arch/arc/kernel/irq.c
index df7da2b..1198168 100644
--- a/arch/arc/kernel/irq.c
+++ b/arch/arc/kernel/irq.c
@@ -13,6 +13,7 @@
 #include <linux/irqdomain.h>
 #include <asm/sections.h>
 #include <asm/irq.h>
+#include <asm/mach_desc.h>
 
 /*
  * Early Hardware specific Interrupt setup
@@ -125,9 +126,15 @@ void __init init_IRQ(void)
 	init_onchip_IRQ();
 	plat_init_IRQ();
 
+	/* Any external intc can be setup here */
+	if (machine_desc->init_irq)
+		machine_desc->init_irq();
+
 #ifdef CONFIG_SMP
 	/* Master CPU can initialize it's side of IPI */
 	arc_platform_smp_init_cpu();
+	if (machine_desc->init_smp)
+		machine_desc->init_smp(smp_processor_id());
 #endif
 }
 
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index 6cc361c..20273b8 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -25,12 +25,14 @@
 #include <asm/prom.h>
 #include <asm/unwind.h>
 #include <asm/clk.h>
+#include <asm/mach_desc.h>
 
 #define FIX_PTR(x)  __asm__ __volatile__(";" : "+r"(x))
 
 int running_on_hw = 1;	/* vs. on ISS */
 
 char __initdata command_line[COMMAND_LINE_SIZE];
+struct machine_desc *machine_desc __initdata;
 
 struct task_struct *_current_task[NR_CPUS];	/* For stack switching */
 
@@ -323,8 +325,6 @@ void __init __attribute__((weak)) arc_platform_early_init(void)
 
 void __init setup_arch(char **cmdline_p)
 {
-	int rc;
-
 #ifdef CONFIG_CMDLINE_UBOOT
 	/* Make sure that a whitespace is inserted before */
 	strlcat(command_line, " ", sizeof(command_line));
@@ -339,13 +339,17 @@ void __init setup_arch(char **cmdline_p)
 	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
-	rc = setup_machine_fdt(__dtb_start);
+	machine_desc = setup_machine_fdt(__dtb_start);
+	if (!machine_desc)
+		panic("Embedded DT invalid\n");
 
 	/* To force early parsing of things like mem=xxx */
 	parse_early_param();
 
 	/* Platform/board specific: e.g. early console registration */
 	arc_platform_early_init();
+	if (machine_desc->init_early)
+		machine_desc->init_early();
 
 	setup_processor();
 
@@ -372,6 +376,24 @@ void __init setup_arch(char **cmdline_p)
 	arc_unwind_setup();
 }
 
+static int __init customize_machine(void)
+{
+	/* Add platform devices */
+	if (machine_desc->init_machine)
+		machine_desc->init_machine();
+
+	return 0;
+}
+arch_initcall(customize_machine);
+
+static int __init init_late_machine(void)
+{
+	if (machine_desc->init_late)
+		machine_desc->init_late();
+
+	return 0;
+}
+late_initcall(init_late_machine);
 /*
  *  Get CPU information for use by the procfs.
  */
diff --git a/arch/arc/kernel/smp.c b/arch/arc/kernel/smp.c
index 1f762ad..ea15f07 100644
--- a/arch/arc/kernel/smp.c
+++ b/arch/arc/kernel/smp.c
@@ -32,6 +32,7 @@
 #include <linux/reboot.h>
 #include <asm/processor.h>
 #include <asm/setup.h>
+#include <asm/mach_desc.h>
 
 arch_spinlock_t smp_atomic_ops_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 arch_spinlock_t smp_bitops_lock = __ARCH_SPIN_LOCK_UNLOCKED;
@@ -127,6 +128,8 @@ void __cpuinit start_kernel_secondary(void)
 	pr_info("## CPU%u LIVE ##: Executing Code...\n", cpu);
 
 	arc_platform_smp_init_cpu();
+	if (machine_desc->init_smp)
+		machine_desc->init_smp(smp_processor_id());
 
 	arc_local_timer_setup(cpu);
 
diff --git a/arch/arc/kernel/time.c b/arch/arc/kernel/time.c
index 05dba11..0ce0e6f 100644
--- a/arch/arc/kernel/time.c
+++ b/arch/arc/kernel/time.c
@@ -43,6 +43,7 @@
 #include <asm/irq.h>
 #include <asm/arcregs.h>
 #include <asm/clk.h>
+#include <asm/mach_desc.h>
 
 #define ARC_TIMER_MAX	0xFFFFFFFF
 
@@ -258,6 +259,9 @@ void __init time_init(void)
 
 	/* sets up the periodic event timer */
 	arc_local_timer_setup(smp_processor_id());
+
+	if (machine_desc->init_time)
+		machine_desc->init_time();
 }
 
 #ifdef CONFIG_ARC_HAS_RTSC
diff --git a/arch/arc/kernel/vmlinux.lds.S b/arch/arc/kernel/vmlinux.lds.S
index 8d3b0d4..622d8b6 100644
--- a/arch/arc/kernel/vmlinux.lds.S
+++ b/arch/arc/kernel/vmlinux.lds.S
@@ -75,6 +75,12 @@ SECTIONS
 		SECURITY_INITCALL
 	}
 
+	.init.arch.info : {
+		__arch_info_begin = .;
+		*(.arch.info.init)
+		__arch_info_end = .;
+	}
+
 	PERCPU_SECTION(L1_CACHE_BYTES)
 
 	/*
-- 
1.7.4.1

