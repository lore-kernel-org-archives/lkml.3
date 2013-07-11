Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab3GKOZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:25:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42850 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab3GKOZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 09/98] cgroup: fix umount vs cgroup_event_remove() race
Date: Thu, 11 Jul 2013 15:23:39 +0100
Message-Id: <1373552708-15235-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/cgroup.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5168e37..07ba52a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3623,6 +3623,23 @@ static int cgroup_write_notify_on_release(struct cgroup *cgrp,
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
@@ -3637,7 +3654,7 @@ static void cgroup_event_remove(struct work_struct *work)
 
 	eventfd_ctx_put(event->eventfd);
 	kfree(event);
-	dput(cgrp->dentry);
+	cgroup_dput(cgrp);
 }
 
 /*
@@ -3888,12 +3905,8 @@ static void css_dput_fn(struct work_struct *work)
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

