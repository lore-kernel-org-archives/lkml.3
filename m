Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaCAFcg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 00:32:36 -0500
Received: from mail-oa0-f74.google.com ([209.85.219.74]:34376 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaCAFcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 00:32:31 -0500
From: Filipe Brandenburger <filbranden@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizefan@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH 3/3] tracing: introduce a trace_data_offset struct to store array size
Date: Fri, 28 Feb 2014 21:32:18 -0800
Message-Id: <1393651938-16418-4-git-send-email-filbranden@google.com>
X-Mailer: git-send-email 1.9.0.279.gdc9e3eb
In-Reply-To: <1393651938-16418-1-git-send-email-filbranden@google.com>
References: <1393651938-16418-1-git-send-email-filbranden@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7d536cb3f stores the length of the array in the high 16 bits of
the offset field. Using a struct with two separate 16 bit fields makes
it cleaner.

Tested: Boot kernel with this change, set a 'filename ~ "/usr/bin/pst*"'
regex filter on events/sched/sched_process_exec/filter, enabled tracing,
checked that calling pstree would log the trace event as expected.

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
---
 include/linux/ftrace_event.h       |  5 +++++
 include/trace/ftrace.h             | 28 ++++++++++++++--------------
 kernel/trace/trace_events_filter.c | 13 ++++++++++---
 3 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4e4cc28..67e4122 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -123,6 +123,11 @@ struct trace_event {
 	struct trace_event_functions	*funcs;
 };
 
+struct trace_array_offset {
+	u16			offset;
+	u16			length;
+};
+
 extern int register_ftrace_event(struct trace_event *event);
 extern int unregister_ftrace_event(struct trace_event *event);
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 86a056a..eac4d0a 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -48,7 +48,8 @@
 #define __array(type, item, len)	type	item[len];
 
 #undef __dynamic_array
-#define __dynamic_array(type, item, len) u32 __data_loc_##item;
+#define __dynamic_array(type, item, len)				\
+		struct trace_array_offset __data_loc_##item;
 
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
@@ -103,14 +104,14 @@
  * Include the following:
  *
  * struct ftrace_data_offsets_<call> {
- *	u32				<item1>;
- *	u32				<item2>;
+ *	struct trace_array_offset	<item1>;
+ *	struct trace_array_offset	<item2>;
  *	[...]
  * };
  *
- * The __dynamic_array() macro will create each u32 <item>, this is
- * to keep the offset of each array from the beginning of the event.
- * The size of an array is also encoded, in the higher 16 bits of <item>.
+ * The __dynamic_array() macro will create each trace_array_offset <item>, this
+ * is to keep the offset and length of each array from the beginning of the
+ * event.
  */
 
 #undef __field
@@ -123,7 +124,8 @@
 #define __array(type, item, len)
 
 #undef __dynamic_array
-#define __dynamic_array(type, item, len)	u32 item;
+#define __dynamic_array(type, item, len)				\
+		struct trace_array_offset item;
 
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
@@ -195,7 +197,7 @@
 
 #undef __get_dynamic_array
 #define __get_dynamic_array(field)	\
-		((void *)__entry + (__entry->__data_loc_##field & 0xffff))
+		((void *)__entry + __entry->__data_loc_##field.offset)
 
 #undef __get_str
 #define __get_str(field) (char *)__get_dynamic_array(field)
@@ -373,11 +375,10 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 
 #undef __dynamic_array
 #define __dynamic_array(type, item, len)				\
-	__item_length = (len) * sizeof(type);				\
-	__data_offsets->item = __data_size +				\
+	__data_offsets->item.offset = __data_size +			\
 			       offsetof(typeof(*entry), __data);	\
-	__data_offsets->item |= __item_length << 16;			\
-	__data_size += __item_length;
+	__data_offsets->item.length = (len) * sizeof(type);		\
+	__data_size += __data_offsets->item.length;
 
 #undef __string
 #define __string(item, src) __dynamic_array(char, item,			\
@@ -389,7 +390,6 @@ static inline notrace int ftrace_get_offsets_##call(			\
 	struct ftrace_data_offsets_##call *__data_offsets, proto)       \
 {									\
 	int __data_size = 0;						\
-	int __maybe_unused __item_length;				\
 	struct ftrace_raw_##call __maybe_unused *entry;			\
 									\
 	tstruct;							\
@@ -658,7 +658,7 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
 
 #undef __get_dynamic_array
 #define __get_dynamic_array(field)	\
-		((void *)__entry + (__entry->__data_loc_##field & 0xffff))
+		((void *)__entry + __entry->__data_loc_##field.offset)
 
 #undef __get_str
 #define __get_str(field) (char *)__get_dynamic_array(field)
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 8a86319..805fc0d 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -234,12 +234,19 @@ static int filter_pred_pchar(struct filter_pred *pred, void *event)
  */
 static int filter_pred_strloc(struct filter_pred *pred, void *event)
 {
-	u32 str_item = *(u32 *)(event + pred->offset);
-	int str_loc = str_item & 0xffff;
-	int str_len = str_item >> 16;
+	struct trace_array_offset *array_offset =
+		(struct trace_array_offset *)(event + pred->offset);
+	int str_loc = array_offset->offset;
+	int str_len = array_offset->length;
 	char *addr = (char *)(event + str_loc);
 	int cmp, match;
 
+	/*
+	 * As struct trace_array_offset is replacing an u32,
+	 * ensure they have the same size.
+	 */
+	BUILD_BUG_ON(sizeof(struct trace_array_offset) != sizeof(u32));
+
 	cmp = pred->regex.match(addr, &pred->regex, str_len);
 
 	match = cmp ^ pred->not;
-- 
1.9.0.279.gdc9e3eb

