Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763257Ab3DCTQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:16:15 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:37941 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763014Ab3DCTQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:16:10 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org
Cc: rth@twiddle.net, linux@arm.linux.org.uk, msalter@redhat.com,
        starvik@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        benh@kernel.crashing.org, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu, ralf@linux-mips.org,
        jonas@southpole.se, rkuo@codeaurora.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, davem@davemloft.net, lethal@linux-sh.org,
        vgupta@synopsys.com, chris@zankel.net, cmetcalf@tilera.com,
        ysato@users.sourceforge.jp, gxt@mprc.pku.edu.cn, jdike@addtoit.com,
        Tejun Heo <tj@kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-s390@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 3/7] dump_stack: consolidate dump_stack() implementations and unify their behaviors
Date: Wed,  3 Apr 2013 12:14:53 -0700
Message-Id: <1365016497-32033-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365016497-32033-1-git-send-email-tj@kernel.org>
References: <1365016497-32033-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both dump_stack() and show_stack() are currently implemented by each
architecture.  show_stack(NULL, NULL) dumps the backtrace for the
current task as does dump_stack().  On some archs, dump_stack() prints
extra information - pid, utsname and so on - in addition to the
backtrace while the two are identical on other archs.

The usages in arch-independent code of the two functions indicate
show_stack(NULL, NULL) should print out bare backtrace while
dump_stack() is used for debugging purposes when something went wrong,
so it does make sense to print additional information on the task
which triggered dump_stack().

There's no reason to require archs to implement two separate but
mostly identical functions.  It leads to unnecessary subtle
differences among archs and makes it very tedius to add generic debug
information.

This patch expands the dummy fallback dump_stack() implementation in
lib/dump_stack.c such that it prints out debug information (taken from
x86) and invokes show_stack(NULL, NULL) and drops arch-specific
dump_stack() implementations in all archs except blackfin.  Blackfin's
dump_stack() does something wonky that I don't understand.

Debug information can be printed separately by calling
dump_stack_print_info() so that arch-specific dump_stack()
implementation can still emit the same debug information.  This is
used in blackfin.

This patch brings the following behavior changes.

* On some archs, an extra level in backtrace for show_stack() could be
  printed.  This is because the top frame was determined in
  dump_stack() on those archs while generic dump_stack() can't do that
  reliably.  It can be compensated by inlining dump_stack() but not
  sure whether that'd be necessary.

* Most archs didn't use to print debug info on dump_stack().  They do
  now.

An example WARN dump follows.

 WARNING: at /work/os/work/kernel/workqueue.c:4841 init_workqueues+0x35/0x505()
 Hardware name: empty
 Modules linked in:
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0-rc1-work+ #9
  0000000000000009 ffff88007c861e08 ffffffff81c614dc ffff88007c861e48
  ffffffff8108f50f ffffffff82228240 0000000000000040 ffffffff8234a03c
  0000000000000000 0000000000000000 0000000000000000 ffff88007c861e58
 Call Trace:
  [<ffffffff81c614dc>] dump_stack+0x19/0x1b
  [<ffffffff8108f50f>] warn_slowpath_common+0x7f/0xc0
  [<ffffffff8108f56a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff8234a071>] init_workqueues+0x35/0x505
  ...

v2: CPU number added to the generic debug info as requested by s390
    folks and dropped the s390 specific dump_stack().  This loses %ksp
    from the debug message which the maintainers think isn't important
    enough to keep the s390-specific dump_stack() implementation.

    dump_stack_print_info() is moved to kernel/printk.c from
    lib/dump_stack.c.  Because linkage is per objecct file,
    dump_stack_print_info() living in the same lib file as generic
    dump_stack() means that archs which implement custom dump_stack()
    - at this point, only blackfin - can't use dump_stack_print_info()
    as that will bring in the generic version of dump_stack() too.  v1
    The v1 patch broke build on blackfin due to this issue.  The build
    breakage was reported by Fengguang Wu.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Cc: Fengguang Wu <fengguang.wu@intel.com>
