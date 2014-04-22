Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaDVNNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:13:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48439 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751591AbaDVNMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:12:47 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 01/11] clk: at91: rework main clk implementation
Date: Tue, 22 Apr 2014 15:12:30 +0200
Message-Id: <1398172360-7837-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398172360-7837-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1398172360-7837-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AT91 main clk is a clk multiplexer and not a simple fixed rate clk as
currently implemented.

In some SoCs (sam9x5, sama5, sam9g45 families) this multiplexer can
choose among 2 sources: an internal RC oscillator circuit and an
oscillator using an external crystal.

In other Socs (sam9260, rm9200 families) the multiplexer source is
hardcoded to the external crystal oscillator.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/clk/at91/clk-main.c | 577 +++++++++++++++++++++++++++++++++++++++-----
 drivers/clk/at91/pmc.c      |  12 +
 drivers/clk/at91/pmc.h      |   6 +
 3 files changed, 532 insertions(+), 63 deletions(-)

diff --git a/drivers/clk/at91/clk-main.c b/drivers/clk/at91/clk-main.c
index 8e9e8cc..bc2b98e 100644
--- a/drivers/clk/at91/clk-main.c
+++ b/drivers/clk/at91/clk-main.c
@@ -30,99 +30,546 @@
 #define MAINF_LOOP_MIN_WAIT	(USEC_PER_SEC / SLOW_CLOCK_FREQ)
 #define MAINF_LOOP_MAX_WAIT	MAINFRDY_TIMEOUT
 
