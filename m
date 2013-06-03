Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab3FCPvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:51:33 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:49562 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab3FCPvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:51:31 -0400
From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        Anup Patel <anup.patel@linaro.org>
Subject: [PATCH] arm64: Add support to pass earlyprintk argument via device tree
Date: Mon,  3 Jun 2013 21:21:11 +0530
Message-Id: <1370274671-23812-1-git-send-email-pranavkumar@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for defining and passing earlyprintk
related information i.e. device and address information via
device tree by adding it inside "chosen" node.

This will help user to just specify "earlyprintk" from bootargs
without actually knowing the address and device to enable
earlyprintk.

Mechanism:

One can just append earlyprintk=device-type,address (same as we pass
through command line) in "/chosen" node to notify kernel which is the
earlyprintk device and what is its address.

Backward Compatibility:

This patch also allows existing method of specifying earlyprintk
parameter via bootargs.

Existing method i.e. passing via bootargs will still have precedence
over device tree i.e. if one specifies earlyprintk=device-type,address
in bootargs then kernel will use information from bootargs instead of
device tree.

If user just specifies earlyprintk (without =...) then kernel will
look for device tree earlyprintk parameter.

Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Signed-off-by: Anup Patel <anup.patel@linaro.org>
---
 arch/arm64/kernel/early_printk.c |    7 +++++++
 arch/arm64/kernel/setup.c        |   21 ++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/early_printk.c b/arch/arm64/kernel/early_printk.c
index fbb6e18..4e6f845 100644
--- a/arch/arm64/kernel/early_printk.c
+++ b/arch/arm64/kernel/early_printk.c
@@ -29,6 +29,8 @@
 static void __iomem *early_base;
 static void (*printch)(char ch);
 
+extern char *earlyprintk_dt_args;
+
 /*
  * PL011 single character TX.
  */
@@ -116,6 +118,11 @@ static int __init setup_early_printk(char *buf)
 	phys_addr_t paddr = 0;
 
 	if (!buf) {
+		/* Try to check if Device Tree has this argument or not ? */
+		buf = earlyprintk_dt_args;
+	}
+
+	if (!buf) {
 		pr_warning("No earlyprintk arguments passed.\n");
 		return 0;
 	}
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 6a9a532..fb2d56f 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -60,6 +60,8 @@ EXPORT_SYMBOL(processor_id);
 unsigned int elf_hwcap __read_mostly;
 EXPORT_SYMBOL_GPL(elf_hwcap);
 
+char *earlyprintk_dt_args;
+
 static const char *cpu_name;
 static const char *machine_name;
 phys_addr_t __fdt_pointer __initdata;
@@ -122,6 +124,23 @@ static void __init setup_processor(void)
 	elf_hwcap = 0;
 }
 
+int __init early_init_dt_scan_chosen_arm64(unsigned long node,
+					   const char *uname,
+					   int depth, void *data)
+{
+	char *prop;
+
+	/* Check if this is chosen node */
+	if (early_init_dt_scan_chosen(node, uname, depth, data) == 0)
+		return 0;
+
+	prop = of_get_flat_dt_prop(node, "earlyprintk", NULL);
+	if (prop)
+		earlyprintk_dt_args = prop;
+
+	return 1;
+}
+
 static void __init setup_machine_fdt(phys_addr_t dt_phys)
 {
 	struct boot_param_header *devtree;
@@ -165,7 +184,7 @@ static void __init setup_machine_fdt(phys_addr_t dt_phys)
 	pr_info("Machine: %s\n", machine_name);
 
 	/* Retrieve various information from the /chosen node */
-	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
+	of_scan_flat_dt(early_init_dt_scan_chosen_arm64, boot_command_line);
 	/* Initialize {size,address}-cells info */
 	of_scan_flat_dt(early_init_dt_scan_root, NULL);
 	/* Setup memory, calling early_init_dt_add_memory_arch */
-- 
1.7.9.5

