Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab3GXOOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:14:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45784 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752155Ab3GXOGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:52 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tejun Heo" <tj@kernel.org>,
        "Fengguang Wu" <fengguang.wu@intel.com>,
        "Li Zefan" <lizefan@huawei.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.581226504@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [45/85] cgroup: fix RCU accesses to task->cgroups
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 14611e51a57df10240817d8ada510842faf0ec51 upstream.

task->cgroups is a RCU pointer pointing to struct css_set.  A task
switches to a different css_set on cgroup migration but a css_set
doesn't change once created and its pointers to cgroup_subsys_states
aren't RCU protected.

task_subsys_state[_check]() is the macro to acquire css given a task
and subsys_id pair.  It RCU-dereferences task->cgroups->subsys[] not
task->cgroups, so the RCU pointer task->cgroups ends up being
dereferenced without read_barrier_depends() after it.  It's broken.

Fix it by introducing task_css_set[_check]() which does
RCU-dereference on task->cgroups.  task_subsys_state[_check]() is
reimplemented to directly dereference ->subsys[] of the css_set
returned from task_css_set[_check]().

This removes some of sparse RCU warnings in cgroup.

v2: Fixed unbalanced parenthsis and there's no need to use
    rcu_dereference_raw() when !CONFIG_PROVE_RCU.  Both spotted by Li.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Li Zefan <lizefan@huawei.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Remove CONFIG_PROVE_RCU condition
 - s/lockdep_is_held(&cgroup_mutex)/cgroup_lock_is_held()/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/cgroup.h | 58 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 48 insertions(+), 10 deletions(-)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -531,16 +531,54 @@ static inline struct cgroup_subsys_state
 	return cgrp->subsys[subsys_id];
 }
 
-/*
- * function to get the cgroup_subsys_state which allows for extra
- * rcu_dereference_check() conditions, such as locks used during the
- * cgroup_subsys::attach() methods.
+/**
+ * task_css_set_check - obtain a task's css_set with extra access conditions
+ * @task: the task to obtain css_set for
+ * @__c: extra condition expression to be passed to rcu_dereference_check()
+ *
+ * A task's css_set is RCU protected, initialized and exited while holding
+ * task_lock(), and can only be modified while holding both cgroup_mutex
+ * and task_lock() while the task is alive.  This macro verifies that the
+ * caller is inside proper critical section and returns @task's css_set.
+ *
+ * The caller can also specify additional allowed conditions via @__c, such
+ * as locks used during the cgroup_subsys::attach() methods.
+ */
+#define task_css_set_check(task, __c)					\
+	rcu_dereference_check((task)->cgroups,				\
+		lockdep_is_held(&(task)->alloc_lock) ||			\
+		cgroup_lock_is_held() || (__c))
+
+/**
+ * task_subsys_state_check - obtain css for (task, subsys) w/ extra access conds
+ * @task: the target task
+ * @subsys_id: the target subsystem ID
+ * @__c: extra condition expression to be passed to rcu_dereference_check()
+ *
+ * Return the cgroup_subsys_state for the (@task, @subsys_id) pair.  The
+ * synchronization rules are the same as task_css_set_check().
  */
 #define task_subsys_state_check(task, subsys_id, __c)			\
-	rcu_dereference_check(task->cgroups->subsys[subsys_id],		\
-			      lockdep_is_held(&task->alloc_lock) ||	\
-			      cgroup_lock_is_held() || (__c))
+	task_css_set_check((task), (__c))->subsys[(subsys_id)]
 
+/**
+ * task_css_set - obtain a task's css_set
+ * @task: the task to obtain css_set for
+ *
+ * See task_css_set_check().
+ */
+static inline struct css_set *task_css_set(struct task_struct *task)
+{
+	return task_css_set_check(task, false);
+}
+
+/**
+ * task_subsys_state - obtain css for (task, subsys)
+ * @task: the target task
+ * @subsys_id: the target subsystem ID
+ *
+ * See task_subsys_state_check().
+ */
 static inline struct cgroup_subsys_state *
 task_subsys_state(struct task_struct *task, int subsys_id)
 {

