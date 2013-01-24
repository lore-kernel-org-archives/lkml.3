Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab3AXK4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:56:46 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:42508 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab3AXKyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:54:52 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v3 33/71] ARC: [DeviceTree] Convert some Kconfig items to runtime values
Date: Thu, 24 Jan 2013 16:20:29 +0530
Message-ID: <1359024639-21915-16-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
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
 arch/arc/mm/init.c              |    9 ++++++---
 6 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 7666857..7db9785 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -249,10 +249,6 @@ source "arch/arc/plat-arcfpga/Kconfig"
 
 #New platform adds here
 
-config ARC_PLAT_CLK
-	int "Clk speed in Hz"
-	default "80000000"
-
 config LINUX_LINK_BASE
 	hex "Linux Link Address"
 	default "0x80000000"
@@ -266,14 +262,6 @@ config LINUX_LINK_BASE
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
index 9b357d8..eb8b773 100644
--- a/arch/arc/boot/dts/skeleton.dtsi
+++ b/arch/arc/boot/dts/skeleton.dtsi
@@ -13,9 +13,13 @@
 
 / {
 	compatible = "snps,arc";
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
index 229f78e..d2a41be 100644
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
index 682cf57..caf797d 100644
--- a/arch/arc/mm/init.c
+++ b/arch/arc/mm/init.c
@@ -25,7 +25,7 @@ char empty_zero_page[PAGE_SIZE] __aligned(PAGE_SIZE);
 EXPORT_SYMBOL(empty_zero_page);
 
 /* Default tot mem from .config */
-static unsigned long arc_mem_sz = CONFIG_ARC_PLAT_SDRAM_SIZE;
+static unsigned long arc_mem_sz = 0x20000000;  /* some default */
 
 /* User can over-ride above with "mem=nnn[KkMm]" in cmdline */
 static int __init setup_mem_sz(char *str)
@@ -41,7 +41,8 @@ early_param("mem", setup_mem_sz);
 
 void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 {
-	pr_err("%s(%llx, %llx)\n", __func__, base, size);
+	arc_mem_sz = size & PAGE_MASK;
+	pr_info("Memory size set via devicetree %ldM\n", TO_MB(arc_mem_sz));
 }
 
 /*
@@ -62,7 +63,9 @@ void __init setup_arch_memory(void)
 
 	/*
 	 * We do it here, so that memory is correctly instantiated
-	 * even if "mem=xxx" cmline over-ride is not given
+	 * even if "mem=xxx" cmline over-ride is given and/or
+	 * DT has memory node. Each causes an update to @arc_mem_sz
+	 * and we finally add memory one here
 	 */
 	memblock_add(CONFIG_LINUX_LINK_BASE, arc_mem_sz);
 
-- 
1.7.4.1

