Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab3C3DY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 23:24:59 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:44383 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757665Ab3C3DYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 23:24:55 -0400
Date: Fri, 29 Mar 2013 20:24:45 -0700
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
        ysato@users.sourceforge.jp, gxt@mprc.pku.edu.cn, jdike@addtoit.com
Subject: [PATCH v2 5/5] dump_stack: unify debug information printed by
 show_regs()
Message-ID: <20130330032445.GA28468@htj.dyndns.org>
References: <1364610428-2074-1-git-send-email-tj@kernel.org>
 <1364610428-2074-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364610428-2074-6-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

show_regs() is inherently arch-dependent but it does make sense to
print generic debug information and some archs already do albeit in
slightly different forms.  This patch introduces a generic function to
print debug information from show_regs() so that different archs print
out the same information and it's much easier to modify what's
printed.

show_regs_print_current() prints out the same debug info as
dump_stack() does plus CPU, task and thread_info pointers.

* Archs which didn't print debug info now do.

  alpha, arc, blackfin, c6x, cris, frv, h8300, hexagon, ia64, m32r,
  metag, microblaze, mn10300, openrisc, parisc, score, sh64, sparc,
  um, xtensa

* Already prints debug info.  Replaced with show_regs_print_current().
  The printed information is superset of what used to be there.

  arm, arm64, avr32, mips, powerpc, sh32, tile, unicore32, x86

* The printed debug information includes arch-specific bits.  Left
  alone.

  s390

Note that now all archs print the debug info before actual register
dumps.

An example BUG() dump follows.

 kernel BUG at /work/os/work/kernel/workqueue.c:4841!
 invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
 Modules linked in:
 Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc1-work+ #20 empty empty/S3992
 CPU:0 task: ffff88007c85e040 ti: ffff88007c860000 task.ti: ffff88007c860000
 RIP: 0010:[<ffffffff8234a042>]  [<ffffffff8234a042>] init_workqueues+0x15/0x17
 RSP: 0000:ffff88007c861ec8  EFLAGS: 00010296
 RAX: 0000000000000024 RBX: ffffffff82446608 RCX: 0000000000000001
 RDX: 0000000000000046 RSI: 0000000000000000 RDI: 0000000000000009
 RBP: ffff88007c861ec8 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff8234a02d
 R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: ffff88015f7ff000 CR3: 00000000021f1000 CR4: 00000000000007f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Stack:
  ffff88007c861ef8 ffffffff81000312 ffffffff82446608 ffff88007c85e650
  0000000000000003 0000000000000000 ffff88007c861f38 ffffffff82335e5d
  ffff88007c862080 ffffffff8223d8c0 ffff88007c862080 ffffffff81c47730
 Call Trace:
  [<ffffffff81000312>] do_one_initcall+0x122/0x170
  [<ffffffff82335e5d>] kernel_init_freeable+0x9b/0x1c8
  ...

v2: Typo fix in x86-32.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Silly last minute mistake in x86-32.  git branch updated accordingly.