-struct clk_main {
+#define MOR_KEY_MASK		(0xff << 16)
+
+struct clk_main_osc {
 	struct clk_hw hw;
 	struct at91_pmc *pmc;
-	unsigned long rate;
 	unsigned int irq;
 	wait_queue_head_t wait;
 };
 
-#define to_clk_main(hw) container_of(hw, struct clk_main, hw)
+#define to_clk_main_osc(hw) container_of(hw, struct clk_main_osc, hw)
+
+struct clk_main_rc_osc {
+	struct clk_hw hw;
+	struct at91_pmc *pmc;
+	unsigned int irq;
+	wait_queue_head_t wait;
+	unsigned long frequency;
+	unsigned long accuracy;
+};
+
+#define to_clk_main_rc_osc(hw) container_of(hw, struct clk_main_rc_osc, hw)
+
+struct clk_rm9200_main {
+	struct clk_hw hw;
+	struct at91_pmc *pmc;
+};
+
+#define to_clk_rm9200_main(hw) container_of(hw, struct clk_rm9200_main, hw)
 
-static irqreturn_t clk_main_irq_handler(int irq, void *dev_id)
+struct clk_sam9x5_main {
+	struct clk_hw hw;
+	struct at91_pmc *pmc;
+	unsigned int irq;
+	wait_queue_head_t wait;
+	u8 parent;
+};
+
+#define to_clk_sam9x5_main(hw) container_of(hw, struct clk_sam9x5_main, hw)
+
+static irqreturn_t clk_main_osc_irq_handler(int irq, void *dev_id)
 {
-	struct clk_main *clkmain = (struct clk_main *)dev_id;
+	struct clk_main_osc *osc = dev_id;
 
-	wake_up(&clkmain->wait);
-	disable_irq_nosync(clkmain->irq);
+	wake_up(&osc->wait);
+	disable_irq_nosync(osc->irq);
 
 	return IRQ_HANDLED;
 }
 
-static int clk_main_prepare(struct clk_hw *hw)
+static int clk_main_osc_prepare(struct clk_hw *hw)
 {
-	struct clk_main *clkmain = to_clk_main(hw);
-	struct at91_pmc *pmc = clkmain->pmc;
-	unsigned long halt_time, timeout;
+	struct clk_main_osc *osc = to_clk_main_osc(hw);
+	struct at91_pmc *pmc = osc->pmc;
 	u32 tmp;
 
+	tmp = pmc_read(pmc, AT91_CKGR_MOR) & ~MOR_KEY_MASK;
+	if (tmp & AT91_PMC_OSCBYPASS)
+		return 0;
+
+	if (!(tmp & AT91_PMC_MOSCEN)) {
+		tmp |= AT91_PMC_MOSCEN | AT91_PMC_KEY;
+		pmc_write(pmc, AT91_CKGR_MOR, tmp);
+	}
+
 	while (!(pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_MOSCS)) {
-		enable_irq(clkmain->irq);
-		wait_event(clkmain->wait,
+		enable_irq(osc->irq);
+		wait_event(osc->wait,
 			   pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_MOSCS);
 	}
 
-	if (clkmain->rate)
-		return 0;
+	return 0;
+}
+
+static void clk_main_osc_unprepare(struct clk_hw *hw)
+{
+	struct clk_main_osc *osc = to_clk_main_osc(hw);
+	struct at91_pmc *pmc = osc->pmc;
+	u32 tmp = pmc_read(pmc, AT91_CKGR_MOR);
+
+	if (tmp & AT91_PMC_OSCBYPASS)
+		return;
+
+	if (!(tmp & AT91_PMC_MOSCEN))
+		return;
+
+	tmp &= ~(AT91_PMC_KEY | AT91_PMC_MOSCEN);
+	pmc_write(pmc, AT91_CKGR_MOR, tmp | AT91_PMC_KEY);
+}
+
+static int clk_main_osc_is_prepared(struct clk_hw *hw)
+{
+	struct clk_main_osc *osc = to_clk_main_osc(hw);
+	struct at91_pmc *pmc = osc->pmc;
+	u32 tmp = pmc_read(pmc, AT91_CKGR_MOR);
+
+	if (tmp & AT91_PMC_OSCBYPASS)
+		return 1;
+
+	return !!((pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_MOSCS) &&
+		  (pmc_read(pmc, AT91_CKGR_MOR) & AT91_PMC_MOSCEN));
+}
+
+static const struct clk_ops main_osc_ops = {
+	.prepare = clk_main_osc_prepare,
+	.unprepare = clk_main_osc_unprepare,
+	.is_prepared = clk_main_osc_is_prepared,
+};
+
+static struct clk * __init
+at91_clk_register_main_osc(struct at91_pmc *pmc,
+			   unsigned int irq,
+			   const char *name,
+			   const char *parent_name,
+			   bool bypass)
+{
+	int ret;
+	struct clk_main_osc *osc;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	if (!pmc || !irq || !name || !parent_name)
+		return ERR_PTR(-EINVAL);
+
+	osc = kzalloc(sizeof(*osc), GFP_KERNEL);
+	if (!osc)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &main_osc_ops;
+	init.parent_names = &parent_name;
+	init.num_parents = 1;
+	init.flags = 0;
+
+	osc->hw.init = &init;
+	osc->pmc = pmc;
+	osc->irq = irq;
+
+	init_waitqueue_head(&osc->wait);
+	irq_set_status_flags(osc->irq, IRQ_NOAUTOEN);
+	ret = request_irq(osc->irq, clk_main_osc_irq_handler,
+			  IRQF_TRIGGER_HIGH, name, osc);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (bypass)
+		pmc_write(pmc, AT91_CKGR_MOR,
+			  (pmc_read(pmc, AT91_CKGR_MOR) &
+			   ~(MOR_KEY_MASK | AT91_PMC_MOSCEN)) |
+			  AT91_PMC_OSCBYPASS | AT91_PMC_KEY);
+
+	clk = clk_register(NULL, &osc->hw);
+	if (IS_ERR(clk)) {
+		free_irq(irq, osc);
+		kfree(osc);
+	}
+
+	return clk;
+}
+
+void __init of_at91rm9200_clk_main_osc_setup(struct device_node *np,
+					     struct at91_pmc *pmc)
+{
+	struct clk *clk;
+	unsigned int irq;
+	const char *name = np->name;
+	const char *parent_name;
+	bool bypass;
+
+	of_property_read_string(np, "clock-output-names", &name);
+	bypass = of_property_read_bool(np, "atmel,osc-bypass");
+	parent_name = of_clk_get_parent_name(np, 0);
+
+	irq = irq_of_parse_and_map(np, 0);
+	if (!irq)
+		return;
+
+	clk = at91_clk_register_main_osc(pmc, irq, name, parent_name, bypass);
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
+
+static irqreturn_t clk_main_rc_osc_irq_handler(int irq, void *dev_id)
+{
+	struct clk_main_rc_osc *osc = dev_id;
+
+	wake_up(&osc->wait);
+	disable_irq_nosync(osc->irq);
+
+	return IRQ_HANDLED;
+}
+
+static int clk_main_rc_osc_prepare(struct clk_hw *hw)
+{
+	struct clk_main_rc_osc *osc = to_clk_main_rc_osc(hw);
+	struct at91_pmc *pmc = osc->pmc;
+	u32 tmp;
+
+	tmp = pmc_read(pmc, AT91_CKGR_MOR) & ~MOR_KEY_MASK;
+
+	if (!(tmp & AT91_PMC_MOSCRCEN)) {
+		tmp |= AT91_PMC_MOSCRCEN | AT91_PMC_KEY;
+		pmc_write(pmc, AT91_CKGR_MOR, tmp);
+	}
+
+	while (!(pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_MOSCRCS)) {
+		enable_irq(osc->irq);
+		wait_event(osc->wait,
+			   pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_MOSCRCS);
+	}
+
+	return 0;
+}
+
+static void clk_main_rc_osc_unprepare(struct clk_hw *hw)
+{
+	struct clk_main_rc_osc *osc = to_clk_main_rc_osc(hw);
+	struct at91_pmc *pmc = osc->pmc;
+	u32 tmp = pmc_read(pmc, AT91_CKGR_MOR);
+
+	if (!(tmp & AT91_PMC_MOSCRCEN))
+		return;
+
+	tmp &= ~(MOR_KEY_MASK | AT91_PMC_MOSCRCEN);
+	pmc_write(pmc, AT91_CKGR_MOR, tmp | AT91_PMC_KEY);
+}
+
+static int clk_main_rc_osc_is_prepared(struct clk_hw *hw)
+{
+	struct clk_main_rc_osc *osc = to_clk_main_rc_osc(hw);
+	struct at91_pmc *pmc = osc->pmc;
+
+	return !!((pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_MOSCRCS) &&
+		  (pmc_read(pmc, AT91_CKGR_MOR) & AT91_PMC_MOSCRCEN));
+}
+
+static unsigned long clk_main_rc_osc_recalc_rate(struct clk_hw *hw,
+						 unsigned long parent_rate)
+{
+	struct clk_main_rc_osc *osc = to_clk_main_rc_osc(hw);
+
+	return osc->frequency;
+}
+
+static unsigned long clk_main_rc_osc_recalc_accuracy(struct clk_hw *hw,
+						     unsigned long parent_acc)
+{
+	struct clk_main_rc_osc *osc = to_clk_main_rc_osc(hw);
+
+	return osc->accuracy;
+}
+
+static const struct clk_ops main_rc_osc_ops = {
+	.prepare = clk_main_rc_osc_prepare,
+	.unprepare = clk_main_rc_osc_unprepare,
+	.is_prepared = clk_main_rc_osc_is_prepared,
+	.recalc_rate = clk_main_rc_osc_recalc_rate,
+	.recalc_accuracy = clk_main_rc_osc_recalc_accuracy,
+};
+
+static struct clk * __init
+at91_clk_register_main_rc_osc(struct at91_pmc *pmc,
+			      unsigned int irq,
+			      const char *name,
+			      u32 frequency, u32 accuracy)
+{
+	int ret;
+	struct clk_main_rc_osc *osc;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	if (!pmc || !irq || !name || !frequency)
+		return ERR_PTR(-EINVAL);
+
+	osc = kzalloc(sizeof(*osc), GFP_KERNEL);
+	if (!osc)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &main_rc_osc_ops;
+	init.parent_names = NULL;
+	init.num_parents = 0;
+	init.flags = CLK_IS_ROOT;
+
+	osc->hw.init = &init;
+	osc->pmc = pmc;
+	osc->irq = irq;
+	osc->frequency = frequency;
+	osc->accuracy = accuracy;
+
+	init_waitqueue_head(&osc->wait);
+	irq_set_status_flags(osc->irq, IRQ_NOAUTOEN);
+	ret = request_irq(osc->irq, clk_main_rc_osc_irq_handler,
+			  IRQF_TRIGGER_HIGH, name, osc);
+	if (ret)
+		return ERR_PTR(ret);
+
+	clk = clk_register(NULL, &osc->hw);
+	if (IS_ERR(clk)) {
+		free_irq(irq, osc);
+		kfree(osc);
+	}
+
+	return clk;
+}
+
+void __init of_at91sam9x5_clk_main_rc_osc_setup(struct device_node *np,
+						struct at91_pmc *pmc)
+{
+	struct clk *clk;
+	unsigned int irq;
+	u32 frequency = 0;
+	u32 accuracy = 0;
+	const char *name = np->name;
+
+	of_property_read_string(np, "clock-output-names", &name);
+	of_property_read_u32(np, "clock-frequency", &frequency);
+	of_property_read_u32(np, "clock-accuracy", &accuracy);
+
+	irq = irq_of_parse_and_map(np, 0);
+	if (!irq)
+		return;
+
+	clk = at91_clk_register_main_rc_osc(pmc, irq, name, frequency,
+					    accuracy);
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
+
+
+static int clk_main_probe_frequency(struct at91_pmc *pmc)
+{
+	unsigned long prep_time, timeout;
+	u32 tmp;
 
 	timeout = jiffies + usecs_to_jiffies(MAINFRDY_TIMEOUT);
 	do {
-		halt_time = jiffies;
+		prep_time = jiffies;
 		tmp = pmc_read(pmc, AT91_CKGR_MCFR);
 		if (tmp & AT91_PMC_MAINRDY)
 			return 0;
 		usleep_range(MAINF_LOOP_MIN_WAIT, MAINF_LOOP_MAX_WAIT);
-	} while (time_before(halt_time, timeout));
+	} while (time_before(prep_time, timeout));
 
-	return 0;
+	return -ETIMEDOUT;
 }
 
-static int clk_main_is_prepared(struct clk_hw *hw)
+static unsigned long clk_main_recalc_rate(struct at91_pmc *pmc,
+					  unsigned long parent_rate)
 {
-	struct clk_main *clkmain = to_clk_main(hw);
+	u32 tmp;
+
+	if (parent_rate)
+		return parent_rate;
+
+	tmp = pmc_read(pmc, AT91_CKGR_MCFR);
+	if (!(tmp & AT91_PMC_MAINRDY))
+		return 0;
 
-	return !!(pmc_read(clkmain->pmc, AT91_PMC_SR) & AT91_PMC_MOSCS);
+	return ((tmp & AT91_PMC_MAINF) * SLOW_CLOCK_FREQ) / MAINF_DIV;
 }
 
-static unsigned long clk_main_recalc_rate(struct clk_hw *hw,
-					  unsigned long parent_rate)
+static int clk_rm9200_main_prepare(struct clk_hw *hw)
 {
-	u32 tmp;
-	struct clk_main *clkmain = to_clk_main(hw);
+	struct clk_rm9200_main *clkmain = to_clk_rm9200_main(hw);
+
+	return clk_main_probe_frequency(clkmain->pmc);
+}
+
+static int clk_rm9200_main_is_prepared(struct clk_hw *hw)
+{
+	struct clk_rm9200_main *clkmain = to_clk_rm9200_main(hw);
+
+	return !!(pmc_read(clkmain->pmc, AT91_CKGR_MCFR) & AT91_PMC_MAINRDY);
+}
+
+static unsigned long clk_rm9200_main_recalc_rate(struct clk_hw *hw,
+						 unsigned long parent_rate)
+{
+	struct clk_rm9200_main *clkmain = to_clk_rm9200_main(hw);
+
+	return clk_main_recalc_rate(clkmain->pmc, parent_rate);
+}
+
+static const struct clk_ops rm9200_main_ops = {
+	.prepare = clk_rm9200_main_prepare,
+	.is_prepared = clk_rm9200_main_is_prepared,
+	.recalc_rate = clk_rm9200_main_recalc_rate,
+};
+
+static struct clk * __init
+at91_clk_register_rm9200_main(struct at91_pmc *pmc,
+			      const char *name,
+			      const char *parent_name)
+{
+	struct clk_rm9200_main *clkmain;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	if (!pmc || !name)
+		return ERR_PTR(-EINVAL);
+
+	if (!parent_name)
+		return ERR_PTR(-EINVAL);
+
+	clkmain = kzalloc(sizeof(*clkmain), GFP_KERNEL);
+	if (!clkmain)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &rm9200_main_ops;
+	init.parent_names = &parent_name;
+	init.num_parents = 1;
+	init.flags = 0;
+
+	clkmain->hw.init = &init;
+	clkmain->pmc = pmc;
+
+	clk = clk_register(NULL, &clkmain->hw);
+	if (IS_ERR(clk))
+		kfree(clkmain);
+
+	return clk;
+}
+
+void __init of_at91rm9200_clk_main_setup(struct device_node *np,
+					 struct at91_pmc *pmc)
+{
+	struct clk *clk;
+	const char *parent_name;
+	const char *name = np->name;
+
+	parent_name = of_clk_get_parent_name(np, 0);
+	of_property_read_string(np, "clock-output-names", &name);
+
+	clk = at91_clk_register_rm9200_main(pmc, name, parent_name);
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
+
+static irqreturn_t clk_sam9x5_main_irq_handler(int irq, void *dev_id)
+{
+	struct clk_sam9x5_main *clkmain = dev_id;
+
+	wake_up(&clkmain->wait);
+	disable_irq_nosync(clkmain->irq);
+
+	return IRQ_HANDLED;
+}
+
+static int clk_sam9x5_main_prepare(struct clk_hw *hw)
+{
+	struct clk_sam9x5_main *clkmain = to_clk_sam9x5_main(hw);
 	struct at91_pmc *pmc = clkmain->pmc;
 
-	if (clkmain->rate)
-		return clkmain->rate;
+	while (!(pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_MOSCSELS)) {
+		enable_irq(clkmain->irq);
+		wait_event(clkmain->wait,
+			   pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_MOSCSELS);
+	}
+
+	return clk_main_probe_frequency(pmc);
+}
 
-	tmp = pmc_read(pmc, AT91_CKGR_MCFR) & AT91_PMC_MAINF;
-	clkmain->rate = (tmp * parent_rate) / MAINF_DIV;
+static int clk_sam9x5_main_is_prepared(struct clk_hw *hw)
+{
+	struct clk_sam9x5_main *clkmain = to_clk_sam9x5_main(hw);
 
-	return clkmain->rate;
+	return !!(pmc_read(clkmain->pmc, AT91_PMC_SR) & AT91_PMC_MOSCSELS);
 }
 
-static const struct clk_ops main_ops = {
-	.prepare = clk_main_prepare,
-	.is_prepared = clk_main_is_prepared,
-	.recalc_rate = clk_main_recalc_rate,
+static unsigned long clk_sam9x5_main_recalc_rate(struct clk_hw *hw,
+						 unsigned long parent_rate)
+{
+	struct clk_sam9x5_main *clkmain = to_clk_sam9x5_main(hw);
+
+	return clk_main_recalc_rate(clkmain->pmc, parent_rate);
+}
+
+static int clk_sam9x5_main_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct clk_sam9x5_main *clkmain = to_clk_sam9x5_main(hw);
+	struct at91_pmc *pmc = clkmain->pmc;
+	u32 tmp;
+
+	if (index > 1)
+		return -EINVAL;
+
+	tmp = pmc_read(pmc, AT91_CKGR_MOR) & ~MOR_KEY_MASK;
+
+	if (index && !(tmp & AT91_PMC_MOSCSEL))
+		pmc_write(pmc, AT91_CKGR_MOR, tmp | AT91_PMC_MOSCSEL);
+	else if (!index && (tmp & AT91_PMC_MOSCSEL))
+		pmc_write(pmc, AT91_CKGR_MOR, tmp & ~AT91_PMC_MOSCSEL);
+
+	while (!(pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_MOSCSELS)) {
+		enable_irq(clkmain->irq);
+		wait_event(clkmain->wait,
+			   pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_MOSCSELS);
+	}
+
+	return 0;
+}
+
+static u8 clk_sam9x5_main_get_parent(struct clk_hw *hw)
+{
+	struct clk_sam9x5_main *clkmain = to_clk_sam9x5_main(hw);
+
+	return !!(pmc_read(clkmain->pmc, AT91_CKGR_MOR) & AT91_PMC_MOSCEN);
+}
+
+static const struct clk_ops sam9x5_main_ops = {
+	.prepare = clk_sam9x5_main_prepare,
+	.is_prepared = clk_sam9x5_main_is_prepared,
+	.recalc_rate = clk_sam9x5_main_recalc_rate,
+	.set_parent = clk_sam9x5_main_set_parent,
+	.get_parent = clk_sam9x5_main_get_parent,
 };
 
 static struct clk * __init
-at91_clk_register_main(struct at91_pmc *pmc,
-		       unsigned int irq,
-		       const char *name,
-		       const char *parent_name,
-		       unsigned long rate)
+at91_clk_register_sam9x5_main(struct at91_pmc *pmc,
+			      unsigned int irq,
+			      const char *name,
+			      const char **parent_names,
+			      int num_parents)
 {
 	int ret;
-	struct clk_main *clkmain;
+	struct clk_sam9x5_main *clkmain;
 	struct clk *clk = NULL;
 	struct clk_init_data init;
 
 	if (!pmc || !irq || !name)
 		return ERR_PTR(-EINVAL);
 
-	if (!rate && !parent_name)
+	if (!parent_names || !num_parents)
 		return ERR_PTR(-EINVAL);
 
 	clkmain = kzalloc(sizeof(*clkmain), GFP_KERNEL);
@@ -130,19 +577,20 @@ at91_clk_register_main(struct at91_pmc *pmc,
 		return ERR_PTR(-ENOMEM);
 
 	init.name = name;
-	init.ops = &main_ops;
-	init.parent_names = parent_name ? &parent_name : NULL;
-	init.num_parents = parent_name ? 1 : 0;
-	init.flags = parent_name ? 0 : CLK_IS_ROOT;
+	init.ops = &sam9x5_main_ops;
+	init.parent_names = parent_names;
+	init.num_parents = num_parents;
+	init.flags = CLK_SET_PARENT_GATE;
 
 	clkmain->hw.init = &init;
-	clkmain->rate = rate;
 	clkmain->pmc = pmc;
 	clkmain->irq = irq;
+	clkmain->parent = !!(pmc_read(clkmain->pmc, AT91_CKGR_MOR) &
+			     AT91_PMC_MOSCEN);
 	init_waitqueue_head(&clkmain->wait);
 	irq_set_status_flags(clkmain->irq, IRQ_NOAUTOEN);
-	ret = request_irq(clkmain->irq, clk_main_irq_handler,
-			  IRQF_TRIGGER_HIGH, "clk-main", clkmain);
+	ret = request_irq(clkmain->irq, clk_sam9x5_main_irq_handler,
+			  IRQF_TRIGGER_HIGH, name, clkmain);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -155,33 +603,36 @@ at91_clk_register_main(struct at91_pmc *pmc,
 	return clk;
 }
 
-
-
-static void __init
-of_at91_clk_main_setup(struct device_node *np, struct at91_pmc *pmc)
+void __init of_at91sam9x5_clk_main_setup(struct device_node *np,
+					 struct at91_pmc *pmc)
 {
 	struct clk *clk;
+	const char *parent_names[2];
+	int num_parents;
 	unsigned int irq;
-	const char *parent_name;
 	const char *name = np->name;
-	u32 rate = 0;
+	int i;
+
+	num_parents = of_count_phandle_with_args(np, "clocks", "#clock-cells");
+	if (num_parents <= 0 || num_parents > 2)
+		return;
+
+	for (i = 0; i < num_parents; ++i) {
+		parent_names[i] = of_clk_get_parent_name(np, i);
+		if (!parent_names[i])
+			return;
+	}
 
-	parent_name = of_clk_get_parent_name(np, 0);
 	of_property_read_string(np, "clock-output-names", &name);
-	of_property_read_u32(np, "clock-frequency", &rate);
+
 	irq = irq_of_parse_and_map(np, 0);
 	if (!irq)
 		return;
 
-	clk = at91_clk_register_main(pmc, irq, name, parent_name, rate);
+	clk = at91_clk_register_sam9x5_main(pmc, irq, name, parent_names,
+					    num_parents);
 	if (IS_ERR(clk))
 		return;
 
 	of_clk_add_provider(np, of_clk_src_simple_get, clk);
 }
-
-void __init of_at91rm9200_clk_main_setup(struct device_node *np,
-					 struct at91_pmc *pmc)
-{
-	of_at91_clk_main_setup(np, pmc);
-}
diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index 6a61477..dc5fdde 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -231,9 +231,21 @@ out_free_pmc:
 static const struct of_device_id pmc_clk_ids[] __initconst = {
 	/* Main clock */
 	{
+		.compatible = "atmel,at91rm9200-clk-main-osc",
+		.data = of_at91rm9200_clk_main_osc_setup,
+	},
+	{
+		.compatible = "atmel,at91sam9x5-clk-main-rc-osc",
+		.data = of_at91sam9x5_clk_main_rc_osc_setup,
+	},
+	{
 		.compatible = "atmel,at91rm9200-clk-main",
 		.data = of_at91rm9200_clk_main_setup,
 	},
+	{
+		.compatible = "atmel,at91sam9x5-clk-main",
+		.data = of_at91sam9x5_clk_main_setup,
+	},
 	/* PLL clocks */
 	{
 		.compatible = "atmel,at91rm9200-clk-pll",
diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index 4413509..42cc7cc 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -58,8 +58,14 @@ static inline void pmc_write(struct at91_pmc *pmc, int offset, u32 value)
 int of_at91_get_clk_range(struct device_node *np, const char *propname,
 			  struct clk_range *range);
 
+extern void __init of_at91rm9200_clk_main_osc_setup(struct device_node *np,
+						    struct at91_pmc *pmc);
+extern void __init of_at91sam9x5_clk_main_rc_osc_setup(struct device_node *np,
+						       struct at91_pmc *pmc);
 extern void __init of_at91rm9200_clk_main_setup(struct device_node *np,
 						struct at91_pmc *pmc);
+extern void __init of_at91sam9x5_clk_main_setup(struct device_node *np,
+						struct at91_pmc *pmc);
 
 extern void __init of_at91rm9200_clk_pll_setup(struct device_node *np,
 					       struct at91_pmc *pmc);
-- 
1.8.3.2

