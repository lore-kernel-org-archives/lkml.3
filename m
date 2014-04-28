Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbaD1Bbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42899 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Richard Guy Briggs" <rgb@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.97166684@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 56/94] pid: get pid_t ppid of task in init_pid_ns
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/sched.h | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1690,6 +1690,24 @@ static inline pid_t task_tgid_vnr(struct
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
@@ -1727,7 +1745,7 @@ static inline pid_t task_pgrp_nr(struct
  * If pid_alive fails, then pointers within the task structure
  * can be stale and must not be dereferenced.
  */
-static inline int pid_alive(struct task_struct *p)
+static inline int pid_alive(const struct task_struct *p)
 {
 	return p->pids[PIDTYPE_PID].pid != NULL;
 }

