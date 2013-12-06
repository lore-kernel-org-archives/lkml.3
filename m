Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3LFU3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:29:42 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:56193 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab3LFU16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:27:58 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, vdavydov@parallels.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/7] cgroup: css iterations and css_from_dir() are safe under cgroup_mutex
Date: Fri,  6 Dec 2013 15:27:46 -0500
Message-Id: <1386361672-27791-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386361672-27791-1-git-send-email-tj@kernel.org>
References: <1386361672-27791-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, all css iterations and css_from_dir() require RCU read lock
whether the caller is holding cgroup_mutex or not, which is
unnecessarily restrictive.  They are all safe to use under
cgroup_mutex without holding RCU read lock.

Factor out cgroup_assert_mutex_or_rcu_locked() from css_from_id() and
apply it to all css iteration functions and css_from_dir().

v2: cgroup_assert_mutex_or_rcu_locked() definition doesn't need to be
    inside CONFIG_PROVE_RCU ifdef as rcu_lockdep_assert() is always
    defined and conditionalized.  Move it outside of the ifdef block.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 56 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2e5fbf9..c22eecb 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -93,6 +93,11 @@ static DEFINE_MUTEX(cgroup_mutex);
 
 static DEFINE_MUTEX(cgroup_root_mutex);
 
+#define cgroup_assert_mutex_or_rcu_locked()				\
+	rcu_lockdep_assert(rcu_read_lock_held() ||			\
+			   lockdep_is_held(&cgroup_mutex),		\
+			   "cgroup_mutex or RCU read lock required");
+
 /*
  * cgroup destruction makes heavy use of work items and there can be a lot
  * of concurrent destructions.  Use a separate workqueue so that cgroup
@@ -2897,9 +2902,9 @@ static void cgroup_enable_task_cg_lists(void)
  * @parent_css: css whose children to walk
  *
  * This function returns the next child of @parent_css and should be called
- * under RCU read lock.  The only requirement is that @parent_css and
- * @pos_css are accessible.  The next sibling is guaranteed to be returned
- * regardless of their states.
+ * under either cgroup_mutex or RCU read lock.  The only requirement is
+ * that @parent_css and @pos_css are accessible.  The next sibling is
+ * guaranteed to be returned regardless of their states.
  */
 struct cgroup_subsys_state *
 css_next_child(struct cgroup_subsys_state *pos_css,
@@ -2909,7 +2914,7 @@ css_next_child(struct cgroup_subsys_state *pos_css,
 	struct cgroup *cgrp = parent_css->cgroup;
 	struct cgroup *next;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	cgroup_assert_mutex_or_rcu_locked();
 
 	/*
 	 * @pos could already have been removed.  Once a cgroup is removed,
@@ -2956,10 +2961,10 @@ EXPORT_SYMBOL_GPL(css_next_child);
  * to visit for pre-order traversal of @root's descendants.  @root is
  * included in the iteration and the first node to be visited.
  *
- * While this function requires RCU read locking, it doesn't require the
- * whole traversal to be contained in a single RCU critical section.  This
- * function will return the correct next descendant as long as both @pos
- * and @root are accessible and @pos is a descendant of @root.
+ * While this function requires cgroup_mutex or RCU read locking, it
+ * doesn't require the whole traversal to be contained in a single critical
+ * section.  This function will return the correct next descendant as long
+ * as both @pos and @root are accessible and @pos is a descendant of @root.
  */
 struct cgroup_subsys_state *
 css_next_descendant_pre(struct cgroup_subsys_state *pos,
@@ -2967,7 +2972,7 @@ css_next_descendant_pre(struct cgroup_subsys_state *pos,
 {
 	struct cgroup_subsys_state *next;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	cgroup_assert_mutex_or_rcu_locked();
 
 	/* if first iteration, visit @root */
 	if (!pos)
@@ -2998,17 +3003,17 @@ EXPORT_SYMBOL_GPL(css_next_descendant_pre);
  * is returned.  This can be used during pre-order traversal to skip
  * subtree of @pos.
  *
- * While this function requires RCU read locking, it doesn't require the
- * whole traversal to be contained in a single RCU critical section.  This
- * function will return the correct rightmost descendant as long as @pos is
- * accessible.
+ * While this function requires cgroup_mutex or RCU read locking, it
+ * doesn't require the whole traversal to be contained in a single critical
+ * section.  This function will return the correct rightmost descendant as
+ * long as @pos is accessible.
  */
 struct cgroup_subsys_state *
 css_rightmost_descendant(struct cgroup_subsys_state *pos)
 {
 	struct cgroup_subsys_state *last, *tmp;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	cgroup_assert_mutex_or_rcu_locked();
 
 	do {
 		last = pos;
@@ -3044,10 +3049,11 @@ css_leftmost_descendant(struct cgroup_subsys_state *pos)
  * to visit for post-order traversal of @root's descendants.  @root is
  * included in the iteration and the last node to be visited.
  *
- * While this function requires RCU read locking, it doesn't require the
- * whole traversal to be contained in a single RCU critical section.  This
- * function will return the correct next descendant as long as both @pos
- * and @cgroup are accessible and @pos is a descendant of @cgroup.
+ * While this function requires cgroup_mutex or RCU read locking, it
+ * doesn't require the whole traversal to be contained in a single critical
+ * section.  This function will return the correct next descendant as long
+ * as both @pos and @cgroup are accessible and @pos is a descendant of
+ * @cgroup.
  */
 struct cgroup_subsys_state *
 css_next_descendant_post(struct cgroup_subsys_state *pos,
@@ -3055,7 +3061,7 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
 {
 	struct cgroup_subsys_state *next;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	cgroup_assert_mutex_or_rcu_locked();
 
 	/* if first iteration, visit leftmost descendant which may be @root */
 	if (!pos)
@@ -5217,16 +5223,16 @@ __setup("cgroup_disable=", cgroup_disable);
  * @dentry: directory dentry of interest
  * @ss: subsystem of interest
  *
- * Must be called under RCU read lock.  The caller is responsible for
- * pinning the returned css if it needs to be accessed outside the RCU
- * critical section.
+ * Must be called under cgroup_mutex or RCU read lock.  The caller is
+ * responsible for pinning the returned css if it needs to be accessed
+ * outside the critical section.
  */
 struct cgroup_subsys_state *css_from_dir(struct dentry *dentry,
 					 struct cgroup_subsys *ss)
 {
 	struct cgroup *cgrp;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	cgroup_assert_mutex_or_rcu_locked();
 
 	/* is @dentry a cgroup dir? */
 	if (!dentry->d_inode ||
@@ -5249,9 +5255,7 @@ struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss)
 {
 	struct cgroup *cgrp;
 
-	rcu_lockdep_assert(rcu_read_lock_held() ||
-			   lockdep_is_held(&cgroup_mutex),
-			   "css_from_id() needs proper protection");
+	cgroup_assert_mutex_or_rcu_locked();
 
 	cgrp = idr_find(&ss->root->cgroup_idr, id);
 	if (cgrp)
-- 
1.8.4.2

