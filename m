Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaCaVG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 17:06:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48908 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaCaVGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 17:06:24 -0400
Date: Mon, 31 Mar 2014 14:05:10 -0700
Message-Id: <201403312105.s2VL5AqX010173@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 LTO changes for v3.15
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: ak@linux.intel.com, gleb@redhat.com, hpa@linux.intel.com, hpa@zytor.com,
        hubicka@ucw.cz, linux-kernel@vger.kernel.org, mingo@kernel.org,
        pbonzini@redhat.com, perex@perex.cz, peterz@infradead.org,
        rostedt@goodmis.org, rusty@rustcorp.com.au, tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

More infrastructure work in preparation for link-time optimization
(LTO).  Most of these changes is to make sure symbols accessed from
assembly code are properly marked as visible so the linker doesn't
remove them.

My understanding is that the changes to support LTO are still not
upstream in binutils, but are on the way there.  This patchset should
conclude the x86-specific changes, and remaining patches to actually
enable LTO will be fed through the Kbuild tree (other than keeping up
with changes to the x86 code base, of course), although not
necessarily in this merge window.

The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-asmlinkage-for-linus

for you to fetch changes up to ef178f9238b142cc1020265e176b20d27fd02ba9:

  Kbuild, lto: Handle basic LTO in modpost (2014-02-13 20:25:05 -0800)

----------------------------------------------------------------
Andi Kleen (24):
      asmlinkage, kvm: Make kvm_rebooting visible
      asmlinkage: Make __iowrite32_copy visible
      asmlinkage: Make jiffies visible
      asmlinkage, pnp: Make variables used from assembler code visible
      asmlinkage: Make lockdep_sys_exit asmlinkage
      asmlinkage: Make trace_hardirq visible
      asmlinkage, mutex: Mark __visible
      asmlinkage: Make main_extable_sort_needed visible
      asmlinkage: Mark rwsem functions that can be called from assembler asmlinkage
      asmlinkage Make __stack_chk_failed and memcmp visible
      asmlinkage, x86: Fix 32bit memcpy for LTO
      asmlinkage: Make trace_hardirqs_on/off_caller visible
      initconst: Fix initconst mistake in dcdbas
      initconst, x86: Fix initconst mistake in ts5500 code
      x86, lto: Disable LTO for the x86 VDSO
      lto: Make asmlinkage __visible
      lto, workaround: Add workaround for initcall reordering
      lto: Disable LTO for sys_ni
      Kbuild, lto, workaround: Don't warn for initcall_reference in modpost
      Kbuild, lto: Drop .number postfixes in modpost
      Kbuild, lto: add ld-version and ld-ifversion macros
      Kbuild, lto: Add a gcc-ld script to let run gcc as ld
      Kbuild, lto: Disable LTO for asm-offsets.c
      Kbuild, lto: Handle basic LTO in modpost

Joe Mario (1):
      lto: Handle LTO common symbols in module loader

 arch/x86/kernel/time.c            |  2 +-
 arch/x86/lib/memcpy_32.c          |  6 +++---
 arch/x86/platform/ts5500/ts5500.c |  2 +-
 arch/x86/vdso/Makefile            | 10 +++++++---
 drivers/firmware/dcdbas.c         |  2 +-
 drivers/pnp/pnpbios/bioscalls.c   |  9 +++++----
 include/linux/init.h              | 20 +++++++++++++++++++-
 include/linux/io.h                |  2 +-
 include/linux/linkage.h           |  4 ++--
 include/linux/lockdep.h           |  2 +-
 kernel/Makefile                   |  3 +++
 kernel/extable.c                  |  2 +-
 kernel/locking/lockdep.c          |  6 +++---
 kernel/locking/mutex.c            | 10 +++++-----
 kernel/locking/rwsem-xadd.c       |  4 ++++
 kernel/module.c                   |  4 ++++
 kernel/panic.c                    |  2 +-
 kernel/timer.c                    |  2 +-
 kernel/trace/trace_irqsoff.c      |  4 ++--
 lib/string.c                      |  2 +-
 scripts/Kbuild.include            |  9 +++++++++
 scripts/Makefile.build            |  2 +-
 scripts/gcc-ld                    | 29 +++++++++++++++++++++++++++++
 scripts/ld-version.sh             |  8 ++++++++
 scripts/mod/modpost.c             | 25 +++++++++++++++++++++++--
 scripts/mod/modpost.h             |  2 +-
 virt/kvm/kvm_main.c               |  2 +-
 27 files changed, 138 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 24d3c91..6ec91c0 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -23,7 +23,7 @@
 #include <asm/time.h>
 
 #ifdef CONFIG_X86_64
