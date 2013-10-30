Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3J3UmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:42:23 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:58877 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3J3UmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:42:20 -0400
Message-ID: <52716E67.6090705@hds.com>
Date: Wed, 30 Oct 2013 16:39:03 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, x86@kernel.org
CC: hpa@zytor.com, rostedt@goodmis.org, mingo@elte.hu, bp@alien8.de,
        tglx@linutronix.de, fdeslaur@gmail.com, raphael.beamonte@gmail.com,
        dle-develop@lists.sourceforge.net, tomoki.sekiyama@hds.com
Subject: [PATCH v4 4/4] Add page fault tracepoints
References: <52716D74.3070201@hds.com>
In-Reply-To: <52716D74.3070201@hds.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-30_06:2013-10-30,2013-10-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310300176
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces page fault tracepoints to x86 architecture
by switching IDT.

  Two events, for user and kernel spaces, are introduced at the beginning
  of page fault handler for tracing.

  - User space event
    There is a request of page fault event for user space as below.

    https://lkml.kernel.org/r/1368079520-11015-2-git-send-email-fdeslaur+()+gmail+!+com
    https://lkml.kernel.org/r/1368079520-11015-1-git-send-email-fdeslaur+()+gmail+!+com

  - Kernel space event:
    When we meature an overhead in kernel space for investigating performance
    issues, we can check if it comes from the page fault events.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 arch/x86/include/asm/trace/exceptions.h | 52 +++++++++++++++++++++++++++++++++
 arch/x86/mm/Makefile                    |  2 ++
 arch/x86/mm/fault.c                     | 13 +++++++++
 3 files changed, 67 insertions(+)
 create mode 100644 arch/x86/include/asm/trace/exceptions.h

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
-- 
1.8.3.1


