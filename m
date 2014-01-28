Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbaA1Pcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:32:47 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:42059 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbaA1PcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:32:22 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 3/4] cgroup: fix locking in cgroup_cfts_commit()
Date: Tue, 28 Jan 2014 10:32:04 -0500
Message-Id: <1390923125-4369-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390923125-4369-1-git-send-email-tj@kernel.org>
References: <1390923125-4369-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_cfts_commit() walks the cgroup hierarchy that the target
subsystem is attached to and tries to apply the file changes.  Due to
the convolution with inode locking, it can't keep cgroup_mutex locked
while iterating.  It currently holds only RCU read lock around the
actual iteration and then pins the found cgroup using dget().

Unfortunately, this is incorrect.  Although the iteration does check
cgroup_is_dead() before invoking dget(), there's nothing which
prevents the dentry from going away inbetween.  Note that this is
different from the usual css iterations where css_tryget() is used to
pin the css - css_tryget() tests whether the css can be pinned and
fails if not.

The problem can be solved by simply holding cgroup_mutex instead of
RCU read lock around the iteration, which actually reduces LOC.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
---
 kernel/cgroup.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2e9f12a..b0e030f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2763,10 +2763,7 @@ static int cgroup_cfts_commit(struct cftype *cfts, bool is_add)
 	 */
 	update_before = cgroup_serial_nr_next;
 
-	mutex_unlock(&cgroup_mutex);
-
 	/* add/rm files for all cgroups created before */
-	rcu_read_lock();
 	css_for_each_descendant_pre(css, cgroup_css(root, ss)) {
 		struct cgroup *cgrp = css->cgroup;
 
@@ -2775,23 +2772,19 @@ static int cgroup_cfts_commit(struct cftype *cfts, bool is_add)
 
 		inode = cgrp->dentry->d_inode;
 		dget(cgrp->dentry);
-		rcu_read_unlock();
-
 		dput(prev);
 		prev = cgrp->dentry;
 
+		mutex_unlock(&cgroup_mutex);
 		mutex_lock(&inode->i_mutex);
 		mutex_lock(&cgroup_mutex);
 		if (cgrp->serial_nr < update_before && !cgroup_is_dead(cgrp))
 			ret = cgroup_addrm_files(cgrp, cfts, is_add);
-		mutex_unlock(&cgroup_mutex);
 		mutex_unlock(&inode->i_mutex);
-
-		rcu_read_lock();
 		if (ret)
 			break;
 	}
-	rcu_read_unlock();
+	mutex_unlock(&cgroup_mutex);
 	dput(prev);
 	deactivate_super(sb);
 	return ret;
-- 
1.8.5.3

