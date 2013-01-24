Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab3AXKxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:53:36 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:47243 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab3AXKxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:53:16 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        <devicetree-discuss@lists.ozlabs.org>,
        "Rob Herring" <rob.herring@calxeda.com>
Subject: [PATCH v3 32/71] ARC: [DeviceTree] Basic support
Date: Thu, 24 Jan 2013 16:20:28 +0530
Message-ID: <1359024639-21915-15-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is minimal infrastructure needed for devicetree work.
It uses an a sample "skeleton" devicetree - embedded in kernel image -
to print the board, manufacturer by parsing the top-level "compatible"
string.

As of now we don't need any additional "board" specific "machine_desc".

TODO: support interpreting the command line as boot-loader passed dtb

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: Rob Herring <rob.herring@calxeda.com>
---
 arch/arc/Kconfig                |    9 +++++
 arch/arc/Makefile               |    9 +++++
 arch/arc/boot/dts/Makefile      |   14 ++++++++
 arch/arc/boot/dts/skeleton.dts  |   10 ++++++
 arch/arc/boot/dts/skeleton.dtsi |   21 ++++++++++++
 arch/arc/include/asm/prom.h     |   15 ++++++++
 arch/arc/include/asm/sections.h |    1 +
 arch/arc/kernel/Makefile        |    2 +
 arch/arc/kernel/devtree.c       |   69 +++++++++++++++++++++++++++++++++++++++
 arch/arc/kernel/setup.c         |    9 +++++
 arch/arc/mm/init.c              |   13 +++++++
 11 files changed, 172 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/boot/dts/Makefile
 create mode 100644 arch/arc/boot/dts/skeleton.dts
 create mode 100644 arch/arc/boot/dts/skeleton.dtsi
 create mode 100644 arch/arc/include/asm/prom.h
 create mode 100644 arch/arc/kernel/devtree.c

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index a353849..7666857 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -24,8 +24,11 @@ config ARC
 	select GENERIC_SMP_IDLE_THREAD
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_MEMBLOCK
+	select IRQ_DOMAIN
 	select MODULES_USE_ELF_RELA
 	select NO_BOOTMEM
+	select OF
+	select OF_EARLY_FLATTREE
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
@@ -320,6 +323,12 @@ config CMDLINE_UBOOT
 	  to it. kernel startup code will copy the string into cmdline buffer
 	  and also append CONFIG_CMDLINE.
 
+config ARC_BUILTIN_DTB_NAME
+	string "Built in DTB"
+	help
+	  Set the name of the DTB to embed in the vmlinux binary
+	  Leaving it blank selects the minimal "skeleton" dtb
+
 source "kernel/Kconfig.preempt"
 
 endmenu	 # "ARC Architecture Configuration"
diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index 4d52a3b..90570f9 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -83,6 +83,9 @@ head-y		:= arch/arc/kernel/head.o
 # See arch/arc/Kbuild for content of core part of the kernel
 core-y		+= arch/arc/
 
+# w/o this dtb won't embed into kernel binary
+core-y		+= arch/arc/boot/dts/
+
 # w/o this ifneq, make ARCH=arc clean was crapping out
 ifneq ($(platform-y),)
 core-y		+= arch/arc/plat-$(PLATFORM)/
@@ -101,6 +104,12 @@ bootpImage: vmlinux
 uImage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
 
