Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab3KHXKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:10:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36716 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758455Ab3KHXKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:10:36 -0500
Date: Fri, 8 Nov 2013 15:10:24 -0800
From: tip-bot for Seiji Aguchi <tipbot@zytor.com>
Message-ID: <tip-d34603b07c4255b2b00a546d34f297ccd50ae4c6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        seiji.aguchi@hds.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seiji.aguchi@hds.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <52716E67.6090705@hds.com>
References: <52716E67.6090705@hds.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trace] x86, trace: Add page fault tracepoints
Git-Commit-ID: d34603b07c4255b2b00a546d34f297ccd50ae4c6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 08 Nov 2013 15:10:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d34603b07c4255b2b00a546d34f297ccd50ae4c6
Gitweb:     http://git.kernel.org/tip/d34603b07c4255b2b00a546d34f297ccd50ae4c6
Author:     Seiji Aguchi <seiji.aguchi@hds.com>
AuthorDate: Wed, 30 Oct 2013 16:39:03 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 8 Nov 2013 14:15:49 -0800

x86, trace: Add page fault tracepoints

This patch introduces page fault tracepoints to x86 architecture
by switching IDT.

  Two events, for user and kernel spaces, are introduced at the beginning
  of page fault handler for tracing.

  - User space event
    There is a request of page fault event for user space as below.

    https://lkml.kernel.org/r/1368079520-11015-2-git-send-email-fdeslaur+()+gmail+!+com
    https://lkml.kernel.org/r/1368079520-11015-1-git-send-email-fdeslaur+()+gmail+!+com

  - Kernel space event:
    When we measure an overhead in kernel space for investigating performance
    issues, we can check if it comes from the page fault events.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Link: http://lkml.kernel.org/r/52716E67.6090705@hds.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/trace/exceptions.h | 52 +++++++++++++++++++++++++++++++++
 arch/x86/mm/Makefile                    |  2 ++
 arch/x86/mm/fault.c                     | 13 +++++++++
 3 files changed, 67 insertions(+)

diff --git a/arch/x86/include/asm/trace/exceptions.h b/arch/x86/include/asm/trace/exceptions.h
new file mode 100644
index 0000000..86540c0
--- /dev/null
+++ b/arch/x86/include/asm/trace/exceptions.h
@@ -0,0 +1,52 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM exceptions
+
+#if !defined(_TRACE_PAGE_FAULT_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_PAGE_FAULT_H
+
+#include <linux/tracepoint.h>
+
+extern void trace_irq_vector_regfunc(void);
+extern void trace_irq_vector_unregfunc(void);
+
+DECLARE_EVENT_CLASS(x86_exceptions,
+
+	TP_PROTO(unsigned long address, struct pt_regs *regs,
+		 unsigned long error_code),
+
+	TP_ARGS(address, regs, error_code),
+
+	TP_STRUCT__entry(
+		__field(		unsigned long, address	)
+		__field(		unsigned long, ip	)
+		__field(		unsigned long, error_code )
+	),
+
+	TP_fast_assign(
+		__entry->address = address;
+		__entry->ip = regs->ip;
+		__entry->error_code = error_code;
+	),
+
+	TP_printk("address=%pf ip=%pf error_code=0x%lx",
+		  (void *)__entry->address, (void *)__entry->ip,
+		  __entry->error_code) );
+
+#define DEFINE_PAGE_FAULT_EVENT(name)				\
+DEFINE_EVENT_FN(x86_exceptions, name,				\
+	TP_PROTO(unsigned long address,	struct pt_regs *regs,	\
+		 unsigned long error_code),			\
+	TP_ARGS(address, regs, error_code),			\
+	trace_irq_vector_regfunc,				\
+	trace_irq_vector_unregfunc);
+
+DEFINE_PAGE_FAULT_EVENT(user_page_fault);
+DEFINE_PAGE_FAULT_EVENT(kernel_page_fault);
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE exceptions
+#endif /*  _TRACE_PAGE_FAULT_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 23d8e5f..6a19ad9 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -6,6 +6,8 @@ nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_physaddr.o		:= $(nostackp)
 CFLAGS_setup_nx.o		:= $(nostackp)
 
+CFLAGS_fault.o := -I$(src)/../include/asm/trace
+
 obj-$(CONFIG_X86_PAT)		+= pat_rbtree.o
 obj-$(CONFIG_SMP)		+= tlb.o
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index fd3e281..f2730cbc 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -20,6 +20,9 @@
 #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
 #include <asm/fixmap.h>			/* VSYSCALL_START		*/
 
+#define CREATE_TRACE_POINTS
+#include <asm/trace/exceptions.h>
+
 /*
  * Page fault error code bits:
  *
@@ -1232,12 +1235,22 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	exception_exit(prev_state);
 }
 
+static void trace_page_fault_entries(struct pt_regs *regs,
+				     unsigned long error_code)
+{
+	if (user_mode(regs))
+		trace_user_page_fault(read_cr2(), regs, error_code);
+	else
+		trace_kernel_page_fault(read_cr2(), regs, error_code);
+}
+
 dotraplinkage void __kprobes
 trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	enum ctx_state prev_state;
 
 	prev_state = exception_enter();
+	trace_page_fault_entries(regs, error_code);
 	__do_page_fault(regs, error_code);
 	exception_exit(prev_state);
 }
