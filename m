Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbaCGPRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:17:39 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:48460 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752338AbaCGPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:12:04 -0500
Message-Id: <20140307151202.082805053@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 07 Mar 2014 10:09:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 07/20] tracing: Use helper functions in event assignment to shrink macro
 size
References: <20140307150920.881849073@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0007-tracing-Use-helper-functions-in-event-assignment-to-.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The functions that assign the contents for the ftrace events are
defined by the TRACE_EVENT() macros. Each event has its own unique
way to assign data to its buffer. When you have over 500 events,
that means there's 500 functions assigning data uniquely for each
event (not really that many, as DECLARE_EVENT_CLASS() and multiple
DEFINE_EVENT()s will only need a single function).

By making helper functions in the core kernel to do some of the work
instead, we can shrink the size of the kernel down a bit.

With a kernel configured with 502 events, the change in size was:

   text    data     bss     dec     hex filename
12987390        1913504 9785344 24686238        178ae9e /tmp/vmlinux
12959102        1913504 9785344 24657950        178401e /tmp/vmlinux.patched

That's a total of 28288 bytes, which comes down to 56 bytes per event.

Link: http://lkml.kernel.org/r/20120810034708.370808175@goodmis.org

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h | 15 +++++++++++++++
 include/trace/ftrace.h       | 22 ++++++----------------
 kernel/trace/trace_events.c  | 30 ++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 16 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index ffe642e..9d3fe06 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -206,6 +206,21 @@ int ftrace_event_define_field(struct ftrace_event_call *call,
 			      char *type, int len, char *item, int offset,
 			      int field_size, int sign, int filter);
 
+struct ftrace_event_buffer {
+	struct ring_buffer		*buffer;
+	struct ring_buffer_event	*event;
+	struct ftrace_event_file	*ftrace_file;
+	void				*entry;
+	unsigned long			flags;
+	int				pc;
+};
+
+void *ftrace_event_buffer_reserve(struct ftrace_event_buffer *fbuffer,
+				  struct ftrace_event_file *ftrace_file,
+				  unsigned long len);
+
+void ftrace_event_buffer_commit(struct ftrace_event_buffer *fbuffer);
+
 enum {
 	TRACE_EVENT_FL_FILTERED_BIT,
 	TRACE_EVENT_FL_CAP_ANY_BIT,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 54928fa..1cc2265 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -532,37 +532,27 @@ static notrace void							\
 ftrace_raw_event_##call(void *__data, proto)				\
 {									\
 	struct ftrace_event_file *ftrace_file = __data;			\
-	struct ftrace_event_call *event_call = ftrace_file->event_call;	\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
-	struct ring_buffer_event *event;				\
+	struct ftrace_event_buffer fbuffer;				\
 	struct ftrace_raw_##call *entry;				\
-	struct ring_buffer *buffer;					\
-	unsigned long irq_flags;					\
 	int __data_size;						\
-	int pc;								\
 									\
 	if (ftrace_trigger_soft_disabled(ftrace_file))			\
 		return;							\
 									\
-	local_save_flags(irq_flags);					\
-	pc = preempt_count();						\
-									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 									\
-	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,	\
-				 event_call->event.type,		\
-				 sizeof(*entry) + __data_size,		\
-				 irq_flags, pc);			\
-	if (!event)							\
+	entry = ftrace_event_buffer_reserve(&fbuffer, ftrace_file,	\
+				 sizeof(*entry) + __data_size);		\
+									\
+	if (!entry)							\
 		return;							\
-	entry	= ring_buffer_event_data(event);			\
 									\
 	tstruct								\
 									\
 	{ assign; }							\
 									\
-	event_trigger_unlock_commit(ftrace_file, buffer, event, entry, \
-				    irq_flags, pc);		       \
+	ftrace_event_buffer_commit(&fbuffer);				\
 }
 /*
  * The ftrace_test_probe is compiled out, it is only here as a build time check
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 22826c7..b8f73b3 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -188,6 +188,36 @@ int trace_event_raw_init(struct ftrace_event_call *call)
 }
 EXPORT_SYMBOL_GPL(trace_event_raw_init);
 
+void *ftrace_event_buffer_reserve(struct ftrace_event_buffer *fbuffer,
+				  struct ftrace_event_file *ftrace_file,
+				  unsigned long len)
+{
+	struct ftrace_event_call *event_call = ftrace_file->event_call;
+
+	local_save_flags(fbuffer->flags);
+	fbuffer->pc = preempt_count();
+	fbuffer->ftrace_file = ftrace_file;
+
+	fbuffer->event =
+		trace_event_buffer_lock_reserve(&fbuffer->buffer, ftrace_file,
+						event_call->event.type, len,
+						fbuffer->flags, fbuffer->pc);
+	if (!fbuffer->event)
+		return NULL;
+
+	fbuffer->entry = ring_buffer_event_data(fbuffer->event);
+	return fbuffer->entry;
+}
+EXPORT_SYMBOL_GPL(ftrace_event_buffer_reserve);
+
+void ftrace_event_buffer_commit(struct ftrace_event_buffer *fbuffer)
+{
+	event_trigger_unlock_commit(fbuffer->ftrace_file, fbuffer->buffer,
+				    fbuffer->event, fbuffer->entry,
+				    fbuffer->flags, fbuffer->pc);
+}
+EXPORT_SYMBOL_GPL(ftrace_event_buffer_commit);
+
 int ftrace_event_reg(struct ftrace_event_call *call,
 		     enum trace_reg type, void *data)
 {
-- 
1.8.5.3


