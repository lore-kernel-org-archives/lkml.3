Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbaCKV4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 17:56:44 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:49110 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbaCKV4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 17:56:43 -0400
X-Originating-IP: 98.158.13.34
Date: Tue, 11 Mar 2014 14:56:31 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Alok Kataria <akataria@vmware.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Chris Wright <chrisw@sous-sol.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Jiri Slaby <jslaby@suse.cz>,
        Kees Cook <keescook@chromium.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCHv2 3/3] x86: Support compiling out userspace I/O (iopl and
 ioperm)
Message-ID: <8c735c04da634460ebbf464fbaa8ec3c15f00a61.1394573469.git.josh@joshtriplett.org>
References: <36375e1f113abf53ebfcac87a4275a5efd9d8057.1394573469.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36375e1f113abf53ebfcac87a4275a5efd9d8057.1394573469.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
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
no-ops when CONFIG_X86_IOPORT.

bloat-o-meter shows a net reduction of 9223 bytes on 32-bit and 9491
bytes on 64-bit:

32-bit bloat-o-meter:
add/remove: 0/3 grow/shrink: 0/8 up/down: 0/-9223 (-9223)
function                                     old     new   delta
ioperm_active                                 14       3     -11
init_task                                    888     876     -12
cpu_init                                     497     465     -32
exit_thread                                  147      75     -72
ioperm_get                                   100       6     -94
__switch_to_xtra                             239     141     -98
sys_iopl                                     114       -    -114
SyS_iopl                                     114       -    -114
copy_thread                                  584     443    -141
sys_ioperm                                   343       -    -343
init_tss                                    8576     384   -8192

