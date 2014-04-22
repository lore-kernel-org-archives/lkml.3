Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbaDVUoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:44:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36628 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758134AbaDVUYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:24:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 088/133] pid: get pid_t ppid of task in init_pid_ns
Date: Tue, 22 Apr 2014 13:13:46 -0700
Message-Id: <1398197671-12786-89-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Guy Briggs <rgb@redhat.com>

commit ad36d28293936b03d6b7996e9d6aadfd73c0eb08 upstream.

Added the functions task_ppid_nr_ns() and task_ppid_nr() to abstract the lookup
of the PPID (real_parent's pid_t) of a process, including rcu locking, in the
arbitrary and init_pid_ns.
This provides an alternative to sys_getppid(), which is relative to the child
process' pid namespace.

(informed by ebiederman's 6c621b7e)
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/sched.h | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 87f0503..ee686ba 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1727,6 +1727,24 @@ static inline pid_t task_tgid_vnr(struct task_struct *tsk)
 }
 
 
+static int pid_alive(const struct task_struct *p);
+static inline pid_t task_ppid_nr_ns(const struct task_struct *tsk, struct pid_namespace *ns)
+{
+	pid_t pid = 0;
+
+	rcu_read_lock();
+	if (pid_alive(tsk))
+		pid = task_tgid_nr_ns(rcu_dereference(tsk->real_parent), ns);
+	rcu_read_unlock();
+
+	return pid;
+}
+
+static inline pid_t task_ppid_nr(const struct task_struct *tsk)
+{
+	return task_ppid_nr_ns(tsk, &init_pid_ns);
+}
+
 static inline pid_t task_pgrp_nr_ns(struct task_struct *tsk,
 					struct pid_namespace *ns)
 {
@@ -1764,7 +1782,7 @@ static inline pid_t task_pgrp_nr(struct task_struct *tsk)
  * If pid_alive fails, then pointers within the task structure
  * can be stale and must not be dereferenced.
  */
-static inline int pid_alive(struct task_struct *p)
+static inline int pid_alive(const struct task_struct *p)
 {
 	return p->pids[PIDTYPE_PID].pid != NULL;
 }
-- 
1.9.1

