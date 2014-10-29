Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934392AbaJ2QKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:10:17 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:44575 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994AbaJ2QKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:10:14 -0400
X-Originating-IP: 50.43.41.112
Date: Wed, 29 Oct 2014 09:10:02 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH v3 3/3] x86: Support compiling out userspace I/O (iopl and
 ioperm)
Message-ID: <9d77d0e4df8feb2cb55fb21689e016a3145cb7f8.1414598511.git.josh@joshtriplett.org>
References: <7159269982aac3b732af2c33a2e3d04e2048bdfb.1414598511.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7159269982aac3b732af2c33a2e3d04e2048bdfb.1414598511.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the vast majority of modern systems, no processes will use the
userspsace I/O syscalls, iopl and ioperm.  Add a new config option,
CONFIG_X86_IOPORT, to support configuring them out of the kernel
entirely.  Most current systems do not run programs using these
syscalls, so X86_IOPORT does not depend on EXPERT, though it does still
default to y.

In addition to saving a significant amount of space, this also reduces
the size of several major kernel data structures, drops a bit of code
from several task-related hot paths, and reduces the attack surface of
the kernel.

All of the task-related code dealing with userspace I/O permissions now
lives in process-io.h as several new inline functions, which become
no-ops without CONFIG_X86_IOPORT.

bloat-o-meter results:

add/remove: 0/4 grow/shrink: 4/9 up/down: 83/-9074 (-8991)
function                                     old     new   delta
drop_fpu                                      80     160     +80
perf_event_init_task                         638     639      +1
perf_event_exec                              192     193      +1
perf_event_aux                               132     133      +1
test_tsk_thread_flag                          10       -     -10
ioperm_active                                 14       3     -11
init_task                                    916     904     -12
flush_thread                                 168     149     -19
cpu_init                                     364     339     -25
__drop_fpu                                    60       -     -60
ioperm_get                                    92       6     -86
exit_thread                                  105      10     -95
sys_iopl                                     106       -    -106
copy_thread                                  364     257    -107
__switch_to_xtra                             234     123    -111
sys_ioperm                                   240       -    -240
init_tss                                    8576     384   -8192

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
v3: Eliminated several #ifdefs, and in particular almost all #ifdefs in
    .c files, by adding a macro INIT_SET_IOPL_MASK to use in place of
    the initializer for set_iopl_mask, and using __maybe_unused rather
    than wrapping function definitions in #ifdef.  Rebased on v3.18-rc1.
    Recomputed bloat-o-meter.

I assume this should go through the x86 tree rather than the tiny tree.

 arch/x86/Kconfig                      | 10 +++++
 arch/x86/include/asm/paravirt.h       |  2 +
 arch/x86/include/asm/paravirt_types.h |  5 +++
 arch/x86/include/asm/processor.h      | 51 +++++++++++++++++++++----
 arch/x86/include/asm/syscalls.h       |  3 ++
 arch/x86/kernel/Makefile              |  3 +-
 arch/x86/kernel/cpu/common.c          | 12 +-----
 arch/x86/kernel/entry_64.S            |  9 +++--
 arch/x86/kernel/paravirt.c            |  2 +-
 arch/x86/kernel/process-io.h          | 71 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/process.c             | 34 ++---------------
 arch/x86/kernel/process_32.c          | 13 ++-----
 arch/x86/kernel/process_64.c          |  2 +-
 arch/x86/kernel/ptrace.c              |  8 ++++
 arch/x86/xen/enlighten.c              |  4 +-
 drivers/tty/vt/vt_ioctl.c             |  2 +-
 kernel/sys_ni.c                       |  5 +++
 17 files changed, 169 insertions(+), 67 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f2327e8..a7de2eb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -984,6 +984,16 @@ config X86_ESPFIX64
 	def_bool y
 	depends on X86_16BIT && X86_64
 
