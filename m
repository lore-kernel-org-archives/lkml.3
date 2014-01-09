Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbaAIXtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:49:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33998 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaAIXtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:49:42 -0500
Date: Thu, 9 Jan 2014 15:49:12 -0800
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-1739f09e33d8f66bf48ddbc3eca615574da6c4f6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20131113152004.459787f9@gandalf.local.home>
References: <20131113152004.459787f9@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] ftrace/x86:
  Load ftrace_ops in parameter not the variable holding it
Git-Commit-ID: 1739f09e33d8f66bf48ddbc3eca615574da6c4f6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 09 Jan 2014 15:49:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1739f09e33d8f66bf48ddbc3eca615574da6c4f6
Gitweb:     http://git.kernel.org/tip/1739f09e33d8f66bf48ddbc3eca615574da6c4f6
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Wed, 13 Nov 2013 15:20:04 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 9 Jan 2014 13:24:29 -0800

ftrace/x86: Load ftrace_ops in parameter not the variable holding it

Function tracing callbacks expect to have the ftrace_ops that registered it
passed to them, not the address of the variable that holds the ftrace_ops
that registered it.

Use a mov instead of a lea to store the ftrace_ops into the parameter
of the function tracing callback.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/20131113152004.459787f9@gandalf.local.home
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org> # v3.8+
---
 arch/x86/kernel/entry_32.S | 4 ++--
 arch/x86/kernel/entry_64.S | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 51e2988..a2a4f46 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1082,7 +1082,7 @@ ENTRY(ftrace_caller)
 	pushl $0	/* Pass NULL as regs pointer */
 	movl 4*4(%esp), %eax
 	movl 0x4(%ebp), %edx
-	leal function_trace_op, %ecx
+	movl function_trace_op, %ecx
 	subl $MCOUNT_INSN_SIZE, %eax
 
 .globl ftrace_call
@@ -1140,7 +1140,7 @@ ENTRY(ftrace_regs_caller)
 	movl 12*4(%esp), %eax	/* Load ip (1st parameter) */
 	subl $MCOUNT_INSN_SIZE, %eax	/* Adjust ip */
 	movl 0x4(%ebp), %edx	/* Load parent ip (2nd parameter) */
-	leal function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
+	movl function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
 	pushl %esp		/* Save pt_regs as 4th parameter */
 
 GLOBAL(ftrace_regs_call)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e21b078..1e96c36 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -88,7 +88,7 @@ END(function_hook)
 	MCOUNT_SAVE_FRAME \skip
 
 	/* Load the ftrace_ops into the 3rd parameter */
-	leaq function_trace_op, %rdx
+	movq function_trace_op(%rip), %rdx
 
 	/* Load ip into the first parameter */
 	movq RIP(%rsp), %rdi
