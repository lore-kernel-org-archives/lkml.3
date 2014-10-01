Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbaJAS2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:28:41 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:55637 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbaJAS2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:28:39 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Sebastian Lackner <sebastian@fds-team.de>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 2/2] x86_64: Don't save flags on context switch
Date: Wed,  1 Oct 2014 11:28:25 -0700
Message-Id: <bf6fb790787eb95b922157838f52712c25dda157.1412187233.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1412187233.git.luto@amacapital.net>
References: <cover.1412187233.git.luto@amacapital.net>
In-Reply-To: <cover.1412187233.git.luto@amacapital.net>
References: <cover.1412187233.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the kernel always runs with clean flags (in particular, NT
is clear), there is no need to save and restore flags on every
context switch.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/switch_to.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index d7f3b3b78ac3..751bf4b7bf11 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -79,12 +79,12 @@ do {									\
 #else /* CONFIG_X86_32 */
 
 /* frame pointer must be last for get_wchan */
-#define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
-#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
+#define SAVE_CONTEXT    "pushq %%rbp ; movq %%rsi,%%rbp\n\t"
+#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp\t"
 
 #define __EXTRA_CLOBBER  \
 	, "rcx", "rbx", "rdx", "r8", "r9", "r10", "r11", \
-	  "r12", "r13", "r14", "r15"
+	  "r12", "r13", "r14", "r15", "flags"
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 #define __switch_canary							  \
@@ -100,7 +100,11 @@ do {									\
 #define __switch_canary_iparam
 #endif	/* CC_STACKPROTECTOR */
 
-/* Save restore flags to clear handle leaking NT */
+/*
+ * There is no need to save or restore flags, because flags are always
+ * clean in kernel mode, with the possible exception of IOPL.  Kernel IOPL
+ * has no effect.
+ */
 #define switch_to(prev, next, last) \
 	asm volatile(SAVE_CONTEXT					  \
 	     "movq %%rsp,%P[threadrsp](%[prev])\n\t" /* save RSP */	  \
-- 
1.9.3

