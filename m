Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaBFAK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 19:10:26 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61857 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaBFAKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 19:10:21 -0500
From: Alexei Starovoitov <ast@plumgrid.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Pekka Enberg <penberg@iki.fi>, "David S. Miller" <davem@davemloft.net>,
        Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 tip 4/7] Revert "x86/ptrace: Remove unused regs_get_argument_nth API"
Date: Wed,  5 Feb 2014 16:10:04 -0800
Message-Id: <1391645407-4092-5-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391645407-4092-1-git-send-email-ast@plumgrid.com>
References: <1391645407-4092-1-git-send-email-ast@plumgrid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit aa5add93e92019018e905146f8c3d3f8e3c08300.

Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
---
 arch/x86/include/asm/ptrace.h |    3 +++
 arch/x86/kernel/ptrace.c      |   24 ++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 14fd6fd..e026176 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -222,6 +222,9 @@ static inline unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs,
 		return 0;
 }
 
+/* Get Nth argument at function call */
+unsigned long regs_get_argument_nth(struct pt_regs *regs, unsigned int n);
+
 #define arch_has_single_step()	(1)
 #ifdef CONFIG_X86_DEBUGCTLMSR
 #define arch_has_block_step()	(1)
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 7461f50..ac1c705 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -141,6 +141,30 @@ static const int arg_offs_table[] = {
 #endif
 };
 
+/**
+ * regs_get_argument_nth() - get Nth argument at function call
+ * @regs:	pt_regs which contains registers at function entry.
+ * @n:		argument number.
+ *
+ * regs_get_argument_nth() returns @n th argument of a function call.
+ * Since usually the kernel stack will be changed right after function entry,
+ * you must use this at function entry. If the @n th entry is NOT in the
+ * kernel stack or pt_regs, this returns 0.
+ */
+unsigned long regs_get_argument_nth(struct pt_regs *regs, unsigned int n)
+{
+	if (n < ARRAY_SIZE(arg_offs_table))
+		return *(unsigned long *)((char *)regs + arg_offs_table[n]);
+	else {
+		/*
+		 * The typical case: arg n is on the stack.
+		 * (Note: stack[0] = return address, so skip it)
+		 */
+		n -= ARRAY_SIZE(arg_offs_table);
+		return regs_get_kernel_stack_nth(regs, 1 + n);
+	}
+}
+
 /*
  * does not yet catch signals sent when the child dies.
  * in exit.c or in signal.c.
-- 
1.7.9.5

