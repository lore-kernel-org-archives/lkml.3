Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbaIKO0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:26:45 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38088 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbaIKO0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:26:42 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, tomasz.figa@gmail.com,
        Peter De Schrijver <pdeschrijver@nvidia.com>, rabin@rab.in,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v11 4/9] clk: per-user clock accounting for debug
Date: Thu, 11 Sep 2014 16:26:18 +0200
Message-Id: <1410445583-18626-2-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410445583-18626-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1410445421-18362-1-git-send-email-tomeu.vizoso@collabora.com>
 <1410445583-18626-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a clock has multiple users, the WARNING on imbalance of
enable/disable may not show the guilty party since although they may
have commited the error earlier, the warning is emitted later when some
other user, presumably innocent, disables the clock.

Provide per-user clock enable/disable accounting and disabler tracking
in order to help debug these problems.

Based on previous work by Rabin Vincent <rabin@rab.in>.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Tested-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/clk/clk.c           | 38 ++++++++++++++++++++++++++++++++++----
 drivers/clk/clk.h           |  3 ++-
 drivers/clk/clkdev.c        | 14 ++++++++++----
 include/linux/clk-private.h |  5 +++++
 4 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index ce84b1f..61a3492 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -543,7 +543,8 @@ static int clk_disable_unused(void)
 }
 late_initcall_sync(clk_disable_unused);
 
-struct clk *__clk_create_clk(struct clk_core *clk_core)
+struct clk *__clk_create_clk(struct clk_core *clk_core, const char *dev,
+			     const char *con)
 {
 	struct clk *clk;
 
@@ -556,6 +557,8 @@ struct clk *__clk_create_clk(struct clk_core *clk_core)
 		return ERR_PTR(-ENOMEM);
 
 	clk->core = clk_core;
+	clk->dev_id = dev;
+	clk->con_id = con;
 
 	return clk;
 }
@@ -936,10 +939,25 @@ EXPORT_SYMBOL_GPL(clk_provider_disable);
  */
 void clk_disable(struct clk *clk_user)
 {
+	struct clk_core *clk;
+	unsigned long flags;
+
 	if (IS_ERR_OR_NULL(clk_user))
 		return;
 
-	clk_provider_disable(clk_to_clk_core(clk_user));
+	clk = clk_to_clk_core(clk_user);
+
+	flags = clk_enable_lock();
+	if (!WARN(clk_user->enable_count == 0,
+		  "incorrect disable clk dev %s con %s last disabler %pF\n",
+		  clk_user->dev_id, clk_user->con_id, clk_user->last_disable)) {
+
+		clk_user->last_disable = __builtin_return_address(0);
+		clk_user->enable_count--;
+
+		__clk_disable(clk);
+	}
+	clk_enable_unlock(flags);
 }
 EXPORT_SYMBOL_GPL(clk_disable);
 
@@ -1000,10 +1018,22 @@ EXPORT_SYMBOL_GPL(clk_provider_enable);
  */
 int clk_enable(struct clk *clk_user)
 {
+	struct clk_core *clk;
+	unsigned long flags;
+	int ret;
+
 	if (!clk_user)
 		return 0;
 
-	return clk_provider_enable(clk_to_clk_core(clk_user));
+	clk = clk_to_clk_core(clk_user);
+
+	flags = clk_enable_lock();
+	ret = __clk_enable(clk);
+	if (!ret)
+		clk_user->enable_count++;
+	clk_enable_unlock(flags);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(clk_enable);
 
@@ -1698,7 +1728,7 @@ struct clk *clk_get_parent(struct clk *clk_user)
 	clk = clk_to_clk_core(clk_user);
 	parent = clk_provider_get_parent(clk);
 
-	return __clk_create_clk(parent);
+	return __clk_create_clk(parent, clk_user->dev_id, clk_user->con_id);
 }
 EXPORT_SYMBOL_GPL(clk_get_parent);
 
diff --git a/drivers/clk/clk.h b/drivers/clk/clk.h
index 3b3068b..49eff38 100644
--- a/drivers/clk/clk.h
+++ b/drivers/clk/clk.h
@@ -19,5 +19,6 @@ void of_clk_unlock(void);
 #endif
 
 #if defined(CONFIG_COMMON_CLK)
-struct clk *__clk_create_clk(struct clk_core *clk_core);
+struct clk *__clk_create_clk(struct clk_core *clk_core, const char *dev,
+			     const char *con);
 #endif
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 080b3df..f7b352a 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -76,7 +76,9 @@ struct clk_core *of_clk_provider_get(struct device_node *np, int index)
 
 struct clk *of_clk_get(struct device_node *np, int index)
 {
-	return __clk_create_clk(of_clk_provider_get(np, index));
+	struct clk_core *clk = of_clk_provider_get(np, index);
+
+	return __clk_create_clk(clk, np->full_name, NULL);
 }
 EXPORT_SYMBOL(of_clk_get);
 
@@ -129,7 +131,9 @@ struct clk_core *of_clk_provider_get_by_name(struct device_node *np, const char
  */
 struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
 {
-	return __clk_create_clk(of_clk_provider_get_by_name(np, name));
+	struct clk_core *clk = of_clk_provider_get_by_name(np, name);
+
+	return __clk_create_clk(clk, np->full_name, NULL);
 }
 EXPORT_SYMBOL(of_clk_get_by_name);
 #endif
@@ -201,7 +205,7 @@ struct clk *clk_get_sys(const char *dev_id, const char *con_id)
 #if defined(CONFIG_COMMON_CLK)
 	struct clk_core *clk = clk_provider_get_sys(dev_id, con_id);
 
-	return __clk_create_clk(clk);
+	return __clk_create_clk(clk, dev_id, con_id);
 #else
 	struct clk_lookup *cl;
 
@@ -241,7 +245,9 @@ EXPORT_SYMBOL(clk_provider_get);
 struct clk *clk_get(struct device *dev, const char *con_id)
 {
 #if defined(CONFIG_COMMON_CLK)
-	return __clk_create_clk(clk_provider_get(dev, con_id));
+        const char *dev_id = dev ? dev_name(dev) : NULL;
+
+	return __clk_create_clk(clk_provider_get(dev, con_id), dev_id, con_id);
 #else
 	const char *dev_id = dev ? dev_name(dev) : NULL;
 	struct clk *clk;
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 2c1ece9..ce6a528 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -57,6 +57,11 @@ struct clk_core {
 
 struct clk {
 	struct clk_core	*core;
+	const char	*dev_id;
+	const char	*con_id;
+
+	unsigned int	enable_count;
+	void		*last_disable;
 };
 
 /*
-- 
1.9.3

