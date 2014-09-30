Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaI3Tk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:40:57 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:53202 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbaI3Tkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:40:53 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Sebastian Lackner <sebastian@fds-team.de>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/2] x86_64: Don't save flags on context switch
Date: Tue, 30 Sep 2014 12:40:36 -0700
Message-Id: <6fcba8b78a44292687e6317fcc89a72d0dd07976.1412105369.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1412105369.git.luto@amacapital.net>
References: <cover.1412105369.git.luto@amacapital.net>
In-Reply-To: <cover.1412105369.git.luto@amacapital.net>
References: <cover.1412105369.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the kernel always runs with clean flags (in particular, NT
is clear), there is no need to save and restore flags on every
context switch.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/switch_to.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index d7f3b3b78ac3..0464181b0cbe 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -79,8 +79,8 @@ do {									\
 #else /* CONFIG_X86_32 */
 
 /* frame pointer must be last for get_wchan */
-#define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
-#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
+#define SAVE_CONTEXT    "pushq %%rbp ; movq %%rsi,%%rbp\n\t"
+#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp\t"
 
 #define __EXTRA_CLOBBER  \
 	, "rcx", "rbx", "rdx", "r8", "r9", "r10", "r11", \
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

