Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbaDPG5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 02:57:49 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:34067 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbaDPG5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 02:57:46 -0400
Date: Wed, 16 Apr 2014 08:57:38 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.15-rc2
Message-ID: <20140416085738.1d223db4@mschwide>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041606-6892-0000-0000-0000087B2733
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
An update to the oops output with additional information about the crash.
The renameat2 system call is enabled. Two patches in regard to the
PTR_ERR_OR_ZERO cleanup. And a bunch of bug fixes.

Duan Jiong (2):
      s390/sclp: replace PTR_RET with PTR_ERR_OR_ZERO
      s390/sclp_cmd: replace PTR_RET with PTR_ERR_OR_ZERO

Heiko Carstens (7):
      s390/smp: fix smp_stop_cpu() for !CONFIG_SMP
      s390/mm: print control registers and page table walk on crash
      s390: show_registers() should not map user space addresses to kernel symbols
      s390: wire up sys_renameat2
      s390: add 31 bit warning message
      s390/uaccess: fix possible register corruption in strnlen_user_srst()
      s390/compat: fix typo

Martin Schwidefsky (1):
      s390: fix control register update

Peter Oberparleiter (1):
      s390/sclp_vt220: Fix kernel panic due to early terminal input

 arch/s390/include/asm/sigp.h        |   19 +++++
 arch/s390/include/asm/smp.h         |   13 +++-
 arch/s390/include/uapi/asm/unistd.h |    3 +-
 arch/s390/kernel/compat_wrapper.c   |    3 +-
 arch/s390/kernel/dumpstack.c        |    8 +-
 arch/s390/kernel/ptrace.c           |    2 +-
 arch/s390/kernel/setup.c            |   32 ++++++++
 arch/s390/kernel/smp.c              |   15 ----
 arch/s390/kernel/syscalls.S         |    1 +
 arch/s390/lib/uaccess.c             |    5 +-
 arch/s390/mm/fault.c                |  140 +++++++++++++++++++++++++++++++++--
 drivers/s390/char/sclp.c            |    2 +-
 drivers/s390/char/sclp_cmd.c        |    2 +-
 drivers/s390/char/sclp_vt220.c      |   14 +++-
 14 files changed, 223 insertions(+), 36 deletions(-)

diff --git a/arch/s390/include/asm/sigp.h b/arch/s390/include/asm/sigp.h
index d091aa1..bf9c823 100644
--- a/arch/s390/include/asm/sigp.h
+++ b/arch/s390/include/asm/sigp.h
@@ -31,4 +31,23 @@
 #define SIGP_STATUS_INCORRECT_STATE	0x00000200UL
 #define SIGP_STATUS_NOT_RUNNING		0x00000400UL
 
+#ifndef __ASSEMBLY__
+
+static inline int __pcpu_sigp(u16 addr, u8 order, u32 parm, u32 *status)
+{
+	register unsigned int reg1 asm ("1") = parm;
+	int cc;
+
+	asm volatile(
+		"	sigp	%1,%2,0(%3)\n"
+		"	ipm	%0\n"
+		"	srl	%0,28\n"
+		: "=d" (cc), "+d" (reg1) : "d" (addr), "a" (order) : "cc");
+	if (status && cc == 1)
+		*status = reg1;
+	return cc;
+}
+
+#endif /* __ASSEMBLY__ */
+
 #endif /* __S390_ASM_SIGP_H */
diff --git a/arch/s390/include/asm/smp.h b/arch/s390/include/asm/smp.h
index 1607793..21703f8 100644
--- a/arch/s390/include/asm/smp.h
+++ b/arch/s390/include/asm/smp.h
@@ -7,6 +7,8 @@
 #ifndef __ASM_SMP_H
 #define __ASM_SMP_H
 
+#include <asm/sigp.h>
+
 #ifdef CONFIG_SMP
 
 #include <asm/lowcore.h>
@@ -50,9 +52,18 @@ static inline int smp_store_status(int cpu) { return 0; }
 static inline int smp_vcpu_scheduled(int cpu) { return 1; }
 static inline void smp_yield_cpu(int cpu) { }
 static inline void smp_yield(void) { }
