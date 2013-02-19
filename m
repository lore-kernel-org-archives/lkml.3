Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab3BSOXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:23:17 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:60561 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880Ab3BSOXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:23:13 -0500
Date: Tue, 19 Feb 2013 15:23:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v3.9
Message-ID: <20130219142307.GA13013@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-core-for-linus

   HEAD: 77852fea6e2442a0e654a9292060489895de18c7 sched/rt: Add <linux/sched/rt.h> header to <linux/init_task.h>

Main changes:

 * scheduler side full-dynticks (user-space execution is
   undisturbed and receives no timer IRQs) preparation changes
   that convert the cputime accounting code to be full-dynticks
   ready, from Frederic Weisbecker.

 * Initial sched.h split-up changes, by Clark Williams

 * select_idle_sibling() performance improvement by Mike 
   Galbraith:

   " 1 tbench pair (worst case) in a 10 core + SMT package:

      pre   15.22 MB/sec 1 procs
      post 252.01 MB/sec 1 procs "

 * sched_rr_get_interval() ABI fix/change. We think this detail 
   is not used by apps (so it's not an ABI in practice), but 
   lets keep it under observation.

 * misc RT scheduling cleanups, optimizations

 Thanks,

	Ingo

------------------>
Clark Williams (3):
      sched: Move sched.h sysctl bits into separate header
      sched/rt: Add a tuning knob to allow changing SCHED_RR timeslice
      sched/rt: Move rt specific bits into new header file

Dan Carpenter (1):
      sched: Fix signedness bug in yield_to()

Frederic Weisbecker (9):
      context_tracking: Export context state for generic vtime
      cputime: Avoid multiplication overflow on utime scaling
      cputime: Librarize per nsecs resolution cputime definitions
      cputime: Move default nsecs_to_cputime() to jiffies based cputime file
      cputime: Generic on-demand virtual cputime accounting
      cputime: Allow dynamic switch between tick/virtual based cputime accounting
      cputime: Use accessors to read task cputime stats
      kvm: Prepare to add generic guest entry/exit callbacks
      cputime: Safely read cputime of full dynticks CPUs

Ingo Molnar (2):
      sched, powerpc: Fix sched.h split-up build failure
      sched/rt: Add <linux/sched/rt.h> header to <linux/init_task.h>

Kirill Tkhai (3):
      sched/rt: Add reschedule check to switched_from_rt()
      sched/rt: Do not account zero delta_exec in update_curr_rt()
      sched/rt: Further simplify pick_rt_task()

Mike Galbraith (1):
      sched: Fix select_idle_sibling() bouncing cow syndrome

Stephen Rothwell (1):
      cputime: Restore CPU_ACCOUNTING config defaults for PPC64

Thomas Gleixner (1):
      cputime: Remove irqsave from seqlock readers

Viresh Kumar (1):
      sched/fair: Set se->vruntime directly in place_entity()

Ying Xue (1):
      sched/rt: Avoid updating RT entry timeout twice within one tick period

Zhu Yanhai (1):
      sched: Fix the broken sched_rr_get_interval()


 arch/alpha/kernel/osf_sys.c                  |   6 +-
 arch/ia64/include/asm/cputime.h              |  92 +-------
 arch/ia64/include/asm/thread_info.h          |   4 +-
 arch/ia64/include/asm/xen/minstate.h         |   2 +-
 arch/ia64/kernel/asm-offsets.c               |   2 +-
 arch/ia64/kernel/entry.S                     |  16 +-
 arch/ia64/kernel/fsys.S                      |   4 +-
 arch/ia64/kernel/head.S                      |   4 +-
 arch/ia64/kernel/ivt.S                       |   8 +-
 arch/ia64/kernel/minstate.h                  |   2 +-
 arch/ia64/kernel/time.c                      |   5 +-
 arch/powerpc/configs/chroma_defconfig        |   2 +-
 arch/powerpc/configs/corenet64_smp_defconfig |   2 +-
 arch/powerpc/configs/pasemi_defconfig        |   2 +-
 arch/powerpc/include/asm/cputime.h           |   6 +-
 arch/powerpc/include/asm/lppaca.h            |   2 +-
 arch/powerpc/include/asm/ppc_asm.h           |   4 +-
 arch/powerpc/kernel/entry_64.S               |   4 +-
 arch/powerpc/kernel/time.c                   |   5 +-
 arch/powerpc/platforms/cell/spufs/sched.c    |   1 +
 arch/powerpc/platforms/pseries/dtl.c         |   6 +-
 arch/powerpc/platforms/pseries/setup.c       |   6 +-
 arch/s390/kernel/vtime.c                     |   6 +-
 arch/x86/kernel/apm_32.c                     |  11 +-
 block/blk-exec.c                             |   1 +
 drivers/isdn/mISDN/stack.c                   |   7 +-
 drivers/spi/spi.c                            |   2 +-
 drivers/staging/csr/bh.c                     |   2 +-
 drivers/staging/csr/unifi_sme.c              |   2 +-
 drivers/tty/sysrq.c                          |   1 +
 fs/binfmt_elf.c                              |   8 +-
 fs/binfmt_elf_fdpic.c                        |   7 +-
 fs/proc/array.c                              |   4 +-
 fs/select.c                                  |   1 +
 include/asm-generic/cputime.h                |  66 +-----
 include/asm-generic/cputime_jiffies.h        |  72 ++++++
 include/asm-generic/cputime_nsecs.h          | 104 +++++++++
 include/linux/context_tracking.h             |  28 +++
 include/linux/hardirq.h                      |   4 +-
 include/linux/init_task.h                    |  12 +
 include/linux/kernel_stat.h                  |   2 +-
 include/linux/kvm_host.h                     |  55 ++++-
 include/linux/sched.h                        | 185 ++++------------
 include/linux/sched/rt.h                     |  58 +++++
 include/linux/sched/sysctl.h                 | 110 ++++++++++
 include/linux/tsacct_kern.h                  |   3 +
 include/linux/vtime.h                        |  59 +++--
 init/Kconfig                                 |  25 ++-
 init/init_task.c                             |   2 +
 kernel/acct.c                                |   6 +-
 kernel/context_tracking.c                    |  43 ++--
 kernel/cpu.c                                 |   4 +-
 kernel/delayacct.c                           |   7 +-
 kernel/exit.c                                |  10 +-
 kernel/fork.c                                |   6 +
 kernel/futex.c                               |   1 +
 kernel/hrtimer.c                             |   2 +
 kernel/irq/manage.c                          |   1 +
 kernel/mutex.c                               |   1 +
 kernel/posix-cpu-timers.c                    |  28 ++-
 kernel/rtmutex-debug.c                       |   1 +
 kernel/rtmutex-tester.c                      |   1 +
 kernel/rtmutex.c                             |   1 +
 kernel/sched/core.c                          |  22 +-
 kernel/sched/cpupri.c                        |   2 +
 kernel/sched/cputime.c                       | 314 +++++++++++++++++++++++----
 kernel/sched/fair.c                          |  27 +--
 kernel/sched/rt.c                            |  26 ++-
 kernel/sched/sched.h                         |   2 +
 kernel/signal.c                              |  12 +-
 kernel/softirq.c                             |   6 +-
 kernel/sysctl.c                              |   8 +
 kernel/time/tick-sched.c                     |   5 +-
 kernel/timer.c                               |   1 +
 kernel/trace/trace.c                         |   1 +
 kernel/trace/trace_sched_wakeup.c            |   2 +-
 kernel/tsacct.c                              |  44 +++-
 kernel/watchdog.c                            |   1 +
 mm/mmap.c                                    |   1 +
 mm/mremap.c                                  |   1 +
 mm/nommu.c                                   |   1 +
 mm/page-writeback.c                          |   1 +
 mm/page_alloc.c                              |   1 +
 83 files changed, 1105 insertions(+), 507 deletions(-)
 create mode 100644 include/asm-generic/cputime_jiffies.h
 create mode 100644 include/asm-generic/cputime_nsecs.h
 create mode 100644 include/linux/sched/rt.h
 create mode 100644 include/linux/sched/sysctl.h

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 14db93e..dbc1760 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -1139,6 +1139,7 @@ struct rusage32 {
 SYSCALL_DEFINE2(osf_getrusage, int, who, struct rusage32 __user *, ru)
 {
 	struct rusage32 r;
+	cputime_t utime, stime;
 
 	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN)
 		return -EINVAL;
@@ -1146,8 +1147,9 @@ SYSCALL_DEFINE2(osf_getrusage, int, who, struct rusage32 __user *, ru)
 	memset(&r, 0, sizeof(r));
 	switch (who) {
 	case RUSAGE_SELF:
-		jiffies_to_timeval32(current->utime, &r.ru_utime);
-		jiffies_to_timeval32(current->stime, &r.ru_stime);
+		task_cputime(current, &utime, &stime);
+		jiffies_to_timeval32(utime, &r.ru_utime);
+		jiffies_to_timeval32(stime, &r.ru_stime);
 		r.ru_minflt = current->min_flt;
 		r.ru_majflt = current->maj_flt;
 		break;
diff --git a/arch/ia64/include/asm/cputime.h b/arch/ia64/include/asm/cputime.h
index 7fcf7f0..e2d3f5b 100644
--- a/arch/ia64/include/asm/cputime.h
+++ b/arch/ia64/include/asm/cputime.h
@@ -11,99 +11,19 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  *
- * If we have CONFIG_VIRT_CPU_ACCOUNTING, we measure cpu time in nsec.
+ * If we have CONFIG_VIRT_CPU_ACCOUNTING_NATIVE, we measure cpu time in nsec.
  * Otherwise we measure cpu time in jiffies using the generic definitions.
  */
 
 #ifndef __IA64_CPUTIME_H
 #define __IA64_CPUTIME_H
 
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
-#include <asm-generic/cputime.h>
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
+# include <asm-generic/cputime.h>
 #else
-
-#include <linux/time.h>
-#include <linux/jiffies.h>
-#include <asm/processor.h>
-
-typedef u64 __nocast cputime_t;
-typedef u64 __nocast cputime64_t;
-
-#define cputime_one_jiffy		jiffies_to_cputime(1)
-
-/*
- * Convert cputime <-> jiffies (HZ)
- */
-#define cputime_to_jiffies(__ct)	\
-	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
-#define jiffies_to_cputime(__jif)	\
-	(__force cputime_t)((__jif) * (NSEC_PER_SEC / HZ))
-#define cputime64_to_jiffies64(__ct)	\
-	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
-#define jiffies64_to_cputime64(__jif)	\
-	(__force cputime64_t)((__jif) * (NSEC_PER_SEC / HZ))
-
-/*
- * Convert cputime <-> microseconds
- */
-#define cputime_to_usecs(__ct)		\
-	((__force u64)(__ct) / NSEC_PER_USEC)
-#define usecs_to_cputime(__usecs)	\
-	(__force cputime_t)((__usecs) * NSEC_PER_USEC)
-#define usecs_to_cputime64(__usecs)	\
-	(__force cputime64_t)((__usecs) * NSEC_PER_USEC)
-
-/*
- * Convert cputime <-> seconds
- */
-#define cputime_to_secs(__ct)		\
-	((__force u64)(__ct) / NSEC_PER_SEC)
-#define secs_to_cputime(__secs)		\
-	(__force cputime_t)((__secs) * NSEC_PER_SEC)
-
-/*
- * Convert cputime <-> timespec (nsec)
- */
-static inline cputime_t timespec_to_cputime(const struct timespec *val)
-{
-	u64 ret = val->tv_sec * NSEC_PER_SEC + val->tv_nsec;
-	return (__force cputime_t) ret;
-}
-static inline void cputime_to_timespec(const cputime_t ct, struct timespec *val)
-{
-	val->tv_sec  = (__force u64) ct / NSEC_PER_SEC;
-	val->tv_nsec = (__force u64) ct % NSEC_PER_SEC;
-}
-
-/*
- * Convert cputime <-> timeval (msec)
- */
-static inline cputime_t timeval_to_cputime(struct timeval *val)
-{
-	u64 ret = val->tv_sec * NSEC_PER_SEC + val->tv_usec * NSEC_PER_USEC;
-	return (__force cputime_t) ret;
-}
-static inline void cputime_to_timeval(const cputime_t ct, struct timeval *val)
-{
-	val->tv_sec = (__force u64) ct / NSEC_PER_SEC;
-	val->tv_usec = ((__force u64) ct % NSEC_PER_SEC) / NSEC_PER_USEC;
-}
-
-/*
- * Convert cputime <-> clock (USER_HZ)
- */
-#define cputime_to_clock_t(__ct)	\
-	((__force u64)(__ct) / (NSEC_PER_SEC / USER_HZ))
-#define clock_t_to_cputime(__x)		\
-	(__force cputime_t)((__x) * (NSEC_PER_SEC / USER_HZ))
-
-/*
- * Convert cputime64 to clock.
- */
-#define cputime64_to_clock_t(__ct)	\
-	cputime_to_clock_t((__force cputime_t)__ct)
-
+# include <asm/processor.h>
+# include <asm-generic/cputime_nsecs.h>
 extern void arch_vtime_task_switch(struct task_struct *tsk);
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
-#endif /* CONFIG_VIRT_CPU_ACCOUNTING */
 #endif /* __IA64_CPUTIME_H */
diff --git a/arch/ia64/include/asm/thread_info.h b/arch/ia64/include/asm/thread_info.h
index ff2ae41..020d655 100644
--- a/arch/ia64/include/asm/thread_info.h
+++ b/arch/ia64/include/asm/thread_info.h
@@ -31,7 +31,7 @@ struct thread_info {
 	mm_segment_t addr_limit;	/* user-level address space limit */
 	int preempt_count;		/* 0=premptable, <0=BUG; will also serve as bh-counter */
 	struct restart_block restart_block;
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	__u64 ac_stamp;
 	__u64 ac_leave;
 	__u64 ac_stime;
@@ -69,7 +69,7 @@ struct thread_info {
 #define task_stack_page(tsk)	((void *)(tsk))
 
 #define __HAVE_THREAD_FUNCTIONS
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 #define setup_thread_stack(p, org)			\
 	*task_thread_info(p) = *task_thread_info(org);	\
 	task_thread_info(p)->ac_stime = 0;		\
diff --git a/arch/ia64/include/asm/xen/minstate.h b/arch/ia64/include/asm/xen/minstate.h
index c57fa91..00cf03e 100644
--- a/arch/ia64/include/asm/xen/minstate.h
+++ b/arch/ia64/include/asm/xen/minstate.h
@@ -1,5 +1,5 @@
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 /* read ar.itc in advance, and use it before leaving bank 0 */
 #define XEN_ACCOUNT_GET_STAMP		\
 	MOV_FROM_ITC(pUStk, p6, r20, r2);
diff --git a/arch/ia64/kernel/asm-offsets.c b/arch/ia64/kernel/asm-offsets.c
index a48bd9a..46c9e30 100644
--- a/arch/ia64/kernel/asm-offsets.c
+++ b/arch/ia64/kernel/asm-offsets.c
@@ -41,7 +41,7 @@ void foo(void)
 	DEFINE(TI_FLAGS, offsetof(struct thread_info, flags));
 	DEFINE(TI_CPU, offsetof(struct thread_info, cpu));
 	DEFINE(TI_PRE_COUNT, offsetof(struct thread_info, preempt_count));
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	DEFINE(TI_AC_STAMP, offsetof(struct thread_info, ac_stamp));
 	DEFINE(TI_AC_LEAVE, offsetof(struct thread_info, ac_leave));
 	DEFINE(TI_AC_STIME, offsetof(struct thread_info, ac_stime));
diff --git a/arch/ia64/kernel/entry.S b/arch/ia64/kernel/entry.S
index 6bfd842..7a53530 100644
--- a/arch/ia64/kernel/entry.S
+++ b/arch/ia64/kernel/entry.S
@@ -724,7 +724,7 @@ GLOBAL_ENTRY(__paravirt_leave_syscall)
 #endif
 .global __paravirt_work_processed_syscall;
 __paravirt_work_processed_syscall:
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	adds r2=PT(LOADRS)+16,r12
 	MOV_FROM_ITC(pUStk, p9, r22, r19)	// fetch time at leave
 	adds r18=TI_FLAGS+IA64_TASK_SIZE,r13
@@ -762,7 +762,7 @@ __paravirt_work_processed_syscall:
 
 	ld8 r29=[r2],16		// M0|1 load cr.ipsr
 	ld8 r28=[r3],16		// M0|1 load cr.iip
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 (pUStk) add r14=TI_AC_LEAVE+IA64_TASK_SIZE,r13
 	;;
 	ld8 r30=[r2],16		// M0|1 load cr.ifs
@@ -793,7 +793,7 @@ __paravirt_work_processed_syscall:
 	ld8.fill r1=[r3],16			// M0|1 load r1
 (pUStk) mov r17=1				// A
 	;;
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 (pUStk) st1 [r15]=r17				// M2|3
 #else
 (pUStk) st1 [r14]=r17				// M2|3
@@ -813,7 +813,7 @@ __paravirt_work_processed_syscall:
 	shr.u r18=r19,16		// I0|1 get byte size of existing "dirty" partition
 	COVER				// B    add current frame into dirty partition & set cr.ifs
 	;;
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	mov r19=ar.bsp			// M2   get new backing store pointer
 	st8 [r14]=r22			// M	save time at leave
 	mov f10=f0			// F    clear f10
@@ -948,7 +948,7 @@ GLOBAL_ENTRY(__paravirt_leave_kernel)
 	adds r16=PT(CR_IPSR)+16,r12
 	adds r17=PT(CR_IIP)+16,r12
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	.pred.rel.mutex pUStk,pKStk
 	MOV_FROM_PSR(pKStk, r22, r29)	// M2 read PSR now that interrupts are disabled
 	MOV_FROM_ITC(pUStk, p9, r22, r29)	// M  fetch time at leave
@@ -981,7 +981,7 @@ GLOBAL_ENTRY(__paravirt_leave_kernel)
 	;;
 	ld8.fill r12=[r16],16
 	ld8.fill r13=[r17],16
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 (pUStk)	adds r3=TI_AC_LEAVE+IA64_TASK_SIZE,r18
 #else
 (pUStk)	adds r18=IA64_TASK_THREAD_ON_USTACK_OFFSET,r18
@@ -989,7 +989,7 @@ GLOBAL_ENTRY(__paravirt_leave_kernel)
 	;;
 	ld8 r20=[r16],16	// ar.fpsr
 	ld8.fill r15=[r17],16
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 (pUStk)	adds r18=IA64_TASK_THREAD_ON_USTACK_OFFSET,r18	// deferred
 #endif
 	;;
@@ -997,7 +997,7 @@ GLOBAL_ENTRY(__paravirt_leave_kernel)
 	ld8.fill r2=[r17]
 (pUStk)	mov r17=1
 	;;
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	//  mmi_ :  ld8 st1 shr;;         mmi_ : st8 st1 shr;;
 	//  mib  :  mov add br        ->  mib  : ld8 add br
 	//  bbb_ :  br  nop cover;;       mbb_ : mov br  cover;;
diff --git a/arch/ia64/kernel/fsys.S b/arch/ia64/kernel/fsys.S
index e662f17..c4cd45d 100644
--- a/arch/ia64/kernel/fsys.S
+++ b/arch/ia64/kernel/fsys.S
@@ -529,7 +529,7 @@ GLOBAL_ENTRY(paravirt_fsys_bubble_down)
 	nop.i 0
 	;;
 	mov ar.rsc=0				// M2   set enforced lazy mode, pl 0, LE, loadrs=0
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	MOV_FROM_ITC(p0, p6, r30, r23)		// M    get cycle for accounting
 #else
 	nop.m 0
@@ -555,7 +555,7 @@ GLOBAL_ENTRY(paravirt_fsys_bubble_down)
 	cmp.ne pKStk,pUStk=r0,r0		// A    set pKStk <- 0, pUStk <- 1
 	br.call.sptk.many b7=ia64_syscall_setup	// B
 	;;
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	// mov.m r30=ar.itc is called in advance
 	add r16=TI_AC_STAMP+IA64_TASK_SIZE,r2
 	add r17=TI_AC_LEAVE+IA64_TASK_SIZE,r2
diff --git a/arch/ia64/kernel/head.S b/arch/ia64/kernel/head.S
index 4738ff7..9be4e49 100644
--- a/arch/ia64/kernel/head.S
+++ b/arch/ia64/kernel/head.S
@@ -1073,7 +1073,7 @@ END(ia64_native_sched_clock)
 sched_clock = ia64_native_sched_clock
 #endif
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 GLOBAL_ENTRY(cycle_to_cputime)
 	alloc r16=ar.pfs,1,0,0,0
 	addl r8=THIS_CPU(ia64_cpu_info) + IA64_CPUINFO_NSEC_PER_CYC_OFFSET,r0
@@ -1091,7 +1091,7 @@ GLOBAL_ENTRY(cycle_to_cputime)
 	shrp r8=r9,r8,IA64_NSEC_PER_CYC_SHIFT
 	br.ret.sptk.many rp
 END(cycle_to_cputime)
-#endif /* CONFIG_VIRT_CPU_ACCOUNTING */
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 #ifdef CONFIG_IA64_BRL_EMU
 
diff --git a/arch/ia64/kernel/ivt.S b/arch/ia64/kernel/ivt.S
index fa25689..689ffca 100644
--- a/arch/ia64/kernel/ivt.S
+++ b/arch/ia64/kernel/ivt.S
@@ -784,7 +784,7 @@ ENTRY(break_fault)
 
 (p8)	adds r28=16,r28				// A    switch cr.iip to next bundle
 (p9)	adds r8=1,r8				// A    increment ei to next slot
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	;;
 	mov b6=r30				// I0   setup syscall handler branch reg early
 #else
@@ -801,7 +801,7 @@ ENTRY(break_fault)
 	//
 ///////////////////////////////////////////////////////////////////////
 	st1 [r16]=r0				// M2|3 clear current->thread.on_ustack flag
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	MOV_FROM_ITC(p0, p14, r30, r18)		// M    get cycle for accounting
 #else
 	mov b6=r30				// I0   setup syscall handler branch reg early
@@ -817,7 +817,7 @@ ENTRY(break_fault)
 	cmp.eq p14,p0=r9,r0			// A    are syscalls being traced/audited?
 	br.call.sptk.many b7=ia64_syscall_setup	// B
 1:
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	// mov.m r30=ar.itc is called in advance, and r13 is current
 	add r16=TI_AC_STAMP+IA64_TASK_SIZE,r13	// A
 	add r17=TI_AC_LEAVE+IA64_TASK_SIZE,r13	// A
@@ -1043,7 +1043,7 @@ END(ia64_syscall_setup)
 	DBG_FAULT(16)
 	FAULT(16)
 
-#if defined(CONFIG_VIRT_CPU_ACCOUNTING) && defined(__IA64_ASM_PARAVIRTUALIZED_NATIVE)
+#if defined(CONFIG_VIRT_CPU_ACCOUNTING_NATIVE) && defined(__IA64_ASM_PARAVIRTUALIZED_NATIVE)
 	/*
 	 * There is no particular reason for this code to be here, other than
 	 * that there happens to be space here that would go unused otherwise.
diff --git a/arch/ia64/kernel/minstate.h b/arch/ia64/kernel/minstate.h
index d56753a..cc82a7d 100644
--- a/arch/ia64/kernel/minstate.h
+++ b/arch/ia64/kernel/minstate.h
@@ -4,7 +4,7 @@
 #include "entry.h"
 #include "paravirt_inst.h"
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 /* read ar.itc in advance, and use it before leaving bank 0 */
 #define ACCOUNT_GET_STAMP				\
 (pUStk) mov.m r20=ar.itc;
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 88a7945..fbaac1a 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -77,7 +77,7 @@ static struct clocksource clocksource_itc = {
 };
 static struct clocksource *itc_clocksource;
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 
 #include <linux/kernel_stat.h>
 
@@ -136,13 +136,14 @@ void vtime_account_system(struct task_struct *tsk)
 
 	account_system_time(tsk, 0, delta, delta);
 }
+EXPORT_SYMBOL_GPL(vtime_account_system);
 
 void vtime_account_idle(struct task_struct *tsk)
 {
 	account_idle_time(vtime_delta(tsk));
 }
 
-#endif /* CONFIG_VIRT_CPU_ACCOUNTING */
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 static irqreturn_t
 timer_interrupt (int irq, void *dev_id)
diff --git a/arch/powerpc/configs/chroma_defconfig b/arch/powerpc/configs/chroma_defconfig
index 29bb11e..4f35fc4 100644
--- a/arch/powerpc/configs/chroma_defconfig
+++ b/arch/powerpc/configs/chroma_defconfig
@@ -1,6 +1,6 @@
 CONFIG_PPC64=y
 CONFIG_PPC_BOOK3E_64=y
-# CONFIG_VIRT_CPU_ACCOUNTING is not set
+# CONFIG_VIRT_CPU_ACCOUNTING_NATIVE is not set
 CONFIG_SMP=y
 CONFIG_NR_CPUS=256
 CONFIG_EXPERIMENTAL=y
diff --git a/arch/powerpc/configs/corenet64_smp_defconfig b/arch/powerpc/configs/corenet64_smp_defconfig
index 88fa5c4..f7df836 100644
--- a/arch/powerpc/configs/corenet64_smp_defconfig
+++ b/arch/powerpc/configs/corenet64_smp_defconfig
@@ -1,6 +1,6 @@
 CONFIG_PPC64=y
 CONFIG_PPC_BOOK3E_64=y
-# CONFIG_VIRT_CPU_ACCOUNTING is not set
+# CONFIG_VIRT_CPU_ACCOUNTING_NATIVE is not set
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
 CONFIG_EXPERIMENTAL=y
diff --git a/arch/powerpc/configs/pasemi_defconfig b/arch/powerpc/configs/pasemi_defconfig
index 840a2c2..bcedeea 100644
--- a/arch/powerpc/configs/pasemi_defconfig
+++ b/arch/powerpc/configs/pasemi_defconfig
@@ -1,6 +1,6 @@
 CONFIG_PPC64=y
 CONFIG_ALTIVEC=y
-# CONFIG_VIRT_CPU_ACCOUNTING is not set
+# CONFIG_VIRT_CPU_ACCOUNTING_NATIVE is not set
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
 CONFIG_EXPERIMENTAL=y
diff --git a/arch/powerpc/include/asm/cputime.h b/arch/powerpc/include/asm/cputime.h
index 483733b..607559a 100644
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -8,7 +8,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  *
- * If we have CONFIG_VIRT_CPU_ACCOUNTING, we measure cpu time in
+ * If we have CONFIG_VIRT_CPU_ACCOUNTING_NATIVE, we measure cpu time in
  * the same units as the timebase.  Otherwise we measure cpu time
  * in jiffies using the generic definitions.
  */
@@ -16,7 +16,7 @@
 #ifndef __POWERPC_CPUTIME_H
 #define __POWERPC_CPUTIME_H
 
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 #include <asm-generic/cputime.h>
 #ifdef __KERNEL__
 static inline void setup_cputime_one_jiffy(void) { }
@@ -231,5 +231,5 @@ static inline cputime_t clock_t_to_cputime(const unsigned long clk)
 static inline void arch_vtime_task_switch(struct task_struct *tsk) { }
 
 #endif /* __KERNEL__ */
-#endif /* CONFIG_VIRT_CPU_ACCOUNTING */
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 #endif /* __POWERPC_CPUTIME_H */
diff --git a/arch/powerpc/include/asm/lppaca.h b/arch/powerpc/include/asm/lppaca.h
index 531fe0c..b1e7f2a 100644
--- a/arch/powerpc/include/asm/lppaca.h
+++ b/arch/powerpc/include/asm/lppaca.h
@@ -145,7 +145,7 @@ struct dtl_entry {
 extern struct kmem_cache *dtl_cache;
 
 /*
- * When CONFIG_VIRT_CPU_ACCOUNTING = y, the cpu accounting code controls
+ * When CONFIG_VIRT_CPU_ACCOUNTING_NATIVE = y, the cpu accounting code controls
  * reading from the dispatch trace log.  If other code wants to consume
  * DTL entries, it can set this pointer to a function that will get
  * called once for each DTL entry that gets processed.
diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/asm/ppc_asm.h
index ea2a86e..2d0e1f5 100644
--- a/arch/powerpc/include/asm/ppc_asm.h
+++ b/arch/powerpc/include/asm/ppc_asm.h
@@ -24,7 +24,7 @@
  * user_time and system_time fields in the paca.
  */
 
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 #define ACCOUNT_CPU_USER_ENTRY(ra, rb)
 #define ACCOUNT_CPU_USER_EXIT(ra, rb)
 #define ACCOUNT_STOLEN_TIME
@@ -70,7 +70,7 @@ END_FW_FTR_SECTION_IFSET(FW_FEATURE_SPLPAR)
 
 #endif /* CONFIG_PPC_SPLPAR */
 
-#endif /* CONFIG_VIRT_CPU_ACCOUNTING */
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 /*
  * Macros for storing registers into and loading registers from
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index b310a05..a0ca42f 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -94,7 +94,7 @@ system_call_common:
 	addi	r9,r1,STACK_FRAME_OVERHEAD
 	ld	r11,exception_marker@toc(r2)
 	std	r11,-16(r9)		/* "regshere" marker */
-#if defined(CONFIG_VIRT_CPU_ACCOUNTING) && defined(CONFIG_PPC_SPLPAR)
+#if defined(CONFIG_VIRT_CPU_ACCOUNTING_NATIVE) && defined(CONFIG_PPC_SPLPAR)
 BEGIN_FW_FTR_SECTION
 	beq	33f
 	/* if from user, see if there are any DTL entries to process */
@@ -110,7 +110,7 @@ BEGIN_FW_FTR_SECTION
 	addi	r9,r1,STACK_FRAME_OVERHEAD
 33:
 END_FW_FTR_SECTION_IFSET(FW_FEATURE_SPLPAR)
-#endif /* CONFIG_VIRT_CPU_ACCOUNTING && CONFIG_PPC_SPLPAR */
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE && CONFIG_PPC_SPLPAR */
 
 	/*
 	 * A syscall should always be called with interrupts enabled
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 6f6b1cc..2e04b37 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -143,7 +143,7 @@ EXPORT_SYMBOL_GPL(ppc_proc_freq);
 unsigned long ppc_tb_freq;
 EXPORT_SYMBOL_GPL(ppc_tb_freq);
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 /*
  * Factors for converting from cputime_t (timebase ticks) to
  * jiffies, microseconds, seconds, and clock_t (1/USER_HZ seconds).
@@ -347,6 +347,7 @@ void vtime_account_system(struct task_struct *tsk)
 	if (stolen)
 		account_steal_time(stolen);
 }
+EXPORT_SYMBOL_GPL(vtime_account_system);
 
 void vtime_account_idle(struct task_struct *tsk)
 {
@@ -377,7 +378,7 @@ void vtime_account_user(struct task_struct *tsk)
 	account_user_time(tsk, utime, utimescaled);
 }
 
-#else /* ! CONFIG_VIRT_CPU_ACCOUNTING */
+#else /* ! CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 #define calc_cputime_factors()
 #endif
 
diff --git a/arch/powerpc/platforms/cell/spufs/sched.c b/arch/powerpc/platforms/cell/spufs/sched.c
index 25db92a..4931838 100644
--- a/arch/powerpc/platforms/cell/spufs/sched.c
+++ b/arch/powerpc/platforms/cell/spufs/sched.c
@@ -24,6 +24,7 @@
 
 #include <linux/errno.h>
 #include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
diff --git a/arch/powerpc/platforms/pseries/dtl.c b/arch/powerpc/platforms/pseries/dtl.c
index a764854..0cc0ac0 100644
--- a/arch/powerpc/platforms/pseries/dtl.c
+++ b/arch/powerpc/platforms/pseries/dtl.c
@@ -57,7 +57,7 @@ static u8 dtl_event_mask = 0x7;
  */
 static int dtl_buf_entries = N_DISPATCH_LOG;
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 struct dtl_ring {
 	u64	write_index;
 	struct dtl_entry *write_ptr;
@@ -142,7 +142,7 @@ static u64 dtl_current_index(struct dtl *dtl)
 	return per_cpu(dtl_rings, dtl->cpu).write_index;
 }
 
-#else /* CONFIG_VIRT_CPU_ACCOUNTING */
+#else /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 static int dtl_start(struct dtl *dtl)
 {
@@ -188,7 +188,7 @@ static u64 dtl_current_index(struct dtl *dtl)
 {
 	return lppaca_of(dtl->cpu).dtl_idx;
 }
-#endif /* CONFIG_VIRT_CPU_ACCOUNTING */
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 static int dtl_enable(struct dtl *dtl)
 {
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index ca55882..527e12c 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -281,7 +281,7 @@ static struct notifier_block pci_dn_reconfig_nb = {
 
 struct kmem_cache *dtl_cache;
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 /*
  * Allocate space for the dispatch trace log for all possible cpus
  * and register the buffers with the hypervisor.  This is used for
@@ -332,12 +332,12 @@ static int alloc_dispatch_logs(void)
 
 	return 0;
 }
-#else /* !CONFIG_VIRT_CPU_ACCOUNTING */
+#else /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 static inline int alloc_dispatch_logs(void)
 {
 	return 0;
 }
-#endif /* CONFIG_VIRT_CPU_ACCOUNTING */
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 static int alloc_dispatch_log_kmem_cache(void)
 {
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index e84b8b6..ce9cc5a 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -127,7 +127,7 @@ void vtime_account_user(struct task_struct *tsk)
  * Update process times based on virtual cpu times stored by entry.S
  * to the lowcore fields user_timer, system_timer & steal_clock.
  */
-void vtime_account(struct task_struct *tsk)
+void vtime_account_irq_enter(struct task_struct *tsk)
 {
 	struct thread_info *ti = task_thread_info(tsk);
 	u64 timer, system;
@@ -145,10 +145,10 @@ void vtime_account(struct task_struct *tsk)
 
 	virt_timer_forward(system);
 }
-EXPORT_SYMBOL_GPL(vtime_account);
+EXPORT_SYMBOL_GPL(vtime_account_irq_enter);
 
 void vtime_account_system(struct task_struct *tsk)
-__attribute__((alias("vtime_account")));
+__attribute__((alias("vtime_account_irq_enter")));
 EXPORT_SYMBOL_GPL(vtime_account_system);
 
 void __kprobes vtime_stop_cpu(void)
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index d65464e..8d7012b 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -899,6 +899,7 @@ static void apm_cpu_idle(void)
 	static int use_apm_idle; /* = 0 */
 	static unsigned int last_jiffies; /* = 0 */
 	static unsigned int last_stime; /* = 0 */
+	cputime_t stime;
 
 	int apm_idle_done = 0;
 	unsigned int jiffies_since_last_check = jiffies - last_jiffies;
@@ -906,23 +907,23 @@ static void apm_cpu_idle(void)
 
 	WARN_ONCE(1, "deprecated apm_cpu_idle will be deleted in 2012");
 recalc:
+	task_cputime(current, NULL, &stime);
 	if (jiffies_since_last_check > IDLE_CALC_LIMIT) {
 		use_apm_idle = 0;
-		last_jiffies = jiffies;
-		last_stime = current->stime;
 	} else if (jiffies_since_last_check > idle_period) {
 		unsigned int idle_percentage;
 
-		idle_percentage = current->stime - last_stime;
+		idle_percentage = stime - last_stime;
 		idle_percentage *= 100;
 		idle_percentage /= jiffies_since_last_check;
 		use_apm_idle = (idle_percentage > idle_threshold);
 		if (apm_info.forbid_idle)
 			use_apm_idle = 0;
-		last_jiffies = jiffies;
-		last_stime = current->stime;
 	}
 
+	last_jiffies = jiffies;
+	last_stime = stime;
+
 	bucket = IDLE_LEAKY_MAX;
 
 	while (!need_resched()) {
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 74638ec..c88202f 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/sched/sysctl.h>
 
 #include "blk.h"
 
diff --git a/drivers/isdn/mISDN/stack.c b/drivers/isdn/mISDN/stack.c
index 5f21f62..deda591 100644
--- a/drivers/isdn/mISDN/stack.c
+++ b/drivers/isdn/mISDN/stack.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/mISDNif.h>
 #include <linux/kthread.h>
+#include <linux/sched.h>
 #include "core.h"
 
 static u_int	*debug;
@@ -202,6 +203,9 @@ static int
 mISDNStackd(void *data)
 {
 	struct mISDNstack *st = data;
+#ifdef MISDN_MSG_STATS
+	cputime_t utime, stime;
+#endif
 	int err = 0;
 
 	sigfillset(&current->blocked);
@@ -303,9 +307,10 @@ mISDNStackd(void *data)
 	       "msg %d sleep %d stopped\n",
 	       dev_name(&st->dev->dev), st->msg_cnt, st->sleep_cnt,
 	       st->stopped_cnt);
+	task_cputime(st->thread, &utime, &stime);
 	printk(KERN_DEBUG
 	       "mISDNStackd daemon for %s utime(%ld) stime(%ld)\n",
-	       dev_name(&st->dev->dev), st->thread->utime, st->thread->stime);
+	       dev_name(&st->dev->dev), utime, stime);
 	printk(KERN_DEBUG
 	       "mISDNStackd daemon for %s nvcsw(%ld) nivcsw(%ld)\n",
 	       dev_name(&st->dev->dev), st->thread->nvcsw, st->thread->nivcsw);
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 19ee901..3a6083b 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -33,7 +33,7 @@
 #include <linux/of_gpio.h>
 #include <linux/pm_runtime.h>
 #include <linux/export.h>
-#include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/ioport.h>
diff --git a/drivers/staging/csr/bh.c b/drivers/staging/csr/bh.c
index 1a1f5c7..7b13359 100644
--- a/drivers/staging/csr/bh.c
+++ b/drivers/staging/csr/bh.c
@@ -15,7 +15,7 @@
  */
 #include "csr_wifi_hip_unifi.h"
 #include "unifi_priv.h"
-
+#include <linux/sched/rt.h>
 
 /*
  * ---------------------------------------------------------------------------
diff --git a/drivers/staging/csr/unifi_sme.c b/drivers/staging/csr/unifi_sme.c
index 7c6c413..49395da 100644
--- a/drivers/staging/csr/unifi_sme.c
+++ b/drivers/staging/csr/unifi_sme.c
@@ -15,7 +15,7 @@
 #include "unifi_priv.h"
 #include "csr_wifi_hip_unifi.h"
 #include "csr_wifi_hip_conversions.h"
-
+#include <linux/sched/rt.h>
 
 
 
diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index b3c4a25..40e5b39 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -15,6 +15,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/interrupt.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 0c42cdb..49d0b43 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -33,6 +33,7 @@
 #include <linux/elf.h>
 #include <linux/utsname.h>
 #include <linux/coredump.h>
+#include <linux/sched.h>
 #include <asm/uaccess.h>
 #include <asm/param.h>
 #include <asm/page.h>
@@ -1320,8 +1321,11 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
 		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
 	} else {
-		cputime_to_timeval(p->utime, &prstatus->pr_utime);
-		cputime_to_timeval(p->stime, &prstatus->pr_stime);
+		cputime_t utime, stime;
+
+		task_cputime(p, &utime, &stime);
+		cputime_to_timeval(utime, &prstatus->pr_utime);
+		cputime_to_timeval(stime, &prstatus->pr_stime);
 	}
 	cputime_to_timeval(p->signal->cutime, &prstatus->pr_cutime);
 	cputime_to_timeval(p->signal->cstime, &prstatus->pr_cstime);
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index dc84732..cb240dd 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1375,8 +1375,11 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
 		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
 	} else {
-		cputime_to_timeval(p->utime, &prstatus->pr_utime);
-		cputime_to_timeval(p->stime, &prstatus->pr_stime);
+		cputime_t utime, stime;
+
+		task_cputime(p, &utime, &stime);
+		cputime_to_timeval(utime, &prstatus->pr_utime);
+		cputime_to_timeval(stime, &prstatus->pr_stime);
 	}
 	cputime_to_timeval(p->signal->cutime, &prstatus->pr_cutime);
 	cputime_to_timeval(p->signal->cstime, &prstatus->pr_cstime);
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 6a91e6f..f7ed9ee 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -449,7 +449,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 			do {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
-				gtime += t->gtime;
+				gtime += task_gtime(t);
 				t = next_thread(t);
 			} while (t != task);
 
@@ -472,7 +472,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
 		task_cputime_adjusted(task, &utime, &stime);
-		gtime = task->gtime;
+		gtime = task_gtime(task);
 	}
 
 	/* scale priority and nice values from timeslices to -20..20 */
diff --git a/fs/select.c b/fs/select.c
index 2ef72d9..8c1c96c 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -26,6 +26,7 @@
 #include <linux/fs.h>
 #include <linux/rcupdate.h>
 #include <linux/hrtimer.h>
+#include <linux/sched/rt.h>
 
 #include <asm/uaccess.h>
 
diff --git a/include/asm-generic/cputime.h b/include/asm-generic/cputime.h
index 9a62937..5196943 100644
--- a/include/asm-generic/cputime.h
+++ b/include/asm-generic/cputime.h
@@ -4,66 +4,12 @@
 #include <linux/time.h>
 #include <linux/jiffies.h>
 
-typedef unsigned long __nocast cputime_t;
-
-#define cputime_one_jiffy		jiffies_to_cputime(1)
-#define cputime_to_jiffies(__ct)	(__force unsigned long)(__ct)
-#define cputime_to_scaled(__ct)		(__ct)
-#define jiffies_to_cputime(__hz)	(__force cputime_t)(__hz)
-
-typedef u64 __nocast cputime64_t;
-
-#define cputime64_to_jiffies64(__ct)	(__force u64)(__ct)
-#define jiffies64_to_cputime64(__jif)	(__force cputime64_t)(__jif)
-
-#define nsecs_to_cputime64(__ct)	\
-	jiffies64_to_cputime64(nsecs_to_jiffies64(__ct))
-
-
-/*
- * Convert cputime to microseconds and back.
- */
-#define cputime_to_usecs(__ct)		\
-	jiffies_to_usecs(cputime_to_jiffies(__ct))
-#define usecs_to_cputime(__usec)	\
-	jiffies_to_cputime(usecs_to_jiffies(__usec))
-#define usecs_to_cputime64(__usec)	\
-	jiffies64_to_cputime64(nsecs_to_jiffies64((__usec) * 1000))
-
-/*
- * Convert cputime to seconds and back.
- */
-#define cputime_to_secs(jif)		(cputime_to_jiffies(jif) / HZ)
-#define secs_to_cputime(sec)		jiffies_to_cputime((sec) * HZ)
-
-/*
- * Convert cputime to timespec and back.
- */
-#define timespec_to_cputime(__val)	\
-	jiffies_to_cputime(timespec_to_jiffies(__val))
-#define cputime_to_timespec(__ct,__val)	\
-	jiffies_to_timespec(cputime_to_jiffies(__ct),__val)
-
-/*
- * Convert cputime to timeval and back.
- */
-#define timeval_to_cputime(__val)	\
-	jiffies_to_cputime(timeval_to_jiffies(__val))
-#define cputime_to_timeval(__ct,__val)	\
-	jiffies_to_timeval(cputime_to_jiffies(__ct),__val)
-
-/*
- * Convert cputime to clock and back.
- */
-#define cputime_to_clock_t(__ct)	\
-	jiffies_to_clock_t(cputime_to_jiffies(__ct))
-#define clock_t_to_cputime(__x)		\
-	jiffies_to_cputime(clock_t_to_jiffies(__x))
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+# include <asm-generic/cputime_jiffies.h>
+#endif
 
-/*
- * Convert cputime64 to clock.
- */
-#define cputime64_to_clock_t(__ct)	\
-	jiffies_64_to_clock_t(cputime64_to_jiffies64(__ct))
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+# include <asm-generic/cputime_nsecs.h>
+#endif
 
 #endif
diff --git a/include/asm-generic/cputime_jiffies.h b/include/asm-generic/cputime_jiffies.h
new file mode 100644
index 0000000..272ecba
--- /dev/null
+++ b/include/asm-generic/cputime_jiffies.h
@@ -0,0 +1,72 @@
+#ifndef _ASM_GENERIC_CPUTIME_JIFFIES_H
+#define _ASM_GENERIC_CPUTIME_JIFFIES_H
+
+typedef unsigned long __nocast cputime_t;
+
+#define cputime_one_jiffy		jiffies_to_cputime(1)
+#define cputime_to_jiffies(__ct)	(__force unsigned long)(__ct)
+#define cputime_to_scaled(__ct)		(__ct)
+#define jiffies_to_cputime(__hz)	(__force cputime_t)(__hz)
+
+typedef u64 __nocast cputime64_t;
+
+#define cputime64_to_jiffies64(__ct)	(__force u64)(__ct)
+#define jiffies64_to_cputime64(__jif)	(__force cputime64_t)(__jif)
+
+
+/*
+ * Convert nanoseconds to cputime
+ */
+#define nsecs_to_cputime64(__nsec)	\
+	jiffies64_to_cputime64(nsecs_to_jiffies64(__nsec))
+#define nsecs_to_cputime(__nsec)	\
+	jiffies_to_cputime(nsecs_to_jiffies(__nsec))
+
+
+/*
+ * Convert cputime to microseconds and back.
+ */
+#define cputime_to_usecs(__ct)		\
+	jiffies_to_usecs(cputime_to_jiffies(__ct))
+#define usecs_to_cputime(__usec)	\
+	jiffies_to_cputime(usecs_to_jiffies(__usec))
+#define usecs_to_cputime64(__usec)	\
+	jiffies64_to_cputime64(nsecs_to_jiffies64((__usec) * 1000))
+
+/*
+ * Convert cputime to seconds and back.
+ */
+#define cputime_to_secs(jif)		(cputime_to_jiffies(jif) / HZ)
+#define secs_to_cputime(sec)		jiffies_to_cputime((sec) * HZ)
+
+/*
+ * Convert cputime to timespec and back.
+ */
+#define timespec_to_cputime(__val)	\
+	jiffies_to_cputime(timespec_to_jiffies(__val))
+#define cputime_to_timespec(__ct,__val)	\
+	jiffies_to_timespec(cputime_to_jiffies(__ct),__val)
+
+/*
+ * Convert cputime to timeval and back.
+ */
+#define timeval_to_cputime(__val)	\
+	jiffies_to_cputime(timeval_to_jiffies(__val))
+#define cputime_to_timeval(__ct,__val)	\
+	jiffies_to_timeval(cputime_to_jiffies(__ct),__val)
+
+/*
+ * Convert cputime to clock and back.
+ */
+#define cputime_to_clock_t(__ct)	\
+	jiffies_to_clock_t(cputime_to_jiffies(__ct))
+#define clock_t_to_cputime(__x)		\
+	jiffies_to_cputime(clock_t_to_jiffies(__x))
+
+/*
+ * Convert cputime64 to clock.
+ */
+#define cputime64_to_clock_t(__ct)	\
+	jiffies_64_to_clock_t(cputime64_to_jiffies64(__ct))
+
+#endif
diff --git a/include/asm-generic/cputime_nsecs.h b/include/asm-generic/cputime_nsecs.h
new file mode 100644
index 0000000..b6485ca
--- /dev/null
+++ b/include/asm-generic/cputime_nsecs.h
@@ -0,0 +1,104 @@
+/*
+ * Definitions for measuring cputime in nsecs resolution.
+ *
+ * Based on <arch/ia64/include/asm/cputime.h>
+ *
+ * Copyright (C) 2007 FUJITSU LIMITED
+ * Copyright (C) 2007 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ */
+
+#ifndef _ASM_GENERIC_CPUTIME_NSECS_H
+#define _ASM_GENERIC_CPUTIME_NSECS_H
+
+typedef u64 __nocast cputime_t;
+typedef u64 __nocast cputime64_t;
+
+#define cputime_one_jiffy		jiffies_to_cputime(1)
+
+/*
+ * Convert cputime <-> jiffies (HZ)
+ */
+#define cputime_to_jiffies(__ct)	\
+	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
+#define cputime_to_scaled(__ct)		(__ct)
+#define jiffies_to_cputime(__jif)	\
+	(__force cputime_t)((__jif) * (NSEC_PER_SEC / HZ))
+#define cputime64_to_jiffies64(__ct)	\
+	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
+#define jiffies64_to_cputime64(__jif)	\
+	(__force cputime64_t)((__jif) * (NSEC_PER_SEC / HZ))
+
+
+/*
+ * Convert cputime <-> nanoseconds
+ */
+#define nsecs_to_cputime(__nsecs)	((__force u64)(__nsecs))
+
+
+/*
+ * Convert cputime <-> microseconds
+ */
+#define cputime_to_usecs(__ct)		\
+	((__force u64)(__ct) / NSEC_PER_USEC)
+#define usecs_to_cputime(__usecs)	\
+	(__force cputime_t)((__usecs) * NSEC_PER_USEC)
+#define usecs_to_cputime64(__usecs)	\
+	(__force cputime64_t)((__usecs) * NSEC_PER_USEC)
+
+/*
+ * Convert cputime <-> seconds
+ */
+#define cputime_to_secs(__ct)		\
+	((__force u64)(__ct) / NSEC_PER_SEC)
+#define secs_to_cputime(__secs)		\
+	(__force cputime_t)((__secs) * NSEC_PER_SEC)
+
+/*
+ * Convert cputime <-> timespec (nsec)
+ */
+static inline cputime_t timespec_to_cputime(const struct timespec *val)
+{
+	u64 ret = val->tv_sec * NSEC_PER_SEC + val->tv_nsec;
+	return (__force cputime_t) ret;
+}
+static inline void cputime_to_timespec(const cputime_t ct, struct timespec *val)
+{
+	val->tv_sec  = (__force u64) ct / NSEC_PER_SEC;
+	val->tv_nsec = (__force u64) ct % NSEC_PER_SEC;
+}
+
+/*
+ * Convert cputime <-> timeval (msec)
+ */
+static inline cputime_t timeval_to_cputime(struct timeval *val)
+{
+	u64 ret = val->tv_sec * NSEC_PER_SEC + val->tv_usec * NSEC_PER_USEC;
+	return (__force cputime_t) ret;
+}
+static inline void cputime_to_timeval(const cputime_t ct, struct timeval *val)
+{
+	val->tv_sec = (__force u64) ct / NSEC_PER_SEC;
+	val->tv_usec = ((__force u64) ct % NSEC_PER_SEC) / NSEC_PER_USEC;
+}
+
+/*
+ * Convert cputime <-> clock (USER_HZ)
+ */
+#define cputime_to_clock_t(__ct)	\
+	((__force u64)(__ct) / (NSEC_PER_SEC / USER_HZ))
+#define clock_t_to_cputime(__x)		\
+	(__force cputime_t)((__x) * (NSEC_PER_SEC / USER_HZ))
+
+/*
+ * Convert cputime64 to clock.
+ */
+#define cputime64_to_clock_t(__ct)	\
+	cputime_to_clock_t((__force cputime_t)__ct)
+
+#endif
diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index e24339c..b28d161 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -3,12 +3,40 @@
 
 #ifdef CONFIG_CONTEXT_TRACKING
 #include <linux/sched.h>
+#include <linux/percpu.h>
+
+struct context_tracking {
+	/*
+	 * When active is false, probes are unset in order
+	 * to minimize overhead: TIF flags are cleared
+	 * and calls to user_enter/exit are ignored. This
+	 * may be further optimized using static keys.
+	 */
+	bool active;
+	enum {
+		IN_KERNEL = 0,
+		IN_USER,
+	} state;
+};
+
+DECLARE_PER_CPU(struct context_tracking, context_tracking);
+
+static inline bool context_tracking_in_user(void)
+{
+	return __this_cpu_read(context_tracking.state) == IN_USER;
+}
+
+static inline bool context_tracking_active(void)
+{
+	return __this_cpu_read(context_tracking.active);
+}
 
 extern void user_enter(void);
 extern void user_exit(void);
 extern void context_tracking_task_switch(struct task_struct *prev,
 					 struct task_struct *next);
 #else
+static inline bool context_tracking_in_user(void) { return false; }
 static inline void user_enter(void) { }
 static inline void user_exit(void) { }
 static inline void context_tracking_task_switch(struct task_struct *prev,
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 624ef3f..7105d5c 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -153,7 +153,7 @@ extern void rcu_nmi_exit(void);
  */
 #define __irq_enter()					\
 	do {						\
-		vtime_account_irq_enter(current);	\
+		account_irq_enter_time(current);	\
 		add_preempt_count(HARDIRQ_OFFSET);	\
 		trace_hardirq_enter();			\
 	} while (0)
@@ -169,7 +169,7 @@ extern void irq_enter(void);
 #define __irq_exit()					\
 	do {						\
 		trace_hardirq_exit();			\
-		vtime_account_irq_exit(current);	\
+		account_irq_exit_time(current);		\
 		sub_preempt_count(HARDIRQ_OFFSET);	\
 	} while (0)
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 6d087c5..5cd0f09 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -10,7 +10,9 @@
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/securebits.h>
+#include <linux/seqlock.h>
 #include <net/net_namespace.h>
+#include <linux/sched/rt.h>
 
 #ifdef CONFIG_SMP
 # define INIT_PUSHABLE_TASKS(tsk)					\
@@ -141,6 +143,15 @@ extern struct task_group root_task_group;
 # define INIT_PERF_EVENTS(tsk)
 #endif
 
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+# define INIT_VTIME(tsk)						\
+	.vtime_seqlock = __SEQLOCK_UNLOCKED(tsk.vtime_seqlock),	\
+	.vtime_snap = 0,				\
+	.vtime_snap_whence = VTIME_SYS,
+#else
+# define INIT_VTIME(tsk)
+#endif
+
 #define INIT_TASK_COMM "swapper"
 
 /*
@@ -210,6 +221,7 @@ extern struct task_group root_task_group;
 	INIT_TRACE_RECURSION						\
 	INIT_TASK_RCU_PREEMPT(tsk)					\
 	INIT_CPUSET_SEQ							\
+	INIT_VTIME(tsk)							\
 }
 
 
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 66b7078..ed5f6ed 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -127,7 +127,7 @@ extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t)
 extern void account_steal_time(cputime_t);
 extern void account_idle_time(cputime_t);
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 static inline void account_process_tick(struct task_struct *tsk, int user)
 {
 	vtime_account_user(tsk);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2c497ab..b7996a7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -22,6 +22,7 @@
 #include <linux/rcupdate.h>
 #include <linux/ratelimit.h>
 #include <linux/err.h>
+#include <linux/irqflags.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -740,15 +741,52 @@ static inline int kvm_deassign_device(struct kvm *kvm,
 }
 #endif /* CONFIG_IOMMU_API */
 
-static inline void kvm_guest_enter(void)
+static inline void __guest_enter(void)
 {
-	BUG_ON(preemptible());
 	/*
 	 * This is running in ioctl context so we can avoid
 	 * the call to vtime_account() with its unnecessary idle check.
 	 */
-	vtime_account_system_irqsafe(current);
+	vtime_account_system(current);
 	current->flags |= PF_VCPU;
+}
+
+static inline void __guest_exit(void)
+{
+	/*
+	 * This is running in ioctl context so we can avoid
+	 * the call to vtime_account() with its unnecessary idle check.
+	 */
+	vtime_account_system(current);
+	current->flags &= ~PF_VCPU;
+}
+
+#ifdef CONFIG_CONTEXT_TRACKING
+extern void guest_enter(void);
+extern void guest_exit(void);
+
+#else /* !CONFIG_CONTEXT_TRACKING */
+static inline void guest_enter(void)
+{
+	__guest_enter();
+}
+
+static inline void guest_exit(void)
+{
+	__guest_exit();
+}
+#endif /* !CONFIG_CONTEXT_TRACKING */
+
+static inline void kvm_guest_enter(void)
+{
+	unsigned long flags;
+
+	BUG_ON(preemptible());
+
+	local_irq_save(flags);
+	guest_enter();
+	local_irq_restore(flags);
+
 	/* KVM does not hold any references to rcu protected data when it
 	 * switches CPU into a guest mode. In fact switching to a guest mode
 	 * is very similar to exiting to userspase from rcu point of view. In
@@ -761,12 +799,11 @@ static inline void kvm_guest_enter(void)
 
 static inline void kvm_guest_exit(void)
 {
-	/*
-	 * This is running in ioctl context so we can avoid
-	 * the call to vtime_account() with its unnecessary idle check.
-	 */
-	vtime_account_system_irqsafe(current);
-	current->flags &= ~PF_VCPU;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	guest_exit();
+	local_irq_restore(flags);
 }
 
 /*
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d211247..33cc421 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -304,19 +304,6 @@ static inline void lockup_detector_init(void)
 }
 #endif
 
-#ifdef CONFIG_DETECT_HUNG_TASK
-extern unsigned int  sysctl_hung_task_panic;
-extern unsigned long sysctl_hung_task_check_count;
-extern unsigned long sysctl_hung_task_timeout_secs;
-extern unsigned long sysctl_hung_task_warnings;
-extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
-					 void __user *buffer,
-					 size_t *lenp, loff_t *ppos);
-#else
-/* Avoid need for ifdefs elsewhere in the code */
-enum { sysctl_hung_task_timeout_secs = 0 };
-#endif
-
 /* Attach to any functions which should be ignored in wchan output. */
 #define __sched		__attribute__((__section__(".sched.text")))
 
@@ -338,23 +325,6 @@ extern int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner);
 struct nsproxy;
 struct user_namespace;
 
-/*
- * Default maximum number of active map areas, this limits the number of vmas
- * per mm struct. Users can overwrite this number by sysctl but there is a
- * problem.
- *
- * When a program's coredump is generated as ELF format, a section is created
- * per a vma. In ELF, the number of sections is represented in unsigned short.
- * This means the number of sections should be smaller than 65535 at coredump.
- * Because the kernel adds some informative sections to a image of program at
- * generating coredump, we need some margin. The number of extra sections is
- * 1-3 now and depends on arch. We use "5" as safe margin, here.
- */
-#define MAPCOUNT_ELF_CORE_MARGIN	(5)
-#define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
-
-extern int sysctl_max_map_count;
-
 #include <linux/aio.h>
 
 #ifdef CONFIG_MMU
@@ -1194,6 +1164,7 @@ struct sched_entity {
 	/* rq "owned" by this entity/group: */
 	struct cfs_rq		*my_q;
 #endif
+
 /*
  * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
  * removed when useful for applications beyond shares distribution (e.g.
@@ -1208,6 +1179,7 @@ struct sched_entity {
 struct sched_rt_entity {
 	struct list_head run_list;
 	unsigned long timeout;
+	unsigned long watchdog_stamp;
 	unsigned int time_slice;
 
 	struct sched_rt_entity *back;
@@ -1220,11 +1192,6 @@ struct sched_rt_entity {
 #endif
 };
 
-/*
- * default timeslice is 100 msecs (used only for SCHED_RR tasks).
- * Timeslices get refilled after they expire.
- */
-#define RR_TIMESLICE		(100 * HZ / 1000)
 
 struct rcu_node;
 
@@ -1368,6 +1335,15 @@ struct task_struct {
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	struct cputime prev_cputime;
 #endif
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+	seqlock_t vtime_seqlock;
+	unsigned long long vtime_snap;
+	enum {
+		VTIME_SLEEPING = 0,
+		VTIME_USER,
+		VTIME_SYS,
+	} vtime_snap_whence;
+#endif
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
 	struct timespec real_start_time;	/* boot based time */
@@ -1622,37 +1598,6 @@ static inline void set_numabalancing_state(bool enabled)
 }
 #endif
 
-/*
- * Priority of a process goes from 0..MAX_PRIO-1, valid RT
- * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
- * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1. Priority
- * values are inverted: lower p->prio value means higher priority.
- *
- * The MAX_USER_RT_PRIO value allows the actual maximum
- * RT priority to be separate from the value exported to
- * user-space.  This allows kernel threads to set their
- * priority to a value higher than any user task. Note:
- * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
- */
-
-#define MAX_USER_RT_PRIO	100
-#define MAX_RT_PRIO		MAX_USER_RT_PRIO
-
-#define MAX_PRIO		(MAX_RT_PRIO + 40)
-#define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
-
-static inline int rt_prio(int prio)
-{
-	if (unlikely(prio < MAX_RT_PRIO))
-		return 1;
-	return 0;
-}
-
-static inline int rt_task(struct task_struct *p)
-{
-	return rt_prio(p->prio);
-}
-
 static inline struct pid *task_pid(struct task_struct *task)
 {
 	return task->pids[PIDTYPE_PID].pid;
@@ -1792,6 +1737,37 @@ static inline void put_task_struct(struct task_struct *t)
 		__put_task_struct(t);
 }
 
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+extern void task_cputime(struct task_struct *t,
+			 cputime_t *utime, cputime_t *stime);
+extern void task_cputime_scaled(struct task_struct *t,
+				cputime_t *utimescaled, cputime_t *stimescaled);
+extern cputime_t task_gtime(struct task_struct *t);
+#else
+static inline void task_cputime(struct task_struct *t,
+				cputime_t *utime, cputime_t *stime)
+{
+	if (utime)
+		*utime = t->utime;
+	if (stime)
+		*stime = t->stime;
+}
+
+static inline void task_cputime_scaled(struct task_struct *t,
+				       cputime_t *utimescaled,
+				       cputime_t *stimescaled)
+{
+	if (utimescaled)
+		*utimescaled = t->utimescaled;
+	if (stimescaled)
+		*stimescaled = t->stimescaled;
+}
+
+static inline cputime_t task_gtime(struct task_struct *t)
+{
+	return t->gtime;
+}
+#endif
 extern void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 
@@ -2033,58 +2009,7 @@ extern void wake_up_idle_cpu(int cpu);
 static inline void wake_up_idle_cpu(int cpu) { }
 #endif
 
-extern unsigned int sysctl_sched_latency;
-extern unsigned int sysctl_sched_min_granularity;
-extern unsigned int sysctl_sched_wakeup_granularity;
-extern unsigned int sysctl_sched_child_runs_first;
-
-enum sched_tunable_scaling {
-	SCHED_TUNABLESCALING_NONE,
-	SCHED_TUNABLESCALING_LOG,
-	SCHED_TUNABLESCALING_LINEAR,
-	SCHED_TUNABLESCALING_END,
-};
-extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;
-
-extern unsigned int sysctl_numa_balancing_scan_delay;
-extern unsigned int sysctl_numa_balancing_scan_period_min;
-extern unsigned int sysctl_numa_balancing_scan_period_max;
-extern unsigned int sysctl_numa_balancing_scan_period_reset;
-extern unsigned int sysctl_numa_balancing_scan_size;
-extern unsigned int sysctl_numa_balancing_settle_count;
-
-#ifdef CONFIG_SCHED_DEBUG
-extern unsigned int sysctl_sched_migration_cost;
-extern unsigned int sysctl_sched_nr_migrate;
-extern unsigned int sysctl_sched_time_avg;
-extern unsigned int sysctl_timer_migration;
-extern unsigned int sysctl_sched_shares_window;
-
-int sched_proc_update_handler(struct ctl_table *table, int write,
-		void __user *buffer, size_t *length,
-		loff_t *ppos);
-#endif
-#ifdef CONFIG_SCHED_DEBUG
-static inline unsigned int get_sysctl_timer_migration(void)
-{
-	return sysctl_timer_migration;
-}
-#else
-static inline unsigned int get_sysctl_timer_migration(void)
-{
-	return 1;
-}
-#endif
-extern unsigned int sysctl_sched_rt_period;
-extern int sysctl_sched_rt_runtime;
-
-int sched_rt_handler(struct ctl_table *table, int write,
-		void __user *buffer, size_t *lenp,
-		loff_t *ppos);
-
 #ifdef CONFIG_SCHED_AUTOGROUP
-extern unsigned int sysctl_sched_autogroup_enabled;
-
 extern void sched_autogroup_create_attach(struct task_struct *p);
 extern void sched_autogroup_detach(struct task_struct *p);
 extern void sched_autogroup_fork(struct signal_struct *sig);
@@ -2100,30 +2025,6 @@ static inline void sched_autogroup_fork(struct signal_struct *sig) { }
 static inline void sched_autogroup_exit(struct signal_struct *sig) { }
 #endif
 
-#ifdef CONFIG_CFS_BANDWIDTH
-extern unsigned int sysctl_sched_cfs_bandwidth_slice;
-#endif
-
-#ifdef CONFIG_RT_MUTEXES
-extern int rt_mutex_getprio(struct task_struct *p);
-extern void rt_mutex_setprio(struct task_struct *p, int prio);
-extern void rt_mutex_adjust_pi(struct task_struct *p);
-static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
-{
-	return tsk->pi_blocked_on != NULL;
-}
-#else
-static inline int rt_mutex_getprio(struct task_struct *p)
-{
-	return p->normal_prio;
-}
-# define rt_mutex_adjust_pi(p)		do { } while (0)
-static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
-{
-	return false;
-}
-#endif
-
 extern bool yield_to(struct task_struct *p, bool preempt);
 extern void set_user_nice(struct task_struct *p, long nice);
 extern int task_prio(const struct task_struct *p);
@@ -2753,8 +2654,6 @@ static inline void set_task_cpu(struct task_struct *p, unsigned int cpu)
 extern long sched_setaffinity(pid_t pid, const struct cpumask *new_mask);
 extern long sched_getaffinity(pid_t pid, struct cpumask *mask);
 
-extern void normalize_rt_tasks(void);
-
 #ifdef CONFIG_CGROUP_SCHED
 
 extern struct task_group root_task_group;
diff --git a/include/linux/sched/rt.h b/include/linux/sched/rt.h
new file mode 100644
index 0000000..94e19ea
--- /dev/null
+++ b/include/linux/sched/rt.h
@@ -0,0 +1,58 @@
+#ifndef _SCHED_RT_H
+#define _SCHED_RT_H
+
+/*
+ * Priority of a process goes from 0..MAX_PRIO-1, valid RT
+ * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
+ * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1. Priority
+ * values are inverted: lower p->prio value means higher priority.
+ *
+ * The MAX_USER_RT_PRIO value allows the actual maximum
+ * RT priority to be separate from the value exported to
+ * user-space.  This allows kernel threads to set their
+ * priority to a value higher than any user task. Note:
+ * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
+ */
+
+#define MAX_USER_RT_PRIO	100
+#define MAX_RT_PRIO		MAX_USER_RT_PRIO
+
+#define MAX_PRIO		(MAX_RT_PRIO + 40)
+#define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
+
+static inline int rt_prio(int prio)
+{
+	if (unlikely(prio < MAX_RT_PRIO))
+		return 1;
+	return 0;
+}
+
+static inline int rt_task(struct task_struct *p)
+{
+	return rt_prio(p->prio);
+}
+
+#ifdef CONFIG_RT_MUTEXES
+extern int rt_mutex_getprio(struct task_struct *p);
+extern void rt_mutex_setprio(struct task_struct *p, int prio);
+extern void rt_mutex_adjust_pi(struct task_struct *p);
+static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
+{
+	return tsk->pi_blocked_on != NULL;
+}
+#else
+static inline int rt_mutex_getprio(struct task_struct *p)
+{
+	return p->normal_prio;
+}
+# define rt_mutex_adjust_pi(p)		do { } while (0)
+static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
+{
+	return false;
+}
+#endif
+
+extern void normalize_rt_tasks(void);
+
+
+#endif /* _SCHED_RT_H */
diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
new file mode 100644
index 0000000..d2bb0ae
--- /dev/null
+++ b/include/linux/sched/sysctl.h
@@ -0,0 +1,110 @@
+#ifndef _SCHED_SYSCTL_H
+#define _SCHED_SYSCTL_H
+
+#ifdef CONFIG_DETECT_HUNG_TASK
+extern unsigned int  sysctl_hung_task_panic;
+extern unsigned long sysctl_hung_task_check_count;
+extern unsigned long sysctl_hung_task_timeout_secs;
+extern unsigned long sysctl_hung_task_warnings;
+extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
+					 void __user *buffer,
+					 size_t *lenp, loff_t *ppos);
+#else
+/* Avoid need for ifdefs elsewhere in the code */
+enum { sysctl_hung_task_timeout_secs = 0 };
+#endif
+
+/*
+ * Default maximum number of active map areas, this limits the number of vmas
+ * per mm struct. Users can overwrite this number by sysctl but there is a
+ * problem.
+ *
+ * When a program's coredump is generated as ELF format, a section is created
+ * per a vma. In ELF, the number of sections is represented in unsigned short.
+ * This means the number of sections should be smaller than 65535 at coredump.
+ * Because the kernel adds some informative sections to a image of program at
+ * generating coredump, we need some margin. The number of extra sections is
+ * 1-3 now and depends on arch. We use "5" as safe margin, here.
+ */
+#define MAPCOUNT_ELF_CORE_MARGIN	(5)
+#define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
+
+extern int sysctl_max_map_count;
+
+extern unsigned int sysctl_sched_latency;
+extern unsigned int sysctl_sched_min_granularity;
+extern unsigned int sysctl_sched_wakeup_granularity;
+extern unsigned int sysctl_sched_child_runs_first;
+
+enum sched_tunable_scaling {
+	SCHED_TUNABLESCALING_NONE,
+	SCHED_TUNABLESCALING_LOG,
+	SCHED_TUNABLESCALING_LINEAR,
+	SCHED_TUNABLESCALING_END,
+};
+extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;
+
+extern unsigned int sysctl_numa_balancing_scan_delay;
+extern unsigned int sysctl_numa_balancing_scan_period_min;
+extern unsigned int sysctl_numa_balancing_scan_period_max;
+extern unsigned int sysctl_numa_balancing_scan_period_reset;
+extern unsigned int sysctl_numa_balancing_scan_size;
+extern unsigned int sysctl_numa_balancing_settle_count;
+
+#ifdef CONFIG_SCHED_DEBUG
+extern unsigned int sysctl_sched_migration_cost;
+extern unsigned int sysctl_sched_nr_migrate;
+extern unsigned int sysctl_sched_time_avg;
+extern unsigned int sysctl_timer_migration;
+extern unsigned int sysctl_sched_shares_window;
+
+int sched_proc_update_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *length,
+		loff_t *ppos);
+#endif
+#ifdef CONFIG_SCHED_DEBUG
+static inline unsigned int get_sysctl_timer_migration(void)
+{
+	return sysctl_timer_migration;
+}
+#else
+static inline unsigned int get_sysctl_timer_migration(void)
+{
+	return 1;
+}
+#endif
+
+/*
+ *  control realtime throttling:
+ *
+ *  /proc/sys/kernel/sched_rt_period_us
+ *  /proc/sys/kernel/sched_rt_runtime_us
+ */
+extern unsigned int sysctl_sched_rt_period;
+extern int sysctl_sched_rt_runtime;
+
+#ifdef CONFIG_CFS_BANDWIDTH
+extern unsigned int sysctl_sched_cfs_bandwidth_slice;
+#endif
+
+#ifdef CONFIG_SCHED_AUTOGROUP
+extern unsigned int sysctl_sched_autogroup_enabled;
+#endif
+
+/*
+ * default timeslice is 100 msecs (used only for SCHED_RR tasks).
+ * Timeslices get refilled after they expire.
+ */
+#define RR_TIMESLICE		(100 * HZ / 1000)
+
+extern int sched_rr_timeslice;
+
+extern int sched_rr_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+
+extern int sched_rt_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+
+#endif /* _SCHED_SYSCTL_H */
diff --git a/include/linux/tsacct_kern.h b/include/linux/tsacct_kern.h
index 44893e5..3251965 100644
--- a/include/linux/tsacct_kern.h
+++ b/include/linux/tsacct_kern.h
@@ -23,12 +23,15 @@ static inline void bacct_add_tsk(struct user_namespace *user_ns,
 #ifdef CONFIG_TASK_XACCT
 extern void xacct_add_tsk(struct taskstats *stats, struct task_struct *p);
 extern void acct_update_integrals(struct task_struct *tsk);
+extern void acct_account_cputime(struct task_struct *tsk);
 extern void acct_clear_integrals(struct task_struct *tsk);
 #else
 static inline void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
 {}
 static inline void acct_update_integrals(struct task_struct *tsk)
 {}
+static inline void acct_account_cputime(struct task_struct *tsk)
+{}
 static inline void acct_clear_integrals(struct task_struct *tsk)
 {}
 #endif /* CONFIG_TASK_XACCT */
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index ae30ab5..71a5782 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -6,15 +6,46 @@ struct task_struct;
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 extern void vtime_task_switch(struct task_struct *prev);
 extern void vtime_account_system(struct task_struct *tsk);
-extern void vtime_account_system_irqsafe(struct task_struct *tsk);
 extern void vtime_account_idle(struct task_struct *tsk);
 extern void vtime_account_user(struct task_struct *tsk);
-extern void vtime_account(struct task_struct *tsk);
-#else
+extern void vtime_account_irq_enter(struct task_struct *tsk);
+
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
+static inline bool vtime_accounting_enabled(void) { return true; }
+#endif
+
+#else /* !CONFIG_VIRT_CPU_ACCOUNTING */
+
 static inline void vtime_task_switch(struct task_struct *prev) { }
 static inline void vtime_account_system(struct task_struct *tsk) { }
-static inline void vtime_account_system_irqsafe(struct task_struct *tsk) { }
-static inline void vtime_account(struct task_struct *tsk) { }
+static inline void vtime_account_user(struct task_struct *tsk) { }
+static inline void vtime_account_irq_enter(struct task_struct *tsk) { }
+static inline bool vtime_accounting_enabled(void) { return false; }
+#endif
+
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+extern void arch_vtime_task_switch(struct task_struct *tsk);
+extern void vtime_account_irq_exit(struct task_struct *tsk);
+extern bool vtime_accounting_enabled(void);
+extern void vtime_user_enter(struct task_struct *tsk);
+static inline void vtime_user_exit(struct task_struct *tsk)
+{
+	vtime_account_user(tsk);
+}
+extern void vtime_guest_enter(struct task_struct *tsk);
+extern void vtime_guest_exit(struct task_struct *tsk);
+extern void vtime_init_idle(struct task_struct *tsk);
+#else
+static inline void vtime_account_irq_exit(struct task_struct *tsk)
+{
+	/* On hard|softirq exit we always account to hard|softirq cputime */
+	vtime_account_system(tsk);
+}
+static inline void vtime_user_enter(struct task_struct *tsk) { }
+static inline void vtime_user_exit(struct task_struct *tsk) { }
+static inline void vtime_guest_enter(struct task_struct *tsk) { }
+static inline void vtime_guest_exit(struct task_struct *tsk) { }
+static inline void vtime_init_idle(struct task_struct *tsk) { }
 #endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
@@ -23,25 +54,15 @@ extern void irqtime_account_irq(struct task_struct *tsk);
 static inline void irqtime_account_irq(struct task_struct *tsk) { }
 #endif
 
-static inline void vtime_account_irq_enter(struct task_struct *tsk)
+static inline void account_irq_enter_time(struct task_struct *tsk)
 {
-	/*
-	 * Hardirq can interrupt idle task anytime. So we need vtime_account()
-	 * that performs the idle check in CONFIG_VIRT_CPU_ACCOUNTING.
-	 * Softirq can also interrupt idle task directly if it calls
-	 * local_bh_enable(). Such case probably don't exist but we never know.
-	 * Ksoftirqd is not concerned because idle time is flushed on context
-	 * switch. Softirqs in the end of hardirqs are also not a problem because
-	 * the idle time is flushed on hardirq time already.
-	 */
-	vtime_account(tsk);
+	vtime_account_irq_enter(tsk);
 	irqtime_account_irq(tsk);
 }
 
-static inline void vtime_account_irq_exit(struct task_struct *tsk)
+static inline void account_irq_exit_time(struct task_struct *tsk)
 {
-	/* On hard|softirq exit we always account to hard|softirq cputime */
-	vtime_account_system(tsk);
+	vtime_account_irq_exit(tsk);
 	irqtime_account_irq(tsk);
 }
 
diff --git a/init/Kconfig b/init/Kconfig
index be8b7f5..ccb9f8f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -326,10 +326,13 @@ source "kernel/time/Kconfig"
 
 menu "CPU/Task time and stats accounting"
 
+config VIRT_CPU_ACCOUNTING
+	bool
+
 choice
 	prompt "Cputime accounting"
 	default TICK_CPU_ACCOUNTING if !PPC64
-	default VIRT_CPU_ACCOUNTING if PPC64
+	default VIRT_CPU_ACCOUNTING_NATIVE if PPC64
 
 # Kind of a stub config for the pure tick based cputime accounting
 config TICK_CPU_ACCOUNTING
@@ -342,9 +345,10 @@ config TICK_CPU_ACCOUNTING
 
 	  If unsure, say Y.
 
-config VIRT_CPU_ACCOUNTING
+config VIRT_CPU_ACCOUNTING_NATIVE
 	bool "Deterministic task and CPU time accounting"
 	depends on HAVE_VIRT_CPU_ACCOUNTING
+	select VIRT_CPU_ACCOUNTING
 	help
 	  Select this option to enable more accurate task and CPU time
 	  accounting.  This is done by reading a CPU counter on each
@@ -354,6 +358,23 @@ config VIRT_CPU_ACCOUNTING
 	  this also enables accounting of stolen time on logically-partitioned
 	  systems.
 
+config VIRT_CPU_ACCOUNTING_GEN
+	bool "Full dynticks CPU time accounting"
+	depends on HAVE_CONTEXT_TRACKING && 64BIT
+	select VIRT_CPU_ACCOUNTING
+	select CONTEXT_TRACKING
+	help
+	  Select this option to enable task and CPU time accounting on full
+	  dynticks systems. This accounting is implemented by watching every
+	  kernel-user boundaries using the context tracking subsystem.
+	  The accounting is thus performed at the expense of some significant
+	  overhead.
+
+	  For now this is only useful if you are working on the full
+	  dynticks subsystem development.
+
+	  If unsure, say N.
+
 config IRQ_TIME_ACCOUNTING
 	bool "Fine granularity task level IRQ time accounting"
 	depends on HAVE_IRQ_TIME_ACCOUNTING
diff --git a/init/init_task.c b/init/init_task.c
index 8b2f399..ba0a7f36 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -2,6 +2,8 @@
 #include <linux/export.h>
 #include <linux/mqueue.h>
 #include <linux/sched.h>
+#include <linux/sched/sysctl.h>
+#include <linux/sched/rt.h>
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
diff --git a/kernel/acct.c b/kernel/acct.c
index 051e071..e8b1627 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -566,6 +566,7 @@ out:
 void acct_collect(long exitcode, int group_dead)
 {
 	struct pacct_struct *pacct = &current->signal->pacct;
+	cputime_t utime, stime;
 	unsigned long vsize = 0;
 
 	if (group_dead && current->mm) {
@@ -593,8 +594,9 @@ void acct_collect(long exitcode, int group_dead)
 		pacct->ac_flag |= ACORE;
 	if (current->flags & PF_SIGNALED)
 		pacct->ac_flag |= AXSIG;
-	pacct->ac_utime += current->utime;
-	pacct->ac_stime += current->stime;
+	task_cputime(current, &utime, &stime);
+	pacct->ac_utime += utime;
+	pacct->ac_stime += stime;
 	pacct->ac_minflt += current->min_flt;
 	pacct->ac_majflt += current->maj_flt;
 	spin_unlock_irq(&current->sighand->siglock);
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index e0e07fd..74f68f4 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -1,24 +1,11 @@
 #include <linux/context_tracking.h>
+#include <linux/kvm_host.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
-#include <linux/percpu.h>
 #include <linux/hardirq.h>
+#include <linux/export.h>
 
-struct context_tracking {
-	/*
-	 * When active is false, hooks are not set to
-	 * minimize overhead: TIF flags are cleared
-	 * and calls to user_enter/exit are ignored. This
-	 * may be further optimized using static keys.
-	 */
-	bool active;
-	enum {
-		IN_KERNEL = 0,
-		IN_USER,
-	} state;
-};
-
-static DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
+DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
 #ifdef CONFIG_CONTEXT_TRACKING_FORCE
 	.active = true,
 #endif
@@ -44,8 +31,9 @@ void user_enter(void)
 	local_irq_save(flags);
 	if (__this_cpu_read(context_tracking.active) &&
 	    __this_cpu_read(context_tracking.state) != IN_USER) {
-		__this_cpu_write(context_tracking.state, IN_USER);
+		vtime_user_enter(current);
 		rcu_user_enter();
+		__this_cpu_write(context_tracking.state, IN_USER);
 	}
 	local_irq_restore(flags);
 }
@@ -67,12 +55,31 @@ void user_exit(void)
 
 	local_irq_save(flags);
 	if (__this_cpu_read(context_tracking.state) == IN_USER) {
-		__this_cpu_write(context_tracking.state, IN_KERNEL);
 		rcu_user_exit();
+		vtime_user_exit(current);
+		__this_cpu_write(context_tracking.state, IN_KERNEL);
 	}
 	local_irq_restore(flags);
 }
 
+void guest_enter(void)
+{
+	if (vtime_accounting_enabled())
+		vtime_guest_enter(current);
+	else
+		__guest_enter();
+}
+EXPORT_SYMBOL_GPL(guest_enter);
+
+void guest_exit(void)
+{
+	if (vtime_accounting_enabled())
+		vtime_guest_exit(current);
+	else
+		__guest_exit();
+}
+EXPORT_SYMBOL_GPL(guest_exit);
+
 void context_tracking_task_switch(struct task_struct *prev,
 			     struct task_struct *next)
 {
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 3046a50..e5d5e8e 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -224,11 +224,13 @@ void clear_tasks_mm_cpumask(int cpu)
 static inline void check_for_tasks(int cpu)
 {
 	struct task_struct *p;
+	cputime_t utime, stime;
 
 	write_lock_irq(&tasklist_lock);
 	for_each_process(p) {
+		task_cputime(p, &utime, &stime);
 		if (task_cpu(p) == cpu && p->state == TASK_RUNNING &&
-		    (p->utime || p->stime))
+		    (utime || stime))
 			printk(KERN_WARNING "Task %s (pid = %d) is on cpu %d "
 				"(state = %ld, flags = %x)\n",
 				p->comm, task_pid_nr(p), cpu,
diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index 418b3f7..d473988 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -106,6 +106,7 @@ int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 	unsigned long long t2, t3;
 	unsigned long flags;
 	struct timespec ts;
+	cputime_t utime, stime, stimescaled, utimescaled;
 
 	/* Though tsk->delays accessed later, early exit avoids
 	 * unnecessary returning of other data
@@ -114,12 +115,14 @@ int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 		goto done;
 
 	tmp = (s64)d->cpu_run_real_total;
-	cputime_to_timespec(tsk->utime + tsk->stime, &ts);
+	task_cputime(tsk, &utime, &stime);
+	cputime_to_timespec(utime + stime, &ts);
 	tmp += timespec_to_ns(&ts);
 	d->cpu_run_real_total = (tmp < (s64)d->cpu_run_real_total) ? 0 : tmp;
 
 	tmp = (s64)d->cpu_scaled_run_real_total;
-	cputime_to_timespec(tsk->utimescaled + tsk->stimescaled, &ts);
+	task_cputime_scaled(tsk, &utimescaled, &stimescaled);
+	cputime_to_timespec(utimescaled + stimescaled, &ts);
 	tmp += timespec_to_ns(&ts);
 	d->cpu_scaled_run_real_total =
 		(tmp < (s64)d->cpu_scaled_run_real_total) ? 0 : tmp;
diff --git a/kernel/exit.c b/kernel/exit.c
index b4df219..7dd2040 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -85,6 +85,7 @@ static void __exit_signal(struct task_struct *tsk)
 	bool group_dead = thread_group_leader(tsk);
 	struct sighand_struct *sighand;
 	struct tty_struct *uninitialized_var(tty);
+	cputime_t utime, stime;
 
 	sighand = rcu_dereference_check(tsk->sighand,
 					lockdep_tasklist_lock_is_held());
@@ -123,9 +124,10 @@ static void __exit_signal(struct task_struct *tsk)
 		 * We won't ever get here for the group leader, since it
 		 * will have been the last reference on the signal_struct.
 		 */
-		sig->utime += tsk->utime;
-		sig->stime += tsk->stime;
-		sig->gtime += tsk->gtime;
+		task_cputime(tsk, &utime, &stime);
+		sig->utime += utime;
+		sig->stime += stime;
+		sig->gtime += task_gtime(tsk);
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
 		sig->nvcsw += tsk->nvcsw;
@@ -1092,7 +1094,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		sig = p->signal;
 		psig->cutime += tgutime + sig->cutime;
 		psig->cstime += tgstime + sig->cstime;
-		psig->cgtime += p->gtime + sig->gtime + sig->cgtime;
+		psig->cgtime += task_gtime(p) + sig->gtime + sig->cgtime;
 		psig->cmin_flt +=
 			p->min_flt + sig->min_flt + sig->cmin_flt;
 		psig->cmaj_flt +=
diff --git a/kernel/fork.c b/kernel/fork.c
index c535f33..4133876 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1233,6 +1233,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	p->prev_cputime.utime = p->prev_cputime.stime = 0;
 #endif
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+	seqlock_init(&p->vtime_seqlock);
+	p->vtime_snap = 0;
+	p->vtime_snap_whence = VTIME_SLEEPING;
+#endif
+
 #if defined(SPLIT_RSS_COUNTING)
 	memset(&p->rss_stat, 0, sizeof(p->rss_stat));
 #endif
diff --git a/kernel/futex.c b/kernel/futex.c
index 19eb089..9618b6e 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -60,6 +60,7 @@
 #include <linux/pid.h>
 #include <linux/nsproxy.h>
 #include <linux/ptrace.h>
+#include <linux/sched/rt.h>
 
 #include <asm/futex.h>
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6db7a5e..c5dde98 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -44,6 +44,8 @@
 #include <linux/err.h>
 #include <linux/debugobjects.h>
 #include <linux/sched.h>
+#include <linux/sched/sysctl.h>
+#include <linux/sched/rt.h>
 #include <linux/timer.h>
 
 #include <asm/uaccess.h>
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index e49a288..02115d9 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/task_work.h>
 
 #include "internals.h"
diff --git a/kernel/mutex.c b/kernel/mutex.c
index a307cc9..52f2301 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -19,6 +19,7 @@
  */
 #include <linux/mutex.h>
 #include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index a278cad..165d476 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -155,11 +155,19 @@ static void bump_cpu_timer(struct k_itimer *timer,
 
 static inline cputime_t prof_ticks(struct task_struct *p)
 {
-	return p->utime + p->stime;
+	cputime_t utime, stime;
+
+	task_cputime(p, &utime, &stime);
+
+	return utime + stime;
 }
 static inline cputime_t virt_ticks(struct task_struct *p)
 {
-	return p->utime;
+	cputime_t utime;
+
+	task_cputime(p, &utime, NULL);
+
+	return utime;
 }
 
 static int
@@ -471,18 +479,23 @@ static void cleanup_timers(struct list_head *head,
  */
 void posix_cpu_timers_exit(struct task_struct *tsk)
 {
+	cputime_t utime, stime;
+
 	add_device_randomness((const void*) &tsk->se.sum_exec_runtime,
 						sizeof(unsigned long long));
+	task_cputime(tsk, &utime, &stime);
 	cleanup_timers(tsk->cpu_timers,
-		       tsk->utime, tsk->stime, tsk->se.sum_exec_runtime);
+		       utime, stime, tsk->se.sum_exec_runtime);
 
 }
 void posix_cpu_timers_exit_group(struct task_struct *tsk)
 {
 	struct signal_struct *const sig = tsk->signal;
+	cputime_t utime, stime;
 
+	task_cputime(tsk, &utime, &stime);
 	cleanup_timers(tsk->signal->cpu_timers,
-		       tsk->utime + sig->utime, tsk->stime + sig->stime,
+		       utime + sig->utime, stime + sig->stime,
 		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
 }
 
@@ -1226,11 +1239,14 @@ static inline int task_cputime_expired(const struct task_cputime *sample,
 static inline int fastpath_timer_check(struct task_struct *tsk)
 {
 	struct signal_struct *sig;
+	cputime_t utime, stime;
+
+	task_cputime(tsk, &utime, &stime);
 
 	if (!task_cputime_zero(&tsk->cputime_expires)) {
 		struct task_cputime task_sample = {
-			.utime = tsk->utime,
-			.stime = tsk->stime,
+			.utime = utime,
+			.stime = stime,
 			.sum_exec_runtime = tsk->se.sum_exec_runtime
 		};
 
diff --git a/kernel/rtmutex-debug.c b/kernel/rtmutex-debug.c
index 16502d3..13b243a 100644
--- a/kernel/rtmutex-debug.c
+++ b/kernel/rtmutex-debug.c
@@ -17,6 +17,7 @@
  * See rt.c in preempt-rt for proper credits and further information
  */
 #include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/spinlock.h>
diff --git a/kernel/rtmutex-tester.c b/kernel/rtmutex-tester.c
index 98ec494..7890b10 100644
--- a/kernel/rtmutex-tester.c
+++ b/kernel/rtmutex-tester.c
@@ -10,6 +10,7 @@
 #include <linux/kthread.h>
 #include <linux/export.h>
 #include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/spinlock.h>
 #include <linux/timer.h>
 #include <linux/freezer.h>
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index a242e69..1e09308 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -13,6 +13,7 @@
 #include <linux/spinlock.h>
 #include <linux/export.h>
 #include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/timer.h>
 
 #include "rtmutex_common.h"
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26058d0..4a88f1d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4371,7 +4371,7 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
 	struct task_struct *curr = current;
 	struct rq *rq, *p_rq;
 	unsigned long flags;
-	bool yielded = 0;
+	int yielded = 0;
 
 	local_irq_save(flags);
 	rq = this_rq();
@@ -4667,6 +4667,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	 */
 	idle->sched_class = &idle_sched_class;
 	ftrace_graph_init_idle_task(idle, cpu);
+	vtime_init_idle(idle);
 #if defined(CONFIG_SMP)
 	sprintf(idle->comm, "%s/%d", INIT_TASK_COMM, cpu);
 #endif
@@ -7508,6 +7509,25 @@ static int sched_rt_global_constraints(void)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
+int sched_rr_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret;
+	static DEFINE_MUTEX(mutex);
+
+	mutex_lock(&mutex);
+	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	/* make sure that internally we keep jiffies */
+	/* also, writing zero resets timeslice to default */
+	if (!ret && write) {
+		sched_rr_timeslice = sched_rr_timeslice <= 0 ?
+			RR_TIMESLICE : msecs_to_jiffies(sched_rr_timeslice);
+	}
+	mutex_unlock(&mutex);
+	return ret;
+}
+
 int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
diff --git a/kernel/sched/cpupri.c b/kernel/sched/cpupri.c
index 23aa789..1095e87 100644
--- a/kernel/sched/cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -28,6 +28,8 @@
  */
 
 #include <linux/gfp.h>
+#include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include "cpupri.h"
 
 /* Convert between a 140 based task->prio, and our 102 based cpupri */
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 293b202..9857329 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -3,6 +3,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/kernel_stat.h>
 #include <linux/static_key.h>
+#include <linux/context_tracking.h>
 #include "sched.h"
 
 
@@ -163,7 +164,7 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 	task_group_account_field(p, index, (__force u64) cputime);
 
 	/* Account for user time used */
-	acct_update_integrals(p);
+	acct_account_cputime(p);
 }
 
 /*
@@ -213,7 +214,7 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
 	task_group_account_field(p, index, (__force u64) cputime);
 
 	/* Account for system time used */
-	acct_update_integrals(p);
+	acct_account_cputime(p);
 }
 
 /*
@@ -295,6 +296,7 @@ static __always_inline bool steal_account_process_tick(void)
 void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 {
 	struct signal_struct *sig = tsk->signal;
+	cputime_t utime, stime;
 	struct task_struct *t;
 
 	times->utime = sig->utime;
@@ -308,16 +310,15 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 
 	t = tsk;
 	do {
-		times->utime += t->utime;
-		times->stime += t->stime;
+		task_cputime(tsk, &utime, &stime);
+		times->utime += utime;
+		times->stime += stime;
 		times->sum_exec_runtime += task_sched_runtime(t);
 	} while_each_thread(tsk, t);
 out:
 	rcu_read_unlock();
 }
 
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
-
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 /*
  * Account a tick to a process and cpustat
@@ -382,11 +383,12 @@ static void irqtime_account_idle_ticks(int ticks)
 		irqtime_account_process_tick(current, 0, rq);
 }
 #else /* CONFIG_IRQ_TIME_ACCOUNTING */
-static void irqtime_account_idle_ticks(int ticks) {}
-static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
+static inline void irqtime_account_idle_ticks(int ticks) {}
+static inline void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 						struct rq *rq) {}
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
 
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 /*
  * Account a single tick of cpu time.
  * @p: the process that the cpu time gets accounted to
@@ -397,6 +399,9 @@ void account_process_tick(struct task_struct *p, int user_tick)
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
 	struct rq *rq = this_rq();
 
+	if (vtime_accounting_enabled())
+		return;
+
 	if (sched_clock_irqtime) {
 		irqtime_account_process_tick(p, user_tick, rq);
 		return;
@@ -438,8 +443,7 @@ void account_idle_ticks(unsigned long ticks)
 
 	account_idle_time(jiffies_to_cputime(ticks));
 }
-
-#endif
+#endif /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 /*
  * Use precise platform statistics if available:
@@ -461,25 +465,20 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
 	*st = cputime.stime;
 }
 
-void vtime_account_system_irqsafe(struct task_struct *tsk)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	vtime_account_system(tsk);
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL_GPL(vtime_account_system_irqsafe);
-
 #ifndef __ARCH_HAS_VTIME_TASK_SWITCH
 void vtime_task_switch(struct task_struct *prev)
 {
+	if (!vtime_accounting_enabled())
+		return;
+
 	if (is_idle_task(prev))
 		vtime_account_idle(prev);
 	else
 		vtime_account_system(prev);
 
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	vtime_account_user(prev);
+#endif
 	arch_vtime_task_switch(prev);
 }
 #endif
@@ -493,27 +492,40 @@ void vtime_task_switch(struct task_struct *prev)
  * vtime_account().
  */
 #ifndef __ARCH_HAS_VTIME_ACCOUNT
-void vtime_account(struct task_struct *tsk)
+void vtime_account_irq_enter(struct task_struct *tsk)
 {
-	if (in_interrupt() || !is_idle_task(tsk))
-		vtime_account_system(tsk);
-	else
-		vtime_account_idle(tsk);
+	if (!vtime_accounting_enabled())
+		return;
+
+	if (!in_interrupt()) {
+		/*
+		 * If we interrupted user, context_tracking_in_user()
+		 * is 1 because the context tracking don't hook
+		 * on irq entry/exit. This way we know if
+		 * we need to flush user time on kernel entry.
+		 */
+		if (context_tracking_in_user()) {
+			vtime_account_user(tsk);
+			return;
+		}
+
+		if (is_idle_task(tsk)) {
+			vtime_account_idle(tsk);
+			return;
+		}
+	}
+	vtime_account_system(tsk);
 }
-EXPORT_SYMBOL_GPL(vtime_account);
+EXPORT_SYMBOL_GPL(vtime_account_irq_enter);
 #endif /* __ARCH_HAS_VTIME_ACCOUNT */
 
-#else
-
-#ifndef nsecs_to_cputime
-# define nsecs_to_cputime(__nsecs)	nsecs_to_jiffies(__nsecs)
-#endif
+#else /* !CONFIG_VIRT_CPU_ACCOUNTING */
 
-static cputime_t scale_utime(cputime_t utime, cputime_t rtime, cputime_t total)
+static cputime_t scale_stime(cputime_t stime, cputime_t rtime, cputime_t total)
 {
 	u64 temp = (__force u64) rtime;
 
-	temp *= (__force u64) utime;
+	temp *= (__force u64) stime;
 
 	if (sizeof(cputime_t) == 4)
 		temp = div_u64(temp, (__force u32) total);
@@ -531,10 +543,10 @@ static void cputime_adjust(struct task_cputime *curr,
 			   struct cputime *prev,
 			   cputime_t *ut, cputime_t *st)
 {
-	cputime_t rtime, utime, total;
+	cputime_t rtime, stime, total;
 
-	utime = curr->utime;
-	total = utime + curr->stime;
+	stime = curr->stime;
+	total = stime + curr->utime;
 
 	/*
 	 * Tick based cputime accounting depend on random scheduling
@@ -549,17 +561,17 @@ static void cputime_adjust(struct task_cputime *curr,
 	rtime = nsecs_to_cputime(curr->sum_exec_runtime);
 
 	if (total)
-		utime = scale_utime(utime, rtime, total);
+		stime = scale_stime(stime, rtime, total);
 	else
-		utime = rtime;
+		stime = rtime;
 
 	/*
 	 * If the tick based count grows faster than the scheduler one,
 	 * the result of the scaling may go backward.
 	 * Let's enforce monotonicity.
 	 */
-	prev->utime = max(prev->utime, utime);
-	prev->stime = max(prev->stime, rtime - prev->utime);
+	prev->stime = max(prev->stime, stime);
+	prev->utime = max(prev->utime, rtime - prev->stime);
 
 	*ut = prev->utime;
 	*st = prev->stime;
@@ -568,11 +580,10 @@ static void cputime_adjust(struct task_cputime *curr,
 void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
 	struct task_cputime cputime = {
-		.utime = p->utime,
-		.stime = p->stime,
 		.sum_exec_runtime = p->se.sum_exec_runtime,
 	};
 
+	task_cputime(p, &cputime.utime, &cputime.stime);
 	cputime_adjust(&cputime, &p->prev_cputime, ut, st);
 }
 
@@ -586,4 +597,221 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
 	thread_group_cputime(p, &cputime);
 	cputime_adjust(&cputime, &p->signal->prev_cputime, ut, st);
 }
-#endif
+#endif /* !CONFIG_VIRT_CPU_ACCOUNTING */
+
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+static unsigned long long vtime_delta(struct task_struct *tsk)
+{
+	unsigned long long clock;
+
+	clock = sched_clock();
+	if (clock < tsk->vtime_snap)
+		return 0;
+
+	return clock - tsk->vtime_snap;
+}
+
+static cputime_t get_vtime_delta(struct task_struct *tsk)
+{
+	unsigned long long delta = vtime_delta(tsk);
+
+	WARN_ON_ONCE(tsk->vtime_snap_whence == VTIME_SLEEPING);
+	tsk->vtime_snap += delta;
+
+	/* CHECKME: always safe to convert nsecs to cputime? */
+	return nsecs_to_cputime(delta);
+}
+
+static void __vtime_account_system(struct task_struct *tsk)
+{
+	cputime_t delta_cpu = get_vtime_delta(tsk);
+
+	account_system_time(tsk, irq_count(), delta_cpu, cputime_to_scaled(delta_cpu));
+}
+
+void vtime_account_system(struct task_struct *tsk)
+{
+	if (!vtime_accounting_enabled())
+		return;
+
+	write_seqlock(&tsk->vtime_seqlock);
+	__vtime_account_system(tsk);
+	write_sequnlock(&tsk->vtime_seqlock);
+}
+
+void vtime_account_irq_exit(struct task_struct *tsk)
+{
+	if (!vtime_accounting_enabled())
+		return;
+
+	write_seqlock(&tsk->vtime_seqlock);
+	if (context_tracking_in_user())
+		tsk->vtime_snap_whence = VTIME_USER;
+	__vtime_account_system(tsk);
+	write_sequnlock(&tsk->vtime_seqlock);
+}
+
+void vtime_account_user(struct task_struct *tsk)
+{
+	cputime_t delta_cpu;
+
+	if (!vtime_accounting_enabled())
+		return;
+
+	delta_cpu = get_vtime_delta(tsk);
+
+	write_seqlock(&tsk->vtime_seqlock);
+	tsk->vtime_snap_whence = VTIME_SYS;
+	account_user_time(tsk, delta_cpu, cputime_to_scaled(delta_cpu));
+	write_sequnlock(&tsk->vtime_seqlock);
+}
+
+void vtime_user_enter(struct task_struct *tsk)
+{
+	if (!vtime_accounting_enabled())
+		return;
+
+	write_seqlock(&tsk->vtime_seqlock);
+	tsk->vtime_snap_whence = VTIME_USER;
+	__vtime_account_system(tsk);
+	write_sequnlock(&tsk->vtime_seqlock);
+}
+
+void vtime_guest_enter(struct task_struct *tsk)
+{
+	write_seqlock(&tsk->vtime_seqlock);
+	__vtime_account_system(tsk);
+	current->flags |= PF_VCPU;
+	write_sequnlock(&tsk->vtime_seqlock);
+}
+
+void vtime_guest_exit(struct task_struct *tsk)
+{
+	write_seqlock(&tsk->vtime_seqlock);
+	__vtime_account_system(tsk);
+	current->flags &= ~PF_VCPU;
+	write_sequnlock(&tsk->vtime_seqlock);
+}
+
+void vtime_account_idle(struct task_struct *tsk)
+{
+	cputime_t delta_cpu = get_vtime_delta(tsk);
+
+	account_idle_time(delta_cpu);
+}
+
+bool vtime_accounting_enabled(void)
+{
+	return context_tracking_active();
+}
+
+void arch_vtime_task_switch(struct task_struct *prev)
+{
+	write_seqlock(&prev->vtime_seqlock);
+	prev->vtime_snap_whence = VTIME_SLEEPING;
+	write_sequnlock(&prev->vtime_seqlock);
+
+	write_seqlock(&current->vtime_seqlock);
+	current->vtime_snap_whence = VTIME_SYS;
+	current->vtime_snap = sched_clock();
+	write_sequnlock(&current->vtime_seqlock);
+}
+
+void vtime_init_idle(struct task_struct *t)
+{
+	unsigned long flags;
+
+	write_seqlock_irqsave(&t->vtime_seqlock, flags);
+	t->vtime_snap_whence = VTIME_SYS;
+	t->vtime_snap = sched_clock();
+	write_sequnlock_irqrestore(&t->vtime_seqlock, flags);
+}
+
+cputime_t task_gtime(struct task_struct *t)
+{
+	unsigned int seq;
+	cputime_t gtime;
+
+	do {
+		seq = read_seqbegin(&t->vtime_seqlock);
+
+		gtime = t->gtime;
+		if (t->flags & PF_VCPU)
+			gtime += vtime_delta(t);
+
+	} while (read_seqretry(&t->vtime_seqlock, seq));
+
+	return gtime;
+}
+
+/*
+ * Fetch cputime raw values from fields of task_struct and
+ * add up the pending nohz execution time since the last
+ * cputime snapshot.
+ */
+static void
+fetch_task_cputime(struct task_struct *t,
+		   cputime_t *u_dst, cputime_t *s_dst,
+		   cputime_t *u_src, cputime_t *s_src,
+		   cputime_t *udelta, cputime_t *sdelta)
+{
+	unsigned int seq;
+	unsigned long long delta;
+
+	do {
+		*udelta = 0;
+		*sdelta = 0;
+
+		seq = read_seqbegin(&t->vtime_seqlock);
+
+		if (u_dst)
+			*u_dst = *u_src;
+		if (s_dst)
+			*s_dst = *s_src;
+
+		/* Task is sleeping, nothing to add */
+		if (t->vtime_snap_whence == VTIME_SLEEPING ||
+		    is_idle_task(t))
+			continue;
+
+		delta = vtime_delta(t);
+
+		/*
+		 * Task runs either in user or kernel space, add pending nohz time to
+		 * the right place.
+		 */
+		if (t->vtime_snap_whence == VTIME_USER || t->flags & PF_VCPU) {
+			*udelta = delta;
+		} else {
+			if (t->vtime_snap_whence == VTIME_SYS)
+				*sdelta = delta;
+		}
+	} while (read_seqretry(&t->vtime_seqlock, seq));
+}
+
+
+void task_cputime(struct task_struct *t, cputime_t *utime, cputime_t *stime)
+{
+	cputime_t udelta, sdelta;
+
+	fetch_task_cputime(t, utime, stime, &t->utime,
+			   &t->stime, &udelta, &sdelta);
+	if (utime)
+		*utime += udelta;
+	if (stime)
+		*stime += sdelta;
+}
+
+void task_cputime_scaled(struct task_struct *t,
+			 cputime_t *utimescaled, cputime_t *stimescaled)
+{
+	cputime_t udelta, sdelta;
+
+	fetch_task_cputime(t, utimescaled, stimescaled,
+			   &t->utimescaled, &t->stimescaled, &udelta, &sdelta);
+	if (utimescaled)
+		*utimescaled += cputime_to_scaled(udelta);
+	if (stimescaled)
+		*stimescaled += cputime_to_scaled(sdelta);
+}
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5eea870..ed18c74 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1680,9 +1680,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	}
 
 	/* ensure we never gain time by being placed backwards. */
-	vruntime = max_vruntime(se->vruntime, vruntime);
-
-	se->vruntime = vruntime;
+	se->vruntime = max_vruntime(se->vruntime, vruntime);
 }
 
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq);
@@ -3254,25 +3252,18 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
  */
 static int select_idle_sibling(struct task_struct *p, int target)
 {
-	int cpu = smp_processor_id();
-	int prev_cpu = task_cpu(p);
 	struct sched_domain *sd;
 	struct sched_group *sg;
-	int i;
+	int i = task_cpu(p);
 
-	/*
-	 * If the task is going to be woken-up on this cpu and if it is
-	 * already idle, then it is the right target.
-	 */
-	if (target == cpu && idle_cpu(cpu))
-		return cpu;
+	if (idle_cpu(target))
+		return target;
 
 	/*
-	 * If the task is going to be woken-up on the cpu where it previously
-	 * ran and if it is currently idle, then it the right target.
+	 * If the prevous cpu is cache affine and idle, don't be stupid.
 	 */
-	if (target == prev_cpu && idle_cpu(prev_cpu))
-		return prev_cpu;
+	if (i != target && cpus_share_cache(i, target) && idle_cpu(i))
+		return i;
 
 	/*
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
@@ -3286,7 +3277,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 				goto next;
 
 			for_each_cpu(i, sched_group_cpus(sg)) {
-				if (!idle_cpu(i))
+				if (i == target || !idle_cpu(i))
 					goto next;
 			}
 
@@ -6101,7 +6092,7 @@ static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task
 	 * idle runqueue:
 	 */
 	if (rq->cfs.load.weight)
-		rr_interval = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
+		rr_interval = NS_TO_JIFFIES(sched_slice(cfs_rq_of(se), se));
 
 	return rr_interval;
 }
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 418feb0..fb0f77e 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -7,6 +7,8 @@
 
 #include <linux/slab.h>
 
+int sched_rr_timeslice = RR_TIMESLICE;
+
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
 
 struct rt_bandwidth def_rt_bandwidth;
@@ -925,8 +927,8 @@ static void update_curr_rt(struct rq *rq)
 		return;
 
 	delta_exec = rq->clock_task - curr->se.exec_start;
-	if (unlikely((s64)delta_exec < 0))
-		delta_exec = 0;
+	if (unlikely((s64)delta_exec <= 0))
+		return;
 
 	schedstat_set(curr->se.statistics.exec_max,
 		      max(curr->se.statistics.exec_max, delta_exec));
@@ -1427,8 +1429,7 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpumask_test_cpu(cpu, tsk_cpus_allowed(p))) &&
-	    (p->nr_cpus_allowed > 1))
+	    cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
 		return 1;
 	return 0;
 }
@@ -1889,8 +1890,11 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
 	 * we may need to handle the pulling of RT tasks
 	 * now.
 	 */
-	if (p->on_rq && !rq->rt.rt_nr_running)
-		pull_rt_task(rq);
+	if (!p->on_rq || rq->rt.rt_nr_running)
+		return;
+
+	if (pull_rt_task(rq))
+		resched_task(rq->curr);
 }
 
 void init_sched_rt_class(void)
@@ -1985,7 +1989,11 @@ static void watchdog(struct rq *rq, struct task_struct *p)
 	if (soft != RLIM_INFINITY) {
 		unsigned long next;
 
-		p->rt.timeout++;
+		if (p->rt.watchdog_stamp != jiffies) {
+			p->rt.timeout++;
+			p->rt.watchdog_stamp = jiffies;
+		}
+
 		next = DIV_ROUND_UP(min(soft, hard), USEC_PER_SEC/HZ);
 		if (p->rt.timeout > next)
 			p->cputime_expires.sched_exp = p->se.sum_exec_runtime;
@@ -2010,7 +2018,7 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 	if (--p->rt.time_slice)
 		return;
 
-	p->rt.time_slice = RR_TIMESLICE;
+	p->rt.time_slice = sched_rr_timeslice;
 
 	/*
 	 * Requeue to the end of queue if we (and all of our ancestors) are the
@@ -2041,7 +2049,7 @@ static unsigned int get_rr_interval_rt(struct rq *rq, struct task_struct *task)
 	 * Time slice is 0 for SCHED_FIFO tasks
 	 */
 	if (task->policy == SCHED_RR)
-		return RR_TIMESLICE;
+		return sched_rr_timeslice;
 	else
 		return 0;
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fc88644..cc03cfd 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1,5 +1,7 @@
 
 #include <linux/sched.h>
+#include <linux/sched/sysctl.h>
+#include <linux/sched/rt.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
diff --git a/kernel/signal.c b/kernel/signal.c
index 3d09cf6..7f82adb 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1632,6 +1632,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	unsigned long flags;
 	struct sighand_struct *psig;
 	bool autoreap = false;
+	cputime_t utime, stime;
 
 	BUG_ON(sig == -1);
 
@@ -1669,8 +1670,9 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 				       task_uid(tsk));
 	rcu_read_unlock();
 
-	info.si_utime = cputime_to_clock_t(tsk->utime + tsk->signal->utime);
-	info.si_stime = cputime_to_clock_t(tsk->stime + tsk->signal->stime);
+	task_cputime(tsk, &utime, &stime);
+	info.si_utime = cputime_to_clock_t(utime + tsk->signal->utime);
+	info.si_stime = cputime_to_clock_t(stime + tsk->signal->stime);
 
 	info.si_status = tsk->exit_code & 0x7f;
 	if (tsk->exit_code & 0x80)
@@ -1734,6 +1736,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	unsigned long flags;
 	struct task_struct *parent;
 	struct sighand_struct *sighand;
+	cputime_t utime, stime;
 
 	if (for_ptracer) {
 		parent = tsk->parent;
@@ -1752,8 +1755,9 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	info.si_uid = from_kuid_munged(task_cred_xxx(parent, user_ns), task_uid(tsk));
 	rcu_read_unlock();
 
-	info.si_utime = cputime_to_clock_t(tsk->utime);
-	info.si_stime = cputime_to_clock_t(tsk->stime);
+	task_cputime(tsk, &utime, &stime);
+	info.si_utime = cputime_to_clock_t(utime);
+	info.si_stime = cputime_to_clock_t(stime);
 
  	info.si_code = why;
  	switch (why) {
diff --git a/kernel/softirq.c b/kernel/softirq.c
index ed567ba..f5cc25f 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -221,7 +221,7 @@ asmlinkage void __do_softirq(void)
 	current->flags &= ~PF_MEMALLOC;
 
 	pending = local_softirq_pending();
-	vtime_account_irq_enter(current);
+	account_irq_enter_time(current);
 
 	__local_bh_disable((unsigned long)__builtin_return_address(0),
 				SOFTIRQ_OFFSET);
@@ -272,7 +272,7 @@ restart:
 
 	lockdep_softirq_exit();
 
-	vtime_account_irq_exit(current);
+	account_irq_exit_time(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
 }
@@ -341,7 +341,7 @@ static inline void invoke_softirq(void)
  */
 void irq_exit(void)
 {
-	vtime_account_irq_exit(current);
+	account_irq_exit_time(current);
 	trace_hardirq_exit();
 	sub_preempt_count(IRQ_EXIT_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c88878d..4fc9be9 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -61,6 +61,7 @@
 #include <linux/kmod.h>
 #include <linux/capability.h>
 #include <linux/binfmts.h>
+#include <linux/sched/sysctl.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -403,6 +404,13 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= sched_rt_handler,
 	},
+	{
+		.procname	= "sched_rr_timeslice_ms",
+		.data		= &sched_rr_timeslice,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= sched_rr_handler,
+	},
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
 		.procname	= "sched_autogroup_enabled",
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d58e552..46dfb6d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -631,8 +631,11 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 
 static void tick_nohz_account_idle_ticks(struct tick_sched *ts)
 {
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	unsigned long ticks;
+
+	if (vtime_accounting_enabled())
+		return;
 	/*
 	 * We stopped the tick in idle. Update process times would miss the
 	 * time we slept as update_process_times does only a 1 tick
diff --git a/kernel/timer.c b/kernel/timer.c
index 367d008..3e13baf 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -39,6 +39,7 @@
 #include <linux/kallsyms.h>
 #include <linux/irq_work.h>
 #include <linux/sched.h>
+#include <linux/sched/sysctl.h>
 #include <linux/slab.h>
 
 #include <asm/uaccess.h>
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3c13e46..4d2e4af 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -39,6 +39,7 @@
 #include <linux/poll.h>
 #include <linux/nmi.h>
 #include <linux/fs.h>
+#include <linux/sched/rt.h>
 
 #include "trace.h"
 #include "trace_output.h"
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 9fe45fc..75aa97f 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -15,8 +15,8 @@
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
+#include <linux/sched/rt.h>
 #include <trace/events/sched.h>
-
 #include "trace.h"
 
 static struct trace_array	*wakeup_trace;
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 625df0b..a1dd9a1 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -32,6 +32,7 @@ void bacct_add_tsk(struct user_namespace *user_ns,
 {
 	const struct cred *tcred;
 	struct timespec uptime, ts;
+	cputime_t utime, stime, utimescaled, stimescaled;
 	u64 ac_etime;
 
 	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
@@ -65,10 +66,15 @@ void bacct_add_tsk(struct user_namespace *user_ns,
 	stats->ac_ppid	 = pid_alive(tsk) ?
 		task_tgid_nr_ns(rcu_dereference(tsk->real_parent), pid_ns) : 0;
 	rcu_read_unlock();
-	stats->ac_utime = cputime_to_usecs(tsk->utime);
-	stats->ac_stime = cputime_to_usecs(tsk->stime);
-	stats->ac_utimescaled = cputime_to_usecs(tsk->utimescaled);
-	stats->ac_stimescaled = cputime_to_usecs(tsk->stimescaled);
+
+	task_cputime(tsk, &utime, &stime);
+	stats->ac_utime = cputime_to_usecs(utime);
+	stats->ac_stime = cputime_to_usecs(stime);
+
+	task_cputime_scaled(tsk, &utimescaled, &stimescaled);
+	stats->ac_utimescaled = cputime_to_usecs(utimescaled);
+	stats->ac_stimescaled = cputime_to_usecs(stimescaled);
+
 	stats->ac_minflt = tsk->min_flt;
 	stats->ac_majflt = tsk->maj_flt;
 
@@ -115,11 +121,8 @@ void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
 #undef KB
 #undef MB
 
-/**
- * acct_update_integrals - update mm integral fields in task_struct
- * @tsk: task_struct for accounting
- */
-void acct_update_integrals(struct task_struct *tsk)
+static void __acct_update_integrals(struct task_struct *tsk,
+				    cputime_t utime, cputime_t stime)
 {
 	if (likely(tsk->mm)) {
 		cputime_t time, dtime;
@@ -128,7 +131,7 @@ void acct_update_integrals(struct task_struct *tsk)
 		u64 delta;
 
 		local_irq_save(flags);
-		time = tsk->stime + tsk->utime;
+		time = stime + utime;
 		dtime = time - tsk->acct_timexpd;
 		jiffies_to_timeval(cputime_to_jiffies(dtime), &value);
 		delta = value.tv_sec;
@@ -145,6 +148,27 @@ void acct_update_integrals(struct task_struct *tsk)
 }
 
 /**
+ * acct_update_integrals - update mm integral fields in task_struct
+ * @tsk: task_struct for accounting
+ */
+void acct_update_integrals(struct task_struct *tsk)
+{
+	cputime_t utime, stime;
+
+	task_cputime(tsk, &utime, &stime);
+	__acct_update_integrals(tsk, utime, stime);
+}
+
+/**
+ * acct_account_cputime - update mm integral after cputime update
+ * @tsk: task_struct for accounting
+ */
+void acct_account_cputime(struct task_struct *tsk)
+{
+	__acct_update_integrals(tsk, tsk->utime, tsk->stime);
+}
+
+/**
  * acct_clear_integrals - clear the mm integral fields in task_struct
  * @tsk: task_struct whose accounting fields are cleared
  */
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 75a2ab3..2768942 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/sysctl.h>
 #include <linux/smpboot.h>
+#include <linux/sched/rt.h>
 
 #include <asm/irq_regs.h>
 #include <linux/kvm_para.h>
diff --git a/mm/mmap.c b/mm/mmap.c
index 35730ee..5dee4a0 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -32,6 +32,7 @@
 #include <linux/khugepaged.h>
 #include <linux/uprobes.h>
 #include <linux/rbtree_augmented.h>
+#include <linux/sched/sysctl.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
diff --git a/mm/mremap.c b/mm/mremap.c
index e1031e1..f9766f4 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -19,6 +19,7 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/mmu_notifier.h>
+#include <linux/sched/sysctl.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
diff --git a/mm/nommu.c b/mm/nommu.c
index 79c3cac..b20db4e 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -29,6 +29,7 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/audit.h>
+#include <linux/sched/sysctl.h>
 
 #include <asm/uaccess.h>
 #include <asm/tlb.h>
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0713bfb..66a0024 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -35,6 +35,7 @@
 #include <linux/buffer_head.h> /* __set_page_dirty_buffers */
 #include <linux/pagevec.h>
 #include <linux/timer.h>
+#include <linux/sched/rt.h>
 #include <trace/events/writeback.h>
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index df2022f..42d18e4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -58,6 +58,7 @@
 #include <linux/prefetch.h>
 #include <linux/migrate.h>
 #include <linux/page-debug-flags.h>
+#include <linux/sched/rt.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
