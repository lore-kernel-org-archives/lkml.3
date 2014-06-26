Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826AbaFZRBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:01:32 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:56035 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756132AbaFZQ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:58:54 -0400
Message-Id: <20140626165852.312670231@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 26 Jun 2014 12:52:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>,
        Matt Fleming <matt@console-pimps.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [RFA][PATCH 19/27] sh: ftrace: Remove check of obsolete variable function_trace_stop
References: <20140626165221.736847419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0019-sh-ftrace-Remove-check-of-obsolete-variable-function.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Nothing sets function_trace_stop to disable function tracing anymore.
Remove the check for it in the arch code.

[ Please test this on your arch ]

Cc: Matt Fleming <matt@console-pimps.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/sh/Kconfig      |  1 -
 arch/sh/lib/mcount.S | 24 ++----------------------
 2 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 834b67c4db5a..aa2df3eaeb29 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -57,7 +57,6 @@ config SUPERH32
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_FUNCTION_GRAPH_TRACER
diff --git a/arch/sh/lib/mcount.S b/arch/sh/lib/mcount.S
index 52aa2011d753..7a8572f9d58b 100644
--- a/arch/sh/lib/mcount.S
+++ b/arch/sh/lib/mcount.S
@@ -92,13 +92,6 @@ mcount:
 	rts
 	 nop
 #else
-#ifndef CONFIG_DYNAMIC_FTRACE
-	mov.l	.Lfunction_trace_stop, r0
-	mov.l	@r0, r0
-	tst	r0, r0
-	bf	ftrace_stub
-#endif
-
 	MCOUNT_ENTER()
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -174,11 +167,6 @@ ftrace_graph_call:
 
 	.globl ftrace_caller
 ftrace_caller:
-	mov.l	.Lfunction_trace_stop, r0
-	mov.l	@r0, r0
-	tst	r0, r0
-	bf	ftrace_stub
-
 	MCOUNT_ENTER()
 
 	.globl ftrace_call
@@ -196,8 +184,6 @@ ftrace_call:
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 	.align 2
-.Lfunction_trace_stop:
-	.long	function_trace_stop
 
 /*
  * NOTE: From here on the locations of the .Lftrace_stub label and
@@ -217,12 +203,7 @@ ftrace_stub:
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	.globl	ftrace_graph_caller
 ftrace_graph_caller:
-	mov.l	2f, r0
-	mov.l	@r0, r0
-	tst	r0, r0
-	bt	1f
-
-	mov.l	3f, r1
+	mov.l	2f, r1
 	jmp	@r1
 	 nop
 1:
@@ -242,8 +223,7 @@ ftrace_graph_caller:
 	MCOUNT_LEAVE()
 
 	.align 2
-2:	.long	function_trace_stop
-3:	.long	skip_trace
+2:	.long	skip_trace
 .Lprepare_ftrace_return:
 	.long	prepare_ftrace_return
 
-- 
2.0.0