-static inline void smp_stop_cpu(void) { }
 static inline void smp_fill_possible_mask(void) { }
 
+static inline void smp_stop_cpu(void)
+{
+	u16 pcpu = stap();
+
+	for (;;) {
+		__pcpu_sigp(pcpu, SIGP_STOP, 0, NULL);
+		cpu_relax();
+	}
+}
+
 #endif /* CONFIG_SMP */
 
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/arch/s390/include/uapi/asm/unistd.h b/arch/s390/include/uapi/asm/unistd.h
index 5eb5c9d..3802d2d 100644
--- a/arch/s390/include/uapi/asm/unistd.h
+++ b/arch/s390/include/uapi/asm/unistd.h
@@ -282,7 +282,8 @@
 #define __NR_finit_module	344
 #define __NR_sched_setattr	345
 #define __NR_sched_getattr	346
-#define NR_syscalls 345
+#define __NR_renameat2		347
+#define NR_syscalls 348
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff --git a/arch/s390/kernel/compat_wrapper.c b/arch/s390/kernel/compat_wrapper.c
index 824c39d..45cdb37 100644
--- a/arch/s390/kernel/compat_wrapper.c
+++ b/arch/s390/kernel/compat_wrapper.c
@@ -1,5 +1,5 @@
 /*
- *  Compat sytem call wrappers.
+ *  Compat system call wrappers.
  *
  *    Copyright IBM Corp. 2014
  */