Thanks.

 arch/alpha/kernel/process.c         |  1 +
 arch/arc/kernel/troubleshoot.c      |  1 +
 arch/arm/kernel/process.c           |  8 ++------
 arch/arm64/kernel/process.c         |  7 +------
 arch/avr32/kernel/process.c         |  5 ++---
 arch/blackfin/kernel/trace.c        |  2 ++
 arch/c6x/kernel/traps.c             |  1 +
 arch/cris/arch-v10/kernel/process.c |  3 +++
 arch/cris/arch-v32/kernel/process.c |  3 +++
 arch/frv/kernel/traps.c             |  3 +--
 arch/h8300/kernel/process.c         |  2 ++
 arch/hexagon/kernel/vm_events.c     |  2 ++
 arch/ia64/kernel/process.c          |  4 ++--
 arch/m32r/kernel/process.c          |  2 ++
 arch/metag/kernel/process.c         |  2 ++
 arch/microblaze/kernel/process.c    |  2 ++
 arch/mips/kernel/traps.c            |  2 +-
 arch/mn10300/kernel/process.c       |  1 +
 arch/openrisc/kernel/process.c      |  1 +
 arch/parisc/kernel/traps.c          |  2 ++
 arch/powerpc/kernel/process.c       |  8 ++------
 arch/score/kernel/traps.c           |  2 ++
 arch/sh/kernel/process_32.c         |  6 +-----
 arch/sh/kernel/process_64.c         |  1 +
 arch/sparc/kernel/process_32.c      |  2 ++
 arch/sparc/kernel/process_64.c      |  2 ++
 arch/tile/kernel/process.c          |  3 +--
 arch/um/sys-ppc/sysrq.c             |  2 ++
 arch/unicore32/kernel/process.c     |  6 +-----
 arch/x86/include/asm/bug.h          |  3 ---
 arch/x86/kernel/dumpstack_32.c      |  4 +---
 arch/x86/kernel/dumpstack_64.c      |  6 +-----
 arch/x86/kernel/process.c           | 24 ------------------------
 arch/x86/kernel/process_32.c        |  2 --
 arch/x86/kernel/process_64.c        |  1 -
 arch/xtensa/kernel/traps.c          |  2 ++
 include/linux/printk.h              |  2 ++
 lib/dump_stack.c                    | 16 ++++++++++++++++
 38 files changed, 70 insertions(+), 76 deletions(-)

diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 63d27fb..7085cb8 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -194,6 +194,7 @@ machine_power_off(void)
 void
 show_regs(struct pt_regs *regs)
 {
+	show_regs_print_info(KERN_DEFAULT);
 	dik_show_regs(regs, NULL);
 }
 
diff --git a/arch/arc/kernel/troubleshoot.c b/arch/arc/kernel/troubleshoot.c
index 7c10873..96be1e6 100644
--- a/arch/arc/kernel/troubleshoot.c
+++ b/arch/arc/kernel/troubleshoot.c
@@ -163,6 +163,7 @@ void show_regs(struct pt_regs *regs)
 		return;
 
 	print_task_path_n_nm(tsk, buf);
+	show_regs_print_info(KERN_INFO);
 
 	if (current->thread.cause_code)
 		show_ecr_verbose(regs);
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 047d3e4..3e63a0a 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -273,11 +273,8 @@ void __show_regs(struct pt_regs *regs)
 	unsigned long flags;
 	char buf[64];
 
