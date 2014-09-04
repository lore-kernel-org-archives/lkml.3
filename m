Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263AbaIDBBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 21:01:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39509 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100AbaIDBBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 21:01:10 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 2/4] clk: Make __clk_lookup() use a list instead of tree search
Date: Wed,  3 Sep 2014 18:01:04 -0700
Message-Id: <1409792466-5092-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.rc2.4.g1a517f0
In-Reply-To: <1409792466-5092-1-git-send-email-sboyd@codeaurora.org>
References: <1409792466-5092-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future we're going to move the prepare lock to be a
per-clock ww_mutex. __clk_lookup() is called very deep in the
set-rate path and we would like to avoid having to take all the
locks in the clock tree to search for a clock (basically
defeating the purpose of introducing per-clock locks). Introduce
a new list that contains all clocks registered in the system and
walk this list until the clock is found.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c           | 52 +++++++++++++++++----------------------------
 include/linux/clk-private.h |  1 +
 2 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 1feaf708aa49..248a8612a12d 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -33,8 +33,10 @@ static struct task_struct *enable_owner;
 static int prepare_refcnt;
 static int enable_refcnt;
 
+static DEFINE_MUTEX(clk_lookup_lock);
 static HLIST_HEAD(clk_root_list);
 static HLIST_HEAD(clk_orphan_list);
+static HLIST_HEAD(clk_lookup_list);
 static LIST_HEAD(clk_notifier_list);
 
 /***           locking             ***/
@@ -680,46 +682,23 @@ out:
 }
 EXPORT_SYMBOL_GPL(__clk_is_enabled);
 
-static struct clk *__clk_lookup_subtree(const char *name, struct clk *clk)
-{
-	struct clk *child;
-	struct clk *ret;
-
-	if (!strcmp(clk->name, name))
-		return clk;
-
-	hlist_for_each_entry(child, &clk->children, child_node) {
-		ret = __clk_lookup_subtree(name, child);
-		if (ret)
-			return ret;
-	}
-
-	return NULL;
-}
-
 struct clk *__clk_lookup(const char *name)
 {
-	struct clk *root_clk;
-	struct clk *ret;
+	struct clk *clk;
 
 	if (!name)
 		return NULL;
 
-	/* search the 'proper' clk tree first */
-	hlist_for_each_entry(root_clk, &clk_root_list, child_node) {
-		ret = __clk_lookup_subtree(name, root_clk);
-		if (ret)
-			return ret;
+	mutex_lock(&clk_lookup_lock);
+	hlist_for_each_entry(clk, &clk_lookup_list, lookup_node) {
+		if (!strcmp(clk->name, name))
+			goto found;
 	}
+	clk = NULL;
+found:
+	mutex_unlock(&clk_lookup_lock);
 
-	/* if not found, then search the orphan tree */
-	hlist_for_each_entry(root_clk, &clk_orphan_list, child_node) {
-		ret = __clk_lookup_subtree(name, root_clk);
-		if (ret)
-			return ret;
-	}
-
-	return NULL;
+	return clk;
 }
 
 /*
@@ -1826,6 +1805,11 @@ int __clk_init(struct device *dev, struct clk *clk)
 
 	clk->parent = __clk_init_parent(clk);
 
+	/* Insert into clock lookup list */
+	mutex_lock(&clk_lookup_lock);
+	hlist_add_head(&clk->lookup_node, &clk_lookup_list);
+	mutex_unlock(&clk_lookup_lock);
+
 	/*
 	 * Populate clk->parent if parent has already been __clk_init'd.  If
 	 * parent has not yet been __clk_init'd then place clk in the orphan
@@ -2120,6 +2104,10 @@ void clk_unregister(struct clk *clk)
 
 	hlist_del_init(&clk->child_node);
 
+	mutex_lock(&clk_lookup_lock);
+	hlist_del_init(&clk->lookup_node);
+	mutex_unlock(&clk_lookup_lock);
+
 	if (clk->prepare_count)
 		pr_warn("%s: unregistering prepared clock: %s\n",
 					__func__, clk->name);
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index efbf70b9fd84..3cd98a930006 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -48,6 +48,7 @@ struct clk {
 	unsigned long		accuracy;
 	struct hlist_head	children;
 	struct hlist_node	child_node;
+	struct hlist_node	lookup_node;
 	unsigned int		notifier_count;
 #ifdef CONFIG_DEBUG_FS
 	struct dentry		*dentry;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

