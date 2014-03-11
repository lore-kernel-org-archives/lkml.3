Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaCKJBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:01:25 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59150 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaCKJAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:00:53 -0400
From: Boris BREZILLON <brezillonboris@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH v3 3/4] clk: at91: fix programmable clk irq handling
Date: Tue, 11 Mar 2014 10:00:34 +0100
Message-Id: <1394528435-23734-4-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394528435-23734-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1394528435-23734-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

The PCKRDY bit is not set until the system clock is enabled.
This patch moves the management of the ready status in the system clock
driver.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 drivers/clk/at91/clk-programmable.c |  108 ++++++++---------------------------
 drivers/clk/at91/clk-system.c       |   74 ++++++++++++++++++++----
 2 files changed, 89 insertions(+), 93 deletions(-)

diff --git a/drivers/clk/at91/clk-programmable.c b/drivers/clk/at91/clk-programmable.c
index eff7016..7bcc725 100644
--- a/drivers/clk/at91/clk-programmable.c
+++ b/drivers/clk/at91/clk-programmable.c
@@ -13,12 +13,9 @@
 #include <linux/clk/at91_pmc.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/of_irq.h>
 #include <linux/io.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
 
 #include "pmc.h"
 
@@ -38,68 +35,23 @@ struct clk_programmable_layout {
 struct clk_programmable {
 	struct clk_hw hw;
 	struct at91_pmc *pmc;
-	unsigned int irq;
-	wait_queue_head_t wait;
 	u8 id;
-	u8 css;
-	u8 pres;
-	u8 slckmck;
 	const struct clk_programmable_layout *layout;
 };
 
 #define to_clk_programmable(hw) container_of(hw, struct clk_programmable, hw)
 
-
-static irqreturn_t clk_programmable_irq_handler(int irq, void *dev_id)
-{
-	struct clk_programmable *prog = (struct clk_programmable *)dev_id;
-
-	wake_up(&prog->wait);
-
-	return IRQ_HANDLED;
-}
-
-static int clk_programmable_prepare(struct clk_hw *hw)
-{
-	u32 tmp;
-	struct clk_programmable *prog = to_clk_programmable(hw);
-	struct at91_pmc *pmc = prog->pmc;
-	const struct clk_programmable_layout *layout = prog->layout;
-	u8 id = prog->id;
-	u32 mask = PROG_STATUS_MASK(id);
-
-	tmp = prog->css | (prog->pres << layout->pres_shift);
-	if (layout->have_slck_mck && prog->slckmck)
-		tmp |= AT91_PMC_CSSMCK_MCK;
-
-	pmc_write(pmc, AT91_PMC_PCKR(id), tmp);
-
-	while (!(pmc_read(pmc, AT91_PMC_SR) & mask))
-		wait_event(prog->wait, pmc_read(pmc, AT91_PMC_SR) & mask);
-
-	return 0;
-}
-
-static int clk_programmable_is_ready(struct clk_hw *hw)
-{
-	struct clk_programmable *prog = to_clk_programmable(hw);
-	struct at91_pmc *pmc = prog->pmc;
-
-	return !!(pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_PCKR(prog->id));
-}
-
 static unsigned long clk_programmable_recalc_rate(struct clk_hw *hw,
 						  unsigned long parent_rate)
 {
-	u32 tmp;
+	u32 pres;
 	struct clk_programmable *prog = to_clk_programmable(hw);
 	struct at91_pmc *pmc = prog->pmc;
 	const struct clk_programmable_layout *layout = prog->layout;
 
-	tmp = pmc_read(pmc, AT91_PMC_PCKR(prog->id));
-	prog->pres = (tmp >> layout->pres_shift) & PROG_PRES_MASK;
-
-	return parent_rate >> prog->pres;
+	pres = (pmc_read(pmc, AT91_PMC_PCKR(prog->id)) >> layout->pres_shift) &
+	       PROG_PRES_MASK;
+	return parent_rate >> pres;
 }
 
 static long clk_programmable_determine_rate(struct clk_hw *hw,
@@ -146,17 +98,22 @@ static int clk_programmable_set_parent(struct clk_hw *hw, u8 index)
 {
 	struct clk_programmable *prog = to_clk_programmable(hw);
 	const struct clk_programmable_layout *layout = prog->layout;
+	struct at91_pmc *pmc = prog->pmc;
+	u32 tmp = pmc_read(pmc, AT91_PMC_PCKR(prog->id)) & ~layout->css_mask;
+
+	if (layout->have_slck_mck)
+		tmp &= AT91_PMC_CSSMCK_MCK;
+
 	if (index > layout->css_mask) {
 		if (index > PROG_MAX_RM9200_CSS && layout->have_slck_mck) {
-			prog->css = 0;
-			prog->slckmck = 1;
+			tmp |= AT91_PMC_CSSMCK_MCK;
 			return 0;
 		} else {
 			return -EINVAL;
 		}
 	}
 
-	prog->css = index;
+	pmc_write(pmc, AT91_PMC_PCKR(prog->id), tmp | index);
 	return 0;
 }
 
@@ -169,13 +126,9 @@ static u8 clk_programmable_get_parent(struct clk_hw *hw)
 	const struct clk_programmable_layout *layout = prog->layout;
 
 	tmp = pmc_read(pmc, AT91_PMC_PCKR(prog->id));
-	prog->css = tmp & layout->css_mask;
-	ret = prog->css;
-	if (layout->have_slck_mck) {
-		prog->slckmck = !!(tmp & AT91_PMC_CSSMCK_MCK);
-		if (prog->slckmck && !ret)
-			ret = PROG_MAX_RM9200_CSS + 1;
-	}
+	ret = tmp & layout->css_mask;
+	if (layout->have_slck_mck && (tmp & AT91_PMC_CSSMCK_MCK) && !ret)
+		ret = PROG_MAX_RM9200_CSS + 1;
 
 	return ret;
 }
@@ -184,11 +137,15 @@ static int clk_programmable_set_rate(struct clk_hw *hw, unsigned long rate,
 				     unsigned long parent_rate)
 {
 	struct clk_programmable *prog = to_clk_programmable(hw);
+	struct at91_pmc *pmc = prog->pmc;
+	const struct clk_programmable_layout *layout = prog->layout;
 	unsigned long best_rate = parent_rate;
 	unsigned long best_diff;
 	unsigned long new_diff;
 	unsigned long cur_rate;
 	int shift = 0;
+	u32 tmp = pmc_read(pmc, AT91_PMC_PCKR(prog->id)) &
+		  ~(PROG_PRES_MASK << layout->pres_shift);
 
 	if (rate > parent_rate)
 		return parent_rate;
@@ -196,7 +153,7 @@ static int clk_programmable_set_rate(struct clk_hw *hw, unsigned long rate,
 		best_diff = parent_rate - rate;
 
 	if (!best_diff) {
-		prog->pres = shift;
+		pmc_write(pmc, AT91_PMC_PCKR(prog->id), tmp | shift);
 		return 0;
 	}
 
@@ -220,13 +177,13 @@ static int clk_programmable_set_rate(struct clk_hw *hw, unsigned long rate,
 			break;
 	}
 
-	prog->pres = shift;
+	pmc_write(pmc, AT91_PMC_PCKR(prog->id),
+		  tmp | (shift << layout->pres_shift));
+
 	return 0;
 }
 
 static const struct clk_ops programmable_ops = {
-	.prepare = clk_programmable_prepare,
-	.is_prepared = clk_programmable_is_ready,
 	.recalc_rate = clk_programmable_recalc_rate,
 	.determine_rate = clk_programmable_determine_rate,
 	.get_parent = clk_programmable_get_parent,
@@ -235,16 +192,14 @@ static const struct clk_ops programmable_ops = {
 };
 
 static struct clk * __init
-at91_clk_register_programmable(struct at91_pmc *pmc, unsigned int irq,
+at91_clk_register_programmable(struct at91_pmc *pmc,
 			       const char *name, const char **parent_names,
 			       u8 num_parents, u8 id,
 			       const struct clk_programmable_layout *layout)
 {
-	int ret;
 	struct clk_programmable *prog;
 	struct clk *clk = NULL;
 	struct clk_init_data init;
-	char irq_name[11];
 
 	if (id > PROG_ID_MAX)
 		return ERR_PTR(-EINVAL);
@@ -263,14 +218,6 @@ at91_clk_register_programmable(struct at91_pmc *pmc, unsigned int irq,
 	prog->layout = layout;
 	prog->hw.init = &init;
 	prog->pmc = pmc;
-	prog->irq = irq;
-	init_waitqueue_head(&prog->wait);
-	irq_set_status_flags(prog->irq, IRQ_NOAUTOEN);
-	snprintf(irq_name, sizeof(irq_name), "clk-prog%d", id);
-	ret = request_irq(prog->irq, clk_programmable_irq_handler,
-			  IRQF_TRIGGER_HIGH, irq_name, prog);
-	if (ret)
-		return ERR_PTR(ret);
 
 	clk = clk_register(NULL, &prog->hw);
 	if (IS_ERR(clk))
@@ -304,7 +251,6 @@ of_at91_clk_prog_setup(struct device_node *np, struct at91_pmc *pmc,
 	int num;
 	u32 id;
 	int i;
-	unsigned int irq;
 	struct clk *clk;
 	int num_parents;
 	const char *parent_names[PROG_SOURCE_MAX];
@@ -332,11 +278,7 @@ of_at91_clk_prog_setup(struct device_node *np, struct at91_pmc *pmc,
 		if (of_property_read_string(np, "clock-output-names", &name))
 			name = progclknp->name;
 
-		irq = irq_of_parse_and_map(progclknp, 0);
-		if (!irq)
-			continue;
-
-		clk = at91_clk_register_programmable(pmc, irq, name,
+		clk = at91_clk_register_programmable(pmc, name,
 						     parent_names, num_parents,
 						     id, layout);
 		if (IS_ERR(clk))
diff --git a/drivers/clk/at91/clk-system.c b/drivers/clk/at91/clk-system.c
index 48c89fe..8c96307 100644
--- a/drivers/clk/at91/clk-system.c
+++ b/drivers/clk/at91/clk-system.c
@@ -14,6 +14,11 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/of_irq.h>
+#include <linux/interrupt.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
 
 #include "pmc.h"
 
@@ -25,19 +30,48 @@
 struct clk_system {
 	struct clk_hw hw;
 	struct at91_pmc *pmc;
+	unsigned int irq;
+	wait_queue_head_t wait;
 	u8 id;
 };
 
-static int clk_system_enable(struct clk_hw *hw)
+static inline int is_pck(int id)
+{
+	return (id >= 8) && (id <= 15);
+}
+static irqreturn_t clk_system_irq_handler(int irq, void *dev_id)
+{
+	struct clk_system *sys = (struct clk_system *)dev_id;
+
+	wake_up(&sys->wait);
+	disable_irq_nosync(sys->irq);
+
+	return IRQ_HANDLED;
+}
+
+static int clk_system_prepare(struct clk_hw *hw)
 {
 	struct clk_system *sys = to_clk_system(hw);
 	struct at91_pmc *pmc = sys->pmc;
+	u32 mask = 1 << sys->id;
 
-	pmc_write(pmc, AT91_PMC_SCER, 1 << sys->id);
+	pmc_write(pmc, AT91_PMC_SCER, mask);
+
+	if (!is_pck(sys->id))
+		return 0;
+
+	while (!(pmc_read(pmc, AT91_PMC_SR) & mask)) {
+		if (sys->irq) {
+			enable_irq(sys->irq);
+			wait_event(sys->wait,
+				   pmc_read(pmc, AT91_PMC_SR) & mask);
+		} else
+			cpu_relax();
+	}
 	return 0;
 }
 
-static void clk_system_disable(struct clk_hw *hw)
+static void clk_system_unprepare(struct clk_hw *hw)
 {
 	struct clk_system *sys = to_clk_system(hw);
 	struct at91_pmc *pmc = sys->pmc;
@@ -45,27 +79,34 @@ static void clk_system_disable(struct clk_hw *hw)
 	pmc_write(pmc, AT91_PMC_SCDR, 1 << sys->id);
 }
 
-static int clk_system_is_enabled(struct clk_hw *hw)
+static int clk_system_is_prepared(struct clk_hw *hw)
 {
 	struct clk_system *sys = to_clk_system(hw);
 	struct at91_pmc *pmc = sys->pmc;
 
-	return !!(pmc_read(pmc, AT91_PMC_SCSR) & (1 << sys->id));
+	if (!(pmc_read(pmc, AT91_PMC_SCSR) & (1 << sys->id)))
+		return 0;
+
+	if (!is_pck(sys->id))
+		return 1;
+
+	return !!(pmc_read(pmc, AT91_PMC_SR) & (1 << sys->id));
 }
 
 static const struct clk_ops system_ops = {
-	.enable = clk_system_enable,
-	.disable = clk_system_disable,
-	.is_enabled = clk_system_is_enabled,
+	.prepare = clk_system_prepare,
+	.unprepare = clk_system_unprepare,
+	.is_prepared = clk_system_is_prepared,
 };
 
 static struct clk * __init
 at91_clk_register_system(struct at91_pmc *pmc, const char *name,
-			 const char *parent_name, u8 id)
+			 const char *parent_name, u8 id, int irq)
 {
 	struct clk_system *sys;
 	struct clk *clk = NULL;
 	struct clk_init_data init;
+	int ret;
 
 	if (!parent_name || id > SYSTEM_MAX_ID)
 		return ERR_PTR(-EINVAL);
@@ -89,6 +130,15 @@ at91_clk_register_system(struct at91_pmc *pmc, const char *name,
 	sys->id = id;
 	sys->hw.init = &init;
 	sys->pmc = pmc;
+	sys->irq = irq;
+	if (irq) {
+		init_waitqueue_head(&sys->wait);
+		irq_set_status_flags(sys->irq, IRQ_NOAUTOEN);
+		ret = request_irq(sys->irq, clk_system_irq_handler,
+				IRQF_TRIGGER_HIGH, name, sys);
+		if (ret)
+			return ERR_PTR(ret);
+	}
 
 	clk = clk_register(NULL, &sys->hw);
 	if (IS_ERR(clk))
@@ -101,6 +151,7 @@ static void __init
 of_at91_clk_sys_setup(struct device_node *np, struct at91_pmc *pmc)
 {
 	int num;
+	int irq = 0;
 	u32 id;
 	struct clk *clk;
 	const char *name;
@@ -118,9 +169,12 @@ of_at91_clk_sys_setup(struct device_node *np, struct at91_pmc *pmc)
 		if (of_property_read_string(np, "clock-output-names", &name))
 			name = sysclknp->name;
 
+		if (is_pck(id))
+			irq = irq_of_parse_and_map(sysclknp, 0);
+
 		parent_name = of_clk_get_parent_name(sysclknp, 0);
 
-		clk = at91_clk_register_system(pmc, name, parent_name, id);
+		clk = at91_clk_register_system(pmc, name, parent_name, id, irq);
 		if (IS_ERR(clk))
 			continue;
 
-- 
1.7.9.5