-DEFINE_VVAR(volatile unsigned long, jiffies) = INITIAL_JIFFIES;
+__visible DEFINE_VVAR(volatile unsigned long, jiffies) = INITIAL_JIFFIES;
 #endif
 
 unsigned long profile_pc(struct pt_regs *regs)
diff --git a/arch/x86/lib/memcpy_32.c b/arch/x86/lib/memcpy_32.c
index e78761d..a404b4b 100644
--- a/arch/x86/lib/memcpy_32.c
+++ b/arch/x86/lib/memcpy_32.c
@@ -4,7 +4,7 @@
 #undef memcpy
 #undef memset
 
-void *memcpy(void *to, const void *from, size_t n)
+__visible void *memcpy(void *to, const void *from, size_t n)
 {
 #ifdef CONFIG_X86_USE_3DNOW
 	return __memcpy3d(to, from, n);
@@ -14,13 +14,13 @@ void *memcpy(void *to, const void *from, size_t n)
 }
 EXPORT_SYMBOL(memcpy);
 
-void *memset(void *s, int c, size_t count)
+__visible void *memset(void *s, int c, size_t count)
 {
 	return __memset(s, c, count);
 }
 EXPORT_SYMBOL(memset);
 
-void *memmove(void *dest, const void *src, size_t n)
+__visible void *memmove(void *dest, const void *src, size_t n)
 {
 	int d0,d1,d2,d3,d4,d5;
 	char *ret = dest;
diff --git a/arch/x86/platform/ts5500/ts5500.c b/arch/x86/platform/ts5500/ts5500.c
index 39febb2..9471b94 100644
--- a/arch/x86/platform/ts5500/ts5500.c
+++ b/arch/x86/platform/ts5500/ts5500.c
@@ -88,7 +88,7 @@ struct ts5500_sbc {
 static const struct {
 	const char * const string;
 	const ssize_t offset;
-} ts5500_signatures[] __initdata = {
+} ts5500_signatures[] __initconst = {
 	{ "TS-5x00 AMD Elan", 0xb14 },
 };
 
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index fd14be1..9206ac7 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -2,6 +2,8 @@
 # Building vDSO images for x86.
 #
 
+KBUILD_CFLAGS += $(DISABLE_LTO)
+
 VDSO64-$(CONFIG_X86_64)		:= y
 VDSOX32-$(CONFIG_X86_X32_ABI)	:= y
 VDSO32-$(CONFIG_X86_32)		:= y
@@ -35,7 +37,8 @@ export CPPFLAGS_vdso.lds += -P -C
 
 VDSO_LDFLAGS_vdso.lds = -m64 -Wl,-soname=linux-vdso.so.1 \
 			-Wl,--no-undefined \
-		      	-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
+			-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096 \
+			$(DISABLE_LTO)
 
 $(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
 
@@ -127,7 +130,7 @@ vdso32.so-$(VDSO32-y)		+= sysenter
 vdso32-images			= $(vdso32.so-y:%=vdso32-%.so)
 
 CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
-VDSO_LDFLAGS_vdso32.lds = -m32 -Wl,-soname=linux-gate.so.1
+VDSO_LDFLAGS_vdso32.lds = -m32 -Wl,-m,elf_i386 -Wl,-soname=linux-gate.so.1
 
 # This makes sure the $(obj) subdirectory exists even though vdso32/
 # is not a kbuild sub-make subdirectory.
@@ -181,7 +184,8 @@ quiet_cmd_vdso = VDSO    $@
 		       -Wl,-T,$(filter %.lds,$^) $(filter %.o,$^) && \
 		 sh $(srctree)/$(src)/checkundef.sh '$(NM)' '$@'
 
-VDSO_LDFLAGS = -fPIC -shared $(call cc-ldoption, -Wl$(comma)--hash-style=sysv)
+VDSO_LDFLAGS = -fPIC -shared $(call cc-ldoption, -Wl$(comma)--hash-style=sysv) \
+		$(LTO_CFLAGS)
 GCOV_PROFILE := n
 
 #
diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 1b5e8e4..7160c43 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -584,7 +584,7 @@ static struct platform_driver dcdbas_driver = {
 	.remove		= dcdbas_remove,
 };
 
-static const struct platform_device_info dcdbas_dev_info __initdata = {
+static const struct platform_device_info dcdbas_dev_info __initconst = {
 	.name		= DRIVER_NAME,
 	.id		= -1,
 	.dma_mask	= DMA_BIT_MASK(32),
diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index 769d265..deb7f4b 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -21,7 +21,7 @@
 
 #include "pnpbios.h"
 
-static struct {
+__visible struct {
 	u16 offset;
 	u16 segment;
 } pnp_bios_callpoint;
@@ -41,6 +41,7 @@ asmlinkage void pnp_bios_callfunc(void);
 
 __asm__(".text			\n"
 	__ALIGN_STR "\n"
+	".globl pnp_bios_callfunc\n"
 	"pnp_bios_callfunc:\n"
 	"	pushl %edx	\n"
 	"	pushl %ecx	\n"
@@ -66,9 +67,9 @@ static struct desc_struct bad_bios_desc = GDT_ENTRY_INIT(0x4092,
  * after PnP BIOS oopses.
  */
 
-u32 pnp_bios_fault_esp;
-u32 pnp_bios_fault_eip;
-u32 pnp_bios_is_utter_crap = 0;
+__visible u32 pnp_bios_fault_esp;
+__visible u32 pnp_bios_fault_eip;
+__visible u32 pnp_bios_is_utter_crap = 0;
 
 static spinlock_t pnp_bios_lock;
 
diff --git a/include/linux/init.h b/include/linux/init.h
index e168880..a3ba270 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -163,6 +163,23 @@ extern bool initcall_debug;
 
 #ifndef __ASSEMBLY__
 
+#ifdef CONFIG_LTO
+/* Work around a LTO gcc problem: when there is no reference to a variable
+ * in a module it will be moved to the end of the program. This causes
+ * reordering of initcalls which the kernel does not like.
+ * Add a dummy reference function to avoid this. The function is
+ * deleted by the linker.
+ */
+#define LTO_REFERENCE_INITCALL(x) \
+	; /* yes this is needed */			\
+	static __used __exit void *reference_##x(void)	\
+	{						\
+		return &x;				\
+	}
+#else
+#define LTO_REFERENCE_INITCALL(x)
+#endif
+
 /* initcalls are now grouped by functionality into separate 
  * subsections. Ordering inside the subsections is determined
  * by link order. 
@@ -175,7 +192,8 @@ extern bool initcall_debug;
 
 #define __define_initcall(fn, id) \
 	static initcall_t __initcall_##fn##id __used \
-	__attribute__((__section__(".initcall" #id ".init"))) = fn
+	__attribute__((__section__(".initcall" #id ".init"))) = fn; \
+	LTO_REFERENCE_INITCALL(__initcall_##fn##id)
 
 /*
  * Early initcalls run before initializing SMP.
diff --git a/include/linux/io.h b/include/linux/io.h
index f4f42fa..8a18e75 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -24,7 +24,7 @@
 
 struct device;
 
-void __iowrite32_copy(void __iomem *to, const void *from, size_t count);
+__visible void __iowrite32_copy(void __iomem *to, const void *from, size_t count);
 void __iowrite64_copy(void __iomem *to, const void *from, size_t count);
 
 #ifdef CONFIG_MMU
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index a6a42dd..34a513a 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -12,9 +12,9 @@
 #endif
 
 #ifdef __cplusplus
-#define CPP_ASMLINKAGE extern "C"
+#define CPP_ASMLINKAGE extern "C" __visible
 #else
-#define CPP_ASMLINKAGE
+#define CPP_ASMLINKAGE __visible
 #endif
 
 #ifndef asmlinkage
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 92b1bfc..7df9aa6 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -265,7 +265,7 @@ extern void lockdep_info(void);
 extern void lockdep_reset(void);
 extern void lockdep_reset_lock(struct lockdep_map *lock);
 extern void lockdep_free_key_range(void *start, unsigned long size);
-extern void lockdep_sys_exit(void);
+extern asmlinkage void lockdep_sys_exit(void);
 
 extern void lockdep_off(void);
 extern void lockdep_on(void);
diff --git a/kernel/Makefile b/kernel/Makefile
index bc010ee..31c26c6 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -18,6 +18,9 @@ CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_irq_work.o = -pg
 endif
 
+# cond_syscall is currently not LTO compatible
+CFLAGS_sys_ni.o = $(DISABLE_LTO)
+
 obj-y += sched/
 obj-y += locking/
 obj-y += power/
diff --git a/kernel/extable.c b/kernel/extable.c
index 763faf0..d8a6446 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -36,7 +36,7 @@ extern struct exception_table_entry __start___ex_table[];
 extern struct exception_table_entry __stop___ex_table[];
 
 /* Cleared by build time tools if the table is already sorted. */
-u32 __initdata main_extable_sort_needed = 1;
+u32 __initdata __visible main_extable_sort_needed = 1;
 
 /* Sort the kernel's built-in exception table */
 void __init sort_main_extable(void)
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index eb8a547..aa3bf15 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -2557,7 +2557,7 @@ static void __trace_hardirqs_on_caller(unsigned long ip)
 	debug_atomic_inc(hardirqs_on_events);
 }
 
-void trace_hardirqs_on_caller(unsigned long ip)
+__visible void trace_hardirqs_on_caller(unsigned long ip)
 {
 	time_hardirqs_on(CALLER_ADDR0, ip);
 
@@ -2610,7 +2610,7 @@ EXPORT_SYMBOL(trace_hardirqs_on);
 /*
  * Hardirqs were disabled:
  */
-void trace_hardirqs_off_caller(unsigned long ip)
+__visible void trace_hardirqs_off_caller(unsigned long ip)
 {
 	struct task_struct *curr = current;
 
@@ -4191,7 +4191,7 @@ void debug_show_held_locks(struct task_struct *task)
 }
 EXPORT_SYMBOL_GPL(debug_show_held_locks);
 
-void lockdep_sys_exit(void)
+asmlinkage void lockdep_sys_exit(void)
 {
 	struct task_struct *curr = current;
 
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 4dd6e4c..adbc0d0 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -67,8 +67,7 @@ EXPORT_SYMBOL(__mutex_init);
  * We also put the fastpath first in the kernel image, to make sure the
  * branch is predicted by the CPU as default-untaken.
  */
-static __used noinline void __sched
-__mutex_lock_slowpath(atomic_t *lock_count);
+__visible void __sched __mutex_lock_slowpath(atomic_t *lock_count);
 
 /**
  * mutex_lock - acquire the mutex
@@ -225,7 +224,8 @@ static inline int mutex_can_spin_on_owner(struct mutex *lock)
 }
 #endif
 
-static __used noinline void __sched __mutex_unlock_slowpath(atomic_t *lock_count);
+__visible __used noinline
+void __sched __mutex_unlock_slowpath(atomic_t *lock_count);
 
 /**
  * mutex_unlock - release the mutex
@@ -746,7 +746,7 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 /*
  * Release the lock, slowpath:
  */
-static __used noinline void
+__visible void
 __mutex_unlock_slowpath(atomic_t *lock_count)
 {
 	__mutex_unlock_common_slowpath(lock_count, 1);
@@ -803,7 +803,7 @@ int __sched mutex_lock_killable(struct mutex *lock)
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
-static __used noinline void __sched
+__visible void __sched
 __mutex_lock_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 19c5fa9..1d66e08 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -143,6 +143,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
 /*
  * wait for the read lock to be granted
  */
+__visible
 struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 {
 	long count, adjustment = -RWSEM_ACTIVE_READ_BIAS;
@@ -190,6 +191,7 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 /*
  * wait until we successfully acquire the write lock
  */
+__visible
 struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 {
 	long count, adjustment = -RWSEM_ACTIVE_WRITE_BIAS;
@@ -252,6 +254,7 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
  * handle waking up a waiter on the semaphore
  * - up_read/up_write has decremented the active part of count if we come here
  */
+__visible
 struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
@@ -272,6 +275,7 @@ struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
  * - caller incremented waiting part of count and discovered it still negative
  * - just wake up any readers at the front of the queue
  */
+__visible
 struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
diff --git a/kernel/module.c b/kernel/module.c
index d24fcf2..b99e801 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1948,6 +1948,10 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 
 		switch (sym[i].st_shndx) {
 		case SHN_COMMON:
+			/* Ignore common symbols */
+			if (!strncmp(name, "__gnu_lto", 9))
+				break;
+
 			/* We compiled with -fno-common.  These are not
 			   supposed to happen.  */
 			pr_debug("Common symbol: %s\n", name);
diff --git a/kernel/panic.c b/kernel/panic.c
index 6d63003..3eb0ffb 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -459,7 +459,7 @@ EXPORT_SYMBOL(warn_slowpath_null);
  * Called when gcc's -fstack-protector feature is used, and
  * gcc detects corruption of the on-stack canary value
  */
-void __stack_chk_fail(void)
+__visible void __stack_chk_fail(void)
 {
 	panic("stack-protector: Kernel stack is corrupted in: %p\n",
 		__builtin_return_address(0));
diff --git a/kernel/timer.c b/kernel/timer.c
index accfd24..d78de04 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -52,7 +52,7 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/timer.h>
 
-u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
+__visible u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
 
 EXPORT_SYMBOL(jiffies_64);
 
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 2aefbee..887ef88 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -498,14 +498,14 @@ void trace_hardirqs_off(void)
 }
 EXPORT_SYMBOL(trace_hardirqs_off);
 
-void trace_hardirqs_on_caller(unsigned long caller_addr)
+__visible void trace_hardirqs_on_caller(unsigned long caller_addr)
 {
 	if (!preempt_trace() && irq_trace())
 		stop_critical_timing(CALLER_ADDR0, caller_addr);
 }
 EXPORT_SYMBOL(trace_hardirqs_on_caller);
 
-void trace_hardirqs_off_caller(unsigned long caller_addr)
+__visible void trace_hardirqs_off_caller(unsigned long caller_addr)
 {
 	if (!preempt_trace() && irq_trace())
 		start_critical_timing(CALLER_ADDR0, caller_addr);
diff --git a/lib/string.c b/lib/string.c
index e5878de..9b1f906 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -648,7 +648,7 @@ EXPORT_SYMBOL(memmove);
  * @count: The size of the area.
  */
 #undef memcmp
-int memcmp(const void *cs, const void *ct, size_t count)
+__visible int memcmp(const void *cs, const void *ct, size_t count)
 {
 	const unsigned char *su1, *su2;
 	int res = 0;
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 547e15d..93a0da2 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -155,6 +155,15 @@ ld-option = $(call try-run,\
 # Important: no spaces around options
 ar-option = $(call try-run, $(AR) rc$(1) "$$TMP",$(1),$(2))
 
+# ld-version
+# Usage: $(call ld-version)
+# Note this is mainly for HJ Lu's 3 number binutil versions
+ld-version = $(shell $(LD) --version | $(srctree)/scripts/ld-version.sh)
+
+# ld-ifversion
+# Usage:  $(call ld-ifversion, -ge, 22252, y)
+ld-ifversion = $(shell [ $(call ld-version) $(1) $(2) ] && echo $(3))
+
 ######
 
 ###
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d5d859c..9f0ee22 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -198,7 +198,7 @@ $(multi-objs-y:.o=.s)   : modname = $(modname-multi)
 $(multi-objs-y:.o=.lst) : modname = $(modname-multi)
 
 quiet_cmd_cc_s_c = CC $(quiet_modtag)  $@
-cmd_cc_s_c       = $(CC) $(c_flags) -fverbose-asm -S -o $@ $<
+cmd_cc_s_c       = $(CC) $(c_flags) $(DISABLE_LTO) -fverbose-asm -S -o $@ $<
 
 $(obj)/%.s: $(src)/%.c FORCE
 	$(call if_changed_dep,cc_s_c)
diff --git a/scripts/gcc-ld b/scripts/gcc-ld
new file mode 100644
index 0000000..cadab9a
--- /dev/null
+++ b/scripts/gcc-ld
@@ -0,0 +1,29 @@
+#!/bin/sh
+# run gcc with ld options
+# used as a wrapper to execute link time optimizations
+# yes virginia, this is not pretty
+
+ARGS="-nostdlib"
+
+while [ "$1" != "" ] ; do
+	case "$1" in
+	-save-temps|-m32|-m64) N="$1" ;;
+	-r) N="$1" ;;
+	-[Wg]*) N="$1" ;;
+	-[olv]|-[Ofd]*|-nostdlib) N="$1" ;;
+	--end-group|--start-group)
+		 N="-Wl,$1" ;;
+	-[RTFGhIezcbyYu]*|\
+--script|--defsym|-init|-Map|--oformat|-rpath|\
+-rpath-link|--sort-section|--section-start|-Tbss|-Tdata|-Ttext|\
+--version-script|--dynamic-list|--version-exports-symbol|--wrap|-m)
+		A="$1" ; shift ; N="-Wl,$A,$1" ;;
+	-[m]*) N="$1" ;;
+	-*) N="-Wl,$1" ;;
+	*)  N="$1" ;;
+	esac
+	ARGS="$ARGS $N"
+	shift
+done
+
+exec $CC $ARGS
diff --git a/scripts/ld-version.sh b/scripts/ld-version.sh
new file mode 100755
index 0000000..198580d
--- /dev/null
+++ b/scripts/ld-version.sh
@@ -0,0 +1,8 @@
+#!/usr/bin/awk -f
+# extract linker version number from stdin and turn into single number
+	{
+	gsub(".*)", "");
+	split($1,a, ".");
+	print a[1]*10000000 + a[2]*100000 + a[3]*10000 + a[4]*100 + a[5];
+	exit
+	}
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 4061098..63804a1 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -623,7 +623,10 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
 
 	switch (sym->st_shndx) {
 	case SHN_COMMON:
-		warn("\"%s\" [%s] is COMMON symbol\n", symname, mod->name);
+		if (!strncmp(symname, "__gnu_lto_", sizeof("__gnu_lto_")-1)) {
+			/* Should warn here, but modpost runs before the linker */
+		} else
+			warn("\"%s\" [%s] is COMMON symbol\n", symname, mod->name);
 		break;
 	case SHN_UNDEF:
 		/* undefined symbol */
@@ -849,6 +852,7 @@ static const char *section_white_list[] =
 	".xt.lit",         /* xtensa */
 	".arcextmap*",			/* arc */
 	".gnu.linkonce.arcext*",	/* arc : modules */
+	".gnu.lto*",
 	NULL
 };
 
@@ -1455,6 +1459,10 @@ static void check_section_mismatch(const char *modname, struct elf_info *elf,
 		to = find_elf_symbol(elf, r->r_addend, sym);
 		tosym = sym_name(elf, to);
 
+		if (!strncmp(fromsym, "reference___initcall",
+				sizeof("reference___initcall")-1))
+			return;
+
 		/* check whitelist - we may ignore it */
 		if (secref_whitelist(mismatch,
 					fromsec, fromsym, tosec, tosym)) {
@@ -1680,6 +1688,19 @@ static void check_sec_ref(struct module *mod, const char *modname,
 	}
 }
 
+static char *remove_dot(char *s)
+{
+	char *end;
+	int n = strcspn(s, ".");
+
+	if (n > 0 && s[n] != 0) {
+		strtoul(s + n + 1, &end, 10);
+		if  (end > s + n + 1 && (*end == '.' || *end == 0))
+			s[n] = 0;
+	}
+	return s;
+}
+
 static void read_symbols(char *modname)
 {
 	const char *symname;
@@ -1718,7 +1739,7 @@ static void read_symbols(char *modname)
 	}
 
 	for (sym = info.symtab_start; sym < info.symtab_stop; sym++) {
-		symname = info.strtab + sym->st_name;
+		symname = remove_dot(info.strtab + sym->st_name);
 
 		handle_modversions(mod, &info, sym, symname);
 		handle_moddevtable(mod, &info, sym, symname);
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 51207e4..168b43d 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -127,7 +127,7 @@ struct elf_info {
 	Elf_Section  export_gpl_sec;
 	Elf_Section  export_unused_gpl_sec;
 	Elf_Section  export_gpl_future_sec;
-	const char   *strtab;
+	char         *strtab;
 	char	     *modinfo;
 	unsigned int modinfo_len;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 03a0381..b5ec7fb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -102,7 +102,7 @@ static void kvm_release_pfn_dirty(pfn_t pfn);
 static void mark_page_dirty_in_slot(struct kvm *kvm,
 				    struct kvm_memory_slot *memslot, gfn_t gfn);
 
-bool kvm_rebooting;
+__visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
 
 static bool largepages_enabled = true;
