Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbaGIMlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:41:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38183 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801AbaGIMik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:38:40 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <javier@dowhile0.org>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <dwmw2@infradead.org>,
        <jg1.han@samsung.com>, <nsekhar@ti.com>,
        <linux-mtd@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 03/10] OMAP: GPMC: Introduce APIs to access NAND control registers
Date: Wed, 9 Jul 2014 15:37:23 +0300
Message-ID: <1404909450-11970-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404909450-11970-1-git-send-email-rogerq@ti.com>
References: <1404909450-11970-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce omap_gpmc_read_reg() and omap_gpmc_write_reg() so that the
NAND driver can access the required registers (only those specified in
enum omap_gpmc_reg).

The NAND driver must use these APIs instead of directly accesing the
NAND control registers as they belong to the GPMC controller's register space.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc.c     | 88 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/omap-gpmc-nand.h | 40 +++++++++++++++++++
 2 files changed, 127 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/omap-gpmc-nand.h

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 2c0c281..92bbada 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -31,7 +31,7 @@
 #include <linux/of_device.h>
 #include <linux/mtd/nand.h>
 #include <linux/pm_runtime.h>
-
+#include <linux/omap-gpmc-nand.h>
 #include <linux/platform_data/mtd-nand-omap2.h>
 
 #include <asm/mach-types.h>
@@ -167,10 +167,32 @@ static resource_size_t phys_base, mem_size;
 static unsigned gpmc_capability;
 static void __iomem *gpmc_base;
 
+struct gpmc_nand_reg {
+	void __iomem *command;
+	void __iomem *address;
+	void __iomem *data;
+};
+
+static struct gpmc_nand_reg gpmc_nand_reg_map[GPMC_CS_NUM];
+
 static struct clk *gpmc_l3_clk;
 
 static irqreturn_t gpmc_handle_irq(int irq, void *dev);
 
+static void gpmc_fill_nand_reg_map(void)
+{
+	int i;
+
+	for (i = 0; i < gpmc_cs_num; i++) {
+		gpmc_nand_reg_map[i].command = gpmc_base + GPMC_CS0_OFFSET +
+				GPMC_CS_NAND_COMMAND + GPMC_CS_SIZE * i;
+		gpmc_nand_reg_map[i].address = gpmc_base + GPMC_CS0_OFFSET +
+				GPMC_CS_NAND_ADDRESS + GPMC_CS_SIZE * i;
+		gpmc_nand_reg_map[i].data  = gpmc_base + GPMC_CS0_OFFSET +
+				GPMC_CS_NAND_DATA + GPMC_CS_SIZE * i;
+	}
+}
+
 static void gpmc_write_reg(int idx, u32 val)
 {
 	writel_relaxed(val, gpmc_base + idx);
@@ -1720,6 +1742,7 @@ static int gpmc_probe(struct platform_device *pdev)
 		return rc;
 	}
 
+	gpmc_fill_nand_reg_map();
 	return 0;
 }
 
@@ -1885,3 +1908,66 @@ void omap3_gpmc_restore_context(void)
 		}
 	}
 }
+
+/**
+ * omap_gpmc_read_reg - Read the specified GPMC register
+ * @cs:		chip select number
+ * @reg:	GPMC register id
+ *
+ * Reads the specified register from the appropriate chip select region
+ * and returns the read value.
+ */
+u32 omap_gpmc_read_reg(int cs, enum omap_gpmc_reg reg)
+{
+	if (!gpmc_dev)
+		return 0;
+
+	if (cs >= gpmc_cs_num)
+		return 0;
+
+	switch (reg) {
+	case OMAP_GPMC_STATUS:
+		return gpmc_read_reg(GPMC_STATUS);
+	case OMAP_GPMC_NAND_COMMAND:
+	case OMAP_GPMC_NAND_ADDRESS:
+		return 0;	/* command & address regs can't be read */
+	case OMAP_GPMC_NAND_DATA:
+		return readb_relaxed(gpmc_nand_reg_map[cs].data);
+	default:
+		return 0;
+	}
+}
+
+/**
+ * omap_gpmc_write_reg - Write into the specified GPMC register
+ * @cs:		chip select number
+ * @reg:	GPMC register id
+ * @val:	value to write
+ *
+ * Writes the value into the specified register in the appropriate
+ * chip select region.
+ */
+void omap_gpmc_write_reg(int cs, enum omap_gpmc_reg reg, u32 val)
+{
+	if (!gpmc_dev)
+		return;
+
+	if (cs >= gpmc_cs_num)
+		return;
+
+	switch (reg) {
+	case OMAP_GPMC_STATUS:
+		gpmc_write_reg(GPMC_STATUS, val);
+	case OMAP_GPMC_NAND_COMMAND:
+		writeb_relaxed(val, gpmc_nand_reg_map[cs].command);
+		break;
+	case OMAP_GPMC_NAND_ADDRESS:
+		writeb_relaxed(val, gpmc_nand_reg_map[cs].address);
+		break;
+	case OMAP_GPMC_NAND_DATA:
+		writeb_relaxed(val, gpmc_nand_reg_map[cs].data);
+		break;
+	default:
+		break;
+	}
+}
diff --git a/include/linux/omap-gpmc-nand.h b/include/linux/omap-gpmc-nand.h
new file mode 100644
index 0000000..dcb2abe
--- /dev/null
+++ b/include/linux/omap-gpmc-nand.h
@@ -0,0 +1,40 @@
+/*
+ * OMAP NAND to GPMC custom API interface
+ *
+ * Copyright (C) 2014 Texas Instruments, Inc. - http://www.ti.com
+ *      Roger Quadros <rogerq@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ */
+
+#ifndef _OMAP_GPMC_NAND_H_
+#define _OMAP_GPMC_NAND_H_
+
+/**
+ * Registers that need to be accessed by the OMAP NAND driver
+ */
+
+enum omap_gpmc_reg {
+	OMAP_GPMC_STATUS,
+	OMAP_GPMC_NAND_COMMAND,
+	OMAP_GPMC_NAND_ADDRESS,
+	OMAP_GPMC_NAND_DATA,
+};
+
+#ifdef CONFIG_ARCH_OMAP2PLUS
+u32 omap_gpmc_read_reg(int cs, enum omap_gpmc_reg reg);
+void omap_gpmc_write_reg(int cs, enum omap_gpmc_reg reg, u32 val);
+#else
+static inline u32 omap_gpmc_read_reg(int cs, enum omap_gpmc_reg reg)
+{
+	return 0;
+}
+
+static inline void omap_gpmc_write_reg(int cs, enum omap_gpmc_reg reg, u32 val)
+{
+}
+#endif
+
+#endif /* _GPMC_OMAP_H_ */
-- 
1.8.3.2