---
 arch/alpha/kernel/traps.c        |  7 -------
 arch/arc/kernel/stacktrace.c     |  7 -------
 arch/arm/kernel/traps.c          |  7 -------
 arch/arm64/kernel/traps.c        |  7 -------
 arch/avr32/kernel/process.c      |  8 --------
 arch/blackfin/kernel/dumpstack.c |  1 +
 arch/c6x/kernel/traps.c          |  9 ---------
 arch/cris/kernel/traps.c         |  7 -------
 arch/frv/kernel/traps.c          | 11 -----------
 arch/h8300/kernel/traps.c        |  7 -------
 arch/hexagon/kernel/traps.c      |  8 --------
 arch/ia64/kernel/process.c       |  8 --------
 arch/m32r/kernel/traps.c         |  9 ---------
 arch/m68k/kernel/traps.c         | 12 ------------
 arch/metag/kernel/traps.c        |  6 ------
 arch/microblaze/kernel/traps.c   |  6 ------
 arch/mips/kernel/traps.c         | 13 -------------
 arch/mn10300/kernel/traps.c      | 11 -----------
 arch/openrisc/kernel/traps.c     | 11 -----------
 arch/parisc/kernel/traps.c       |  8 --------
 arch/powerpc/kernel/process.c    |  6 ------
 arch/s390/kernel/dumpstack.c     | 17 -----------------
 arch/score/kernel/traps.c        | 10 ----------
 arch/sh/kernel/dumpstack.c       |  6 ------
 arch/sparc/kernel/process_32.c   |  7 -------
 arch/sparc/kernel/traps_64.c     |  7 -------
 arch/um/kernel/sysrq.c           | 12 ------------
 arch/unicore32/kernel/traps.c    |  6 ------
 arch/x86/kernel/dumpstack.c      | 18 ------------------
 arch/xtensa/kernel/traps.c       |  8 --------
 include/linux/printk.h           |  5 +++++
 kernel/printk.c                  | 18 ++++++++++++++++++
 lib/dump_stack.c                 | 11 ++++++++---
 33 files changed, 32 insertions(+), 262 deletions(-)

diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index 4037461..affccb9 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -169,13 +169,6 @@ void show_stack(struct task_struct *task, unsigned long *sp)
 	dik_show_trace(sp);
 }
 
