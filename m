Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaCGPMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:12:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:56520 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752378AbaCGPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:12:04 -0500
Message-Id: <20140307151201.741087016@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 07 Mar 2014 10:09:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [for-next][PATCH 05/20] tracing: Move raw output code from macro to standalone function
References: <20140307150920.881849073@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0005-tracing-Move-raw-output-code-from-macro-to-standalon.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The code for trace events to format the raw recorded event data
into human readable format in the 'trace' file is repeated for every
event in the system. When you have over 500 events, this can add up
quite a bit.

By making helper functions in the core kernel to do the work
instead, we can shrink the size of the kernel down a bit.

With a kernel configured with 502 events, the change in size was:

   text    data     bss     dec     hex filename
12991007        1913568 9785344 24689919        178bcff /tmp/vmlinux.orig
12990946        1913568 9785344 24689858        178bcc2 /tmp/vmlinux.patched

Note, this version does not save as much as the version of this patch
I had a few years ago. That is because in the mean time, commit
f71130de5c7f ("tracing: Add a helper function for event print functions")
did a lot of the work my original patch did. But this change helps
slightly, and is part of a larger clean up to reduce the size much further.

Link: http://lkml.kernel.org/r/20120810034707.378538034@goodmis.org

Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |  5 +++++
 include/trace/ftrace.h       | 10 +---------
 kernel/trace/trace_output.c  | 31 +++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4e4cc28..a91ab93 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -163,6 +163,8 @@ void trace_current_buffer_discard_commit(struct ring_buffer *buffer,
 
 void tracing_record_cmdline(struct task_struct *tsk);
 
+int ftrace_output_call(struct trace_iterator *iter, char *name, char *fmt, ...);
+
 struct event_filter;
 
 enum trace_reg {
@@ -197,6 +199,9 @@ struct ftrace_event_class {
 extern int ftrace_event_reg(struct ftrace_event_call *event,
 			    enum trace_reg type, void *data);
 
+int ftrace_output_event(struct trace_iterator *iter, struct ftrace_event_call *event,
+			char *fmt, ...);
+
 enum {
 	TRACE_EVENT_FL_FILTERED_BIT,
 	TRACE_EVENT_FL_CAP_ANY_BIT,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 1a8b28d..3873d6e 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -265,11 +265,9 @@ static notrace enum print_line_t					\
 ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 			 struct trace_event *event)			\
 {									\
-	struct trace_seq *s = &iter->seq;				\
 	struct ftrace_raw_##template *field;				\
 	struct trace_entry *entry;					\
 	struct trace_seq *p = &iter->tmp_seq;				\
-	int ret;							\
 									\
 	entry = iter->ent;						\
 									\
@@ -281,13 +279,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 	field = (typeof(field))entry;					\
 									\
 	trace_seq_init(p);						\
-	ret = trace_seq_printf(s, "%s: ", #call);			\
-	if (ret)							\
-		ret = trace_seq_printf(s, print);			\
-	if (!ret)							\
-		return TRACE_TYPE_PARTIAL_LINE;				\
-									\
-	return TRACE_TYPE_HANDLED;					\
+	return ftrace_output_call(iter, #call, print);			\
 }									\
 static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
 	.trace			= ftrace_raw_output_##call,		\
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index ed32284..ca0e79e2 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -439,6 +439,37 @@ int ftrace_raw_output_prep(struct trace_iterator *iter,
 }
 EXPORT_SYMBOL(ftrace_raw_output_prep);
 
+static int ftrace_output_raw(struct trace_iterator *iter, char *name,
+			     char *fmt, va_list ap)
+{
+	struct trace_seq *s = &iter->seq;
+	int ret;
+
+	ret = trace_seq_printf(s, "%s: ", name);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	ret = trace_seq_vprintf(s, fmt, ap);
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
+int ftrace_output_call(struct trace_iterator *iter, char *name, char *fmt, ...)
+{
+	va_list ap;
+	int ret;
+
+	va_start(ap, fmt);
+	ret = ftrace_output_raw(iter, name, fmt, ap);
+	va_end(ap);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ftrace_output_call);
+
 #ifdef CONFIG_KRETPROBES
 static inline const char *kretprobed(const char *name)
 {
-- 
1.8.5.3


