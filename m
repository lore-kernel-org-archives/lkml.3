Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbaE2Eey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:34:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbaE2Eeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 3.14 006/140] pid: get pid_t ppid of task in init_pid_ns
Date: Wed, 28 May 2014 21:32:25 -0700
Message-Id: <20140529043050.380954143@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/sched.h |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1688,6 +1688,24 @@ static inline pid_t task_tgid_vnr(struct
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
  *
  * Return: 1 if the process is alive. 0 otherwise.
  */
-static inline int pid_alive(struct task_struct *p)
+static inline int pid_alive(const struct task_struct *p)
 {
 	return p->pids[PIDTYPE_PID].pid != NULL;
 }


