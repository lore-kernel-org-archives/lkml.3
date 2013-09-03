Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760937Ab3ICUwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 16:52:05 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:45021 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760799Ab3ICUwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 16:52:00 -0400
Date: Tue, 3 Sep 2013 16:51:54 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/9] cgroup: fix css leaks on online_css() failure
Message-ID: <20130903205154.GF27092@mtj.dyndns.org>
References: <1377723829-22814-1-git-send-email-tj@kernel.org>
 <1377723829-22814-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377723829-22814-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, re-sequencing the for_each_css patch turns out to be a lot more
headache than expected.  Let's just fix it up in this patch proper.
It's a standalone bug fix anyway.  The change only affects the
for_each_css() patch later.  Will post an updated version of that
patch too soon.

Thanks.
----- 8< -----
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

v2: Li pointed out that cgroup_destroy_locked() would do NULL-deref if
    invoked with a cgroup which doesn't have all css's populated.
    Update cgroup_destroy_locked() so that it skips NULL css's.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4489,14 +4489,6 @@ static long cgroup_create(struct cgroup
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
 
@@ -4508,6 +4500,13 @@ static long cgroup_create(struct cgroup
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
@@ -4698,8 +4705,12 @@ static int cgroup_destroy_locked(struct
 	 * will be invoked to perform the rest of destruction once the
 	 * percpu refs of all css's are confirmed to be killed.
 	 */
-	for_each_root_subsys(cgrp->root, ss)
-		kill_css(cgroup_css(cgrp, ss));
+	for_each_root_subsys(cgrp->root, ss) {
+		struct cgroup_subsys_state *css = cgroup_css(cgrp, ss);
+
+		if (css)
+			kill_css(css);
+	}
 
 	/*
 	 * Mark @cgrp dead.  This prevents further task migration and child
