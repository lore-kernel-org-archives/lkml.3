Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab3GQXDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:03:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56817 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab3GQW4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 025/145] cgroup: fix umount vs cgroup_event_remove() race
Date: Wed, 17 Jul 2013 15:45:57 -0700
Message-Id: <1374101277-7915-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 1c8158eeae0f37d0eee9f1fbe68080df6a408df2 upstream.

 commit 5db9a4d99b0157a513944e9a44d29c9cec2e91dc
 Author: Tejun Heo <tj@kernel.org>
 Date:   Sat Jul 7 16:08:18 2012 -0700

     cgroup: fix cgroup hierarchy umount race

This commit fixed a race caused by the dput() in css_dput_fn(), but
the dput() in cgroup_event_remove() can also lead to the same BUG().

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ luis: backported to 3.8: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/cgroup.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b6a1f62..754b917 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3755,6 +3755,23 @@ static int cgroup_write_notify_on_release(struct cgroup *cgrp,
 }
 
 /*
+ * When dput() is called asynchronously, if umount has been done and
+ * then deactivate_super() in cgroup_free_fn() kills the superblock,
+ * there's a small window that vfs will see the root dentry with non-zero
+ * refcnt and trigger BUG().
+ *
+ * That's why we hold a reference before dput() and drop it right after.
+ */
+static void cgroup_dput(struct cgroup *cgrp)
+{
+	struct super_block *sb = cgrp->root->sb;
+
+	atomic_inc(&sb->s_active);
+	dput(cgrp->dentry);
+	deactivate_super(sb);
+}
+
+/*
  * Unregister event and free resources.
  *
  * Gets called from workqueue.
@@ -3769,7 +3786,7 @@ static void cgroup_event_remove(struct work_struct *work)
 
 	eventfd_ctx_put(event->eventfd);
 	kfree(event);
-	dput(cgrp->dentry);
+	cgroup_dput(cgrp);
 }
 
 /*
@@ -4031,12 +4048,8 @@ static void css_dput_fn(struct work_struct *work)
 {
 	struct cgroup_subsys_state *css =
 		container_of(work, struct cgroup_subsys_state, dput_work);
-	struct dentry *dentry = css->cgroup->dentry;
-	struct super_block *sb = dentry->d_sb;
 
-	atomic_inc(&sb->s_active);
-	dput(dentry);
-	deactivate_super(sb);
+	cgroup_dput(css->cgroup);
 }
 
 static void init_cgroup_css(struct cgroup_subsys_state *css,
-- 
1.8.1.2

