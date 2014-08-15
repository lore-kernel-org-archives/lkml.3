Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaHOMBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 08:01:10 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:42587 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaHOMBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 08:01:07 -0400
Date: Fri, 15 Aug 2014 14:01:02 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Vojtech Pavlik <vojtech@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] s390/ftrace: enforce DYNAMIC_FTRACE if FUNCTION_TRACER
 is selected
Message-ID: <20140815120102.GF4215@osiris>
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
x-cbid: 14081512-0542-0000-0000-0000004E983C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have too many combinations for function tracing. Lets simply stick to
the most advanced option, so we don't have to care of other combinations.

This means we always select DYNAMIC_FTRACE if FUNCTION_TRACER is selected.

In the s390 Makefile also remove CONFIG_FTRACE_SYSCALLS since that
functionality got moved to architecture independent code in the meantime.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/Kconfig           | 1 +
 arch/s390/kernel/Makefile   | 4 +---
 arch/s390/kernel/ftrace.c   | 6 ------
 arch/s390/kernel/mcount.S   | 2 --
 arch/s390/kernel/mcount64.S | 2 --
 5 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 2d935cb77393..a8cbc72837d0 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -99,6 +99,7 @@ config S390
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select BUILDTIME_EXTABLE_SORT
 	select CLONE_BACKWARDS2
+	select DYNAMIC_FTRACE if FUNCTION_TRACER
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CPU_DEVICES if !SMP
 	select GENERIC_FIND_FIRST_BIT
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index a95c4ca99617..d44245d4df37 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -53,9 +53,7 @@ obj-$(CONFIG_COMPAT)		+= compat_wrapper.o $(compat-obj-y)
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_FUNCTION_TRACER)	+= $(if $(CONFIG_64BIT),mcount64.o,mcount.o)
-obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
-obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
-obj-$(CONFIG_FTRACE_SYSCALLS)  += ftrace.o
+obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 
 ifdef CONFIG_64BIT
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 69eb49ccf8a4..40d4da7c9f8a 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -17,8 +17,6 @@
 #include <asm/asm-offsets.h>
 #include "entry.h"
 
-#ifdef CONFIG_DYNAMIC_FTRACE
-
 void ftrace_disable_code(void);
 void ftrace_enable_insn(void);
 
@@ -140,8 +138,6 @@ int __init ftrace_dyn_arch_init(void)
 	return 0;
 }
 
-#endif /* CONFIG_DYNAMIC_FTRACE */
-
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 /*
  * Hook the return address and push it in the stack of return addresses
@@ -167,7 +163,6 @@ out:
 	return parent;
 }
 
-#ifdef CONFIG_DYNAMIC_FTRACE
 /*
  * Patch the kernel code at ftrace_graph_caller location. The instruction
  * there is branch relative and save to prepare_ftrace_return. To disable
@@ -217,5 +212,4 @@ int ftrace_disable_ftrace_graph_caller(void)
 }
 
 #endif /* CONFIG_64BIT */
-#endif /* CONFIG_DYNAMIC_FTRACE */
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/arch/s390/kernel/mcount.S b/arch/s390/kernel/mcount.S
index 433c6dbfa442..be6dbd9a81a7 100644
--- a/arch/s390/kernel/mcount.S
+++ b/arch/s390/kernel/mcount.S
@@ -15,11 +15,9 @@ ENTRY(ftrace_stub)
 	br	%r14
 
 ENTRY(_mcount)
-#ifdef CONFIG_DYNAMIC_FTRACE
 	br	%r14
 
 ENTRY(ftrace_caller)
-#endif
 	stm	%r2,%r5,16(%r15)
 	bras	%r1,1f
 0:	.long	ftrace_trace_function
diff --git a/arch/s390/kernel/mcount64.S b/arch/s390/kernel/mcount64.S
index 92f8994f37b8..5c7b506ef44d 100644
--- a/arch/s390/kernel/mcount64.S
+++ b/arch/s390/kernel/mcount64.S
@@ -21,13 +21,11 @@ ENTRY(ftrace_stub)
 #define STACK_PTREGS_GPRS (STACK_PTREGS + __PT_GPRS)
 
 ENTRY(_mcount)
-#ifdef CONFIG_DYNAMIC_FTRACE
 	br	%r14
 
 ENTRY(ftrace_caller)
 	.globl	ftrace_regs_caller
 	.set	ftrace_regs_caller,ftrace_caller
-#endif
 	lgr	%r1,%r15
 	aghi	%r15,-STACK_FRAME_SIZE
 	stg	%r1,__SF_BACKCHAIN(%r15)
-- 
1.8.5.5

