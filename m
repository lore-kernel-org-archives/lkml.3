Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbaGLDhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 23:37:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:10390 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754664AbaGLDhr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 23:37:47 -0400
Date: Fri, 11 Jul 2014 23:37:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [for-next][PATCH 04/21] ftrace: Optimize function graph to be
 called directly
Message-ID: <20140711233745.38d8e351@gandalf.local.home>
In-Reply-To: <20140711233610.551c274d@gandalf.local.home>
References: <20140703160503.006976702@goodmis.org>
	<20140703161224.062459692@goodmis.org>
	<53BED155.9040607@nvidia.com>
	<20140711233610.551c274d@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014 23:36:10 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> I'll worked on getting arm to be called directly too. Can you test that
> patch as well? I'll reply to this email with that one.

Here's that patch:

-- Steve

>From ff9ee792640d802415eaedf0e8d41992c898d2a9 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Fri, 11 Jul 2014 23:28:11 -0400
Subject: [PATCH] ARM: ftrace: Allow function graph tracer to have its own
 trampoline

The ftrace infrastructure now allows the function graph tracer
trampoline to be called directly instead of having to first go
through the function tracer trampoline. But in order for this to
work, the function graph tracer must be dependent from the function
tracer trampoline. Currently in ARM, the function graph tracer
does not save registers as it depends on the function tracer
trampoline to do so.

By adding a ftrace_graph_tramp_caller function that saves the regs
then does the function graph tracing work, this can be used as
the trampoline for function graph tracing.

Link: http://lkml.kernel.org/r/53BED155.9040607@nvidia.com

Reported-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/include/asm/ftrace.h  | 5 +++++
 arch/arm/kernel/entry-common.S | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index 39eb16b..6af3929 100644
--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -54,6 +54,11 @@ extern inline void *return_address(unsigned int level)
 
 #define ftrace_return_address(n) return_address(n)
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+extern void ftrace_graph_tramp_caller(void);
+#define FTRACE_GRAPH_TRAMP_ADDR ((unsigned long)ftrace_graph_tramp_caller)
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 #endif /* ifndef __ASSEMBLY__ */
 
 #endif /* _ASM_ARM_FTRACE */
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 7139d4a..0199167 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -314,6 +314,13 @@ ENDPROC(ftrace_caller)
 #endif
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
+ENTRY(ftrace_graph_tramp_caller)
+UNWIND(.fnstart)
+	mcount_enter
+	__ftrace_graph_caller
+UNWIND(.fnend)
+ENDPROC(ftrace_graph_tramp_caller)
+
 ENTRY(ftrace_graph_caller)
 UNWIND(.fnstart)
 	__ftrace_graph_caller
-- 
1.8.1.4


