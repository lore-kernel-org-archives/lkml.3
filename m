Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaIOQSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:18:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39509 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753206AbaIOQQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:16:11 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 1/7] clk: at91: add a driver for the h32mx clock
Date: Mon, 15 Sep 2014 18:15:53 +0200
Message-Id: <1410797759-18675-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410797759-18675-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410797759-18675-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer SoCs have two different AHB interconnect. The AHB 32 bits Matrix
interconnect (h32mx) has a clock that can be setup at the half of the h64mx
clock (which is mck). The h32mx clock can not exceed 90 MHz.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
Cc:Mike Turquette <mturquette@linaro.org>

 .../devicetree/bindings/clock/at91-clock.txt       |  15 +++
 arch/arm/mach-at91/Kconfig                         |   3 +
 drivers/clk/at91/Makefile                          |   1 +
 drivers/clk/at91/clk-h32mx.c                       | 123 +++++++++++++++++++++
 drivers/clk/at91/pmc.c                             |   6 +
 drivers/clk/at91/pmc.h                             |   5 +
 include/linux/clk/at91_pmc.h                       |   1 +
 7 files changed, 154 insertions(+)
 create mode 100644 drivers/clk/at91/clk-h32mx.c

diff --git a/Documentation/devicetree/bindings/clock/at91-clock.txt b/Documentation/devicetree/bindings/clock/at91-clock.txt
index b3d544ca522a..40dc2405de7c 100644
--- a/Documentation/devicetree/bindings/clock/at91-clock.txt
+++ b/Documentation/devicetree/bindings/clock/at91-clock.txt
@@ -74,6 +74,9 @@ Required properties:
 	"atmel,at91sam9x5-clk-utmi":
 		at91 utmi clock
 
+	"atmel,sama5d4-clk-h32mx":
+		at91 h32mx clock
+
 Required properties for SCKC node:
 - reg : defines the IO memory reserved for the SCKC.
 - #size-cells : shall be 0 (reg is used to encode clk id).
@@ -447,3 +450,15 @@ For example:
 		#clock-cells = <0>;
 		clocks = <&main>;
 	};
+
+Required properties for 32 bits bus Matrix clock (h32mx clock):
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : shall be the master clock source phandle.
+
+For example:
+	h32ck: h32mxck {
+		#clock-cells = <0>;
+		compatible = "atmel,sama5d4-clk-h32mx";
+		clocks = <&mck>;
+	};
+
diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 6eb3c658761d..fd177956dd56 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -39,6 +39,9 @@ config AT91_SAM9_TIME
 config HAVE_AT91_SMD
 	bool
 
+config HAVE_AT91_H32MX
+	bool
+
 config SOC_AT91SAM9
 	bool
 	select AT91_SAM9_TIME
diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index 4998aee59267..89a48a7bd5df 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -9,3 +9,4 @@ obj-y += clk-system.o clk-peripheral.o clk-programmable.o
 obj-$(CONFIG_HAVE_AT91_UTMI)		+= clk-utmi.o
 obj-$(CONFIG_HAVE_AT91_USB_CLK)		+= clk-usb.o
 obj-$(CONFIG_HAVE_AT91_SMD)		+= clk-smd.o