+config X86_IOPORT
+	bool "iopl and ioperm system calls"
+	default y
+	---help---
+	  This option enables the iopl and ioperm system calls, which allow
+	  privileged userspace processes to directly access I/O ports. This
+	  is used by software that drives hardware directly from userspace
+	  without using a kernel driver. Unless you intend to run such
+	  software, you can safely say N here.
+
 config TOSHIBA
 	tristate "Toshiba Laptop support"
 	depends on X86_32
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index cd6e161..52d2ec8 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -299,10 +299,12 @@ static inline void write_idt_entry(gate_desc *dt, int entry, const gate_desc *g)
 {
 	PVOP_VCALL3(pv_cpu_ops.write_idt_entry, dt, entry, g);
 }
+#ifdef CONFIG_X86_IOPORT
 static inline void set_iopl_mask(unsigned mask)
 {
 	PVOP_VCALL1(pv_cpu_ops.set_iopl_mask, mask);
 }
+#endif /* CONFIG_X86_IOPORT */
 
 /* The paravirtualized I/O functions */
 static inline void slow_down_io(void)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 7549b8b..a22a5d4 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -142,7 +142,12 @@ struct pv_cpu_ops {
 
 	void (*load_sp0)(struct tss_struct *tss, struct thread_struct *t);
 
+#ifdef CONFIG_X86_IOPORT
 	void (*set_iopl_mask)(unsigned mask);
+#define INIT_SET_IOPL_MASK(f) .set_iopl_mask = f,
+#else
+#define INIT_SET_IOPL_MASK(f)
+#endif
 
 	void (*wbinvd)(void);
 	void (*io_delay)(void);
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 76751cd..6e0b639 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -255,7 +255,11 @@ struct x86_hw_tss {
 /*
  * IO-bitmap sizes:
  */
+#ifdef CONFIG_X86_IOPORT
 #define IO_BITMAP_BITS			65536
+#else
+#define IO_BITMAP_BITS			0
+#endif
 #define IO_BITMAP_BYTES			(IO_BITMAP_BITS/8)
 #define IO_BITMAP_LONGS			(IO_BITMAP_BYTES/sizeof(long))
 #define INVALID_IO_BITMAP_OFFSET	0x8000
@@ -269,6 +273,7 @@ struct tss_struct {
 	 */
 	struct x86_hw_tss	x86_tss;
 
+#ifdef CONFIG_X86_IOPORT
 	/*
 	 * The extra 1 is there because the CPU will access an
 	 * additional byte beyond the end of the IO permission
@@ -276,6 +281,7 @@ struct tss_struct {
 	 * be within the limit.
 	 */
 	unsigned long		io_bitmap[IO_BITMAP_LONGS + 1];
+#endif /* CONFIG_X86_IOPORT */
 
 	/*
 	 * .. and then another 0x100 bytes for the emergency kernel stack:
@@ -286,6 +292,24 @@ struct tss_struct {
 
 DECLARE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss);
 
+static inline void init_tss_io(struct tss_struct *t)
+{
+#ifdef CONFIG_X86_IOPORT
+	int i;
+
+	t->x86_tss.io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
+
+	/*
+	 * <= is required because the CPU will access up to
+	 * 8 bits beyond the end of the IO permission bitmap.
+	 */
+	for (i = 0; i <= IO_BITMAP_LONGS; i++)
+		t->io_bitmap[i] = ~0UL;
+#else
+	t->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
+#endif
+}
+
 /*
  * Save the original ist values for checking stack pointers during debugging
  */
@@ -510,11 +534,13 @@ struct thread_struct {
 	unsigned int		saved_fs;
 	unsigned int		saved_gs;
 #endif
+#ifdef CONFIG_X86_IOPORT
 	/* IO permissions: */
 	unsigned long		*io_bitmap_ptr;
 	unsigned long		iopl;
 	/* Max allowed port in the bitmap, in bytes: */
 	unsigned		io_bitmap_max;
+#endif /* CONFIG_X86_IOPORT */
 	/*
 	 * fpu_counter contains the number of consecutive context switches
 	 * that the FPU is used. If this is over a threshold, the lazy fpu
@@ -531,7 +557,7 @@ struct thread_struct {
  */
 static inline void native_set_iopl_mask(unsigned mask)
 {
-#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86_IOPORT) && defined(CONFIG_X86_32)
 	unsigned int reg;
 
 	asm volatile ("pushfl;"
@@ -842,12 +868,8 @@ static inline void spin_lock_prefetch(const void *x)
 #define STACK_TOP		TASK_SIZE
 #define STACK_TOP_MAX		STACK_TOP
 
-#define INIT_THREAD  {							  \
-	.sp0			= sizeof(init_stack) + (long)&init_stack, \
-	.vm86_info		= NULL,					  \
-	.sysenter_cs		= __KERNEL_CS,				  \
-	.io_bitmap_ptr		= NULL,					  \
-}
+#ifdef CONFIG_X86_IOPORT
+#define INIT_THREAD_IO .io_bitmap_ptr = NULL,
 
 /*
  * Note that the .io_bitmap member must be extra-big. This is because
@@ -855,6 +877,19 @@ static inline void spin_lock_prefetch(const void *x)
  * permission bitmap. The extra byte must be all 1 bits, and must
  * be within the limit.
  */
+#define INIT_TSS_IO .io_bitmap = { [0 ... IO_BITMAP_LONGS] = ~0 },
+#else
+#define INIT_THREAD_IO
+#define INIT_TSS_IO
+#endif
+
+#define INIT_THREAD  {							  \
+	.sp0			= sizeof(init_stack) + (long)&init_stack, \
+	.vm86_info		= NULL,					  \
+	.sysenter_cs		= __KERNEL_CS,				  \
+	INIT_THREAD_IO							  \
+}
+
 #define INIT_TSS  {							  \
 	.x86_tss = {							  \
 		.sp0		= sizeof(init_stack) + (long)&init_stack, \
@@ -862,7 +897,7 @@ static inline void spin_lock_prefetch(const void *x)
 		.ss1		= __KERNEL_CS,				  \
 		.io_bitmap_base	= INVALID_IO_BITMAP_OFFSET,		  \
 	 },								  \
-	.io_bitmap		= { [0 ... IO_BITMAP_LONGS] = ~0 },	  \
+	INIT_TSS_IO							  \
 }
 
 extern unsigned long thread_saved_pc(struct task_struct *tsk);
diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 592a6a6..4db79ea 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -16,9 +16,12 @@
 #include <linux/types.h>
 
 /* Common in X86_32 and X86_64 */
+
+#ifdef CONFIG_X86_IOPORT
 /* kernel/ioport.c */
 asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
 asmlinkage long sys_iopl(unsigned int);
+#endif /* CONFIG_X86_IOPORT */
 
 /* kernel/ldt.c */
 asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 8f1e774..84d5fbe 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -20,7 +20,8 @@ CFLAGS_irq.o := -I$(src)/../include/asm/trace
 
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
-obj-y			+= time.o ioport.o ldt.o dumpstack.o nmi.o
+obj-y			+= time.o ldt.o dumpstack.o nmi.o
+obj-$(CONFIG_X86_IOPORT) += ioport.o
 obj-y			+= setup.o x86_init.o i8259.o irqinit.o jump_label.o
 obj-$(CONFIG_IRQ_WORK)  += irq_work.o
 obj-y			+= probe_roms.o
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4b4f78c..ae2e8d7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1297,7 +1297,6 @@ void cpu_init(void)
 	struct tss_struct *t;
 	unsigned long v;
 	int cpu = stack_smp_processor_id();
-	int i;
 
 	wait_for_master_cpu(cpu);
 
@@ -1357,14 +1356,7 @@ void cpu_init(void)
 		}
 	}
 
