Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbaEFUTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:19:46 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:37781 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbaEFUTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:19:42 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/8] cgroup: collapse cgroup_create() into croup_mkdir()
Date: Tue,  6 May 2014 16:19:28 -0400
Message-Id: <1399407574-21472-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399407574-21472-1-git-send-email-tj@kernel.org>
References: <1399407574-21472-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_mkdir() is the sole user of cgroup_create().  Let's collapse
the latter into the former.  This will help simplifying locking.
While at it, remove now stale comment about inode locking.

This patch doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 52 +++++++++++++---------------------------------------
 1 file changed, 13 insertions(+), 39 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4d58229..69c0ed9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4236,30 +4236,24 @@ err_free_css:
 	return err;
 }
 
-/**
- * cgroup_create - create a cgroup
- * @parent: cgroup that will be parent of the new cgroup
- * @name: name of the new cgroup
- * @mode: mode to set on new cgroup
- */
-static long cgroup_create(struct cgroup *parent, const char *name,
-			  umode_t mode)
+static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
+			umode_t mode)
 {
-	struct cgroup *cgrp;
+	struct cgroup *parent = parent_kn->priv, *cgrp;
 	struct cgroup_root *root = parent->root;
-	int ssid, ret;
 	struct cgroup_subsys *ss;
 	struct kernfs_node *kn;
-
-	mutex_lock(&cgroup_tree_mutex);
+	int ssid, ret;
 
 	/*
-	 * Only live parents can have children.  Note that the liveliness
-	 * check isn't strictly necessary because cgroup_mkdir() and
-	 * cgroup_rmdir() are fully synchronized by i_mutex; however, do it
-	 * anyway so that locking is contained inside cgroup proper and we
-	 * don't get nasty surprises if we ever grow another caller.
+	 * cgroup_mkdir() grabs cgroup_tree_mutex which nests outside
+	 * kernfs active_ref and cgroup_create() already synchronizes
+	 * properly against removal through cgroup_lock_live_group().
+	 * Break it before calling cgroup_create().
 	 */
+	cgroup_get(parent);
+	kernfs_break_active_protection(parent_kn);
+	mutex_lock(&cgroup_tree_mutex);
 	if (!cgroup_lock_live_group(parent)) {
 		ret = -ENODEV;
 		goto out_unlock_tree;
@@ -4358,6 +4352,8 @@ out_unlock:
 	mutex_unlock(&cgroup_mutex);
 out_unlock_tree:
 	mutex_unlock(&cgroup_tree_mutex);
+	kernfs_unbreak_active_protection(parent_kn);
+	cgroup_put(parent);
 	return ret;
 
 out_destroy:
@@ -4365,28 +4361,6 @@ out_destroy:
 	goto out_unlock;
 }
 
-static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
-			umode_t mode)
-{
-	struct cgroup *parent = parent_kn->priv;
-	int ret;
-
-	/*
-	 * cgroup_create() grabs cgroup_tree_mutex which nests outside
-	 * kernfs active_ref and cgroup_create() already synchronizes
-	 * properly against removal through cgroup_lock_live_group().
-	 * Break it before calling cgroup_create().
-	 */
-	cgroup_get(parent);
-	kernfs_break_active_protection(parent_kn);
-
-	ret = cgroup_create(parent, name, mode);
-
-	kernfs_unbreak_active_protection(parent_kn);
-	cgroup_put(parent);
-	return ret;
-}
-
 /*
  * This is called when the refcnt of a css is confirmed to be killed.
  * css_tryget() is now guaranteed to fail.
-- 
1.9.0