64-bit bloat-o-meter:
add/remove: 0/4 grow/shrink: 0/8 up/down: 0/-9491 (-9491)
function                                     old     new   delta
cpu_init                                     840     835      -5
ioperm_active                                 12       3      -9
init_task                                   1416    1400     -16
stub_iopl                                     79       -     -79
exit_thread                                  164      84     -80
ioperm_get                                   101       6     -95
__switch_to_xtra                             263     155    -108
sys_iopl                                     129       -    -129
SyS_iopl                                     129       -    -129
copy_thread                                  598     455    -143
sys_ioperm                                   442       -    -442
init_tss                                    8896     640   -8256

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
v2: Rebased.  Updated bloat-o-meter statistics.  Changed description of
    the new Kconfig system to more neutrally describe the software using
    iopl and ioperm.

 arch/x86/Kconfig                      | 10 +++++
 arch/x86/include/asm/paravirt.h       |  2 +
 arch/x86/include/asm/paravirt_types.h |  2 +
 arch/x86/include/asm/processor.h      | 51 +++++++++++++++++++++----
 arch/x86/include/asm/syscalls.h       |  3 ++
 arch/x86/kernel/Makefile              |  3 +-
 arch/x86/kernel/cpu/common.c          | 12 +-----
 arch/x86/kernel/entry_64.S            |  9 +++--
 arch/x86/kernel/paravirt.c            |  2 +
 arch/x86/kernel/process-io.h          | 71 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/process.c             | 34 ++---------------
 arch/x86/kernel/process_32.c          | 13 ++-----
 arch/x86/kernel/process_64.c          |  2 +-
 arch/x86/kernel/ptrace.c              |  8 ++++
 arch/x86/xen/enlighten.c              |  4 ++
 drivers/tty/vt/vt_ioctl.c             |  2 +-
 kernel/sys_ni.c                       |  5 +++
 17 files changed, 170 insertions(+), 63 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..6ce28fb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -970,6 +970,16 @@ config VM86
 	  XFree86 to initialize some video cards via BIOS. Disabling this
 	  option saves about 6k.
 
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
index 7549b8b..8b51bd1 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -142,7 +142,9 @@ struct pv_cpu_ops {
 
 	void (*load_sp0)(struct tss_struct *tss, struct thread_struct *t);
 
+#ifdef CONFIG_X86_IOPORT
 	void (*set_iopl_mask)(unsigned mask);
+#endif /* CONFIG_X86_IOPORT */
 
 	void (*wbinvd)(void);
 	void (*io_delay)(void);
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7da8794..853d24c 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -256,7 +256,11 @@ struct x86_hw_tss {
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
@@ -270,6 +274,7 @@ struct tss_struct {
 	 */
 	struct x86_hw_tss	x86_tss;
 
+#ifdef CONFIG_X86_IOPORT
 	/*
 	 * The extra 1 is there because the CPU will access an
 	 * additional byte beyond the end of the IO permission
@@ -277,6 +282,7 @@ struct tss_struct {
 	 * be within the limit.
 	 */
 	unsigned long		io_bitmap[IO_BITMAP_LONGS + 1];
+#endif /* CONFIG_X86_IOPORT */
 
 	/*
 	 * .. and then another 0x100 bytes for the emergency kernel stack:
@@ -287,6 +293,24 @@ struct tss_struct {
 
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
@@ -502,11 +526,13 @@ struct thread_struct {
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
@@ -518,6 +544,7 @@ struct thread_struct {
 	unsigned char fpu_counter;
 };
 
+#ifdef CONFIG_X86_IOPORT
 /*
  * Set IOPL bits in EFLAGS from given mask
  */
@@ -536,6 +563,7 @@ static inline void native_set_iopl_mask(unsigned mask)
 		      : "i" (~X86_EFLAGS_IOPL), "r" (mask));
 #endif
 }
+#endif /* CONFIG_X86_IOPORT */
 
 static inline void
 native_load_sp0(struct tss_struct *tss, struct thread_struct *thread)
@@ -832,12 +860,8 @@ static inline void spin_lock_prefetch(const void *x)
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
@@ -845,6 +869,19 @@ static inline void spin_lock_prefetch(const void *x)
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
@@ -852,7 +889,7 @@ static inline void spin_lock_prefetch(const void *x)
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
index cb648c8..0d84b07 100644
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
index 8e28bf2..de79215 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1236,7 +1236,6 @@ void cpu_init(void)
 	struct tss_struct *t;
 	unsigned long v;
 	int cpu;
-	int i;
 
 	/*
 	 * Load microcode on this cpu if a valid microcode is available.
@@ -1298,14 +1297,7 @@ void cpu_init(void)
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
@@ -1364,7 +1356,7 @@ void cpu_init(void)
 	load_TR_desc();
 	load_LDT(&init_mm.context);
 
-	t->x86_tss.io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
+	init_tss_io(t);
 
 #ifdef CONFIG_DOUBLEFAULT
 	/* Set up doublefault TSS pointer in the GDT */
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1e96c36..d2d873a 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -829,6 +829,11 @@ ENTRY(stub_\func)
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
@@ -841,10 +846,8 @@ ENTRY(\label)
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
index 1b10af8..46da3d9 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -382,7 +382,9 @@ __visible struct pv_cpu_ops pv_cpu_ops = {
 	.iret = native_iret,
 	.swapgs = native_swapgs,
 
+#ifdef CONFIG_X86_IOPORT
 	.set_iopl_mask = native_set_iopl_mask,
+#endif /* CONFIG_X86_IOPORT */
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
index 3fb8d95..29c0693 100644
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
@@ -101,23 +103,7 @@ void arch_task_cache_init(void)
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
 
@@ -222,19 +208,7 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
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
index 73a38c8..38eaae4 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -154,7 +154,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		childregs->cs = __KERNEL_CS | get_kernel_rpl();
 		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
 		p->thread.fpu_counter = 0;
-		p->thread.io_bitmap_ptr = NULL;
+		clear_thread_io_bitmap(p);
 		memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 		return 0;
 	}
@@ -167,7 +167,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	task_user_gs(p) = get_user_gs(current_pt_regs());
 
 	p->thread.fpu_counter = 0;
-	p->thread.io_bitmap_ptr = NULL;
+	clear_thread_io_bitmap(p);
 	tsk = current;
 
 	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
@@ -269,14 +269,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
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
index 3b8f17c..7eb9adc 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -165,7 +165,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	p->thread.usersp = me->thread.usersp;
 	set_tsk_thread_flag(p, TIF_FORK);
 	p->thread.fpu_counter = 0;
-	p->thread.io_bitmap_ptr = NULL;
+	clear_thread_io_bitmap(p);
 
 	savesegment(gs, p->thread.gsindex);
 	p->thread.gs = p->thread.gsindex ? 0 : me->thread.gs;
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 7461f50..f071bfa 100644
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
index 201d09a..0de20ba 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -912,6 +912,7 @@ static void xen_load_sp0(struct tss_struct *tss,
 	xen_mc_issue(PARAVIRT_LAZY_CPU);
 }
 
+#ifdef CONFIG_X86_IOPORT
 static void xen_set_iopl_mask(unsigned mask)
 {
 	struct physdev_set_iopl set_iopl;
@@ -920,6 +921,7 @@ static void xen_set_iopl_mask(unsigned mask)
 	set_iopl.iopl = (mask == 0) ? 1 : (mask >> 12) & 3;
 	HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl);
 }
+#endif /* CONFIG_X86_IOPORT */
 
 static void xen_io_delay(void)
 {
@@ -1279,7 +1281,9 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.write_idt_entry = xen_write_idt_entry,
 	.load_sp0 = xen_load_sp0,
 
+#ifdef CONFIG_X86_IOPORT
 	.set_iopl_mask = xen_set_iopl_mask,
+#endif /* CONFIG_X86_IOPORT */
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
index 7078052..e7f4a35 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -209,3 +209,8 @@ cond_syscall(compat_sys_open_by_handle_at);
 
 /* compare kernel pointers */
 cond_syscall(sys_kcmp);
+
+/* userspace I/O port access */
+cond_syscall(stub_iopl);
+cond_syscall(sys_iopl);
+cond_syscall(sys_ioperm);
-- 
1.9.0