@@ -213,3 +213,4 @@ COMPAT_SYSCALL_WRAP5(kcmp, pid_t, pid1, pid_t, pid2, int, type, unsigned long, i
 COMPAT_SYSCALL_WRAP3(finit_module, int, fd, const char __user *, uargs, int, flags);
 COMPAT_SYSCALL_WRAP3(sched_setattr, pid_t, pid, struct sched_attr __user *, attr, unsigned int, flags);
 COMPAT_SYSCALL_WRAP4(sched_getattr, pid_t, pid, struct sched_attr __user *, attr, unsigned int, size, unsigned int, flags);
+COMPAT_SYSCALL_WRAP5(renameat2, int, olddfd, const char __user *, oldname, int, newdfd, const char __user *, newname, unsigned int, flags);
diff --git a/arch/s390/kernel/dumpstack.c b/arch/s390/kernel/dumpstack.c
index e6af940..acb4124 100644
--- a/arch/s390/kernel/dumpstack.c
+++ b/arch/s390/kernel/dumpstack.c
@@ -144,10 +144,10 @@ void show_registers(struct pt_regs *regs)
 	char *mode;
 
 	mode = user_mode(regs) ? "User" : "Krnl";
-	printk("%s PSW : %p %p (%pSR)\n",
-	       mode, (void *) regs->psw.mask,
-	       (void *) regs->psw.addr,
-	       (void *) regs->psw.addr);
+	printk("%s PSW : %p %p", mode, (void *)regs->psw.mask, (void *)regs->psw.addr);
+	if (!user_mode(regs))
+		printk(" (%pSR)", (void *)regs->psw.addr);
+	printk("\n");
 	printk("           R:%x T:%x IO:%x EX:%x Key:%x M:%x W:%x "
 	       "P:%x AS:%x CC:%x PM:%x", mask_bits(regs, PSW_MASK_PER),
 	       mask_bits(regs, PSW_MASK_DAT), mask_bits(regs, PSW_MASK_IO),
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 4ac8faf..1c82619 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -64,7 +64,7 @@ void update_cr_regs(struct task_struct *task)
 		if (task->thread.per_flags & PER_FLAG_NO_TE)
 			cr_new &= ~(1UL << 55);
 		if (cr_new != cr)
-			__ctl_load(cr, 0, 0);
+			__ctl_load(cr_new, 0, 0);
 		/* Set or clear transaction execution TDC bits 62 and 63. */
 		__ctl_store(cr, 2, 2);
 		cr_new = cr & ~3UL;
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index f70f248..88d1ca8 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -1027,3 +1027,35 @@ void __init setup_arch(char **cmdline_p)
 	/* Setup zfcpdump support */
 	setup_zfcpdump();
 }
+
+#ifdef CONFIG_32BIT
+static int no_removal_warning __initdata;
+
+static int __init parse_no_removal_warning(char *str)
+{
+	no_removal_warning = 1;
+	return 0;
+}
+__setup("no_removal_warning", parse_no_removal_warning);
+
+static int __init removal_warning(void)
+{
+	if (no_removal_warning)
+		return 0;
+	printk(KERN_ALERT "\n\n");
+	printk(KERN_CONT "Warning - you are using a 31 bit kernel!\n\n");
+	printk(KERN_CONT "We plan to remove 31 bit kernel support from the kernel sources in March 2015.\n");
+	printk(KERN_CONT "Currently we assume that nobody is using the 31 bit kernel on old 31 bit\n");
+	printk(KERN_CONT "hardware anymore. If you think that the code should not be removed and also\n");
+	printk(KERN_CONT "future versions of the Linux kernel should be able to run in 31 bit mode\n");
+	printk(KERN_CONT "please let us know. Please write to:\n");
+	printk(KERN_CONT "linux390@de.ibm.com (mail address) and/or\n");
+	printk(KERN_CONT "linux-s390@vger.kernel.org (mailing list).\n\n");
+	printk(KERN_CONT "Thank you!\n\n");
+	printk(KERN_CONT "If this kernel runs on a 64 bit machine you may consider using a 64 bit kernel.\n");
+	printk(KERN_CONT "This message can be disabled with the \"no_removal_warning\" kernel parameter.\n");
+	schedule_timeout_uninterruptible(300 * HZ);
+	return 0;
+}
+early_initcall(removal_warning);
+#endif
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 512ce1c..86e65ec 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -82,21 +82,6 @@ DEFINE_MUTEX(smp_cpu_state_mutex);
 /*
  * Signal processor helper functions.
  */
-static inline int __pcpu_sigp(u16 addr, u8 order, u32 parm, u32 *status)
-{
-	register unsigned int reg1 asm ("1") = parm;
-	int cc;
-
-	asm volatile(
-		"	sigp	%1,%2,0(%3)\n"
-		"	ipm	%0\n"
-		"	srl	%0,28\n"
-		: "=d" (cc), "+d" (reg1) : "d" (addr), "a" (order) : "cc");
-	if (status && cc == 1)
-		*status = reg1;
-	return cc;
-}
-
 static inline int __pcpu_sigp_relax(u16 addr, u8 order, u32 parm, u32 *status)
 {
 	int cc;
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index 542ef48..fe5cdf2 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -355,3 +355,4 @@ SYSCALL(sys_kcmp,sys_kcmp,compat_sys_kcmp)
 SYSCALL(sys_finit_module,sys_finit_module,compat_sys_finit_module)
 SYSCALL(sys_sched_setattr,sys_sched_setattr,compat_sys_sched_setattr) /* 345 */
 SYSCALL(sys_sched_getattr,sys_sched_getattr,compat_sys_sched_getattr)
+SYSCALL(sys_renameat2,sys_renameat2,compat_sys_renameat2)
diff --git a/arch/s390/lib/uaccess.c b/arch/s390/lib/uaccess.c
index 23f866b..7416efe 100644
--- a/arch/s390/lib/uaccess.c
+++ b/arch/s390/lib/uaccess.c
@@ -338,9 +338,6 @@ static inline unsigned long strnlen_user_srst(const char __user *src,
 	register unsigned long reg0 asm("0") = 0;
 	unsigned long tmp1, tmp2;
 
-	if (unlikely(!size))
-		return 0;
-	update_primary_asce(current);
 	asm volatile(
 		"   la    %2,0(%1)\n"
 		"   la    %3,0(%0,%1)\n"
@@ -359,6 +356,8 @@ static inline unsigned long strnlen_user_srst(const char __user *src,
 
 unsigned long __strnlen_user(const char __user *src, unsigned long size)
 {
+	if (unlikely(!size))
+		return 0;
 	update_primary_asce(current);
 	return strnlen_user_srst(src, size);
 }
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 19f623f..2f51a99 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -126,6 +126,133 @@ static inline int user_space_fault(struct pt_regs *regs)
 	return 0;
 }
 
+static int bad_address(void *p)
+{
+	unsigned long dummy;
+
+	return probe_kernel_address((unsigned long *)p, dummy);
+}
+
+#ifdef CONFIG_64BIT
+static void dump_pagetable(unsigned long asce, unsigned long address)
+{
+	unsigned long *table = __va(asce & PAGE_MASK);
+
+	pr_alert("AS:%016lx ", asce);
+	switch (asce & _ASCE_TYPE_MASK) {
+	case _ASCE_TYPE_REGION1:
+		table = table + ((address >> 53) & 0x7ff);
+		if (bad_address(table))
+			goto bad;
+		pr_cont("R1:%016lx ", *table);
+		if (*table & _REGION_ENTRY_INVALID)
+			goto out;
+		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
+		/* fallthrough */
+	case _ASCE_TYPE_REGION2:
+		table = table + ((address >> 42) & 0x7ff);
+		if (bad_address(table))
+			goto bad;
+		pr_cont("R2:%016lx ", *table);
+		if (*table & _REGION_ENTRY_INVALID)
+			goto out;
+		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
+		/* fallthrough */
+	case _ASCE_TYPE_REGION3:
+		table = table + ((address >> 31) & 0x7ff);
+		if (bad_address(table))
+			goto bad;
+		pr_cont("R3:%016lx ", *table);
+		if (*table & (_REGION_ENTRY_INVALID | _REGION3_ENTRY_LARGE))
+			goto out;
+		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
+		/* fallthrough */
+	case _ASCE_TYPE_SEGMENT:
+		table = table + ((address >> 20) & 0x7ff);
+		if (bad_address(table))
+			goto bad;
+		pr_cont(KERN_CONT "S:%016lx ", *table);
+		if (*table & (_SEGMENT_ENTRY_INVALID | _SEGMENT_ENTRY_LARGE))
+			goto out;
+		table = (unsigned long *)(*table & _SEGMENT_ENTRY_ORIGIN);
+	}
+	table = table + ((address >> 12) & 0xff);
+	if (bad_address(table))
+		goto bad;
+	pr_cont("P:%016lx ", *table);
+out:
+	pr_cont("\n");
+	return;
+bad:
+	pr_cont("BAD\n");
+}
+
+#else /* CONFIG_64BIT */
+
+static void dump_pagetable(unsigned long asce, unsigned long address)
+{
+	unsigned long *table = __va(asce & PAGE_MASK);
+
+	pr_alert("AS:%08lx ", asce);
+	table = table + ((address >> 20) & 0x7ff);
+	if (bad_address(table))
+		goto bad;
+	pr_cont("S:%08lx ", *table);
+	if (*table & _SEGMENT_ENTRY_INVALID)
+		goto out;
+	table = (unsigned long *)(*table & _SEGMENT_ENTRY_ORIGIN);
+	table = table + ((address >> 12) & 0xff);
+	if (bad_address(table))
+		goto bad;
+	pr_cont("P:%08lx ", *table);
+out:
+	pr_cont("\n");
+	return;
+bad:
+	pr_cont("BAD\n");
+}
+
+#endif /* CONFIG_64BIT */
+
+static void dump_fault_info(struct pt_regs *regs)
+{
+	unsigned long asce;
+
+	pr_alert("Fault in ");
+	switch (regs->int_parm_long & 3) {
+	case 3:
+		pr_cont("home space ");
+		break;
+	case 2:
+		pr_cont("secondary space ");
+		break;
+	case 1:
+		pr_cont("access register ");
+		break;
+	case 0:
+		pr_cont("primary space ");
+		break;
+	}
+	pr_cont("mode while using ");
+	if (!user_space_fault(regs)) {
+		asce = S390_lowcore.kernel_asce;
+		pr_cont("kernel ");
+	}
+#ifdef CONFIG_PGSTE
+	else if ((current->flags & PF_VCPU) && S390_lowcore.gmap) {
+		struct gmap *gmap = (struct gmap *)S390_lowcore.gmap;
+		asce = gmap->asce;
+		pr_cont("gmap ");
+	}
+#endif
+	else {
+		asce = S390_lowcore.user_asce;
+		pr_cont("user ");
+	}
+	pr_cont("ASCE.\n");
+	dump_pagetable(asce, regs->int_parm_long & __FAIL_ADDR_MASK);
+}
+
 static inline void report_user_fault(struct pt_regs *regs, long signr)
 {
 	if ((task_pid_nr(current) > 1) && !show_unhandled_signals)
@@ -138,8 +265,9 @@ static inline void report_user_fault(struct pt_regs *regs, long signr)
 	       regs->int_code);
 	print_vma_addr(KERN_CONT "in ", regs->psw.addr & PSW_ADDR_INSN);
 	printk(KERN_CONT "\n");
-	printk(KERN_ALERT "failing address: %lX\n",
-	       regs->int_parm_long & __FAIL_ADDR_MASK);
+	printk(KERN_ALERT "failing address: %016lx TEID: %016lx\n",
+	       regs->int_parm_long & __FAIL_ADDR_MASK, regs->int_parm_long);
+	dump_fault_info(regs);
 	show_regs(regs);
 }
 
@@ -177,11 +305,13 @@ static noinline void do_no_context(struct pt_regs *regs)
 	address = regs->int_parm_long & __FAIL_ADDR_MASK;
 	if (!user_space_fault(regs))
 		printk(KERN_ALERT "Unable to handle kernel pointer dereference"
-		       " at virtual kernel address %p\n", (void *)address);
+		       " in virtual kernel address space\n");
 	else
 		printk(KERN_ALERT "Unable to handle kernel paging request"
-		       " at virtual user address %p\n", (void *)address);
-
+		       " in virtual user address space\n");
+	printk(KERN_ALERT "failing address: %016lx TEID: %016lx\n",
+	       regs->int_parm_long & __FAIL_ADDR_MASK, regs->int_parm_long);
+	dump_fault_info(regs);
 	die(regs, "Oops");
 	do_exit(SIGKILL);
 }
