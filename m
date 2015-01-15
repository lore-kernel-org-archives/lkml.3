Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbbAOQvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:51:32 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:34958 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbbAOQva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:51:30 -0500
From: Javi Merino <javi.merino@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Martin <Dave.Martin@arm.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Javi Merino <javi.merino@arm.com>
Subject: [RESEND PATCH v2 1/2] tracing: Add array printing helpers
Date: Thu, 15 Jan 2015 16:50:58 +0000
Message-Id: <1421340659-18063-1-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Martin <Dave.Martin@arm.com>

If a trace event contains an array, there is currently no standard
way to format this for text output.  Drivers are currently hacking
around this by a) local hacks that use the trace_seq functionailty
directly, or b) just not printing that information.  For fixed size
arrays, formatting of the elements can be open-coded, but this gets
cumbersome for arrays of non-trivial size.

These approaches result in non-standard content of the event format
description delivered to userspace, so userland tools needs to be
taught to understand and parse each array printing method
individually.

This patch implements common __print_<type>_array() helpers that
tracepoint implementations can use instead of reinventing them.  A
simple C-style syntax is used to delimit the array and its elements
{like,this}.

So that the helpers can be used with large static arrays as well as
dynamic arrays, they take a pointer and element count: they can be
used with __get_dynamic_array() for use with dynamic arrays.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: Javi Merino <javi.merino@arm.com>
---
Changes since v1[0]

- Replaced the DEFINE_PRINT_ARRAY macros with a single
  ftrace_print_array_seq() function.

[0] http://thread.gmane.org/gmane.linux.kernel/1845418/focus=54110

 include/linux/ftrace_event.h |  4 ++++
 include/trace/ftrace.h       |  5 +++++
 kernel/trace/trace_output.c  | 42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 0bebb5c348b8..5aa4a9269547 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -44,6 +44,10 @@ const char *ftrace_print_bitmask_seq(struct trace_seq *p, void *bitmask_ptr,
 const char *ftrace_print_hex_seq(struct trace_seq *p,
 				 const unsigned char *buf, int len);
 
+const char *ftrace_print_array_seq(struct trace_seq *p,
+				   const void *buf, int buf_len,
+				   size_t el_size);
+
 struct trace_iterator;
 struct trace_event;
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 139b5067345b..da911289a8dd 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -263,6 +263,10 @@
 #undef __print_hex
 #define __print_hex(buf, buf_len) ftrace_print_hex_seq(p, buf, buf_len)
 
+#undef __print_array
+#define __print_array(array, count, el_size)			\
+	ftrace_print_array_seq(p, array, count, el_size)
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static notrace enum print_line_t					\
@@ -674,6 +678,7 @@ static inline void ftrace_test_probe_##call(void)			\
 #undef __get_dynamic_array_len
 #undef __get_str
 #undef __get_bitmask
+#undef __print_array
 
 #undef TP_printk
 #define TP_printk(fmt, args...) "\"" fmt "\", "  __stringify(args)
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index b77b9a697619..6cee7c36a669 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -177,6 +177,48 @@ ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
 }
 EXPORT_SYMBOL(ftrace_print_hex_seq);
 
+const char *
+ftrace_print_array_seq(struct trace_seq *p, const void *buf, int buf_len,
+		       size_t el_size)
+{
+	const char *ret = trace_seq_buffer_ptr(p);
+	const char *prefix = "";
+	void *ptr = (void *)buf;
+
+	trace_seq_putc(p, '{');
+
+	while (ptr < buf + buf_len) {
+		switch (el_size) {
+		case 8:
+			trace_seq_printf(p, "%s0x%x", prefix,
+					 *(u8 *)ptr);
+			break;
+		case 16:
+			trace_seq_printf(p, "%s0x%x", prefix,
+					 *(u16 *)ptr);
+			break;
+		case 32:
+			trace_seq_printf(p, "%s0x%x", prefix,
+					 *(u32 *)ptr);
+			break;
+		case 64:
+			trace_seq_printf(p, "%s0x%llx", prefix,
+					 *(u64 *)ptr);
+			break;
+		default:
+			BUG();
+		}
+		prefix = ",";
+		ptr += el_size / 8;
+	}
+
+	trace_seq_putc(p, '}');
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL(ftrace_print_array_seq);
+
 int ftrace_raw_output_prep(struct trace_iterator *iter,
 			   struct trace_event *trace_event)
 {
-- 
1.9.1

