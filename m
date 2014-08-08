Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaHHRpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:45:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbaHHRpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:45:41 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 09/17] x86: entry_64.S: move save_paranoid and ret_from_fork closer to their users
Date: Fri,  8 Aug 2014 19:44:32 +0200
Message-Id: <1407519880-6719-10-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
References: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some odd reasons, these two functions are at the very top of the file,
whereas their callers are approximately in the middle of it.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
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
 arch/x86/kernel/entry_64.S | 106 ++++++++++++++++++++++-----------------------
 1 file changed, 53 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 4a2e3ab..5ad9b28 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -202,59 +202,6 @@ ENDPROC(native_usergs_sysret64)
 	CFI_REL_OFFSET r15, R15+\offset
 	.endm
 
-ENTRY(save_paranoid)
-	XCPT_FRAME 1 RDI+8
-	cld
-	SAVE_C_REGS 8
-	SAVE_EXTRA_REGS 8
-	movl $1,%ebx
-	movl $MSR_GS_BASE,%ecx
-	rdmsr
-	testl %edx,%edx
-	js 1f	/* negative -> in kernel */
-	SWAPGS
-	xorl %ebx,%ebx
-1:	ret
-	CFI_ENDPROC
-END(save_paranoid)
-
-/*
- * A newly forked process directly context switches into this address.
- *
- * rdi: prev task we switched from
- */
-ENTRY(ret_from_fork)
-	DEFAULT_FRAME
-
-	LOCK ; btr $TIF_FORK,TI_flags(%r8)
-
-	pushq_cfi $0x0002
-	popfq_cfi				# reset kernel eflags
-
-	call schedule_tail			# rdi: 'prev' task parameter
-
-	GET_THREAD_INFO(%rcx)
-
-	RESTORE_EXTRA_REGS
-
-	testl $3, CS(%rsp)			# from kernel_thread?
-	jz   1f
-
-	testl $_TIF_IA32, TI_flags(%rcx)	# 32-bit compat task needs IRET
-	jnz  int_ret_from_sys_call
-
-	RESTORE_TOP_OF_STACK %rdi
-	jmp ret_from_sys_call			# go to the SYSRET fastpath
-
-1:
-	movq %rbp, %rdi
-	call *%rbx
-	movl $0, RAX(%rsp)
-	RESTORE_EXTRA_REGS
-	jmp int_ret_from_sys_call
-	CFI_ENDPROC
-END(ret_from_fork)
-
 /*
  * 64bit SYSCALL instruction entry. Up to 6 arguments in registers.
  *
@@ -608,6 +555,43 @@ END(stub_x32_execve)
 #endif
 
 /*
+ * A newly forked process directly context switches into this address.
+ *
+ * rdi: prev task we switched from
+ */
+ENTRY(ret_from_fork)
+	DEFAULT_FRAME
+
+	LOCK ; btr $TIF_FORK,TI_flags(%r8)
+
+	pushq_cfi $0x0002
+	popfq_cfi				# reset kernel eflags
+
+	call schedule_tail			# rdi: 'prev' task parameter
+
+	GET_THREAD_INFO(%rcx)
+
+	RESTORE_EXTRA_REGS
+
+	testl $3, CS(%rsp)			# from kernel_thread?
+	jz   1f
+
+	testl $_TIF_IA32, TI_flags(%rcx)	# 32-bit compat task needs IRET
+	jnz  int_ret_from_sys_call
+
+	RESTORE_TOP_OF_STACK %rdi
+	jmp ret_from_sys_call			# go to the SYSRET fastpath
+
+1:
+	movq %rbp, %rdi
+	call *%rbx
+	movl $0, RAX(%rsp)
+	RESTORE_EXTRA_REGS
+	jmp int_ret_from_sys_call
+	CFI_ENDPROC
+END(ret_from_fork)
+
+/*
  * Build the entry stubs and pointer table with some assembler magic.
  * We pack 7 stubs into a single 32-byte chunk, which will fit in a
  * single cache line on all modern x86 implementations.
@@ -1258,6 +1242,22 @@ idtentry async_page_fault do_async_page_fault has_error_code=1
 idtentry machine_check has_error_code=0 paranoid=1 do_sym=*machine_check_vector(%rip)
 #endif
 
+ENTRY(save_paranoid)
+	XCPT_FRAME 1 RDI+8
+	cld
+	SAVE_C_REGS 8
+	SAVE_EXTRA_REGS 8
+	movl $1,%ebx
+	movl $MSR_GS_BASE,%ecx
+	rdmsr
+	testl %edx,%edx
+	js 1f	/* negative -> in kernel */
+	SWAPGS
+	xorl %ebx,%ebx
+1:	ret
+	CFI_ENDPROC
+END(save_paranoid)
+
 	/*
 	 * "Paranoid" exit path from exception stack.
 	 * Paranoid because this is used by NMIs and cannot take
-- 
1.8.1.4

