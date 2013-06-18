Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab3FRKsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:48:53 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:11595 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3FRKsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:48:51 -0400
Message-ID: <51C03B05.4080504@huawei.com>
Date: Tue, 18 Jun 2013 18:48:37 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 2/2] cgroup: convert cgroup_cft_commit() to use cgroup_for_each_descendant_pre()
References: <51C03AF2.7050702@huawei.com>
In-Reply-To: <51C03AF2.7050702@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used root->allcg_list to iterate cgroup hierarchy because at that time
cgroup_for_each_descendant_pre() hasn't been invented.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h |  6 -----
 kernel/cgroup.c        | 62 +++++++++++++++++++++++++++-----------------------
 2 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 835918c..f70b116 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -206,9 +206,6 @@ struct cgroup {
 	 */
 	struct list_head cset_links;
 
-	struct list_head allcg_node;	/* cgroupfs_root->allcg_list */
-	struct list_head cft_q_node;	/* used during cftype add/rm */
-
 	/*
 	 * Linked list running through all cgroups that can
 	 * potentially be reaped by the release agent. Protected by
@@ -317,9 +314,6 @@ struct cgroupfs_root {
 	/* A list running through the active hierarchies */
 	struct list_head root_list;
 
-	/* All cgroups on this root, cgroup_mutex protected */
-	struct list_head allcg_list;
-
 	/* Hierarchy-specific flags */
 	unsigned long flags;
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b1d98f2..bc46c28 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1399,7 +1399,6 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	INIT_LIST_HEAD(&cgrp->children);
 	INIT_LIST_HEAD(&cgrp->files);
 	INIT_LIST_HEAD(&cgrp->cset_links);
-	INIT_LIST_HEAD(&cgrp->allcg_node);
 	INIT_LIST_HEAD(&cgrp->release_list);
 	INIT_LIST_HEAD(&cgrp->pidlists);
 	mutex_init(&cgrp->pidlist_mutex);
@@ -1414,12 +1413,10 @@ static void init_cgroup_root(struct cgroupfs_root *root)
 
 	INIT_LIST_HEAD(&root->subsys_list);
 	INIT_LIST_HEAD(&root->root_list);
-	INIT_LIST_HEAD(&root->allcg_list);
 	root->number_of_cgroups = 1;
 	cgrp->root = root;
 	cgrp->name = &root_cgroup_name;
 	init_cgroup_housekeeping(cgrp);
-	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
 }
 
 static int cgroup_init_root_id(struct cgroupfs_root *root)
@@ -2775,65 +2772,74 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 	return ret;
 }
 
-static DEFINE_MUTEX(cgroup_cft_mutex);
-
 static void cgroup_cfts_prepare(void)
-	__acquires(&cgroup_cft_mutex) __acquires(&cgroup_mutex)
+	__acquires(&cgroup_mutex)
 {
 	/*
 	 * Thanks to the entanglement with vfs inode locking, we can't walk
 	 * the existing cgroups under cgroup_mutex and create files.
-	 * Instead, we increment reference on all cgroups and build list of
-	 * them using @cgrp->cft_q_node.  Grab cgroup_cft_mutex to ensure
-	 * exclusive access to the field.
+	 * Instead, we use cgroup_for_each_descendant_pre() and drop RCU
+	 * read lock before calling cgroup_addrm_files().
 	 */
-	mutex_lock(&cgroup_cft_mutex);
 	mutex_lock(&cgroup_mutex);
 }
 
 static void cgroup_cfts_commit(struct cgroup_subsys *ss,
 			       struct cftype *cfts, bool is_add)
-	__releases(&cgroup_mutex) __releases(&cgroup_cft_mutex)
+	__releases(&cgroup_mutex)
 {
 	LIST_HEAD(pending);
-	struct cgroup *cgrp, *n;
+	struct cgroup *cgrp, *root = &ss->root->top_cgroup;
 	struct super_block *sb = ss->root->sb;
+	struct inode *inode;
+	struct dentry *prev = NULL;
+	u64 serial_nr = atomic64_read(&cgroup_serial_nr_cursor);
 
 	/* %NULL @cfts indicates abort and don't bother if @ss isn't attached */
-	if (cfts && ss->root != &rootnode &&
-	    atomic_inc_not_zero(&sb->s_active)) {
-		list_for_each_entry(cgrp, &ss->root->allcg_list, allcg_node) {
-			dget(cgrp->dentry);
-			list_add_tail(&cgrp->cft_q_node, &pending);
-		}
-	} else {
-		sb = NULL;
+	if (!cfts || ss->root == &rootnode ||
+	    !atomic_inc_not_zero(&sb->s_active)) {
+		mutex_unlock(&cgroup_mutex);
+		return;
 	}
+	mutex_unlock(&cgroup_mutex);
 
+	inode = root->dentry->d_inode;
+	mutex_lock(&inode->i_mutex);
+	mutex_lock(&cgroup_mutex);
+	cgroup_addrm_files(root, ss, cfts, is_add);
 	mutex_unlock(&cgroup_mutex);
+	mutex_unlock(&inode->i_mutex);
 
 	/*
 	 * All new cgroups will see @cfts update on @ss->cftsets.  Add/rm
 	 * files for all cgroups which were created before.
 	 */
-	list_for_each_entry_safe(cgrp, n, &pending, cft_q_node) {
-		struct inode *inode = cgrp->dentry->d_inode;
+	rcu_read_lock();
+	cgroup_for_each_descendant_pre(cgrp, root) {
+		if (cgroup_is_dead(cgrp))
+			continue;
+
+		inode = cgrp->dentry->d_inode;
+		dget(cgrp->dentry);
+		rcu_read_unlock();
+
+		dput(prev);
+		prev = cgrp->dentry;
 
 		mutex_lock(&inode->i_mutex);
 		mutex_lock(&cgroup_mutex);
-		if (!cgroup_is_dead(cgrp))
+		if (cgrp->serial_nr <= serial_nr && !cgroup_is_dead(cgrp))
 			cgroup_addrm_files(cgrp, ss, cfts, is_add);
 		mutex_unlock(&cgroup_mutex);
 		mutex_unlock(&inode->i_mutex);
 
-		list_del_init(&cgrp->cft_q_node);
-		dput(cgrp->dentry);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
+	dput(prev);
 
 	if (sb)
 		deactivate_super(sb);
-
-	mutex_unlock(&cgroup_cft_mutex);
 }
 
 /**
@@ -4316,7 +4322,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	cgrp->serial_nr = atomic64_inc_return(&cgroup_serial_nr_cursor);
 
 	/* allocation complete, commit to creation */
-	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
 	list_add_tail_rcu(&cgrp->sibling, &cgrp->parent->children);
 	root->number_of_cgroups++;
 
@@ -4555,7 +4560,6 @@ static void cgroup_offline_fn(struct work_struct *work)
 
 	/* delete this cgroup from parent->children */
 	list_del_rcu(&cgrp->sibling);
-	list_del_init(&cgrp->allcg_node);
 
 	dput(d);
 
-- 
1.8.0.2
