Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851AbaAaRcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:32:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55218 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675AbaAaRcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:32:46 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 04/14] ftrace/x86: Load ftrace_ops in parameter not the variable holding it
Date: Fri, 31 Jan 2014 09:32:07 -0800
Message-Id: <1391189537-20777-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391189537-20777-1-git-send-email-kamal@canonical.com>
References: <1391189537-20777-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 1739f09e33d8f66bf48ddbc3eca615574da6c4f6 upstream.

Function tracing callbacks expect to have the ftrace_ops that registered it
passed to them, not the address of the variable that holds the ftrace_ops
that registered it.

Use a mov instead of a lea to store the ftrace_ops into the parameter
of the function tracing callback.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/20131113152004.459787f9@gandalf.local.home
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/entry_32.S | 4 ++--
 arch/x86/kernel/entry_64.S | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 6ed91d9..1d7fdbe 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1113,7 +1113,7 @@ ENTRY(ftrace_caller)
 	pushl $0	/* Pass NULL as regs pointer */
 	movl 4*4(%esp), %eax
 	movl 0x4(%ebp), %edx
-	leal function_trace_op, %ecx
+	movl function_trace_op, %ecx
 	subl $MCOUNT_INSN_SIZE, %eax
 
 .globl ftrace_call
@@ -1171,7 +1171,7 @@ ENTRY(ftrace_regs_caller)
 	movl 12*4(%esp), %eax	/* Load ip (1st parameter) */
 	subl $MCOUNT_INSN_SIZE, %eax	/* Adjust ip */
 	movl 0x4(%ebp), %edx	/* Load parent ip (2nd parameter) */
-	leal function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
+	movl function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
 	pushl %esp		/* Save pt_regs as 4th parameter */
 
 GLOBAL(ftrace_regs_call)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index cb3c591..310b270 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -88,7 +88,7 @@ END(function_hook)
 	MCOUNT_SAVE_FRAME \skip
 
 	/* Load the ftrace_ops into the 3rd parameter */
-	leaq function_trace_op, %rdx
+	movq function_trace_op(%rip), %rdx
 
 	/* Load ip into the first parameter */
 	movq RIP(%rsp), %rdi
-- 
1.8.3.2

