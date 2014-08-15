Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaHOMAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 08:00:55 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:45778 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaHOMAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 08:00:53 -0400
Date: Fri, 15 Aug 2014 14:00:31 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Vojtech Pavlik <vojtech@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] s390/ftrace: add HAVE_DYNAMIC_FTRACE_WITH_REGS support
Message-ID: <20140815120031.GE4215@osiris>
References: <20140703120046.GA10664@suse.cz>
 <20140708080740.GA4491@osiris>
 <20140815115753.GA4215@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140815115753.GA4215@osiris>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081512-5024-0000-0000-000000FF3746
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code is based on a patch from Vojtech Pavlik.
http://marc.info/?l=linux-s390&m=140438885114413&w=2

The actual implementation now differs significantly:
Instead of adding a second function "ftrace_regs_caller" which would be nearly
identical to the existing ftrace_caller function, the current ftrace_caller
function is now an alias to ftrace_regs_caller and always passes the needed
pt_regs structure and function_trace_op parameters unconditionally.

Besides that also use asm offsets to correctly allocate and access the new
struct pt_regs on the stack.

While at it we can make use of new instruction to get rid of some indirect
loads if compiled for new machines.

The passed struct pt_regs can be changed by the called function and it's new
contents will replace the current contents. E.g. r14 can be modified to change
the return address of a traced function.

We explicitly do not use the psw_t member of struct pt_regs to pass (and
modify) r14, since that would result in a fake psw where the mask member is
invalid. In addition r14 and the psw_t member have different semantics
anyway.

Cc: Vojtech Pavlik <vojtech@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/Kconfig              |  1 +
 arch/s390/include/asm/ftrace.h |  4 ++++
 arch/s390/kernel/ftrace.c      |  5 +++++
 arch/s390/kernel/mcount64.S    | 45 ++++++++++++++++++++++++++++--------------
 4 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index ab39ceb89ecf..2d935cb77393 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -116,6 +116,7 @@ config S390
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DYNAMIC_FTRACE
+	select HAVE_DYNAMIC_FTRACE_WITH_REGS if 64BIT
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER
diff --git a/arch/s390/include/asm/ftrace.h b/arch/s390/include/asm/ftrace.h
index 874f903c2eb4..d419362dc231 100644
--- a/arch/s390/include/asm/ftrace.h
+++ b/arch/s390/include/asm/ftrace.h
@@ -24,4 +24,8 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 #define MCOUNT_INSN_SIZE  22
 #endif
 
+#ifdef CONFIG_64BIT
+#define ARCH_SUPPORTS_FTRACE_OPS 1
+#endif
+
 #endif /* _ASM_S390_FTRACE_H */
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 7dc7df3857c4..69eb49ccf8a4 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -107,6 +107,11 @@ asm(
 
 #endif /* CONFIG_64BIT */
 
+int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
+		       unsigned long addr)
+{
+	return 0;
+}
 
 int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
 		    unsigned long addr)
diff --git a/arch/s390/kernel/mcount64.S b/arch/s390/kernel/mcount64.S
index b03896d29274..92f8994f37b8 100644
--- a/arch/s390/kernel/mcount64.S
+++ b/arch/s390/kernel/mcount64.S
@@ -8,45 +8,60 @@
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
 #include <asm/ftrace.h>
+#include <asm/ptrace.h>
 
 	.section .kprobes.text, "ax"
 
 ENTRY(ftrace_stub)
 	br	%r14
 
+#define STACK_FRAME_SIZE  (STACK_FRAME_OVERHEAD + __PT_SIZE)
+#define STACK_PARENT_IP   (STACK_FRAME_SIZE + 8)
+#define STACK_PTREGS	  (STACK_FRAME_OVERHEAD)
+#define STACK_PTREGS_GPRS (STACK_PTREGS + __PT_GPRS)
+
 ENTRY(_mcount)
 #ifdef CONFIG_DYNAMIC_FTRACE
 	br	%r14
 
 ENTRY(ftrace_caller)
+	.globl	ftrace_regs_caller
+	.set	ftrace_regs_caller,ftrace_caller
 #endif
-	stmg	%r2,%r5,32(%r15)
-	stg	%r14,112(%r15)
 	lgr	%r1,%r15
-	aghi	%r15,-160
+	aghi	%r15,-STACK_FRAME_SIZE
 	stg	%r1,__SF_BACKCHAIN(%r15)
+	stg	%r1,(STACK_PTREGS_GPRS+15*8)(%r15)
+	stmg	%r0,%r14,STACK_PTREGS_GPRS(%r15)
+#ifdef CONFIG_HAVE_MARCH_Z196_FEATURES
+	aghik	%r2,%r14,-MCOUNT_INSN_SIZE
+	lgrl    %r4,function_trace_op
+	lgrl	%r14,ftrace_trace_function
+#else
 	lgr	%r2,%r14
-	lg	%r3,168(%r15)
 	aghi	%r2,-MCOUNT_INSN_SIZE
+	larl    %r4,function_trace_op
+	lg      %r4,0(%r4)
 	larl	%r14,ftrace_trace_function
 	lg	%r14,0(%r14)
+#endif
+	lg	%r3,STACK_PARENT_IP(%r15)
+	la	%r5,STACK_PTREGS(%r15)
 	basr	%r14,%r14
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-# The j instruction gets runtime patched to a nop instruction.
+ENTRY(ftrace_graph_caller)
+# The bras instruction gets runtime patched to call prepare_ftrace_return.
 # See ftrace_enable_ftrace_graph_caller. The patched instruction is:
 #	j	.+2
-ENTRY(ftrace_graph_caller)
 	j	ftrace_graph_caller_end
-	lg	%r2,168(%r15)
-	lg	%r3,272(%r15)
-	brasl	%r14,prepare_ftrace_return
-	stg	%r2,168(%r15)
+	lg	%r2,STACK_PARENT_IP(%r15)
+	lg	%r3,(STACK_PTREGS_GPRS+14*8)(%r15)
+	bras	%r14,prepare_ftrace_return
+	stg	%r2,STACK_PARENT_IP(%r15)
 ftrace_graph_caller_end:
 	.globl	ftrace_graph_caller_end
 #endif
-	aghi	%r15,160
-	lmg	%r2,%r5,32(%r15)
-	lg	%r14,112(%r15)
+	lmg	%r0,%r15,STACK_PTREGS_GPRS(%r15)
 	br	%r14
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -54,10 +69,10 @@ ftrace_graph_caller_end:
 ENTRY(return_to_handler)
 	stmg	%r2,%r5,32(%r15)
 	lgr	%r1,%r15
-	aghi	%r15,-160
+	aghi	%r15,-STACK_FRAME_OVERHEAD
 	stg	%r1,__SF_BACKCHAIN(%r15)
 	brasl	%r14,ftrace_return_to_handler
-	aghi	%r15,160
+	aghi	%r15,STACK_FRAME_OVERHEAD
 	lgr	%r14,%r2
 	lmg	%r2,%r5,32(%r15)
 	br	%r14
-- 
1.8.5.5

