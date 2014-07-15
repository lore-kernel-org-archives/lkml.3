Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbaGOIuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:50:46 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:55311
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758370AbaGOIsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:48:41 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH v2 16/29] nios2: Signal handling support
Date: Tue, 15 Jul 2014 16:45:43 +0800
Message-ID: <1405413956-2772-17-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405413956-2772-1-git-send-email-lftan@altera.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(22564002)(189002)(199002)(84676001)(104166001)(46102001)(76482001)(15202345003)(77156001)(99396002)(97736001)(2201001)(92726001)(92566001)(83322001)(19580395003)(48376002)(68736004)(19580405001)(42186005)(50986999)(6806004)(76176999)(44976005)(87286001)(21056001)(79102001)(77982001)(89996001)(15975445006)(83072002)(85852003)(88136002)(87936001)(36756003)(229853001)(86362001)(93916002)(80022001)(85306003)(47776003)(107046002)(64706001)(20776003)(74502001)(74662001)(50226001)(4396001)(106466001)(102836001)(81342001)(62966002)(31966008)(95666004)(81542001)(77096002)(33646002)(105596002)(2004002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR03MB039;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027367F73D
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for signal handling.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/signal.h          |  22 +++
 arch/nios2/include/asm/ucontext.h        |  34 ++++
 arch/nios2/include/uapi/asm/sigcontext.h |  30 +++
 arch/nios2/include/uapi/asm/signal.h     |  23 +++
 arch/nios2/kernel/signal.c               | 316 +++++++++++++++++++++++++++++++
 5 files changed, 425 insertions(+)
 create mode 100644 arch/nios2/include/asm/signal.h
 create mode 100644 arch/nios2/include/asm/ucontext.h
 create mode 100644 arch/nios2/include/uapi/asm/sigcontext.h
 create mode 100644 arch/nios2/include/uapi/asm/signal.h
 create mode 100644 arch/nios2/kernel/signal.c

diff --git a/arch/nios2/include/asm/signal.h b/arch/nios2/include/asm/signal.h
new file mode 100644
index 0000000..bbcf11e
--- /dev/null
+++ b/arch/nios2/include/asm/signal.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright Altera Corporation (C) 2013. All rights reserved
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+#ifndef _NIOS2_SIGNAL_H
+#define _NIOS2_SIGNAL_H
+
+#include <uapi/asm/signal.h>
+
+#endif	/* _NIOS2_SIGNAL_H */
diff --git a/arch/nios2/include/asm/ucontext.h b/arch/nios2/include/asm/ucontext.h
new file mode 100644
index 0000000..5870ef4
--- /dev/null
+++ b/arch/nios2/include/asm/ucontext.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd
+ *
+ * derived from m68knommu
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_UCONTEXT_H
+#define _ASM_NIOS2_UCONTEXT_H
+
+typedef int greg_t;
+#define NGREG 32
+typedef greg_t gregset_t[NGREG];
+
+struct mcontext {
+	int version;
+	gregset_t gregs;
+};
+
+#define MCONTEXT_VERSION 2
+
+struct ucontext {
+	unsigned long	  uc_flags;
+	struct ucontext  *uc_link;
+	stack_t		  uc_stack;
+	struct mcontext	  uc_mcontext;
+	sigset_t	  uc_sigmask;	/* mask last for extensibility */
+};
+
+#endif
diff --git a/arch/nios2/include/uapi/asm/sigcontext.h b/arch/nios2/include/uapi/asm/sigcontext.h
new file mode 100644
index 0000000..6bfd880
--- /dev/null
+++ b/arch/nios2/include/uapi/asm/sigcontext.h
@@ -0,0 +1,30 @@
+/*
+ * Taken from the m68knommu.
+ *
+ * Copyright (C) 2004, Microtronix Datacom Ltd.
+ *
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ */
+
+#ifndef _ASM_NIOS2_SIGCONTEXT_H
+#define _ASM_NIOS2_SIGCONTEXT_H
+
+#include <asm/ptrace.h>
+
+struct sigcontext {
+	struct pt_regs regs;
+	unsigned long  sc_mask;	/* old sigmask */
+};
+
+#endif
diff --git a/arch/nios2/include/uapi/asm/signal.h b/arch/nios2/include/uapi/asm/signal.h
new file mode 100644
index 0000000..f29ee63
--- /dev/null
+++ b/arch/nios2/include/uapi/asm/signal.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright Altera Corporation (C) 2013. All rights reserved
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+#ifndef _ASM_NIOS2_SIGNAL_H
+#define _ASM_NIOS2_SIGNAL_H
+
+#define SA_RESTORER 0x04000000
+#include <asm-generic/signal.h>
+
+#endif /* _ASM_NIOS2_SIGNAL_H */
diff --git a/arch/nios2/kernel/signal.c b/arch/nios2/kernel/signal.c
new file mode 100644
index 0000000..3f649d8
--- /dev/null
+++ b/arch/nios2/kernel/signal.c
@@ -0,0 +1,316 @@
+/*
+ * Copyright (C) 2013 Altera Corporation
+ * Copyright (C) 2011-2012 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd
+ * Copyright (C) 1991, 1992 Linus Torvalds
+ *
+ * This file is based on kernel/signal.c from m68knommu.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/signal.h>
+#include <linux/errno.h>
+#include <linux/ptrace.h>
+#include <linux/uaccess.h>
+#include <linux/unistd.h>
+#include <linux/personality.h>
+#include <linux/tracehook.h>
+
+#include <asm/ucontext.h>
+#include <asm/cacheflush.h>
+
+#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
+
+static int do_signal(struct pt_regs *regs, int in_syscall);
+
+/*
+ * Do a signal return; undo the signal stack.
+ *
+ * Keep the return code on the stack quadword aligned!
+ * That makes the cache flush below easier.
+ */
+
+struct rt_sigframe {
+	struct siginfo info;
+	struct ucontext uc;
+};
+
+static inline int rt_restore_ucontext(struct pt_regs *regs,
+					struct switch_stack *sw,
+					struct ucontext *uc, int *pr2)
+{
+	int temp;
+	greg_t *gregs = uc->uc_mcontext.gregs;
+	int err;
+
+	err = __get_user(temp, &uc->uc_mcontext.version);
+	if (temp != MCONTEXT_VERSION)
+		goto badframe;
+	/* restore passed registers */
+	err |= __get_user(regs->r1, &gregs[0]);
+	err |= __get_user(regs->r2, &gregs[1]);
+	err |= __get_user(regs->r3, &gregs[2]);
+	err |= __get_user(regs->r4, &gregs[3]);
+	err |= __get_user(regs->r5, &gregs[4]);
+	err |= __get_user(regs->r6, &gregs[5]);
+	err |= __get_user(regs->r7, &gregs[6]);
+	err |= __get_user(regs->r8, &gregs[7]);
+	err |= __get_user(regs->r9, &gregs[8]);
+	err |= __get_user(regs->r10, &gregs[9]);
+	err |= __get_user(regs->r11, &gregs[10]);
+	err |= __get_user(regs->r12, &gregs[11]);
+	err |= __get_user(regs->r13, &gregs[12]);
+	err |= __get_user(regs->r14, &gregs[13]);
+	err |= __get_user(regs->r15, &gregs[14]);
+	err |= __get_user(sw->r16, &gregs[15]);
+	err |= __get_user(sw->r17, &gregs[16]);
+	err |= __get_user(sw->r18, &gregs[17]);
+	err |= __get_user(sw->r19, &gregs[18]);
+	err |= __get_user(sw->r20, &gregs[19]);
+	err |= __get_user(sw->r21, &gregs[20]);
+	err |= __get_user(sw->r22, &gregs[21]);
+	err |= __get_user(sw->r23, &gregs[22]);
+	/* gregs[23] is handled below */
+	err |= __get_user(sw->fp, &gregs[24]);  /* Verify, should this be
+							settable */
+	err |= __get_user(sw->gp, &gregs[25]);  /* Verify, should this be
+							settable */
+
+	err |= __get_user(temp, &gregs[26]);  /* Not really necessary no user
+							settable bits */
+	err |= __get_user(regs->ea, &gregs[27]);
+
+	err |= __get_user(regs->ra, &gregs[23]);
+	err |= __get_user(regs->sp, &gregs[28]);
+
+	regs->estatus = (regs->estatus & 0xffffffff);
+	regs->orig_r2 = -1;		/* disable syscall checks */
+
+	err |= restore_altstack(&uc->uc_stack);
+	if (err)
+		goto badframe;
+
+	*pr2 = regs->r2;
+	return err;
+
+badframe:
+	return 1;
+}
+
+asmlinkage int do_rt_sigreturn(struct switch_stack *sw)
+{
+	struct pt_regs *regs = (struct pt_regs *)(sw + 1);
+	/* Verify, can we follow the stack back */
+	struct rt_sigframe *frame = (struct rt_sigframe *) regs->sp;
+	sigset_t set;
+	int rval;
+
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+
+	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
+		goto badframe;
+
+	sigdelsetmask(&set, ~_BLOCKABLE);
+	spin_lock_irq(&current->sighand->siglock);
+	current->blocked = set;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (rt_restore_ucontext(regs, sw, &frame->uc, &rval))
+		goto badframe;
+
+	return rval;
+
+badframe:
+	force_sig(SIGSEGV, current);
+	return 0;
+}
+
+static inline int rt_setup_ucontext(struct ucontext *uc, struct pt_regs *regs)
+{
+	struct switch_stack *sw = (struct switch_stack *)regs - 1;
+	greg_t *gregs = uc->uc_mcontext.gregs;
+	int err = 0;
+
+	err |= __put_user(MCONTEXT_VERSION, &uc->uc_mcontext.version);
+	err |= __put_user(regs->r1, &gregs[0]);
+	err |= __put_user(regs->r2, &gregs[1]);
+	err |= __put_user(regs->r3, &gregs[2]);
+	err |= __put_user(regs->r4, &gregs[3]);
+	err |= __put_user(regs->r5, &gregs[4]);
+	err |= __put_user(regs->r6, &gregs[5]);
+	err |= __put_user(regs->r7, &gregs[6]);
+	err |= __put_user(regs->r8, &gregs[7]);
+	err |= __put_user(regs->r9, &gregs[8]);
+	err |= __put_user(regs->r10, &gregs[9]);
+	err |= __put_user(regs->r11, &gregs[10]);
+	err |= __put_user(regs->r12, &gregs[11]);
+	err |= __put_user(regs->r13, &gregs[12]);
+	err |= __put_user(regs->r14, &gregs[13]);
+	err |= __put_user(regs->r15, &gregs[14]);
+	err |= __put_user(sw->r16, &gregs[15]);
+	err |= __put_user(sw->r17, &gregs[16]);
+	err |= __put_user(sw->r18, &gregs[17]);
+	err |= __put_user(sw->r19, &gregs[18]);
+	err |= __put_user(sw->r20, &gregs[19]);
+	err |= __put_user(sw->r21, &gregs[20]);
+	err |= __put_user(sw->r22, &gregs[21]);
+	err |= __put_user(sw->r23, &gregs[22]);
+	err |= __put_user(regs->ra, &gregs[23]);
+	err |= __put_user(sw->fp, &gregs[24]);
+	err |= __put_user(sw->gp, &gregs[25]);
+	err |= __put_user(regs->ea, &gregs[27]);
+	err |= __put_user(regs->sp, &gregs[28]);
+	return err;
+}
+
+static inline void push_cache(unsigned long vaddr)
+{
+	flush_dcache_range(vaddr, vaddr + 12);
+	flush_icache_range(vaddr, vaddr + 12);
+}
+
+static inline void *get_sigframe(struct ksignal *ksig, struct pt_regs *regs,
+				 size_t frame_size)
+{
+	unsigned long usp;
+
+	/* Default to using normal stack.  */
+	usp = regs->sp;
+
+	/* This is the X/Open sanctioned signal stack switching.  */
+	usp = sigsp(usp, ksig);
+
+	/* Verify, is it 32 or 64 bit aligned */
+	return (void *)((usp - frame_size) & -8UL);
+}
+
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
+{
+	struct rt_sigframe *frame;
+	int err = 0;
+
+	frame = get_sigframe(ksig, regs, sizeof(*frame));
+
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		err |= copy_siginfo_to_user(&frame->info, &ksig->info);
+
+	/* Create the ucontext.  */
+	err |= __put_user(0, &frame->uc.uc_flags);
+	err |= __put_user(0, &frame->uc.uc_link);
+	err |= __save_altstack(&frame->uc.uc_stack, regs->sp);
+	err |= rt_setup_ucontext(&frame->uc, regs);
+	err |= copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
+	/* Set up to return from userspace; jump to fixed address sigreturn
+	   trampoline on kuser page.  */
+	regs->ra = (unsigned long) (0x1040);
+
+	/* Set up registers for signal handler */
+	regs->sp = (unsigned long) frame;
+	regs->r4 = (unsigned long) ksig->sig;
+	regs->r5 = (unsigned long) &frame->info;
+	regs->r6 = (unsigned long) &frame->uc;
+	regs->ea = (unsigned long) ksig->ka.sa.sa_handler;
+	return 0;
+}
+
+static inline void handle_restart(struct pt_regs *regs, struct k_sigaction *ka,
+				  int has_handler)
+{
+	switch (regs->r2) {
+	case ERESTART_RESTARTBLOCK:
+	case ERESTARTNOHAND:
+		regs->r2 = EINTR;
+		regs->r7 = 1;
+		break;
+	case ERESTARTSYS:
+		if (has_handler && !(ka->sa.sa_flags & SA_RESTART)) {
+			regs->r2 = EINTR;
+			regs->r7 = 1;
+			break;
+		}
+	/* fallthrough */
+	case ERESTARTNOINTR:
+		regs->r2 = regs->orig_r2;
+		regs->r7 = regs->orig_r7;
+		regs->ea -= 4;
+		break;
+	}
+}
+
+/*
+ * OK, we're invoking a handler
+ */
+static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
+{
+	int ret;
+	sigset_t *oldset = sigmask_to_save();
+
+	/* set up the stack frame */
+	ret = setup_rt_frame(ksig, oldset, regs);
+
+	signal_setup_done(ret, ksig, 0);
+}
+
+static int do_signal(struct pt_regs *regs, int in_syscall)
+{
+	struct ksignal ksig;
+
+	current->thread.kregs = regs;
+
+	if (get_signal(&ksig)) {
+		/*
+		 * Are we from a system call? If so, check system call
+		 * restarting.
+		 */
+		if (in_syscall)
+			handle_restart(regs, &ksig.ka, 1);
+		/* Whee!  Actually deliver the signal.  */
+		handle_signal(&ksig, regs);
+		return 1;
+	}
+
+	/*
+	 * No signal to deliver to the process - restart the syscall.
+	 */
+	if (in_syscall) {
+		/* Did the syscall return an error code */
+		if (regs->r7 == 1) {
+			if (regs->r2 == ERESTARTNOHAND ||
+				regs->r2 == ERESTARTSYS ||
+				regs->r2 == ERESTARTNOINTR) {
+				regs->r2 = regs->orig_r2;
+				regs->r7 = regs->orig_r7;
+				regs->ea -= 4;
+			} else if (regs->r2 == ERESTART_RESTARTBLOCK) {
+				regs->r2 = __NR_restart_syscall;
+				regs->ea -= 4;
+			}
+		}
+	}
+
+	return 0;
+}
+
+asmlinkage void do_notify_resume(struct pt_regs *regs, int in_syscall)
+{
+	/*
+	 * We want the common case to go fast, which is why we may in certain
+	 * cases get here from kernel mode. Just return without doing anything
+	 * if so.
+	 */
+	if (!user_mode(regs))
+		return;
+
+	if (test_thread_flag(TIF_SIGPENDING))
+		do_signal(regs, in_syscall);
+
+	if (test_and_clear_thread_flag(TIF_NOTIFY_RESUME))
+		tracehook_notify_resume(regs);
+}
-- 
1.8.2.1