-void dump_stack(void)
-{
-	show_stack(NULL, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 void
 die_if_kernel(char * str, struct pt_regs *regs, long err, unsigned long *r9_15)
 {
diff --git a/arch/arc/kernel/stacktrace.c b/arch/arc/kernel/stacktrace.c
index a63ff84..ca0207b 100644
--- a/arch/arc/kernel/stacktrace.c
+++ b/arch/arc/kernel/stacktrace.c
@@ -220,13 +220,6 @@ void show_stack(struct task_struct *tsk, unsigned long *sp)
 	show_stacktrace(tsk, NULL);
 }
 
-/* Expected by Rest of kernel code */
-void dump_stack(void)
-{
-	show_stacktrace(NULL, NULL);
-}
-EXPORT_SYMBOL(dump_stack);
-
 /* Another API expected by schedular, shows up in "ps" as Wait Channel
  * Ofcourse just returning schedule( ) would be pointless so unwind until
  * the function is not in schedular code
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 1c08911..18b32e8 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -204,13 +204,6 @@ static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 }
 #endif
 
-void dump_stack(void)
-{
-	dump_backtrace(NULL, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 void show_stack(struct task_struct *tsk, unsigned long *sp)
 {
 	dump_backtrace(NULL, tsk);
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index b3c5f62..61d7dd2 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -167,13 +167,6 @@ static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 	}
 }
 
-void dump_stack(void)
-{
-	dump_backtrace(NULL, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 void show_stack(struct task_struct *tsk, unsigned long *sp)
 {
 	dump_backtrace(NULL, tsk);
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index fd78f58..c1cafdb 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -213,14 +213,6 @@ void show_stack(struct task_struct *tsk, unsigned long *stack)
 	show_stack_log_lvl(tsk, (unsigned long)stack, NULL, "");
 }
 
-void dump_stack(void)
-{
-	unsigned long stack;
-
-	show_trace_log_lvl(current, &stack, NULL, "");
-}
-EXPORT_SYMBOL(dump_stack);
-
 static const char *cpu_modes[] = {
 	"Application", "Supervisor", "Interrupt level 0", "Interrupt level 1",
 	"Interrupt level 2", "Interrupt level 3", "Exception", "NMI"
diff --git a/arch/blackfin/kernel/dumpstack.c b/arch/blackfin/kernel/dumpstack.c
index 5cfbaa2..95ba6d9 100644
--- a/arch/blackfin/kernel/dumpstack.c
+++ b/arch/blackfin/kernel/dumpstack.c
@@ -168,6 +168,7 @@ void dump_stack(void)
 #endif
 	trace_buffer_save(tflags);
 	dump_bfin_trace_buffer();
+	dump_stack_print_info(KERN_DEFAULT);
 	show_stack(current, &stack);
 	trace_buffer_restore(tflags);
 }
diff --git a/arch/c6x/kernel/traps.c b/arch/c6x/kernel/traps.c
index 1be74e5..d0b96ef 100644
--- a/arch/c6x/kernel/traps.c
+++ b/arch/c6x/kernel/traps.c
@@ -67,15 +67,6 @@ void show_regs(struct pt_regs *regs)
 	pr_err("A31: %08lx  B31: %08lx\n", regs->a31, regs->b31);
 }
 
-void dump_stack(void)
-{
-	unsigned long stack;
-
-	show_stack(current, &stack);
-}
-EXPORT_SYMBOL(dump_stack);
-
-
 void die(char *str, struct pt_regs *fp, int nr)
 {
 	console_verbose();
diff --git a/arch/cris/kernel/traps.c b/arch/cris/kernel/traps.c
index a11ad32..0ffda73 100644
--- a/arch/cris/kernel/traps.c
+++ b/arch/cris/kernel/traps.c
@@ -147,13 +147,6 @@ show_stack(void)
 #endif
 
 void
-dump_stack(void)
-{
-	show_stack(NULL, NULL);
-}
-EXPORT_SYMBOL(dump_stack);
-
-void
 set_nmi_handler(void (*handler)(struct pt_regs *))
 {
 	nmi_handler = handler;
diff --git a/arch/frv/kernel/traps.c b/arch/frv/kernel/traps.c
index 5cfd142..cfcd802 100644
--- a/arch/frv/kernel/traps.c
+++ b/arch/frv/kernel/traps.c
@@ -466,17 +466,6 @@ asmlinkage void compound_exception(unsigned long esfr1,
 	BUG();
 } /* end compound_exception() */
 
-/*****************************************************************************/
-/*
- * The architecture-independent backtrace generator
- */
-void dump_stack(void)
-{
-	show_stack(NULL, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 void show_stack(struct task_struct *task, unsigned long *sp)
 {
 }
diff --git a/arch/h8300/kernel/traps.c b/arch/h8300/kernel/traps.c
index 7833aa3..cfe494d 100644
--- a/arch/h8300/kernel/traps.c
+++ b/arch/h8300/kernel/traps.c
@@ -164,10 +164,3 @@ void show_trace_task(struct task_struct *tsk)
 {
 	show_stack(tsk,(unsigned long *)tsk->thread.esp0);
 }
-
-void dump_stack(void)
-{
-	show_stack(NULL,NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
diff --git a/arch/hexagon/kernel/traps.c b/arch/hexagon/kernel/traps.c
index aaf53f8..7858663 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -195,14 +195,6 @@ void show_stack(struct task_struct *task, unsigned long *fp)
 	do_show_stack(task, fp, 0);
 }
 
-void dump_stack(void)
-{
-	unsigned long *fp;
-	asm("%0 = r30" : "=r" (fp));
-	show_stack(current, fp);
-}
-EXPORT_SYMBOL(dump_stack);
-
 int die(const char *str, struct pt_regs *regs, long err)
 {
 	static struct {
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 6f7dc8b..87c7a26 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -96,14 +96,6 @@ show_stack (struct task_struct *task, unsigned long *sp)
 }
 
 void
-dump_stack (void)
-{
-	show_stack(NULL, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
-void
 show_regs (struct pt_regs *regs)
 {
 	unsigned long ip = regs->cr_iip + ia64_psr(regs)->ri;
diff --git a/arch/m32r/kernel/traps.c b/arch/m32r/kernel/traps.c
index 3bcb207..5623ea3 100644
--- a/arch/m32r/kernel/traps.c
+++ b/arch/m32r/kernel/traps.c
@@ -169,15 +169,6 @@ void show_stack(struct task_struct *task, unsigned long *sp)
 	show_trace(task, sp);
 }
 
-void dump_stack(void)
-{
-	unsigned long stack;
-
-	show_trace(current, &stack);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 static void show_registers(struct pt_regs *regs)
 {
 	int i = 0;
diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index f32ab22..88fcd8c 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -992,18 +992,6 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 }
 
 /*
- * The architecture-independent backtrace generator
- */
-void dump_stack(void)
-{
-	unsigned long stack;
-
-	show_trace(&stack);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
-/*
  * The vector number returned in the frame pointer may also contain
  * the "fs" (Fault Status) bits on ColdFire. These are in the bottom
  * 2 bits, and upper 2 bits. So we need to mask out the real vector
diff --git a/arch/metag/kernel/traps.c b/arch/metag/kernel/traps.c
index 8961f24..2ceeaae 100644
--- a/arch/metag/kernel/traps.c
+++ b/arch/metag/kernel/traps.c
@@ -987,9 +987,3 @@ void show_stack(struct task_struct *tsk, unsigned long *sp)
 
 	show_trace(tsk, sp, NULL);
 }
-
-void dump_stack(void)
-{
-	show_stack(NULL, NULL);
-}
-EXPORT_SYMBOL(dump_stack);
diff --git a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
index 30e6b50..cb61953 100644
--- a/arch/microblaze/kernel/traps.c
+++ b/arch/microblaze/kernel/traps.c
@@ -75,9 +75,3 @@ void show_stack(struct task_struct *task, unsigned long *sp)
 
 	debug_show_held_locks(task);
 }
-
-void dump_stack(void)
-{
-	show_stack(NULL, NULL);
-}
-EXPORT_SYMBOL(dump_stack);
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 59351e5..d2a31ac 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -206,19 +206,6 @@ void show_stack(struct task_struct *task, unsigned long *sp)
 	show_stacktrace(task, &regs);
 }
 
-/*
- * The architecture-independent dump_stack generator
- */
-void dump_stack(void)
-{
-	struct pt_regs regs;
-
-	prepare_frametrace(&regs);
-	show_backtrace(current, &regs);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 static void show_code(unsigned int __user *pc)
 {
 	long i;
diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index b900e5a..a7a987c 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -294,17 +294,6 @@ void show_stack(struct task_struct *task, unsigned long *sp)
 }
 
 /*
- * the architecture-independent dump_stack generator
- */
-void dump_stack(void)
-{
-	unsigned long stack;
-
-	show_stack(current, &stack);
-}
-EXPORT_SYMBOL(dump_stack);
-
-/*
  * dump the register file in the specified exception frame
  */
 void show_registers_only(struct pt_regs *regs)
diff --git a/arch/openrisc/kernel/traps.c b/arch/openrisc/kernel/traps.c
index 5cce396..3d3f606 100644
--- a/arch/openrisc/kernel/traps.c
+++ b/arch/openrisc/kernel/traps.c
@@ -105,17 +105,6 @@ void show_trace_task(struct task_struct *tsk)
 	 */
 }
 
-/*
- * The architecture-independent backtrace generator
- */
-void dump_stack(void)
-{
-	unsigned long stack;
-
-	show_stack(current, &stack);
-}
-EXPORT_SYMBOL(dump_stack);
-
 void show_registers(struct pt_regs *regs)
 {
 	int i;
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index aeb8f8f..e64cf5f 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -158,14 +158,6 @@ void show_regs(struct pt_regs *regs)
 	}
 }
 
-
-void dump_stack(void)
-{
-	show_stack(NULL, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 static void do_show_stack(struct unwind_frame_info *info)
 {
 	int i = 1;
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 59dd545..2e6f83a 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1360,12 +1360,6 @@ void show_stack(struct task_struct *tsk, unsigned long *stack)
 	} while (count++ < kstack_depth_to_print);
 }
 
-void dump_stack(void)
-{
-	show_stack(current, NULL);
-}
-EXPORT_SYMBOL(dump_stack);
-
 #ifdef CONFIG_PPC64
 /* Called with hard IRQs off */
 void __ppc64_runlatch_on(void)
diff --git a/arch/s390/kernel/dumpstack.c b/arch/s390/kernel/dumpstack.c
index 03dce39..2f1f639 100644
--- a/arch/s390/kernel/dumpstack.c
+++ b/arch/s390/kernel/dumpstack.c
@@ -129,23 +129,6 @@ static void show_last_breaking_event(struct pt_regs *regs)
 #endif
 }
 
-/*
- * The architecture-independent dump_stack generator
- */
-void dump_stack(void)
-{
-	printk("CPU: %d %s %s %.*s\n",
-	       task_thread_info(current)->cpu, print_tainted(),
-	       init_utsname()->release,
-	       (int)strcspn(init_utsname()->version, " "),
-	       init_utsname()->version);
-	printk("Process %s (pid: %d, task: %p, ksp: %p)\n",
-	       current->comm, current->pid, current,
-	       (void *) current->thread.ksp);
-	show_stack(NULL, NULL);
-}
-EXPORT_SYMBOL(dump_stack);
-
 static inline int mask_bits(struct pt_regs *regs, unsigned long bits)
 {
 	return (regs->psw.mask & bits) / ((~bits + 1) & bits);
diff --git a/arch/score/kernel/traps.c b/arch/score/kernel/traps.c
index 0e46fb1..a38f435 100644
--- a/arch/score/kernel/traps.c
+++ b/arch/score/kernel/traps.c
@@ -149,16 +149,6 @@ static void show_registers(struct pt_regs *regs)
 	printk(KERN_NOTICE "\n");
 }
 
-/*
- * The architecture-independent dump_stack generator
- */
-void dump_stack(void)
-{
-	show_stack(current_thread_info()->task,
-		   (long *) get_irq_regs()->regs[0]);
-}
-EXPORT_SYMBOL(dump_stack);
-
 void __die(const char *str, struct pt_regs *regs, const char *file,
 	const char *func, unsigned long line)
 {
diff --git a/arch/sh/kernel/dumpstack.c b/arch/sh/kernel/dumpstack.c
index 7617dc4..b959f55 100644
--- a/arch/sh/kernel/dumpstack.c
+++ b/arch/sh/kernel/dumpstack.c
@@ -158,9 +158,3 @@ void show_stack(struct task_struct *tsk, unsigned long *sp)
 		 (unsigned long)task_stack_page(tsk));
 	show_trace(tsk, sp, NULL);
 }
-
-void dump_stack(void)
-{
-	show_stack(NULL, NULL);
-}
-EXPORT_SYMBOL(dump_stack);
diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
index 0d57b24..fe99fbd 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -175,13 +175,6 @@ void show_stack(struct task_struct *tsk, unsigned long *_ksp)
 	printk("\n");
 }
 
-void dump_stack(void)
-{
-	show_stack(current, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 /*
  * Note: sparc64 has a pretty intricated thread_saved_pc, check it out.
  */
diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index 8d38ca9..b3f833a 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -2350,13 +2350,6 @@ void show_stack(struct task_struct *tsk, unsigned long *_ksp)
 	} while (++count < 16);
 }
 
-void dump_stack(void)
-{
-	show_stack(current, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 static inline struct reg_window *kernel_stack_up(struct reg_window *rw)
 {
 	unsigned long fp = rw->ins[6];
diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index e562ff8..7d101a2 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -35,18 +35,6 @@ void show_trace(struct task_struct *task, unsigned long * stack)
 }
 #endif
 
-/*
- * stack dumps generator - this is used by arch-independent code.
- * And this is identical to i386 currently.
- */
-void dump_stack(void)
-{
-	unsigned long stack;
-
-	show_trace(current, &stack);
-}
-EXPORT_SYMBOL(dump_stack);
-
 /*Stolen from arch/i386/kernel/traps.c */
 static const int kstack_depth_to_print = 24;
 
diff --git a/arch/unicore32/kernel/traps.c b/arch/unicore32/kernel/traps.c
index 0870b68..c54e324 100644
--- a/arch/unicore32/kernel/traps.c
+++ b/arch/unicore32/kernel/traps.c
@@ -170,12 +170,6 @@ static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 		c_backtrace(fp, mode);
 }
 
-void dump_stack(void)
-{
-	dump_backtrace(NULL, NULL);
-}
-EXPORT_SYMBOL(dump_stack);
-
 void show_stack(struct task_struct *tsk, unsigned long *sp)
 {
 	dump_backtrace(NULL, tsk);
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index dd1a7c3..deb6421 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -191,24 +191,6 @@ void show_stack(struct task_struct *task, unsigned long *sp)
 	show_stack_log_lvl(task, NULL, sp, bp, "");
 }
 
-/*
- * The architecture-independent dump_stack generator
- */
-void dump_stack(void)
-{
-	unsigned long bp;
-	unsigned long stack;
-
-	bp = stack_frame(current, NULL);
-	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
-		current->pid, current->comm, print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
-	show_trace(NULL, NULL, &stack, bp);
-}
-EXPORT_SYMBOL(dump_stack);
-
 static arch_spinlock_t die_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 static int die_owner = -1;
 static unsigned int die_nest_count;
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index 923db5c..384b7c7 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -481,14 +481,6 @@ void show_stack(struct task_struct *task, unsigned long *sp)
 	show_trace(task, stack);
 }
 
-void dump_stack(void)
-{
-	show_stack(current, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
-
 void show_code(unsigned int *pc)
 {
 	long i;
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 4890fe6..7ce1f87 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -145,6 +145,7 @@ extern void wake_up_klogd(void);
 
 void log_buf_kexec_setup(void);
 void __init setup_log_buf(int early);
+void dump_stack_print_info(const char *log_lvl);
 #else
 static inline __printf(1, 0)
 int vprintk(const char *s, va_list args)
@@ -182,6 +183,10 @@ static inline void log_buf_kexec_setup(void)
 static inline void setup_log_buf(int early)
 {
 }
+
+static inline void dump_stack_print_info(const char *log_lvl)
+{
+}
 #endif
 
 extern void dump_stack(void) __cold;
diff --git a/kernel/printk.c b/kernel/printk.c
index 021053d..a00a285 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -44,6 +44,7 @@
 #include <linux/rculist.h>
 #include <linux/poll.h>
 #include <linux/irq_work.h>
+#include <linux/utsname.h>
 
 #include <asm/uaccess.h>
 
@@ -2850,4 +2851,21 @@ void kmsg_dump_rewind(struct kmsg_dumper *dumper)
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 }
 EXPORT_SYMBOL_GPL(kmsg_dump_rewind);
+
+/**
+ * dump_stack_print_info - print generic debug info for dump_stack()
+ * @log_lvl: log level
+ *
+ * Arch-specific dump_stack() implementations can use this function to
+ * print out the same debug information as the generic dump_stack().
+ */
+void dump_stack_print_info(const char *log_lvl)
+{
+	printk("%sCPU: %d PID: %d Comm: %.20s %s %s %.*s\n",
+	       log_lvl, raw_smp_processor_id(), current->pid, current->comm,
+	       print_tainted(), init_utsname()->release,
+	       (int)strcspn(init_utsname()->version, " "),
+	       init_utsname()->version);
+}
+
 #endif
diff --git a/lib/dump_stack.c b/lib/dump_stack.c
index 42f4f55..53bad09 100644
--- a/lib/dump_stack.c
+++ b/lib/dump_stack.c
@@ -5,11 +5,16 @@
 
 #include <linux/kernel.h>
 #include <linux/export.h>
+#include <linux/sched.h>
 
+/**
+ * dump_stack - dump the current task information and its stack trace
+ *
+ * Architectures can override this implementation by implementing its own.
+ */
 void dump_stack(void)
 {
-	printk(KERN_NOTICE
-		"This architecture does not implement dump_stack()\n");
+	dump_stack_print_info(KERN_DEFAULT);
+	show_stack(NULL, NULL);
 }
-
 EXPORT_SYMBOL(dump_stack);
-- 
1.8.1.4

