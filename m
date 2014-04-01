Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbaDALdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:33:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42678 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaDALSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Laurent Chavey <chavey@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 117/144] tracing: Fix array size mismatch in format string
Date: Tue,  1 Apr 2014 12:15:21 +0100
Message-Id: <1396350948-29910-118-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

commit 87291347c49dc40aa339f587b209618201c2e527 upstream.

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
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/ftrace_event.h | 4 ----
 include/trace/ftrace.h       | 7 ++-----
 kernel/trace/trace_events.c  | 6 ------
 kernel/trace/trace_export.c  | 7 ++-----
 4 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 120d57a..b5e3601 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -325,10 +325,6 @@ enum {
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
index ef0a427..27ae288 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -303,15 +303,12 @@ static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
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
index 34b821f..6ccd39e 100644
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
index d21a746..d7d0b50 100644
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
-- 
1.9.1

