Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbaCYRRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:17:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55593 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbaCYRRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:17:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 05/81] cgroup: fix locking in cgroup_cfts_commit()
Date: Tue, 25 Mar 2014 10:15:18 -0700
Message-Id: <1395767794-5012-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 48573a893303986e3b0b2974d6fb11f3d1bb7064 upstream.

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
Acked-by: Li Zefan <lizefan@huawei.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/cgroup.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 754b917..ba9e28c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2826,8 +2826,6 @@ static void cgroup_cfts_commit(struct cgroup_subsys *ss,
 		sb = NULL;
 	}
 
-	mutex_unlock(&cgroup_mutex);
-
 	/*
 	 * All new cgroups will see @cfts update on @ss->cftsets.  Add/rm
 	 * files for all cgroups which were created before.
@@ -2835,16 +2833,17 @@ static void cgroup_cfts_commit(struct cgroup_subsys *ss,
 	list_for_each_entry_safe(cgrp, n, &pending, cft_q_node) {
 		struct inode *inode = cgrp->dentry->d_inode;
 
+		mutex_unlock(&cgroup_mutex);
 		mutex_lock(&inode->i_mutex);
 		mutex_lock(&cgroup_mutex);
 		if (!cgroup_is_removed(cgrp))
 			cgroup_addrm_files(cgrp, ss, cfts, is_add);
-		mutex_unlock(&cgroup_mutex);
 		mutex_unlock(&inode->i_mutex);
 
 		list_del_init(&cgrp->cft_q_node);
 		dput(cgrp->dentry);
 	}
+	mutex_unlock(&cgroup_mutex);
 
 	if (sb)
 		deactivate_super(sb);
-- 
1.8.3.2

