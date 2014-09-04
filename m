Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbaIDVLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:11:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56350 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaIDVLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:11:38 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH] clk: qcom: Consolidate frequency finding logic
Date: Thu,  4 Sep 2014 14:11:34 -0700
Message-Id: <1409865094-20762-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.rc2.4.g1a517f0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two find_freq() functions in clk-rcg.c and clk-rcg2.c
that are almost exactly the same. Consolidate them into one
function to save on some code space.

Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

I'll queue this for v3.18 if there are no objections.

 drivers/clk/qcom/clk-rcg.c  | 20 ++++----------------
 drivers/clk/qcom/clk-rcg2.c | 19 +++----------------
 drivers/clk/qcom/common.c   | 16 ++++++++++++++++
 drivers/clk/qcom/common.h   |  4 ++++
 4 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/drivers/clk/qcom/clk-rcg.c b/drivers/clk/qcom/clk-rcg.c
index 59f118cc4c8b..710a869fc24c 100644
--- a/drivers/clk/qcom/clk-rcg.c
+++ b/drivers/clk/qcom/clk-rcg.c
@@ -21,6 +21,7 @@
 #include <asm/div64.h>
 
 #include "clk-rcg.h"
+#include "common.h"
 
 static u32 ns_to_src(struct src_sel *s, u32 ns)
 {
@@ -360,26 +361,13 @@ clk_dyn_rcg_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
 	}
 }
 
-static const
-struct freq_tbl *find_freq(const struct freq_tbl *f, unsigned long rate)
-{
-	if (!f)
-		return NULL;
-
-	for (; f->freq; f++)
-		if (rate <= f->freq)
-			return f;
-
-	return NULL;
-}
-
 static long _freq_tbl_determine_rate(struct clk_hw *hw,
 		const struct freq_tbl *f, unsigned long rate,
 		unsigned long *p_rate, struct clk_core **p)
 {
 	unsigned long clk_flags;
 
-	f = find_freq(f, rate);
+	f = qcom_find_freq(f, rate);
 	if (!f)
 		return -EINVAL;
 
@@ -477,7 +465,7 @@ static int clk_rcg_set_rate(struct clk_hw *hw, unsigned long rate,
 	struct clk_rcg *rcg = to_clk_rcg(hw);
 	const struct freq_tbl *f;
 
-	f = find_freq(rcg->freq_tbl, rate);
+	f = qcom_find_freq(rcg->freq_tbl, rate);
 	if (!f)
 		return -EINVAL;
 
@@ -497,7 +485,7 @@ static int __clk_dyn_rcg_set_rate(struct clk_hw *hw, unsigned long rate)
 	struct clk_dyn_rcg *rcg = to_clk_dyn_rcg(hw);
 	const struct freq_tbl *f;
 
-	f = find_freq(rcg->freq_tbl, rate);
+	f = qcom_find_freq(rcg->freq_tbl, rate);
 	if (!f)
 		return -EINVAL;
 
diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index 6aac1ec0777c..0d2759b814ff 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -24,6 +24,7 @@
 #include <asm/div64.h>
 
 #include "clk-rcg.h"
+#include "common.h"
 
 #define CMD_REG			0x0
 #define CMD_UPDATE		BIT(0)
@@ -172,27 +173,13 @@ clk_rcg2_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
 	return calc_rate(parent_rate, m, n, mode, hid_div);
 }
 
-static const
-struct freq_tbl *find_freq(const struct freq_tbl *f, unsigned long rate)
-{
-	if (!f)
-		return NULL;
-
-	for (; f->freq; f++)
-		if (rate <= f->freq)
-			return f;
-
-	/* Default to our fastest rate */
-	return f - 1;
-}
-
 static long _freq_tbl_determine_rate(struct clk_hw *hw,
 		const struct freq_tbl *f, unsigned long rate,
 		unsigned long *p_rate, struct clk_core **p)
 {
 	unsigned long clk_flags;
 
-	f = find_freq(f, rate);
+	f = qcom_find_freq(f, rate);
 	if (!f)
 		return -EINVAL;
 
@@ -268,7 +255,7 @@ static int __clk_rcg2_set_rate(struct clk_hw *hw, unsigned long rate)
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
 	const struct freq_tbl *f;
 
-	f = find_freq(rcg->freq_tbl, rate);
+	f = qcom_find_freq(rcg->freq_tbl, rate);
 	if (!f)
 		return -EINVAL;
 
diff --git a/drivers/clk/qcom/common.c b/drivers/clk/qcom/common.c
index afd40ea50887..dd8335b8522b 100644
--- a/drivers/clk/qcom/common.c
+++ b/drivers/clk/qcom/common.c
@@ -18,6 +18,7 @@
 #include <linux/reset-controller.h>
 
 #include "common.h"
+#include "clk-rcg.h"
 #include "clk-regmap.h"
 #include "reset.h"
 
@@ -27,6 +28,21 @@ struct qcom_cc {
 	struct clk_core *clks[];
 };
 
+const
+struct freq_tbl *qcom_find_freq(const struct freq_tbl *f, unsigned long rate)
+{
+	if (!f)
+		return NULL;
+
+	for (; f->freq; f++)
+		if (rate <= f->freq)
+			return f;
+
+	/* Default to our fastest rate */
+	return f - 1;
+}
+EXPORT_SYMBOL_GPL(qcom_find_freq);
+
 struct regmap *
 qcom_cc_map(struct platform_device *pdev, const struct qcom_cc_desc *desc)
 {
diff --git a/drivers/clk/qcom/common.h b/drivers/clk/qcom/common.h
index 2765e9d3da97..f519322acdf3 100644
--- a/drivers/clk/qcom/common.h
+++ b/drivers/clk/qcom/common.h
@@ -18,6 +18,7 @@ struct regmap_config;
 struct clk_regmap;
 struct qcom_reset_map;
 struct regmap;
+struct freq_tbl;
 
 struct qcom_cc_desc {
 	const struct regmap_config *config;
@@ -27,6 +28,9 @@ struct qcom_cc_desc {
 	size_t num_resets;
 };
 
+extern const struct freq_tbl *qcom_find_freq(const struct freq_tbl *f,
+					     unsigned long rate);
+
 extern struct regmap *qcom_cc_map(struct platform_device *pdev,
 				  const struct qcom_cc_desc *desc);
 extern int qcom_cc_really_probe(struct platform_device *pdev,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

