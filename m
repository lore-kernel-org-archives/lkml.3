Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab3K1MnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 07:43:12 -0500
Received: from 2.mo6.mail-out.ovh.net ([46.105.76.65]:57116 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754912Ab3K1MnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 07:43:08 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH v6 05/16] clk: at91: add PMC main clock
Date: Thu, 28 Nov 2013 13:42:43 +0100
Message-Id: <1385642563-6763-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385642184-6467-1-git-send-email-b.brezillon@overkiz.com>
References: <1385642184-6467-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 4202421402381285484
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

This patch adds new at91 main oscillator clock implementation using common
clk framework.

If rate is not provided during clock registration it is calculated using
the slow clock (main clk parent in this case) rate and MCFR register.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/clk/at91/Makefile   |    1 +
 drivers/clk/at91/clk-main.c |  187 +++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/at91/pmc.c      |    5 ++
 drivers/clk/at91/pmc.h      |    3 +
 4 files changed, 196 insertions(+)
 create mode 100644 drivers/clk/at91/clk-main.c

diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index 1d4fb21..44105bd 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-y += pmc.o
+obj-y += clk-main.o
diff --git a/drivers/clk/at91/clk-main.c b/drivers/clk/at91/clk-main.c
new file mode 100644
index 0000000..8e9e8cc
--- /dev/null
+++ b/drivers/clk/at91/clk-main.c
@@ -0,0 +1,187 @@
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
+#define SLOW_CLOCK_FREQ		32768
+#define MAINF_DIV		16
+#define MAINFRDY_TIMEOUT	(((MAINF_DIV + 1) * USEC_PER_SEC) / \
+				 SLOW_CLOCK_FREQ)
+#define MAINF_LOOP_MIN_WAIT	(USEC_PER_SEC / SLOW_CLOCK_FREQ)
+#define MAINF_LOOP_MAX_WAIT	MAINFRDY_TIMEOUT
+
+struct clk_main {
+	struct clk_hw hw;
+	struct at91_pmc *pmc;
+	unsigned long rate;
+	unsigned int irq;
+	wait_queue_head_t wait;
+};
+
+#define to_clk_main(hw) container_of(hw, struct clk_main, hw)
+
+static irqreturn_t clk_main_irq_handler(int irq, void *dev_id)
+{
+	struct clk_main *clkmain = (struct clk_main *)dev_id;
+
+	wake_up(&clkmain->wait);
+	disable_irq_nosync(clkmain->irq);
+
+	return IRQ_HANDLED;
+}
+
+static int clk_main_prepare(struct clk_hw *hw)
+{
+	struct clk_main *clkmain = to_clk_main(hw);
+	struct at91_pmc *pmc = clkmain->pmc;
+	unsigned long halt_time, timeout;
+	u32 tmp;
+
+	while (!(pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_MOSCS)) {
+		enable_irq(clkmain->irq);
+		wait_event(clkmain->wait,
+			   pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_MOSCS);
+	}
+
+	if (clkmain->rate)
+		return 0;
+
+	timeout = jiffies + usecs_to_jiffies(MAINFRDY_TIMEOUT);
+	do {
+		halt_time = jiffies;
+		tmp = pmc_read(pmc, AT91_CKGR_MCFR);
+		if (tmp & AT91_PMC_MAINRDY)
+			return 0;
+		usleep_range(MAINF_LOOP_MIN_WAIT, MAINF_LOOP_MAX_WAIT);
+	} while (time_before(halt_time, timeout));
+
+	return 0;
+}
+
+static int clk_main_is_prepared(struct clk_hw *hw)
+{
+	struct clk_main *clkmain = to_clk_main(hw);
+
+	return !!(pmc_read(clkmain->pmc, AT91_PMC_SR) & AT91_PMC_MOSCS);
+}
+
+static unsigned long clk_main_recalc_rate(struct clk_hw *hw,
+					  unsigned long parent_rate)
+{
+	u32 tmp;
+	struct clk_main *clkmain = to_clk_main(hw);
+	struct at91_pmc *pmc = clkmain->pmc;
+
+	if (clkmain->rate)
+		return clkmain->rate;
+
+	tmp = pmc_read(pmc, AT91_CKGR_MCFR) & AT91_PMC_MAINF;
+	clkmain->rate = (tmp * parent_rate) / MAINF_DIV;
+
+	return clkmain->rate;
+}
+
+static const struct clk_ops main_ops = {
+	.prepare = clk_main_prepare,
+	.is_prepared = clk_main_is_prepared,
+	.recalc_rate = clk_main_recalc_rate,
+};
+
+static struct clk * __init
+at91_clk_register_main(struct at91_pmc *pmc,
+		       unsigned int irq,
+		       const char *name,
+		       const char *parent_name,
+		       unsigned long rate)
+{
+	int ret;
+	struct clk_main *clkmain;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	if (!pmc || !irq || !name)
+		return ERR_PTR(-EINVAL);
+
+	if (!rate && !parent_name)
+		return ERR_PTR(-EINVAL);
+
+	clkmain = kzalloc(sizeof(*clkmain), GFP_KERNEL);
+	if (!clkmain)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &main_ops;
+	init.parent_names = parent_name ? &parent_name : NULL;
+	init.num_parents = parent_name ? 1 : 0;
+	init.flags = parent_name ? 0 : CLK_IS_ROOT;
+
+	clkmain->hw.init = &init;
+	clkmain->rate = rate;
+	clkmain->pmc = pmc;
+	clkmain->irq = irq;
+	init_waitqueue_head(&clkmain->wait);
+	irq_set_status_flags(clkmain->irq, IRQ_NOAUTOEN);
+	ret = request_irq(clkmain->irq, clk_main_irq_handler,
+			  IRQF_TRIGGER_HIGH, "clk-main", clkmain);
+	if (ret)
+		return ERR_PTR(ret);
+
+	clk = clk_register(NULL, &clkmain->hw);
+	if (IS_ERR(clk)) {
+		free_irq(clkmain->irq, clkmain);
+		kfree(clkmain);
+	}
+
+	return clk;
+}
+
+
+
+static void __init
+of_at91_clk_main_setup(struct device_node *np, struct at91_pmc *pmc)
+{
+	struct clk *clk;
+	unsigned int irq;
+	const char *parent_name;
+	const char *name = np->name;
+	u32 rate = 0;
+
+	parent_name = of_clk_get_parent_name(np, 0);
+	of_property_read_string(np, "clock-output-names", &name);
+	of_property_read_u32(np, "clock-frequency", &rate);
+	irq = irq_of_parse_and_map(np, 0);
+	if (!irq)
+		return;
+
+	clk = at91_clk_register_main(pmc, irq, name, parent_name, rate);
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
+
+void __init of_at91rm9200_clk_main_setup(struct device_node *np,
+					 struct at91_pmc *pmc)
+{
+	of_at91_clk_main_setup(np, pmc);
+}
diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index 69c116a..3d35b73 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -229,6 +229,11 @@ out_free_pmc:
 }
 
 static const struct of_device_id pmc_clk_ids[] __initdata = {
+	/* Main clock */
+	{
+		.compatible = "atmel,at91rm9200-clk-main",
+		.data = of_at91rm9200_clk_main_setup,
+	},
 	{ /*sentinel*/ }
 };
 
diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index d92b946..729aa46 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -58,4 +58,7 @@ static inline void pmc_write(struct at91_pmc *pmc, int offset, u32 value)
 int of_at91_get_clk_range(struct device_node *np, const char *propname,
 			  struct clk_range *range);
 
+extern void __init of_at91rm9200_clk_main_setup(struct device_node *np,
+						struct at91_pmc *pmc);
+
 #endif /* __PMC_H_ */
-- 
1.7.9.5

