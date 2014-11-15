Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbaKOFMH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 00:12:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:48451 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750857AbaKOFGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 00:06:04 -0500
Message-Id: <20141115050601.520764174@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 23:58:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 05/26 v5] tracing: Have branch tracer use trace_handle_return() helper function
References: <20141115045847.712848224@goodmis.org>
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

Reviewed-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_branch.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index a3916f68a1c7..7d6e2afde669 100644
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


