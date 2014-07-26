Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaGZTKB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:10:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaGZTDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:03:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.14 13/87] tracing: Fix graph tracer with stack tracer on other archs
Date: Sat, 26 Jul 2014 12:01:47 -0700
Message-Id: <20140726190214.961975660@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


