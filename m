Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaCKAhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 20:37:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55724 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbaCKAhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 20:37:46 -0400
Date: Mon, 10 Mar 2014 17:36:43 -0700
From: tip-bot for Mathias Krause <tipbot@zytor.com>
Message-ID: <tip-6cce16f99d7be23cec7cabdf32a8166eec6e5393@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        brgerst@gmail.com, peterz@infradead.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, minipli@googlemail.com, ak@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, peterz@infradead.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, minipli@googlemail.com, ak@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1394178752-18047-1-git-send-email-minipli@googlemail.com>
References: <1394178752-18047-1-git-send-email-minipli@googlemail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/threadinfo] x86, threadinfo: Redo "x86:
  Use inline assembler to get sp"
Git-Commit-ID: 6cce16f99d7be23cec7cabdf32a8166eec6e5393
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

Commit-ID:  6cce16f99d7be23cec7cabdf32a8166eec6e5393
Gitweb:     http://git.kernel.org/tip/6cce16f99d7be23cec7cabdf32a8166eec6e5393
Author:     Mathias Krause <minipli@googlemail.com>
AuthorDate: Fri, 7 Mar 2014 08:52:32 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 10 Mar 2014 17:32:01 -0700

x86, threadinfo: Redo "x86: Use inline assembler to get sp"

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
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Link: http://lkml.kernel.org/r/1394178752-18047-1-git-send-email-minipli@googlemail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/irq_32.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 988dc8b..63ce838 100644
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
