Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaBXQNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:13:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbaBXQNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:13:09 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 2/3] ftrace: Warn on error when modifying ftrace function
Date: Mon, 24 Feb 2014 17:12:21 +0100
Message-Id: <1393258342-29978-3-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1393258342-29978-1-git-send-email-pmladek@suse.cz>
References: <1393258342-29978-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should print some warning and kill ftrace functionality when the ftrace
function is not set correctly. Otherwise, ftrace might do crazy things without
an explanation. The error value has been ignored so far.

Note that an error that happens during updating all the traced calls is handled
in ftrace_replace_code(). We print more details about the particular
failing address via ftrace_bug() there.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/trace/ftrace.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cd7f76d1eb86..2f139023e789 100644
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
1.8.4

