Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab3H1VJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:09:12 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:57778 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3H1VJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:09:10 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/9] cgroup: implement for_each_css()
Date: Wed, 28 Aug 2013 17:03:48 -0400
Message-Id: <1377723829-22814-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1377723829-22814-1-git-send-email-tj@kernel.org>
References: <1377723829-22814-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are enough places where css's of a cgroup are iterated, which
currently uses for_each_root_subsys() + explicit cgroup_css().  This
patch implements for_each_css() and replaces the above combination
with it.

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 53 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index cd53b49..88684ce 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -289,6 +289,21 @@ static int notify_on_release(const struct cgroup *cgrp)
 }
 
 /**
+ * for_each_css - iterate all css's of a cgroup
+ * @css: the iteration cursor
+ * @ssid: the index of the subsystem, CGROUP_SUBSYS_COUNT after reaching the end
+ * @cgrp: the target cgroup to iterate css's of
+ *
+ * Should be called under cgroup_mutex.
+ */
+#define for_each_css(css, ssid, cgrp)					\
+	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT; (ssid)++)	\
+		if (!((css) = rcu_dereference_check(			\
+				(cgrp)->subsys[(ssid)],			\
+				lockdep_is_held(&cgroup_mutex)))) { }	\
+		else
+
+/**
  * for_each_subsys - iterate all loaded cgroup subsystems
  * @ss: the iteration cursor
  * @ssid: the index of @ss, CGROUP_SUBSYS_COUNT after reaching the end
@@ -2007,8 +2022,8 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 			      bool threadgroup)
 {
 	int retval, i, group_size;
-	struct cgroup_subsys *ss, *failed_ss = NULL;
 	struct cgroupfs_root *root = cgrp->root;
+	struct cgroup_subsys_state *css, *failed_css = NULL;
 	/* threadgroup list cursor and array */
 	struct task_struct *leader = tsk;
 	struct task_and_cgroup *tc;
@@ -2081,13 +2096,11 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 	/*
 	 * step 1: check that we can legitimately attach to the cgroup.
 	 */
-	for_each_root_subsys(root, ss) {
-		struct cgroup_subsys_state *css = cgroup_css(cgrp, ss);
-
-		if (ss->can_attach) {
-			retval = ss->can_attach(css, &tset);
+	for_each_css(css, i, cgrp) {
+		if (css->ss->can_attach) {
+			retval = css->ss->can_attach(css, &tset);
 			if (retval) {
-				failed_ss = ss;
+				failed_css = css;
 				goto out_cancel_attach;
 			}
 		}
@@ -2123,12 +2136,9 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 	/*
 	 * step 4: do subsystem attach callbacks.
 	 */
-	for_each_root_subsys(root, ss) {
-		struct cgroup_subsys_state *css = cgroup_css(cgrp, ss);
-
-		if (ss->attach)
-			ss->attach(css, &tset);
-	}
+	for_each_css(css, i, cgrp)
+		if (css->ss->attach)
+			css->ss->attach(css, &tset);
 
 	/*
 	 * step 5: success! and cleanup
@@ -2145,13 +2155,11 @@ out_put_css_set_refs:
 	}
 out_cancel_attach:
 	if (retval) {
-		for_each_root_subsys(root, ss) {
-			struct cgroup_subsys_state *css = cgroup_css(cgrp, ss);
-
-			if (ss == failed_ss)
+		for_each_css(css, i, cgrp) {
+			if (css == failed_css)
 				break;
-			if (ss->cancel_attach)
-				ss->cancel_attach(css, &tset);
+			if (css->ss->cancel_attach)
+				css->ss->cancel_attach(css, &tset);
 		}
 	}
 out_free_group_list:
@@ -4694,8 +4702,9 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 {
 	struct dentry *d = cgrp->dentry;
 	struct cgroup_event *event, *tmp;
-	struct cgroup_subsys *ss;
+	struct cgroup_subsys_state *css;
 	bool empty;
+	int ssid;
 
 	lockdep_assert_held(&d->d_inode->i_mutex);
 	lockdep_assert_held(&cgroup_mutex);
@@ -4715,8 +4724,8 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 * will be invoked to perform the rest of destruction once the
 	 * percpu refs of all css's are confirmed to be killed.
 	 */
-	for_each_root_subsys(cgrp->root, ss)
-		kill_css(cgroup_css(cgrp, ss));
+	for_each_css(css, ssid, cgrp)
+		kill_css(css);
 
 	/*
 	 * Mark @cgrp dead.  This prevents further task migration and child
-- 
1.8.3.1

