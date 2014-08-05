Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbaHEOxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:53:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbaHEOw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:52:59 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/8] x86: entry_64.S: delete unused code
Date: Tue,  5 Aug 2014 16:52:27 +0200
Message-Id: <1407250354-29525-2-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1407250354-29525-1-git-send-email-dvlasenk@redhat.com>
References: <1407250354-29525-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A define, two macros and an unreferenced bit of assembly are gone.

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
 arch/x86/include/asm/calling.h |  1 -
 arch/x86/kernel/entry_64.S     | 34 ----------------------------------
 2 files changed, 35 deletions(-)

diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index cb4c73b..e176cea 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -83,7 +83,6 @@ For 32-bit we have the following conventions - kernel is built with
 #define SS		160
 
 #define ARGOFFSET	R11
-#define SWFRAME		ORIG_RAX
 
 	.macro SAVE_ARGS addskip=0, save_rcx=1, save_r891011=1
 	subq  $9*8+\addskip, %rsp
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b25ca96..dbfd037 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -155,27 +155,6 @@ ENDPROC(native_usergs_sysret64)
 	movq \tmp,R11+\offset(%rsp)
 	.endm
 
-	.macro FAKE_STACK_FRAME child_rip
-	/* push in order ss, rsp, eflags, cs, rip */
-	xorl %eax, %eax
-	pushq_cfi $__KERNEL_DS /* ss */
-	/*CFI_REL_OFFSET	ss,0*/
-	pushq_cfi %rax /* rsp */
-	CFI_REL_OFFSET	rsp,0
-	pushq_cfi $(X86_EFLAGS_IF|X86_EFLAGS_FIXED) /* eflags - interrupts on */
-	/*CFI_REL_OFFSET	rflags,0*/
-	pushq_cfi $__KERNEL_CS /* cs */
-	/*CFI_REL_OFFSET	cs,0*/
-	pushq_cfi \child_rip /* rip */
-	CFI_REL_OFFSET	rip,0
-	pushq_cfi %rax /* orig rax */
-	.endm
-
-	.macro UNFAKE_STACK_FRAME
-	addq $8*6, %rsp
-	CFI_ADJUST_CFA_OFFSET	-(6*8)
-	.endm
-
 /*
  * initial frame state for interrupts (and exceptions without error code)
  */
@@ -640,19 +619,6 @@ END(\label)
 	FORK_LIKE  vfork
 	FIXED_FRAME stub_iopl, sys_iopl
 
-ENTRY(ptregscall_common)
-	DEFAULT_FRAME 1 8	/* offset 8: return address */
-	RESTORE_TOP_OF_STACK %r11, 8
-	movq_cfi_restore R15+8, r15
-	movq_cfi_restore R14+8, r14
-	movq_cfi_restore R13+8, r13
-	movq_cfi_restore R12+8, r12
-	movq_cfi_restore RBP+8, rbp
-	movq_cfi_restore RBX+8, rbx
-	ret $REST_SKIP		/* pop extended registers */
-	CFI_ENDPROC
-END(ptregscall_common)
-
 ENTRY(stub_execve)
 	CFI_STARTPROC
 	addq $8, %rsp
-- 
1.8.1.4

