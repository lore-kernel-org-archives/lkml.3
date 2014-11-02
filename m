Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaKBRdM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 12:33:12 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:51685 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaKBRdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 12:33:08 -0500
X-Originating-IP: 50.43.41.112
Date: Sun, 2 Nov 2014 09:33:01 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH v4 10/10] x86: Support compiling out userspace IO (iopl and
 ioperm)
Message-ID: <ec10c497d3a7f44f335dbc267edd6de5b4acd671.1414870871.git.josh@joshtriplett.org>
References: <cover.1414870871.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414870871.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the vast majority of modern systems, no processes will use the
userspsace IO syscalls, iopl and ioperm.  Add a new config option,
CONFIG_X86_IOPORT, to support configuring them out of the kernel
entirely.  Most current systems do not run programs using these
syscalls, so X86_IOPORT does not depend on EXPERT, though it does still
default to y.

In addition to saving a significant amount of space, this also reduces
the size of several major kernel data structures, drops a bit of code
from several task-related hot paths, and reduces the attack surface of
the kernel.

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
 arch/x86/Kconfig                      | 10 ++++++++++
 arch/x86/include/asm/paravirt.h       |  2 ++
 arch/x86/include/asm/paravirt_types.h |  4 ++++
 arch/x86/include/asm/processor.h      | 19 ++++++++++++++++++-
 arch/x86/include/asm/syscalls.h       |  3 +++
 arch/x86/kernel/Makefile              |  3 ++-
 arch/x86/kernel/entry_64.S            |  9 ++++++---
 arch/x86/kernel/process-io.h          | 10 ++++++++++
 arch/x86/kernel/ptrace.c              |  8 ++++++++
 drivers/tty/vt/vt_ioctl.c             |  2 +-
 kernel/sys_ni.c                       |  5 +++++
 11 files changed, 69 insertions(+), 6 deletions(-)

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
index 3caf2a8..a22a5d4 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -142,8 +142,12 @@ struct pv_cpu_ops {
 
 	void (*load_sp0)(struct tss_struct *tss, struct thread_struct *t);
 
+#ifdef CONFIG_X86_IOPORT
 	void (*set_iopl_mask)(unsigned mask);
 #define INIT_SET_IOPL_MASK(f) .set_iopl_mask = f,
+#else
+#define INIT_SET_IOPL_MASK(f)
+#endif
 
 	void (*wbinvd)(void);
 	void (*io_delay)(void);
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 1fa78f7..6e0b639 100644
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
@@ -288,6 +294,7 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss);
 
 static inline void init_tss_io(struct tss_struct *t)
 {
+#ifdef CONFIG_X86_IOPORT
 	int i;
 
 	t->x86_tss.io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
@@ -298,6 +305,9 @@ static inline void init_tss_io(struct tss_struct *t)
 	 */
 	for (i = 0; i <= IO_BITMAP_LONGS; i++)
 		t->io_bitmap[i] = ~0UL;
+#else
+	t->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
+#endif
 }
 
 /*
@@ -524,11 +534,13 @@ struct thread_struct {
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
@@ -545,7 +557,7 @@ struct thread_struct {
  */
 static inline void native_set_iopl_mask(unsigned mask)
 {
-#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86_IOPORT) && defined(CONFIG_X86_32)
 	unsigned int reg;
 
 	asm volatile ("pushfl;"
@@ -856,6 +868,7 @@ static inline void spin_lock_prefetch(const void *x)
 #define STACK_TOP		TASK_SIZE
 #define STACK_TOP_MAX		STACK_TOP
 
+#ifdef CONFIG_X86_IOPORT
 #define INIT_THREAD_IO .io_bitmap_ptr = NULL,
 
 /*
@@ -865,6 +878,10 @@ static inline void spin_lock_prefetch(const void *x)
  * be within the limit.
  */
 #define INIT_TSS_IO .io_bitmap = { [0 ... IO_BITMAP_LONGS] = ~0 },
+#else
+#define INIT_THREAD_IO
+#define INIT_TSS_IO
+#endif
 
 #define INIT_THREAD  {							  \
 	.sp0			= sizeof(init_stack) + (long)&init_stack, \
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
diff --git a/arch/x86/kernel/process-io.h b/arch/x86/kernel/process-io.h
index e48d5c9..3e773fa 100644
--- a/arch/x86/kernel/process-io.h
+++ b/arch/x86/kernel/process-io.h
@@ -3,12 +3,15 @@
 
 static inline void clear_thread_io_bitmap(struct task_struct *p)
 {
+#ifdef CONFIG_X86_IOPORT
 	p->thread.io_bitmap_ptr = NULL;
+#endif /* CONFIG_X86_IOPORT */
 }
 
 static inline int copy_io_bitmap(struct task_struct *me,
 				 struct task_struct *p)
 {
+#ifdef CONFIG_X86_IOPORT
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(me->thread.io_bitmap_ptr,
 						  IO_BITMAP_BYTES, GFP_KERNEL);
@@ -20,12 +23,14 @@ static inline int copy_io_bitmap(struct task_struct *me,
 	} else {
 		p->thread.io_bitmap_ptr = NULL;
 	}
+#endif /* CONFIG_X86_IOPORT */
 
 	return 0;
 }
 
 static inline void exit_thread_io(struct task_struct *me)
 {
+#ifdef CONFIG_X86_IOPORT
         struct thread_struct *t = &me->thread;
         unsigned long *bp = t->io_bitmap_ptr;
 
@@ -42,11 +47,13 @@ static inline void exit_thread_io(struct task_struct *me)
                 put_cpu();
                 kfree(bp);
         }
+#endif /* CONFIG_X86_IOPORT */
 }
 
 static inline void switch_iopl_mask(struct thread_struct *prev,
 				    struct thread_struct *next)
 {
+#ifdef CONFIG_X86_IOPORT
         /*
          * Restore IOPL if needed.  In normal use, the flags restore
          * in the switch assembly will handle this.  But if the kernel
@@ -55,12 +62,14 @@ static inline void switch_iopl_mask(struct thread_struct *prev,
          */
         if (get_kernel_rpl() && unlikely(prev->iopl != next->iopl))
                 set_iopl_mask(next->iopl);
+#endif /* CONFIG_X86_IOPORT */
 }
 
 static inline void switch_io_bitmap(struct tss_struct *tss,
 				    struct task_struct *prev_p,
 				    struct task_struct *next_p)
 {
+#ifdef CONFIG_X86_IOPORT
         struct thread_struct *prev, *next;
         prev = &prev_p->thread;
         next = &next_p->thread;
@@ -78,6 +87,7 @@ static inline void switch_io_bitmap(struct tss_struct *tss,
                  */
                 memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
         }
+#endif /* CONFIG_X86_IOPORT */
 }
 
 #endif /* _X86_KERNEL_PROCESS_IO_H */
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

