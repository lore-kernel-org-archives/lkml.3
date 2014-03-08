Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaCHBZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:25:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbaCHBHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Li Zefan <lizefan@huawei.com>, Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 50/99] cgroup: fix RCU accesses to task->cgroups
Date: Fri,  7 Mar 2014 17:07:46 -0800
Message-Id: <20140308010613.210603947@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/cgroup.h |   52 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 7 deletions(-)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -513,16 +513,54 @@ static inline struct cgroup_subsys_state
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


