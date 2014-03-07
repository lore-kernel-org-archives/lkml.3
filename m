Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaCGPQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:16:11 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:56534 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752592AbaCGPMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:12:05 -0500
Message-Id: <20140307151201.881183550@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 07 Mar 2014 10:09:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 06/20] tracing: Move event storage for array from macro to standalone
 function
References: <20140307150920.881849073@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0006-tracing-Move-event-storage-for-array-from-macro-to-s.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The code that shows array fields for events is defined for all events.
This can add up quite a bit when you have over 500 events.

By making helper functions in the core kernel to do the work
instead, we can shrink the size of the kernel down a bit.

With a kernel configured with 502 events, the change in size was:

   text    data     bss     dec     hex filename
12990946        1913568 9785344 24689858        178bcc2 /tmp/vmlinux
12987390        1913504 9785344 24686238        178ae9e /tmp/vmlinux.patched

That's a total of 3556 bytes, which comes down to 7 bytes per event.
Although it's not much, this code is just called at initialization of
the events.

Link: http://lkml.kernel.org/r/20120810034708.084036335@goodmis.org

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |  8 ++++----
 include/trace/ftrace.h       | 12 ++++--------
 kernel/trace/trace_events.c  |  6 ------
 kernel/trace/trace_export.c  | 12 ++++--------
 kernel/trace/trace_output.c  | 21 +++++++++++++++++++++
 5 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index a91ab93..ffe642e 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -202,6 +202,10 @@ extern int ftrace_event_reg(struct ftrace_event_call *event,
 int ftrace_output_event(struct trace_iterator *iter, struct ftrace_event_call *event,
 			char *fmt, ...);
 
+int ftrace_event_define_field(struct ftrace_event_call *call,
+			      char *type, int len, char *item, int offset,
+			      int field_size, int sign, int filter);
+
 enum {
 	TRACE_EVENT_FL_FILTERED_BIT,
 	TRACE_EVENT_FL_CAP_ANY_BIT,
@@ -500,10 +504,6 @@ enum {
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
index 3873d6e..54928fa 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -302,15 +302,11 @@ static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
 #undef __array
 #define __array(type, item, len)					\
 	do {								\
-		mutex_lock(&event_storage_mutex);			\
 		BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);			\
-		snprintf(event_storage, sizeof(event_storage),		\
-			 "%s[%d]", #type, len);				\
-		ret = trace_define_field(event_call, event_storage, #item, \
-				 offsetof(typeof(field), item),		\
-				 sizeof(field.item),			\
-				 is_signed_type(type), FILTER_OTHER);	\
-		mutex_unlock(&event_storage_mutex);			\
+		ret = ftrace_event_define_field(event_call, #type, len,	\
+				#item, offsetof(typeof(field), item),   \
+				sizeof(field.item),			\
+			 	is_signed_type(type), FILTER_OTHER); \
 		if (ret)						\
 			return ret;					\
 	} while (0);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index e71ffd4..22826c7 100644
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
index 7c3e3e7..39c746c 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -96,14 +96,10 @@ static void __always_unused ____ftrace_check_##name(void)		\
 #define __array(type, item, len)					\
 	do {								\
 		BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);			\
-		mutex_lock(&event_storage_mutex);			\
-		snprintf(event_storage, sizeof(event_storage),		\
-			 "%s[%d]", #type, len);				\
-		ret = trace_define_field(event_call, event_storage, #item, \
-				 offsetof(typeof(field), item),		\
-				 sizeof(field.item),			\
-				 is_signed_type(type), filter_type);	\
-		mutex_unlock(&event_storage_mutex);			\
+		ret = ftrace_event_define_field(event_call, #type, len,	\
+				#item, offsetof(typeof(field), item),   \
+				sizeof(field.item),			\
+			 	is_signed_type(type), filter_type);	\
 		if (ret)						\
 			return ret;					\
 	} while (0);
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index ca0e79e2..ee8d748 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -20,6 +20,10 @@ static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
 
 static int next_event_type = __TRACE_LAST_TYPE + 1;
 
+#define EVENT_STORAGE_SIZE 128
+static DEFINE_MUTEX(event_storage_mutex);
+static char event_storage[EVENT_STORAGE_SIZE];
+
 int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
 	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
@@ -470,6 +474,23 @@ int ftrace_output_call(struct trace_iterator *iter, char *name, char *fmt, ...)
 }
 EXPORT_SYMBOL_GPL(ftrace_output_call);
 
+int ftrace_event_define_field(struct ftrace_event_call *call,
+			      char *type, int len, char *item, int offset,
+			      int field_size, int sign, int filter)
+{
+	int ret;
+
+	mutex_lock(&event_storage_mutex);
+	snprintf(event_storage, sizeof(event_storage),
+		 "%s[%d]", type, len);
+	ret = trace_define_field(call, event_storage, item, offset,
+				 field_size, sign, filter);
+	mutex_unlock(&event_storage_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ftrace_event_define_field);
+
 #ifdef CONFIG_KRETPROBES
 static inline const char *kretprobed(const char *name)
 {
-- 
1.8.5.3


