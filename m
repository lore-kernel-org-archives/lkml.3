Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab3C1U7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 16:59:54 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:63341 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3C1U7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 16:59:52 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, rajagopal.venkat@linaro.org,
        davidb@codeaurora.org, ulf.hansson@linaro.org,
        laurent.pinchart@ideasonboard.com, tglx@linutronix.de,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 1/2] clk: abstract locking out into helper functions
Date: Thu, 28 Mar 2013 13:59:01 -0700
Message-Id: <1364504343-12635-2-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364504343-12635-1-git-send-email-mturquette@linaro.org>
References: <1364445958-2999-1-git-send-email-mturquette@linaro.org>
 <1364504343-12635-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create locking helpers for the global mutex and global spinlock.  The
definitions of these helpers will be expanded upon in the next patch
which introduces reentrancy into the locking scheme.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: David Brown <davidb@codeaurora.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
Changes since v5:
 * pass flags by value instead of by reference in clk_enable_{un}lock

 drivers/clk/clk.c |   99 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 61 insertions(+), 38 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 5e8ffff..0b5d612 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -27,6 +27,29 @@ static HLIST_HEAD(clk_root_list);
 static HLIST_HEAD(clk_orphan_list);
 static LIST_HEAD(clk_notifier_list);
 
+/***           locking             ***/
+static void clk_prepare_lock(void)
+{
+	mutex_lock(&prepare_lock);
+}
+
+static void clk_prepare_unlock(void)
+{
+	mutex_unlock(&prepare_lock);
+}
+
+static unsigned long clk_enable_lock(void)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&enable_lock, flags);
+	return flags;
+}
+
+static void clk_enable_unlock(unsigned long flags)
+{
+	spin_unlock_irqrestore(&enable_lock, flags);
+}
+
 /***        debugfs support        ***/
 
 #ifdef CONFIG_COMMON_CLK_DEBUG
@@ -69,7 +92,7 @@ static int clk_summary_show(struct seq_file *s, void *data)
 	seq_printf(s, "   clock                        enable_cnt  prepare_cnt  rate\n");
 	seq_printf(s, "---------------------------------------------------------------------\n");
 
-	mutex_lock(&prepare_lock);
+	clk_prepare_lock();
 
 	hlist_for_each_entry(c, &clk_root_list, child_node)
 		clk_summary_show_subtree(s, c, 0);
@@ -77,7 +100,7 @@ static int clk_summary_show(struct seq_file *s, void *data)
 	hlist_for_each_entry(c, &clk_orphan_list, child_node)
 		clk_summary_show_subtree(s, c, 0);
 
-	mutex_unlock(&prepare_lock);
+	clk_prepare_unlock();
 
 	return 0;
 }
@@ -130,7 +153,7 @@ static int clk_dump(struct seq_file *s, void *data)
 
 	seq_printf(s, "{");
 
-	mutex_lock(&prepare_lock);
+	clk_prepare_lock();
 
 	hlist_for_each_entry(c, &clk_root_list, child_node) {
 		if (!first_node)
@@ -144,7 +167,7 @@ static int clk_dump(struct seq_file *s, void *data)
 		clk_dump_subtree(s, c, 0);
 	}
 
-	mutex_unlock(&prepare_lock);
+	clk_prepare_unlock();
 
 	seq_printf(s, "}");
 	return 0;
@@ -316,7 +339,7 @@ static int __init clk_debug_init(void)
 	if (!orphandir)
 		return -ENOMEM;
 
-	mutex_lock(&prepare_lock);
+	clk_prepare_lock();
 
 	hlist_for_each_entry(clk, &clk_root_list, child_node)
 		clk_debug_create_subtree(clk, rootdir);
@@ -326,7 +349,7 @@ static int __init clk_debug_init(void)
 
 	inited = 1;
 
-	mutex_unlock(&prepare_lock);
+	clk_prepare_unlock();
 
 	return 0;
 }
@@ -372,7 +395,7 @@ static void clk_disable_unused_subtree(struct clk *clk)
 	hlist_for_each_entry(child, &clk->children, child_node)
 		clk_disable_unused_subtree(child);
 
-	spin_lock_irqsave(&enable_lock, flags);
+	flags = clk_enable_lock();
 
 	if (clk->enable_count)
 		goto unlock_out;
@@ -393,7 +416,7 @@ static void clk_disable_unused_subtree(struct clk *clk)
 	}
 
 unlock_out:
-	spin_unlock_irqrestore(&enable_lock, flags);
+	clk_enable_unlock(flags);
 
 out:
 	return;
@@ -403,7 +426,7 @@ static int clk_disable_unused(void)
 {
 	struct clk *clk;
 
-	mutex_lock(&prepare_lock);
+	clk_prepare_lock();
 
 	hlist_for_each_entry(clk, &clk_root_list, child_node)
 		clk_disable_unused_subtree(clk);
@@ -417,7 +440,7 @@ static int clk_disable_unused(void)
 	hlist_for_each_entry(clk, &clk_orphan_list, child_node)
 		clk_unprepare_unused_subtree(clk);
 
-	mutex_unlock(&prepare_lock);
+	clk_prepare_unlock();
 
 	return 0;
 }
@@ -600,9 +623,9 @@ void __clk_unprepare(struct clk *clk)
  */
 void clk_unprepare(struct clk *clk)
 {
-	mutex_lock(&prepare_lock);
+	clk_prepare_lock();
 	__clk_unprepare(clk);
-	mutex_unlock(&prepare_lock);
+	clk_prepare_unlock();
 }
 EXPORT_SYMBOL_GPL(clk_unprepare);
 
