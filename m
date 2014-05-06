Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbaEFUTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:19:51 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:52766 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbaEFUTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:19:48 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/8] cgroup: use cgroup_kn_lock_live() in other cgroup kernfs methods
Date: Tue,  6 May 2014 16:19:32 -0400
Message-Id: <1399407574-21472-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399407574-21472-1-git-send-email-tj@kernel.org>
References: <1399407574-21472-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make __cgroup_procs_write() and cgroup_release_agent_write() use
cgroup_kn_lock_live() and cgroup_kn_unlock() instead of
cgroup_lock_live_group().  This puts the operations under both
cgroup_tree_mutex and cgroup_mutex protection without circular
dependency from kernfs active protection.  Also, this means that
cgroup_mutex is no longer nested below kernfs active protection.
There is no longer any place where the two locks interact.

This leaves cgroup_lock_live_group() without any user.  Removed.

This will help simplifying cgroup locking.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 39 ++++++++++++---------------------------
 1 file changed, 12 insertions(+), 27 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1d0d5f7..281fce5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -386,23 +386,6 @@ static int notify_on_release(const struct cgroup *cgrp)
 			;						\
 		else
 
-/**
- * cgroup_lock_live_group - take cgroup_mutex and check that cgrp is alive.
- * @cgrp: the cgroup to be checked for liveness
- *
- * On success, returns true; the mutex should be later unlocked.  On
- * failure returns false with no lock held.
- */
-static bool cgroup_lock_live_group(struct cgroup *cgrp)
-{
-	mutex_lock(&cgroup_mutex);
-	if (cgroup_is_dead(cgrp)) {
-		mutex_unlock(&cgroup_mutex);
-		return false;
-	}
-	return true;
-}
-
 /* the list of cgroups eligible for automatic release. Protected by
  * release_list_lock */
 static LIST_HEAD(release_list);
@@ -2306,14 +2289,15 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 {
 	struct task_struct *tsk;
 	const struct cred *cred = current_cred(), *tcred;
-	struct cgroup *cgrp = of_css(of)->cgroup;
+	struct cgroup *cgrp;
 	pid_t pid;
 	int ret;
 
 	if (kstrtoint(strstrip(buf), 0, &pid) || pid < 0)
 		return -EINVAL;
 
-	if (!cgroup_lock_live_group(cgrp))
+	cgrp = cgroup_kn_lock_live(of->kn);
+	if (!cgrp)
 		return -ENODEV;
 
 retry_find_task:
@@ -2379,7 +2363,7 @@ retry_find_task:
 
 	put_task_struct(tsk);
 out_unlock_cgroup:
-	mutex_unlock(&cgroup_mutex);
+	cgroup_kn_unlock(of->kn);
 	return ret ?: nbytes;
 }
 
@@ -2429,17 +2413,18 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
 					  char *buf, size_t nbytes, loff_t off)
 {
-	struct cgroup *cgrp = of_css(of)->cgroup;
-	struct cgroup_root *root = cgrp->root;
+	struct cgroup *cgrp;
 
-	BUILD_BUG_ON(sizeof(root->release_agent_path) < PATH_MAX);
-	if (!cgroup_lock_live_group(cgrp))
+	BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
+
+	cgrp = cgroup_kn_lock_live(of->kn);
+	if (!cgrp)
 		return -ENODEV;
 	spin_lock(&release_agent_path_lock);
-	strlcpy(root->release_agent_path, strstrip(buf),
-		sizeof(root->release_agent_path));
+	strlcpy(cgrp->root->release_agent_path, strstrip(buf),
+		sizeof(cgrp->root->release_agent_path));
 	spin_unlock(&release_agent_path_lock);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_kn_unlock(of->kn);
 	return nbytes;
 }
 
-- 
1.9.0

