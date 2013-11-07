Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab3KGEBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:01:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:38742 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753369Ab3KGEAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:00:54 -0500
Message-Id: <20131107040050.696807040@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 23:00:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [for-next][PATCH 5/5] tracing: Do not use signed enums with unsigned long long in fgragh
 output
References: <20131107040002.605895766@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Do-not-use-signed-enums-with-unsigned-long-l.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The duration field of print_graph_duration() can also be used
to do the space filling by passing an enum in it:

  DURATION_FILL_FULL
  DURATION_FILL_START
  DURATION_FILL_END

The problem is that these are enums and defined as negative,
but the duration field is unsigned long long. Most archs are
fine with this but blackfin fails to compile because of it:

kernel/built-in.o: In function `print_graph_duration':
kernel/trace/trace_functions_graph.c:782: undefined reference to `__ucmpdi2'

Overloading a unsigned long long with an signed enum is just
bad in principle. We can accomplish the same thing by using
part of the flags field instead.

Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h                 |  2 ++
 kernel/trace/trace_functions_graph.c | 22 +++++++++++-----------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4388e16..11a04d6 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -712,6 +712,8 @@ extern unsigned long trace_flags;
 #define TRACE_GRAPH_PRINT_PROC          0x8
 #define TRACE_GRAPH_PRINT_DURATION      0x10
 #define TRACE_GRAPH_PRINT_ABS_TIME      0x20
+#define TRACE_GRAPH_PRINT_FILL_SHIFT	28
+#define TRACE_GRAPH_PRINT_FILL_MASK	(0x3 << TRACE_GRAPH_PRINT_FILL_SHIFT)
 
 extern enum print_line_t
 print_graph_function_flags(struct trace_iterator *iter, u32 flags);
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 80387d1..0b99120 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -82,9 +82,9 @@ static struct trace_array *graph_array;
  * to fill in space into DURATION column.
  */
 enum {
-	DURATION_FILL_FULL  = -1,
-	DURATION_FILL_START = -2,
-	DURATION_FILL_END   = -3,
+	FLAGS_FILL_FULL  = 1 << TRACE_GRAPH_PRINT_FILL_SHIFT,
+	FLAGS_FILL_START = 2 << TRACE_GRAPH_PRINT_FILL_SHIFT,
+	FLAGS_FILL_END   = 3 << TRACE_GRAPH_PRINT_FILL_SHIFT,
 };
 
 static enum print_line_t
@@ -702,7 +702,7 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 	}
 
 	/* No overhead */
-	ret = print_graph_duration(DURATION_FILL_START, s, flags);
+	ret = print_graph_duration(0, s, flags | FLAGS_FILL_START);
 	if (ret != TRACE_TYPE_HANDLED)
 		return ret;
 
@@ -714,7 +714,7 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	ret = print_graph_duration(DURATION_FILL_END, s, flags);
+	ret = print_graph_duration(0, s, flags | FLAGS_FILL_END);
 	if (ret != TRACE_TYPE_HANDLED)
 		return ret;
 
@@ -779,14 +779,14 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
 			return TRACE_TYPE_HANDLED;
 
 	/* No real adata, just filling the column with spaces */
-	switch (duration) {
-	case DURATION_FILL_FULL:
+	switch (flags & TRACE_GRAPH_PRINT_FILL_MASK) {
+	case FLAGS_FILL_FULL:
 		ret = trace_seq_puts(s, "              |  ");
 		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
-	case DURATION_FILL_START:
+	case FLAGS_FILL_START:
 		ret = trace_seq_puts(s, "  ");
 		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
-	case DURATION_FILL_END:
+	case FLAGS_FILL_END:
 		ret = trace_seq_puts(s, " |");
 		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
 	}
@@ -902,7 +902,7 @@ print_graph_entry_nested(struct trace_iterator *iter,
 	}
 
 	/* No time */
-	ret = print_graph_duration(DURATION_FILL_FULL, s, flags);
+	ret = print_graph_duration(0, s, flags | FLAGS_FILL_FULL);
 	if (ret != TRACE_TYPE_HANDLED)
 		return ret;
 
@@ -1222,7 +1222,7 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* No time */
-	ret = print_graph_duration(DURATION_FILL_FULL, s, flags);
+	ret = print_graph_duration(0, s, flags | FLAGS_FILL_FULL);
 	if (ret != TRACE_TYPE_HANDLED)
 		return ret;
 
-- 
1.8.4.rc3


