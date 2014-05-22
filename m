Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbaEVM33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:29:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51333 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaEVM30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:29:26 -0400
Date: Thu, 22 May 2014 05:28:36 -0700
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-7aa2c016db2162defff77f6f5731bff3f25e5175@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <a568a1e3cc8e78648f41b5035fa5e381d36274da.1399532322.git.yangds.fnst@cn.fujitsu.com>
References: <a568a1e3cc8e78648f41b5035fa5e381d36274da.1399532322.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Consolidate open coded implementations of nice level frobbing into nice_to_rlimit
 () and rlimit_to_nice()
Git-Commit-ID: 7aa2c016db2162defff77f6f5731bff3f25e5175
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7aa2c016db2162defff77f6f5731bff3f25e5175
Gitweb:     http://git.kernel.org/tip/7aa2c016db2162defff77f6f5731bff3f25e5175
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Thu, 8 May 2014 18:33:49 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 22 May 2014 11:16:36 +0200

sched: Consolidate open coded implementations of nice level frobbing into nice_to_rlimit() and rlimit_to_nice()

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/a568a1e3cc8e78648f41b5035fa5e381d36274da.1399532322.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/staging/android/binder.c |  2 +-
 include/linux/sched/prio.h       | 16 ++++++++++++++++
 kernel/sched/core.c              |  2 +-
 kernel/sys.c                     |  6 +++---
 4 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 179b21b..9311bb6 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -436,7 +436,7 @@ static void binder_set_nice(long nice)
 		set_user_nice(current, nice);
 		return;
 	}
-	min_nice = 20 - current->signal->rlim[RLIMIT_NICE].rlim_cur;
+	min_nice = rlimit_to_nice(current->signal->rlim[RLIMIT_NICE].rlim_cur);
 	binder_debug(BINDER_DEBUG_PRIORITY_CAP,
 		     "%d: nice value %ld not allowed use %ld instead\n",
 		      current->pid, nice, min_nice);
diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index ac32258..d9cf5a5 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -41,4 +41,20 @@
 #define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
 #define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
 
+/*
+ * Convert nice value [19,-20] to rlimit style value [1,40].
+ */
+static inline long nice_to_rlimit(long nice)
+{
+	return (MAX_NICE - nice + 1);
+}
+
+/*
+ * Convert rlimit style value [1,40] to nice value [-20, 19].
+ */
+static inline long rlimit_to_nice(long prio)
+{
+	return (MAX_NICE - prio + 1);
+}
+
 #endif /* _SCHED_PRIO_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index da302ca..321d800 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3033,7 +3033,7 @@ EXPORT_SYMBOL(set_user_nice);
 int can_nice(const struct task_struct *p, const int nice)
 {
 	/* convert nice value [19,-20] to rlimit style value [1,40] */
-	int nice_rlim = 20 - nice;
+	int nice_rlim = nice_to_rlimit(nice);
 
 	return (nice_rlim <= task_rlimit(p, RLIMIT_NICE) ||
 		capable(CAP_SYS_NICE));
diff --git a/kernel/sys.c b/kernel/sys.c
index fba0f29..66a751e 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -250,7 +250,7 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 			else
 				p = current;
 			if (p) {
-				niceval = 20 - task_nice(p);
+				niceval = nice_to_rlimit(task_nice(p));
 				if (niceval > retval)
 					retval = niceval;
 			}
@@ -261,7 +261,7 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 			else
 				pgrp = task_pgrp(current);
 			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
-				niceval = 20 - task_nice(p);
+				niceval = nice_to_rlimit(task_nice(p));
 				if (niceval > retval)
 					retval = niceval;
 			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
@@ -277,7 +277,7 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 
 			do_each_thread(g, p) {
 				if (uid_eq(task_uid(p), uid)) {
-					niceval = 20 - task_nice(p);
+					niceval = nice_to_rlimit(task_nice(p));
 					if (niceval > retval)
 						retval = niceval;
 				}
