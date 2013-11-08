Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab3KHPGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:06:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:9301 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932221Ab3KHPGx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:06:53 -0500
Date: Fri, 8 Nov 2013 10:06:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] ftrace/x86: Load ftrace_ops in parameter not the variable
 holding it
Message-ID: <20131108100646.07a63692@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Peter,

I found a bug in the ftrace callback code. When there's only one
function registered that supplies its own recursion protection, it gets
the ftrace_ops that it registered passed to it in the 3rd parameter
from assembly (otherwise, it gets it from a helper function).

But the assembly uses 'leaq' instead of 'movq' and instead of passing
the ftrace_ops to the callback, it passes in the address of the pointer
to the current ftrace_ops structure :-p.  Luckily, all users that needed
ftrace_ops so far used the helper function. But I have new code that
requires this to work that is scheduled for 3.14, I would like to get
this fix in for 3.13. As there are no current users of the direct
assembly passing, it's not required for stable.

I didn't know what branch to base this on in tip so I'm sending you the
patch here. You can pull in in directly or if you tell me which branch
to base on, I can send you a pull request. Your choice.

Thanks!

-- Steve


>From 95669fe1c8236af4519937d19545e65da0d29f1d Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Thu, 7 Nov 2013 18:11:58 -0500
Subject: ftrace/x86: Load ftrace_ops in parameter not the variable
 holding it

Function tracing callbacks expect to have the ftrace_ops that registered it
passed to them, not the address of the variable that holds the ftrace_ops
that registered it.

Use a movq instead of a leaq to store the ftrace_ops into the parameter
of the function tracing callback.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b077f4c..d7570c1 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -88,7 +88,7 @@ END(function_hook)
 	MCOUNT_SAVE_FRAME \skip
 
 	/* Load the ftrace_ops into the 3rd parameter */
-	leaq function_trace_op, %rdx
+	movq function_trace_op, %rdx
 
 	/* Load ip into the first parameter */
 	movq RIP(%rsp), %rdi
-- 
1.8.1.4

