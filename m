Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031AbaJXI0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:26:55 -0400
Received: from mail-by2on0069.outbound.protection.outlook.com ([207.46.100.69]:3399
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932996AbaJXI0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:26:51 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 26/29] nios2: ptrace support
Date: Fri, 24 Oct 2014 16:24:28 +0800
Message-ID: <1414139071-3818-27-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(22564002)(189002)(199003)(42186005)(89996001)(88136002)(86362001)(93916002)(92726001)(92566001)(2201001)(77156001)(64706001)(85852003)(87286001)(87936001)(21056001)(62966002)(84676001)(229853001)(106466001)(77096002)(105596002)(107046002)(36756003)(120916001)(99396003)(47776003)(97736003)(95666004)(20776003)(76482002)(104166001)(80022003)(6806004)(19580395003)(44976005)(50466002)(48376002)(68736004)(19580405001)(33646002)(76176999)(85306004)(50986999)(31966008)(46102003)(50226001)(102836001)(4396001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB218;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB218;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ptrace support for nios2.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/ptrace.h      |  33 +++++++
 arch/nios2/include/uapi/asm/ptrace.h | 120 +++++++++++++++++++++++++
 arch/nios2/kernel/ptrace.c           | 166 +++++++++++++++++++++++++++++++++++
 3 files changed, 319 insertions(+)
 create mode 100644 arch/nios2/include/asm/ptrace.h
 create mode 100644 arch/nios2/include/uapi/asm/ptrace.h
 create mode 100644 arch/nios2/kernel/ptrace.c

diff --git a/arch/nios2/include/asm/ptrace.h b/arch/nios2/include/asm/ptrace.h
new file mode 100644
index 0000000..20fb1cf
--- /dev/null
+++ b/arch/nios2/include/asm/ptrace.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright (C) 2013 Altera Corporation
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd
+ *
+ * based on m68k asm/processor.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_PTRACE_H
+#define _ASM_NIOS2_PTRACE_H
+
+#include <uapi/asm/ptrace.h>
+
+#ifndef __ASSEMBLY__
+#define user_mode(regs)	(((regs)->estatus & ESTATUS_EU))
+
+#define instruction_pointer(regs)	((regs)->ra)
+#define profile_pc(regs)		instruction_pointer(regs)
+#define user_stack_pointer(regs)	((regs)->sp)
+extern void show_regs(struct pt_regs *);
+
+#define current_pt_regs() \
+	((struct pt_regs *)((unsigned long)current_thread_info() + THREAD_SIZE)\
+		- 1)
+
+int do_syscall_trace_enter(void);
+void do_syscall_trace_exit(void);
+#endif /* __ASSEMBLY__ */
+#endif /* _ASM_NIOS2_PTRACE_H */
diff --git a/arch/nios2/include/uapi/asm/ptrace.h b/arch/nios2/include/uapi/asm/ptrace.h
new file mode 100644
index 0000000..e83a7c9
--- /dev/null
+++ b/arch/nios2/include/uapi/asm/ptrace.h
@@ -0,0 +1,120 @@
+/*
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd
+ *
+ * based on m68k asm/processor.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _UAPI_ASM_NIOS2_PTRACE_H
+#define _UAPI_ASM_NIOS2_PTRACE_H
+
+#ifndef __ASSEMBLY__
+
+/*
+ * Register numbers used by 'ptrace' system call interface.
+ */
+
+/* GP registers */
+#define PTR_R0		0
+#define PTR_R1		1
+#define PTR_R2		2
+#define PTR_R3		3
+#define PTR_R4		4
+#define PTR_R5		5
+#define PTR_R6		6
+#define PTR_R7		7
+#define PTR_R8		8
+#define PTR_R9		9
+#define PTR_R10		10
+#define PTR_R11		11
+#define PTR_R12		12
+#define PTR_R13		13
+#define PTR_R14		14
+#define PTR_R15		15
+#define PTR_R16		16
+#define PTR_R17		17
+#define PTR_R18		18
+#define PTR_R19		19
+#define PTR_R20		20
+#define PTR_R21		21
+#define PTR_R22		22
+#define PTR_R23		23
+#define PTR_R24		24
+#define PTR_R25		25
+#define PTR_GP		26
+#define PTR_SP		27
+#define PTR_FP		28
+#define PTR_EA		29
+#define PTR_BA		30
+#define PTR_RA		31
+/* Control registers */
+#define PTR_PC		32
+#define PTR_STATUS	33
+#define PTR_ESTATUS	34
+#define PTR_BSTATUS	35
+#define PTR_IENABLE	36
+#define PTR_IPENDING	37
+#define PTR_CPUID	38
+#define PTR_CTL6	39
+#define PTR_CTL7	40
+#define PTR_PTEADDR	41
+#define PTR_TLBACC	42
+#define PTR_TLBMISC	43
+
+#define NUM_PTRACE_REG (PTR_TLBMISC + 1)
+
+/* this struct defines the way the registers are stored on the
+   stack during a system call.
+
+   There is a fake_regs in setup.c that has to match pt_regs.*/
+
+struct pt_regs {
+	unsigned long  r8;		/* r8-r15 Caller-saved GP registers */
+	unsigned long  r9;
+	unsigned long  r10;
+	unsigned long  r11;
+	unsigned long  r12;
+	unsigned long  r13;
+	unsigned long  r14;
+	unsigned long  r15;
+	unsigned long  r1;		/* Assembler temporary */
+	unsigned long  r2;		/* Retval LS 32bits */
+	unsigned long  r3;		/* Retval MS 32bits */
+	unsigned long  r4;		/* r4-r7 Register arguments */
+	unsigned long  r5;
+	unsigned long  r6;
+	unsigned long  r7;
+	unsigned long  orig_r2;		/* Copy of r2 ?? */
+	unsigned long  ra;		/* Return address */
+	unsigned long  fp;		/* Frame pointer */
+	unsigned long  sp;		/* Stack pointer */
+	unsigned long  gp;		/* Global pointer */
+	unsigned long  estatus;
+	unsigned long  ea;		/* Exception return address (pc) */
+	unsigned long  orig_r7;
+};
+
+/*
+ * This is the extended stack used by signal handlers and the context
+ * switcher: it's pushed after the normal "struct pt_regs".
+ */
+struct switch_stack {
+	unsigned long  r16;		/* r16-r23 Callee-saved GP registers */
+	unsigned long  r17;
+	unsigned long  r18;
+	unsigned long  r19;
+	unsigned long  r20;
+	unsigned long  r21;
+	unsigned long  r22;
+	unsigned long  r23;
+	unsigned long  fp;
+	unsigned long  gp;
+	unsigned long  ra;
+};
+
+#endif /* __ASSEMBLY__ */
+#endif /* _UAPI_ASM_NIOS2_PTRACE_H */
diff --git a/arch/nios2/kernel/ptrace.c b/arch/nios2/kernel/ptrace.c
new file mode 100644
index 0000000..0d3e7e3
--- /dev/null
+++ b/arch/nios2/kernel/ptrace.c
@@ -0,0 +1,166 @@
+/*
+ * Copyright (C) 2014 Altera Corporation
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License.  See the file COPYING in the main directory of this
+ * archive for more details.
+ */
+
+#include <linux/elf.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/ptrace.h>
+#include <linux/regset.h>
+#include <linux/sched.h>
+#include <linux/tracehook.h>
+#include <linux/uaccess.h>
+#include <linux/user.h>
+
+static int genregs_get(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       void *kbuf, void __user * ubuf)
+{
+	const struct pt_regs *regs = task_pt_regs(target);
+	const struct switch_stack *sw = (struct switch_stack *)regs - 1;
+	int ret = 0;
+
+#define REG_O_ZERO_RANGE(START, END)		\
+	if (!ret)					\
+		ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf, \
+			START * 4, (END * 4) + 4);
+
+#define REG_O_ONE(PTR, LOC)	\
+	if (!ret)			\
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, PTR, \
+			LOC * 4, (LOC * 4) + 4);
+
+#define REG_O_RANGE(PTR, START, END)	\
+	if (!ret)				\
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, PTR, \
+			START * 4, (END * 4) + 4);
+
+	REG_O_ZERO_RANGE(PTR_R0, PTR_R0);
+	REG_O_RANGE(&regs->r1,PTR_R1, PTR_R7);
+	REG_O_RANGE(&regs->r8,PTR_R8, PTR_R15);
+	REG_O_RANGE(sw, PTR_R16, PTR_R23);
+	REG_O_ZERO_RANGE(PTR_R24, PTR_R25); /* et and bt */
+	REG_O_ONE(&regs->gp, PTR_GP);
+	REG_O_ONE(&regs->sp, PTR_SP);
+	REG_O_ONE(&regs->fp, PTR_FP);
+	REG_O_ONE(&regs->ea, PTR_EA);
+	REG_O_ZERO_RANGE(PTR_BA, PTR_BA);
+	REG_O_ONE(&regs->ra, PTR_RA);
+	REG_O_ONE(&regs->ea, PTR_PC); /* use ea for PC */
+	if (!ret)
+		ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+					 PTR_STATUS * 4, -1);
+
+	return ret;
+}
+
+/*
+ * Set the thread state from a regset passed in via ptrace
+ */
+static int genregs_set(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       const void *kbuf, const void __user * ubuf)
+{
+	struct pt_regs *regs = task_pt_regs(target);
+	const struct switch_stack *sw = (struct switch_stack *)regs - 1;
+	int ret = 0;
+
+#define REG_IGNORE_RANGE(START, END)		\
+	if (!ret)					\
+		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf, \
+			START * 4, (END * 4) + 4);
+
+#define REG_IN_ONE(PTR, LOC)	\
+	if (!ret)			\
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, \
+			(void *)(PTR), LOC * 4, (LOC * 4) + 4);
+
+#define REG_IN_RANGE(PTR, START, END)	\
+	if (!ret)				\
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, \
+			(void *)(PTR), START * 4, (END * 4) + 4);
+
+	REG_IGNORE_RANGE(PTR_R0, PTR_R0);
+	REG_IN_RANGE(&regs->r1,PTR_R1, PTR_R7);
+	REG_IN_RANGE(&regs->r8,PTR_R8, PTR_R15);
+	REG_IN_RANGE(sw, PTR_R16, PTR_R23);
+	REG_IGNORE_RANGE(PTR_R24, PTR_R25); /* et and bt */
+	REG_IN_ONE(&regs->gp, PTR_GP);
+	REG_IN_ONE(&regs->sp, PTR_SP);
+	REG_IN_ONE(&regs->fp, PTR_FP);
+	REG_IN_ONE(&regs->ea, PTR_EA);
+	REG_IGNORE_RANGE(PTR_BA, PTR_BA);
+	REG_IN_ONE(&regs->ra, PTR_RA);
+	REG_IN_ONE(&regs->ea, PTR_PC); /* use ea for PC */
+	if (!ret)
+		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					 PTR_STATUS * 4, -1);
+
+	return ret;
+}
+
+/*
+ * Define the register sets available on Nios2 under Linux
+ */
+enum nios2_regset {
+	REGSET_GENERAL,
+};
+
+static const struct user_regset nios2_regsets[] = {
+	[REGSET_GENERAL] = {
+		.core_note_type = NT_PRSTATUS,
+		.n = NUM_PTRACE_REG,
+		.size = sizeof(unsigned long),
+		.align = sizeof(unsigned long),
+		.get = genregs_get,
+		.set = genregs_set,
+	}
+};
+
+static const struct user_regset_view nios2_user_view = {
+	.name = "nios2",
+	.e_machine = ELF_ARCH,
+	.ei_osabi = ELF_OSABI,
+	.regsets = nios2_regsets,
+	.n = ARRAY_SIZE(nios2_regsets)
+};
+
+const struct user_regset_view *task_user_regset_view(struct task_struct *task)
+{
+	return &nios2_user_view;
+}
+
+void ptrace_disable(struct task_struct *child)
+{
+
+}
+
+long arch_ptrace(struct task_struct *child, long request, unsigned long addr,
+		 unsigned long data)
+{
+	return ptrace_request(child, request, addr, data);
+}
+
+asmlinkage int do_syscall_trace_enter(void)
+{
+	int ret = 0;
+
+	if (test_thread_flag(TIF_SYSCALL_TRACE))
+		ret = tracehook_report_syscall_entry(task_pt_regs(current));
+
+	return ret;
+}
+
+asmlinkage void do_syscall_trace_exit(void)
+{
+	if (test_thread_flag(TIF_SYSCALL_TRACE))
+		tracehook_report_syscall_exit(task_pt_regs(current), 0);
+}
-- 
1.8.2.1

