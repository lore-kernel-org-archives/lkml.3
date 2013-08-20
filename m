Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab3HTVda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:33:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab3HTVd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:33:28 -0400
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
Subject: [PATCH 03/12] pid: get ppid pid_t of task in init_pid_ns safely
Date: Tue, 20 Aug 2013 17:31:55 -0400
Message-Id: <a411b87ba4c4af251166ee5877cb8c646cf7826c.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the functions
        task_ppid()
        task_ppid_nr_ns()
        task_ppid_nr_init_ns()
to safely abstract the lookup of the PPID (real_parent's tgid) of a process,
including rcu locking, in any required pid namespace.  This provides an
alternative to sys_getppid(), which is relative to the child process' pid
namespace.

(informed by ebiederman's 6c621b7e)
Cc: stable@vger.kernel.org
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/sched.h |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d722490..ec04090 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1448,6 +1448,11 @@ static inline struct pid *task_session(struct task_struct *task)
 	return task->group_leader->pids[PIDTYPE_SID].pid;
 }
 
+static inline struct pid *task_ppid(struct task_struct *task)
+{
+	return task_tgid(rcu_dereference(current->real_parent));
+}
+
 struct pid_namespace;
 
 /*
@@ -1496,6 +1501,24 @@ static inline pid_t task_tgid_vnr(struct task_struct *tsk)
 }
 
 
+static inline pid_t task_ppid_nr_ns(struct task_struct *tsk,
+					struct pid_namespace *ns)
+{
+	pid_t pid;
+
+	rcu_read_lock();
+	pid = pid_nr_ns(task_ppid(current), ns);
+	rcu_read_unlock();
+
+	return pid;
+}
+
+static inline pid_t task_ppid_nr_init_ns(struct task_struct *tsk)
+{
+	return task_ppid_nr_ns(tsk, &init_pid_ns);
+}
+
+
 static inline pid_t task_pgrp_nr_ns(struct task_struct *tsk,
 					struct pid_namespace *ns)
 {
-- 
1.7.1

