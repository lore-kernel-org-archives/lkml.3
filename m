Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbaKSX1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:27:20 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:23890 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757014AbaKSX1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:27:16 -0500
Message-Id: <20141119232712.566869349@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 19 Nov 2014 18:26:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 18/18] tracing: Fix return value of ftrace_raw_output_prep()
References: <20141119232632.737569526@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0018-tracing-Fix-return-value-of-ftrace_raw_output_prep.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

If the trace_seq of ftrace_raw_output_prep() is full this function
returns TRACE_TYPE_PARTIAL_LINE, otherwise it returns zero.

The problem is that TRACE_TYPE_PARTIAL_LINE happens to be zero!

The thing is, the caller of ftrace_raw_output_prep() expects a
success to be zero. Change that to expect it to be
TRACE_TYPE_HANDLED.

Link: http://lkml.kernel.org/r/20141114112522.GA2988@dhcp128.suse.cz

Reminded-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h      | 2 +-
 kernel/trace/trace_output.c | 5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index f13471b5d27a..139b5067345b 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -277,7 +277,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 	field = (typeof(field))iter->ent;				\
 									\
 	ret = ftrace_raw_output_prep(iter, trace_event);		\
-	if (ret)							\
+	if (ret != TRACE_TYPE_HANDLED)					\
 		return ret;						\
 									\
 	trace_seq_printf(s, print);					\
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 163c11b6b8ff..723818bc83b4 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -196,10 +196,7 @@ int ftrace_raw_output_prep(struct trace_iterator *iter,
 	trace_seq_init(p);
 	trace_seq_printf(s, "%s: ", ftrace_event_name(event));
 
-	if (trace_seq_has_overflowed(s))
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return 0;
+	return trace_handle_return(s);
 }
 EXPORT_SYMBOL(ftrace_raw_output_prep);
 
-- 
2.1.1