+obj-$(CONFIG_HAVE_AT91_H32MX)		+= clk-h32mx.o
diff --git a/drivers/clk/at91/clk-h32mx.c b/drivers/clk/at91/clk-h32mx.c
new file mode 100644
index 000000000000..152dcb3f7b5f
--- /dev/null
+++ b/drivers/clk/at91/clk-h32mx.c
@@ -0,0 +1,123 @@
+/*
+ * clk-h32mx.c
+ *
+ *  Copyright (C) 2014 Atmel
+ *
+ * Alexandre Belloni <alexandre.belloni@free-electrons.com>
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
+#include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+
+#include "pmc.h"
+
+#define H32MX_MAX_FREQ	90000000
+
+struct clk_sama5d4_h32mx {
+	struct clk_hw hw;
+	struct at91_pmc *pmc;
+};
+
+#define to_clk_sama5d4_h32mx(hw) container_of(hw, struct clk_sama5d4_h32mx, hw)
+
+static unsigned long clk_sama5d4_h32mx_recalc_rate(struct clk_hw *hw,
+						 unsigned long parent_rate)
+{
+	struct clk_sama5d4_h32mx *h32mxclk = to_clk_sama5d4_h32mx(hw);
+
+	if (pmc_read(h32mxclk->pmc, AT91_PMC_MCKR) & AT91_PMC_H32MXDIV)
+		return parent_rate / 2;
+
+	if (parent_rate > H32MX_MAX_FREQ)
+		pr_warn("H32MX clock is too fast\n");
+	return parent_rate;
+}
+
+static long clk_sama5d4_h32mx_round_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long *parent_rate)
+{
+	unsigned long div;
+
+	if (rate > *parent_rate)
+		return *parent_rate;
+	div = *parent_rate / 2;
+	if (rate < div)
+		return div;
+
+	if (rate - div < *parent_rate - rate)
+		return div;
+
+	return *parent_rate;
+}
+
+static int clk_sama5d4_h32mx_set_rate(struct clk_hw *hw, unsigned long rate,
+				    unsigned long parent_rate)
+{
+	struct clk_sama5d4_h32mx *h32mxclk = to_clk_sama5d4_h32mx(hw);
+	struct at91_pmc *pmc = h32mxclk->pmc;
+	u32 tmp;
+
+	if (parent_rate != rate && (parent_rate / 2) != rate)
+		return -EINVAL;
+
+	pmc_lock(pmc);
+	tmp = pmc_read(pmc, AT91_PMC_MCKR) & ~AT91_PMC_H32MXDIV;
+	if ((parent_rate / 2) == rate)
+		tmp |= AT91_PMC_H32MXDIV;
+	pmc_write(pmc, AT91_PMC_MCKR, tmp);
+	pmc_unlock(pmc);
+
+	return 0;
+}
+
+static const struct clk_ops h32mx_ops = {
+	.recalc_rate = clk_sama5d4_h32mx_recalc_rate,
+	.round_rate = clk_sama5d4_h32mx_round_rate,
+	.set_rate = clk_sama5d4_h32mx_set_rate,
+};
+
+void __init of_sama5d4_clk_h32mx_setup(struct device_node *np,
+				     struct at91_pmc *pmc)
+{
+	struct clk_sama5d4_h32mx *h32mxclk;
+	struct clk_init_data init;
+	const char *parent_name;
+	struct clk *clk;
+
+	h32mxclk = kzalloc(sizeof(*h32mxclk), GFP_KERNEL);
+	if (!h32mxclk)
+		return;
+
+	parent_name = of_clk_get_parent_name(np, 0);
+
+	init.name = np->name;
+	init.ops = &h32mx_ops;
+	init.parent_names = parent_name ? &parent_name : NULL;
+	init.num_parents = parent_name ? 1 : 0;
+	init.flags = CLK_SET_RATE_GATE;
+
+	h32mxclk->hw.init = &init;
+	h32mxclk->pmc = pmc;
+
+	clk = clk_register(NULL, &h32mxclk->hw);
+	if (!clk)
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index 524196bb35a5..386999b4f8eb 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -337,6 +337,12 @@ static const struct of_device_id pmc_clk_ids[] __initconst = {
 		.data = of_at91sam9x5_clk_smd_setup,
 	},
 #endif
+#if defined(CONFIG_HAVE_AT91_H32MX)
+	{
+		.compatible = "atmel,sama5d4-clk-h32mx",
+		.data = of_sama5d4_clk_h32mx_setup,
+	},
+#endif
 	{ /*sentinel*/ }
 };
 
diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index 6c7625976113..52d2041fa3f6 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -120,4 +120,9 @@ extern void __init of_at91sam9x5_clk_smd_setup(struct device_node *np,
 					       struct at91_pmc *pmc);
 #endif
 
+#if defined(CONFIG_HAVE_AT91_SMD)
+extern void __init of_sama5d4_clk_h32mx_setup(struct device_node *np,
+					      struct at91_pmc *pmc);
+#endif
+
 #endif /* __PMC_H_ */
diff --git a/include/linux/clk/at91_pmc.h b/include/linux/clk/at91_pmc.h
index de4268d4987a..c8e3b3d1eded 100644
--- a/include/linux/clk/at91_pmc.h
+++ b/include/linux/clk/at91_pmc.h
@@ -125,6 +125,7 @@ extern void __iomem *at91_pmc_base;
 #define		AT91_PMC_PLLADIV2	(1 << 12)		/* PLLA divisor by 2 [some SAM9 only] */
 #define			AT91_PMC_PLLADIV2_OFF		(0 << 12)
 #define			AT91_PMC_PLLADIV2_ON		(1 << 12)
+#define		AT91_PMC_H32MXDIV	BIT(24)
 
 #define	AT91_PMC_USB		0x38			/* USB Clock Register [some SAM9 only] */
 #define		AT91_PMC_USBS		(0x1 <<  0)		/* USB OHCI Input clock selection */
-- 
1.9.1

