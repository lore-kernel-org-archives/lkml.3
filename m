Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaCGHww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 02:52:52 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:52298 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaCGHwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 02:52:51 -0500
From: Mathias Krause <minipli@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brian Gerst <brgerst@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH] x86: redo "x86: Use inline assembler to get sp"
Date: Fri,  7 Mar 2014 08:52:32 +0100
Message-Id: <1394178752-18047-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <tip-198d208df4371734ac4728f69cb585c284d20a15@git.kernel.org>
References: <tip-198d208df4371734ac4728f69cb585c284d20a15@git.kernel.org>, <20110806012354.263834829@goodmis.org>, <20140206144321.852942014@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch restores the changes of commit dff38e3e93 "x86: Use inline
assembler instead of global register variable to get sp". They got lost
in commit 198d208df4 "x86: Keep thread_info on thread stack in x86_32"
while moving the code to arch/x86/kernel/irq_32.c.

Quoting Andi from commit dff38e3e93:

"""
LTO in gcc 4.6/47. has trouble with global register variables. They were
used to read the stack pointer. Use a simple inline assembler statement
with a mov instead.

This also helps LLVM/clang, which does not support global register
variables.
"""

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---

If it's not obvious, this patch should be applied to tip.git on top of
tip/x86/threadinfo.

 arch/x86/kernel/irq_32.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 988dc8bcae..63ce838e5a 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -70,7 +70,11 @@ static void call_on_stack(void *func, void *stack)
 }
 
 /* how to get the current stack pointer from C */
-register unsigned long current_stack_pointer asm("esp") __used;
+#define current_stack_pointer ({		\
+	unsigned long sp;			\
+	asm("mov %%esp,%0" : "=g" (sp));	\
+	sp;					\
+})
 
 static inline void *current_stack(void)
 {
-- 
1.7.10.4

