Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaCGPNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:13:24 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:49596 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753186AbaCGPMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:12:08 -0500
Message-Id: <20140307151204.025107334@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 07 Mar 2014 10:09:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>
Subject: [for-next][PATCH 19/20] ftrace: Warn on error when modifying ftrace function
References: <20140307150920.881849073@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0019-ftrace-Warn-on-error-when-modifying-ftrace-function.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petr Mladek <pmladek@suse.cz>

We should print some warning and kill ftrace functionality when the ftrace
function is not set correctly. Otherwise, ftrace might do crazy things without
an explanation. The error value has been ignored so far.

Note that an error that happens during updating all the traced calls is handled
in ftrace_replace_code(). We print more details about the particular
failing address via ftrace_bug() there.

Link: http://lkml.kernel.org/r/1393258342-29978-3-git-send-email-pmladek@suse.cz

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5bd70e8..0e48ff4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1994,6 +1994,7 @@ int __weak ftrace_arch_code_modify_post_process(void)
 void ftrace_modify_all_code(int command)
 {
 	int update = command & FTRACE_UPDATE_TRACE_FUNC;
+	int err = 0;
 
 	/*
 	 * If the ftrace_caller calls a ftrace_ops func directly,
@@ -2005,8 +2006,11 @@ void ftrace_modify_all_code(int command)
 	 * to make sure the ops are having the right functions
 	 * traced.
 	 */
-	if (update)
-		ftrace_update_ftrace_func(ftrace_ops_list_func);
+	if (update) {
+		err = ftrace_update_ftrace_func(ftrace_ops_list_func);
+		if (FTRACE_WARN_ON(err))
+			return;
+	}
 
 	if (command & FTRACE_UPDATE_CALLS)
 		ftrace_replace_code(1);
@@ -2019,13 +2023,16 @@ void ftrace_modify_all_code(int command)
 		/* If irqs are disabled, we are in stop machine */
 		if (!irqs_disabled())
 			smp_call_function(ftrace_sync_ipi, NULL, 1);
-		ftrace_update_ftrace_func(ftrace_trace_function);
+		err = ftrace_update_ftrace_func(ftrace_trace_function);
+		if (FTRACE_WARN_ON(err))
+			return;
 	}
 
 	if (command & FTRACE_START_FUNC_RET)
-		ftrace_enable_ftrace_graph_caller();
+		err = ftrace_enable_ftrace_graph_caller();
 	else if (command & FTRACE_STOP_FUNC_RET)
-		ftrace_disable_ftrace_graph_caller();
+		err = ftrace_disable_ftrace_graph_caller();
+	FTRACE_WARN_ON(err);
 }
 
 static int __ftrace_modify_code(void *data)
-- 
1.8.5.3


