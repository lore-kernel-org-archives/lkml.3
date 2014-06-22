Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaFVSSu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 14:18:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:27749 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751572AbaFVSSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 14:18:49 -0400
Date: Sun, 22 Jun 2014 14:18:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@gmail.com>
Subject: [GIT PULL v2] tracing: Cleanups and fixes to syscall tracepoints
 and added traceevent macro
Message-ID: <20140622141846.4cf2bd07@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Let's try this again. We fixed the issue with the breaking of another
arch with the syscall patches. But in the mean time I was informed that
the __field() macro no longer handles complex variables like
structures. This is needed for work being done for the RAS subsystem.
It doesn't affect any existing tracepoints but it fixes an issues that
should have worked before and will be needed in the future. More
details below and in the commit messages.

This includes three patches from Oleg Nesterov. The first is a fix to a
race condition that happens between enabling/disabling syscall tracepoints
and new process creations (the check to go into the ptrace path for a process
can be set when it shouldn't, or not set when it should). Not a major bug
but one that should be fixed and even applied to stable.

The other two patches are cleanup/fixes that are not that critical, but
for an -rc1 release would be nice to have. They both deal with syscall
tracepoints.

It also includes a patch to introduce a new macro for the TRACE_EVENT()
format called __field_struct(). Originally, __field() was used to record
any variable into a trace event, but with the addition of setting the
"is signed" attribute, the check causes anything but a primitive variable
to fail to compile. That is, structs and unions can't be used as they
once were. When the "is signed" check was introduce there were only
primitive variables being recorded. But that will change soon and it
was reported that __field() causes build failures.

To solve the __field() issue, __field_struct() is introduced to allow
trace_events to be able to record complex types too.

Please pull the latest trace-fixes-v3.16-rc1-v2 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.16-rc1-v2

Tag SHA1: 69e8277eeda20b29d83cb812e731e30feaefb68f
Head SHA1: 4d4c9cc839a308be3289a361ccba4447ee140552


Oleg Nesterov (3):
      tracing: Fix syscall_*regfunc() vs copy_process() race
      tracing: Change syscall_*regfunc() to check PF_KTHREAD and use for_each_process_thread()
      tracing: syscall_regfunc() should not skip kernel threads

Steven Rostedt (1):
      tracing: Add __field_struct macro for TRACE_EVENT()

----
 include/trace/ftrace.h                     | 33 ++++++++++++++++++++++++++++++
 include/trace/syscall.h                    | 15 ++++++++++++++
 kernel/fork.c                              |  2 ++
 kernel/tracepoint.c                        | 26 ++++++++++-------------
 samples/trace_events/trace-events-sample.h |  3 ++-
 5 files changed, 63 insertions(+), 16 deletions(-)
---------------------------
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 0fd06fef9fac..26b4f2e13275 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -44,6 +44,12 @@
 #undef __field_ext
 #define __field_ext(type, item, filter_type)	type	item;
 
+#undef __field_struct
+#define __field_struct(type, item)	type	item;
+
+#undef __field_struct_ext
+#define __field_struct_ext(type, item, filter_type)	type	item;
+
 #undef __array
 #define __array(type, item, len)	type	item[len];
 
@@ -122,6 +128,12 @@
 #undef __field_ext
 #define __field_ext(type, item, filter_type)
 
+#undef __field_struct
+#define __field_struct(type, item)
+
+#undef __field_struct_ext
+#define __field_struct_ext(type, item, filter_type)
+
 #undef __array
 #define __array(type, item, len)
 
@@ -315,9 +327,21 @@ static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
 	if (ret)							\
 		return ret;
 
+#undef __field_struct_ext
+#define __field_struct_ext(type, item, filter_type)			\
+	ret = trace_define_field(event_call, #type, #item,		\
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item),			\
+				 0, filter_type);			\
+	if (ret)							\
+		return ret;
+
 #undef __field
 #define __field(type, item)	__field_ext(type, item, FILTER_OTHER)
 
