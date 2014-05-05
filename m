Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbaEEN5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:57:46 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:64634 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722AbaEEN5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:57:44 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org,
        devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] clk: bcm281xx: add bus clock support
Date: Mon,  5 May 2014 08:57:34 -0500
Message-Id: <1399298256-10965-4-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399298256-10965-1-git-send-email-elder@linaro.org>
References: <1399298256-10965-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add bus clock support.  A bus clock has a subset of the components
present in a peripheral clock (again, all optional): a gate; CCU
policy management bits; and if needed, bits to control hysteresis.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-kona-setup.c | 96 ++++++++++++++++++++++++++++++++++++++--
 drivers/clk/bcm/clk-kona.c       | 58 ++++++++++++++++++++++++
 drivers/clk/bcm/clk-kona.h       |  8 ++++
 3 files changed, 159 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/bcm/clk-kona-setup.c b/drivers/clk/bcm/clk-kona-setup.c
index fcce22c..60d18f0 100644
--- a/drivers/clk/bcm/clk-kona-setup.c
+++ b/drivers/clk/bcm/clk-kona-setup.c
@@ -76,6 +76,56 @@ static bool clk_requires_trigger(struct kona_clk *bcm_clk)
 	return divider_exists(div) && !divider_is_fixed(div);
 }
 
