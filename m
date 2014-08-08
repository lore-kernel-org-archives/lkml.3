Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415AbaHHWbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:31:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40163 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506AbaHHUlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 138/259] tracing: Fix graph tracer with stack tracer on other archs
Date: Fri,  8 Aug 2014 13:39:21 -0700
Message-Id: <1407530482-4483-139-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 5f8bf2d263a20b986225ae1ed7d6759dc4b93af9 upstream.

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

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/trace/ftrace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7db0614..bb4ca60 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -331,12 +331,12 @@ static void update_ftrace_function(void)
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
1.9.1

