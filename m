Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbbANVtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:49:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbbANVth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:49:37 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] x86: entry_64.S: fold test_in_nmi macro into its only user
Date: Wed, 14 Jan 2015 22:48:18 +0100
Message-Id: <1421272101-16847-8-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com>
References: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No code changes.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
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
index aacfa2c..71036fe 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1365,19 +1365,7 @@ ENTRY(error_exit)
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
@@ -1438,8 +1426,14 @@ ENTRY(nmi)
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