+static bool bus_clk_data_offsets_valid(struct kona_clk *bcm_clk)
+{
+	struct bus_clk_data *bus;
+	struct bcm_clk_policy *policy;
+	struct bcm_clk_gate *gate;
+	struct bcm_clk_hyst *hyst;
+	const char *name;
+	u32 limit;
+
+	BUG_ON(bcm_clk->type != bcm_clk_bus);
+	bus = bcm_clk->u.bus;
+	name = bcm_clk->init_data.name;
+
+	limit = bcm_clk->ccu->range - sizeof(u32);
+	limit = round_down(limit, sizeof(u32));
+
+	policy = &bus->policy;
+	if (policy_exists(policy)) {
+		if (policy->offset > limit) {
+			pr_err("%s: bad policy offset for %s (%u > %u)\n",
+				__func__, name, policy->offset, limit);
+			return false;
+		}
+	}
+
+	gate = &bus->gate;
+	hyst = &bus->hyst;
+	if (gate_exists(gate)) {
+		if (gate->offset > limit) {
+			pr_err("%s: bad gate offset for %s (%u > %u)\n",
+				__func__, name, gate->offset, limit);
+			return false;
+		}
+		if (hyst_exists(hyst)) {
+			if (hyst->offset > limit) {
+				pr_err("%s: bad hysteresis offset for %s "
+					"(%u > %u)\n", __func__,
+					name, hyst->offset, limit);
+				return false;
+			}
+		}
+	} else if (hyst_exists(hyst)) {
+		pr_err("%s: hysteresis but no gate for %s\n", __func__, name);
+		return false;
+	}
+
+
+	return true;
+}
+
 static bool peri_clk_data_offsets_valid(struct kona_clk *bcm_clk)
 {
 	struct peri_clk_data *peri;
@@ -86,15 +136,13 @@ static bool peri_clk_data_offsets_valid(struct kona_clk *bcm_clk)
 	struct bcm_clk_sel *sel;
 	struct bcm_clk_trig *trig;
 	const char *name;
-	u32 range;
 	u32 limit;
 
 	BUG_ON(bcm_clk->type != bcm_clk_peri);
 	peri = bcm_clk->u.peri;
 	name = bcm_clk->init_data.name;
-	range = bcm_clk->ccu->range;
 
-	limit = range - sizeof(u32);
+	limit = bcm_clk->ccu->range - sizeof(u32);
 	limit = round_down(limit, sizeof(u32));
 
 	policy = &peri->policy;
@@ -397,6 +445,23 @@ static bool trig_valid(struct bcm_clk_trig *trig, const char *field_name,
 	return bit_posn_valid(trig->bit, field_name, clock_name);
 }
 
+/* Determine whether the set of bus clock registers are valid. */
+static bool
+bus_clk_data_valid(struct kona_clk *bcm_clk)
+{
+	struct bcm_clk_gate *gate;
+
+	BUG_ON(bcm_clk->type != bcm_clk_bus);
+	if (!bus_clk_data_offsets_valid(bcm_clk))
+		return false;
+
+	gate = &bcm_clk->u.bus->gate;
+	if (!gate_exists(gate))
+		return true;
+
+	return gate_valid(gate, "gate", bcm_clk->init_data.name);
+}
+
 /* Determine whether the set of peripheral clock registers are valid. */
 static bool
 peri_clk_data_valid(struct kona_clk *bcm_clk)
@@ -494,6 +559,10 @@ peri_clk_data_valid(struct kona_clk *bcm_clk)
 static bool kona_clk_valid(struct kona_clk *bcm_clk)
 {
 	switch (bcm_clk->type) {
+	case bcm_clk_bus:
+		if (!bus_clk_data_valid(bcm_clk))
+			return false;
+		break;
 	case bcm_clk_peri:
 		if (!peri_clk_data_valid(bcm_clk))
 			return false;
@@ -664,6 +733,20 @@ static void clk_sel_teardown(struct bcm_clk_sel *sel,
 	init_data->parent_names = NULL;
 }
 
+static void bus_clk_teardown(struct bus_clk_data *data,
+				struct clk_init_data *init_data)
+{
+	/* Nothing to do */
+}
+
+static int
+bus_clk_setup(struct bus_clk_data *data, struct clk_init_data *init_data)
+{
+	init_data->flags = CLK_IGNORE_UNUSED;
+
+	return 0;
+}
+
 static void peri_clk_teardown(struct peri_clk_data *data,
 				struct clk_init_data *init_data)
 {
@@ -690,6 +773,9 @@ static void bcm_clk_teardown(struct kona_clk *bcm_clk)
 	/* clkdev_remove(&bcm_clk->cl); */
 
 	switch (bcm_clk->type) {
+	case bcm_clk_bus:
+		bus_clk_teardown(bcm_clk->u.data, &bcm_clk->init_data);
+		break;
 	case bcm_clk_peri:
 		peri_clk_teardown(bcm_clk->u.data, &bcm_clk->init_data);
 		break;
@@ -726,6 +812,10 @@ struct clk *kona_clk_setup(struct kona_clk *bcm_clk)
 	struct clk *clk = NULL;
 
 	switch (bcm_clk->type) {
+	case bcm_clk_bus:
+		if (bus_clk_setup(bcm_clk->u.data, init_data))
+			return NULL;
+		break;
 	case bcm_clk_peri:
 		if (peri_clk_setup(bcm_clk->u.data, init_data))
 			return NULL;
diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index de8047d..242dc8d 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -986,6 +986,36 @@ static int selector_write(struct ccu_data *ccu, struct bcm_clk_gate *gate,
 
 /* Clock operations */
 
+static int kona_bus_clk_enable(struct clk_hw *hw)
+{
+	struct kona_clk *bcm_clk = to_kona_clk(hw);
+	struct bcm_clk_gate *gate = &bcm_clk->u.bus->gate;
+
+	return clk_gate(bcm_clk->ccu, bcm_clk->init_data.name, gate, true);
+}
+
+static void kona_bus_clk_disable(struct clk_hw *hw)
+{
+	struct kona_clk *bcm_clk = to_kona_clk(hw);
+	struct bcm_clk_gate *gate = &bcm_clk->u.bus->gate;
+
+	(void)clk_gate(bcm_clk->ccu, bcm_clk->init_data.name, gate, false);
+}
+
+static int kona_bus_clk_is_enabled(struct clk_hw *hw)
+{
+	struct kona_clk *bcm_clk = to_kona_clk(hw);
+	struct bcm_clk_gate *gate = &bcm_clk->u.bus->gate;
+
+	return is_clk_gate_enabled(bcm_clk->ccu, gate) ? 1 : 0;
+}
+
+struct clk_ops kona_bus_clk_ops = {
+	.enable = kona_bus_clk_enable,
+	.disable = kona_bus_clk_disable,
+	.is_enabled = kona_bus_clk_is_enabled,
+};
+
 static int kona_peri_clk_enable(struct clk_hw *hw)
 {
 	struct kona_clk *bcm_clk = to_kona_clk(hw);
@@ -1144,6 +1174,31 @@ struct clk_ops kona_peri_clk_ops = {
 	.set_rate = kona_peri_clk_set_rate,
 };
 
+/* Put a bus clock into its initial state */
+static bool __bus_clk_init(struct kona_clk *bcm_clk)
+{
+	struct ccu_data *ccu = bcm_clk->ccu;
+	struct bus_clk_data *bus = bcm_clk->u.bus;
+	const char *name = bcm_clk->init_data.name;
+
+	BUG_ON(bcm_clk->type != bcm_clk_bus);
+
+	if (!policy_init(ccu, &bus->policy)) {
+		pr_err("%s: error initializing policy for %s\n",
+			__func__, name);
+		return false;
+	}
+	if (!gate_init(ccu, &bus->gate)) {
+		pr_err("%s: error initializing gate for %s\n", __func__, name);
+		return false;
+	}
+	if (!hyst_init(ccu, &bus->hyst)) {
+		pr_err("%s: error initializing hyst for %s\n", __func__, name);
+		return false;
+	}
+	return true;
+}
+
 /* Put a peripheral clock into its initial state */
 static bool __peri_clk_init(struct kona_clk *bcm_clk)
 {
@@ -1248,6 +1303,9 @@ static bool __kona_clk_init(struct kona_clk *bcm_clk)
 		return false;
 
 	switch (bcm_clk->type) {
+	case bcm_clk_bus:
+		ret = __bus_clk_init(bcm_clk);
+		break;
 	case bcm_clk_peri:
 		ret = __peri_clk_init(bcm_clk);
 		break;
diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
index beac016..436f4ed 100644
--- a/drivers/clk/bcm/clk-kona.h
+++ b/drivers/clk/bcm/clk-kona.h
@@ -389,6 +389,12 @@ struct bcm_clk_trig {
 		.flags = FLAG(TRIG, EXISTS),				\
 	}
 
+struct bus_clk_data {
+	struct bcm_clk_policy policy;
+	struct bcm_clk_gate gate;
+	struct bcm_clk_hyst hyst;
+};
+
 struct peri_clk_data {
 	struct bcm_clk_policy policy;
 	struct bcm_clk_gate gate;
@@ -416,6 +422,7 @@ struct kona_clk {
 	};
 	union {
 		void *data;
+		struct bus_clk_data *bus;
 		struct peri_clk_data *peri;
 	} u;
 };
@@ -520,6 +527,7 @@ struct ccu_data {
 
 /* Exported globals */
 
+extern struct clk_ops kona_bus_clk_ops;
 extern struct clk_ops kona_peri_clk_ops;
 
 /* Externally visible functions */
-- 
1.9.1

