Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbaA1XzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:55:01 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:42238 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbaA1Xy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:54:57 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/13] cgroup: release cgroup_mutex over file removals
Date: Tue, 28 Jan 2014 18:54:35 -0500
Message-Id: <1390953285-16360-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390953285-16360-1-git-send-email-tj@kernel.org>
References: <1390953285-16360-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that cftypes and all tree modification operations are protected by
cgroup_tree_mutex, we can drop cgroup_mutex while deleting files and
directories.  Drop cgroup_mutex over removals.

This doesn't make any noticeable difference now but is to help kernfs
conversion.  In kernfs, removals are sync points which drain in-flight
operations as those operations would grab cgroup_mutex, trying to
delete under cgroup_mutex would deadlock.  This can be resolved by
just holding the outer cgroup_tree_mutex which nests outside both
kernfs active reference and cgroup_mutex.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8018777..bff7d64 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -974,7 +974,9 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 	 * Nothing can fail from this point on.  Remove files for the
 	 * removed subsystems and rebind each subsystem.
 	 */
+	mutex_unlock(&cgroup_mutex);
 	cgroup_clear_dir(cgrp, removed_mask);
+	mutex_lock(&cgroup_mutex);
 
 	for_each_subsys(ss, i) {
 		unsigned long bit = 1UL << i;
@@ -2687,10 +2689,11 @@ static int cgroup_cfts_commit(struct cftype *cfts, bool is_add)
 	u64 update_before;
 	int ret = 0;
 
+	mutex_unlock(&cgroup_mutex);
+
 	/* %NULL @cfts indicates abort and don't bother if @ss isn't attached */
 	if (!cfts || ss->root == &cgroup_dummy_root ||
 	    !atomic_inc_not_zero(&sb->s_active)) {
-		mutex_unlock(&cgroup_mutex);
 		mutex_unlock(&cgroup_tree_mutex);
 		return 0;
 	}
@@ -2714,18 +2717,15 @@ static int cgroup_cfts_commit(struct cftype *cfts, bool is_add)
 		dput(prev);
 		prev = cgrp->dentry;
 
-		mutex_unlock(&cgroup_mutex);
 		mutex_unlock(&cgroup_tree_mutex);
 		mutex_lock(&inode->i_mutex);
 		mutex_lock(&cgroup_tree_mutex);
-		mutex_lock(&cgroup_mutex);
 		if (cgrp->serial_nr < update_before && !cgroup_is_dead(cgrp))
 			ret = cgroup_addrm_files(cgrp, cfts, is_add);
 		mutex_unlock(&inode->i_mutex);
 		if (ret)
 			break;
 	}
-	mutex_unlock(&cgroup_mutex);
 	mutex_unlock(&cgroup_tree_mutex);
 	dput(prev);
 	deactivate_super(sb);
@@ -4378,10 +4378,13 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	/*
 	 * Initiate massacre of all css's.  cgroup_destroy_css_killed()
 	 * will be invoked to perform the rest of destruction once the
-	 * percpu refs of all css's are confirmed to be killed.
+	 * percpu refs of all css's are confirmed to be killed.  This
+	 * involves removing the subsystem's files, drop cgroup_mutex.
 	 */
+	mutex_unlock(&cgroup_mutex);
 	for_each_css(css, ssid, cgrp)
 		kill_css(css);
+	mutex_lock(&cgroup_mutex);
 
 	/*
 	 * Mark @cgrp dead.  This prevents further task migration and child
@@ -4412,9 +4415,11 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 * puts the base ref but we aren't quite done with @cgrp yet, so
 	 * hold onto it.
 	 */
+	mutex_unlock(&cgroup_mutex);
 	cgroup_addrm_files(cgrp, cgroup_base_files, false);
 	dget(d);
 	cgroup_d_remove_dir(d);
+	mutex_lock(&cgroup_mutex);
 
 	return 0;
 };
-- 
1.8.5.3

