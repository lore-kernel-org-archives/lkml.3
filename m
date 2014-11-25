Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbaKYMOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:14:37 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:12389 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753284AbaKYMO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:14:29 -0500
Message-Id: <20141125121426.926254854@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 25 Nov 2014 07:14:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Markos Chandras <Markos.Chandras@imgtec.com>
Subject: [for-next][PATCH 5/5] ftrace/x86: Have static function tracing always test for function
 graph
References: <20141125121355.225538266@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-ftrace-x86-Have-static-function-tracing-always-test-.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

New updates to the ftrace generic code had ftrace_stub not always being
called when ftrace is off. This causes the static tracer to always save
and restore functions. But it also showed that when function tracing is
running, the function graph tracer can not. We should always check to see
if function graph tracing is running even if the function tracer is running
too. The function tracer code is not the only one that uses the hook to
function mcount.

Cc: Markos Chandras <Markos.Chandras@imgtec.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/mcount_64.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index 35a793fa4bba..6dc134b8dc70 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -194,6 +194,7 @@ ENTRY(function_hook)
 	cmpq $ftrace_stub, ftrace_trace_function
 	jnz trace
 
+fgraph_trace:
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	cmpq $ftrace_stub, ftrace_graph_return
 	jnz ftrace_graph_caller
@@ -220,7 +221,7 @@ trace:
 
 	MCOUNT_RESTORE_FRAME
 
-	jmp ftrace_stub
+	jmp fgraph_trace
 END(function_hook)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #endif /* CONFIG_FUNCTION_TRACER */
-- 
2.1.1


