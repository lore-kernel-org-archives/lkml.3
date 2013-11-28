Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336Ab3K1NFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 08:05:25 -0500
Received: from 16.mo6.mail-out.ovh.net ([87.98.139.208]:46671 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751102Ab3K1NFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 08:05:18 -0500
X-Greylist: delayed 1705 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Nov 2013 08:05:17 EST
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH v6 03/16] clk: at91: add PMC base support
Date: Thu, 28 Nov 2013 13:40:08 +0100
Message-Id: <1385642408-6684-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385642184-6467-1-git-send-email-b.brezillon@overkiz.com>
References: <1385642184-6467-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 4158792782798682220
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds at91 PMC (Power Management Controller) base support.

All at91 clocks managed by the PMC unit will use this framework.

This framework provides the following fonctionalities:
- define a new struct at91_pmc to hide PMC internals (lock, PMC memory
  mapping, irq domain, ...)
- read/write helper functions (pmc_read/write) to access PMC registers
- lock/unlock helper functions (pmc_lock/unlock) to lock/unlock access to
  pmc registers
- a new irq domain and its associated irq chip to request PMC specific
  interrupts (useful for clk prepare callbacks)

The PMC unit is declared as a dt clk provider (CLK_OF_DECLARE), and every
clk using this framework will declare a table of of_at91_clk_init_cb_t
and add it to the pmc_clk_ids table.

When the pmc dt clock setup function is called (by of_clk_init function),
it triggers the registration of every supported child clk (those matching
the definitions in pmc_clk_ids).

This patch copies at91_pmc_base (memory mapping) and at91sam9_idle
(function) from arch/arm/mach-at91/clock.c (which is not compiled if
COMMON_CLK_AT91 is enabled).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/clk/Makefile      |    1 +
 drivers/clk/at91/Makefile |    5 +
 drivers/clk/at91/pmc.c    |  304 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/at91/pmc.h    |   61 +++++++++
 4 files changed, 371 insertions(+)
 create mode 100644 drivers/clk/at91/Makefile
 create mode 100644 drivers/clk/at91/pmc.c
 create mode 100644 drivers/clk/at91/pmc.h

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 7b11106..28c2678 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_ARCH_VT8500)	+= clk-vt8500.o
 obj-$(CONFIG_ARCH_ZYNQ)		+= zynq/
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
 obj-$(CONFIG_PLAT_SAMSUNG)	+= samsung/
+obj-$(CONFIG_COMMON_CLK_AT91)	+= at91/
 
 obj-$(CONFIG_X86)		+= x86/
 
diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
new file mode 100644
index 0000000..1d4fb21
--- /dev/null
+++ b/drivers/clk/at91/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for at91 specific clk
+#
+
+obj-y += pmc.o
diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
new file mode 100644
index 0000000..69c116a
--- /dev/null
+++ b/drivers/clk/at91/pmc.c
@@ -0,0 +1,304 @@
+/*
+ *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/clk/at91_pmc.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqchip/chained_irq.h>
+#include <linux/irqdomain.h>
+#include <linux/of_irq.h>
+
+#include <asm/proc-fns.h>
+
+#include "pmc.h"
+
+void __iomem *at91_pmc_base;
+EXPORT_SYMBOL_GPL(at91_pmc_base);
+
+void at91sam9_idle(void)
+{
+	at91_pmc_write(AT91_PMC_SCDR, AT91_PMC_PCK);
+	cpu_do_idle();
+}
+
+int of_at91_get_clk_range(struct device_node *np, const char *propname,
+			  struct clk_range *range)
+{
+	u32 min, max;
+	int ret;
+
+	ret = of_property_read_u32_index(np, propname, 0, &min);
+	if (ret)
+		return ret;
+
+	ret = of_property_read_u32_index(np, propname, 1, &max);
+	if (ret)
+		return ret;
+
+	if (range) {
+		range->min = min;
+		range->max = max;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_at91_get_clk_range);
+
+static void pmc_irq_mask(struct irq_data *d)
+{
+	struct at91_pmc *pmc = irq_data_get_irq_chip_data(d);
+
+	pmc_write(pmc, AT91_PMC_IDR, 1 << d->hwirq);
+}
+
+static void pmc_irq_unmask(struct irq_data *d)
+{
+	struct at91_pmc *pmc = irq_data_get_irq_chip_data(d);
+
+	pmc_write(pmc, AT91_PMC_IER, 1 << d->hwirq);
+}
+
+static int pmc_irq_set_type(struct irq_data *d, unsigned type)
+{
+	if (type != IRQ_TYPE_LEVEL_HIGH) {
+		pr_warn("PMC: type not supported (support only IRQ_TYPE_LEVEL_HIGH type)\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct irq_chip pmc_irq = {
+	.name = "PMC",
+	.irq_disable = pmc_irq_mask,
+	.irq_mask = pmc_irq_mask,
+	.irq_unmask = pmc_irq_unmask,
+	.irq_set_type = pmc_irq_set_type,
+};
+
+static struct lock_class_key pmc_lock_class;
+
+static int pmc_irq_map(struct irq_domain *h, unsigned int virq,
+		       irq_hw_number_t hw)
+{
+	struct at91_pmc	*pmc = h->host_data;
+
+	irq_set_lockdep_class(virq, &pmc_lock_class);
+
+	irq_set_chip_and_handler(virq, &pmc_irq,
+				 handle_level_irq);
+	set_irq_flags(virq, IRQF_VALID);
+	irq_set_chip_data(virq, pmc);
+
+	return 0;
+}
+
+static int pmc_irq_domain_xlate(struct irq_domain *d,
+				struct device_node *ctrlr,
+				const u32 *intspec, unsigned int intsize,
+				irq_hw_number_t *out_hwirq,
+				unsigned int *out_type)
+{
+	struct at91_pmc *pmc = d->host_data;
+	const struct at91_pmc_caps *caps = pmc->caps;
+
+	if (WARN_ON(intsize < 1))
+		return -EINVAL;
+
+	*out_hwirq = intspec[0];
+
+	if (!(caps->available_irqs & (1 << *out_hwirq)))
+		return -EINVAL;
+
+	*out_type = IRQ_TYPE_LEVEL_HIGH;
+
+	return 0;
+}
+
+static struct irq_domain_ops pmc_irq_ops = {
+	.map	= pmc_irq_map,
+	.xlate	= pmc_irq_domain_xlate,
+};
+
+static irqreturn_t pmc_irq_handler(int irq, void *data)
+{
+	struct at91_pmc *pmc = (struct at91_pmc *)data;
+	unsigned long sr;
+	int n;
+
+	sr = pmc_read(pmc, AT91_PMC_SR) & pmc_read(pmc, AT91_PMC_IMR);
+	if (!sr)
+		return IRQ_NONE;
+
+	for_each_set_bit(n, &sr, BITS_PER_LONG)
+		generic_handle_irq(irq_find_mapping(pmc->irqdomain, n));
+
+	return IRQ_HANDLED;
+}
+
+static const struct at91_pmc_caps at91rm9200_caps = {
+	.available_irqs = AT91_PMC_MOSCS | AT91_PMC_LOCKA | AT91_PMC_LOCKB |
+			  AT91_PMC_MCKRDY | AT91_PMC_PCK0RDY |
+			  AT91_PMC_PCK1RDY | AT91_PMC_PCK2RDY |
+			  AT91_PMC_PCK3RDY,
+};
+
+static const struct at91_pmc_caps at91sam9260_caps = {
+	.available_irqs = AT91_PMC_MOSCS | AT91_PMC_LOCKA | AT91_PMC_LOCKB |
+			  AT91_PMC_MCKRDY | AT91_PMC_PCK0RDY |
+			  AT91_PMC_PCK1RDY,
+};
+
+static const struct at91_pmc_caps at91sam9g45_caps = {
+	.available_irqs = AT91_PMC_MOSCS | AT91_PMC_LOCKA | AT91_PMC_MCKRDY |
+			  AT91_PMC_LOCKU | AT91_PMC_PCK0RDY |
+			  AT91_PMC_PCK1RDY,
+};
+
+static const struct at91_pmc_caps at91sam9n12_caps = {
+	.available_irqs = AT91_PMC_MOSCS | AT91_PMC_LOCKA | AT91_PMC_LOCKB |
+			  AT91_PMC_MCKRDY | AT91_PMC_PCK0RDY |
+			  AT91_PMC_PCK1RDY | AT91_PMC_MOSCSELS |
+			  AT91_PMC_MOSCRCS | AT91_PMC_CFDEV,
+};
+
+static const struct at91_pmc_caps at91sam9x5_caps = {
+	.available_irqs = AT91_PMC_MOSCS | AT91_PMC_LOCKA | AT91_PMC_MCKRDY |
+			  AT91_PMC_LOCKU | AT91_PMC_PCK0RDY |
+			  AT91_PMC_PCK1RDY | AT91_PMC_MOSCSELS |
+			  AT91_PMC_MOSCRCS | AT91_PMC_CFDEV,
+};
+
+static const struct at91_pmc_caps sama5d3_caps = {
+	.available_irqs = AT91_PMC_MOSCS | AT91_PMC_LOCKA | AT91_PMC_MCKRDY |
+			  AT91_PMC_LOCKU | AT91_PMC_PCK0RDY |
+			  AT91_PMC_PCK1RDY | AT91_PMC_PCK2RDY |
+			  AT91_PMC_MOSCSELS | AT91_PMC_MOSCRCS |
+			  AT91_PMC_CFDEV,
+};
+
+static struct at91_pmc *__init at91_pmc_init(struct device_node *np,
+					     void __iomem *regbase, int virq,
+					     const struct at91_pmc_caps *caps)
+{
+	struct at91_pmc *pmc;
+
+	if (!regbase || !virq ||  !caps)
+		return NULL;
+
+	at91_pmc_base = regbase;
+
+	pmc = kzalloc(sizeof(*pmc), GFP_KERNEL);
+	if (!pmc)
+		return NULL;
+
+	spin_lock_init(&pmc->lock);
+	pmc->regbase = regbase;
+	pmc->virq = virq;
+	pmc->caps = caps;
+
+	pmc->irqdomain = irq_domain_add_linear(np, 32, &pmc_irq_ops, pmc);
+
+	if (!pmc->irqdomain)
+		goto out_free_pmc;
+
+	pmc_write(pmc, AT91_PMC_IDR, 0xffffffff);
+	if (request_irq(pmc->virq, pmc_irq_handler, IRQF_SHARED, "pmc", pmc))
+		goto out_remove_irqdomain;
+
+	return pmc;
+
+out_remove_irqdomain:
+	irq_domain_remove(pmc->irqdomain);
+out_free_pmc:
+	kfree(pmc);
+
+	return NULL;
+}
+
+static const struct of_device_id pmc_clk_ids[] __initdata = {
+	{ /*sentinel*/ }
+};
+
+static void __init of_at91_pmc_setup(struct device_node *np,
+				     const struct at91_pmc_caps *caps)
+{
+	struct at91_pmc *pmc;
+	struct device_node *childnp;
+	void (*clk_setup)(struct device_node *, struct at91_pmc *);
+	const struct of_device_id *clk_id;
+	void __iomem *regbase = of_iomap(np, 0);
+	int virq;
+
+	if (!regbase)
+		return;
+
+	virq = irq_of_parse_and_map(np, 0);
+	if (!virq)
+		return;
+
+	pmc = at91_pmc_init(np, regbase, virq, caps);
+	if (!pmc)
+		return;
+	for_each_child_of_node(np, childnp) {
+		clk_id = of_match_node(pmc_clk_ids, childnp);
+		if (!clk_id)
+			continue;
+		clk_setup = clk_id->data;
+		clk_setup(childnp, pmc);
+	}
+}
+
+static void __init of_at91rm9200_pmc_setup(struct device_node *np)
+{
+	of_at91_pmc_setup(np, &at91rm9200_caps);
+}
+CLK_OF_DECLARE(at91rm9200_clk_pmc, "atmel,at91rm9200-pmc",
+	       of_at91rm9200_pmc_setup);
+
+static void __init of_at91sam9260_pmc_setup(struct device_node *np)
+{
+	of_at91_pmc_setup(np, &at91sam9260_caps);
+}
+CLK_OF_DECLARE(at91sam9260_clk_pmc, "atmel,at91sam9260-pmc",
+	       of_at91sam9260_pmc_setup);
+
+static void __init of_at91sam9g45_pmc_setup(struct device_node *np)
+{
+	of_at91_pmc_setup(np, &at91sam9g45_caps);
+}
+CLK_OF_DECLARE(at91sam9g45_clk_pmc, "atmel,at91sam9g45-pmc",
+	       of_at91sam9g45_pmc_setup);
+
+static void __init of_at91sam9n12_pmc_setup(struct device_node *np)
+{
+	of_at91_pmc_setup(np, &at91sam9n12_caps);
+}
+CLK_OF_DECLARE(at91sam9n12_clk_pmc, "atmel,at91sam9n12-pmc",
+	       of_at91sam9n12_pmc_setup);
+
+static void __init of_at91sam9x5_pmc_setup(struct device_node *np)
+{
+	of_at91_pmc_setup(np, &at91sam9x5_caps);
+}
+CLK_OF_DECLARE(at91sam9x5_clk_pmc, "atmel,at91sam9x5-pmc",
+	       of_at91sam9x5_pmc_setup);
+
+static void __init of_sama5d3_pmc_setup(struct device_node *np)
+{
+	of_at91_pmc_setup(np, &sama5d3_caps);
+}
+CLK_OF_DECLARE(sama5d3_clk_pmc, "atmel,sama5d3-pmc",
+	       of_sama5d3_pmc_setup);
diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
new file mode 100644
index 0000000..d92b946
--- /dev/null
+++ b/drivers/clk/at91/pmc.h
@@ -0,0 +1,61 @@
+/*
+ * drivers/clk/at91/pmc.h
+ *
+ *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __PMC_H_
+#define __PMC_H_
+
+#include <linux/io.h>
+#include <linux/irqdomain.h>
+#include <linux/spinlock.h>
+
+struct clk_range {
+	unsigned long min;
+	unsigned long max;
+};
+
+#define CLK_RANGE(MIN, MAX) {.min = MIN, .max = MAX,}
+
+struct at91_pmc_caps {
+	u32 available_irqs;
+};
+
+struct at91_pmc {
+	void __iomem *regbase;
+	int virq;
+	spinlock_t lock;
+	const struct at91_pmc_caps *caps;
+	struct irq_domain *irqdomain;
+};
+
+static inline void pmc_lock(struct at91_pmc *pmc)
+{
+	spin_lock(&pmc->lock);
+}
+
+static inline void pmc_unlock(struct at91_pmc *pmc)
+{
+	spin_unlock(&pmc->lock);
+}
+
+static inline u32 pmc_read(struct at91_pmc *pmc, int offset)
+{
+	return readl(pmc->regbase + offset);
+}
+
+static inline void pmc_write(struct at91_pmc *pmc, int offset, u32 value)
+{
+	writel(value, pmc->regbase + offset);
+}
+
+int of_at91_get_clk_range(struct device_node *np, const char *propname,
+			  struct clk_range *range);
+
+#endif /* __PMC_H_ */
-- 
1.7.9.5

