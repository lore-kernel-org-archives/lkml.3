Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab3H1VGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:06:06 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:53246 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab3H1VD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:03:58 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/9] cgroup: css iterations and css_from_dir() are safe under cgroup_mutex
Date: Wed, 28 Aug 2013 17:03:42 -0400
Message-Id: <1377723829-22814-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1377723829-22814-1-git-send-email-tj@kernel.org>
References: <1377723829-22814-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, all css iterations and css_from_dir() require RCU read lock
whether the caller is holding cgroup_mutex or not, which is
unnecessarily restrictive.  They are all safe to use under
cgroup_mutex without holding RCU read lock.

Factor out cgroup_assert_mutex_or_rcu_locked() from css_from_id() and
apply it to all css iteration functions and css_from_dir().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 56 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a4168cf..a10baf8 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -82,8 +82,13 @@
 #ifdef CONFIG_PROVE_RCU
 DEFINE_MUTEX(cgroup_mutex);
 EXPORT_SYMBOL_GPL(cgroup_mutex);	/* only for lockdep */
+#define cgroup_assert_mutex_or_rcu_locked()				\
+	rcu_lockdep_assert(rcu_read_lock_held() ||			\
+			   lockdep_is_held(&cgroup_mutex),		\
+			   "cgroup_mutex or RCU read lock required");
 #else
 static DEFINE_MUTEX(cgroup_mutex);
+#define cgroup_assert_mutex_or_rcu_locked()	do { } while (false)
 #endif
 
 static DEFINE_MUTEX(cgroup_root_mutex);
@@ -3036,9 +3041,9 @@ static void cgroup_enable_task_cg_lists(void)
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
@@ -3048,7 +3053,7 @@ css_next_child(struct cgroup_subsys_state *pos_css,
 	struct cgroup *cgrp = parent_css->cgroup;
 	struct cgroup *next;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	cgroup_assert_mutex_or_rcu_locked();
 
 	/*
 	 * @pos could already have been removed.  Once a cgroup is removed,
@@ -3095,10 +3100,10 @@ EXPORT_SYMBOL_GPL(css_next_child);
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
@@ -3106,7 +3111,7 @@ css_next_descendant_pre(struct cgroup_subsys_state *pos,
 {
 	struct cgroup_subsys_state *next;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	cgroup_assert_mutex_or_rcu_locked();
 
 	/* if first iteration, visit @root */
 	if (!pos)
@@ -3137,17 +3142,17 @@ EXPORT_SYMBOL_GPL(css_next_descendant_pre);
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
@@ -3183,10 +3188,11 @@ css_leftmost_descendant(struct cgroup_subsys_state *pos)
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
@@ -3194,7 +3200,7 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
 {
 	struct cgroup_subsys_state *next;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	cgroup_assert_mutex_or_rcu_locked();
 
 	/* if first iteration, visit the leftmost descendant */
 	if (!pos) {
@@ -5698,16 +5704,16 @@ EXPORT_SYMBOL_GPL(css_lookup);
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
@@ -5730,9 +5736,7 @@ struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss)
 {
 	struct cgroup *cgrp;
 
-	rcu_lockdep_assert(rcu_read_lock_held() ||
-			   lockdep_is_held(&cgroup_mutex),
-			   "css_from_id() needs proper protection");
+	cgroup_assert_mutex_or_rcu_locked();
 
 	cgrp = idr_find(&ss->root->cgroup_idr, id);
 	if (cgrp)
-- 
1.8.3.1

