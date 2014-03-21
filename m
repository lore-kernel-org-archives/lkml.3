Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbaCUC4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 22:56:41 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:11071 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756619AbaCUC4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 22:56:39 -0400
Date: Thu, 20 Mar 2014 22:56:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Ingo Molnar <mingo@kernel.org>, Laurent Chavey <chavey@google.com>
Subject: [GIT PULL] tracing: Fix array size mismatch in format string
Message-ID: <20140320225637.0226041b@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Vaibhav Nagarnaik discovered that since 3.10 a clean up patch made the
array index in the trace event format bogus. He supplied an elegant solution
that uses __stringify() and also removes the need for the event_storage
and event_storage_mutex that cuts off a few K of overhead from
the trace events.

I know this is very late in the -rcs. I'm fine if you don't pull this
and I'll just add it to my 3.15 push. The Cc to stable still stands as
this does fix bogus information passed to userspace.

This actually conflicts with my current 3.15 queue, as I had a not so
elegant code reduction of this same code. I'll have to revert my change
to use this one instead.

I'll let you decide to pull it or let it wait.

-- Steve


Please pull the latest trace-fixes-v3.14-rc7 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.14-rc7

Tag SHA1: e7c4d872fd1fc8906debb95c6eab6f3b4d035a86
Head SHA1: 87291347c49dc40aa339f587b209618201c2e527


Vaibhav Nagarnaik (1):
      tracing: Fix array size mismatch in format string

----
 include/linux/ftrace_event.h | 4 ----
 include/trace/ftrace.h       | 7 ++-----
 kernel/trace/trace_events.c  | 6 ------
 kernel/trace/trace_export.c  | 7 ++-----
 4 files changed, 4 insertions(+), 20 deletions(-)
---------------------------
commit 87291347c49dc40aa339f587b209618201c2e527
Author: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date:   Thu Feb 13 19:51:48 2014 -0800

    tracing: Fix array size mismatch in format string
    
    In event format strings, the array size is reported in two locations.
    One in array subscript and then via the "size:" attribute. The values
    reported there have a mismatch.
    
    For e.g., in sched:sched_switch the prev_comm and next_comm character
    arrays have subscript values as [32] where as the actual field size is
    16.
    
    name: sched_switch
    ID: 301
    format:
            field:unsigned short common_type;       offset:0;       size:2; signed:0;
            field:unsigned char common_flags;       offset:2;       size:1; signed:0;
            field:unsigned char common_preempt_count;       offset:3;       size:1;signed:0;
            field:int common_pid;   offset:4;       size:4; signed:1;
    
            field:char prev_comm[32];       offset:8;       size:16;        signed:1;
            field:pid_t prev_pid;   offset:24;      size:4; signed:1;
            field:int prev_prio;    offset:28;      size:4; signed:1;
            field:long prev_state;  offset:32;      size:8; signed:1;
            field:char next_comm[32];       offset:40;      size:16;        signed:1;
            field:pid_t next_pid;   offset:56;      size:4; signed:1;
            field:int next_prio;    offset:60;      size:4; signed:1;
    
    After bisection, the following commit was blamed:
    92edca0 tracing: Use direct field, type and system names
    
    This commit removes the duplication of strings for field->name and
    field->type assuming that all the strings passed in
    __trace_define_field() are immutable. This is not true for arrays, where
    the type string is created in event_storage variable and field->type for
    all array fields points to event_storage.
    
    Use __stringify() to create a string constant for the type string.
    
    Also, get rid of event_storage and event_storage_mutex that are not
    needed anymore.
    
    also, an added benefit is that this reduces the overhead of events a bit more:
    
       text    data     bss     dec     hex filename
    8424787 2036472 1302528 11763787         b3804b vmlinux
    8420814 2036408 1302528 11759750         b37086 vmlinux.patched
    
    Link: http://lkml.kernel.org/r/1392349908-29685-1-git-send-email-vnagarnaik@google.com
    
    Cc: Laurent Chavey <chavey@google.com>
    Cc: stable@vger.kernel.org # 3.10+
    Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4e4cc28..4cdb3a1 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -495,10 +495,6 @@ enum {
 	FILTER_TRACE_FN,
 };
 
-#define EVENT_STORAGE_SIZE 128
-extern struct mutex event_storage_mutex;
-extern char event_storage[EVENT_STORAGE_SIZE];
-
 extern int trace_event_raw_init(struct ftrace_event_call *call);
 extern int trace_define_field(struct ftrace_event_call *call, const char *type,
 			      const char *name, int offset, int size,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 1a8b28d..1ee19a2 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -310,15 +310,12 @@ static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
 #undef __array
 #define __array(type, item, len)					\
 	do {								\
-		mutex_lock(&event_storage_mutex);			\
+		char *type_str = #type"["__stringify(len)"]";		\
 		BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);			\
-		snprintf(event_storage, sizeof(event_storage),		\
-			 "%s[%d]", #type, len);				\
-		ret = trace_define_field(event_call, event_storage, #item, \
+		ret = trace_define_field(event_call, type_str, #item,	\
 				 offsetof(typeof(field), item),		\
 				 sizeof(field.item),			\
 				 is_signed_type(type), FILTER_OTHER);	\
-		mutex_unlock(&event_storage_mutex);			\
 		if (ret)						\
 			return ret;					\
 	} while (0);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f3989ce..7b16d40 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -27,12 +27,6 @@
 
 DEFINE_MUTEX(event_mutex);
 
-DEFINE_MUTEX(event_storage_mutex);
-EXPORT_SYMBOL_GPL(event_storage_mutex);
-
-char event_storage[EVENT_STORAGE_SIZE];
-EXPORT_SYMBOL_GPL(event_storage);
-
 LIST_HEAD(ftrace_events);
 static LIST_HEAD(ftrace_common_fields);
 
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 7c3e3e7..ee0a509 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -95,15 +95,12 @@ static void __always_unused ____ftrace_check_##name(void)		\
 #undef __array
 #define __array(type, item, len)					\
 	do {								\
+		char *type_str = #type"["__stringify(len)"]";		\
 		BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);			\
-		mutex_lock(&event_storage_mutex);			\
-		snprintf(event_storage, sizeof(event_storage),		\
-			 "%s[%d]", #type, len);				\
-		ret = trace_define_field(event_call, event_storage, #item, \
+		ret = trace_define_field(event_call, type_str, #item,	\
 				 offsetof(typeof(field), item),		\
 				 sizeof(field.item),			\
 				 is_signed_type(type), filter_type);	\
-		mutex_unlock(&event_storage_mutex);			\
 		if (ret)						\
 			return ret;					\
 	} while (0);