+%.dtb %.dtb.S %.dtb.o:
+	$(Q)$(MAKE) $(build)=$(boot)/dts $(boot)/dts/$@
+
+dtbs:
+	$(Q)$(MAKE) $(build)=$(boot)/dts $(boot)/dts/$@
+
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 
diff --git a/arch/arc/boot/dts/Makefile b/arch/arc/boot/dts/Makefile
new file mode 100644
index 0000000..4a972a3
--- /dev/null
+++ b/arch/arc/boot/dts/Makefile
@@ -0,0 +1,14 @@
+ifeq ($(CONFIG_OF),y)
+
+# Built-in dtb
+builtindtb-y		:= skeleton
+
+ifneq ($(CONFIG_ARC_BUILTIN_DTB_NAME),"")
+	builtindtb-y	:= $(CONFIG_ARC_BUILTIN_DTB_NAME)
+endif
+
+obj-y	+= $(patsubst "%",%,$(builtindtb-y)).dtb.o
+
+clean-files := *.dtb
+
+endif
diff --git a/arch/arc/boot/dts/skeleton.dts b/arch/arc/boot/dts/skeleton.dts
new file mode 100644
index 0000000..25a84fb
--- /dev/null
+++ b/arch/arc/boot/dts/skeleton.dts
@@ -0,0 +1,10 @@
+/*
+ * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/dts-v1/;
+
+/include/ "skeleton.dtsi"
diff --git a/arch/arc/boot/dts/skeleton.dtsi b/arch/arc/boot/dts/skeleton.dtsi
new file mode 100644
index 0000000..9b357d8
--- /dev/null
+++ b/arch/arc/boot/dts/skeleton.dtsi
@@ -0,0 +1,21 @@
+/*
+ * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * Skeleton device tree; the bare minimum needed to boot; just include and
+ * add a compatible value.
+ */
+
+/ {
+	compatible = "snps,arc";
+	#address-cells = <1>;
+	#size-cells = <1>;
+	chosen { };
+	aliases { };
+	memory { device_type = "memory"; reg = <0 0>; };
+};
diff --git a/arch/arc/include/asm/prom.h b/arch/arc/include/asm/prom.h
new file mode 100644
index 0000000..f54489b
--- /dev/null
+++ b/arch/arc/include/asm/prom.h
@@ -0,0 +1,15 @@
+/*
+ * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_PROM_H_
+#define _ASM_ARC_PROM_H_
+
+#define HAVE_ARCH_DEVTREE_FIXUPS
+extern int __init setup_machine_fdt(void *dt);
+
+#endif
diff --git a/arch/arc/include/asm/sections.h b/arch/arc/include/asm/sections.h
index fc15f2e..6fc1159 100644
--- a/arch/arc/include/asm/sections.h
+++ b/arch/arc/include/asm/sections.h
@@ -13,5 +13,6 @@
 
 extern char _int_vec_base_lds[];
 extern char __arc_dccm_base[];
+extern char __dtb_start[];
 
 #endif
diff --git a/arch/arc/kernel/Makefile b/arch/arc/kernel/Makefile
index 6d83431..8a55e99 100644
--- a/arch/arc/kernel/Makefile
+++ b/arch/arc/kernel/Makefile
@@ -8,6 +8,8 @@
 obj-y	:= arcksyms.o setup.o irq.o time.o reset.o ptrace.o entry.o process.o
 obj-y	+= signal.o traps.o sys.o troubleshoot.o stacktrace.o clk.o
 
+obj-$(CONFIG_OF)			+= devtree.o
+
 obj-$(CONFIG_ARC_FPU_SAVE_RESTORE)	+= fpu.o
 CFLAGS_fpu.o   += -mdpfp
 
diff --git a/arch/arc/kernel/devtree.c b/arch/arc/kernel/devtree.c
new file mode 100644
index 0000000..229f78e
--- /dev/null
+++ b/arch/arc/kernel/devtree.c
@@ -0,0 +1,69 @@
+/*
+ * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * Based on highly stipped down version of METAG
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+
+#include <linux/init.h>
+#include <linux/export.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/reboot.h>
+#include <linux/memblock.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <asm/prom.h>
+
+/* called from unflatten_device_tree() to bootstrap devicetree itself */
+void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
+{
+	return __va(memblock_alloc(size, align));
+}
+
+/**
+ * setup_machine_fdt - Machine setup when an dtb was passed to the kernel
+ * @dt:		virtual address pointer to dt blob
+ *
+ * If a dtb was passed to the kernel, then use it to choose the correct
+ * machine_desc and to setup the system.
+ */
+int __init setup_machine_fdt(void *dt)
+{
+	struct boot_param_header *devtree = dt;
+	unsigned long dt_root;
+	char *model, *compat;
+	char manufacturer[16];
+
+	/* check device tree validity */
+	if (be32_to_cpu(devtree->magic) != OF_DT_HEADER)
+		return 1;
+
+	/* Search the mdescs for the 'best' compatible value match */
+	initial_boot_params = devtree;
+	dt_root = of_get_flat_dt_root();
+
+	/* compat = "<manufacturer>,<model>" */
+	compat = of_get_flat_dt_prop(dt_root, "compatible", NULL);
+	if (!compat)
+		compat = "<unknown>";
+
+	model = strchr(compat, ',');
+	if (model)
+		model++;
+
+	strlcpy(manufacturer, compat, model ? model - compat : strlen(compat));
+
+	pr_info("Board \"%s\" from %s (Manufacturer)\n", model, manufacturer);
+
+	/* Retrieve various information from the /chosen node */
+	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
+
+	return 0;
+}
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index 82ac206..27aebd6 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -13,6 +13,8 @@
 #include <linux/console.h>
 #include <linux/module.h>
 #include <linux/cpu.h>
+#include <linux/of_fdt.h>
+#include <asm/sections.h>
 #include <asm/arcregs.h>
 #include <asm/tlb.h>
 #include <asm/cache.h>
@@ -20,6 +22,7 @@
 #include <asm/page.h>
 #include <asm/irq.h>
 #include <asm/arcregs.h>
+#include <asm/prom.h>
 
 #define FIX_PTR(x)  __asm__ __volatile__(";" : "+r"(x))
 
@@ -57,6 +60,8 @@ void __init __attribute__((weak)) arc_platform_early_init(void)
 
 void __init setup_arch(char **cmdline_p)
 {
+	int rc;
+
 #ifdef CONFIG_CMDLINE_UBOOT
 	/* Make sure that a whitespace is inserted before */
 	strlcat(command_line, " ", sizeof(command_line));
@@ -71,6 +76,8 @@ void __init setup_arch(char **cmdline_p)
 	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
+	rc = setup_machine_fdt(__dtb_start);
+
 	/* To force early parsing of things like mem=xxx */
 	parse_early_param();
 
@@ -81,6 +88,8 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_arch_memory();
 
+	unflatten_device_tree();
+
 	/* Can be issue if someone passes cmd line arg "ro"
 	 * But that is unlikely so keeping it as it is
 	 */
diff --git a/arch/arc/mm/init.c b/arch/arc/mm/init.c
index 63da347..682cf57 100644
--- a/arch/arc/mm/init.c
+++ b/arch/arc/mm/init.c
@@ -39,6 +39,11 @@ static int __init setup_mem_sz(char *str)
 }
 early_param("mem", setup_mem_sz);
 
+void __init early_init_dt_add_memory_arch(u64 base, u64 size)
+{
+	pr_err("%s(%llx, %llx)\n", __func__, base, size);
+}
+
 /*
  * First memory setup routine called from setup_arch()
  * 1. setup swapper's mm @init_mm
@@ -169,3 +174,11 @@ void __init free_initrd_mem(unsigned long start, unsigned long end)
 	free_init_pages("initrd memory", start, end);
 }
 #endif
+
+#ifdef CONFIG_OF_FLATTREE
+void __init early_init_dt_setup_initrd_arch(unsigned long start,
+					    unsigned long end)
+{
+	pr_err("%s(%lx, %lx)\n", __func__, start, end);
+}
+#endif /* CONFIG_OF_FLATTREE */
-- 
1.7.4.1

