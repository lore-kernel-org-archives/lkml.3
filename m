Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab3CLQDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:03:40 -0400
Received: from avalon.kleine-koenig.org ([78.46.226.219]:47937 "EHLO
	avalon.kleine-koenig.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab3CLQDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:03:38 -0400
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Mar 2013 12:03:38 EDT
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH] irqchip: Add support for ARMv7-M's NVIC
Date: Tue, 12 Mar 2013 16:54:33 +0100
Message-Id: <1363103673-24720-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.2.rc2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

This interrupt controller is found on Cortex-M3 and Cortex-M4 machines.

[ukleinek: drop locking, switch to fasteoi handler, add irqdomain
and dt support, move to drivers/irq]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/irqchip/Kconfig    |   4 ++
 drivers/irqchip/Makefile   |   1 +
 drivers/irqchip/irq-nvic.c | 136 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 141 insertions(+)
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
index 0000000..ddfb3d8
--- /dev/null
+++ b/drivers/irqchip/irq-nvic.c
@@ -0,0 +1,136 @@
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
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/compiler.h>
+#include <linux/smp.h>
+#include <linux/export.h>
+#include <linux/err.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/irqdomain.h>
+
+#include <asm/irq.h>
+#include <asm/io.h>
+#include <asm/mach/irq.h>
+
+#include "irqchip.h"
+
+#define NVIC_INTR_CTRL			(0x004)
+#define NVIC_ISER			(0x100)
+#define NVIC_ICER			(0x180)
+#define NVIC_IPRI			(0x400)
+
+struct nvic_chip_data {
+	void __iomem *dist_base;
+	struct irq_domain *domain;
+};
+
+static struct nvic_chip_data nvic_data __read_mostly;
+
+static inline void __iomem *nvic_dist_base(struct irq_data *d)
+{
+	struct nvic_chip_data *nvic_data = irq_data_get_irq_chip_data(d);
+	return nvic_data->dist_base;
+}
+
+static void nvic_mask_irq(struct irq_data *d)
+{
+	u32 mask = 1 << (d->hwirq % 32);
+
+	writel_relaxed(mask, nvic_dist_base(d) + NVIC_ICER + d->irq / 32 * 4);
+}
+
+static void nvic_unmask_irq(struct irq_data *d)
+{
+	u32 mask = 1 << (d->hwirq % 32);
+
+	writel_relaxed(mask, nvic_dist_base(d) + NVIC_ISER + d->hwirq / 32 * 4);
+}
+
+void nvic_eoi(struct irq_data *d)
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
+static void __init nvic_init_bases(struct device_node *node,
+		void __iomem *dist_base)
+{
+	unsigned int irqs, i, irq_base;
+
+	nvic_data.dist_base = dist_base;
+
+	irqs = ((readl_relaxed(dist_base + NVIC_INTR_CTRL) & 0x0f) + 1) * 32;
+	if (irqs > 496)
+		irqs = 496;
+
+	irq_base = irq_alloc_descs(-1, 16, irqs - 16, numa_node_id());
+	if (IS_ERR_VALUE(irq_base)) {
+		WARN(1, "Cannot allocate irq_descs\n");
+		irq_base = 16;
+	}
+	nvic_data.domain = irq_domain_add_legacy(node, irqs - 16, irq_base, 0,
+			&irq_domain_simple_ops, NULL);
+	if (WARN_ON(!nvic_data.domain))
+		return;
+
+	/*
+	 * Set priority on all interrupts.
+	 */
+	for (i = 0; i < irqs; i += 4)
+		writel_relaxed(0, dist_base + NVIC_IPRI + i);
+
+	/*
+	 * Disable all interrupts
+	 */
+	for (i = 0; i < irqs; i += 32)
+		writel_relaxed(~0, dist_base + NVIC_ICER + i * 4 / 32);
+
+	/*
+	 * Setup the Linux IRQ subsystem.
+	 */
+	for (i = 0; i < irqs; i++) {
+		irq_set_chip_and_handler(irq_base + i, &nvic_chip,
+				handle_fasteoi_irq);
+		irq_set_chip_data(irq_base + i, &nvic_data);
+		set_irq_flags(irq_base + i, IRQF_VALID | IRQF_PROBE);
+	}
+}
+
+static int __init nvic_of_init(struct device_node *node,
+		struct device_node *parent)
+{
+	void __iomem *dist_base;
+
+	if (WARN_ON(!node))
+		return -ENODEV;
+
+	dist_base = of_iomap(node, 0);
+	WARN(!dist_base, "unable to map nvic dist registers\n");
+
+	nvic_init_bases(node, dist_base);
+
+	return 0;
+}
+IRQCHIP_DECLARE(cortex_m3_nvic, "arm,cortex-m3-nvic", nvic_of_init);
-- 
1.8.2.rc2

