Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab3APXoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 18:44:10 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:2044 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab3APXoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 18:44:09 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Al Cooper" <alcooperx@gmail.com>
To: rostedt@goodmis.org, ddaney.cavm@gmail.com, ralf@linux-mips.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
cc: "Al Cooper" <alcooperx@gmail.com>
Subject: [PATCH V2] mips: function tracer: Fix broken function tracing
Date: Wed, 16 Jan 2013 18:43:28 -0500
Message-ID: <1358379808-16449-1-git-send-email-alcooperx@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <y>
References: <y>
MIME-Version: 1.0
X-WSS-ID: 7CE9E58E3Q43364463-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my second attempt and is the result of some GREAT feedback
from David Daney and Steven Rostedt.

Function tracing is currently broken for all 32 bit MIPS platforms.
When tracing is enabled, the kernel immediately hangs on boot.
This is a result of commit b732d439cb43336cd6d7e804ecb2c81193ef63b0
that changes the kernel/trace/Kconfig file so that is no longer
forces FRAME_POINTER when FUNCTION_TRACING is enabled.

MIPS frame pointers are generally considered to be useless because
they cannot be used to unwind the stack. Unfortunately the MIPS
function tracing code has bugs that are masked by the use of frame
pointers. This commit fixes the bugs so that MIPS frame pointers
don't need to be enabled.

The bugs are a result of the odd calling sequence used to call the trace
routine. This calling sequence is inserted into every traceable function
when the tracing CONFIG option is enabled. This sequence is generated
for 32bit MIPS platforms by the compiler via the "-pg" flag.
Part of the sequence is "addiu sp,sp,-8" in the delay slot after every
call to the trace routine "_mcount" (some legacy thing where 2 arguments
used to be pushed on the stack). The _mcount routine is expected to
adjust the sp by +8 before returning.

The problem is that when tracing is disabled for a function, the
"jalr _mcount" instruction is replaced with a nop, but the
"addiu sp,sp,-8" is still executed and the stack pointer is left
trashed. When frame pointers are enabled the problem is masked
because any access to the stack is done through the frame
pointer and the stack pointer is restored from the frame pointer when
the function returns.

This patch writes two nops starting at the address of the "jalr _mcount"
instruction whenever tracing is disabled. This means that the
"addiu sp,sp.-8" will be converted to a nop along with the "jalr".
This is SMP safe because the first time this happens is during
ftrace_init() which is before any other processor has been started.
Subsequent calls to enable/disable tracing when other CPUs ARE running
will still be safe because the enable will only change the first nop
to a "jalr" and the disable, while writing 2 nops, will only be changing
the "jalr". This patch also stops using stop_machine() to call the
tracer enable/disable routines and calls them directly because the
routines are SMP safe.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
---
 arch/mips/kernel/ftrace.c |   34 +++++++++++++++++++++++++++++++++-
 arch/mips/kernel/mcount.S |    5 ++---
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index 6a2d758..6bcb678 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -25,6 +25,12 @@
 #define MCOUNT_OFFSET_INSNS 4
 #endif
 
+/* Arch override because MIPS doesn't need to run this from stop_machine() */
+void arch_ftrace_update_code(int command)
+{
+	ftrace_modify_all_code(command);
+}
+
 /*
  * Check if the address is in kernel space
  *
@@ -89,6 +95,22 @@ static int ftrace_modify_code(unsigned long ip, unsigned int new_code)
 	return 0;
 }
 
+static int ftrace_modify_code_2(unsigned long ip, unsigned int new_code1,
+				unsigned int new_code2)
+{
+	int faulted;
+
+	safe_store_code(new_code1, ip, faulted);
+	if (unlikely(faulted))
+		return -EFAULT;
+	ip += 4;
+	safe_store_code(new_code2, ip, faulted);
+	if (unlikely(faulted))
+		return -EFAULT;
+	flush_icache_range(ip, ip + 8); /* original ip + 12 */
+	return 0;
+}
+
 /*
  * The details about the calling site of mcount on MIPS
  *
@@ -131,8 +153,18 @@ int ftrace_make_nop(struct module *mod,
 	 * needed.
 	 */
 	new = in_kernel_space(ip) ? INSN_NOP : INSN_B_1F;
-
+#ifdef CONFIG_64BIT
 	return ftrace_modify_code(ip, new);
+#else
+	/*
+	 * On 32 bit MIPS platforms, gcc adds a stack adjust
+	 * instruction in the delay slot after the branch to
+	 * mcount and expects mcount to restore the sp on return.
+	 * This is based on a legacy API and does nothing but
+	 * waste instructions so it's being removed at runtime.
+	 */
+	return ftrace_modify_code_2(ip, new, INSN_NOP);
+#endif
 }
 
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
index 4c968e7..35ccaf7 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -46,9 +46,8 @@
 	PTR_L	a5, PT_R9(sp)
 	PTR_L	a6, PT_R10(sp)
 	PTR_L	a7, PT_R11(sp)
-	PTR_ADDIU	sp, PT_SIZE
 #else
-	PTR_ADDIU	sp, (PT_SIZE + 8)
+	PTR_ADDIU	sp, PT_SIZE
 #endif
 .endm
 
@@ -69,7 +68,7 @@ NESTED(ftrace_caller, PT_SIZE, ra)
 	.globl _mcount
 _mcount:
 	b	ftrace_stub
-	 nop
+	addiu sp,sp,8
 	lw	t1, function_trace_stop
 	bnez	t1, ftrace_stub
 	 nop
-- 
1.7.6


