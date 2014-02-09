Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaBINxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:53:05 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:43231 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaBINxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:53:00 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/16] cgroup: drop CGRP_ROOT_SUBSYS_BOUND
Date: Sun,  9 Feb 2014 08:52:30 -0500
Message-Id: <1391953964-22088-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391953964-22088-1-git-send-email-tj@kernel.org>
References: <1391953964-22088-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before kernfs conversion, due to the way super_block lookup works,
cgroup roots were created and made visible before being fully
initialized.  This in turn required a special flag to mark that the
root hasn't been fully initialized so that the destruction path can
tell fully bound ones from half initialized.

That flag is CGRP_ROOT_SUBSYS_BOUND and no longer necessary after the
kernfs conversion as the lookup and creation of new root are atomic
w.r.t. cgroup_mutex.  This patch removes the flag and passes the
requests subsystem mask to cgroup_setup_root() so that it can set the
respective mask bits as subsystems are bound.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  2 --
 kernel/cgroup.c        | 28 ++++------------------------
 2 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index fa415a8..8ca31c1 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -265,8 +265,6 @@ enum {
 
 	/* mount options live below bit 16 */
 	CGRP_ROOT_OPTION_MASK	= (1 << 16) - 1,
-
-	CGRP_ROOT_SUBSYS_BOUND	= (1 << 16), /* subsystems finished binding */
 };
 
 /*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 47160ce..caed061 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -733,7 +733,6 @@ static void cgroup_destroy_root(struct cgroupfs_root *root)
 {
 	struct cgroup *cgrp = &root->top_cgroup;
 	struct cgrp_cset_link *link, *tmp_link;
-	int ret;
 
 	mutex_lock(&cgroup_tree_mutex);
 	mutex_lock(&cgroup_mutex);
@@ -742,11 +741,7 @@ static void cgroup_destroy_root(struct cgroupfs_root *root)
 	BUG_ON(!list_empty(&cgrp->children));
 
 	/* Rebind all subsystems back to the default hierarchy */
-	if (root->flags & CGRP_ROOT_SUBSYS_BOUND) {
-		ret = rebind_subsystems(root, 0, root->subsys_mask);
-		/* Shouldn't be able to fail ... */
-		BUG_ON(ret);
-	}
+	WARN_ON(rebind_subsystems(root, 0, root->subsys_mask));
 
 	/*
 	 * Release all the links from cset_links to this hierarchy's
@@ -1053,13 +1048,7 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 		}
 	}
 
-	/*
-	 * Mark @root has finished binding subsystems.  @root->subsys_mask
-	 * now matches the bound subsystems.
-	 */
-	root->flags |= CGRP_ROOT_SUBSYS_BOUND;
 	kernfs_activate(cgrp->kn);
-
 	return 0;
 }
 
@@ -1351,15 +1340,6 @@ static struct cgroupfs_root *cgroup_root_from_opts(struct cgroup_sb_opts *opts)
 
 	init_cgroup_root(root);
 
-	/*
-	 * We need to set @root->subsys_mask now so that @root can be
-	 * matched by cgroup_test_super() before it finishes
-	 * initialization; otherwise, competing mounts with the same
-	 * options may try to bind the same subsystems instead of waiting
-	 * for the first one leading to unexpected mount errors.
-	 * SUBSYS_BOUND will be set once actual binding is complete.
-	 */
-	root->subsys_mask = opts->subsys_mask;
 	root->flags = opts->flags;
 	if (opts->release_agent)
 		strcpy(root->release_agent_path, opts->release_agent);
@@ -1370,7 +1350,7 @@ static struct cgroupfs_root *cgroup_root_from_opts(struct cgroup_sb_opts *opts)
 	return root;
 }
 
-static int cgroup_setup_root(struct cgroupfs_root *root)
+static int cgroup_setup_root(struct cgroupfs_root *root, unsigned long ss_mask)
 {
 	LIST_HEAD(tmp_links);
 	struct cgroup *root_cgrp = &root->top_cgroup;
@@ -1413,7 +1393,7 @@ static int cgroup_setup_root(struct cgroupfs_root *root)
 	if (ret)
 		goto destroy_root;
 
-	ret = rebind_subsystems(root, root->subsys_mask, 0);
+	ret = rebind_subsystems(root, ss_mask, 0);
 	if (ret)
 		goto destroy_root;
 
@@ -1530,7 +1510,7 @@ retry:
 		goto out_unlock;
 	}
 
-	ret = cgroup_setup_root(root);
+	ret = cgroup_setup_root(root, opts.subsys_mask);
 	if (ret)
 		cgroup_free_root(root);
 
-- 
1.8.5.3

