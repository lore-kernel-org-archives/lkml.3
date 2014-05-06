Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbaEFUWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:22:10 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:40587 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135AbaEFUTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:19:43 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/8] cgroup: grab cgroup_mutex earlier in cgroup_subtree_control_write()
Date: Tue,  6 May 2014 16:19:29 -0400
Message-Id: <1399407574-21472-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399407574-21472-1-git-send-email-tj@kernel.org>
References: <1399407574-21472-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move cgroup_lock_live_group() invocation upwards to right below
cgroup_tree_mutex in cgroup_subtree_control_write().  This is to help
the planned locking simplification.

This doesn't make any userland-visible behavioral changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 69c0ed9..f544e46 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2583,6 +2583,10 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	kernfs_break_active_protection(of->kn);
 
 	mutex_lock(&cgroup_tree_mutex);
+	if (!cgroup_lock_live_group(cgrp)) {
+		ret = -ENODEV;
+		goto out_unlock_tree;
+	}
 
 	for_each_subsys(ss, ssid) {
 		if (enable & (1 << ssid)) {
@@ -2606,6 +2610,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 				cgroup_get(child);
 				prepare_to_wait(&child->offline_waitq, &wait,
 						TASK_UNINTERRUPTIBLE);
+				mutex_unlock(&cgroup_mutex);
 				mutex_unlock(&cgroup_tree_mutex);
 				schedule();
 				finish_wait(&child->offline_waitq, &wait);
@@ -2620,7 +2625,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 			    (cgrp->parent &&
 			     !(cgrp->parent->child_subsys_mask & (1 << ssid)))) {
 				ret = -ENOENT;
-				goto out_unlock_tree;
+				goto out_unlock;
 			}
 		} else if (disable & (1 << ssid)) {
 			if (!(cgrp->child_subsys_mask & (1 << ssid))) {
@@ -2632,7 +2637,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 			cgroup_for_each_live_child(child, cgrp) {
 				if (child->child_subsys_mask & (1 << ssid)) {
 					ret = -EBUSY;
-					goto out_unlock_tree;
+					goto out_unlock;
 				}
 			}
 		}
@@ -2640,12 +2645,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 
 	if (!enable && !disable) {
 		ret = 0;
-		goto out_unlock_tree;
-	}
-
-	if (!cgroup_lock_live_group(cgrp)) {
-		ret = -ENODEV;
-		goto out_unlock_tree;
+		goto out_unlock;
 	}
 
 	/*
-- 
1.9.0

