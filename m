Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbaDBCEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 22:04:44 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:47560 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaDBCEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 22:04:35 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, bcm@fixthebug.org, mporter@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/7] clk: bcm281xx: use init_data.name for clock name
Date: Tue,  1 Apr 2014 21:04:50 -0500
Message-Id: <1396404296-9390-3-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396404296-9390-1-git-send-email-elder@linaro.org>
References: <1396404296-9390-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the init_data.name field to hold the name of a Kona clock rather
than duplicating it.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-kona-setup.c |    6 +++---
 drivers/clk/bcm/clk-kona.c       |   17 ++++++++++-------
 drivers/clk/bcm/clk-kona.h       |    3 +--
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/bcm/clk-kona-setup.c b/drivers/clk/bcm/clk-kona-setup.c
index c7607fe..eed84f5 100644
--- a/drivers/clk/bcm/clk-kona-setup.c
+++ b/drivers/clk/bcm/clk-kona-setup.c
@@ -64,7 +64,7 @@ static bool peri_clk_data_offsets_valid(struct kona_clk *bcm_clk)
 
 	BUG_ON(bcm_clk->type != bcm_clk_peri);
 	peri = bcm_clk->peri;
-	name = bcm_clk->name;
+	name = bcm_clk->init_data.name;
 	range = bcm_clk->ccu->range;
 
 	limit = range - sizeof(u32);
@@ -329,7 +329,7 @@ peri_clk_data_valid(struct kona_clk *bcm_clk)
 		return false;
 
 	peri = bcm_clk->peri;
-	name = bcm_clk->name;
+	name = bcm_clk->init_data.name;
 	gate = &peri->gate;
 	if (gate_exists(gate) && !gate_valid(gate, "gate", name))
 		return false;
@@ -630,7 +630,7 @@ struct clk *kona_clk_setup(struct ccu_data *ccu, const char *name,
 		return NULL;
 	}
 	bcm_clk->ccu = ccu;
-	bcm_clk->name = name;
+	bcm_clk->init_data.name = name;
 
 	init_data = &bcm_clk->init_data;
 	init_data->name = name;
diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index c01d810..488ed1f 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -807,7 +807,7 @@ static int kona_peri_clk_enable(struct clk_hw *hw)
 	struct kona_clk *bcm_clk = to_kona_clk(hw);
 	struct bcm_clk_gate *gate = &bcm_clk->peri->gate;
 
-	return clk_gate(bcm_clk->ccu, bcm_clk->name, gate, true);
+	return clk_gate(bcm_clk->ccu, bcm_clk->init_data.name, gate, true);
 }
 
 static void kona_peri_clk_disable(struct clk_hw *hw)
@@ -815,7 +815,7 @@ static void kona_peri_clk_disable(struct clk_hw *hw)
 	struct kona_clk *bcm_clk = to_kona_clk(hw);
 	struct bcm_clk_gate *gate = &bcm_clk->peri->gate;
 
-	(void)clk_gate(bcm_clk->ccu, bcm_clk->name, gate, false);
+	(void)clk_gate(bcm_clk->ccu, bcm_clk->init_data.name, gate, false);
 }
 
 static int kona_peri_clk_is_enabled(struct clk_hw *hw)
@@ -873,12 +873,13 @@ static int kona_peri_clk_set_parent(struct clk_hw *hw, u8 index)
 
 	ret = selector_write(bcm_clk->ccu, &data->gate, sel, trig, index);
 	if (ret == -ENXIO) {
-		pr_err("%s: gating failure for %s\n", __func__, bcm_clk->name);
+		pr_err("%s: gating failure for %s\n", __func__,
+			bcm_clk->init_data.name);
 		ret = -EIO;	/* Don't proliferate weird errors */
 	} else if (ret == -EIO) {
 		pr_err("%s: %strigger failed for %s\n", __func__,
 			trig == &data->pre_trig ? "pre-" : "",
-			bcm_clk->name);
+			bcm_clk->init_data.name);
 	}
 
 	return ret;
@@ -937,10 +938,12 @@ static int kona_peri_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 	ret = divider_write(bcm_clk->ccu, &data->gate, &data->div,
 				&data->trig, scaled_div);
 	if (ret == -ENXIO) {
-		pr_err("%s: gating failure for %s\n", __func__, bcm_clk->name);
+		pr_err("%s: gating failure for %s\n", __func__,
+			bcm_clk->init_data.name);
 		ret = -EIO;	/* Don't proliferate weird errors */
 	} else if (ret == -EIO) {
-		pr_err("%s: trigger failed for %s\n", __func__, bcm_clk->name);
+		pr_err("%s: trigger failed for %s\n", __func__,
+			bcm_clk->init_data.name);
 	}
 
 	return ret;
@@ -962,7 +965,7 @@ static bool __peri_clk_init(struct kona_clk *bcm_clk)
 {
 	struct ccu_data *ccu = bcm_clk->ccu;
 	struct peri_clk_data *peri = bcm_clk->peri;
-	const char *name = bcm_clk->name;
+	const char *name = bcm_clk->init_data.name;
 	struct bcm_clk_trig *trig;
 
 	BUG_ON(bcm_clk->type != bcm_clk_peri);
diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
index 5e139ad..96fd0bc 100644
--- a/drivers/clk/bcm/clk-kona.h
+++ b/drivers/clk/bcm/clk-kona.h
@@ -373,8 +373,7 @@ struct peri_clk_data {
 
 struct kona_clk {
 	struct clk_hw hw;
-	struct clk_init_data init_data;
-	const char *name;	/* name of this clock */
+	struct clk_init_data init_data;	/* includes name of this clock */
 	struct ccu_data *ccu;	/* ccu this clock is associated with */
 	enum bcm_clk_type type;
 	union {
-- 
1.7.9.5