@@ -648,9 +671,9 @@ int clk_prepare(struct clk *clk)
 {
 	int ret;
 
-	mutex_lock(&prepare_lock);
+	clk_prepare_lock();
 	ret = __clk_prepare(clk);
-	mutex_unlock(&prepare_lock);
+	clk_prepare_unlock();
 
 	return ret;
 }
@@ -692,9 +715,9 @@ void clk_disable(struct clk *clk)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&enable_lock, flags);
+	flags = clk_enable_lock();
 	__clk_disable(clk);
-	spin_unlock_irqrestore(&enable_lock, flags);
+	clk_enable_unlock(flags);
 }
 EXPORT_SYMBOL_GPL(clk_disable);
 
@@ -745,9 +768,9 @@ int clk_enable(struct clk *clk)
 	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&enable_lock, flags);
+	flags = clk_enable_lock();
 	ret = __clk_enable(clk);
-	spin_unlock_irqrestore(&enable_lock, flags);
+	clk_enable_unlock(flags);
 
 	return ret;
 }
@@ -792,9 +815,9 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
 {
 	unsigned long ret;
 
-	mutex_lock(&prepare_lock);
+	clk_prepare_lock();
 	ret = __clk_round_rate(clk, rate);
-	mutex_unlock(&prepare_lock);
+	clk_prepare_unlock();
 
 	return ret;
 }
@@ -889,13 +912,13 @@ unsigned long clk_get_rate(struct clk *clk)
 {
 	unsigned long rate;
 
-	mutex_lock(&prepare_lock);
+	clk_prepare_lock();
 
 	if (clk && (clk->flags & CLK_GET_RATE_NOCACHE))
 		__clk_recalc_rates(clk, 0);
 
 	rate = __clk_get_rate(clk);
-	mutex_unlock(&prepare_lock);
+	clk_prepare_unlock();
 
 	return rate;
 }
@@ -1100,7 +1123,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	int ret = 0;
 
 	/* prevent racing with updates to the clock topology */
-	mutex_lock(&prepare_lock);
+	clk_prepare_lock();
 
 	/* bail early if nothing to do */
 	if (rate == clk->rate)
@@ -1132,7 +1155,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	clk_change_rate(top);
 
 out:
-	mutex_unlock(&prepare_lock);
+	clk_prepare_unlock();
 
 	return ret;
 }
@@ -1148,9 +1171,9 @@ struct clk *clk_get_parent(struct clk *clk)
 {
 	struct clk *parent;
 
-	mutex_lock(&prepare_lock);
+	clk_prepare_lock();
 	parent = __clk_get_parent(clk);
-	mutex_unlock(&prepare_lock);
+	clk_prepare_unlock();
 
 	return parent;
 }
@@ -1294,19 +1317,19 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
 		__clk_prepare(parent);
 
 	/* FIXME replace with clk_is_enabled(clk) someday */
-	spin_lock_irqsave(&enable_lock, flags);
+	flags = clk_enable_lock();
 	if (clk->enable_count)
 		__clk_enable(parent);
-	spin_unlock_irqrestore(&enable_lock, flags);
+	clk_enable_unlock(flags);
 
 	/* change clock input source */
 	ret = clk->ops->set_parent(clk->hw, i);
 
 	/* clean up old prepare and enable */
-	spin_lock_irqsave(&enable_lock, flags);
+	flags = clk_enable_lock();
 	if (clk->enable_count)
 		__clk_disable(old_parent);
-	spin_unlock_irqrestore(&enable_lock, flags);
+	clk_enable_unlock(flags);
 
 	if (clk->prepare_count)
 		__clk_unprepare(old_parent);
@@ -1338,7 +1361,7 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 		return -ENOSYS;
 
 	/* prevent racing with updates to the clock topology */
-	mutex_lock(&prepare_lock);
+	clk_prepare_lock();
 
 	if (clk->parent == parent)
 		goto out;
@@ -1367,7 +1390,7 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	__clk_reparent(clk, parent);
 
 out:
-	mutex_unlock(&prepare_lock);
+	clk_prepare_unlock();
 
 	return ret;
 }
@@ -1390,7 +1413,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 	if (!clk)
 		return -EINVAL;
 
-	mutex_lock(&prepare_lock);
+	clk_prepare_lock();
 
 	/* check to see if a clock with this name is already registered */
 	if (__clk_lookup(clk->name)) {
@@ -1514,7 +1537,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 	clk_debug_register(clk);
 
 out:
-	mutex_unlock(&prepare_lock);
+	clk_prepare_unlock();
 
 	return ret;
 }
@@ -1748,7 +1771,7 @@ int clk_notifier_register(struct clk *clk, struct notifier_block *nb)
 	if (!clk || !nb)
 		return -EINVAL;
 
-	mutex_lock(&prepare_lock);
+	clk_prepare_lock();
 
 	/* search the list of notifiers for this clk */
 	list_for_each_entry(cn, &clk_notifier_list, node)
@@ -1772,7 +1795,7 @@ int clk_notifier_register(struct clk *clk, struct notifier_block *nb)
 	clk->notifier_count++;
 
 out:
-	mutex_unlock(&prepare_lock);
+	clk_prepare_unlock();
 
 	return ret;
 }
@@ -1797,7 +1820,7 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 	if (!clk || !nb)
 		return -EINVAL;
 
-	mutex_lock(&prepare_lock);
+	clk_prepare_lock();
 
 	list_for_each_entry(cn, &clk_notifier_list, node)
 		if (cn->clk == clk)
@@ -1818,7 +1841,7 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 		ret = -ENOENT;
 	}
 
-	mutex_unlock(&prepare_lock);
+	clk_prepare_unlock();
 
 	return ret;
 }
-- 
1.7.10.4

