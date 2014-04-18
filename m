Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaDRMpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:45:52 -0400
Received: from mail-bn1on0133.outbound.protection.outlook.com ([157.56.110.133]:52775
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753374AbaDRMoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:44:05 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH 25/28] nios2: ptrace support
Date: Fri, 18 Apr 2014 20:27:08 +0800
Message-ID: <1397824031-4892-22-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397824031-4892-1-git-send-email-lftan@altera.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(22564002)(199002)(189002)(16796002)(31966008)(74662001)(74502001)(20776003)(76176999)(46102001)(77156001)(36756003)(77982001)(47776003)(19580405001)(83322001)(76482001)(6806004)(44976005)(19580395003)(42186004)(50226001)(4396001)(2009001)(62966002)(84676001)(81542001)(92726001)(92566001)(2201001)(80022001)(93916002)(86362001)(80976001)(48376002)(97736001)(50466002)(87286001)(81342001)(87936001)(89996001)(85852003)(83072002)(99396002)(50986999)(88136002)(21314002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB039;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:D0A95856.ACA6DF5D.F0FA551D.8D453F1.20701;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 018577E36E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ptrace support for nios2.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/ptrace.h      |  40 +++++++
 arch/nios2/include/uapi/asm/ptrace.h | 123 ++++++++++++++++++++++
 arch/nios2/kernel/ptrace.c           | 198 +++++++++++++++++++++++++++++++++++
 3 files changed, 361 insertions(+)
 create mode 100644 arch/nios2/include/asm/ptrace.h
 create mode 100644 arch/nios2/include/uapi/asm/ptrace.h
 create mode 100644 arch/nios2/kernel/ptrace.c

diff --git a/arch/nios2/include/asm/ptrace.h b/arch/nios2/include/asm/ptrace.h
new file mode 100644
index 0000000..ca8588ed8c32eff5ed081c21c55fc142bb16f151
--- /dev/null
+++ b/arch/nios2/include/asm/ptrace.h
@@ -0,0 +1,40 @@
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
+
+/* Arbitrarily choose the same ptrace numbers as used by the Sparc code. */
+#define PTRACE_GETREGS		12
+#define PTRACE_SETREGS		13
+
+/*
+ * Supervisor mode
+ */
+
+# define user_mode(regs)	(((regs)->estatus & ESTATUS_EU))
+
+
+#define instruction_pointer(regs)	((regs)->ra)
+#define profile_pc(regs)		instruction_pointer(regs)
+#define user_stack_pointer(regs)	((regs)->sp)
+extern void show_regs(struct pt_regs *);
+
+#define current_pt_regs() \
+	((struct pt_regs *)((unsigned long)current_thread_info() + THREAD_SIZE)\
+		- 1)
+#endif /* __ASSEMBLY__ */
+#endif /* _ASM_NIOS2_PTRACE_H */
diff --git a/arch/nios2/include/uapi/asm/ptrace.h b/arch/nios2/include/uapi/asm/ptrace.h
new file mode 100644
index 0000000..e37ca15350ea60e8eb7f73b5dad331886abb5e31
--- /dev/null
+++ b/arch/nios2/include/uapi/asm/ptrace.h
@@ -0,0 +1,123 @@
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
+/* Text/data offsets, needed by gdbserver */
+#define PT_TEXT_ADDR		(44*4)
+#define PT_TEXT_END_ADDR	(45*4)
+#define PT_DATA_ADDR		(46*4)
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
index 0000000..5db61796b2c11532dd6219a972331d9c09f5c30a
--- /dev/null
+++ b/arch/nios2/kernel/ptrace.c
@@ -0,0 +1,198 @@
+/*
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ *
+ * based on arch/m68knommu/kernel/ptrace.c
+ *
+ * Copyright (C) 1994 by Hamish Macdonald
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License.  See the file COPYING in the main directory of this
+ * archive for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/errno.h>
+#include <linux/ptrace.h>
+#include <linux/user.h>
+
+#include <linux/uaccess.h>
+
+/*
+ * does not yet catch signals sent when the child dies.
+ * in exit.c or in signal.c.
+ */
+
+/* determines which bits in the SR the user has access to. */
+/* 1 = access 0 = no access */
+#define SR_MASK 0x00000000
+
+/* Find the stack offset for a register, relative to thread.ksp. */
+#define PT_REG(reg)	((long)&((struct pt_regs *)0)->reg)
+#define SW_REG(reg)	((long)&((struct switch_stack *)0)->reg \
+			 - sizeof(struct switch_stack))
+
+/* Mapping from PT_xxx to the stack offset at which the register is
+ * saved.
+ */
+static int regoff[] = {
+		-1, PT_REG(r1), PT_REG(r2), PT_REG(r3),
+	PT_REG(r4), PT_REG(r5), PT_REG(r6), PT_REG(r7),
+	PT_REG(r8), PT_REG(r9), PT_REG(r10), PT_REG(r11),
+	PT_REG(r12), PT_REG(r13), PT_REG(r14), PT_REG(r15),  /* reg 15 */
+	SW_REG(r16), SW_REG(r17), SW_REG(r18), SW_REG(r19),
+	SW_REG(r20), SW_REG(r21), SW_REG(r22), SW_REG(r23),
+		-1,          -1, PT_REG(gp), PT_REG(sp),
+	PT_REG(fp), PT_REG(ea),          -1, PT_REG(ra),  /* reg 31 */
+	PT_REG(ea),          -1,          -1,          -1,  /* use ea for pc */
+		-1,          -1,          -1,          -1,
+		-1,          -1,          -1,          -1   /* reg 43 */
+};
+
+/*
+ * Get contents of register REGNO in task TASK.
+ */
+static inline long get_reg(struct task_struct *task, int regno)
+{
+	unsigned long *addr;
+
+	if (regno >= ARRAY_SIZE(regoff) || regoff[regno] == -1)
+		return 0;
+
+	addr = (unsigned long *)((char *)task->thread.kregs + regoff[regno]);
+	return *addr;
+}
+
+/*
+ * Write contents of register REGNO in task TASK.
+ */
+static inline int put_reg(struct task_struct *task, int regno,
+			  unsigned long data)
+{
+	unsigned long *addr;
+
+	if (regno >= ARRAY_SIZE(regoff) || regoff[regno] == -1)
+		return -1;
+
+	addr = (unsigned long *)((char *)task->thread.kregs + regoff[regno]);
+	*addr = data;
+	return 0;
+}
+
+/*
+ * Called by kernel/ptrace.c when detaching..
+ *
+ * Nothing special to do here, no processor debug support.
+ */
+void ptrace_disable(struct task_struct *child)
+{
+}
+
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
+{
+	unsigned long tmp;
+	unsigned int i;
+	int ret;
+
+	switch (request) {
+	/* read the word at location addr in the USER area. */
+	case PTRACE_PEEKUSR:
+		pr_debug("PEEKUSR: addr=0x%08lx\n", addr);
+		ret = -EIO;
+		if (addr & 3)
+			break;
+
+		addr = addr >> 2; /* temporary hack. */
+		ret = -EIO;
+		if (addr < ARRAY_SIZE(regoff))
+			tmp = get_reg(child, addr);
+		else if (addr == PT_TEXT_ADDR / 4)
+			tmp = child->mm->start_code;
+		else if (addr == PT_DATA_ADDR / 4)
+			tmp = child->mm->start_data;
+		else if (addr == PT_TEXT_END_ADDR / 4)
+			tmp = child->mm->end_code;
+		else
+			break;
+		ret = put_user(tmp, (unsigned long *) data);
+		pr_debug("PEEKUSR: rdword=0x%08lx\n", tmp);
+		break;
+	/* write the word at location addr in the USER area */
+	case PTRACE_POKEUSR:
+		pr_debug("POKEUSR: addr=0x%08lx, data=0x%08lx\n", addr, data);
+		ret = -EIO;
+		if (addr & 3)
+			break;
+
+		addr = addr >> 2; /* temporary hack. */
+
+		if (addr == PTR_ESTATUS) {
+			data &= SR_MASK;
+			data |= get_reg(child, PTR_ESTATUS) & ~(SR_MASK);
+		}
+		if (addr < ARRAY_SIZE(regoff)) {
+			if (put_reg(child, addr, data))
+				break;
+			ret = 0;
+			break;
+		}
+		break;
+	 /* Get all gp regs from the child. */
+	case PTRACE_GETREGS:
+		pr_debug("GETREGS\n");
+		for (i = 0; i < ARRAY_SIZE(regoff); i++) {
+			tmp = get_reg(child, i);
+			if (put_user(tmp, (unsigned long *) data)) {
+				ret = -EFAULT;
+				break;
+			}
+			data += sizeof(long);
+		}
+		ret = 0;
+		break;
+	/* Set all gp regs in the child. */
+	case PTRACE_SETREGS:
+		pr_debug("SETREGS\n");
+		for (i = 0; i < ARRAY_SIZE(regoff); i++) {
+			if (get_user(tmp, (unsigned long *) data)) {
+				ret = -EFAULT;
+				break;
+			}
+			if (i == PTR_ESTATUS) {
+				tmp &= SR_MASK;
+				tmp |= get_reg(child, PTR_ESTATUS) & ~(SR_MASK);
+			}
+			put_reg(child, i, tmp);
+			data += sizeof(long);
+		}
+		ret = 0;
+		break;
+	default:
+		ret = ptrace_request(child, request, addr, data);
+	}
+
+	return ret;
+}
+
+asmlinkage void syscall_trace(void)
+{
+	if (!test_thread_flag(TIF_SYSCALL_TRACE))
+		return;
+	if (!(current->ptrace & PT_PTRACED))
+		return;
+	current->exit_code = SIGTRAP;
+	current->state = TASK_STOPPED;
+	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
+				 ? 0x80 : 0));
+	/*
+	 * this isn't the same as continuing with a signal, but it will do
+	 * for normal use.  strace only continues with a signal if the
+	 * stopping signal is not SIGTRAP.  -brl
+	 */
+	if (current->exit_code) {
+		send_sig(current->exit_code, current, 1);
+		current->exit_code = 0;
+	}
+}
-- 
1.8.3.2

