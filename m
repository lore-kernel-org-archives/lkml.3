Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbaIKOtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:49:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:41665 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752434AbaIKOtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:49:10 -0400
Message-Id: <20140911144908.056256622@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 11 Sep 2014 10:47:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 3/9] ftrace: Set callback to ftrace_stub when no ops are registered
References: <20140911144744.907770249@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-ftrace-Set-callback-to-ftrace_stub-when-no-ops-are-r.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The clean up that adds the helper function ftrace_ops_get_func()
caused the default function to not change when DYNAMIC_FTRACE was not
set and no ftrace_ops were registered. Although static tracing is
not very useful (not having DYNAMIC_FTRACE set), it is still supported
and we don't want to break it.

Clean up the if statement even more to specifically have the default
function call ftrace_stub when no ftrace_ops are registered. This
fixes the small bug for static tracing as well as makes the code a
bit more understandable.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index dabf734f909c..708aea493d96 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -254,17 +254,24 @@ static void update_ftrace_function(void)
 	ftrace_func_t func;
 
 	/*
+	 * Prepare the ftrace_ops that the arch callback will use.
+	 * If there's only one ftrace_ops registered, the ftrace_ops_list
+	 * will point to the ops we want.
+	 */
+	set_function_trace_op = ftrace_ops_list;
+
+	/* If there's no ftrace_ops registered, just call the stub function */
+	if (ftrace_ops_list == &ftrace_list_end) {
+		func = ftrace_stub;
+
+	/*
 	 * If we are at the end of the list and this ops is
 	 * recursion safe and not dynamic and the arch supports passing ops,
 	 * then have the mcount trampoline call the function directly.
 	 */
-	if (ftrace_ops_list == &ftrace_list_end ||
-	    (ftrace_ops_list->next == &ftrace_list_end)) {
-
-		/* Set the ftrace_ops that the arch callback uses */
-		set_function_trace_op = ftrace_ops_list;
-
+	} else if (ftrace_ops_list->next == &ftrace_list_end) {
 		func = ftrace_ops_get_func(ftrace_ops_list);
+
 	} else {
 		/* Just use the default ftrace_ops */
 		set_function_trace_op = &ftrace_list_end;
-- 
2.0.1


