Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaF1BD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 21:03:28 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:53581 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaF1BDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 21:03:19 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        mhocko@suse.cz, vgoyal@redhat.com, axboe@kernel.dk,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] cgroup: introduce cgroup->subtree_control
Date: Fri, 27 Jun 2014 21:03:08 -0400
Message-Id: <1403917392-32555-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403917392-32555-1-git-send-email-tj@kernel.org>
References: <1403917392-32555-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup is implementing support for subsystem dependency which would
require a way to enable a subsystem even when it's not directly
configured through "cgroup.subtree_control".

Previously, cgroup->child_subsys_mask directly reflected
"cgroup.subtree_control" and the enabled subsystems in the child
cgroups.  This patch adds cgroup->subtree_control which
"cgroup.subtree_control" operates on.  cgroup->child_subsys_mask is
now calculated from cgroup->subtree_control by
cgroup_refresh_child_subsys_mask(), which sets it identical to
cgroup->subtree_control for now.

This will allow using cgroup->child_subsys_mask for all the enabled
subsystems including the implicit ones and ->subtree_control for
tracking the explicitly requested ones.  This patch keeps the two
masks identical and doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  8 +++++++-
 kernel/cgroup.c        | 46 +++++++++++++++++++++++++++++-----------------
 2 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 8a111dd..8d52c8e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -203,7 +203,13 @@ struct cgroup {
 	struct kernfs_node *kn;		/* cgroup kernfs entry */
 	struct kernfs_node *populated_kn; /* kn for "cgroup.subtree_populated" */
 
-	/* the bitmask of subsystems enabled on the child cgroups */
+	/*
+	 * The bitmask of subsystems enabled on the child cgroups.
+	 * ->subtree_control is the one configured through
+	 * "cgroup.subtree_control" while ->child_subsys_mask is the
+	 * effective one which may have more subsystems enabled.
+	 */
+	unsigned int subtree_control;
 	unsigned int child_subsys_mask;
 
 	/* Private pointers for each registered subsystem */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a46d7e2..14a9d88 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1036,6 +1036,11 @@ static void cgroup_put(struct cgroup *cgrp)
 	css_put(&cgrp->self);
 }
 
+static void cgroup_refresh_child_subsys_mask(struct cgroup *cgrp)
+{
+	cgrp->child_subsys_mask = cgrp->subtree_control;
+}
+
 /**
  * cgroup_kn_unlock - unlocking helper for cgroup kernfs methods
  * @kn: the kernfs_node being serviced
@@ -1208,12 +1213,15 @@ static int rebind_subsystems(struct cgroup_root *dst_root, unsigned int ss_mask)
 		up_write(&css_set_rwsem);
 
 		src_root->subsys_mask &= ~(1 << ssid);
-		src_root->cgrp.child_subsys_mask &= ~(1 << ssid);
+		src_root->cgrp.subtree_control &= ~(1 << ssid);
+		cgroup_refresh_child_subsys_mask(&src_root->cgrp);
 
 		/* default hierarchy doesn't enable controllers by default */
 		dst_root->subsys_mask |= 1 << ssid;
-		if (dst_root != &cgrp_dfl_root)
-			dst_root->cgrp.child_subsys_mask |= 1 << ssid;
+		if (dst_root != &cgrp_dfl_root) {
+			dst_root->cgrp.subtree_control |= 1 << ssid;
+			cgroup_refresh_child_subsys_mask(&dst_root->cgrp);
+		}
 
 		if (ss->bind)
 			ss->bind(css);
@@ -2454,7 +2462,7 @@ static int cgroup_controllers_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
 
-	cgroup_print_ss_mask(seq, cgroup_parent(cgrp)->child_subsys_mask);
+	cgroup_print_ss_mask(seq, cgroup_parent(cgrp)->subtree_control);
 	return 0;
 }
 
@@ -2463,7 +2471,7 @@ static int cgroup_subtree_control_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
 
-	cgroup_print_ss_mask(seq, cgrp->child_subsys_mask);
+	cgroup_print_ss_mask(seq, cgrp->subtree_control);
 	return 0;
 }
 
@@ -2608,7 +2616,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 
 	for_each_subsys(ss, ssid) {
 		if (enable & (1 << ssid)) {
-			if (cgrp->child_subsys_mask & (1 << ssid)) {
+			if (cgrp->subtree_control & (1 << ssid)) {
 				enable &= ~(1 << ssid);
 				continue;
 			}
@@ -2616,7 +2624,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 			/* unavailable or not enabled on the parent? */
 			if (!(cgrp_dfl_root.subsys_mask & (1 << ssid)) ||
 			    (cgroup_parent(cgrp) &&
-			     !(cgroup_parent(cgrp)->child_subsys_mask & (1 << ssid)))) {
+			     !(cgroup_parent(cgrp)->subtree_control & (1 << ssid)))) {
 				ret = -ENOENT;
 				goto out_unlock;
 			}
@@ -2644,14 +2652,14 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 				return restart_syscall();
 			}
 		} else if (disable & (1 << ssid)) {
-			if (!(cgrp->child_subsys_mask & (1 << ssid))) {
+			if (!(cgrp->subtree_control & (1 << ssid))) {
 				disable &= ~(1 << ssid);
 				continue;
 			}
 
 			/* a child has it enabled? */
 			cgroup_for_each_live_child(child, cgrp) {
-				if (child->child_subsys_mask & (1 << ssid)) {
+				if (child->subtree_control & (1 << ssid)) {
 					ret = -EBUSY;
 					goto out_unlock;
 				}
@@ -2665,7 +2673,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	}
 
 	/*
-	 * Except for the root, child_subsys_mask must be zero for a cgroup
+	 * Except for the root, subtree_control must be zero for a cgroup
 	 * with tasks so that child cgroups don't compete against tasks.
 	 */
 	if (enable && cgroup_parent(cgrp) && !list_empty(&cgrp->cset_links)) {
@@ -2673,8 +2681,9 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 		goto out_unlock;
 	}
 
-	cgrp->child_subsys_mask |= enable;
-	cgrp->child_subsys_mask &= ~disable;
+	cgrp->subtree_control |= enable;
+	cgrp->subtree_control &= ~disable;
+	cgroup_refresh_child_subsys_mask(cgrp);
 
 	/* create new csses */
 	for_each_subsys(ss, ssid) {
@@ -2713,8 +2722,9 @@ out_unlock:
 	return ret ?: nbytes;
 
 err_undo_css:
-	cgrp->child_subsys_mask &= ~enable;
-	cgrp->child_subsys_mask |= disable;
+	cgrp->subtree_control &= ~enable;
+	cgrp->subtree_control |= disable;
+	cgroup_refresh_child_subsys_mask(cgrp);
 
 	for_each_subsys(ss, ssid) {
 		if (!(enable & (1 << ssid)))
@@ -4428,10 +4438,12 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 
 	/*
 	 * On the default hierarchy, a child doesn't automatically inherit
-	 * child_subsys_mask from the parent.  Each is configured manually.
+	 * subtree_control from the parent.  Each is configured manually.
 	 */
-	if (!cgroup_on_dfl(cgrp))
-		cgrp->child_subsys_mask = parent->child_subsys_mask;
+	if (!cgroup_on_dfl(cgrp)) {
+		cgrp->subtree_control = parent->subtree_control;
+		cgroup_refresh_child_subsys_mask(cgrp);
+	}
 
 	kernfs_activate(kn);
 
-- 
1.9.3

