Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaAWTGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:06:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaAWTGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:06:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3.12 14/27] ftrace/x86: Load ftrace_ops in parameter not the variable holding it
Date: Thu, 23 Jan 2014 11:06:51 -0800
Message-Id: <20140123190650.189639826@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123190648.720195687@linuxfoundation.org>
References: <20140123190648.720195687@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/entry_32.S |    4 ++--
 arch/x86/kernel/entry_64.S |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1085,7 +1085,7 @@ ENTRY(ftrace_caller)
 	pushl $0	/* Pass NULL as regs pointer */
 	movl 4*4(%esp), %eax
 	movl 0x4(%ebp), %edx
-	leal function_trace_op, %ecx
+	movl function_trace_op, %ecx
 	subl $MCOUNT_INSN_SIZE, %eax
 
 .globl ftrace_call
@@ -1143,7 +1143,7 @@ ENTRY(ftrace_regs_caller)
 	movl 12*4(%esp), %eax	/* Load ip (1st parameter) */
 	subl $MCOUNT_INSN_SIZE, %eax	/* Adjust ip */
 	movl 0x4(%ebp), %edx	/* Load parent ip (2nd parameter) */
-	leal function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
+	movl function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
 	pushl %esp		/* Save pt_regs as 4th parameter */
 
 GLOBAL(ftrace_regs_call)
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -88,7 +88,7 @@ END(function_hook)
 	MCOUNT_SAVE_FRAME \skip
 
 	/* Load the ftrace_ops into the 3rd parameter */
-	leaq function_trace_op, %rdx
+	movq function_trace_op(%rip), %rdx
 
 	/* Load ip into the first parameter */
 	movq RIP(%rsp), %rdi


