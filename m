Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3CRNUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:20:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44250 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3CRNUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:20:48 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v2] irqchip: Add support for ARMv7-M's NVIC
Date: Mon, 18 Mar 2013 14:20:26 +0100
Message-Id: <1363612826-15623-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.2.rc2
In-Reply-To: <alpine.LFD.2.02.1303122150490.22263@ionos>
References: <alpine.LFD.2.02.1303122150490.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This interrupt controller is found on Cortex-M3 and Cortex-M4 machines.

Support for this controller appeared in Catalin's Cortex tree based on
2.6.33 but was nearly completely rewritten.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

changes since v1:

 - fixed base address to match documentation
   So reading ICTR (which isn't in the nvic's address range) uses a new #define
   in asm/v7m.h which isn't in mainline yet. That's ugly but I don't have a
   better idea how to solve it without platform code.
 - s/NVIC_IPRI/NVIC_IPR/ to match documentation
 - use pr_warn instead of WARN/WARN_ON
 - do proper error handling, don't use IS_ERR_VALUE
 - drop the wrong skipping of the 16 system exceptions. They are not counted in
   ICTR_INTLINESNUM.
 - dynamically allocate chip data
 - drop the irq_domain* member from chip data as it's only used in the probe
   callback
 - change compatible string to arm,armv7m-nvic
 - drop a few unused #includes, use some linux/ #includes instead of asm/ ones
 - change indention to please tglx' eyes

A failure to probe the nvic makes the machine unresponsive. Does this 
have any implications on how the driver should behave when something
goes wrong? Another issue is that up to now the exception handling
simply calls asm_do_IRQ(16, ..) for the first nvic interrupt. So there
is a mismatch if irq_alloc_descs_from(16, ...) doesn't return 16. I
added error handling for that assuming that's fine for now, but in the long run
a better fix would be nice. What is the preferred approach to fix that? Use a
global variable that holds the irq_base? Or should I use a mapping function
instead?

 drivers/irqchip/Kconfig    |   4 ++
 drivers/irqchip/Makefile   |   1 +
 drivers/irqchip/irq-nvic.c | 176 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 181 insertions(+)
 create mode 100644 drivers/irqchip/irq-nvic.c

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index a350969..18657fd 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -10,6 +10,10 @@ config ARM_GIC
 config GIC_NON_BANKED
 	bool
 
+config ARM_NVIC
+	bool
+	select IRQ_DOMAIN
+
 config ARM_VIC
 	bool
 	select IRQ_DOMAIN
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 98e3b87..7227c5f 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -7,5 +7,6 @@ obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
+obj-$(CONFIG_ARM_NVIC)			+= irq-nvic.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
 obj-$(CONFIG_VERSATILE_FPGA_IRQ)	+= irq-versatile-fpga.o
