Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaKZEui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 23:50:38 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33377 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaKZEuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 23:50:35 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: keescook@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v9 2/6] arm64: ptrace: allow tracer to skip a system call
Date: Wed, 26 Nov 2014 13:49:47 +0900
Message-Id: <1416977391-24231-3-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416977391-24231-1-git-send-email-takahiro.akashi@linaro.org>
References: <1416977391-24231-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If tracer modifies a syscall number to -1, this traced system call should
be skipped with a return value specified in x0.
This patch implements this semantics.

Please note:
* syscall entry tracing and syscall exit tracing (ftrace tracepoint and
  audit) are always executed, if enabled, even when skipping a system call
  (that is, -1).
  In this way, we can avoid a potential bug where audit_syscall_entry()
  might be called without audit_syscall_exit() at the previous system call
  being called, that would cause OOPs in audit_syscall_entry().

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/kernel/entry.S |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 726b910..946ec52 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -161,6 +161,7 @@
  */
 sc_nr	.req	x25		// number of system calls
 scno	.req	x26		// syscall number
+scno_w	.req	w26		// syscall number (lower 32 bits)
 stbl	.req	x27		// syscall table pointer
 tsk	.req	x28		// current thread_info
 
@@ -668,8 +669,14 @@ ENDPROC(el0_svc)
 	 * switches, and waiting for our parent to respond.
 	 */
 __sys_trace:
-	mov	x0, sp
+	cmp     scno_w, #-1			// set default errno for
+	b.ne	1f				// user-issued syscall(-1)
+	mov	x0, #-ENOSYS
+	str	x0, [sp]
+1:	mov	x0, sp
 	bl	syscall_trace_enter
+	cmp	w0, #-1				// skip the syscall?
+	b.eq	__sys_trace_return_skipped
 	adr	lr, __sys_trace_return		// return address
 	uxtw	scno, w0			// syscall number (possibly new)
 	mov	x1, sp				// pointer to regs
@@ -684,6 +691,7 @@ __sys_trace:
 
 __sys_trace_return:
 	str	x0, [sp]			// save returned x0
+__sys_trace_return_skipped:
 	mov	x0, sp
 	bl	syscall_trace_exit
 	b	ret_to_user
-- 
1.7.9.5

