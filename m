Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaA0JSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:18:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:46967 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbaA0JSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:18:06 -0500
X-IronPort-AV: E=Sophos;i="4.95,728,1384272000"; 
   d="scan'208";a="9457825"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, peterz@infradead.org
Cc: raistlin@linux.it, juri.lelli@gmail.com, clark.williams@gmail.com,
        mingo@redhat.com, rostedt@goodmis.org,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] sched: Implement task_nice and task_prio as static inline functions.
Date: Mon, 27 Jan 2014 17:15:39 -0500
Message-Id: <1800e6249ff54199573ea5f0aa4ec16b15bb5158.1390859827.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1390859827.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1390859827.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/27 17:16:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/27 17:16:28,
	Serialize complete at 2014/01/27 17:16:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As commit 0e0c0797 expose the priority related macros in linux/sched/prio.h,
we don't have to implement task_nice and task_prio in kernel/sched/core.c any
more.

This patch implement them in linux/sched/sched.h as static inline functions,
saving the kernel stack and enhancing the performance.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 include/linux/sched.h | 26 ++++++++++++++++++++++++--
 kernel/sched/core.c   | 25 -------------------------
 2 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ba1b732..125145b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2082,8 +2082,30 @@ static inline void sched_autogroup_exit(struct signal_struct *sig) { }
 
 extern bool yield_to(struct task_struct *p, bool preempt);
 extern void set_user_nice(struct task_struct *p, long nice);
-extern int task_prio(const struct task_struct *p);
-extern int task_nice(const struct task_struct *p);
+/**
+ * task_prio - return the priority value of a given task.
+ * @p: the task in question.
+ *
+ * Return: The priority value as seen by users in /proc.
+ * RT tasks are offset by -200. Normal tasks are centered
+ * around 0, value goes from -16 to +15.
+ */
+static inline int task_prio(const struct task_struct *p)
+{
+	return p->prio - MAX_RT_PRIO;
+}
+
+/**
+ * task_nice - return the nice value of a given task.
+ * @p: the task in question.
+ *
+ * Return: The nice value [ -20 ... 0 ... 19 ].
+ */
+static inline int task_nice(const struct task_struct *p)
+{
+	return TASK_NICE(p);
+}
+
 extern int can_nice(const struct task_struct *p, const int nice);
 extern int task_curr(const struct task_struct *p);
 extern int idle_cpu(int cpu);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7fea865..a8d6150 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3096,31 +3096,6 @@ SYSCALL_DEFINE1(nice, int, increment)
 #endif
 
 /**
- * task_prio - return the priority value of a given task.
- * @p: the task in question.
- *
- * Return: The priority value as seen by users in /proc.
- * RT tasks are offset by -200. Normal tasks are centered
- * around 0, value goes from -16 to +15.
- */
-int task_prio(const struct task_struct *p)
-{
-	return p->prio - MAX_RT_PRIO;
-}
-
-/**
- * task_nice - return the nice value of a given task.
- * @p: the task in question.
- *
- * Return: The nice value [ -20 ... 0 ... 19 ].
- */
-int task_nice(const struct task_struct *p)
-{
-	return TASK_NICE(p);
-}
-EXPORT_SYMBOL(task_nice);
-
-/**
  * idle_cpu - is a given cpu idle currently?
  * @cpu: the processor in question.
  *
-- 
1.8.2.1