diff --git a/drivers/irqchip/irq-nvic.c b/drivers/irqchip/irq-nvic.c
new file mode 100644
index 0000000..721c328
--- /dev/null
+++ b/drivers/irqchip/irq-nvic.c
@@ -0,0 +1,176 @@
+/*
+ * drivers/irq/irq-nvic.c
+ *
+ * Copyright (C) 2008 ARM Limited, All Rights Reserved.
+ * Copyright (C) 2013 Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Support for the Nested Vectored Interrupt Controller found on the
+ * ARMv7-M CPUs (Cortex-M3/M4)
+ */
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/export.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+
+#include <asm/v7m.h>
+
+#include "irqchip.h"
+
+#define NVIC_ISER			0x000
+#define NVIC_ICER			0x080
+#define NVIC_IPR			0x300
+
+/*
+ * Each bank handles 32 irqs. Only the 16th (= last) bank handles only
+ * 16 irqs yielding a maximum of 15 * 32 + 16 = 496 interrupts.
+ */
+#define NVIC_MAX_IRQ		496
+
+struct nvic_bank_data {
+	/*
+	 * For irq i base holds nvic_base + 4 * i / 32. So you can access the
+	 * right ISER register (i.e ISER[i / 32]) by just taking base + ISER.
+	 * Ditto for ICER.
+	 */
+	void __iomem *base;
+};
+
+static inline void __iomem *nvic_bank_base(struct irq_data *d)
+{
+	struct nvic_bank_data *data = irq_data_get_irq_chip_data(d);
+	return data->base;
+}
+
+static void nvic_mask_irq(struct irq_data *d)
+{
+	u32 mask = 1 << (d->hwirq % 32);
+
+	writel_relaxed(mask, nvic_bank_base(d) + NVIC_ICER);
+}
+
+static void nvic_unmask_irq(struct irq_data *d)
+{
+	u32 mask = 1 << (d->hwirq % 32);
+
+	writel_relaxed(mask, nvic_bank_base(d) + NVIC_ISER);
+}
+
+static void nvic_eoi(struct irq_data *d)
+{
+	/*
+	 * This is a no-op as end of interrupt is signaled by the exception
+	 * return sequence.
+	 */
+}
+
+static struct irq_chip nvic_chip = {
+	.name = "NVIC",
+	.irq_mask = nvic_mask_irq,
+	.irq_unmask = nvic_unmask_irq,
+	.irq_eoi = nvic_eoi,
+};
+
+static int __init nvic_init_bases(struct device_node *node,
+				  void __iomem *nvic_base)
+{
+	unsigned int irqs, i;
+	int irq_base, ret = -ENOMEM;
+	struct irq_domain *irq_domain;
+	struct nvic_bank_data *bank_data;
+	unsigned numbanks = (readl_relaxed(V7M_SCS_ICTR) &
+			     V7M_SCS_ICTR_INTLINESNUM_MASK) + 1;
+
+	irqs = numbanks * 32;
+	if (irqs > NVIC_MAX_IRQ)
+		irqs = NVIC_MAX_IRQ;
+
+	bank_data = kzalloc(sizeof(*bank_data) * numbanks, GFP_KERNEL);
+	if (!bank_data) {
+		pr_warn("Failed to allocate chip data");
+		goto err_alloc_bank_data;
+	}
+	for (i = 0; i < numbanks; ++i)
+		bank_data[i].base = nvic_base + 4 * i;
+
+	irq_base = irq_alloc_descs_from(16, irqs, numa_node_id());
+	if (irq_base < 0) {
+		pr_warn("Cannot allocate irq_descs\n");
+		ret = irq_base;
+		goto err_irq_alloc_descs;
+	}
+	if (irq_base != 16) {
+		/*
+		 * The entry code just passes the exception number (i.e. irq
+		 * number + 16) to asm_do_IRQ, so the offset needs to be fixed
+		 * here.
+		 */
+		pr_warn("Failed to allocate irq_descs at offset 16\n");
+		goto err_wrong_irq_base;
+	}
+
+	irq_domain = irq_domain_add_legacy(node, irqs, irq_base, 0,
+					   &irq_domain_simple_ops, NULL);
+	if (!irq_domain) {
+		pr_warn("Failed to allocate irq domain\n");
+		goto err_domain_add;
+	}
+
+	/* Disable all interrupts */
+	for (i = 0; i < irqs; i += 32)
+		writel_relaxed(~0, nvic_base + NVIC_ICER + i * 4 / 32);
+
+	/* Set priority on all interrupts */
+	for (i = 0; i < irqs; i += 4)
+		writel_relaxed(0, nvic_base + NVIC_IPR + i);
+
+	/* Setup the Linux IRQ subsystem */
+	for (i = 0; i < irqs; i++) {
+		irq_set_chip_and_handler(irq_base + i, &nvic_chip,
+					 handle_fasteoi_irq);
+		irq_set_chip_data(irq_base + i, bank_data + i / 32);
+		set_irq_flags(irq_base + i, IRQF_VALID | IRQF_PROBE);
+	}
+
+	return 0;
+
+err_domain_add:
+err_wrong_irq_base:
+
+	irq_free_descs(irq_base, irqs - 16);
+err_irq_alloc_descs:
+
+	kfree(bank_data);
+err_alloc_bank_data:
+
+	return ret;
+}
+
+static int __init nvic_of_init(struct device_node *node,
+			       struct device_node *parent)
+{
+	void __iomem *nvic_base;
+
+	if (!node)
+		return -ENODEV;
+
+	nvic_base = of_iomap(node, 0);
+	if (!nvic_base) {
+		pr_warn("unable to map nvic registers\n");
+		return -ENOMEM;
+	}
+
+	return nvic_init_bases(node, nvic_base);
+}
+IRQCHIP_DECLARE(armv7m_nvic, "arm,armv7m-nvic", nvic_of_init);
-- 
1.8.2.rc2

