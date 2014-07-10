Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaGJNei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:34:38 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:45681 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaGJNef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:34:35 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, rabin@rab.in,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tomasz.figa@gmail.com
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [RFC v3 4/5] clk: per-user clock accounting for debug
Date: Thu, 10 Jul 2014 15:32:25 +0200
Message-Id: <1404999146-32691-5-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404999146-32691-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1404999146-32691-1-git-send-email-tomeu.vizoso@collabora.com>
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
---
 drivers/clk/clk.c           | 35 +++++++++++++++++++++++++++++++----
 drivers/clk/clk.h           |  3 ++-
 drivers/clk/clkdev.c        | 16 ++++++++++++----
 include/linux/clk-private.h |  4 ++++
 4 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index cc1d09b..9d51900 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -568,7 +568,8 @@ static int clk_disable_unused(void)
 }
 late_initcall_sync(clk_disable_unused);
 
-struct clk *__clk_create_clk(struct clk_core *clk_core)
+struct clk *__clk_create_clk(struct clk_core *clk_core, const char *dev,
+			     const char *con)
 {
 	struct clk *clk;
 
@@ -581,6 +582,8 @@ struct clk *__clk_create_clk(struct clk_core *clk_core)
 		return ERR_PTR(-ENOMEM);
 
 	clk->core = clk_core;
+	clk->dev_id = dev;
+	clk->con_id = con;
 
 	return clk;
 }
@@ -955,7 +958,20 @@ EXPORT_SYMBOL_GPL(clk_provider_disable);
  */
 void clk_disable(struct clk *clk_user)
 {
-	clk_provider_disable(clk_to_clk_core(clk_user));
+	struct clk_core *clk = clk_to_clk_core(clk_user);
+	unsigned long flags;
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
 
@@ -1016,7 +1032,17 @@ EXPORT_SYMBOL_GPL(clk_provider_enable);
  */
 int clk_enable(struct clk *clk_user)
 {
-	return clk_provider_enable(clk_to_clk_core(clk_user));
+	struct clk_core *clk = clk_to_clk_core(clk_user);
+	unsigned long flags;
+	int ret;
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
 
@@ -1692,8 +1718,9 @@ EXPORT_SYMBOL_GPL(clk_provider_get_parent);
 struct clk *clk_get_parent(struct clk *clk_user)
 {
 	struct clk_core *clk = clk_to_clk_core(clk_user);
+	struct clk_core *parent = clk_provider_get_parent(clk);
 
-	return __clk_create_clk(clk_provider_get_parent(clk));
+	return __clk_create_clk(parent, clk_user->dev_id, clk_user->con_id);
 }
 EXPORT_SYMBOL_GPL(clk_get_parent);
 
diff --git a/drivers/clk/clk.h b/drivers/clk/clk.h
index 4d7398f..3987594 100644
--- a/drivers/clk/clk.h
+++ b/drivers/clk/clk.h
@@ -23,5 +23,6 @@ static inline struct clk_core *clk_to_clk_core(struct clk *clk)
 {
 	return clk->core;
 }
-struct clk *__clk_create_clk(struct clk_core *clk_core);
+struct clk *__clk_create_clk(struct clk_core *clk_core, const char *dev,
+			     const char *con);
 #endif
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 10020b2..6ea91bf 100644
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
 
@@ -128,7 +130,9 @@ struct clk_core *of_clk_provider_get_by_name(struct device_node *np, const char
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
@@ -195,7 +199,9 @@ EXPORT_SYMBOL_GPL(clk_provider_get_sys);
 
 struct clk *clk_get_sys(const char *dev_id, const char *con_id)
 {
-	return __clk_create_clk(clk_provider_get_sys(dev_id, con_id));
+	struct clk_core *clk = clk_provider_get_sys(dev_id, con_id);
+
+	return __clk_create_clk(clk, dev_id, con_id);
 }
 EXPORT_SYMBOL(clk_get_sys);
 
@@ -218,7 +224,9 @@ EXPORT_SYMBOL(clk_provider_get);
 
 struct clk *clk_get(struct device *dev, const char *con_id)
 {
-	return __clk_create_clk(clk_provider_get(dev, con_id));
+	const char *dev_id = dev ? dev_name(dev) : NULL;
+
+	return __clk_create_clk(clk_provider_get(dev, con_id), dev_id, con_id);
 }
 EXPORT_SYMBOL(clk_get);
 
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 2c1ece9..9657fc8 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -57,6 +57,10 @@ struct clk_core {
 
 struct clk {
 	struct clk_core	*core;
+	unsigned int	enable_count;
+	const char	*dev_id;
+	const char	*con_id;
+	void		*last_disable;
 };
 
 /*
-- 
1.9.3