diff --git a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
index 1990285..c316051 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -1252,7 +1252,7 @@ static __init int sclp_initcall(void)
 		return rc;
 
 	sclp_pdev = platform_device_register_simple("sclp", -1, NULL, 0);
-	rc = PTR_RET(sclp_pdev);
+	rc = PTR_ERR_OR_ZERO(sclp_pdev);
 	if (rc)
 		goto fail_platform_driver_unregister;
 
diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index 6e8f90f..6e14999 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -515,7 +515,7 @@ static int __init sclp_detect_standby_memory(void)
 	if (rc)
 		goto out;
 	sclp_pdev = platform_device_register_simple("sclp_mem", -1, NULL, 0);
-	rc = PTR_RET(sclp_pdev);
+	rc = PTR_ERR_OR_ZERO(sclp_pdev);
 	if (rc)
 		goto out_driver;
 	sclp_add_standby_memory();
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index 4eed38c..cd9c919 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -97,13 +97,16 @@ static void sclp_vt220_pm_event_fn(struct sclp_register *reg,
 static int __sclp_vt220_emit(struct sclp_vt220_request *request);
 static void sclp_vt220_emit_current(void);
 
-/* Registration structure for our interest in SCLP event buffers */
+/* Registration structure for SCLP output event buffers */
 static struct sclp_register sclp_vt220_register = {
 	.send_mask		= EVTYP_VT220MSG_MASK,
+	.pm_event_fn		= sclp_vt220_pm_event_fn,
+};
+
+/* Registration structure for SCLP input event buffers */
+static struct sclp_register sclp_vt220_register_input = {
 	.receive_mask		= EVTYP_VT220MSG_MASK,
-	.state_change_fn	= NULL,
 	.receiver_fn		= sclp_vt220_receiver_fn,
-	.pm_event_fn		= sclp_vt220_pm_event_fn,
 };
 
 
@@ -715,9 +718,14 @@ static int __init sclp_vt220_tty_init(void)
 	rc = tty_register_driver(driver);
 	if (rc)
 		goto out_init;
+	rc = sclp_register(&sclp_vt220_register_input);
+	if (rc)
+		goto out_reg;
 	sclp_vt220_driver = driver;
 	return 0;
 
+out_reg:
+	tty_unregister_driver(driver);
 out_init:
 	__sclp_vt220_cleanup();
 out_driver:

