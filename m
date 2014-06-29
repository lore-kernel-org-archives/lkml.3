Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaF2WJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 18:09:41 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:6110 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbaF2WJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 18:09:40 -0400
Message-ID: <1404079773.2619.4.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH v2] arch,locking: Ciao arch_mutex_cpu_relax()
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 29 Jun 2014 15:09:33 -0700
In-Reply-To: <CA+55aFx3UQG42cYrUWrTDT9CnpnRwVta6C9N_0FH1wvyDMxPgw@mail.gmail.com>
References: <1403288473.10903.2.camel@buesod1.americas.hpqcorp.net>
	 <20140623065835.GF19860@laptop.programming.kicks-ass.net>
	 <1403622415.15523.4.camel@buesod1.americas.hpqcorp.net>
	 <20140625062510.GB4260@osiris>
	 <CA+55aFx3UQG42cYrUWrTDT9CnpnRwVta6C9N_0FH1wvyDMxPgw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

The arch_mutex_cpu_relax() function, introduced by 34b133f, is
hacky and ugly. It was added a few years ago to address the fact
that common cpu_relax() calls include yielding on s390, and thus
impact the optimistic spinning functionality of mutexes. Nowadays
we use this function well beyond mutexes: rwsem, qrwlock, mcs and
lockref. Since the macro that defines the call is in the mutex header,
any users must include mutex.h and the naming is misleading as well.

This patch (i) renames the call to cpu_relax_lowlatency  ("relax, but
only if you can do it with very low latency") and (ii) defines it in
each arch's asm/processor.h local header, just like for regular cpu_relax
functions. On all archs, except s390, cpu_relax_lowlatency is simply cpu_relax,
and thus we can take it out of mutex.h. While this can seem redundant,
I believe it is a good choice as it allows us to move out arch specific
logic from generic locking primitives and enables future(?) archs to
transparently define it, similarly to System Z.

Please note that these changes are only tested on x86-64.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
Changes from v1: Rename arch_cpu_relax to cpu_relax_lowlatency,
based on the purpose of the function, as suggested by Linus.

 arch/alpha/include/asm/processor.h     | 1 +
 arch/arc/include/asm/processor.h       | 2 ++
 arch/arm/include/asm/processor.h       | 2 ++
 arch/arm64/include/asm/processor.h     | 1 +
 arch/avr32/include/asm/processor.h     | 1 +
 arch/blackfin/include/asm/processor.h  | 2 +-
 arch/c6x/include/asm/processor.h       | 1 +
 arch/cris/include/asm/processor.h      | 1 +
 arch/hexagon/include/asm/processor.h   | 1 +
 arch/ia64/include/asm/processor.h      | 1 +
 arch/m32r/include/asm/processor.h      | 1 +
 arch/m68k/include/asm/processor.h      | 1 +
 arch/metag/include/asm/processor.h     | 1 +
 arch/mips/include/asm/processor.h      | 1 +
 arch/mn10300/include/asm/processor.h   | 2 ++
 arch/openrisc/include/asm/processor.h  | 1 +
 arch/parisc/include/asm/processor.h    | 1 +
 arch/powerpc/include/asm/processor.h   | 2 ++
 arch/s390/include/asm/processor.h      | 2 +-
 arch/score/include/asm/processor.h     | 1 +
 arch/sh/include/asm/processor.h        | 1 +
 arch/sparc/include/asm/processor_32.h  | 2 ++
 arch/sparc/include/asm/processor_64.h  | 1 +
 arch/tile/include/asm/processor.h      | 2 ++
 arch/unicore32/include/asm/processor.h | 1 +
 arch/x86/include/asm/processor.h       | 2 ++
 arch/xtensa/include/asm/processor.h    | 1 +
 include/linux/mutex.h                  | 4 ----
 kernel/locking/mcs_spinlock.c          | 8 +++-----
 kernel/locking/mcs_spinlock.h          | 4 ++--
 kernel/locking/mutex.c                 | 4 ++--
 kernel/locking/qrwlock.c               | 9 ++++-----
 kernel/locking/rwsem-xadd.c            | 4 ++--
 lib/lockref.c                          | 3 +--
 34 files changed, 48 insertions(+), 24 deletions(-)

diff --git a/arch/alpha/include/asm/processor.h b/arch/alpha/include/asm/processor.h
index 6cb7fe8..b4cf036 100644
--- a/arch/alpha/include/asm/processor.h
+++ b/arch/alpha/include/asm/processor.h
@@ -57,6 +57,7 @@ unsigned long get_wchan(struct task_struct *p);
   ((tsk) == current ? rdusp() : task_thread_info(tsk)->pcb.usp)
 
 #define cpu_relax()	barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 #define ARCH_HAS_PREFETCH
 #define ARCH_HAS_PREFETCHW
diff --git a/arch/arc/include/asm/processor.h b/arch/arc/include/asm/processor.h
index d99f9b3..82588f3 100644
--- a/arch/arc/include/asm/processor.h
+++ b/arch/arc/include/asm/processor.h
@@ -62,6 +62,8 @@ unsigned long thread_saved_pc(struct task_struct *t);
 #define cpu_relax()	do { } while (0)
 #endif
 
+#define cpu_relax_lowlatency() cpu_relax()
+
 #define copy_segments(tsk, mm)      do { } while (0)
 #define release_segments(mm)        do { } while (0)
 
diff --git a/arch/arm/include/asm/processor.h b/arch/arm/include/asm/processor.h
index c3d5fc1..8a1e8e9 100644
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -82,6 +82,8 @@ unsigned long get_wchan(struct task_struct *p);
 #define cpu_relax()			barrier()
 #endif
 
+#define cpu_relax_lowlatency()                cpu_relax()
+
 #define task_pt_regs(p) \
 	((struct pt_regs *)(THREAD_START_SP + task_stack_page(p)) - 1)
 
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 34de2a8..4610b0d 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -129,6 +129,7 @@ extern void release_thread(struct task_struct *);
 unsigned long get_wchan(struct task_struct *p);
 
 #define cpu_relax()			barrier()
+#define cpu_relax_lowlatency()                cpu_relax()
 
 /* Thread switching */
 extern struct task_struct *cpu_switch_to(struct task_struct *prev,
diff --git a/arch/avr32/include/asm/processor.h b/arch/avr32/include/asm/processor.h
index 972adcc..941593c 100644
--- a/arch/avr32/include/asm/processor.h
+++ b/arch/avr32/include/asm/processor.h
@@ -92,6 +92,7 @@ extern struct avr32_cpuinfo boot_cpu_data;
 #define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 3))
 
 #define cpu_relax()		barrier()
+#define cpu_relax_lowlatency()        cpu_relax()
 #define cpu_sync_pipeline()	asm volatile("sub pc, -2" : : : "memory")
 
 struct cpu_context {
diff --git a/arch/blackfin/include/asm/processor.h b/arch/blackfin/include/asm/processor.h
index d0e72e9..7acd466 100644
--- a/arch/blackfin/include/asm/processor.h
+++ b/arch/blackfin/include/asm/processor.h
@@ -99,7 +99,7 @@ unsigned long get_wchan(struct task_struct *p);
 #define	KSTK_ESP(tsk)	((tsk) == current ? rdusp() : (tsk)->thread.usp)
 
 #define cpu_relax()    	smp_mb()
-
+#define cpu_relax_lowlatency() cpu_relax()
 
 /* Get the Silicon Revision of the chip */
 static inline uint32_t __pure bfin_revid(void)
diff --git a/arch/c6x/include/asm/processor.h b/arch/c6x/include/asm/processor.h
index b9eb3da..f2ef31b 100644
--- a/arch/c6x/include/asm/processor.h
+++ b/arch/c6x/include/asm/processor.h
@@ -121,6 +121,7 @@ extern unsigned long get_wchan(struct task_struct *p);
 #define KSTK_ESP(task)	(task_pt_regs(task)->sp)
 
 #define cpu_relax()		do { } while (0)
+#define cpu_relax_lowlatency()        cpu_relax()
 
 extern const struct seq_operations cpuinfo_op;
 
diff --git a/arch/cris/include/asm/processor.h b/arch/cris/include/asm/processor.h
index 15b815d..862126b 100644
--- a/arch/cris/include/asm/processor.h
+++ b/arch/cris/include/asm/processor.h
@@ -63,6 +63,7 @@ static inline void release_thread(struct task_struct *dead_task)
 #define init_stack      (init_thread_union.stack)
 
 #define cpu_relax()     barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 void default_idle(void);
 
diff --git a/arch/hexagon/include/asm/processor.h b/arch/hexagon/include/asm/processor.h
index 45a8254..d850113 100644
--- a/arch/hexagon/include/asm/processor.h
+++ b/arch/hexagon/include/asm/processor.h
@@ -56,6 +56,7 @@ struct thread_struct {
 }
 
 #define cpu_relax() __vmyield()
+#define cpu_relax_lowlatency() cpu_relax()
 
 /*
  * Decides where the kernel will search for a free chunk of vm space during
diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index efd1b92..c736713 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -548,6 +548,7 @@ ia64_eoi (void)
 }
 
 #define cpu_relax()	ia64_hint(ia64_hint_pause)
+#define cpu_relax_lowlatency() cpu_relax()
 
 static inline int
 ia64_get_irr(unsigned int vector)
diff --git a/arch/m32r/include/asm/processor.h b/arch/m32r/include/asm/processor.h
index 5767367..9f8fd9b 100644
--- a/arch/m32r/include/asm/processor.h
+++ b/arch/m32r/include/asm/processor.h
@@ -133,5 +133,6 @@ unsigned long get_wchan(struct task_struct *p);
 #define KSTK_ESP(tsk)  ((tsk)->thread.sp)
 
 #define cpu_relax()	barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 #endif /* _ASM_M32R_PROCESSOR_H */
diff --git a/arch/m68k/include/asm/processor.h b/arch/m68k/include/asm/processor.h
index b0768a6..20dda1d 100644
--- a/arch/m68k/include/asm/processor.h
+++ b/arch/m68k/include/asm/processor.h
@@ -176,5 +176,6 @@ unsigned long get_wchan(struct task_struct *p);
 #define task_pt_regs(tsk)	((struct pt_regs *) ((tsk)->thread.esp0))
 
 #define cpu_relax()	barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 #endif
diff --git a/arch/metag/include/asm/processor.h b/arch/metag/include/asm/processor.h
index a8a3747..881071c 100644
--- a/arch/metag/include/asm/processor.h
+++ b/arch/metag/include/asm/processor.h
@@ -155,6 +155,7 @@ unsigned long get_wchan(struct task_struct *p);
 #define user_stack_pointer(regs)        ((regs)->ctx.AX[0].U0)
 
 #define cpu_relax()     barrier()
+#define cpu_relax_lowlatency()  cpu_relax()
 
 extern void setup_priv(void);
 
diff --git a/arch/mips/include/asm/processor.h b/arch/mips/include/asm/processor.h
index ad70cba..d5098bc 100644
--- a/arch/mips/include/asm/processor.h
+++ b/arch/mips/include/asm/processor.h
@@ -367,6 +367,7 @@ unsigned long get_wchan(struct task_struct *p);
 #define KSTK_STATUS(tsk) (task_pt_regs(tsk)->cp0_status)
 
 #define cpu_relax()	barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 /*
  * Return_address is a replacement for __builtin_return_address(count)
diff --git a/arch/mn10300/include/asm/processor.h b/arch/mn10300/include/asm/processor.h
index 8b80b19..769d5ed 100644
--- a/arch/mn10300/include/asm/processor.h
+++ b/arch/mn10300/include/asm/processor.h
@@ -68,7 +68,9 @@ extern struct mn10300_cpuinfo cpu_data[];
 extern void identify_cpu(struct mn10300_cpuinfo *);
 extern void print_cpu_info(struct mn10300_cpuinfo *);
 extern void dodgy_tsc(void);
+
 #define cpu_relax() barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 /*
  * User space process size: 1.75GB (default).
diff --git a/arch/openrisc/include/asm/processor.h b/arch/openrisc/include/asm/processor.h
index cab746f..4d235e3 100644
--- a/arch/openrisc/include/asm/processor.h
+++ b/arch/openrisc/include/asm/processor.h
@@ -101,6 +101,7 @@ extern unsigned long thread_saved_pc(struct task_struct *t);
 #define init_stack      (init_thread_union.stack)
 
 #define cpu_relax()     barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 #endif /* __ASSEMBLY__ */
 #endif /* __ASM_OPENRISC_PROCESSOR_H */
diff --git a/arch/parisc/include/asm/processor.h b/arch/parisc/include/asm/processor.h
index d951c96..689a8ad 100644
--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -338,6 +338,7 @@ extern unsigned long get_wchan(struct task_struct *p);
 #define KSTK_ESP(tsk)	((tsk)->thread.regs.gr[30])
 
 #define cpu_relax()	barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 /* Used as a macro to identify the combined VIPT/PIPT cached
  * CPUs which require a guarantee of coherency (no inequivalent
diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index 6d59072..dda7ac4 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -400,6 +400,8 @@ static inline unsigned long __pack_fe01(unsigned int fpmode)
 #define cpu_relax()	barrier()
 #endif
 
+#define cpu_relax_lowlatency() cpu_relax()
+
 /* Check that a certain kernel stack pointer is valid in task_struct p */
 int validate_sp(unsigned long sp, struct task_struct *p,
                        unsigned long nbytes);
diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index 6f02d45..e568fc8 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -217,7 +217,7 @@ static inline void cpu_relax(void)
 	barrier();
 }
 
-#define arch_mutex_cpu_relax()  barrier()
+#define cpu_relax_lowlatency()  barrier()
 
 static inline void psw_set_key(unsigned int key)
 {
diff --git a/arch/score/include/asm/processor.h b/arch/score/include/asm/processor.h
index d9a922d..851f441 100644
--- a/arch/score/include/asm/processor.h
+++ b/arch/score/include/asm/processor.h
@@ -24,6 +24,7 @@ extern unsigned long get_wchan(struct task_struct *p);
 #define current_text_addr() ({ __label__ _l; _l: &&_l; })
 
 #define cpu_relax()		barrier()
+#define cpu_relax_lowlatency()        cpu_relax()
 #define release_thread(thread)	do {} while (0)
 
 /*
diff --git a/arch/sh/include/asm/processor.h b/arch/sh/include/asm/processor.h
index 5448f9b..1506897 100644
--- a/arch/sh/include/asm/processor.h
+++ b/arch/sh/include/asm/processor.h
@@ -97,6 +97,7 @@ extern struct sh_cpuinfo cpu_data[];
 
 #define cpu_sleep()	__asm__ __volatile__ ("sleep" : : : "memory")
 #define cpu_relax()	barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 void default_idle(void);
 void stop_this_cpu(void *);
diff --git a/arch/sparc/include/asm/processor_32.h b/arch/sparc/include/asm/processor_32.h
index 2c7baa4..f873358 100644
--- a/arch/sparc/include/asm/processor_32.h
+++ b/arch/sparc/include/asm/processor_32.h
@@ -118,6 +118,8 @@ extern unsigned long get_wchan(struct task_struct *);
 extern struct task_struct *last_task_used_math;
 
 #define cpu_relax()	barrier()
+#define cpu_relax_lowlatency() cpu_relax()
+
 extern void (*sparc_idle)(void);
 
 #endif
diff --git a/arch/sparc/include/asm/processor_64.h b/arch/sparc/include/asm/processor_64.h
index 4c3f7f0..733544b 100644
--- a/arch/sparc/include/asm/processor_64.h
+++ b/arch/sparc/include/asm/processor_64.h
@@ -216,6 +216,7 @@ extern unsigned long get_wchan(struct task_struct *task);
 				     "nop\n\t"				\
 				     ".previous"			\
 				     ::: "memory")
+#define cpu_relax_lowlatency() cpu_relax()
 
 /* Prefetch support.  This is tuned for UltraSPARC-III and later.
  * UltraSPARC-I will treat these as nops, and UltraSPARC-II has
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index 4232363..dd4f9f1 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -266,6 +266,8 @@ static inline void cpu_relax(void)
 	barrier();
 }
 
+#define cpu_relax_lowlatency() cpu_relax()
+
 /* Info on this processor (see fs/proc/cpuinfo.c) */
 struct seq_operations;
 extern const struct seq_operations cpuinfo_op;
diff --git a/arch/unicore32/include/asm/processor.h b/arch/unicore32/include/asm/processor.h
index 4eaa421..8d21b7a 100644
--- a/arch/unicore32/include/asm/processor.h
+++ b/arch/unicore32/include/asm/processor.h
@@ -71,6 +71,7 @@ extern void release_thread(struct task_struct *);
 unsigned long get_wchan(struct task_struct *p);
 
 #define cpu_relax()			barrier()
+#define cpu_relax_lowlatency()                cpu_relax()
 
 #define task_pt_regs(p) \
 	((struct pt_regs *)(THREAD_START_SP + task_stack_page(p)) - 1)
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index a4ea023..32cc237 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -696,6 +696,8 @@ static inline void cpu_relax(void)
 	rep_nop();
 }
 
+#define cpu_relax_lowlatency() cpu_relax()
+
 /* Stop speculative execution and prefetching of modified code. */
 static inline void sync_core(void)
 {
diff --git a/arch/xtensa/include/asm/processor.h b/arch/xtensa/include/asm/processor.h
index abb5970..b61bdf0 100644
--- a/arch/xtensa/include/asm/processor.h
+++ b/arch/xtensa/include/asm/processor.h
@@ -182,6 +182,7 @@ extern unsigned long get_wchan(struct task_struct *p);
 #define KSTK_ESP(tsk)		(task_pt_regs(tsk)->areg[1])
 
 #define cpu_relax()  barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 /* Special register access. */
 
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 11692de..cf63ead 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -176,8 +176,4 @@ extern void mutex_unlock(struct mutex *lock);
 
 extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 
-#ifndef arch_mutex_cpu_relax
-# define arch_mutex_cpu_relax() cpu_relax()
-#endif
-
 #endif /* __LINUX_MUTEX_H */
diff --git a/kernel/locking/mcs_spinlock.c b/kernel/locking/mcs_spinlock.c
index 838dc9e..b469bd3 100644
--- a/kernel/locking/mcs_spinlock.c
+++ b/kernel/locking/mcs_spinlock.c
@@ -1,6 +1,4 @@
-
 #include <linux/percpu.h>
-#include <linux/mutex.h>
 #include <linux/sched.h>
 #include "mcs_spinlock.h"
 
@@ -53,7 +51,7 @@ osq_wait_next(struct optimistic_spin_queue **lock,
 				break;
 		}
 
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 	}
 
 	return next;
@@ -89,7 +87,7 @@ bool osq_lock(struct optimistic_spin_queue **lock)
 		if (need_resched())
 			goto unqueue;
 
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 	}
 	return true;
 
@@ -115,7 +113,7 @@ unqueue:
 		if (smp_load_acquire(&node->locked))
 			return true;
 
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 
 		/*
 		 * Or we race against a concurrent unqueue()'s step-B, in which
diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
index a2dbac4..856880e 100644
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -27,7 +27,7 @@ struct mcs_spinlock {
 #define arch_mcs_spin_lock_contended(l)					\
 do {									\
 	while (!(smp_load_acquire(l)))					\
-		arch_mutex_cpu_relax();					\
+		cpu_relax_lowlatency();					\
 } while (0)
 #endif
 
@@ -104,7 +104,7 @@ void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 			return;
 		/* Wait until the next pointer is set */
 		while (!(next = ACCESS_ONCE(node->next)))
-			arch_mutex_cpu_relax();
+			cpu_relax_lowlatency();
 	}
 
 	/* Pass lock to next waiter. */
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index bc73d33..19ceb91 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -152,7 +152,7 @@ int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
 		if (need_resched())
 			break;
 
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 	}
 	rcu_read_unlock();
 
@@ -471,7 +471,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * memory barriers as we'll eventually observe the right
 		 * values at the cost of a few extra spins.
 		 */
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 	}
 	osq_unlock(&lock->osq);
 slowpath:
diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
index fb5b8ac..f956ede 100644
--- a/kernel/locking/qrwlock.c
+++ b/kernel/locking/qrwlock.c
@@ -20,7 +20,6 @@
 #include <linux/cpumask.h>
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
-#include <linux/mutex.h>
 #include <asm/qrwlock.h>
 
 /**
@@ -35,7 +34,7 @@ static __always_inline void
 rspin_until_writer_unlock(struct qrwlock *lock, u32 cnts)
 {
 	while ((cnts & _QW_WMASK) == _QW_LOCKED) {
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 		cnts = smp_load_acquire((u32 *)&lock->cnts);
 	}
 }
@@ -75,7 +74,7 @@ void queue_read_lock_slowpath(struct qrwlock *lock)
 	 * to make sure that the write lock isn't taken.
 	 */
 	while (atomic_read(&lock->cnts) & _QW_WMASK)
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 
 	cnts = atomic_add_return(_QR_BIAS, &lock->cnts) - _QR_BIAS;
 	rspin_until_writer_unlock(lock, cnts);
@@ -114,7 +113,7 @@ void queue_write_lock_slowpath(struct qrwlock *lock)
 				    cnts | _QW_WAITING) == cnts))
 			break;
 
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 	}
 
 	/* When no more readers, set the locked flag */