-	t->x86_tss.io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
-
-	/*
-	 * <= is required because the CPU will access up to
-	 * 8 bits beyond the end of the IO permission bitmap.
-	 */
-	for (i = 0; i <= IO_BITMAP_LONGS; i++)
-		t->io_bitmap[i] = ~0UL;
+	init_tss_io(t);
 
 	atomic_inc(&init_mm.mm_count);
 	me->active_mm = &init_mm;
@@ -1419,7 +1411,7 @@ void cpu_init(void)
 	load_TR_desc();
 	load_LDT(&init_mm.context);
 
-	t->x86_tss.io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
+	init_tss_io(t);
 
 #ifdef CONFIG_DOUBLEFAULT
 	/* Set up doublefault TSS pointer in the GDT */
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index df088bb..1e6a74e0 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -609,6 +609,11 @@ ENTRY(stub_\func)
 END(stub_\func)
 	.endm
 
+	FORK_LIKE  clone
+	FORK_LIKE  fork
+	FORK_LIKE  vfork
+
+#ifdef CONFIG_X86_IOPORT
 	.macro FIXED_FRAME label,func
 ENTRY(\label)
 	CFI_STARTPROC
@@ -621,10 +626,8 @@ ENTRY(\label)
 END(\label)
 	.endm
 
