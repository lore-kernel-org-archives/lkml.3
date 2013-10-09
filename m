Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab3JIAOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 20:14:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60558 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab3JIAOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 20:14:18 -0400
Date: Wed, 09 Oct 2013 01:14:17 +0100
To: torvalds@linux-foundation.org
Subject: [RFC][PATCH 01/13] restore 32bit aout coredump
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VThPt-0002vO-Lm@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


just getting rid of bitrot

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/ia32/ia32_aout.c |   70 +++++++++++++++++++++++----------------------
 1 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index bae3aba..80361c0 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -25,6 +25,7 @@
 #include <linux/personality.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
+#include <linux/perf_event.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
@@ -33,14 +34,18 @@
 #include <asm/ia32.h>
 
 #undef WARN_OLD
-#undef CORE_DUMP /* definitely broken */
 
 static int load_aout_binary(struct linux_binprm *);
 static int load_aout_library(struct file *);
 
-#ifdef CORE_DUMP
-static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file,
-			  unsigned long limit);
+#ifdef CONFIG_COREDUMP
+static int aout_core_dump(struct coredump_params *);
+
+static unsigned long get_dr(int n)
+{
+	struct perf_event *bp = current->thread.ptrace_bps[n];
+	return bp ? bp->hw.info.address : 0;
+}
 
 /*
  * fill in the user structure for a core dump..
@@ -48,6 +53,7 @@ static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file,
 static void dump_thread32(struct pt_regs *regs, struct user32 *dump)
 {
 	u32 fs, gs;
+	memset(dump, 0, sizeof(*dump));
 
 /* changed the size calculations - should hopefully work better. lbt */
 	dump->magic = CMAGIC;
@@ -57,15 +63,12 @@ static void dump_thread32(struct pt_regs *regs, struct user32 *dump)
 	dump->u_dsize = ((unsigned long)
 			 (current->mm->brk + (PAGE_SIZE-1))) >> PAGE_SHIFT;
 	dump->u_dsize -= dump->u_tsize;
-	dump->u_ssize = 0;
-	dump->u_debugreg[0] = current->thread.debugreg0;
-	dump->u_debugreg[1] = current->thread.debugreg1;
-	dump->u_debugreg[2] = current->thread.debugreg2;
-	dump->u_debugreg[3] = current->thread.debugreg3;
-	dump->u_debugreg[4] = 0;
-	dump->u_debugreg[5] = 0;
+	dump->u_debugreg[0] = get_dr(0);
+	dump->u_debugreg[1] = get_dr(1);
+	dump->u_debugreg[2] = get_dr(2);
+	dump->u_debugreg[3] = get_dr(3);
 	dump->u_debugreg[6] = current->thread.debugreg6;
-	dump->u_debugreg[7] = current->thread.debugreg7;
+	dump->u_debugreg[7] = current->thread.ptrace_dr7;
 
 	if (dump->start_stack < 0xc0000000) {
 		unsigned long tmp;
@@ -74,24 +77,24 @@ static void dump_thread32(struct pt_regs *regs, struct user32 *dump)
 		dump->u_ssize = tmp >> PAGE_SHIFT;
 	}
 
-	dump->regs.bx = regs->bx;
-	dump->regs.cx = regs->cx;
-	dump->regs.dx = regs->dx;
-	dump->regs.si = regs->si;
-	dump->regs.di = regs->di;
-	dump->regs.bp = regs->bp;
-	dump->regs.ax = regs->ax;
+	dump->regs.ebx = regs->bx;
+	dump->regs.ecx = regs->cx;
+	dump->regs.edx = regs->dx;
+	dump->regs.esi = regs->si;
+	dump->regs.edi = regs->di;
+	dump->regs.ebp = regs->bp;
+	dump->regs.eax = regs->ax;
 	dump->regs.ds = current->thread.ds;
 	dump->regs.es = current->thread.es;
 	savesegment(fs, fs);
 	dump->regs.fs = fs;
 	savesegment(gs, gs);
 	dump->regs.gs = gs;
-	dump->regs.orig_ax = regs->orig_ax;
-	dump->regs.ip = regs->ip;
+	dump->regs.orig_eax = regs->orig_ax;
+	dump->regs.eip = regs->ip;
 	dump->regs.cs = regs->cs;
-	dump->regs.flags = regs->flags;
-	dump->regs.sp = regs->sp;
+	dump->regs.eflags = regs->flags;
+	dump->regs.esp = regs->sp;
 	dump->regs.ss = regs->ss;
 
 #if 1 /* FIXME */
@@ -107,7 +110,7 @@ static struct linux_binfmt aout_format = {
 	.module		= THIS_MODULE,
 	.load_binary	= load_aout_binary,
 	.load_shlib	= load_aout_library,
-#ifdef CORE_DUMP
+#ifdef CONFIG_COREDUMP
 	.core_dump	= aout_core_dump,
 #endif
 	.min_coredump	= PAGE_SIZE
@@ -122,7 +125,7 @@ static void set_brk(unsigned long start, unsigned long end)
 	vm_brk(start, end - start);
 }
 
-#ifdef CORE_DUMP
+#ifdef CONFIG_COREDUMP
 /*
  * These are the only things you should do on a core-file: use only these
  * macros to write out all the necessary info.
@@ -131,14 +134,14 @@ static void set_brk(unsigned long start, unsigned long end)
 #include <linux/coredump.h>
 
 #define DUMP_WRITE(addr, nr)			     \
-	if (!dump_write(file, (void *)(addr), (nr))) \
+	if (!dump_write(cprm->file, (void *)(addr), (nr))) \
 		goto end_coredump;
 
 #define DUMP_SEEK(offset)		\
-	if (!dump_seek(file, offset))	\
+	if (!dump_seek(cprm->file, offset))	\
 		goto end_coredump;
 
-#define START_DATA()	(u.u_tsize << PAGE_SHIFT)
+#define START_DATA(u)	(u.u_tsize << PAGE_SHIFT)
 #define START_STACK(u)	(u.start_stack)
 
 /*
@@ -151,8 +154,7 @@ static void set_brk(unsigned long start, unsigned long end)
  * dumping of the process results in another error..
  */
 
-static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file,
-			  unsigned long limit)
+static int aout_core_dump(struct coredump_params *cprm)
 {
 	mm_segment_t fs;
 	int has_dumped = 0;
@@ -164,19 +166,19 @@ static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file,
 	has_dumped = 1;
 	strncpy(dump.u_comm, current->comm, sizeof(current->comm));
 	dump.u_ar0 = offsetof(struct user32, regs);
-	dump.signal = signr;
-	dump_thread32(regs, &dump);
+	dump.signal = cprm->siginfo->si_signo;
+	dump_thread32(cprm->regs, &dump);
 
 	/*
 	 * If the size of the dump file exceeds the rlimit, then see
 	 * what would happen if we wrote the stack, but not the data
 	 * area.
 	 */
-	if ((dump.u_dsize + dump.u_ssize + 1) * PAGE_SIZE > limit)
+	if ((dump.u_dsize + dump.u_ssize + 1) * PAGE_SIZE > cprm->limit)
 		dump.u_dsize = 0;
 
 	/* Make sure we have enough room to write the stack and data areas. */
-	if ((dump.u_ssize + 1) * PAGE_SIZE > limit)
+	if ((dump.u_ssize + 1) * PAGE_SIZE > cprm->limit)
 		dump.u_ssize = 0;
 
 	/* make sure we actually have a data and stack area to dump */
-- 
1.7.2.5


