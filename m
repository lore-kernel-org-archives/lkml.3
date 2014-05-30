Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbaE3PB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:01:29 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18815 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaE3PB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:01:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 30 May 2014 07:56:24 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Mike Turquette <mturquette@linaro.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: flatten clk tree in debugfs
Date: Fri, 30 May 2014 18:01:20 +0300
Message-ID: <1401462080-14848-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch flattens the clk tree in CCF debugfs. Instead of representing the
clocks and their hierarchy as a directory structure under
/sys/kernel/debug/clk, each clock gets a single directory directly under
/sys/kernel/debug/clk. The orphans directory is replaced by a file called
clk_orphan_summary.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/clk.c |  114 ++++++++++++++++------------------------------------
 1 files changed, 35 insertions(+), 79 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index dff0373..453ff3b0 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -36,6 +36,17 @@ static HLIST_HEAD(clk_root_list);
 static HLIST_HEAD(clk_orphan_list);
 static LIST_HEAD(clk_notifier_list);
 
+static struct hlist_head *all_lists[] = {
+	&clk_root_list,
+	&clk_orphan_list,
+	NULL,
+};
+
+static struct hlist_head *orphan_list[] = {
+	&clk_orphan_list,
+	NULL,
+};
+
 /***           locking             ***/
 static void clk_prepare_lock(void)
 {
@@ -98,7 +109,6 @@ static void clk_enable_unlock(unsigned long flags)
 #include <linux/debugfs.h>
 
 static struct dentry *rootdir;
-static struct dentry *orphandir;
 static int inited = 0;
 
 static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
@@ -131,17 +141,16 @@ static void clk_summary_show_subtree(struct seq_file *s, struct clk *c,
 static int clk_summary_show(struct seq_file *s, void *data)
 {
 	struct clk *c;
+	struct hlist_head **lists = (struct hlist_head **)s->private;
 
 	seq_printf(s, "   clock                        enable_cnt  prepare_cnt  rate        accuracy\n");
 	seq_printf(s, "---------------------------------------------------------------------------------\n");
 
 	clk_prepare_lock();
 
-	hlist_for_each_entry(c, &clk_root_list, child_node)
-		clk_summary_show_subtree(s, c, 0);
-
-	hlist_for_each_entry(c, &clk_orphan_list, child_node)
-		clk_summary_show_subtree(s, c, 0);
+	for (; *lists; lists++)
+		hlist_for_each_entry(c, *lists, child_node)
+			clk_summary_show_subtree(s, c, 0);
 
 	clk_prepare_unlock();
 
@@ -194,21 +203,19 @@ static int clk_dump(struct seq_file *s, void *data)
 {
 	struct clk *c;
 	bool first_node = true;
+	struct hlist_head **lists = (struct hlist_head **)s->private;
 
 	seq_printf(s, "{");
 
 	clk_prepare_lock();
 
-	hlist_for_each_entry(c, &clk_root_list, child_node) {
-		if (!first_node)
-			seq_printf(s, ",");
-		first_node = false;
-		clk_dump_subtree(s, c, 0);
-	}
-
-	hlist_for_each_entry(c, &clk_orphan_list, child_node) {
-		seq_printf(s, ",");
-		clk_dump_subtree(s, c, 0);
+	for (; *lists; lists++) {
+		hlist_for_each_entry(c, *lists, child_node) {
+			if (!first_node)
+				seq_puts(s, ",");
+			first_node = false;
+			clk_dump_subtree(s, c, 0);
+		}
 	}
 
 	clk_prepare_unlock();
@@ -306,7 +313,7 @@ static int clk_debug_create_subtree(struct clk *clk, struct dentry *pdentry)
 		goto out;
 
 	hlist_for_each_entry(child, &clk->children, child_node)
-		clk_debug_create_subtree(child, clk->dentry);
+		clk_debug_create_subtree(child, pdentry);
 
 	ret = 0;
 out:
@@ -326,31 +333,12 @@ out:
  */
 static int clk_debug_register(struct clk *clk)
 {
-	struct clk *parent;
-	struct dentry *pdentry;
 	int ret = 0;
 
 	if (!inited)
 		goto out;
 
-	parent = clk->parent;
-
-	/*
-	 * Check to see if a clk is a root clk.  Also check that it is
-	 * safe to add this clk to debugfs
-	 */
-	if (!parent)
-		if (clk->flags & CLK_IS_ROOT)
-			pdentry = rootdir;
-		else
-			pdentry = orphandir;
-	else
-		if (parent->dentry)
-			pdentry = parent->dentry;
-		else
-			goto out;
-
-	ret = clk_debug_create_subtree(clk, pdentry);
+	ret = clk_debug_create_subtree(clk, rootdir);
 
 out:
 	return ret;
@@ -372,39 +360,6 @@ static void clk_debug_unregister(struct clk *clk)
 }
 
 /**
- * clk_debug_reparent - reparent clk node in the debugfs clk tree
- * @clk: the clk being reparented
- * @new_parent: the new clk parent, may be NULL
- *
- * Rename clk entry in the debugfs clk tree if debugfs has been
- * initialized.  Otherwise it bails out early since the debugfs clk tree
- * will be created lazily by clk_debug_init as part of a late_initcall.
- *
- * Caller must hold prepare_lock.
- */
-static void clk_debug_reparent(struct clk *clk, struct clk *new_parent)
-{
-	struct dentry *d;
-	struct dentry *new_parent_d;
-
-	if (!inited)
-		return;
-
-	if (new_parent)
-		new_parent_d = new_parent->dentry;
-	else
-		new_parent_d = orphandir;
-
-	d = debugfs_rename(clk->dentry->d_parent, clk->dentry,
-			new_parent_d, clk->name);
-	if (d)
-		clk->dentry = d;
-	else
-		pr_debug("%s: failed to rename debugfs entry for %s\n",
-				__func__, clk->name);
-}
-
-/**
  * clk_debug_init - lazily create the debugfs clk tree visualization
  *
  * clks are often initialized very early during boot before memory can
@@ -426,19 +381,24 @@ static int __init clk_debug_init(void)
 	if (!rootdir)
 		return -ENOMEM;
 
-	d = debugfs_create_file("clk_summary", S_IRUGO, rootdir, NULL,
+	d = debugfs_create_file("clk_summary", S_IRUGO, rootdir, &all_lists,
 				&clk_summary_fops);
 	if (!d)
 		return -ENOMEM;
 
-	d = debugfs_create_file("clk_dump", S_IRUGO, rootdir, NULL,
+	d = debugfs_create_file("clk_dump", S_IRUGO, rootdir, &all_lists,
 				&clk_dump_fops);
 	if (!d)
 		return -ENOMEM;
 
-	orphandir = debugfs_create_dir("orphans", rootdir);
+	d = debugfs_create_file("clk_orphan_summary", S_IRUGO, rootdir,
+				&orphan_list, &clk_summary_fops);
+	if (!d)
+		return -ENOMEM;
 
-	if (!orphandir)
+	d = debugfs_create_file("clk_orphan_dump", S_IRUGO, rootdir,
+				&orphan_list, &clk_dump_fops);
+	if (!d)
 		return -ENOMEM;
 
 	clk_prepare_lock();
@@ -447,7 +407,7 @@ static int __init clk_debug_init(void)
 		clk_debug_create_subtree(clk, rootdir);
 
 	hlist_for_each_entry(clk, &clk_orphan_list, child_node)
-		clk_debug_create_subtree(clk, orphandir);
+		clk_debug_create_subtree(clk, rootdir);
 
 	inited = 1;
 
@@ -1277,9 +1237,6 @@ static void __clk_set_parent_after(struct clk *clk, struct clk *parent,
 		clk_disable(old_parent);
 		__clk_unprepare(old_parent);
 	}
-
-	/* update debugfs with new clk tree topology */
-	clk_debug_reparent(clk, parent);
 }
 
 static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
@@ -1685,7 +1642,6 @@ out:
 void __clk_reparent(struct clk *clk, struct clk *new_parent)
 {
 	clk_reparent(clk, new_parent);
-	clk_debug_reparent(clk, new_parent);
 	__clk_recalc_accuracies(clk);
 	__clk_recalc_rates(clk, POST_RATE_CHANGE);
 }
-- 
1.7.7.rc0.72.g4b5ea.dirty

