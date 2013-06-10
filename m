Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab3FJOKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 10:10:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab3FJOKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 10:10:39 -0400
Date: Mon, 10 Jun 2013 16:06:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] unexport __set_special_pids()
Message-ID: <20130610140640.GA5732@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move __set_special_pids() from exit.c to sys.c close to its
single caller and make it static.

And rename it to set_special_pids(), another helper with this
name has gone away.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h |    2 --
 kernel/exit.c         |   11 -----------
 kernel/sys.c          |   13 ++++++++++++-
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ce51dfd..253cb37 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1955,8 +1955,6 @@ extern struct task_struct *find_task_by_vpid(pid_t nr);
 extern struct task_struct *find_task_by_pid_ns(pid_t nr,
 		struct pid_namespace *ns);
 
-extern void __set_special_pids(struct pid *pid);
-
 /* per-UID process charging. */
 extern struct user_struct * alloc_uid(kuid_t);
 static inline struct user_struct *get_uid(struct user_struct *u)
diff --git a/kernel/exit.c b/kernel/exit.c
index af2eb3c..0ae87b5 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -312,17 +312,6 @@ kill_orphaned_pgrp(struct task_struct *tsk, struct task_struct *parent)
 	}
 }
 
-void __set_special_pids(struct pid *pid)
-{
-	struct task_struct *curr = current->group_leader;
-
-	if (task_session(curr) != pid)
-		change_pid(curr, PIDTYPE_SID, pid);
-
-	if (task_pgrp(curr) != pid)
-		change_pid(curr, PIDTYPE_PGID, pid);
-}
-
 /*
  * Let kernel threads use this to say that they allow a certain signal.
  * Must not be used if kthread was cloned with CLONE_SIGHAND.
diff --git a/kernel/sys.c b/kernel/sys.c
index b95d3c7..50f8677 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1286,6 +1286,17 @@ out:
 	return retval;
 }
 
+static void set_special_pids(struct pid *pid)
+{
+	struct task_struct *curr = current->group_leader;
+
+	if (task_session(curr) != pid)
+		change_pid(curr, PIDTYPE_SID, pid);
+
+	if (task_pgrp(curr) != pid)
+		change_pid(curr, PIDTYPE_PGID, pid);
+}
+
 SYSCALL_DEFINE0(setsid)
 {
 	struct task_struct *group_leader = current->group_leader;
@@ -1305,7 +1316,7 @@ SYSCALL_DEFINE0(setsid)
 		goto out;
 
 	group_leader->signal->leader = 1;
-	__set_special_pids(sid);
+	set_special_pids(sid);
 
 	proc_clear_tty(group_leader);
 
-- 
1.5.5.1


