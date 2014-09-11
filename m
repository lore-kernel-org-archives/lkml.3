Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbaIKO2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:28:06 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48766 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbaIKO0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:26:43 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, tomasz.figa@gmail.com,
        Peter De Schrijver <pdeschrijver@nvidia.com>, rabin@rab.in,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v11 5/9] clk: Add floor and ceiling constraints to clock rates
Date: Thu, 11 Sep 2014 16:26:19 +0200
Message-Id: <1410445583-18626-3-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410445583-18626-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1410445421-18362-1-git-send-email-tomeu.vizoso@collabora.com>
 <1410445583-18626-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a way for clock consumers to set maximum and minimum rates. This can be
used for thermal drivers to set ceiling rates, or by misc. drivers to set
floor rates to assure a minimum performance level.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Tested-by: Heiko Stuebner <heiko@sntech.de>

---

v9: * Apply first all the floor constraints, then the ceiling constraints.
    * WARN on ceiling constraints below the current floor, for a given user clk

v5: * Move the storage of constraints to the per-user clk struct, as suggested
      by Stephen Warren.
---
 drivers/clk/clk.c           | 43 +++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/clk.h           |  1 +
 drivers/clk/clkdev.c        |  2 +-
 include/linux/clk-private.h |  5 +++++
 include/linux/clk.h         | 18 ++++++++++++++++++
 5 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 61a3492..3a961c6 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -560,6 +560,8 @@ struct clk *__clk_create_clk(struct clk_core *clk_core, const char *dev,
 	clk->dev_id = dev;
 	clk->con_id = con;
 
+	hlist_add_head(&clk->child_node, &clk_core->per_user_clks);
+
 	return clk;
 }
 
@@ -1625,6 +1627,7 @@ static void clk_change_rate(struct clk_core *clk)
 int clk_provider_set_rate(struct clk_core *clk, unsigned long rate)
 {
 	struct clk_core *top, *fail_clk;
+	struct clk *clk_user;
 	int ret = 0;
 
 	if (!clk)
@@ -1633,6 +1636,15 @@ int clk_provider_set_rate(struct clk_core *clk, unsigned long rate)
 	/* prevent racing with updates to the clock topology */
 	clk_prepare_lock();
 
+	hlist_for_each_entry(clk_user, &clk->per_user_clks, child_node) {
+		rate = max(rate, clk_user->floor_constraint);
+	}
+
+	hlist_for_each_entry(clk_user, &clk->per_user_clks, child_node) {
+		if (clk_user->ceiling_constraint > 0)
+			rate = min(rate, clk_user->ceiling_constraint);
+	}
+
 	/* bail early if nothing to do */
 	if (rate == clk_provider_get_rate(clk))
 		goto out;
@@ -1699,6 +1711,29 @@ int clk_set_rate(struct clk *clk_user, unsigned long rate)
 }
 EXPORT_SYMBOL_GPL(clk_set_rate);
 
+int clk_set_floor_rate(struct clk *clk_user, unsigned long rate)
+{
+	struct clk_core *clk = clk_to_clk_core(clk_user);
+
+	clk_user->floor_constraint = rate;
+	return clk_provider_set_rate(clk, clk_provider_get_rate(clk));
+}
+EXPORT_SYMBOL_GPL(clk_set_floor_rate);
+
+int clk_set_ceiling_rate(struct clk *clk_user, unsigned long rate)
+{
+	struct clk_core *clk = clk_to_clk_core(clk_user);
+
+	WARN(rate > 0 && rate < clk_user->floor_constraint,
+	     "clk %s dev %s con %s: new ceiling %lu lower than existing floor %lu\n",
+	     __clk_get_name(clk), clk_user->dev_id, clk_user->con_id, rate,
+	     clk_user->floor_constraint);
+
+	clk_user->ceiling_constraint = rate;
+	return clk_provider_set_rate(clk, clk_provider_get_rate(clk));
+}
+EXPORT_SYMBOL_GPL(clk_set_ceiling_rate);
+
 struct clk_core *clk_provider_get_parent(struct clk_core *clk)
 {
 	struct clk_core *parent;
@@ -2043,6 +2078,8 @@ int __clk_init(struct device *dev, struct clk_core *clk)
 			}
 	 }
 
+	INIT_HLIST_HEAD(&clk->per_user_clks);
+
 	/*
 	 * optional platform-specific magic
 	 *
@@ -2493,6 +2530,12 @@ int clk_notifier_unregister(struct clk *clk_user, struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(clk_notifier_unregister);
 
+void __clk_free_clk(struct clk *clk_user)
+{
+	hlist_del(&clk_user->child_node);
+	kfree(clk_user);
+}
+
 #ifdef CONFIG_OF
 /**
  * struct of_clk_provider - Clock provider registration structure
diff --git a/drivers/clk/clk.h b/drivers/clk/clk.h
index 49eff38..005deb3 100644
--- a/drivers/clk/clk.h
+++ b/drivers/clk/clk.h
@@ -21,4 +21,5 @@ void of_clk_unlock(void);
 #if defined(CONFIG_COMMON_CLK)
 struct clk *__clk_create_clk(struct clk_core *clk_core, const char *dev,
 			     const char *con);
+void __clk_free_clk(struct clk *clk_user);
 #endif
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index f7b352a..89193de 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -270,7 +270,7 @@ void clk_put(struct clk *clk)
 #if defined(CONFIG_COMMON_CLK)
 	clk_core_t *core = clk_to_clk_core(clk);
 
-	kfree(clk);
+	__clk_free_clk(clk);
 	__clk_put(core);
 #else
 	__clk_put(clk);
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index ce6a528..8126046 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -48,6 +48,7 @@ struct clk_core {
 	unsigned long		accuracy;
 	struct hlist_head	children;
 	struct hlist_node	child_node;
+	struct hlist_head	per_user_clks;
 	unsigned int		notifier_count;
 #ifdef CONFIG_DEBUG_FS
 	struct dentry		*dentry;
@@ -62,6 +63,10 @@ struct clk {
 
 	unsigned int	enable_count;
 	void		*last_disable;
+
+	unsigned long	floor_constraint;
+	unsigned long	ceiling_constraint;
+	struct hlist_node child_node;
 };
 
 /*
diff --git a/include/linux/clk.h b/include/linux/clk.h
index f46a2eb..066b100 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -275,6 +275,24 @@ long clk_round_rate(struct clk *clk, unsigned long rate);
 int clk_set_rate(struct clk *clk, unsigned long rate);
 
 /**
+ * clk_set_floor_rate - set a minimum clock rate for a clock source
+ * @clk: clock source
+ * @rate: desired minimum clock rate in Hz
+ *
+ * Returns success (0) or negative errno.
+ */
+int clk_set_floor_rate(struct clk *clk, unsigned long rate);
+
+/**
+ * clk_set_ceiling_rate - set a maximum clock rate for a clock source
+ * @clk: clock source
+ * @rate: desired maximum clock rate in Hz
+ *
+ * Returns success (0) or negative errno.
+ */
+int clk_set_ceiling_rate(struct clk *clk, unsigned long rate);
+
+/**
  * clk_set_parent - set the parent clock source for this clock
  * @clk: clock source
  * @parent: parent clock source
-- 
1.9.3

