Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789Ab3IFBtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 21:49:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10577 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab3IFBtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 21:49:16 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=3tjohxJAiiAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6APJjXR-8hQA:10 a=s1CHMtKVOpMdRrh2RDUA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130906014915.280791272@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 05 Sep 2013 21:48:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>
Subject: [for-next][PATCH 2/4] ftrace: Fix a slight race in modifying what function callback gets
 traced
References: <20130906014816.037690469@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Fix-a-slight-race-in-modifying-what-function-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

There's a slight race when going from a list function to a non list
function. That is, when only one callback is registered to the function
tracer, it gets called directly by the mcount trampoline. But if this
function has filters, it may be called by the wrong functions.

As the list ops callback that handles multiple callbacks that are
registered to ftrace, it also handles what functions they call. While
the transaction is taking place, use the list function always, and
after all the updates are finished (only the functions that should be
traced are being traced), then we can update the trampoline to call
the function directly.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a6d098c..03cf44a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1978,12 +1978,27 @@ int __weak ftrace_arch_code_modify_post_process(void)
 
 void ftrace_modify_all_code(int command)
 {
+	int update = command & FTRACE_UPDATE_TRACE_FUNC;
+
+	/*
+	 * If the ftrace_caller calls a ftrace_ops func directly,
+	 * we need to make sure that it only traces functions it
+	 * expects to trace. When doing the switch of functions,
+	 * we need to update to the ftrace_ops_list_func first
+	 * before the transition between old and new calls are set,
+	 * as the ftrace_ops_list_func will check the ops hashes
+	 * to make sure the ops are having the right functions
+	 * traced.
+	 */
+	if (update)
+		ftrace_update_ftrace_func(ftrace_ops_list_func);
+
 	if (command & FTRACE_UPDATE_CALLS)
 		ftrace_replace_code(1);
 	else if (command & FTRACE_DISABLE_CALLS)
 		ftrace_replace_code(0);
 
-	if (command & FTRACE_UPDATE_TRACE_FUNC)
+	if (update && ftrace_trace_function != ftrace_ops_list_func)
 		ftrace_update_ftrace_func(ftrace_trace_function);
 
 	if (command & FTRACE_START_FUNC_RET)
-- 
1.7.10.4