-	FORK_LIKE  clone
-	FORK_LIKE  fork
-	FORK_LIKE  vfork
 	FIXED_FRAME stub_iopl, sys_iopl
+#endif /* CONFIG_X86_IOPORT */
 
 ENTRY(ptregscall_common)
 	DEFAULT_FRAME 1 8	/* offset 8: return address */
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 548d25f..e7969d4 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -383,7 +383,7 @@ __visible struct pv_cpu_ops pv_cpu_ops = {
 	.iret = native_iret,
 	.swapgs = native_swapgs,
 
-	.set_iopl_mask = native_set_iopl_mask,
+	INIT_SET_IOPL_MASK(native_set_iopl_mask)
 	.io_delay = native_io_delay,
 
 	.start_context_switch = paravirt_nop,
diff --git a/arch/x86/kernel/process-io.h b/arch/x86/kernel/process-io.h
index d884444..3e773fa 100644
--- a/arch/x86/kernel/process-io.h
+++ b/arch/x86/kernel/process-io.h
@@ -1,9 +1,17 @@
 #ifndef _X86_KERNEL_PROCESS_IO_H
 #define _X86_KERNEL_PROCESS_IO_H
 
+static inline void clear_thread_io_bitmap(struct task_struct *p)
+{
+#ifdef CONFIG_X86_IOPORT
+	p->thread.io_bitmap_ptr = NULL;
+#endif /* CONFIG_X86_IOPORT */
+}
+
 static inline int copy_io_bitmap(struct task_struct *me,
 				 struct task_struct *p)
 {
+#ifdef CONFIG_X86_IOPORT
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(me->thread.io_bitmap_ptr,
 						  IO_BITMAP_BYTES, GFP_KERNEL);
@@ -15,8 +23,71 @@ static inline int copy_io_bitmap(struct task_struct *me,
 	} else {
 		p->thread.io_bitmap_ptr = NULL;
 	}
+#endif /* CONFIG_X86_IOPORT */
 
 	return 0;
 }
 
+static inline void exit_thread_io(struct task_struct *me)
+{
+#ifdef CONFIG_X86_IOPORT
+        struct thread_struct *t = &me->thread;
+        unsigned long *bp = t->io_bitmap_ptr;
+
+        if (bp) {
+                struct tss_struct *tss = &per_cpu(init_tss, get_cpu());
+
+                t->io_bitmap_ptr = NULL;
+                clear_thread_flag(TIF_IO_BITMAP);
+                /*
+                 * Careful, clear this in the TSS too:
+                 */
+                memset(tss->io_bitmap, 0xff, t->io_bitmap_max);
+                t->io_bitmap_max = 0;
+                put_cpu();
+                kfree(bp);
+        }
+#endif /* CONFIG_X86_IOPORT */
+}
+
+static inline void switch_iopl_mask(struct thread_struct *prev,
+				    struct thread_struct *next)
+{
+#ifdef CONFIG_X86_IOPORT
+        /*
+         * Restore IOPL if needed.  In normal use, the flags restore
+         * in the switch assembly will handle this.  But if the kernel
+         * is running virtualized at a non-zero CPL, the popf will
+         * not restore flags, so it must be done in a separate step.
+         */
+        if (get_kernel_rpl() && unlikely(prev->iopl != next->iopl))
+                set_iopl_mask(next->iopl);
+#endif /* CONFIG_X86_IOPORT */
+}
+
+static inline void switch_io_bitmap(struct tss_struct *tss,
+				    struct task_struct *prev_p,
+				    struct task_struct *next_p)
+{
+#ifdef CONFIG_X86_IOPORT
+        struct thread_struct *prev, *next;
+        prev = &prev_p->thread;
+        next = &next_p->thread;
+
+        if (test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
+                /*
+                 * Copy the relevant range of the IO bitmap.
+                 * Normally this is 128 bytes or less:
+                 */
+                memcpy(tss->io_bitmap, next->io_bitmap_ptr,
+                       max(prev->io_bitmap_max, next->io_bitmap_max));
+        } else if (test_tsk_thread_flag(prev_p, TIF_IO_BITMAP)) {
+                /*
+                 * Clear any possible leftover bits:
+                 */
+                memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
+        }
+#endif /* CONFIG_X86_IOPORT */
+}
+
 #endif /* _X86_KERNEL_PROCESS_IO_H */
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e127dda..7ac01bf 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -29,6 +29,8 @@
 #include <asm/debugreg.h>
 #include <asm/nmi.h>
 
+#include "process-io.h"
+
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
  * no more per-task TSS's. The TSS size is kept cacheline-aligned
@@ -104,23 +106,7 @@ void arch_task_cache_init(void)
 void exit_thread(void)
 {
 	struct task_struct *me = current;
-	struct thread_struct *t = &me->thread;
-	unsigned long *bp = t->io_bitmap_ptr;
-
-	if (bp) {
-		struct tss_struct *tss = &per_cpu(init_tss, get_cpu());
-
-		t->io_bitmap_ptr = NULL;
-		clear_thread_flag(TIF_IO_BITMAP);
-		/*
-		 * Careful, clear this in the TSS too:
-		 */
-		memset(tss->io_bitmap, 0xff, t->io_bitmap_max);
-		t->io_bitmap_max = 0;
-		put_cpu();
-		kfree(bp);
-	}
-
+	exit_thread_io(me);
 	drop_fpu(me);
 }
 
@@ -225,19 +211,7 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 			hard_enable_TSC();
 	}
 