@@ -125,7 +124,7 @@ void queue_write_lock_slowpath(struct qrwlock *lock)
 				    _QW_LOCKED) == _QW_WAITING))
 			break;
 
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 	}
 unlock:
 	arch_spin_unlock(&lock->lock);
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index dacc321..f69ddb0 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -329,7 +329,7 @@ bool rwsem_spin_on_owner(struct rw_semaphore *sem, struct task_struct *owner)
 		if (need_resched())
 			break;
 
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 	}
 	rcu_read_unlock();
 
@@ -381,7 +381,7 @@ static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
 		 * memory barriers as we'll eventually observe the right
 		 * values at the cost of a few extra spins.
 		 */
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 	}
 	osq_unlock(&sem->osq);
 done:
diff --git a/lib/lockref.c b/lib/lockref.c
index f07a40d..d2233de 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -1,6 +1,5 @@
 #include <linux/export.h>
 #include <linux/lockref.h>
-#include <linux/mutex.h>
 
 #if USE_CMPXCHG_LOCKREF
 
@@ -29,7 +28,7 @@
 		if (likely(old.lock_count == prev.lock_count)) {		\
 			SUCCESS;						\
 		}								\
-		arch_mutex_cpu_relax();						\
+		cpu_relax_lowlatency();						\
 	}									\
 } while (0)
 
-- 
1.8.1.4



