Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab3HTVdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:33:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab3HTVdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:33:33 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 05/12] pid: get pid_t of task in init_pid_ns correctly
Date: Tue, 20 Aug 2013 17:31:57 -0400
Message-Id: <aff5414acbe54d255ab3792b5273ff0ffeba29e4.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the functions
        task_pid_nr_init_ns()
        task_tgid_nr_init_ns()
to avoid the use of the error-prone duplicity of task->pid and task->tgid,
avoid changing the existing usage of task_pid_nr() and task_tgid_nr() while it
gets converted away from task->pid and task->tgid, and provide a clear
abstraction of the frequently used init_pid_ns in task_pid_nr_ns() and
task_tgid_nr_ns().
Also added pid_nr_init_ns() to explicitly use init_pid_ns.

(informed by ebiederman's 3a2e8c59)
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/pid.h   |    6 ++++++
 include/linux/sched.h |   10 ++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index 23705a5..051e134 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -172,6 +172,12 @@ static inline pid_t pid_nr(struct pid *pid)
 pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns);
 pid_t pid_vnr(struct pid *pid);
 
+static inline pid_t pid_nr_init_ns(struct pid *pid)
+{
+	return pid_nr_ns(pid, &init_pid_ns);
+}
+
+
 #define do_each_pid_task(pid, type, task)				\
 	do {								\
 		if ((pid) != NULL)					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ec04090..9651d95 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1482,6 +1482,11 @@ static inline pid_t task_pid_nr_ns(struct task_struct *tsk,
 	return __task_pid_nr_ns(tsk, PIDTYPE_PID, ns);
 }
 
+static inline pid_t task_pid_nr_init_ns(struct task_struct *tsk)
+{
+	return task_pid_nr_ns(tsk, &init_pid_ns);
+}
+
 static inline pid_t task_pid_vnr(struct task_struct *tsk)
 {
 	return __task_pid_nr_ns(tsk, PIDTYPE_PID, NULL);
@@ -1495,6 +1500,11 @@ static inline pid_t task_tgid_nr(struct task_struct *tsk)
 
 pid_t task_tgid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
 
+static inline pid_t task_tgid_nr_init_ns(struct task_struct *tsk)
+{
+	return task_tgid_nr_ns(tsk, &init_pid_ns);
+}
+
 static inline pid_t task_tgid_vnr(struct task_struct *tsk)
 {
 	return pid_vnr(task_tgid(tsk));
-- 
1.7.1

