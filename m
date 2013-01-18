Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab3ARMmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:42:37 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:58791 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab3ARMbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:31:05 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 33/76] ARC: [DeviceTree] Convert some Kconfig items to runtime values
Date: Fri, 18 Jan 2013 17:54:47 +0530
Message-ID: <1358511930-7424-34-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* mem size now runtime configured (prev CONFIG_ARC_PLAT_SDRAM_SIZE)
* core cpu clk runtime configured (prev CONFIG_ARC_PLAT_CLK)

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arc/Kconfig                |   12 ------------
 arch/arc/boot/dts/skeleton.dtsi |    6 +++++-
 arch/arc/include/asm/clk.h      |    2 ++
 arch/arc/kernel/clk.c           |   12 +++++++++++-
 arch/arc/kernel/devtree.c       |   13 +++++++++++++
 arch/arc/mm/init.c              |    5 +++--
 6 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 5175cf7..548b89e 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -245,10 +245,6 @@ source "arch/arc/plat-arcfpga/Kconfig"
 
 #New platform adds here
 
-config ARC_PLAT_CLK
-	int "Clk speed in Hz"
-	default "80000000"
-
 config LINUX_LINK_BASE
 	hex "Linux Link Address"
 	default "0x80000000"
@@ -262,14 +258,6 @@ config LINUX_LINK_BASE
 	  Linux needs to be scooted a bit.
 	  If you don't know what the above means, leave this setting alone.
 
-config ARC_PLAT_SDRAM_SIZE
-	hex "SD RAM Size"
-	default "0x10000000"
-	help
-	  Implies the amount of SDRAM/DRAM Linux is going to claim/own.
-	  The actual memory itself could be larger than this number. But for
-	  all software purposes, this is the amt of memory.
-
 endmenu # "Platform Board Configuration"
 
 config ARC_STACK_NONEXEC
diff --git a/arch/arc/boot/dts/skeleton.dtsi b/arch/arc/boot/dts/skeleton.dtsi
index f6a457a..8e4ec00 100644
--- a/arch/arc/boot/dts/skeleton.dtsi
+++ b/arch/arc/boot/dts/skeleton.dtsi
@@ -13,9 +13,13 @@
 
 / {
 	compatible = "snps,arc-angel4", "snps,arc-ml509";
+	clock-frequency = <80000000>;	/* 80 MHZ */
 	#address-cells = <1>;
 	#size-cells = <1>;
 	chosen { };
 	aliases { };
-	memory { device_type = "memory"; reg = <0 0>; };
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x10000000>;	/* 256M */
+	};
 };
diff --git a/arch/arc/include/asm/clk.h b/arch/arc/include/asm/clk.h
index 6195643..bf9d29f 100644
--- a/arch/arc/include/asm/clk.h
+++ b/arch/arc/include/asm/clk.h
@@ -17,4 +17,6 @@ static inline unsigned long arc_get_core_freq(void)
 	return core_freq;
 }
 
+extern int arc_set_core_freq(unsigned long);
+
 #endif
diff --git a/arch/arc/kernel/clk.c b/arch/arc/kernel/clk.c
index 64925db..66ce0dc 100644
--- a/arch/arc/kernel/clk.c
+++ b/arch/arc/kernel/clk.c
@@ -8,4 +8,14 @@
 
 #include <asm/clk.h>
 
-unsigned long core_freq = CONFIG_ARC_PLAT_CLK;
+unsigned long core_freq = 800000000;
+
+/*
+ * As of now we default to device-tree provided clock
+ * In future we can determine this in early boot
+ */
+int arc_set_core_freq(unsigned long freq)
+{
+	core_freq = freq;
+	return 0;
+}
diff --git a/arch/arc/kernel/devtree.c b/arch/arc/kernel/devtree.c
index 021293d..fd49394 100644
--- a/arch/arc/kernel/devtree.c
+++ b/arch/arc/kernel/devtree.c
@@ -20,6 +20,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <asm/prom.h>
+#include <asm/clk.h>
 
 /* called from unflatten_device_tree() to bootstrap devicetree itself */
 void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
@@ -39,7 +40,9 @@ int __init setup_machine_fdt(void *dt)
 	struct boot_param_header *devtree = dt;
 	unsigned long dt_root;
 	char *model, *compat;
+	void *clk;
 	char manufacturer[16];
+	unsigned long len;
 
 	/* check device tree validity */
 	if (be32_to_cpu(devtree->magic) != OF_DT_HEADER)
@@ -65,5 +68,15 @@ int __init setup_machine_fdt(void *dt)
 	/* Retrieve various information from the /chosen node */
 	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
 
+	/* Initialize {size,address}-cells info */
+	of_scan_flat_dt(early_init_dt_scan_root, NULL);
+
+	/* Setup memory, calling early_init_dt_add_memory_arch */
+	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
+
+	clk = of_get_flat_dt_prop(dt_root, "clock-frequency", &len);
+	if (clk)
+		arc_set_core_freq(of_read_ulong(clk, len/4));
+
 	return 0;
 }
diff --git a/arch/arc/mm/init.c b/arch/arc/mm/init.c
index 1087a97..8c173f9 100644
--- a/arch/arc/mm/init.c
+++ b/arch/arc/mm/init.c
@@ -24,7 +24,7 @@ char empty_zero_page[PAGE_SIZE] __aligned(PAGE_SIZE);
 EXPORT_SYMBOL(empty_zero_page);
 
 /* Default tot mem from .config */
-static unsigned long arc_mem_sz = CONFIG_ARC_PLAT_SDRAM_SIZE;
+static unsigned long arc_mem_sz = 0x20000000;  /* some default */
 
 /* User can over-ride above with "mem=nnn[KkMm]" in cmdline */
 static int __init setup_mem_sz(char *str)
@@ -40,7 +40,8 @@ early_param("mem", setup_mem_sz);
 
 void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 {
-	pr_err("%s(%llx, %llx)\n", __func__, base, size);
+	arc_mem_sz = size & PAGE_MASK;
+	pr_info("Memory size set via devicetree %ldM\n", TO_MB(arc_mem_sz));
 }
 
 /*
-- 
1.7.4.1

