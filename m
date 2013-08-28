Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3H1VEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:04:00 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:59974 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab3H1VD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:03:56 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/9] cgroup: fix css leaks on online_css() failure
Date: Wed, 28 Aug 2013 17:03:41 -0400
Message-Id: <1377723829-22814-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1377723829-22814-1-git-send-email-tj@kernel.org>
References: <1377723829-22814-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ae7f164a09 ("cgroup: move cgroup->subsys[] assignment to
online_css()") moved cgroup->subsys[] assignements later in
cgroup_create() but didn't update error handling path accordingly
leaking later css's after an online_css() failure.

This patch moves reference bumping inside online_css() loop, clears
css_ar[] as css's are brought online successfully, and updates
err_destroy path so that either a css is fully online and destroyed by
cgroup_destroy_locked() or the error path frees it.  This creates a
duplicate css free logic in the error path but it will be cleaned up
soon.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b5f4989..a4168cf 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4489,14 +4489,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	list_add_tail_rcu(&cgrp->sibling, &cgrp->parent->children);
 	root->number_of_cgroups++;
 
-	/* each css holds a ref to the cgroup's dentry and the parent css */
-	for_each_root_subsys(root, ss) {
-		struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
-
-		dget(dentry);
-		css_get(css->parent);
-	}
-
 	/* hold a ref to the parent's dentry */
 	dget(parent->dentry);
 
@@ -4508,6 +4500,13 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 		if (err)
 			goto err_destroy;
 
+		/* each css holds a ref to the cgroup's dentry and parent css */
+		dget(dentry);
+		css_get(css->parent);
+
+		/* mark it consumed for error path */
+		css_ar[ss->subsys_id] = NULL;
+
 		if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
 		    parent->parent) {
 			pr_warning("cgroup: %s (%d) created nested cgroup for controller \"%s\" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.\n",
@@ -4554,6 +4553,14 @@ err_free_cgrp:
 	return err;
 
 err_destroy:
+	for_each_root_subsys(root, ss) {
+		struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
+
+		if (css) {
+			percpu_ref_cancel_init(&css->refcnt);
+			ss->css_free(css);
+		}
+	}
 	cgroup_destroy_locked(cgrp);
 	mutex_unlock(&cgroup_mutex);
 	mutex_unlock(&dentry->d_inode->i_mutex);
-- 
1.8.3.1

