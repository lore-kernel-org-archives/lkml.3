Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934995AbaKNBOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:14:19 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:54013 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934681AbaKNBOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:14:12 -0500
Message-Id: <20141114011410.814170311@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 13 Nov 2014 20:12:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [RFC][PATCH 05/23 v4] tracing: Have branch tracer use trace_handle_return() helper function
References: <20141114011244.256115061@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-tracing-Have-branch-tracer-use-trace_handle_return-h.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The branch tracer should not be checking the trace_seq_printf() return value
as that will soon be void. There's a new trace_handle_return() helper function
that will return TRACE_TYPE_PARTIAL_LINE if the trace_seq overflowed
and TRACE_TYPE_HANDLED otherwise.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_branch.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 697fb9bac8f0..42c85036fc3f 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -151,14 +151,13 @@ static enum print_line_t trace_branch_print(struct trace_iterator *iter,
 
 	trace_assign_type(field, iter->ent);
 
-	if (trace_seq_printf(&iter->seq, "[%s] %s:%s:%d\n",
-			     field->correct ? "  ok  " : " MISS ",
-			     field->func,
-			     field->file,
-			     field->line))
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return TRACE_TYPE_HANDLED;
+	trace_seq_printf(&iter->seq, "[%s] %s:%s:%d\n",
+			 field->correct ? "  ok  " : " MISS ",
+			 field->func,
+			 field->file,
+			 field->line);
+
+	return trace_handle_return(&iter->seq);
 }
 
 static void branch_print_header(struct seq_file *s)
-- 
2.1.1