-	printk("CPU: %d    %s  (%s %.*s)\n",
-		raw_smp_processor_id(), print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
+	show_regs_print_info(KERN_DEFAULT);
+
 	print_symbol("PC is at %s\n", instruction_pointer(regs));
 	print_symbol("LR is at %s\n", regs->ARM_lr);
 	printk("pc : [<%08lx>]    lr : [<%08lx>]    psr: %08lx\n"
@@ -332,7 +329,6 @@ void __show_regs(struct pt_regs *regs)
 void show_regs(struct pt_regs * regs)
 {
 	printk("\n");
-	printk("Pid: %d, comm: %20s\n", task_pid_nr(current), current->comm);
 	__show_regs(regs);
 	dump_stack();
 }
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 0337cdb..4f812bb 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -178,11 +178,7 @@ void __show_regs(struct pt_regs *regs)
 {
 	int i;
 
-	printk("CPU: %d    %s  (%s %.*s)\n",
-		raw_smp_processor_id(), print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
+	show_regs_print_info(KERN_DEFAULT);
 	print_symbol("PC is at %s\n", instruction_pointer(regs));
 	print_symbol("LR is at %s\n", regs->regs[30]);
 	printk("pc : [<%016llx>] lr : [<%016llx>] pstate: %08llx\n",
@@ -199,7 +195,6 @@ void __show_regs(struct pt_regs *regs)
 void show_regs(struct pt_regs * regs)
 {
 	printk("\n");
-	printk("Pid: %d, comm: %20s\n", task_pid_nr(current), current->comm);
 	__show_regs(regs);
 }
 
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index c1cafdb..63c9e8c 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -224,6 +224,8 @@ void show_regs_log_lvl(struct pt_regs *regs, const char *log_lvl)
 	unsigned long lr = regs->lr;
 	unsigned long mode = (regs->sr & MODE_MASK) >> MODE_SHIFT;
 
+	show_regs_print_info(log_lvl);
+
 	if (!user_mode(regs)) {
 		sp = (unsigned long)regs + FRAME_SIZE_FULL;
 
@@ -261,9 +263,6 @@ void show_regs_log_lvl(struct pt_regs *regs, const char *log_lvl)
 	       regs->sr & SR_I0M ? '0' : '.',
 	       regs->sr & SR_GM ? 'G' : 'g');
 	printk("%sCPU Mode: %s\n", log_lvl, cpu_modes[mode]);
-	printk("%sProcess: %s [%d] (task: %p thread: %p)\n",
-	       log_lvl, current->comm, current->pid, current,
-	       task_thread_info(current));
 }
 
 void show_regs(struct pt_regs *regs)
diff --git a/arch/blackfin/kernel/trace.c b/arch/blackfin/kernel/trace.c
index f7f7a18..c36efa0 100644
--- a/arch/blackfin/kernel/trace.c
+++ b/arch/blackfin/kernel/trace.c
@@ -853,6 +853,8 @@ void show_regs(struct pt_regs *fp)
 	unsigned char in_atomic = (bfin_read_IPEND() & 0x10) || in_atomic();
 
 	pr_notice("\n");
+	show_regs_print_info(KERN_NOTICE);
+
 	if (CPUID != bfin_cpuid())
 		pr_notice("Compiled for cpu family 0x%04x (Rev %d), "
 			"but running on:0x%04x (Rev %d)\n",
diff --git a/arch/c6x/kernel/traps.c b/arch/c6x/kernel/traps.c
index d0b96ef..dcc2c2f 100644
--- a/arch/c6x/kernel/traps.c
+++ b/arch/c6x/kernel/traps.c
@@ -31,6 +31,7 @@ void __init trap_init(void)
 void show_regs(struct pt_regs *regs)
 {
 	pr_err("\n");
+	show_regs_print_info(KERN_ERR);
 	pr_err("PC: %08lx SP: %08lx\n", regs->pc, regs->sp);
 	pr_err("Status: %08lx ORIG_A4: %08lx\n", regs->csr, regs->orig_a4);
 	pr_err("A0: %08lx  B0: %08lx\n", regs->a0, regs->b0);
diff --git a/arch/cris/arch-v10/kernel/process.c b/arch/cris/arch-v10/kernel/process.c
index b101875..9087bbf 100644
--- a/arch/cris/arch-v10/kernel/process.c
+++ b/arch/cris/arch-v10/kernel/process.c
@@ -175,6 +175,9 @@ unsigned long get_wchan(struct task_struct *p)
 void show_regs(struct pt_regs * regs)
 {
 	unsigned long usp = rdusp();
+
+	show_regs_print_info(KERN_DEFAULT);
+
 	printk("IRP: %08lx SRP: %08lx DCCR: %08lx USP: %08lx MOF: %08lx\n",
 	       regs->irp, regs->srp, regs->dccr, usp, regs->mof );
 	printk(" r0: %08lx  r1: %08lx   r2: %08lx  r3: %08lx\n",
diff --git a/arch/cris/arch-v32/kernel/process.c b/arch/cris/arch-v32/kernel/process.c
index 2b23ef0..09fd16c 100644
--- a/arch/cris/arch-v32/kernel/process.c
+++ b/arch/cris/arch-v32/kernel/process.c
@@ -170,6 +170,9 @@ get_wchan(struct task_struct *p)
 void show_regs(struct pt_regs * regs)
 {
 	unsigned long usp = rdusp();
+
+	show_regs_print_info(KERN_DEFAULT);
+
         printk("ERP: %08lx SRP: %08lx  CCS: %08lx USP: %08lx MOF: %08lx\n",
 		regs->erp, regs->srp, regs->ccs, usp, regs->mof);
 
diff --git a/arch/frv/kernel/traps.c b/arch/frv/kernel/traps.c
index cfcd802..4bff48c 100644
--- a/arch/frv/kernel/traps.c
+++ b/arch/frv/kernel/traps.c
@@ -497,6 +497,7 @@ void show_regs(struct pt_regs *regs)
 	int loop;
 
 	printk("\n");
+	show_regs_print_info(KERN_DEFAULT);
 
 	printk("Frame: @%08lx [%s]\n",
 	       (unsigned long) regs,
@@ -511,8 +512,6 @@ void show_regs(struct pt_regs *regs)
 		else
 			printk(" | ");
 	}
-
-	printk("Process %s (pid: %d)\n", current->comm, current->pid);
 }
 
 void die_if_kernel(const char *str, ...)
diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index b609f63..8f235a3 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -110,6 +110,8 @@ void machine_power_off(void)
 
 void show_regs(struct pt_regs * regs)
 {
+	show_regs_print_info(KERN_DEFAULT);
+
 	printk("\nPC: %08lx  Status: %02x",
 	       regs->pc, regs->ccr);
 	printk("\nORIG_ER0: %08lx ER0: %08lx ER1: %08lx",
diff --git a/arch/hexagon/kernel/vm_events.c b/arch/hexagon/kernel/vm_events.c
index 9b5a4a2..f337281 100644
--- a/arch/hexagon/kernel/vm_events.c
+++ b/arch/hexagon/kernel/vm_events.c
@@ -33,6 +33,8 @@
  */
 void show_regs(struct pt_regs *regs)
 {
+	show_regs_print_info(KERN_EMERG);
+
 	printk(KERN_EMERG "restart_r0: \t0x%08lx   syscall_nr: %ld\n",
 	       regs->restart_r0, regs->syscall_nr);
 	printk(KERN_EMERG "preds: \t\t0x%08lx\n", regs->preds);
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 29fb256..492dc45 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -101,8 +101,8 @@ show_regs (struct pt_regs *regs)
 	unsigned long ip = regs->cr_iip + ia64_psr(regs)->ri;
 
 	print_modules();
-	printk("\nPid: %d, CPU %d, comm: %20s\n", task_pid_nr(current),
-			smp_processor_id(), current->comm);
+	printk("\n");
+	show_regs_print_info(KERN_DEFAULT);
 	printk("psr : %016lx ifs : %016lx ip  : [<%016lx>]    %s (%s)\n",
 	       regs->cr_ipsr, regs->cr_ifs, ip, print_tainted(),
 	       init_utsname()->release);
diff --git a/arch/m32r/kernel/process.c b/arch/m32r/kernel/process.c
index bde899e..892a1d9 100644
--- a/arch/m32r/kernel/process.c
+++ b/arch/m32r/kernel/process.c
@@ -91,6 +91,8 @@ void machine_power_off(void)
 void show_regs(struct pt_regs * regs)
 {
 	printk("\n");
+	show_regs_print_info(KERN_DEFAULT);
+
 	printk("BPC[%08lx]:PSW[%08lx]:LR [%08lx]:FP [%08lx]\n", \
 	  regs->bpc, regs->psw, regs->lr, regs->fp);
 	printk("BBPC[%08lx]:BBPSW[%08lx]:SPU[%08lx]:SPI[%08lx]\n", \
diff --git a/arch/metag/kernel/process.c b/arch/metag/kernel/process.c
index c6efe62..cfe4e7f 100644
--- a/arch/metag/kernel/process.c
+++ b/arch/metag/kernel/process.c
@@ -152,6 +152,8 @@ void show_regs(struct pt_regs *regs)
 		"D1.7 "
 	};
 
+	show_regs_print_info(KERN_INFO);
+
 	pr_info(" pt_regs @ %p\n", regs);
 	pr_info(" SaveMask = 0x%04hx\n", regs->ctx.SaveMask);
 	pr_info(" Flags = 0x%04hx (%c%c%c%c)\n", regs->ctx.Flags,
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index fa0ea60..d55700c 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -20,6 +20,8 @@
 
 void show_regs(struct pt_regs *regs)
 {
+	show_regs_print_info(KERN_INFO);
+
 	pr_info(" Registers dump: mode=%X\r\n", regs->pt_mode);
 	pr_info(" r1=%08lX, r2=%08lX, r3=%08lX, r4=%08lX\n",
 				regs->r1, regs->r2, regs->r3, regs->r4);
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 93f9b26..1b383a9 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -231,7 +231,7 @@ static void __show_regs(const struct pt_regs *regs)
 	unsigned int cause = regs->cp0_cause;
 	int i;
 
-	printk("Cpu %d\n", smp_processor_id());
+	show_regs_print_info(KERN_DEFAULT);
 
 	/*
 	 * Saved main processor registers
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 84f4e97..1223770 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -155,6 +155,7 @@ void machine_power_off(void)
 
 void show_regs(struct pt_regs *regs)
 {
+	show_regs_print_info(KERN_DEFAULT);
 }
 
 /*
diff --git a/arch/openrisc/kernel/process.c b/arch/openrisc/kernel/process.c
index 00c233b..386af25 100644
--- a/arch/openrisc/kernel/process.c
+++ b/arch/openrisc/kernel/process.c
@@ -90,6 +90,7 @@ void show_regs(struct pt_regs *regs)
 {
 	extern void show_registers(struct pt_regs *regs);
 
+	show_regs_print_info(KERN_DEFAULT);
 	/* __PHX__ cleanup this mess */
 	show_registers(regs);
 }
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index e64cf5f..f702bff 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -126,6 +126,8 @@ void show_regs(struct pt_regs *regs)
 	user = user_mode(regs);
 	level = user ? KERN_DEBUG : KERN_CRIT;
 
+	show_regs_print_info(level);
+
 	print_gr(level, regs);
 
 	for (i = 0; i < 8; i += 4)
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 2e6f83a..fd1b300 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -829,6 +829,8 @@ void show_regs(struct pt_regs * regs)
 {
 	int i, trap;
 
+	show_regs_print_info(KERN_DEFAULT);
+
 	printk("NIP: "REG" LR: "REG" CTR: "REG"\n",
 	       regs->nip, regs->link, regs->ctr);
 	printk("REGS: %p TRAP: %04lx   %s  (%s)\n",
@@ -848,12 +850,6 @@ void show_regs(struct pt_regs * regs)
 #else
 		printk("DAR: "REG", DSISR: %08lx\n", regs->dar, regs->dsisr);
 #endif
-	printk("TASK = %p[%d] '%s' THREAD: %p",
-	       current, task_pid_nr(current), current->comm, task_thread_info(current));
-
-#ifdef CONFIG_SMP
-	printk(" CPU: %d", raw_smp_processor_id());
-#endif /* CONFIG_SMP */
 
 	for (i = 0;  i < 32;  i++) {
 		if ((i % REGS_PER_LINE) == 0)
diff --git a/arch/score/kernel/traps.c b/arch/score/kernel/traps.c
index a38f435..1517a7d 100644
--- a/arch/score/kernel/traps.c
+++ b/arch/score/kernel/traps.c
@@ -117,6 +117,8 @@ static void show_code(unsigned int *pc)
  */
 void show_regs(struct pt_regs *regs)
 {
+	show_regs_print_info(KERN_DEFAULT);
+
 	printk("r0 : %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
 		regs->regs[0], regs->regs[1], regs->regs[2], regs->regs[3],
 		regs->regs[4], regs->regs[5], regs->regs[6], regs->regs[7]);
diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
index 73eb66f..ebd3933 100644
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -32,11 +32,7 @@
 void show_regs(struct pt_regs * regs)
 {
 	printk("\n");
-	printk("Pid : %d, Comm: \t\t%s\n", task_pid_nr(current), current->comm);
-	printk("CPU : %d        \t\t%s  (%s %.*s)\n\n",
-	       smp_processor_id(), print_tainted(), init_utsname()->release,
-	       (int)strcspn(init_utsname()->version, " "),
-	       init_utsname()->version);
+	show_regs_print_info(KERN_DEFAULT);
 
 	print_symbol("PC is at %s\n", instruction_pointer(regs));
 	print_symbol("PR is at %s\n", regs->pr);
diff --git a/arch/sh/kernel/process_64.c b/arch/sh/kernel/process_64.c
index e611c85..174d124 100644
--- a/arch/sh/kernel/process_64.c
+++ b/arch/sh/kernel/process_64.c
@@ -40,6 +40,7 @@ void show_regs(struct pt_regs *regs)
 	unsigned long long ah, al, bh, bl, ch, cl;
 
 	printk("\n");
+	show_regs_print_info(KERN_DEFAULT);
 
 	ah = (regs->pc) >> 32;
 	al = (regs->pc) & 0xffffffff;
diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
index fe99fbd..9e78f9a 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -123,6 +123,8 @@ void show_regs(struct pt_regs *r)
 {
 	struct reg_window32 *rw = (struct reg_window32 *) r->u_regs[14];
 
+	show_regs_print_info(KERN_DEFAULT);
+
         printk("PSR: %08lx PC: %08lx NPC: %08lx Y: %08lx    %s\n",
 	       r->psr, r->pc, r->npc, r->y, print_tainted());
 	printk("PC: <%pS>\n", (void *) r->pc);
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index cdb80b2..2415a95 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -186,6 +186,8 @@ static void show_regwindow(struct pt_regs *regs)
 
 void show_regs(struct pt_regs *regs)
 {
+	show_regs_print_info(KERN_DEFAULT);
+
 	printk("TSTATE: %016lx TPC: %016lx TNPC: %016lx Y: %08x    %s\n", regs->tstate,
 	       regs->tpc, regs->tnpc, regs->y, print_tainted());
 	printk("TPC: <%pS>\n", (void *) regs->tpc);
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index caf93ae..302691d 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -620,8 +620,7 @@ void show_regs(struct pt_regs *regs)
 	int i;
 
 	pr_err("\n");
-	pr_err(" Pid: %d, comm: %20s, CPU: %d\n",
-	       tsk->pid, tsk->comm, smp_processor_id());
+	show_regs_print_info(KERN_ERR);
 #ifdef __tilegx__
 	for (i = 0; i < 51; i += 3)
 		pr_err(" r%-2d: "REGFMT" r%-2d: "REGFMT" r%-2d: "REGFMT"\n",
diff --git a/arch/um/sys-ppc/sysrq.c b/arch/um/sys-ppc/sysrq.c
index f889449..1ff1ad7 100644
--- a/arch/um/sys-ppc/sysrq.c
+++ b/arch/um/sys-ppc/sysrq.c
@@ -11,6 +11,8 @@
 void show_regs(struct pt_regs_subarch *regs)
 {
 	printk("\n");
+	show_regs_print_info(KERN_DEFAULT);
+
 	printk("show_regs(): insert regs here.\n");
 #if 0
         printk("\n");
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index 872d7e2..c412484 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -159,11 +159,7 @@ void __show_regs(struct pt_regs *regs)
 	unsigned long flags;
 	char buf[64];
 
-	printk(KERN_DEFAULT "CPU: %d    %s  (%s %.*s)\n",
-		raw_smp_processor_id(), print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
+	show_regs_print_info(KERN_DEFAULT);
 	print_symbol("PC is at %s\n", instruction_pointer(regs));
 	print_symbol("LR is at %s\n", regs->UCreg_lr);
 	printk(KERN_DEFAULT "pc : [<%08lx>]    lr : [<%08lx>]    psr: %08lx\n"
diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index 11e1152..2f03ff0 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -37,7 +37,4 @@ do {								\
 
 #include <asm-generic/bug.h>
 
-
-extern void show_regs_common(void);
-
 #endif /* _ASM_X86_BUG_H */
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 1038a41..f2a1770 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -86,11 +86,9 @@ void show_regs(struct pt_regs *regs)
 {
 	int i;
 
+	show_regs_print_info(KERN_EMERG);
 	__show_regs(regs, !user_mode_vm(regs));
 
-	pr_emerg("Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)\n",
-		 TASK_COMM_LEN, current->comm, task_pid_nr(current),
-		 current_thread_info(), current, task_thread_info(current));
 	/*
 	 * When in-kernel, we also print out the stack and code at the
 	 * time of the fault..
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index b653675..addb207 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -249,14 +249,10 @@ void show_regs(struct pt_regs *regs)
 {
 	int i;
 	unsigned long sp;
-	const int cpu = smp_processor_id();
-	struct task_struct *cur = current;
 
 	sp = regs->sp;
-	printk("CPU %d ", cpu);
+	show_regs_print_info(KERN_DEFAULT);
 	__show_regs(regs, 1);
-	printk(KERN_DEFAULT "Process %s (pid: %d, threadinfo %p, task %p)\n",
-	       cur->comm, cur->pid, task_thread_info(cur), cur);
 
 	/*
 	 * When in-kernel, we also print out the stack and code at the
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 14ae100..7646378 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -121,30 +121,6 @@ void exit_thread(void)
 	drop_fpu(me);
 }
 
-void show_regs_common(void)
-{
-	const char *vendor, *product, *board;
-
-	vendor = dmi_get_system_info(DMI_SYS_VENDOR);
-	if (!vendor)
-		vendor = "";
-	product = dmi_get_system_info(DMI_PRODUCT_NAME);
-	if (!product)
-		product = "";
-
-	/* Board Name is optional */
-	board = dmi_get_system_info(DMI_BOARD_NAME);
-
-	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s %s %s%s%s\n",
-	       current->pid, current->comm, print_tainted(),
-	       init_utsname()->release,
-	       (int)strcspn(init_utsname()->version, " "),
-	       init_utsname()->version,
-	       vendor, product,
-	       board ? "/" : "",
-	       board ? board : "");
-}
-
 void flush_thread(void)
 {
 	struct task_struct *tsk = current;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index b5a8905..7305f7d 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -84,8 +84,6 @@ void __show_regs(struct pt_regs *regs, int all)
 		savesegment(gs, gs);
 	}
 
-	show_regs_common();
-
 	printk(KERN_DEFAULT "EIP: %04x:[<%08lx>] EFLAGS: %08lx CPU: %d\n",
 			(u16)regs->cs, regs->ip, regs->flags,
 			smp_processor_id());
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 0f49677..355ae06 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -62,7 +62,6 @@ void __show_regs(struct pt_regs *regs, int all)
 	unsigned int fsindex, gsindex;
 	unsigned int ds, cs, es;
 
-	show_regs_common();
 	printk(KERN_DEFAULT "RIP: %04lx:[<%016lx>] ", regs->cs & 0xffff, regs->ip);
 	printk_address(regs->ip, 1);
 	printk(KERN_DEFAULT "RSP: %04lx:%016lx  EFLAGS: %08lx\n", regs->ss,
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index 384b7c7..458186d 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -383,6 +383,8 @@ void show_regs(struct pt_regs * regs)
 {
 	int i, wmask;
 
+	show_regs_print_info(KERN_DEFAULT);
+
 	wmask = regs->wmask & ~1;
 
 	for (i = 0; i < 16; i++) {
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 73788ff..d42b26a 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -181,6 +181,8 @@ extern void dump_stack_set_arch_desc(const char *fmt, ...);
 extern void dump_stack_print_info(const char *log_lvl);
 extern void dump_stack(void) __cold;
 
+extern void show_regs_print_info(const char *log_lvl);
+
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
 #endif
diff --git a/lib/dump_stack.c b/lib/dump_stack.c
index 93573ec..520a878 100644
--- a/lib/dump_stack.c
+++ b/lib/dump_stack.c
@@ -57,3 +57,19 @@ void dump_stack(void)
 	show_stack(NULL, NULL);
 }
 EXPORT_SYMBOL(dump_stack);
+
+/**
+ * show_regs_print_info - print generic debug info for show_regs()
+ * @log_lvl: log level
+ *
+ * show_regs() implementations can use this function to print out generic
+ * debug information.
+ */
+void show_regs_print_info(const char *log_lvl)
+{
+	dump_stack_print_info(log_lvl);
+
+	printk("%sCPU:%d task: %p ti: %p task.ti: %p\n",
+	       log_lvl, raw_smp_processor_id(), current, current_thread_info(),
+	       task_thread_info(current));
+}
-- 
1.8.1.4

