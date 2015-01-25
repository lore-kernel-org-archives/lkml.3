Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbbAYShG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:37:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927AbbAYSKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.18 123/183] ftrace: Fix updating of filters for shared global_ops filters
Date: Sun, 25 Jan 2015 10:07:25 -0800
Message-Id: <20150125180815.516787231@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 8f86f83709c585742dea5dd7f0d2b79c43f992ec upstream.

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

Link: http://lkml.kernel.org/r/20150114154329.055980438@goodmis.org

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3786,8 +3786,32 @@ ftrace_match_addr(struct ftrace_hash *ha
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


