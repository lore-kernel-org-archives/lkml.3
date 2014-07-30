Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbaG3Mji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:39:38 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36653 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780AbaG3MP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 20/94] tracing: Fix graph tracer with stack tracer on other archs
Date: Wed, 30 Jul 2014 14:14:09 +0200
Message-Id: <48b19dc8a5307db7f6115724f9bf3c41acbcc2b8.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/trace/ftrace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a8642bac843e..d2ab10b3a30e 100644
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
2.0.1