+#undef __field_struct
+#define __field_struct(type, item) __field_struct_ext(type, item, FILTER_OTHER)
+
 #undef __array
 #define __array(type, item, len)					\
 	do {								\
@@ -379,6 +403,12 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 #undef __field_ext
 #define __field_ext(type, item, filter_type)
 
+#undef __field_struct
+#define __field_struct(type, item)
+
+#undef __field_struct_ext
+#define __field_struct_ext(type, item, filter_type)
+
 #undef __array
 #define __array(type, item, len)
 
@@ -550,6 +580,9 @@ static inline notrace int ftrace_get_offsets_##call(			\
 #undef __field
 #define __field(type, item)
 
+#undef __field_struct
+#define __field_struct(type, item)
+
 #undef __array
 #define __array(type, item, len)
 
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index fed853f3d7aa..9674145e2f6a 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -4,6 +4,7 @@
 #include <linux/tracepoint.h>
 #include <linux/unistd.h>
 #include <linux/ftrace_event.h>
+#include <linux/thread_info.h>
 
 #include <asm/ptrace.h>
 
@@ -32,4 +33,18 @@ struct syscall_metadata {
 	struct ftrace_event_call *exit_event;
 };
 
+#if defined(CONFIG_TRACEPOINTS) && defined(CONFIG_HAVE_SYSCALL_TRACEPOINTS)
+static inline void syscall_tracepoint_update(struct task_struct *p)
+{
+	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
+		set_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
+	else
+		clear_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
+}
+#else
+static inline void syscall_tracepoint_update(struct task_struct *p)
+{
+}
+#endif
+
 #endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index d2799d1fc952..6a13c46cd87d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1487,7 +1487,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
+	syscall_tracepoint_update(p);
 	write_unlock_irq(&tasklist_lock);
+
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	if (clone_flags & CLONE_THREAD)
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 33cbd8c203f8..3490407dc7b7 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -492,33 +492,29 @@ static int sys_tracepoint_refcount;
 
 void syscall_regfunc(void)
 {
-	unsigned long flags;
-	struct task_struct *g, *t;
+	struct task_struct *p, *t;
 
 	if (!sys_tracepoint_refcount) {
-		read_lock_irqsave(&tasklist_lock, flags);
-		do_each_thread(g, t) {
-			/* Skip kernel threads. */
-			if (t->mm)
-				set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
-		} while_each_thread(g, t);
-		read_unlock_irqrestore(&tasklist_lock, flags);
+		read_lock(&tasklist_lock);
+		for_each_process_thread(p, t) {
+			set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
+		}
+		read_unlock(&tasklist_lock);
 	}
 	sys_tracepoint_refcount++;
 }
 
 void syscall_unregfunc(void)
 {
-	unsigned long flags;
-	struct task_struct *g, *t;
+	struct task_struct *p, *t;
 
 	sys_tracepoint_refcount--;
 	if (!sys_tracepoint_refcount) {
-		read_lock_irqsave(&tasklist_lock, flags);
-		do_each_thread(g, t) {
+		read_lock(&tasklist_lock);
+		for_each_process_thread(p, t) {
 			clear_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
-		} while_each_thread(g, t);
-		read_unlock_irqrestore(&tasklist_lock, flags);
+		}
+		read_unlock(&tasklist_lock);
 	}
 }
 #endif
diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index 6af373236d73..4b0113f73ee9 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -56,7 +56,8 @@
  * struct:  This defines the way the data will be stored in the ring buffer.
  *    There are currently two types of elements. __field and __array.
  *    a __field is broken up into (type, name). Where type can be any
- *    type but an array.
+ *    primitive type (integer, long or pointer). __field_struct() can
+ *    be any static complex data value (struct, union, but not an array).
  *    For an array. there are three fields. (type, name, size). The
  *    type of elements in the array, the name of the field and the size
  *    of the array.
