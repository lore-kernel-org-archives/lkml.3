Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765524Ab3DDXhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:37:06 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:63217 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765513Ab3DDXhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:37:00 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] cgroup: remove cgroup_lock_is_held()
Date: Thu,  4 Apr 2013 16:36:29 -0700
Message-Id: <1365118589-10619-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365118589-10619-1-git-send-email-tj@kernel.org>
References: <1365118589-10619-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't want controllers to assume that the information is officially
available and do funky things with it.

The only user is task_subsys_state_check() which uses it to verify RCU
access context.  We can move cgroup_lock_is_held() inside
CONFIG_PROVE_RCU but that doesn't add meaningful protection compared
to conditionally exposing cgroup_mutex.

Remove cgroup_lock_is_held(), export cgroup_mutex iff CONFIG_PROVE_RCU
and use lockdep_is_held() directly on the mutex in
task_subsys_state_check().

While at it, add parentheses around macro arguments in
task_subsys_state_check().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 13 +++++++++----
 kernel/cgroup.c        | 20 ++++++--------------
 2 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 63deb70..515927e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -30,7 +30,6 @@ struct css_id;
 
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
-extern int cgroup_lock_is_held(void);
 extern void cgroup_fork(struct task_struct *p);
 extern void cgroup_post_fork(struct task_struct *p);
 extern void cgroup_exit(struct task_struct *p, int run_callbacks);
@@ -552,10 +551,16 @@ static inline struct cgroup_subsys_state *cgroup_subsys_state(
  * rcu_dereference_check() conditions, such as locks used during the
  * cgroup_subsys::attach() methods.
  */
+#ifdef CONFIG_PROVE_RCU
+extern struct mutex cgroup_mutex;
 #define task_subsys_state_check(task, subsys_id, __c)			\
-	rcu_dereference_check(task->cgroups->subsys[subsys_id],		\
-			      lockdep_is_held(&task->alloc_lock) ||	\
-			      cgroup_lock_is_held() || (__c))
+	rcu_dereference_check((task)->cgroups->subsys[(subsys_id)],	\
+			      lockdep_is_held(&(task)->alloc_lock) ||	\
+			      lockdep_is_held(&cgroup_mutex) || (__c))
+#else
+#define task_subsys_state_check(task, subsys_id, __c)			\
+	rcu_dereference((task)->cgroups->subsys[(subsys_id)])
+#endif
 
 static inline struct cgroup_subsys_state *
 task_subsys_state(struct task_struct *task, int subsys_id)
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1a65958..ba3e24a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -83,7 +83,13 @@
  * B happens only through cgroup_show_options() and using cgroup_root_mutex
  * breaks it.
  */
+#ifdef CONFIG_PROVE_RCU
+DEFINE_MUTEX(cgroup_mutex);
+EXPORT_SYMBOL_GPL(cgroup_mutex);	/* only for task_subsys_state_check() */
+#else
 static DEFINE_MUTEX(cgroup_mutex);
+#endif
+
 static DEFINE_MUTEX(cgroup_root_mutex);
 
 /*
@@ -251,20 +257,6 @@ static int cgroup_destroy_locked(struct cgroup *cgrp);
 static int cgroup_addrm_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 			      struct cftype cfts[], bool is_add);
 
-#ifdef CONFIG_PROVE_LOCKING
-int cgroup_lock_is_held(void)
-{
-	return lockdep_is_held(&cgroup_mutex);
-}
-#else /* #ifdef CONFIG_PROVE_LOCKING */
-int cgroup_lock_is_held(void)
-{
-	return mutex_is_locked(&cgroup_mutex);
-}
-#endif /* #else #ifdef CONFIG_PROVE_LOCKING */
-
-EXPORT_SYMBOL_GPL(cgroup_lock_is_held);
-
 static int css_unbias_refcnt(int refcnt)
 {
 	return refcnt >= 0 ? refcnt : refcnt - CSS_DEACT_BIAS;
-- 
1.8.1.4

