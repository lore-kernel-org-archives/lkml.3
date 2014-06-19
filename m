Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966254AbaFSViP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:38:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:55668 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965603AbaFSVek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:34:40 -0400
Message-Id: <20140619212713.038658058@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:34:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>, spear-devel@list.st.com
Subject: [patch 03/13] irqchip: spear_shirq: Move private structs to source
References: <20140619212606.431750473@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=spear-shirq-move-private-structs-to-source.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point in having them in a separate header file. Make the init
functions static.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/spear-shirq.c       |   52 +++++++++++++++++++++++++----
 include/linux/irqchip/spear-shirq.h |   64 ------------------------------------
 2 files changed, 45 insertions(+), 71 deletions(-)

Index: linux/drivers/irqchip/spear-shirq.c
===================================================================
--- linux.orig/drivers/irqchip/spear-shirq.c
+++ linux/drivers/irqchip/spear-shirq.c
@@ -19,7 +19,6 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
-#include <linux/irqchip/spear-shirq.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
@@ -27,6 +26,45 @@
 
 #include "irqchip.h"
 
+/*
+ * struct shirq_regs: shared irq register configuration
+ *
+ * enb_reg: enable register offset
+ * reset_to_enb: val 1 indicates, we need to clear bit for enabling interrupt
+ * status_reg: status register offset
+ * status_reg_mask: status register valid mask
+ * clear_reg: clear register offset
+ * reset_to_clear: val 1 indicates, we need to clear bit for clearing interrupt
+ */
+struct shirq_regs {
+	u32 enb_reg;
+	u32 reset_to_enb;
+	u32 status_reg;
+	u32 clear_reg;
+	u32 reset_to_clear;
+};
+
+/*
+ * struct spear_shirq: shared irq structure
+ *
+ * irq: hardware irq number
+ * irq_base: base irq in linux domain
+ * irq_nr: no. of shared interrupts in a particular block
+ * irq_bit_off: starting bit offset in the status register
+ * invalid_irq: irq group is currently disabled
+ * base: base address of shared irq register
+ * regs: register configuration for shared irq block
+ */
+struct spear_shirq {
+	u32 irq;
+	u32 irq_base;
+	u32 irq_nr;
+	u32 irq_bit_off;
+	int invalid_irq;
+	void __iomem *base;
+	struct shirq_regs regs;
+};
+
 static DEFINE_SPINLOCK(lock);
 
 /* spear300 shared irq registers offsets and masks */
@@ -296,24 +334,24 @@ err_unmap:
 	return -ENXIO;
 }
 
-int __init spear300_shirq_of_init(struct device_node *np,
-		struct device_node *parent)
+static int __init spear300_shirq_of_init(struct device_node *np,
+					 struct device_node *parent)
 {
 	return shirq_init(spear300_shirq_blocks,
 			ARRAY_SIZE(spear300_shirq_blocks), np);
 }
 IRQCHIP_DECLARE(spear300_shirq, "st,spear300-shirq", spear300_shirq_of_init);
 
-int __init spear310_shirq_of_init(struct device_node *np,
-		struct device_node *parent)
+static int __init spear310_shirq_of_init(struct device_node *np,
+					 struct device_node *parent)
 {
 	return shirq_init(spear310_shirq_blocks,
 			ARRAY_SIZE(spear310_shirq_blocks), np);
 }
 IRQCHIP_DECLARE(spear310_shirq, "st,spear310-shirq", spear310_shirq_of_init);
 
-int __init spear320_shirq_of_init(struct device_node *np,
-		struct device_node *parent)
+static int __init spear320_shirq_of_init(struct device_node *np,
+					 struct device_node *parent)
 {
 	return shirq_init(spear320_shirq_blocks,
 			ARRAY_SIZE(spear320_shirq_blocks), np);
Index: linux/include/linux/irqchip/spear-shirq.h
===================================================================
--- linux.orig/include/linux/irqchip/spear-shirq.h
+++ /dev/null
@@ -1,64 +0,0 @@
-/*
- * SPEAr platform shared irq layer header file
- *
- * Copyright (C) 2009-2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
- *
- * This file is licensed under the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- */
-
-#ifndef __SPEAR_SHIRQ_H
-#define __SPEAR_SHIRQ_H
-
-#include <linux/irq.h>
-#include <linux/types.h>
-
-/*
- * struct shirq_regs: shared irq register configuration
- *
- * enb_reg: enable register offset
- * reset_to_enb: val 1 indicates, we need to clear bit for enabling interrupt
- * status_reg: status register offset
- * status_reg_mask: status register valid mask
- * clear_reg: clear register offset
- * reset_to_clear: val 1 indicates, we need to clear bit for clearing interrupt
- */
-struct shirq_regs {
-	u32 enb_reg;
-	u32 reset_to_enb;
-	u32 status_reg;
-	u32 clear_reg;
-	u32 reset_to_clear;
-};
-
-/*
- * struct spear_shirq: shared irq structure
- *
- * irq: hardware irq number
- * irq_base: base irq in linux domain
- * irq_nr: no. of shared interrupts in a particular block
- * irq_bit_off: starting bit offset in the status register
- * invalid_irq: irq group is currently disabled
- * base: base address of shared irq register
- * regs: register configuration for shared irq block
- */
-struct spear_shirq {
-	u32 irq;
-	u32 irq_base;
-	u32 irq_nr;
-	u32 irq_bit_off;
-	int invalid_irq;
-	void __iomem *base;
-	struct shirq_regs regs;
-};
-
-int __init spear300_shirq_of_init(struct device_node *np,
-		struct device_node *parent);
-int __init spear310_shirq_of_init(struct device_node *np,
-		struct device_node *parent);
-int __init spear320_shirq_of_init(struct device_node *np,
-		struct device_node *parent);
-
-#endif /* __SPEAR_SHIRQ_H */


