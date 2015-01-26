Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbbAZKps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:45:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39878 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbbAZKpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:45:43 -0500
Date: Mon, 26 Jan 2015 02:45:15 -0800
From: tip-bot for Baruch Siach <tipbot@zytor.com>
Message-ID: <tip-8041dfbd31cfff31309a2469c3d692595381c38e@git.kernel.org>
Cc: tglx@linutronix.de, baruch@tkos.co.il, hpa@zytor.com,
        sergei.shtylyov@cogentembedded.com, mark.rutland@arm.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org, mingo@kernel.org,
        jason@lakedaemon.net
Reply-To: arnd@arndb.de, jason@lakedaemon.net, mingo@kernel.org,
        linux-kernel@vger.kernel.org, sergei.shtylyov@cogentembedded.com,
        mark.rutland@arm.com, tglx@linutronix.de, hpa@zytor.com,
        baruch@tkos.co.il
In-Reply-To: <5b769e3c23dfa5fde08c4f3bc966c2c2b3921d8a.1421317616.git.baruch@tkos.co.il>
References: <5b769e3c23dfa5fde08c4f3bc966c2c2b3921d8a.1421317616.git.baruch@tkos.co.il>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip:
  Conexant CX92755 interrupts controller driver
Git-Commit-ID: 8041dfbd31cfff31309a2469c3d692595381c38e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8041dfbd31cfff31309a2469c3d692595381c38e
Gitweb:     http://git.kernel.org/tip/8041dfbd31cfff31309a2469c3d692595381c38e
Author:     Baruch Siach <baruch@tkos.co.il>
AuthorDate: Thu, 15 Jan 2015 12:34:00 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 26 Jan 2015 11:38:23 +0100

irqchip: Conexant CX92755 interrupts controller driver

Add interrupt controller driver to the Conexant CX92755 SoC, part of the
Digicolor SoCs series. Use the generic irq framework support. Use syscon to
access the system global UC_IRQ_CONTROL register.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Link: http://lkml.kernel.org/r/5b769e3c23dfa5fde08c4f3bc966c2c2b3921d8a.1421317616.git.baruch@tkos.co.il
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/Makefile        |   1 +
 drivers/irqchip/irq-digicolor.c | 120 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+)

diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 9516a32..42965d2 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -42,3 +42,4 @@ obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o
 obj-$(CONFIG_KEYSTONE_IRQ)		+= irq-keystone.o
 obj-$(CONFIG_MIPS_GIC)			+= irq-mips-gic.o
 obj-$(CONFIG_ARCH_MEDIATEK)		+= irq-mtk-sysirq.o
+obj-$(CONFIG_ARCH_DIGICOLOR)		+= irq-digicolor.o
diff --git a/drivers/irqchip/irq-digicolor.c b/drivers/irqchip/irq-digicolor.c
new file mode 100644
index 0000000..930a2a2
--- /dev/null
+++ b/drivers/irqchip/irq-digicolor.c
@@ -0,0 +1,120 @@
+/*
+ * Conexant Digicolor SoCs IRQ chip driver
+ *
+ * Author: Baruch Siach <baruch@tkos.co.il>
+ *
+ * Copyright (C) 2014 Paradox Innovation Ltd.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+
+#include <asm/exception.h>
+
+#include "irqchip.h"
+
+#define UC_IRQ_CONTROL		0x04
+
+#define IC_FLAG_CLEAR_LO	0x00
+#define IC_FLAG_CLEAR_XLO	0x04
+#define IC_INT0ENABLE_LO	0x10
+#define IC_INT0ENABLE_XLO	0x14
+#define IC_INT0STATUS_LO	0x18
+#define IC_INT0STATUS_XLO	0x1c
+
+static struct irq_domain *digicolor_irq_domain;
+
+static void __exception_irq_entry digicolor_handle_irq(struct pt_regs *regs)
+{
+	struct irq_domain_chip_generic *dgc = digicolor_irq_domain->gc;
+	struct irq_chip_generic *gc = dgc->gc[0];
+	u32 status, hwirq;
+
+	do {
+		status = irq_reg_readl(gc, IC_INT0STATUS_LO);
+		if (status) {
+			hwirq = ffs(status) - 1;
+		} else {
+			status = irq_reg_readl(gc, IC_INT0STATUS_XLO);
+			if (status)
+				hwirq = ffs(status) - 1 + 32;
+			else
+				return;
+		}
+
+		handle_domain_irq(digicolor_irq_domain, hwirq, regs);
+	} while (1);
+}
+
+static void digicolor_set_gc(void __iomem *reg_base, unsigned irq_base,
+			     unsigned en_reg, unsigned ack_reg)
+{
+	struct irq_chip_generic *gc;
+
+	gc = irq_get_domain_generic_chip(digicolor_irq_domain, irq_base);
+	gc->reg_base = reg_base;
+	gc->chip_types[0].regs.ack = ack_reg;
+	gc->chip_types[0].regs.mask = en_reg;
+	gc->chip_types[0].chip.irq_ack = irq_gc_ack_set_bit;
+	gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
+	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
+}
+
+static int __init digicolor_of_init(struct device_node *node,
+				struct device_node *parent)
+{
+	static void __iomem *reg_base;
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	struct regmap *ucregs;
+	int ret;
+
+	reg_base = of_iomap(node, 0);
+	if (!reg_base) {
+		pr_err("%s: unable to map IC registers\n", node->full_name);
+		return -ENXIO;
+	}
+
+	/* disable all interrupts */
+	writel(0, reg_base + IC_INT0ENABLE_LO);
+	writel(0, reg_base + IC_INT0ENABLE_XLO);
+
+	ucregs = syscon_regmap_lookup_by_phandle(node, "syscon");
+	if (IS_ERR(ucregs)) {
+		pr_err("%s: unable to map UC registers\n", node->full_name);
+		return PTR_ERR(ucregs);
+	}
+	/* channel 1, regular IRQs */
+	regmap_write(ucregs, UC_IRQ_CONTROL, 1);
+
+	digicolor_irq_domain =
+		irq_domain_add_linear(node, 64, &irq_generic_chip_ops, NULL);
+	if (!digicolor_irq_domain) {
+		pr_err("%s: unable to create IRQ domain\n", node->full_name);
+		return -ENOMEM;
+	}
+
+	ret = irq_alloc_domain_generic_chips(digicolor_irq_domain, 32, 1,
+					     "digicolor_irq", handle_level_irq,
+					     clr, 0, 0);
+	if (ret) {
+		pr_err("%s: unable to allocate IRQ gc\n", node->full_name);
+		return ret;
+	}
+
+	digicolor_set_gc(reg_base, 0, IC_INT0ENABLE_LO, IC_FLAG_CLEAR_LO);
+	digicolor_set_gc(reg_base, 32, IC_INT0ENABLE_XLO, IC_FLAG_CLEAR_XLO);
+
+	set_handle_irq(digicolor_handle_irq);
+
+	return 0;
+}
+IRQCHIP_DECLARE(conexant_digicolor_ic, "cnxt,cx92755-ic", digicolor_of_init);
