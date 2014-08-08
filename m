Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaHHRpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:45:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbaHHRpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:45:50 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 11/17] x86: entry_64.S: fold test_in_nmi macro into its only user
Date: Fri,  8 Aug 2014 19:44:34 +0200
Message-Id: <1407519880-6719-12-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
References: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No code changes.

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
 arch/x86/kernel/entry_64.S | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index decfe25..bf882af 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1389,19 +1389,7 @@ ENTRY(error_exit)
 	CFI_ENDPROC
 END(error_exit)
 
-/*
- * Test if a given stack is an NMI stack or not.
- */
-	.macro test_in_nmi reg stack nmi_ret normal_ret
-	cmpq %\reg, \stack
-	ja \normal_ret
-	subq $EXCEPTION_STKSZ, %\reg
-	cmpq %\reg, \stack
-	jb \normal_ret
-	jmp \nmi_ret
-	.endm
-
-	/* runs on exception stack */
+/* Runs on exception stack */
 ENTRY(nmi)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
@@ -1462,8 +1450,14 @@ ENTRY(nmi)
 	 * We check the variable because the first NMI could be in a
 	 * breakpoint routine using a breakpoint stack.
 	 */
-	lea 6*8(%rsp), %rdx
-	test_in_nmi rdx, 4*8(%rsp), nested_nmi, first_nmi
+	lea	6*8(%rsp), %rdx
+	cmpq	%rdx, 4*8(%rsp)
+	ja	first_nmi
+	subq	$EXCEPTION_STKSZ, %rdx
+	cmpq	%rdx, 4*8(%rsp)
+	jb	first_nmi
+	jmp	nested_nmi
+
 	CFI_REMEMBER_STATE
 
 nested_nmi:
-- 
1.8.1.4

