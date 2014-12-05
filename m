Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaLETFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:05:09 -0500
Received: from service87.mimecast.com ([91.220.42.44]:33410 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaLETFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:05:06 -0500
From: "Javi Merino" <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: punit.agrawal@arm.com, broonie@kernel.org,
        Dave Martin <Dave.Martin@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: [RFC PATCH v6 1/9] tracing: Add array printing helpers
Date: Fri,  5 Dec 2014 19:04:12 +0000
Message-Id: <1417806260-9264-2-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
X-OriginalArrivalTime: 05 Dec 2014 19:05:02.0126 (UTC) FILETIME=[5F3ABCE0:01D010BE]
X-MC-Unique: 114120519050500201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sB5J5GRE013829

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
---
 include/linux/ftrace_event.h |  9 ++++++++
 include/trace/ftrace.h       | 17 +++++++++++++++
 kernel/trace/trace_output.c  | 51 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 28672e87e910..415afc53fa51 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -44,6 +44,15 @@ const char *ftrace_print_bitmask_seq(struct trace_seq *p, void *bitmask_ptr,
 const char *ftrace_print_hex_seq(struct trace_seq *p,
 				 const unsigned char *buf, int len);
 
+const char *ftrace_print_u8_array_seq(struct trace_seq *p,
+				      const u8 *buf, int count);
+const char *ftrace_print_u16_array_seq(struct trace_seq *p,
+				       const u16 *buf, int count);
+const char *ftrace_print_u32_array_seq(struct trace_seq *p,
+				       const u32 *buf, int count);
+const char *ftrace_print_u64_array_seq(struct trace_seq *p,
+				       const u64 *buf, int count);
+
 struct trace_iterator;
 struct trace_event;
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 26b4f2e13275..15bc5d417aea 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -263,6 +263,19 @@
 #undef __print_hex
 #define __print_hex(buf, buf_len) ftrace_print_hex_seq(p, buf, buf_len)
 
+#undef __print_u8_array
+#define __print_u8_array(array, count)			\
+	ftrace_print_u8_array_seq(p, array, count)
+#undef __print_u16_array
+#define __print_u16_array(array, count)			\
+	ftrace_print_u16_array_seq(p, array, count)
+#undef __print_u32_array
+#define __print_u32_array(array, count)			\
+	ftrace_print_u32_array_seq(p, array, count)
+#undef __print_u64_array
+#define __print_u64_array(array, count)			\
+	ftrace_print_u64_array_seq(p, array, count)
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static notrace enum print_line_t					\
@@ -676,6 +689,10 @@ static inline void ftrace_test_probe_##call(void)			\
 #undef __get_dynamic_array_len
 #undef __get_str
 #undef __get_bitmask
+#undef __print_u8_array
+#undef __print_u16_array
+#undef __print_u32_array
+#undef __print_u64_array
 
 #undef TP_printk
 #define TP_printk(fmt, args...) "\"" fmt "\", "  __stringify(args)
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index c6977d5a9b12..4a6ee61f30b3 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -186,6 +186,57 @@ ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
 }
 EXPORT_SYMBOL(ftrace_print_hex_seq);
 
+static const char *
+ftrace_print_array_seq(struct trace_seq *p, const void *buf, int buf_len,
+		       bool (*iterator)(struct trace_seq *p, const char *prefix,
+					const void **buf, int *buf_len))
+{
+	const char *ret = trace_seq_buffer_ptr(p);
+	const char *prefix = "";
+
+	trace_seq_putc(p, '{');
+
+	while (iterator(p, prefix, &buf, &buf_len))
+		prefix = ",";
+
+	trace_seq_putc(p, '}');
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
+#define DEFINE_PRINT_ARRAY(type, printk_type, format)			\
+static bool								\
+ftrace_print_array_iterator_##type(struct trace_seq *p, const char *prefix, \
+				   const void **buf, int *buf_len)	\
+{									\
+	const type *__src = *buf;					\
+									\
+	if (*buf_len < sizeof(*__src))					\
+		return false;						\
+									\
+	trace_seq_printf(p, "%s" format, prefix, (printk_type)*__src++); \
+									\
+	*buf = __src;							\
+	*buf_len -= sizeof(*__src);					\
+									\
+	return true;							\
+}									\
+									\
+const char *ftrace_print_##type##_array_seq(				\
+	struct trace_seq *p, const type *buf, int count)		\
+{									\
+	return ftrace_print_array_seq(p, buf, (count) * sizeof(type),	\
+				      ftrace_print_array_iterator_##type); \
+}									\
+									\
+EXPORT_SYMBOL(ftrace_print_##type##_array_seq)
+
+DEFINE_PRINT_ARRAY(u8, unsigned int, "0x%x");
+DEFINE_PRINT_ARRAY(u16, unsigned int, "0x%x");
+DEFINE_PRINT_ARRAY(u32, unsigned int, "0x%x");
+DEFINE_PRINT_ARRAY(u64, unsigned long long, "0x%llx");
+
 int ftrace_raw_output_prep(struct trace_iterator *iter,
 			   struct trace_event *trace_event)
 {
-- 
1.9.1


