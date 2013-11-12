Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab3KLTnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:43:12 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:60490 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab3KLTml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:42:41 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        James Hogan <james.hogan@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Chris Zankel <chris@zankel.net>, Rob Herring <rob.herring@calxeda.com>,
        devicetree@vger.kernel.org
Subject: [PATCH 14/17] dt: Consolidate __dtb_start declarations in <linux/of_fdt.h>
Date: Tue, 12 Nov 2013 20:42:24 +0100
Message-Id: <1384285347-13506-15-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The different architectures used their own (and different) declarations:

    extern struct boot_param_header __dtb_start;
    extern u32 __dtb_start[];
    extern char __dtb_start[];

Consolidate them using the first variant in <linux/of_fdt.h>.
This requires adding a few "address of" operators on architectures where
__dtb_start was an array before.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jonas Bonn <jonas@southpole.se>
CC: Chris Zankel <chris@zankel.net>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree@vger.kernel.org
---
 arch/arc/include/asm/sections.h             |    1 -
 arch/arc/kernel/setup.c                     |    2 +-
 arch/metag/kernel/setup.c                   |    6 +-----
 arch/mips/include/asm/mips-boards/generic.h |    4 ----
 arch/mips/lantiq/prom.h                     |    2 --
 arch/mips/netlogic/xlp/dt.c                 |    4 ++--
 arch/mips/ralink/of.c                       |    2 --
 arch/openrisc/kernel/setup.c                |    2 +-
 arch/openrisc/kernel/vmlinux.h              |    2 --
 arch/xtensa/kernel/setup.c                  |    3 +--
 include/linux/of_fdt.h                      |    3 +++
 11 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/arch/arc/include/asm/sections.h b/arch/arc/include/asm/sections.h
index 764f1e3ba752..09db952e14bd 100644
--- a/arch/arc/include/asm/sections.h
+++ b/arch/arc/include/asm/sections.h
@@ -12,6 +12,5 @@
 #include <asm-generic/sections.h>
 
 extern char __arc_dccm_base[];
-extern char __dtb_start[];
 
 #endif
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index 643eae4436e0..ef705d0f50f5 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -314,7 +314,7 @@ void setup_processor(void)
 void __init setup_arch(char **cmdline_p)
 {
 	/* This also populates @boot_command_line from /bootargs */
-	machine_desc = setup_machine_fdt(__dtb_start);
+	machine_desc = setup_machine_fdt(&__dtb_start);
 	if (!machine_desc)
 		panic("Embedded DT invalid\n");
 
diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
index 129c7cdda1ce..919c782f5479 100644
--- a/arch/metag/kernel/setup.c
+++ b/arch/metag/kernel/setup.c
@@ -105,10 +105,6 @@
 
 extern char _heap_start[];
 
-#ifdef CONFIG_METAG_BUILTIN_DTB
-extern u32 __dtb_start[];
-#endif
-
 #ifdef CONFIG_DA_CONSOLE
 /* Our early channel based console driver */
 extern struct console dash_console;
@@ -251,7 +247,7 @@ void __init setup_arch(char **cmdline_p)
 	if (!machine_desc) {
 #ifdef CONFIG_METAG_BUILTIN_DTB
 		/* try the embedded device tree */
-		machine_desc = setup_machine_fdt(__dtb_start);
+		machine_desc = setup_machine_fdt(&__dtb_start);
 		if (!machine_desc)
 			panic("Invalid embedded device tree.");
 #else
diff --git a/arch/mips/include/asm/mips-boards/generic.h b/arch/mips/include/asm/mips-boards/generic.h
index 48616816bcbc..c904c24550f6 100644
--- a/arch/mips/include/asm/mips-boards/generic.h
+++ b/arch/mips/include/asm/mips-boards/generic.h
@@ -67,10 +67,6 @@
 
 extern int mips_revision_sconid;
 
-#ifdef CONFIG_OF
-extern struct boot_param_header __dtb_start;
-#endif
-
 #ifdef CONFIG_PCI
 extern void mips_pcibios_init(void);
 #else
diff --git a/arch/mips/lantiq/prom.h b/arch/mips/lantiq/prom.h
index 8e07b5f28ef1..bfd2d58c1d69 100644
--- a/arch/mips/lantiq/prom.h
+++ b/arch/mips/lantiq/prom.h
@@ -26,6 +26,4 @@ struct ltq_soc_info {
 extern void ltq_soc_detect(struct ltq_soc_info *i);
 extern void ltq_soc_init(void);
 
-extern struct boot_param_header __dtb_start;
-
 #endif
diff --git a/arch/mips/netlogic/xlp/dt.c b/arch/mips/netlogic/xlp/dt.c
index 8316d5454b17..87250f378386 100644
--- a/arch/mips/netlogic/xlp/dt.c
+++ b/arch/mips/netlogic/xlp/dt.c
@@ -42,7 +42,7 @@
 #include <asm/prom.h>
 
 extern u32 __dtb_xlp_evp_begin[], __dtb_xlp_svp_begin[],
-	__dtb_xlp_fvp_begin[], __dtb_start[];
+	__dtb_xlp_fvp_begin[];
 static void *xlp_fdt_blob;
 
 void __init *xlp_dt_init(void *fdtp)
@@ -66,7 +66,7 @@ void __init *xlp_dt_init(void *fdtp)
 #endif
 		default:
 			/* Pick a built-in if any, and hope for the best */
-			fdtp = __dtb_start;
+			fdtp = &__dtb_start;
 			break;
 		}
 	}
diff --git a/arch/mips/ralink/of.c b/arch/mips/ralink/of.c
index eccc5526155e..615603bd8063 100644
--- a/arch/mips/ralink/of.c
+++ b/arch/mips/ralink/of.c
@@ -28,8 +28,6 @@
 __iomem void *rt_sysc_membase;
 __iomem void *rt_memc_membase;
 
-extern struct boot_param_header __dtb_start;
-
 __iomem void *plat_of_remap_node(const char *node)
 {
 	struct resource res;
diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
index 4fc7ccc0a2cf..c9b880d64bb8 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -213,7 +213,7 @@ void __init or32_early_setup(void *fdt)
 	if (fdt)
 		pr_info("FDT at %p\n", fdt);
 	else {
-		fdt = __dtb_start;
+		fdt = &__dtb_start;
 		pr_info("Compiled-in FDT at %p\n", fdt);
 	}
 	early_init_devtree(fdt);
diff --git a/arch/openrisc/kernel/vmlinux.h b/arch/openrisc/kernel/vmlinux.h
index 70b9ce41835c..bbcdf21b0b35 100644
--- a/arch/openrisc/kernel/vmlinux.h
+++ b/arch/openrisc/kernel/vmlinux.h
@@ -5,6 +5,4 @@
 extern char __initrd_start, __initrd_end;
 #endif
 
-extern u32 __dtb_start[];
-
 #endif
diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 6e2b6638122d..d96cf8f3fe70 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -68,8 +68,7 @@ extern int initrd_below_start_ok;
 #endif
 
 #ifdef CONFIG_OF
-extern u32 __dtb_start[];
-void *dtb_start = __dtb_start;
+void *dtb_start = &__dtb_start;
 #endif
 
 unsigned char aux_device_present;
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index 0beaee9dac1f..aabc49f3e403 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -57,6 +57,9 @@ struct boot_param_header {
 	__be32	dt_struct_size;		/* size of the DT structure block */
 };
 
+/* For kernels with a built-in device tree */
+extern struct boot_param_header __dtb_start;
+
 #if defined(CONFIG_OF_FLATTREE)
 
 struct device_node;
-- 
1.7.9.5

