Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbaBFSLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:11:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:36360 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756699AbaBFSLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:11:13 -0500
Message-Id: <20140206181109.227268645@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 06 Feb 2014 12:39:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Li Zefan <lizefan@huawei.com>
Subject: [RFC][PATCH 3/4] tracing: Use helper functions in event assignment to shrink macro
 size
References: <20140206173910.029355947@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Use-helper-functions-in-event-assignment-to-.patch
X-RR-Connecting-IP: 107.14.168.130:25
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
 include/linux/ftrace_event.h | 16 ++++++++++++++++
 include/trace/ftrace.h       | 20 ++++++--------------
 kernel/trace/trace_output.c  | 31 +++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 14 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 014090c..4cc6852 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -205,6 +205,22 @@ int ftrace_event_define_field(struct ftrace_event_call *call,
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
+				  int type, unsigned long len);
+
+void ftrace_event_buffer_commit(struct ftrace_event_buffer *fbuffer,
+				struct ftrace_event_call *event_call);
+
 enum {
 	TRACE_EVENT_FL_FILTERED_BIT,
 	TRACE_EVENT_FL_CAP_ANY_BIT,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index c9c991f..dc883a3 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -520,36 +520,28 @@ ftrace_raw_event_##call(void *__data, proto)				\
 	struct ftrace_event_file *ftrace_file = __data;			\
 	struct ftrace_event_call *event_call = ftrace_file->event_call;	\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
-	struct ring_buffer_event *event;				\
+	struct ftrace_event_buffer fbuffer;				\
 	struct ftrace_raw_##call *entry;				\
-	struct ring_buffer *buffer;					\
-	unsigned long irq_flags;					\
 	int __data_size;						\
-	int pc;								\
 									\
 	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,			\
 		     &ftrace_file->flags))				\
 		return;							\
 									\
-	local_save_flags(irq_flags);					\
-	pc = preempt_count();						\
-									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 									\
-	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,	\
+	entry = ftrace_event_buffer_reserve(&fbuffer, ftrace_file,	\
 				 event_call->event.type,		\
-				 sizeof(*entry) + __data_size,		\
-				 irq_flags, pc);			\
-	if (!event)							\
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
-	if (!filter_check_discard(ftrace_file, entry, buffer, event))	\
-		trace_buffer_unlock_commit(buffer, event, irq_flags, pc); \
+	ftrace_event_buffer_commit(&fbuffer, event_call);		\
 }
 /*
  * The ftrace_test_probe is compiled out, it is only here as a build time check
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index ee8d748..fae6c9b 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -491,6 +491,37 @@ int ftrace_event_define_field(struct ftrace_event_call *call,
 }
 EXPORT_SYMBOL_GPL(ftrace_event_define_field);
 
+void *ftrace_event_buffer_reserve(struct ftrace_event_buffer *fbuffer,
+				  struct ftrace_event_file *ftrace_file,
+				  int type, unsigned long len)
+{
+	local_save_flags(fbuffer->flags);
+	fbuffer->pc = preempt_count();
+	fbuffer->ftrace_file = ftrace_file;
+
+	fbuffer->event =
+		trace_event_buffer_lock_reserve(&fbuffer->buffer, ftrace_file,
+						type, len,
+						fbuffer->flags, fbuffer->pc);
+	if (!fbuffer->event)
+		return NULL;
+
+	fbuffer->entry = ring_buffer_event_data(fbuffer->event);
+	return fbuffer->entry;
+}
+EXPORT_SYMBOL_GPL(ftrace_event_buffer_reserve);
+
+void ftrace_event_buffer_commit(struct ftrace_event_buffer *fbuffer,
+				struct ftrace_event_call *event_call)
+{
+	if (!filter_check_discard(fbuffer->ftrace_file, fbuffer->entry,
+				  fbuffer->buffer, fbuffer->event))
+		trace_buffer_unlock_commit(fbuffer->buffer,
+					   fbuffer->event,
+					   fbuffer->flags, fbuffer->pc);
+}
+EXPORT_SYMBOL_GPL(ftrace_event_buffer_commit);
+
 #ifdef CONFIG_KRETPROBES
 static inline const char *kretprobed(const char *name)
 {
-- 
1.8.4.3


