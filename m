Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3EaOZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:25:11 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33431 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab3EaOYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:24:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/2] ARM: ux500: Enable HIGHMEM in the u8540 defconfig
Date: Fri, 31 May 2013 15:24:32 +0100
Message-Id: <1370010272-25520-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370010272-25520-1-git-send-email-lee.jones@linaro.org>
References: <1370010272-25520-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to utilise all of the memory located on ux500 based devices
we have to enable HIGHMEM. Without it the kernel truncates memory down
to what's left after the PAGE_OFFSET has been applied, which doesn't
leave an awful lot, especially if we're running large rootfs' such
as full Linux desktop distributions or Android.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/configs/u8500_defconfig |    1 +
 drivers/of/fdt.c                 |   52 +++++++-------------------------------
 2 files changed, 10 insertions(+), 43 deletions(-)

diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index 2d322d2..38d633a 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -1,3 +1,4 @@
+CONFIG_HIGHMEM=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_NO_HZ=y
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 5439925..808be06 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -43,7 +43,7 @@ void *of_fdt_get_property(struct boot_param_header *blob,
 
 	do {
 		u32 tag = be32_to_cpup((__be32 *)p);
-		u32 sz, noff, i;
+		u32 sz, noff;
 		const char *nstr;
 
 		p += 4;
@@ -66,10 +66,6 @@ void *of_fdt_get_property(struct boot_param_header *blob,
 		if (strcmp(name, nstr) == 0) {
 			if (size)
 				*size = sz;
-
-	print_hex_dump(KERN_ERR, "node: ", DUMP_PREFIX_ADDRESS,
-		       16, 1, (__be32 *)node, p - node, true);
-
 			return (void *)p;
 		}
 		p += sz;
@@ -624,68 +620,38 @@ int __init early_init_dt_scan_memory(unsigned long node, const char *uname,
 	__be32 *reg, *endp;
 	unsigned long l;
 
-	printk("LEE: ******************************************* \n");
-	printk("LEE: ******************************************* \n");
-	printk("LEE: ******************************************* \n");
-	printk("LEE: ******************************************* \n");
-	printk("LEE: ******************************************* \n");
-	printk("LEE: ******************************************* \n");
-	printk("LEE: ******************************************* \n");
-
 	/* We are scanning "memory" nodes only */
 	if (type == NULL) {
-		printk("LEE: 1\n");
 		/*
 		 * The longtrail doesn't have a device_type on the
 		 * /memory node, so look for the node called /memory@0.
 		 */
-		if (depth != 1 || strcmp(uname, "memory@0") != 0) {
-			printk("LEE: 2\n");
+		if (depth != 1 || strcmp(uname, "memory@0") != 0)
 			return 0;
-		}
-	} else if (strcmp(type, "memory") != 0) {
-		printk("LEE: 3\n");
+	} else if (strcmp(type, "memory") != 0)
 		return 0;
-	}
 
 	reg = of_get_flat_dt_prop(node, "linux,usable-memory", &l);
-	if (reg == NULL) {
+	if (reg == NULL)
 		reg = of_get_flat_dt_prop(node, "reg", &l);
-		printk("LEE: This is correct \n");
-	}
-	if (reg == NULL) {
-		printk("LEE: 4\n");
-       		return 0;
-	}
-
-	printk("LEE: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n");
-	printk("LEE: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n");
-	printk("LEE: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n");
-	printk("LEE: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n");
-	printk("LEE: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n");
-	printk("LEE: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n");
-	printk("LEE: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n");
+	if (reg == NULL)
+		return 0;
 
 	endp = reg + (l / sizeof(__be32));
 
-	printk("LEE: reg: 0x%p\n", reg);
-
-	printk("memory scan node %s, reg size %ld, data: %x %x %x %x,\n",
+	pr_debug("memory scan node %s, reg size %ld, data: %x %x %x %x,\n",
 	    uname, l, reg[0], reg[1], reg[2], reg[3]);
 
-	printk("extras: %x %x %x %x,\n", reg[4], reg[5], reg[6], reg[7]);
-
 	while ((endp - reg) >= (dt_root_addr_cells + dt_root_size_cells)) {
 		u64 base, size;
 
 		base = dt_mem_next_cell(dt_root_addr_cells, &reg);
 		size = dt_mem_next_cell(dt_root_size_cells, &reg);
 
-		printk(" - %llx ,  %llx\n", (unsigned long long)base,
-		    (unsigned long long)size);
-
 		if (size == 0)
 			continue;
+		pr_debug(" - %llx ,  %llx\n", (unsigned long long)base,
+		    (unsigned long long)size);
 
 		early_init_dt_add_memory_arch(base, size);
 	}
-- 
1.7.10.4

