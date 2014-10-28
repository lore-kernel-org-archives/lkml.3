Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbaJ1LO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:14:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51352 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbaJ1LOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:14:24 -0400
Date: Tue, 28 Oct 2014 04:14:01 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-2c7577a7583747c9b71f26dced7f696b739da745@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, cebbert.lkml@gmail.com, anish@chelsio.com,
        tglx@linutronix.de, luto@amacapital.net, jbeulich@suse.com,
        mingo@kernel.org, torvalds@linux-foundation.org, sebastian@fds-team.de,
        hpa@zytor.com
Reply-To: luto@amacapital.net, jbeulich@suse.com, mingo@kernel.org,
        torvalds@linux-foundation.org, hpa@zytor.com, sebastian@fds-team.de,
        linux-kernel@vger.kernel.org, cebbert.lkml@gmail.com,
        anish@chelsio.com, tglx@linutronix.de
In-Reply-To: <bf6fb790787eb95b922157838f52712c25dda157.1412187233.git.luto@amacapital.net>
References: <bf6fb790787eb95b922157838f52712c25dda157.1412187233.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] sched/x86_64: Don't save flags on context switch
Git-Commit-ID: 2c7577a7583747c9b71f26dced7f696b739da745
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c7577a7583747c9b71f26dced7f696b739da745
Gitweb:     http://git.kernel.org/tip/2c7577a7583747c9b71f26dced7f696b739da745
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Wed, 1 Oct 2014 11:28:25 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 11:11:30 +0100

sched/x86_64: Don't save flags on context switch

Now that the kernel always runs with clean flags (in particular,
NT is clear), there is no need to save and restore flags on
every context switch.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Sebastian Lackner <sebastian@fds-team.de>
Cc: Anish Bhatt <anish@chelsio.com>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/bf6fb790787eb95b922157838f52712c25dda157.1412187233.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/switch_to.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index d7f3b3b..751bf4b 100644
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
