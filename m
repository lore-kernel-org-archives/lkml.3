Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab3AXGdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 01:33:17 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:31866 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3AXGdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 01:33:08 -0500
Message-ID: <5100D54E.7010602@huawei.com>
Date: Thu, 24 Jan 2013 14:31:42 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v2 5/6] cgroup: remove synchronize_rcu() from cgroup_diput()
References: <5100D4FE.9080205@huawei.com>
In-Reply-To: <5100D4FE.9080205@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free cgroup via call_rcu(). The actual work is done through
workqueue.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---

v2: move INIT_WORK() from cgroup_create() to init_cgroup_housekeeping()

---
 include/linux/cgroup.h |  1 +
 kernel/cgroup.c        | 72 ++++++++++++++++++++++++++++++--------------------
 2 files changed, 44 insertions(+), 29 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 8118a31..900af59 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -203,6 +203,7 @@ struct cgroup {
 
 	/* For RCU-protected deletion */
 	struct rcu_head rcu_head;
+	struct work_struct free_work;
 
 	/* List of events which userspace want to receive */
 	struct list_head event_list;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a39e2b0..f18b0d9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -852,12 +852,52 @@ static struct inode *cgroup_new_inode(umode_t mode, struct super_block *sb)
 	return inode;
 }
 
+static void cgroup_free_fn(struct work_struct *work)
+{
+	struct cgroup *cgrp = container_of(work, struct cgroup, free_work);
+	struct cgroup_subsys *ss;
+
+	mutex_lock(&cgroup_mutex);
+	/*
+	 * Release the subsystem state objects.
+	 */
+	for_each_subsys(cgrp->root, ss)
+		ss->css_free(cgrp);
+
+	cgrp->root->number_of_cgroups--;
+	mutex_unlock(&cgroup_mutex);
+
+	/*
+	 * Drop the active superblock reference that we took when we
+	 * created the cgroup
+	 */
+	deactivate_super(cgrp->root->sb);
+
+	/*
+	 * if we're getting rid of the cgroup, refcount should ensure
+	 * that there are no pidlists left.
+	 */
+	BUG_ON(!list_empty(&cgrp->pidlists));
+
+	simple_xattrs_free(&cgrp->xattrs);
+
+	ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
+	kfree(cgrp);
+}
+
+static void cgroup_free_rcu(struct rcu_head *head)
+{
+	struct cgroup *cgrp = container_of(head, struct cgroup, rcu_head);
+
+	schedule_work(&cgrp->free_work);
+}
+
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 {
 	/* is dentry a directory ? if so, kfree() associated cgroup */
 	if (S_ISDIR(inode->i_mode)) {
 		struct cgroup *cgrp = dentry->d_fsdata;
-		struct cgroup_subsys *ss;
+
 		BUG_ON(!(cgroup_is_removed(cgrp)));
 		/* It's possible for external users to be holding css
 		 * reference counts on a cgroup; css_put() needs to
@@ -865,34 +905,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		 * the reference count in order to know if it needs to
 		 * queue the cgroup to be handled by the release
 		 * agent */
-		synchronize_rcu();
-
-		mutex_lock(&cgroup_mutex);
-		/*
-		 * Release the subsystem state objects.
-		 */
-		for_each_subsys(cgrp->root, ss)
-			ss->css_free(cgrp);
-
-		cgrp->root->number_of_cgroups--;
-		mutex_unlock(&cgroup_mutex);
-
-		/*
-		 * Drop the active superblock reference that we took when we
-		 * created the cgroup
-		 */
-		deactivate_super(cgrp->root->sb);
-
-		/*
-		 * if we're getting rid of the cgroup, refcount should ensure
-		 * that there are no pidlists left.
-		 */
-		BUG_ON(!list_empty(&cgrp->pidlists));
-
-		simple_xattrs_free(&cgrp->xattrs);
-
-		ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
-		kfree(cgrp);
+		call_rcu(&cgrp->rcu_head, cgroup_free_rcu);
 	} else {
 		struct cfent *cfe = __d_cfe(dentry);
 		struct cgroup *cgrp = dentry->d_parent->d_fsdata;
@@ -1391,6 +1404,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	INIT_LIST_HEAD(&cgrp->allcg_node);
 	INIT_LIST_HEAD(&cgrp->release_list);
 	INIT_LIST_HEAD(&cgrp->pidlists);
+	INIT_WORK(&cgrp->free_work, cgroup_free_fn);
 	mutex_init(&cgrp->pidlist_mutex);
 	INIT_LIST_HEAD(&cgrp->event_list);
 	spin_lock_init(&cgrp->event_list_lock);
-- 
1.8.0.2

