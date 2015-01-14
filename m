Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbbANPnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:43:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:31300 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751280AbbANPnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:43:33 -0500
Message-Id: <20150114154329.055980438@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 14 Jan 2015 10:39:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, vvs@sw.ru,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86-ml <x86@kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH 1/3] ftrace: Fix updating of filters for shared global_ops filters
References: <20150114153958.931152836@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-ftrace-Fix-updating-of-filters-for-shared-global_ops.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

As the set_ftrace_filter affects both the function tracer as well as the
function graph tracer, the ops that represent each have a shared
ftrace_ops_hash structure. This allows both to be updated when the filter
files are updated.

But if function graph is enabled and the global_ops (function tracing) ops
is not, then it is possible that the filter could be changed without the
update happening for the function graph ops. This will cause the changes
to not take place and may even cause a ftrace_bug to occur as it could mess
with the trampoline accounting.

The solution is to check if the ops uses the shared global_ops filter and
if the ops itself is not enabled, to check if there's another ops that is
enabled and also shares the global_ops filter. In that case, the
modification still needs to be executed.

Cc: stable@vger.kernel.org # 3.17+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 929a733d302e..2b35d0ba578d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4008,8 +4008,32 @@ ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
 static void ftrace_ops_update_code(struct ftrace_ops *ops,
 				   struct ftrace_hash *old_hash)
 {
-	if (ops->flags & FTRACE_OPS_FL_ENABLED && ftrace_enabled)
+	struct ftrace_ops *op;
+
+	if (!ftrace_enabled)
+		return;
+
+	if (ops->flags & FTRACE_OPS_FL_ENABLED) {
 		ftrace_run_modify_code(ops, FTRACE_UPDATE_CALLS, old_hash);
+		return;
+	}
+
+	/*
+	 * If this is the shared global_ops filter, then we need to
+	 * check if there is another ops that shares it, is enabled.
+	 * If so, we still need to run the modify code.
+	 */
+	if (ops->func_hash != &global_ops.local_hash)
+		return;
+
+	do_for_each_ftrace_op(op, ftrace_ops_list) {
+		if (op->func_hash == &global_ops.local_hash &&
+		    op->flags & FTRACE_OPS_FL_ENABLED) {
+			ftrace_run_modify_code(op, FTRACE_UPDATE_CALLS, old_hash);
+			/* Only need to do this once */
+			return;
+		}
+	} while_for_each_ftrace_op(op);
 }
 
 static int
-- 
2.1.4