-	if (test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
-		/*
-		 * Copy the relevant range of the IO bitmap.
-		 * Normally this is 128 bytes or less:
-		 */
-		memcpy(tss->io_bitmap, next->io_bitmap_ptr,
-		       max(prev->io_bitmap_max, next->io_bitmap_max));
-	} else if (test_tsk_thread_flag(prev_p, TIF_IO_BITMAP)) {
-		/*
-		 * Clear any possible leftover bits:
-		 */
-		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
-	}
+	switch_io_bitmap(tss, prev_p, next_p);
 	propagate_user_return_notify(prev_p, next_p);
 }
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 07550ff..3b82293 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -154,7 +154,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		childregs->orig_ax = -1;
 		childregs->cs = __KERNEL_CS | get_kernel_rpl();
 		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
-		p->thread.io_bitmap_ptr = NULL;
+		clear_thread_io_bitmap(p);
 		return 0;
 	}
 	*childregs = *current_pt_regs();
@@ -165,7 +165,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	p->thread.ip = (unsigned long) ret_from_fork;
 	task_user_gs(p) = get_user_gs(current_pt_regs());
 
-	p->thread.io_bitmap_ptr = NULL;
+	clear_thread_io_bitmap(p);
 	tsk = current;
 
 	/*
@@ -265,14 +265,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	load_TLS(next, cpu);
 
-	/*
-	 * Restore IOPL if needed.  In normal use, the flags restore
-	 * in the switch assembly will handle this.  But if the kernel
-	 * is running virtualized at a non-zero CPL, the popf will
-	 * not restore flags, so it must be done in a separate step.
-	 */
-	if (get_kernel_rpl() && unlikely(prev->iopl != next->iopl))
-		set_iopl_mask(next->iopl);
+	switch_iopl_mask(prev, next);
 
 	/*
 	 * If it were not for PREEMPT_ACTIVE we could guarantee that the
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b1babb4..d18f3fc 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -164,7 +164,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	p->thread.sp = (unsigned long) childregs;
 	p->thread.usersp = me->thread.usersp;
 	set_tsk_thread_flag(p, TIF_FORK);
-	p->thread.io_bitmap_ptr = NULL;
+	clear_thread_io_bitmap(p);
 
 	savesegment(gs, p->thread.gsindex);
 	p->thread.gs = p->thread.gsindex ? 0 : me->thread.gs;
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 749b0e4..fdb74a8 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -785,7 +785,11 @@ static int ptrace_set_debugreg(struct task_struct *tsk, int n,
 static int ioperm_active(struct task_struct *target,
 			 const struct user_regset *regset)
 {
+#ifdef CONFIG_X86_IOPORT
 	return target->thread.io_bitmap_max / regset->size;
+#else
+	return 0;
+#endif
 }
 
 static int ioperm_get(struct task_struct *target,
@@ -793,12 +797,16 @@ static int ioperm_get(struct task_struct *target,
 		      unsigned int pos, unsigned int count,
 		      void *kbuf, void __user *ubuf)
 {
+#ifdef CONFIG_X86_IOPORT
 	if (!target->thread.io_bitmap_ptr)
 		return -ENXIO;
 
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
 				   target->thread.io_bitmap_ptr,
 				   0, IO_BITMAP_BYTES);
+#else
+	return -ENXIO;
+#endif
 }
 
 /*
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 1a3f044..8ad0778 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -912,7 +912,7 @@ static void xen_load_sp0(struct tss_struct *tss,
 	xen_mc_issue(PARAVIRT_LAZY_CPU);
 }
 
-static void xen_set_iopl_mask(unsigned mask)
+static void __maybe_unused xen_set_iopl_mask(unsigned mask)
 {
 	struct physdev_set_iopl set_iopl;
 
@@ -1279,7 +1279,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.write_idt_entry = xen_write_idt_entry,
 	.load_sp0 = xen_load_sp0,
 
-	.set_iopl_mask = xen_set_iopl_mask,
+	INIT_SET_IOPL_MASK(xen_set_iopl_mask)
 	.io_delay = xen_io_delay,
 
 	/* Xen takes care of %gs when switching to usermode for us */
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 2bd78e2..7c7d405 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -410,7 +410,7 @@ int vt_ioctl(struct tty_struct *tty,
 		 *
 		 * XXX: you should never use these, just call ioperm directly..
 		 */
-#ifdef CONFIG_X86
+#ifdef CONFIG_X86_IOPORT
 	case KDADDIO:
 	case KDDELIO:
 		/*
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 02aa418..f3014fe 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -224,3 +224,8 @@ cond_syscall(sys_seccomp);
 
 /* access BPF programs and maps */
 cond_syscall(sys_bpf);
+
+/* userspace I/O port access */
+cond_syscall(stub_iopl);
+cond_syscall(sys_iopl);
+cond_syscall(sys_ioperm);
-- 
2.1.1

