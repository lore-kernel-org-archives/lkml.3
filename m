Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034AbaGCQMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:12:33 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:3745 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759146AbaGCQM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:26 -0400
Message-Id: <20140703161224.224000289@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 05/21] ftrace: Add trampolines to enabled_functions debug file
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0005-ftrace-Add-trampolines-to-enabled_functions-debug-fi.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The enabled_functions is used to help debug the dynamic function tracing.
Adding what trampolines are attached to files is useful for debugging.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5d15eb8146a7..3ded796e10e0 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2903,10 +2903,22 @@ static int t_show(struct seq_file *m, void *v)
 		return 0;
 
 	seq_printf(m, "%ps", (void *)rec->ip);
-	if (iter->flags & FTRACE_ITER_ENABLED)
+	if (iter->flags & FTRACE_ITER_ENABLED) {
 		seq_printf(m, " (%ld)%s",
 			   ftrace_rec_count(rec),
-			   rec->flags & FTRACE_FL_REGS ? " R" : "");
+			   rec->flags & FTRACE_FL_REGS ? " R" : "  ");
+		if (rec->flags & FTRACE_FL_TRAMP_EN) {
+			struct ftrace_ops *ops;
+
+			ops = ftrace_find_tramp_ops_curr(rec);
+			if (ops && ops->trampoline)
+				seq_printf(m, "\ttramp: %pS",
+					   (void *)ops->trampoline);
+			else
+				seq_printf(m, "\ttramp: ERROR!");
+		}
+	}	
+
 	seq_printf(m, "\n");
 
 	return 0;
-- 
2.0.0


