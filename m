Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaCUTb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 15:31:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:54179 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750745AbaCUTbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 15:31:53 -0400
Date: Fri, 21 Mar 2014 15:31:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [for-next][PATCH] Revert "tracing: Move event storage for array
 from macro to standalone function"
Message-ID: <20140321153149.650a0628@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: bc4c426ee2431d1f717004d3bbaacbd819b544fd


Steven Rostedt (Red Hat) (1):
      Revert "tracing: Move event storage for array from macro to standalone function"

----
 include/linux/ftrace_event.h |  8 ++++++++
 include/trace/ftrace.h       | 12 ++++++++----
 kernel/trace/trace_events.c  |  6 ++++++
 kernel/trace/trace_export.c  | 12 ++++++++----
 kernel/trace/trace_output.c  | 21 ---------------------
 5 files changed, 30 insertions(+), 29 deletions(-)
---------------------------
commit bc4c426ee2431d1f717004d3bbaacbd819b544fd
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Fri Mar 21 08:23:38 2014 -0400

    Revert "tracing: Move event storage for array from macro to standalone function"
    
    I originally wrote commit 35bb4399bd0e to shrink the size of the overhead of
    tracepoints by several kilobytes. Later, I received a patch from Vaibhav
    Nagarnaik that fixed a bug in the same code that this commit touches. Not
    only did it fix a bug, it also removed code and shrunk the size of the
    overhead of trace events even more than this commit did.
    
    Since this commit is scheduled for 3.15 and Vaibhav's patch is already in
    mainline, I need to revert this patch in order to keep it from conflicting
    with Vaibhav's patch. Not to mention, Vaibhav's patch makes this patch
    obsolete.
    
    Link: http://lkml.kernel.org/r/20140320225637.0226041b@gandalf.local.home
    
    Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 9d3fe06..cdc9759 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -221,6 +221,10 @@ void *ftrace_event_buffer_reserve(struct ftrace_event_buffer *fbuffer,
 
 void ftrace_event_buffer_commit(struct ftrace_event_buffer *fbuffer);
 
+int ftrace_event_define_field(struct ftrace_event_call *call,
+			      char *type, int len, char *item, int offset,
+			      int field_size, int sign, int filter);
+
 enum {
 	TRACE_EVENT_FL_FILTERED_BIT,
 	TRACE_EVENT_FL_CAP_ANY_BIT,
@@ -519,6 +523,10 @@ enum {
 	FILTER_TRACE_FN,
 };
 
+#define EVENT_STORAGE_SIZE 128
+extern struct mutex event_storage_mutex;
+extern char event_storage[EVENT_STORAGE_SIZE];
+
 extern int trace_event_raw_init(struct ftrace_event_call *call);
 extern int trace_define_field(struct ftrace_event_call *call, const char *type,
 			      const char *name, int offset, int size,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index e15ae401..d1d9187 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -302,11 +302,15 @@ static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
 #undef __array
 #define __array(type, item, len)					\
 	do {								\
+		mutex_lock(&event_storage_mutex);			\
 		BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);			\
-		ret = ftrace_event_define_field(event_call, #type, len,	\
-				#item, offsetof(typeof(field), item),   \
-				sizeof(field.item),			\
-			 	is_signed_type(type), FILTER_OTHER); \
+		snprintf(event_storage, sizeof(event_storage),		\
+			 "%s[%d]", #type, len);				\
+		ret = trace_define_field(event_call, event_storage, #item, \
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item),			\
+				 is_signed_type(type), FILTER_OTHER);	\
+		mutex_unlock(&event_storage_mutex);			\
 		if (ret)						\
 			return ret;					\
 	} while (0);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index b8f73b3..2f7b8e3 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -27,6 +27,12 @@
 
 DEFINE_MUTEX(event_mutex);
 
+DEFINE_MUTEX(event_storage_mutex);
+EXPORT_SYMBOL_GPL(event_storage_mutex);
+
+char event_storage[EVENT_STORAGE_SIZE];
+EXPORT_SYMBOL_GPL(event_storage);
+
 LIST_HEAD(ftrace_events);
 static LIST_HEAD(ftrace_common_fields);
 
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 39c746c..7c3e3e7 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -96,10 +96,14 @@ static void __always_unused ____ftrace_check_##name(void)		\
 #define __array(type, item, len)					\
 	do {								\
 		BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);			\
-		ret = ftrace_event_define_field(event_call, #type, len,	\
-				#item, offsetof(typeof(field), item),   \
-				sizeof(field.item),			\
-			 	is_signed_type(type), filter_type);	\
+		mutex_lock(&event_storage_mutex);			\
+		snprintf(event_storage, sizeof(event_storage),		\
+			 "%s[%d]", #type, len);				\
+		ret = trace_define_field(event_call, event_storage, #item, \
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item),			\
+				 is_signed_type(type), filter_type);	\
+		mutex_unlock(&event_storage_mutex);			\
 		if (ret)						\
 			return ret;					\
 	} while (0);
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index ee8d748..ca0e79e2 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -20,10 +20,6 @@ static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
 
 static int next_event_type = __TRACE_LAST_TYPE + 1;
 
-#define EVENT_STORAGE_SIZE 128
-static DEFINE_MUTEX(event_storage_mutex);
-static char event_storage[EVENT_STORAGE_SIZE];
-
 int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
 	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
@@ -474,23 +470,6 @@ int ftrace_output_call(struct trace_iterator *iter, char *name, char *fmt, ...)
 }
 EXPORT_SYMBOL_GPL(ftrace_output_call);
 
-int ftrace_event_define_field(struct ftrace_event_call *call,
-			      char *type, int len, char *item, int offset,
-			      int field_size, int sign, int filter)
-{
-	int ret;
-
-	mutex_lock(&event_storage_mutex);
-	snprintf(event_storage, sizeof(event_storage),
-		 "%s[%d]", type, len);
-	ret = trace_define_field(call, event_storage, item, offset,
-				 field_size, sign, filter);
-	mutex_unlock(&event_storage_mutex);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(ftrace_event_define_field);
-
 #ifdef CONFIG_KRETPROBES
 static inline const char *kretprobed(const char *name)
 {
