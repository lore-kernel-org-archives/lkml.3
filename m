Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaHAOtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:49:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbaHAOtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:49:18 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 2/5] x86: open-code register save/restore in trace_hardirqs thunks
Date: Fri,  1 Aug 2014 16:48:15 +0200
Message-Id: <1406904498-21647-2-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparatory patch for change in "struct pt_regs"
handling in entry_64.S.

trace_hardirqs thunks were (ab)using a part of pt_regs
handling code, namely SAVE_ARGS/RESTORE_ARGS macros,
to save/restore registers across C function calls.

Since SAVE_ARGS is going to be changed, open-code
register saving/restoring here.

Incidentally, this removes a bit of dead code:
one SAVE_ARGS was just to emit a CFI annotation,
but it also generated unreachable assembly insns.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: X86 ML <x86@kernel.org>
CC: Alexei Starovoitov <ast@plumgrid.com>
CC: Will Drewry <wad@chromium.org>
CC: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org
---
 arch/x86/lib/thunk_64.S | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
index 92d9fea..c1c9131 100644
--- a/arch/x86/lib/thunk_64.S
+++ b/arch/x86/lib/thunk_64.S
@@ -16,10 +16,20 @@
 \name:
 	CFI_STARTPROC
 
-	/* this one pushes 9 elems, the next one would be %rIP */
-	SAVE_ARGS
+	subq  $9*8, %rsp
+	CFI_ADJUST_CFA_OFFSET 9*8
+	movq_cfi rdi, 8*8
+	movq_cfi rsi, 7*8
+	movq_cfi rdx, 6*8
+	movq_cfi rcx, 5*8
+	movq_cfi rax, 4*8
+	movq_cfi r8,  3*8
+	movq_cfi r9,  2*8
+	movq_cfi r10, 1*8
+	movq_cfi r11, 0*8
 
 	.if \put_ret_addr_in_rdi
+	/* 9*8(%rsp) is return addr on stack */
 	movq_cfi_restore 9*8, rdi
 	.endif
 
@@ -38,11 +48,20 @@
 	THUNK lockdep_sys_exit_thunk,lockdep_sys_exit
 #endif
 
-	/* SAVE_ARGS below is used only for the .cfi directives it contains. */
 	CFI_STARTPROC
-	SAVE_ARGS
+	CFI_ADJUST_CFA_OFFSET 9*8
 restore:
-	RESTORE_ARGS
+	movq_cfi_restore 0*8, r11
+	movq_cfi_restore 1*8, r10
+	movq_cfi_restore 2*8, r9
+	movq_cfi_restore 3*8, r8
+	movq_cfi_restore 4*8, rax
+	movq_cfi_restore 5*8, rcx
+	movq_cfi_restore 6*8, rdx
+	movq_cfi_restore 7*8, rsi
+	movq_cfi_restore 8*8, rdi
+	addq 9*8, %rsp
+	CFI_ADJUST_CFA_OFFSET -9*8
 	ret
 	CFI_ENDPROC
 	_ASM_NOKPROBE(restore)
-- 
1.8.1.4

