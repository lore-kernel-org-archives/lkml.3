Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaDUVMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:12:08 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:54822 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbaDUVMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:12:01 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 RESEND 2/7] clk: bcm281xx: use init_data.name for clock name
Date: Mon, 21 Apr 2014 16:11:38 -0500
Message-Id: <1398114703-32410-3-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398114703-32410-1-git-send-email-elder@linaro.org>
References: <1398114703-32410-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the init_data.name field to hold the name of a Kona clock rather
than duplicating it.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-kona-setup.c |  6 +++---
 drivers/clk/bcm/clk-kona.c       | 17 ++++++++++-------
 drivers/clk/bcm/clk-kona.h       |  3 +--
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/bcm/clk-kona-setup.c b/drivers/clk/bcm/clk-kona-setup.c
index 54a0652..9e7a9c1 100644
--- a/drivers/clk/bcm/clk-kona-setup.c
+++ b/drivers/clk/bcm/clk-kona-setup.c
@@ -64,7 +64,7 @@ static bool peri_clk_data_offsets_valid(struct kona_clk *bcm_clk)
 
 	BUG_ON(bcm_clk->type != bcm_clk_peri);
 	peri = bcm_clk->u.peri;
-	name = bcm_clk->name;
+	name = bcm_clk->init_data.name;
 	range = bcm_clk->ccu->range;
 
 	limit = range - sizeof(u32);
@@ -330,7 +330,7 @@ peri_clk_data_valid(struct kona_clk *bcm_clk)
 		return false;
 
 	peri = bcm_clk->u.peri;
-	name = bcm_clk->name;
+	name = bcm_clk->init_data.name;
 	gate = &peri->gate;
 	if (gate_exists(gate) && !gate_valid(gate, "gate", name))
 		return false;
@@ -631,7 +631,7 @@ struct clk *kona_clk_setup(struct ccu_data *ccu, const char *name,
 		return NULL;
 	}
 	bcm_clk->ccu = ccu;
-	bcm_clk->name = name;
+	bcm_clk->init_data.name = name;
 
 	init_data = &bcm_clk->init_data;
 	init_data->name = name;
diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index 4b4e35a..bf0b70e 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -809,7 +809,7 @@ static int kona_peri_clk_enable(struct clk_hw *hw)
 	struct kona_clk *bcm_clk = to_kona_clk(hw);
 	struct bcm_clk_gate *gate = &bcm_clk->u.peri->gate;
 
-	return clk_gate(bcm_clk->ccu, bcm_clk->name, gate, true);
+	return clk_gate(bcm_clk->ccu, bcm_clk->init_data.name, gate, true);
 }
 
 static void kona_peri_clk_disable(struct clk_hw *hw)
@@ -817,7 +817,7 @@ static void kona_peri_clk_disable(struct clk_hw *hw)
 	struct kona_clk *bcm_clk = to_kona_clk(hw);
 	struct bcm_clk_gate *gate = &bcm_clk->u.peri->gate;
 
-	(void)clk_gate(bcm_clk->ccu, bcm_clk->name, gate, false);
+	(void)clk_gate(bcm_clk->ccu, bcm_clk->init_data.name, gate, false);
 }
 
 static int kona_peri_clk_is_enabled(struct clk_hw *hw)
@@ -875,12 +875,13 @@ static int kona_peri_clk_set_parent(struct clk_hw *hw, u8 index)
 
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
@@ -939,10 +940,12 @@ static int kona_peri_clk_set_rate(struct clk_hw *hw, unsigned long rate,
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
@@ -964,7 +967,7 @@ static bool __peri_clk_init(struct kona_clk *bcm_clk)
 {
 	struct ccu_data *ccu = bcm_clk->ccu;
 	struct peri_clk_data *peri = bcm_clk->u.peri;
-	const char *name = bcm_clk->name;
+	const char *name = bcm_clk->init_data.name;
 	struct bcm_clk_trig *trig;
 
 	BUG_ON(bcm_clk->type != bcm_clk_peri);
diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
index dee6909..1a7eba4 100644
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
1.9.1

