Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbaFPNlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:41:40 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:51673 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaFPNjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:39:51 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 1/7] clk: kona: move some code
Date: Mon, 16 Jun 2014 08:40:01 -0500
Message-Id: <1402926007-4436-2-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402926007-4436-1-git-send-email-elder@linaro.org>
References: <1402926007-4436-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the definition of __peri_clk_init() up in "clk-kona.c", in
preparation for the next patch (so it's defined before it's needed).
Move kona_ccu_init() and __kona_clk_init() as well.

Done as a separate patch so doing so doesn't obscure other changes.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-kona.c | 174 ++++++++++++++++++++++-----------------------
 1 file changed, 87 insertions(+), 87 deletions(-)

diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index 95af2e6..b643d35 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -981,6 +981,93 @@ static int selector_write(struct ccu_data *ccu, struct bcm_clk_gate *gate,
 	return ret;
 }
 
+/* Put a peripheral clock into its initial state */
+static bool __peri_clk_init(struct kona_clk *bcm_clk)
+{
+	struct ccu_data *ccu = bcm_clk->ccu;
+	struct peri_clk_data *peri = bcm_clk->u.peri;
+	const char *name = bcm_clk->init_data.name;
+	struct bcm_clk_trig *trig;
+
+	BUG_ON(bcm_clk->type != bcm_clk_peri);
+
+	if (!policy_init(ccu, &peri->policy)) {
+		pr_err("%s: error initializing policy for %s\n",
+			__func__, name);
+		return false;
+	}
+	if (!gate_init(ccu, &peri->gate)) {
+		pr_err("%s: error initializing gate for %s\n", __func__, name);
+		return false;
+	}
+	if (!hyst_init(ccu, &peri->hyst)) {
+		pr_err("%s: error initializing hyst for %s\n", __func__, name);
+		return false;
+	}
+	if (!div_init(ccu, &peri->gate, &peri->div, &peri->trig)) {
+		pr_err("%s: error initializing divider for %s\n", __func__,
+			name);
+		return false;
+	}
+
+	/*
+	 * For the pre-divider and selector, the pre-trigger is used
+	 * if it's present, otherwise we just use the regular trigger.
+	 */
+	trig = trigger_exists(&peri->pre_trig) ? &peri->pre_trig
+					       : &peri->trig;
+
+	if (!div_init(ccu, &peri->gate, &peri->pre_div, trig)) {
+		pr_err("%s: error initializing pre-divider for %s\n", __func__,
+			name);
+		return false;
+	}
+
+	if (!sel_init(ccu, &peri->gate, &peri->sel, trig)) {
+		pr_err("%s: error initializing selector for %s\n", __func__,
+			name);
+		return false;
+	}
+
+	return true;
+}
+
+static bool __kona_clk_init(struct kona_clk *bcm_clk)
+{
+	switch (bcm_clk->type) {
+	case bcm_clk_peri:
+		return __peri_clk_init(bcm_clk);
+	default:
+		BUG();
+	}
+	return -EINVAL;
+}
+
+/* Set a CCU and all its clocks into their desired initial state */
+bool __init kona_ccu_init(struct ccu_data *ccu)
+{
+	unsigned long flags;
+	unsigned int which;
+	struct clk **clks = ccu->clk_data.clks;
+	bool success = true;
+
+	flags = ccu_lock(ccu);
+	__ccu_write_enable(ccu);
+
+	for (which = 0; which < ccu->clk_data.clk_num; which++) {
+		struct kona_clk *bcm_clk;
+
+		if (!clks[which])
+			continue;
+		bcm_clk = to_kona_clk(__clk_get_hw(clks[which]));
+		success &= __kona_clk_init(bcm_clk);
+	}
+
+	__ccu_write_disable(ccu);
+	ccu_unlock(ccu, flags);
+	return success;
+}
+
 /* Clock operations */
 
 static int kona_peri_clk_enable(struct clk_hw *hw)
@@ -1192,90 +1279,3 @@ struct clk_ops kona_peri_clk_ops = {
 	.get_parent = kona_peri_clk_get_parent,
 	.set_rate = kona_peri_clk_set_rate,
 };
-
-/* Put a peripheral clock into its initial state */
-static bool __peri_clk_init(struct kona_clk *bcm_clk)
-{
-	struct ccu_data *ccu = bcm_clk->ccu;
-	struct peri_clk_data *peri = bcm_clk->u.peri;
-	const char *name = bcm_clk->init_data.name;
-	struct bcm_clk_trig *trig;
-
-	BUG_ON(bcm_clk->type != bcm_clk_peri);
-
-	if (!policy_init(ccu, &peri->policy)) {
-		pr_err("%s: error initializing policy for %s\n",
-			__func__, name);
-		return false;
-	}
-	if (!gate_init(ccu, &peri->gate)) {
-		pr_err("%s: error initializing gate for %s\n", __func__, name);
-		return false;
-	}
-	if (!hyst_init(ccu, &peri->hyst)) {
-		pr_err("%s: error initializing hyst for %s\n", __func__, name);
-		return false;
-	}
-	if (!div_init(ccu, &peri->gate, &peri->div, &peri->trig)) {
-		pr_err("%s: error initializing divider for %s\n", __func__,
-			name);
-		return false;
-	}
-
-	/*
-	 * For the pre-divider and selector, the pre-trigger is used
-	 * if it's present, otherwise we just use the regular trigger.
-	 */
-	trig = trigger_exists(&peri->pre_trig) ? &peri->pre_trig
-					       : &peri->trig;
-
-	if (!div_init(ccu, &peri->gate, &peri->pre_div, trig)) {
-		pr_err("%s: error initializing pre-divider for %s\n", __func__,
-			name);
-		return false;
-	}
-
-	if (!sel_init(ccu, &peri->gate, &peri->sel, trig)) {
-		pr_err("%s: error initializing selector for %s\n", __func__,
-			name);
-		return false;
-	}
-
-	return true;
-}
-
-static bool __kona_clk_init(struct kona_clk *bcm_clk)
-{
-	switch (bcm_clk->type) {
-	case bcm_clk_peri:
-		return __peri_clk_init(bcm_clk);
-	default:
-		BUG();
-	}
-	return -EINVAL;
-}
-
-/* Set a CCU and all its clocks into their desired initial state */
-bool __init kona_ccu_init(struct ccu_data *ccu)
-{
-	unsigned long flags;
-	unsigned int which;
-	struct clk **clks = ccu->clk_data.clks;
-	bool success = true;
-
-	flags = ccu_lock(ccu);
-	__ccu_write_enable(ccu);
-
-	for (which = 0; which < ccu->clk_data.clk_num; which++) {
-		struct kona_clk *bcm_clk;
-
-		if (!clks[which])
-			continue;
-		bcm_clk = to_kona_clk(__clk_get_hw(clks[which]));
-		success &= __kona_clk_init(bcm_clk);
-	}
-
-	__ccu_write_disable(ccu);
-	ccu_unlock(ccu, flags);
-	return success;
-}
-- 
1.9.1

