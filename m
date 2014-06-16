Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaFPNjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:39:53 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:40400 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbaFPNjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:39:51 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 2/7] clk: kona: don't init clocks at startup time
Date: Mon, 16 Jun 2014 08:40:02 -0500
Message-Id: <1402926007-4436-3-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402926007-4436-1-git-send-email-elder@linaro.org>
References: <1402926007-4436-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last thing done for CCU setup is a call to kona_ccu_init().
This locks and enables write access on the CCU, then calls
__kona_clk_init() for all of the clocks it provides.  The purpose of
this was to get or set the initial state of all the registers
related to each clock.

There's no reason to do this though.  The common clock framework
assumes nothing about the state of the hardware, and if a driver
requires its clock to be in a particular state it can set that
state up itself.

Instead of initializing clocks at startup time, define a prepare
method that performs that step when a clock is first needed.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-kona-setup.c |  3 ---
 drivers/clk/bcm/clk-kona.c       | 49 +++++++++++++++++++---------------------
 drivers/clk/bcm/clk-kona.h       |  1 -
 3 files changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/clk/bcm/clk-kona-setup.c b/drivers/clk/bcm/clk-kona-setup.c
index e5aeded..317f7dd 100644
--- a/drivers/clk/bcm/clk-kona-setup.c
+++ b/drivers/clk/bcm/clk-kona-setup.c
@@ -867,9 +867,6 @@ void __init kona_dt_ccu_setup(struct ccu_data *ccu,
 		goto out_err;
 	}
 
-	if (!kona_ccu_init(ccu))
-		pr_err("Broadcom %s initialization had errors\n", node->name);
-
 	return;
 out_err:
 	kona_ccu_teardown(ccu);
diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index b643d35..cacbfd6 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -1032,43 +1032,38 @@ static bool __peri_clk_init(struct kona_clk *bcm_clk)
 	return true;
 }
 
-static bool __kona_clk_init(struct kona_clk *bcm_clk)
+/* Clock operations */
+
+static int kona_clk_prepare(struct clk_hw *hw)
 {
+	struct kona_clk *bcm_clk = to_kona_clk(hw);
+	struct ccu_data *ccu;
+	unsigned long flags;
+	int ret = 0;
+
+	ccu = bcm_clk->ccu;
+	flags = ccu_lock(ccu);
+	__ccu_write_enable(ccu);
+
 	switch (bcm_clk->type) {
 	case bcm_clk_peri:
-		return __peri_clk_init(bcm_clk);
+		if (!__peri_clk_init(bcm_clk))
+			ret = -EINVAL;
+		break;
 	default:
 		BUG();
 	}
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
 
 	__ccu_write_disable(ccu);
 	ccu_unlock(ccu, flags);
-	return success;
+
+	return ret;
 }
 
-/* Clock operations */
+static void kona_clk_unprepare(struct clk_hw *hw)
+{
+	/* Nothing to do. */
+}
 
 static int kona_peri_clk_enable(struct clk_hw *hw)
 {
@@ -1270,6 +1265,8 @@ static int kona_peri_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 }
 
 struct clk_ops kona_peri_clk_ops = {
+	.prepare = kona_clk_prepare,
+	.unprepare = kona_clk_unprepare,
 	.enable = kona_peri_clk_enable,
 	.disable = kona_peri_clk_disable,
 	.is_enabled = kona_peri_clk_is_enabled,
diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
index 2537b30..4c7e796 100644
--- a/drivers/clk/bcm/clk-kona.h
+++ b/drivers/clk/bcm/clk-kona.h
@@ -511,6 +511,5 @@ extern u64 scaled_div_build(struct bcm_clk_div *div, u32 div_value,
 extern struct clk *kona_clk_setup(struct kona_clk *bcm_clk);
 extern void __init kona_dt_ccu_setup(struct ccu_data *ccu,
 				struct device_node *node);
-extern bool __init kona_ccu_init(struct ccu_data *ccu);
 
 #endif /* _CLK_KONA_H */
-- 
1.9.1

