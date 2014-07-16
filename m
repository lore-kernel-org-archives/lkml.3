Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbaGPD0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:26:41 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:33438 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752988AbaGPD0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:26:38 -0400
Message-Id: <20140716032637.099993761@goodmis.org>
User-Agent: quilt/0.63-1
Date: Tue, 15 Jul 2014 23:24:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/4] tracing: Fix graph tracer with stack tracer on other archs
References: <20140716032455.761976900@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tracing-Fix-graph-tracer-with-stack-tracer-on-other-.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Running my ftrace tests on PowerPC, it failed the test that checks
if function_graph tracer is affected by the stack tracer. It was.
Looking into this, I found that the update_function_graph_func()
must be called even if the trampoline function is not changed.
This is because archs like PowerPC do not support ftrace_ops being
passed by assembly and instead uses a helper function (what the
trampoline function points to). Since this function is not changed
even when multiple ftrace_ops are added to the code, the test that
falls out before calling update_function_graph_func() will miss that
the update must still be done.

Call update_function_graph_function() for all calls to
update_ftrace_function()

Cc: stable@vger.kernel.org # 3.3+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5b372e3ed675..ac9d1dad630b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -265,12 +265,12 @@ static void update_ftrace_function(void)
 		func = ftrace_ops_list_func;
 	}
 
+	update_function_graph_func();
+
 	/* If there's no change, then do nothing more here */
 	if (ftrace_trace_function == func)
 		return;
 
-	update_function_graph_func();
-
 	/*
 	 * If we are using the list function, it doesn't care
 	 * about the function_trace_ops.
-- 
2.0.0


