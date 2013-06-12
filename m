Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab3FLVDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 17:03:55 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:52089 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab3FLVDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 17:03:51 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        koverstreet@google.com, linux-kernel@vger.kernel.org,
        cl@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/11] cgroup: split cgroup destruction into two steps
Date: Wed, 12 Jun 2013 14:03:15 -0700
Message-Id: <1371070996-20613-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371070996-20613-1-git-send-email-tj@kernel.org>
References: <1371070996-20613-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split cgroup_destroy_locked() into two steps and put the latter half
into cgroup_offline_fn() which is executed from a work item.  The
latter half is responsible for offlining the css's, removing the
cgroup from internal lists, and propagating release notification to
the parent.  The separation is to allow using percpu refcnt for css.

Note that this allows for other cgroup operations to happen between
the first and second halves of destruction, including creating a new
cgroup with the same name.  As the target cgroup is marked DEAD in the
first half and cgroup internals don't care about the names of cgroups,
this should be fine.  A comment explaining this will be added by the
next patch which implements the actual percpu refcnting.

As RCU freeing is guaranteed to happen after the second step of
destruction, we can use the same work item for both.  This patch
renames cgroup->free_work to ->destroy_work and uses it for both
purposes.  INIT_WORK() is now performed right before queueing the work
item.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  2 +-
 kernel/cgroup.c        | 38 +++++++++++++++++++++++++++-----------
 2 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5428738..58ee0f4 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -233,7 +233,7 @@ struct cgroup {
 
 	/* For RCU-protected deletion */
 	struct rcu_head rcu_head;
-	struct work_struct free_work;
+	struct work_struct destroy_work;
 
 	/* List of events which userspace want to receive */
 	struct list_head event_list;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a43bc9d..83e3183 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -208,6 +208,7 @@ static struct cgroup_name root_cgroup_name = { .name = "/" };
  */
 static int need_forkexit_callback __read_mostly;
 
+static void cgroup_offline_fn(struct work_struct *work);
 static int cgroup_destroy_locked(struct cgroup *cgrp);
 static int cgroup_addrm_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 			      struct cftype cfts[], bool is_add);
@@ -830,7 +831,7 @@ static struct cgroup_name *cgroup_alloc_name(struct dentry *dentry)
 
 static void cgroup_free_fn(struct work_struct *work)
 {
-	struct cgroup *cgrp = container_of(work, struct cgroup, free_work);
+	struct cgroup *cgrp = container_of(work, struct cgroup, destroy_work);
 	struct cgroup_subsys *ss;
 
 	mutex_lock(&cgroup_mutex);
@@ -875,7 +876,8 @@ static void cgroup_free_rcu(struct rcu_head *head)
 {
 	struct cgroup *cgrp = container_of(head, struct cgroup, rcu_head);
 
-	schedule_work(&cgrp->free_work);
+	INIT_WORK(&cgrp->destroy_work, cgroup_free_fn);
+	schedule_work(&cgrp->destroy_work);
 }
 
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
@@ -1407,7 +1409,6 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	INIT_LIST_HEAD(&cgrp->allcg_node);
 	INIT_LIST_HEAD(&cgrp->release_list);
 	INIT_LIST_HEAD(&cgrp->pidlists);
-	INIT_WORK(&cgrp->free_work, cgroup_free_fn);
 	mutex_init(&cgrp->pidlist_mutex);
 	INIT_LIST_HEAD(&cgrp->event_list);
 	spin_lock_init(&cgrp->event_list_lock);
@@ -2994,12 +2995,13 @@ struct cgroup *cgroup_next_sibling(struct cgroup *pos)
 	/*
 	 * @pos could already have been removed.  Once a cgroup is removed,
 	 * its ->sibling.next is no longer updated when its next sibling
-	 * changes.  As CGRP_DEAD is set on removal which is fully
-	 * serialized, if we see it unasserted, it's guaranteed that the
-	 * next sibling hasn't finished its grace period even if it's
-	 * already removed, and thus safe to dereference from this RCU
-	 * critical section.  If ->sibling.next is inaccessible,
-	 * cgroup_is_dead() is guaranteed to be visible as %true here.
+	 * changes.  As CGRP_DEAD assertion is serialized and happens
+	 * before the cgroup is taken off the ->sibling list, if we see it
+	 * unasserted, it's guaranteed that the next sibling hasn't
+	 * finished its grace period even if it's already removed, and thus
+	 * safe to dereference from this RCU critical section.  If
+	 * ->sibling.next is inaccessible, cgroup_is_dead() is guaranteed
+	 * to be visible as %true here.
 	 */
 	if (likely(!cgroup_is_dead(pos))) {
 		next = list_entry_rcu(pos->sibling.next, struct cgroup, sibling);
@@ -4362,7 +4364,6 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	__releases(&cgroup_mutex) __acquires(&cgroup_mutex)
 {
 	struct dentry *d = cgrp->dentry;
-	struct cgroup *parent = cgrp->parent;
 	struct cgroup_event *event, *tmp;
 	struct cgroup_subsys *ss;
 	bool empty;
@@ -4426,6 +4427,21 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	}
 	spin_unlock(&cgrp->event_list_lock);
 
+	INIT_WORK(&cgrp->destroy_work, cgroup_offline_fn);
+	schedule_work(&cgrp->destroy_work);
+
+	return 0;
+};
+
+static void cgroup_offline_fn(struct work_struct *work)
+{
+	struct cgroup *cgrp = container_of(work, struct cgroup, destroy_work);
+	struct cgroup *parent = cgrp->parent;
+	struct dentry *d = cgrp->dentry;
+	struct cgroup_subsys *ss;
+
+	mutex_lock(&cgroup_mutex);
+
 	/* tell subsystems to initate destruction */
 	for_each_subsys(cgrp->root, ss)
 		offline_css(ss, cgrp);
@@ -4449,7 +4465,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	set_bit(CGRP_RELEASABLE, &parent->flags);
 	check_for_release(parent);
 
-	return 0;
+	mutex_unlock(&cgroup_mutex);
 }
 
 static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
-- 
1.8.2.1

