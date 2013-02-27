Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673Ab3B0Rv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:51:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8786 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760296Ab3B0RuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:50:00 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=m615m8OSurgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=naRG-YedzgAA:10 a=20KFwNOVAAAA:8 a=c7H4CLgIfgmQj44wZ6YA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130227174958.355300380@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 27 Feb 2013 12:22:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com
Subject: [for-next][PATCH 4/8] tracing: Pass the ftrace_file to the buffer lock reserve code
References: <20130227172232.707306533@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Pass-the-ftrace_file-to-the-buffer-lock-rese.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Pass the struct ftrace_event_file *ftrace_file to the
trace_event_buffer_lock_reserve() (new function that replaces the
trace_current_buffer_lock_reserver()).

The ftrace_file holds a pointer to the trace_array that is in use.
In the case of multiple buffers with different trace_arrays, this
allows different events to be recorded into different buffers.

Also fixed some of the stale comments in include/trace/ftrace.h

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    7 +++++++
 include/trace/ftrace.h       |    9 +++++----
 kernel/trace/trace.c         |   12 ++++++++++++
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index c7191d4..fd28c17 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -128,6 +128,13 @@ enum print_line_t {
 void tracing_generic_entry_update(struct trace_entry *entry,
 				  unsigned long flags,
 				  int pc);
+struct ftrace_event_file;
+
+struct ring_buffer_event *
+trace_event_buffer_lock_reserve(struct ring_buffer **current_buffer,
+				struct ftrace_event_file *ftrace_file,
+				int type, unsigned long len,
+				unsigned long flags, int pc);
 struct ring_buffer_event *
 trace_current_buffer_lock_reserve(struct ring_buffer **current_buffer,
 				  int type, unsigned long len,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 191d966..e5d140a 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -414,7 +414,8 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *
  * static void ftrace_raw_event_<call>(void *__data, proto)
  * {
- *	struct ftrace_event_call *event_call = __data;
+ *	struct ftrace_event_file *ftrace_file = __data;
+ *	struct ftrace_event_call *event_call = ftrace_file->event_call;
  *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
  *	struct ring_buffer_event *event;
  *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
@@ -428,7 +429,7 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *
  *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
  *
- *	event = trace_current_buffer_lock_reserve(&buffer,
+ *	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
  *				  event_<call>->event.type,
  *				  sizeof(*entry) + __data_size,
  *				  irq_flags, pc);
@@ -440,7 +441,7 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *			   __array macros.
  *
  *	if (!filter_current_check_discard(buffer, event_call, entry, event))
- *		trace_current_buffer_unlock_commit(buffer,
+ *		trace_nowake_buffer_unlock_commit(buffer,
  *						   event, irq_flags, pc);
  * }
  *
@@ -533,7 +534,7 @@ ftrace_raw_event_##call(void *__data, proto)				\
 									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 									\
-	event = trace_current_buffer_lock_reserve(&buffer,		\
+	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,	\
 				 event_call->event.type,		\
 				 sizeof(*entry) + __data_size,		\
 				 irq_flags, pc);			\
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 13c5809..3c18fd0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1293,6 +1293,18 @@ void trace_buffer_unlock_commit(struct ring_buffer *buffer,
 EXPORT_SYMBOL_GPL(trace_buffer_unlock_commit);
 
 struct ring_buffer_event *
+trace_event_buffer_lock_reserve(struct ring_buffer **current_rb,
+			  struct ftrace_event_file *ftrace_file,
+			  int type, unsigned long len,
+			  unsigned long flags, int pc)
+{
+	*current_rb = ftrace_file->tr->buffer;
+	return trace_buffer_lock_reserve(*current_rb,
+					 type, len, flags, pc);
+}
+EXPORT_SYMBOL_GPL(trace_event_buffer_lock_reserve);
+
+struct ring_buffer_event *
 trace_current_buffer_lock_reserve(struct ring_buffer **current_rb,
 				  int type, unsigned long len,
 				  unsigned long flags, int pc)
-- 
1.7.10.4


