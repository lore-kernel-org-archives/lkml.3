Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaE1IqC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:46:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:17443 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbaE1Ip6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:45:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,926,1392192000"; 
   d="scan'208";a="518914533"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf: Differentiate exec() and non-exec() comm events
Date: Wed, 28 May 2014 11:45:04 +0300
Message-Id: <1401266704-22572-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf tools like 'perf report' can aggregate samples by comm
strings, which generally works.  However, there are other
potential use-cases.  For example, to pair up 'calls'
with 'returns' accurately (from branch events like Intel BTS)
it is necessary to identify whether the process has exec'd.
Although a comm event is generated when an 'exec' happens
it is also generated whenever the comm string is changed
on a whim (e.g. by prctl PR_SET_NAME).  This patch adds a
flag to the comm event to differentiate one case from the
other.

In order to determine whether the kernel supports the new
flag, a selection bit named 'exec' is added to struct
perf_event_attr.  The bit does nothing but will cause
perf_event_open() to fail if the bit is set on kernels
that do not have it defined.

Cc: Dave Jones <davej@redhat.com>
Link: http://lkml.kernel.org/r/537D9EBE.7030806@intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 fs/exec.c                       | 6 +++---
 include/linux/perf_event.h      | 4 ++--
 include/linux/sched.h           | 6 +++++-
 include/uapi/linux/perf_event.h | 9 +++++++--
 kernel/events/core.c            | 4 ++--
 5 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index eb83064..a9a9591 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1046,13 +1046,13 @@ EXPORT_SYMBOL_GPL(get_task_comm);
  * so that a new one can be started
  */
 
-void set_task_comm(struct task_struct *tsk, const char *buf)
+void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
 {
 	task_lock(tsk);
 	trace_task_rename(tsk, buf);
 	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
-	perf_event_comm(tsk);
+	perf_event_comm(tsk, exec);
 }
 
 int flush_old_exec(struct linux_binprm * bprm)
@@ -1111,7 +1111,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 		set_dumpable(current->mm, suid_dumpable);
 
 	perf_event_exec();
-	set_task_comm(current, kbasename(bprm->filename));
+	__set_task_comm(current, kbasename(bprm->filename), true);
 
 	/* Set the new mm task size. We have to do that late because it may
 	 * depend on TIF_32BIT which is only updated in flush_thread() on
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ec2e29f..3f736a5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -707,7 +707,7 @@ extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *
 extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 
 extern void perf_event_exec(void);
-extern void perf_event_comm(struct task_struct *tsk);
+extern void perf_event_comm(struct task_struct *tsk, bool exec);
 extern void perf_event_fork(struct task_struct *tsk);
 
 /* Callchains */
@@ -814,7 +814,7 @@ static inline int perf_unregister_guest_info_callbacks
 (struct perf_guest_info_callbacks *callbacks)				{ return 0; }
 
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
-static inline void perf_event_comm(struct task_struct *tsk)		{ }
+static inline void perf_event_comm(struct task_struct *tsk, bool exec)	{ }
 static inline void perf_event_fork(struct task_struct *tsk)		{ }
 static inline void perf_event_init(void)				{ }
 static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25f54c7..cadcf38 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2376,7 +2376,11 @@ extern long do_fork(unsigned long, unsigned long, unsigned long, int __user *, i
 struct task_struct *fork_idle(int);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 
-extern void set_task_comm(struct task_struct *tsk, const char *from);
+extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec);
+static inline void set_task_comm(struct task_struct *tsk, const char *from)
+{
+	__set_task_comm(tsk, from, false);
+}
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index d9cd853..7e55160 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -302,8 +302,8 @@ struct perf_event_attr {
 				exclude_callchain_kernel : 1, /* exclude kernel callchains */
 				exclude_callchain_user   : 1, /* exclude user callchains */
 				mmap2          :  1, /* include mmap with inode data     */
-
-				__reserved_1   : 40;
+				exec           :  1, /* flag comm events that are due to an exec */
+				__reserved_1   : 39;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -502,7 +502,12 @@ struct perf_event_mmap_page {
 #define PERF_RECORD_MISC_GUEST_KERNEL		(4 << 0)
 #define PERF_RECORD_MISC_GUEST_USER		(5 << 0)
 
+/*
+ * PERF_RECORD_MISC_MMAP_DATA and PERF_RECORD_MISC_COMM_EXEC are used on
+ * different events so can reuse the same bit position.
+ */
 #define PERF_RECORD_MISC_MMAP_DATA		(1 << 13)
+#define PERF_RECORD_MISC_COMM_EXEC		(1 << 13)
 /*
  * Indicates that the content of PERF_SAMPLE_IP points to
  * the actual instruction that triggered the event. See also
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6a5e064..9efb1e7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5090,7 +5090,7 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 		       NULL);
 }
 
-void perf_event_comm(struct task_struct *task)
+void perf_event_comm(struct task_struct *task, bool exec)
 {
 	struct perf_comm_event comm_event;
 
@@ -5104,7 +5104,7 @@ void perf_event_comm(struct task_struct *task)
 		.event_id  = {
 			.header = {
 				.type = PERF_RECORD_COMM,
-				.misc = 0,
+				.misc = exec ? PERF_RECORD_MISC_COMM_EXEC : 0,
 				/* .size */
 			},
 			/* .pid */
-- 
1.8.3.2

