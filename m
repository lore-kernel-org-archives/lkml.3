Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbaDBCEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 22:04:46 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:46817 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426AbaDBCEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 22:04:41 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, bcm@fixthebug.org, mporter@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/10] clk: bcm281xx: add clock hysteresis support
Date: Tue,  1 Apr 2014 21:04:56 -0500
Message-Id: <1396404296-9390-9-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396404296-9390-1-git-send-email-elder@linaro.org>
References: <1396404296-9390-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for clock gate hysteresis control.  For now, if it's
defined for a clock, it's enabled.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-kona-setup.c |   30 ++++++++++++++++++++++++++++++
 drivers/clk/bcm/clk-kona.c       |   33 +++++++++++++++++++++++++++++++++
 drivers/clk/bcm/clk-kona.h       |   19 +++++++++++++++++++
 3 files changed, 82 insertions(+)

diff --git a/drivers/clk/bcm/clk-kona-setup.c b/drivers/clk/bcm/clk-kona-setup.c
index 5a49deb..757de19 100644
--- a/drivers/clk/bcm/clk-kona-setup.c
+++ b/drivers/clk/bcm/clk-kona-setup.c
@@ -81,6 +81,7 @@ static bool peri_clk_data_offsets_valid(struct kona_clk *bcm_clk)
 	struct peri_clk_data *peri;
 	struct bcm_clk_policy *policy;
 	struct bcm_clk_gate *gate;
+	struct bcm_clk_hyst *hyst;
 	struct bcm_clk_div *div;
 	struct bcm_clk_sel *sel;
 	struct bcm_clk_trig *trig;
@@ -106,12 +107,25 @@ static bool peri_clk_data_offsets_valid(struct kona_clk *bcm_clk)
 	}
 
 	gate = &peri->gate;
+	hyst = &peri->hyst;
 	if (gate_exists(gate)) {
 		if (gate->offset > limit) {
 			pr_err("%s: bad gate offset for %s (%u > %u)\n",
 				__func__, name, gate->offset, limit);
 			return false;
 		}
+
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
 	}
 
 	div = &peri->div;
@@ -261,6 +275,17 @@ static bool gate_valid(struct bcm_clk_gate *gate, const char *field_name,
 	return true;
 }
 
+static bool hyst_valid(struct bcm_clk_hyst *hyst, const char *clock_name)
+{
+	if (!bit_posn_valid(hyst->en_bit, "hysteresis enable", clock_name))
+		return false;
+
+	if (!bit_posn_valid(hyst->val_bit, "hysteresis value", clock_name))
+		return false;
+
+	return true;
+}
+
 /*
  * A selector bitfield must be valid.  Its parent_sel array must
  * also be reasonable for the field.
@@ -378,6 +403,7 @@ peri_clk_data_valid(struct kona_clk *bcm_clk)
 	struct peri_clk_data *peri;
 	struct bcm_clk_policy *policy;
 	struct bcm_clk_gate *gate;
+	struct bcm_clk_hyst *hyst;
 	struct bcm_clk_sel *sel;
 	struct bcm_clk_div *div;
 	struct bcm_clk_div *pre_div;
@@ -405,6 +431,10 @@ peri_clk_data_valid(struct kona_clk *bcm_clk)
 	if (gate_exists(gate) && !gate_valid(gate, "gate", name))
 		return false;
 
+	hyst = &peri->hyst;
+	if (hyst_exists(hyst) && !hyst_valid(hyst, name))
+		return false;
+
 	sel = &peri->sel;
 	if (selector_exists(sel)) {
 		if (!sel_valid(sel, "selector", name))
diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index bf9661c..64b6361 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -527,6 +527,35 @@ static int clk_gate(struct ccu_data *ccu, const char *name,
 	return -EIO;
 }
 
+/* Hysteresis operations */
+
+/*
+ * If a clock gate requires a turn-off delay it will have
+ * "hysteresis" register bits defined.  The first, if set, enables
+ * the delay; and if enabled, the second bit determines whether the
+ * delay is "low" or "high" (1 means high).  For now, if it's
+ * defined for a clock, we set it.
+ */
+static bool hyst_init(struct ccu_data *ccu, struct bcm_clk_hyst *hyst)
+{
+	u32 offset;
+	u32 reg_val;
+	u32 mask;
+
+	if (!hyst_exists(hyst))
+		return true;
+
+	offset = hyst->offset;
+	mask = (u32)1 << hyst->en_bit;
+	mask |= (u32)1 << hyst->val_bit;
+
+	reg_val = __ccu_read(ccu, offset);
+	reg_val |= mask;
+	__ccu_write(ccu, offset, reg_val);
+
+	return true;
+}
+
 /* Trigger operations */
 
 /*
@@ -1129,6 +1158,10 @@ static bool __peri_clk_init(struct kona_clk *bcm_clk)
 		pr_err("%s: error initializing gate for %s\n", __func__, name);
 		return false;
 	}
+	if (!hyst_init(ccu, &peri->hyst)) {
+		pr_err("%s: error initializing hyst for %s\n", __func__, name);
+		return false;
+	}
 	if (!div_init(ccu, &peri->gate, &peri->div, &peri->trig)) {
 		pr_err("%s: error initializing divider for %s\n", __func__,
 			name);
diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
index c390ca4..c6285d2 100644
--- a/drivers/clk/bcm/clk-kona.h
+++ b/drivers/clk/bcm/clk-kona.h
@@ -60,6 +60,8 @@
 
 #define gate_flip_enabled(gate)		FLAG_FLIP(gate, GATE, ENABLED)
 
+#define hyst_exists(hyst)		((hyst)->offset != 0)
+
 #define divider_exists(div)		FLAG_TEST(div, DIV, EXISTS)
 #define divider_is_fixed(div)		FLAG_TEST(div, DIV, FIXED)
 #define divider_has_fraction(div)	(!divider_is_fixed(div) && \
@@ -205,6 +207,22 @@ struct bcm_clk_gate {
 		.flags = FLAG(GATE, HW)|FLAG(GATE, EXISTS),		\
 	}
 
+/* Gate hysteresis for clocks */
+struct bcm_clk_hyst {
+	u32 offset;		/* hyst register offset (normally CLKGATE) */
+	u32 en_bit;		/* bit used to enable hysteresis */
+	u32 val_bit;		/* if enabled: 0 = low delay; 1 = high delay */
+};
+
+/* Hysteresis initialization macro */
+
+#define HYST(_offset, _en_bit, _val_bit)				\
+	{								\
+		.offset = (_offset),					\
+		.en_bit = (_en_bit),					\
+		.val_bit = (_val_bit),					\
+	}
+
 /*
  * Each clock can have zero, one, or two dividers which change the
  * output rate of the clock.  Each divider can be either fixed or
@@ -372,6 +390,7 @@ struct bcm_clk_trig {
 struct peri_clk_data {
 	struct bcm_clk_policy policy;
 	struct bcm_clk_gate gate;
+	struct bcm_clk_hyst hyst;
 	struct bcm_clk_trig pre_trig;
 	struct bcm_clk_div pre_div;
 	struct bcm_clk_trig trig;
-- 
1.7.9.5

