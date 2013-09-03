Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761021Ab3ICUye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 16:54:34 -0400
Received: from mail-ye0-f177.google.com ([209.85.213.177]:49971 "EHLO
	mail-ye0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760735Ab3ICUyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 16:54:32 -0400
Date: Tue, 3 Sep 2013 16:54:26 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/9] cgroup: implement for_each_css()
Message-ID: <20130903205426.GG27092@mtj.dyndns.org>
References: <1377723829-22814-1-git-send-email-tj@kernel.org>
 <1377723829-22814-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377723829-22814-9-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are enough places where css's of a cgroup are iterated, which
currently uses for_each_root_subsys() + explicit cgroup_css().  This
patch implements for_each_css() and replaces the above combination
with it.

This patch doesn't introduce any behavior changes.

v2: Updated to apply cleanly on top of v2 of "cgroup: fix css leaks on
    online_css() failure"

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c |   57 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 26 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -297,6 +297,21 @@ static int notify_on_release(const struc
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
@@ -2013,8 +2028,8 @@ static int cgroup_attach_task(struct cgr
 			      bool threadgroup)
 {
 	int retval, i, group_size;
-	struct cgroup_subsys *ss, *failed_ss = NULL;
 	struct cgroupfs_root *root = cgrp->root;
+	struct cgroup_subsys_state *css, *failed_css = NULL;
 	/* threadgroup list cursor and array */
 	struct task_struct *leader = tsk;
 	struct task_and_cgroup *tc;
@@ -2087,13 +2102,11 @@ static int cgroup_attach_task(struct cgr
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
@@ -2129,12 +2142,9 @@ static int cgroup_attach_task(struct cgr
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
@@ -2151,13 +2161,11 @@ out_put_css_set_refs:
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
@@ -4700,8 +4708,9 @@ static int cgroup_destroy_locked(struct
 {
 	struct dentry *d = cgrp->dentry;
 	struct cgroup_event *event, *tmp;
-	struct cgroup_subsys *ss;
+	struct cgroup_subsys_state *css;
 	bool empty;
+	int ssid;
 
 	lockdep_assert_held(&d->d_inode->i_mutex);
 	lockdep_assert_held(&cgroup_mutex);
@@ -4721,12 +4730,8 @@ static int cgroup_destroy_locked(struct
 	 * will be invoked to perform the rest of destruction once the
 	 * percpu refs of all css's are confirmed to be killed.
 	 */
-	for_each_root_subsys(cgrp->root, ss) {
-		struct cgroup_subsys_state *css = cgroup_css(cgrp, ss);
-
-		if (css)
-			kill_css(css);
-	}
+	for_each_css(css, ssid, cgrp)
+		kill_css(css);
 
 	/*
 	 * Mark @cgrp dead.  This prevents further task migration and child
