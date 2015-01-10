Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbbAJWBN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:01:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbbAJWBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:01:10 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 3/4] x86: open-code register save/restore in trace_hardirqs thunks
Date: Sat, 10 Jan 2015 23:00:09 +0100
Message-Id: <1420927210-19738-4-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1420927210-19738-1-git-send-email-dvlasenk@redhat.com>
References: <1420927210-19738-1-git-send-email-dvlasenk@redhat.com>
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
one SAVE_ARGS was used just to emit a CFI annotation,
but it also generated unreachable assembly insns.

Take a page from thunk_32.S and use push/pop insns
instead of movq, they are far shorter:
1 or 2 bytes versus 5, and no need for insns to adjust %rsp:

   text	   data	    bss	    dec	    hex	filename
    333	     40	      0	    373	    175	thunk_64_movq.o
    104	     40	      0	    144	     90	thunk_64_push_pop.o

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@alien8.de>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: X86 ML <x86@kernel.org>
CC: Alexei Starovoitov <ast@plumgrid.com>
CC: Will Drewry <wad@chromium.org>
CC: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org
---
 arch/x86/lib/thunk_64.S | 46 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
index b30b5eb..8ec443a 100644
--- a/arch/x86/lib/thunk_64.S
+++ b/arch/x86/lib/thunk_64.S
@@ -17,9 +17,27 @@
 	CFI_STARTPROC
 
 	/* this one pushes 9 elems, the next one would be %rIP */
-	SAVE_ARGS
+	pushq_cfi %rdi
+	CFI_REL_OFFSET rdi, 0
+	pushq_cfi %rsi
+	CFI_REL_OFFSET rsi, 0
+	pushq_cfi %rdx
+	CFI_REL_OFFSET rdx, 0
+	pushq_cfi %rcx
+	CFI_REL_OFFSET rcx, 0
+	pushq_cfi %rax
+	CFI_REL_OFFSET rax, 0
+	pushq_cfi %r8
+	CFI_REL_OFFSET r8, 0
+	pushq_cfi %r9
+	CFI_REL_OFFSET r9, 0
+	pushq_cfi %r10
+	CFI_REL_OFFSET r10, 0
+	pushq_cfi %r11
+	CFI_REL_OFFSET r11, 0
 
 	.if \put_ret_addr_in_rdi
+	/* 9*8(%rsp) is return addr on stack */
 	movq_cfi_restore 9*8, rdi
 	.endif
 
@@ -45,11 +63,31 @@
 #endif
 #endif
 
-	/* SAVE_ARGS below is used only for the .cfi directives it contains. */
+#if defined(CONFIG_TRACE_IRQFLAGS) \
+ || defined(CONFIG_DEBUG_LOCK_ALLOC) \
+ || defined(CONFIG_PREEMPT)
 	CFI_STARTPROC
-	SAVE_ARGS
+	CFI_ADJUST_CFA_OFFSET 9*8
 restore:
-	RESTORE_ARGS
+	popq_cfi %r11
+	CFI_RESTORE r11
+	popq_cfi %r10
+	CFI_RESTORE r10
+	popq_cfi %r9
+	CFI_RESTORE r9
+	popq_cfi %r8
+	CFI_RESTORE r8
+	popq_cfi %rax
+	CFI_RESTORE rax
+	popq_cfi %rcx
+	CFI_RESTORE rcx
+	popq_cfi %rdx
+	CFI_RESTORE rdx
+	popq_cfi %rsi
+	CFI_RESTORE rsi
+	popq_cfi %rdi
+	CFI_RESTORE rdi
 	ret
 	CFI_ENDPROC
 	_ASM_NOKPROBE(restore)
+#endif
-- 
1.8.1.4

