Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3GWAcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 20:32:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33744 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751589Ab3GWAcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 20:32:45 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [trivial PATCH 1/2] treewide: Convert print_symbol uses to %pSR
Date: Mon, 22 Jul 2013 17:32:40 -0700
Message-Id: <5cafe992f6a42500e82433880a8500f0cd67cf72.1374539434.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the vsprintf pointer extension to emit the addresses symbol name.

Signed-off-by: Joe Perches <joe@perches.com>
---
 Documentation/filesystems/sysfs.txt                |  4 ++--
 Documentation/zh_CN/filesystems/sysfs.txt          |  4 ++--
 arch/alpha/kernel/traps.c                          |  8 +++----
 arch/arc/kernel/stacktrace.c                       |  2 +-
 arch/arm/kernel/process.c                          |  5 +++--
 arch/arm64/kernel/process.c                        |  5 +++--
 arch/avr32/kernel/process.c                        | 25 ++++++---------------
 arch/c6x/kernel/traps.c                            |  3 +--
 arch/ia64/kernel/process.c                         | 13 +++++------
 arch/mn10300/kernel/traps.c                        |  8 +++----
 arch/openrisc/kernel/traps.c                       |  7 ++----
 arch/s390/kernel/dumpstack.c                       | 26 +++++++++++++---------
 arch/sh/kernel/process_32.c                        |  4 ++--
 arch/um/kernel/sysrq.c                             |  6 ++---
 arch/unicore32/kernel/process.c                    |  5 +++--
 arch/x86/kernel/cpu/mcheck/mce.c                   | 13 ++++++-----
 arch/x86/kernel/dumpstack.c                        |  5 ++---
 arch/x86/kernel/head_64.S                          |  4 ++--
 arch/x86/kernel/process_32.c                       |  2 +-
 arch/x86/mm/mmio-mod.c                             |  4 ++--
 arch/x86/um/sysrq_32.c                             |  9 +++-----
 arch/xtensa/kernel/traps.c                         |  7 +++---
 drivers/base/core.c                                |  4 ++--
 .../lustre/lustre/libcfs/linux/linux-debug.c       |  4 +---
 fs/sysfs/file.c                                    |  4 ++--
 kernel/irq/debug.h                                 | 15 ++++++-------
 lib/smp_processor_id.c                             |  2 +-
 27 files changed, 88 insertions(+), 110 deletions(-)

diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index a6619b7..9cc7742 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -154,8 +154,8 @@ static ssize_t dev_attr_show(struct kobject *kobj, struct attribute *attr,
         if (dev_attr->show)
                 ret = dev_attr->show(dev, dev_attr, buf);
         if (ret >= (ssize_t)PAGE_SIZE) {
-                print_symbol("dev_attr_show: %s returned bad count\n",
-                                (unsigned long)dev_attr->show);
+                printk("dev_attr_show: %pSR returned bad count\n",
+                       dev_attr->show);
         }
         return ret;
 }
diff --git a/Documentation/zh_CN/filesystems/sysfs.txt b/Documentation/zh_CN/filesystems/sysfs.txt
index e230eaa..42fc023 100644
--- a/Documentation/zh_CN/filesystems/sysfs.txt
+++ b/Documentation/zh_CN/filesystems/sysfs.txt
@@ -167,8 +167,8 @@ static ssize_t dev_attr_show(struct kobject *kobj, struct attribute *attr,
         if (dev_attr->show)
                 ret = dev_attr->show(dev, dev_attr, buf);
         if (ret >= (ssize_t)PAGE_SIZE) {
-                print_symbol("dev_attr_show: %s returned bad count\n",
-                                (unsigned long)dev_attr->show);
+                printk("dev_attr_show: %pSR returned bad count\n",
+                       dev_attr->show);
         }
         return ret;
 }
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index be1fba3..8331d51 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -66,8 +66,8 @@ dik_show_regs(struct pt_regs *regs, unsigned long *r9_15)
 {
 	printk("pc = [<%016lx>]  ra = [<%016lx>]  ps = %04lx    %s\n",
 	       regs->pc, regs->r26, regs->ps, print_tainted());
-	print_symbol("pc is at %s\n", regs->pc);
-	print_symbol("ra is at %s\n", regs->r26 );
+	printk("pc is at %pSR\n", (void *)(unsigned long)regs->pc);
+	printk("ra is at %pSR\n", (void *)(unsigned long)regs->r26);
 	printk("v0 = %016lx  t0 = %016lx  t1 = %016lx\n",
 	       regs->r0, regs->r1, regs->r2);
 	printk("t2 = %016lx  t3 = %016lx  t4 = %016lx\n",
@@ -132,9 +132,7 @@ dik_show_trace(unsigned long *sp)
 			continue;
 		if (tmp >= (unsigned long) &_etext)
 			continue;
-		printk("[<%lx>]", tmp);
-		print_symbol(" %s", tmp);
-		printk("\n");
+		printk("[<%lx>] %pSR\n", tmp, (void *)tmp);
 		if (i > 40) {
 			printk(" ...");
 			break;
diff --git a/arch/arc/kernel/stacktrace.c b/arch/arc/kernel/stacktrace.c
index f8b7d88..60d878c 100644
--- a/arch/arc/kernel/stacktrace.c
+++ b/arch/arc/kernel/stacktrace.c
@@ -150,7 +150,7 @@ arc_unwind_core(struct task_struct *tsk, struct pt_regs *regs,
  */
 static int __print_sym(unsigned int address, void *unused)
 {
-	__print_symbol("  %s\n", address);
+	printk("  %pSR\n", (void *)(unsigned long)address);
 	return 0;
 }
 
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index d3ca4f6..e10a927 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -250,8 +250,9 @@ void __show_regs(struct pt_regs *regs)
 
 	show_regs_print_info(KERN_DEFAULT);
 
-	print_symbol("PC is at %s\n", instruction_pointer(regs));
-	print_symbol("LR is at %s\n", regs->ARM_lr);
+	printk("PC is at %pSR\n",
+	       (void *)(unsigned long)instruction_pointer(regs));
+	printk("LR is at %pSR\n", (void *)(unsigned long)(regs->ARM_lr));
 	printk("pc : [<%08lx>]    lr : [<%08lx>]    psr: %08lx\n"
 	       "sp : %08lx  ip : %08lx  fp : %08lx\n",
 		regs->ARM_pc, regs->ARM_lr, regs->ARM_cpsr,
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 1788bf6..338c849 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -146,8 +146,9 @@ void __show_regs(struct pt_regs *regs)
 	int i;
 
 	show_regs_print_info(KERN_DEFAULT);
-	print_symbol("PC is at %s\n", instruction_pointer(regs));
-	print_symbol("LR is at %s\n", regs->regs[30]);
+	printk("PC is at %pSR\n",
+	       (void *)(unsigned long)instruction_pointer(regs));
+	printk("LR is at %pSR\n", (void *)(unsigned long)(regs->regs[30]));
 	printk("pc : [<%016llx>] lr : [<%016llx>] pstate: %08llx\n",
 	       regs->pc, regs->regs[30], regs->pstate);
 	printk("sp : %016llx\n", regs->sp);
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index c273100..5a53b58 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -139,12 +139,7 @@ static void show_trace_log_lvl(struct task_struct *tsk, unsigned long *sp,
 		unsigned long new_fp;
 
 		lr = *(unsigned long *)fp;
-#ifdef CONFIG_KALLSYMS
-		printk("%s [<%08lx>] ", log_lvl, lr);
-#else
-		printk(" [<%08lx>] ", lr);
-#endif
-		print_symbol("%s\n", lr);
+		printk("%s [<%08lx>] %pSR\n", log_lvl, lr, (void *)lr);
 
 		new_fp = *(unsigned long *)(fp + 4);
 		if (new_fp <= fp)
@@ -163,14 +158,9 @@ static void show_trace_log_lvl(struct task_struct *tsk, unsigned long *sp,
 
 	while (!kstack_end(sp)) {
 		addr = *sp++;
-		if (kernel_text_address(addr)) {
-#ifdef CONFIG_KALLSYMS
-			printk("%s [<%08lx>] ", log_lvl, addr);
-#else
-			printk(" [<%08lx>] ", addr);
-#endif
-			print_symbol("%s\n", addr);
-		}
+		if (kernel_text_address(addr))
+			printk("%s [<%08lx>] %pSR\n",
+			       log_lvl, addr, (void *)addr);
 	}
 	printk("\n");
 }
@@ -220,10 +210,9 @@ void show_regs_log_lvl(struct pt_regs *regs, const char *log_lvl)
 	if (!user_mode(regs)) {
 		sp = (unsigned long)regs + FRAME_SIZE_FULL;
 
-		printk("%s", log_lvl);
-		print_symbol("PC is at %s\n", instruction_pointer(regs));
-		printk("%s", log_lvl);
-		print_symbol("LR is at %s\n", lr);
+		printk("%sPC is at %pSR\n",
+		       log_lvl, (void *)instruction_pointer(regs));
+		printk("%sLR is at %pSR\n", log_lvl, (void *)lr);
 	}
 
 	printk("%spc : [<%08lx>]    lr : [<%08lx>]    %s\n"
diff --git a/arch/c6x/kernel/traps.c b/arch/c6x/kernel/traps.c
index dcc2c2f..66825b7 100644
--- a/arch/c6x/kernel/traps.c
+++ b/arch/c6x/kernel/traps.c
@@ -374,8 +374,7 @@ static void show_trace(unsigned long *stack, unsigned long *endstack)
 			if (i % 5 == 0)
 				pr_debug("\n	    ");
 #endif
-			pr_debug(" [<%08lx>]", addr);
-			print_symbol(" %s\n", addr);
+			pr_debug(" [<%08lx>] %pSR\n", addr, (void *)addr);
 			i++;
 		}
 	}
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 55d4ba4..63a8b2d 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -1,4 +1,4 @@
-/*
+ /*
  * Architecture-specific setup.
  *
  * Copyright (C) 1998-2003 Hewlett-Packard Co
@@ -64,7 +64,6 @@ void
 ia64_do_show_stack (struct unw_frame_info *info, void *arg)
 {
 	unsigned long ip, sp, bsp;
-	char buf[128];			/* don't make it so big that it overflows the stack! */
 
 	printk("\nCall Trace:\n");
 	do {
@@ -74,11 +73,9 @@ ia64_do_show_stack (struct unw_frame_info *info, void *arg)
 
 		unw_get_sp(info, &sp);
 		unw_get_bsp(info, &bsp);
-		snprintf(buf, sizeof(buf),
-			 " [<%016lx>] %%s\n"
-			 "                                sp=%016lx bsp=%016lx\n",
-			 ip, sp, bsp);
-		print_symbol(buf, ip);
+		printk(" [<%016lx>] %pSR\n"
+		       "                                sp=%016lx bsp=%016lx\n",
+		       ip, (void *)ip, sp, bsp);
 	} while (unw_unwind(info) >= 0);
 }
 
@@ -106,7 +103,7 @@ show_regs (struct pt_regs *regs)
 	printk("psr : %016lx ifs : %016lx ip  : [<%016lx>]    %s (%s)\n",
 	       regs->cr_ipsr, regs->cr_ifs, ip, print_tainted(),
 	       init_utsname()->release);
-	print_symbol("ip is at %s\n", ip);
+	printk("ip is at %pSR\n", (void *)ip);
 	printk("unat: %016lx pfs : %016lx rsc : %016lx\n",
 	       regs->ar_unat, regs->ar_pfs, regs->ar_rsc);
 	printk("rnat: %016lx bsps: %016lx pr  : %016lx\n",
diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index a7a987c..e457de0 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -256,13 +256,13 @@ void show_trace(unsigned long *sp)
 		}
 
 		if (__kernel_text_address(addr)) {
-			printk(" [<%08lx>]", addr);
+			const char *known = "";
 			if (stack >= raslot)
 				raslot = ULONG_MAX;
 			else
-				printk(" ?");
-			print_symbol(" %s", addr);
-			printk("\n");
+				known = " ?";
+			printk(" [<%08lx>]%s %pSR\n",
+			       addr, known, (void *)addr);
 		}
 	}
 
diff --git a/arch/openrisc/kernel/traps.c b/arch/openrisc/kernel/traps.c
index 3d3f606..4cc1ee6 100644
--- a/arch/openrisc/kernel/traps.c
+++ b/arch/openrisc/kernel/traps.c
@@ -56,11 +56,8 @@ void show_trace(struct task_struct *task, unsigned long *stack)
 
 	while (valid_stack_ptr(context, stack)) {
 		addr = *stack++;
-		if (__kernel_text_address(addr)) {
-			printk(" [<%08lx>]", addr);
-			print_symbol(" %s", addr);
-			printk("\n");
-		}
+		if (__kernel_text_address(addr))
+			printk(" [<%08lx>] %pSR\n", addr, (void *)addr);
 	}
 	printk(" =======================\n");
 }
diff --git a/arch/s390/kernel/dumpstack.c b/arch/s390/kernel/dumpstack.c
index 87acc38..a81c517 100644
--- a/arch/s390/kernel/dumpstack.c
+++ b/arch/s390/kernel/dumpstack.c
@@ -46,8 +46,9 @@ __show_trace(unsigned long sp, unsigned long low, unsigned long high)
 		if (sp < low || sp > high - sizeof(*sf))
 			return sp;
 		sf = (struct stack_frame *) sp;
-		printk("([<%016lx>] ", sf->gprs[8] & PSW_ADDR_INSN);
-		print_symbol("%s)\n", sf->gprs[8] & PSW_ADDR_INSN);
+		printk("([<%016lx>] (%pSR)\n",
+		       (unsigned long)(sf->gprs[8] & PSW_ADDR_INSN),
+		       (void *)(unsigned long)(sf->gprs[8] & PSW_ADDR_INSN));
 		/* Follow the backchain. */
 		while (1) {
 			low = sp;
@@ -57,16 +58,18 @@ __show_trace(unsigned long sp, unsigned long low, unsigned long high)
 			if (sp <= low || sp > high - sizeof(*sf))
 				return sp;
 			sf = (struct stack_frame *) sp;
-			printk(" [<%016lx>] ", sf->gprs[8] & PSW_ADDR_INSN);
-			print_symbol("%s\n", sf->gprs[8] & PSW_ADDR_INSN);
+			printk(" [<%016lx>] %pSR\n",
+			       (unsigned long)(sf->gprs[8] & PSW_ADDR_INSN),
+			       (void *)(unsigned long)(sf->gprs[8] & PSW_ADDR_INSN));
 		}
 		/* Zero backchain detected, check for interrupt frame. */
 		sp = (unsigned long) (sf + 1);
 		if (sp <= low || sp > high - sizeof(*regs))
 			return sp;
 		regs = (struct pt_regs *) sp;
-		printk(" [<%016lx>] ", regs->psw.addr & PSW_ADDR_INSN);
-		print_symbol("%s\n", regs->psw.addr & PSW_ADDR_INSN);
+		printk(" [<%016lx>] %pSR\n",
+		       (unsigned long)(regs->psw.addr & PSW_ADDR_INSN),
+		       (void *)(unsigned long)(regs->psw.addr & PSW_ADDR_INSN));
 		low = sp;
 		sp = regs->gprs[15];
 	}
@@ -128,8 +131,9 @@ static void show_last_breaking_event(struct pt_regs *regs)
 {
 #ifdef CONFIG_64BIT
 	printk("Last Breaking-Event-Address:\n");
-	printk(" [<%016lx>] ", regs->args[0] & PSW_ADDR_INSN);
-	print_symbol("%s\n", regs->args[0] & PSW_ADDR_INSN);
+	printk(" [<%016lx>] %pSR\n",
+	       (unsigned long)(regs->args[0] & PSW_ADDR_INSN),
+	       (void *)(unsigned long)(regs->args[0] & PSW_ADDR_INSN));
 #endif
 }
 
@@ -143,10 +147,10 @@ void show_registers(struct pt_regs *regs)
 	char *mode;
 
 	mode = user_mode(regs) ? "User" : "Krnl";
-	printk("%s PSW : %p %p",
+	printk("%s PSW : %p %p %pSR\n",
 	       mode, (void *) regs->psw.mask,
-	       (void *) regs->psw.addr);
-	print_symbol(" (%s)\n", regs->psw.addr & PSW_ADDR_INSN);
+	       (void *) regs->psw.addr,
+	       (void *)(unsigned long)(regs->psw.addr & PSW_ADDR_INSN));
 	printk("           R:%x T:%x IO:%x EX:%x Key:%x M:%x W:%x "
 	       "P:%x AS:%x CC:%x PM:%x", mask_bits(regs, PSW_MASK_PER),
 	       mask_bits(regs, PSW_MASK_DAT), mask_bits(regs, PSW_MASK_IO),
diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
index ebd3933..fd7a988 100644
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -34,8 +34,8 @@ void show_regs(struct pt_regs * regs)
 	printk("\n");
 	show_regs_print_info(KERN_DEFAULT);
 
-	print_symbol("PC is at %s\n", instruction_pointer(regs));
-	print_symbol("PR is at %s\n", regs->pr);
+	printk("PC is at %pSR\n", (void *)instruction_pointer(regs));
+	printk("PR is at %pSR\n", (void *)regs->pr);
 
 	printk("PC  : %08lx SP  : %08lx SR  : %08lx ",
 	       regs->pc, regs->regs[15], regs->sr);
diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index 0dc4d1c..6d71cbe 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -24,10 +24,8 @@ void show_trace(struct task_struct *task, unsigned long * stack)
 	while (((long) stack & (THREAD_SIZE-1)) != 0) {
 		addr = *stack;
 		if (__kernel_text_address(addr)) {
-			printk(KERN_INFO "%08lx:  [<%08lx>]",
-			       (unsigned long) stack, addr);
-			print_symbol(KERN_CONT " %s", addr);
-			printk(KERN_CONT "\n");
+			printk(KERN_INFO "%08lx:  [<%08lx>] %pSR\n",
+			       (unsigned long)stack, addr, (void *)addr);
 		}
 		stack++;
 	}
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index 778ebba..40e4a04 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -135,8 +135,9 @@ void __show_regs(struct pt_regs *regs)
 	char buf[64];
 
 	show_regs_print_info(KERN_DEFAULT);
-	print_symbol("PC is at %s\n", instruction_pointer(regs));
-	print_symbol("LR is at %s\n", regs->UCreg_lr);
+	printk(KERN_DEFAULT "PC is at %pSR\n",
+	       (void *)instruction_pointer(regs));
+	printk(KERN_DEFAULT "LR is at %pSR\n", (void *)regs->UCreg_lr);
 	printk(KERN_DEFAULT "pc : [<%08lx>]    lr : [<%08lx>]    psr: %08lx\n"
 	       "sp : %08lx  ip : %08lx  fp : %08lx\n",
 		regs->UCreg_pc, regs->UCreg_lr, regs->UCreg_asr,
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 87a65c9..7262130 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -245,13 +245,14 @@ static void print_mce(struct mce *m)
 	       m->extcpu, m->mcgstatus, m->bank, m->status);
 
 	if (m->ip) {
-		pr_emerg(HW_ERR "RIP%s %02x:<%016Lx> ",
-			!(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
-				m->cs, m->ip);
-
 		if (m->cs == __KERNEL_CS)
-			print_symbol("{%s}", m->ip);
-		pr_cont("\n");
+			pr_emerg(HW_ERR "RIP%s %02x:<%016Lx> {%pSR}\n",
+				 !(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
+				 m->cs, m->ip, (void *)m->ip);
+		else
+			pr_emerg(HW_ERR "RIP%s %02x:<%016Lx>\n",
+				 !(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
+				 m->cs, m->ip);
 	}
 
 	pr_emerg(HW_ERR "TSC %llx ", m->tsc);
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index deb6421..b52b6f9 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -275,9 +275,8 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 		sp = kernel_stack_pointer(regs);
 		savesegment(ss, ss);
 	}
-	printk(KERN_EMERG "EIP: [<%08lx>] ", regs->ip);
-	print_symbol("%s", regs->ip);
-	printk(" SS:ESP %04x:%08lx\n", ss, sp);
+	printk(KERN_EMERG "EIP: [<%08lx>] %pSR SS:ESP %04x:%08lx\n",
+	       regs->ip, (void *)regs->ip, ss, sp);
 #else
 	/* Executive summary in case the oops scrolled away */
 	printk(KERN_ALERT "RIP ");
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index e1aabdb..8ad741e 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -389,7 +389,7 @@ ENTRY(early_idt_handler)
 #ifdef CONFIG_KALLSYMS	
 	leaq early_idt_ripmsg(%rip),%rdi
 	movq 40(%rsp),%rsi	# %rip again
-	call __print_symbol
+	call early_printk
 #endif
 #endif /* EARLY_PRINTK */
 1:	hlt
@@ -420,7 +420,7 @@ early_recursion_flag:
 early_idt_msg:
 	.asciz "PANIC: early exception %02lx rip %lx:%lx error %lx cr2 %lx\n"
 early_idt_ripmsg:
-	.asciz "RIP %s\n"
+	.asciz "RIP %pSR\n"
 #endif /* CONFIG_EARLY_PRINTK */
 
 #define NEXT_PAGE(name) \
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index f8adefc..7b826be 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -87,7 +87,7 @@ void __show_regs(struct pt_regs *regs, int all)
 	printk(KERN_DEFAULT "EIP: %04x:[<%08lx>] EFLAGS: %08lx CPU: %d\n",
 			(u16)regs->cs, regs->ip, regs->flags,
 			smp_processor_id());
-	print_symbol("EIP is at %s\n", regs->ip);
+	printk(KERN_DEFAULT "EIP is at %pSR\n", (void *)regs->ip);
 
 	printk(KERN_DEFAULT "EAX: %08lx EBX: %08lx ECX: %08lx EDX: %08lx\n",
 		regs->ax, regs->bx, regs->cx, regs->dx);
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 0057a7a..2b0a9ff 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -123,8 +123,8 @@ static void die_kmmio_nesting_error(struct pt_regs *regs, unsigned long addr)
 	pr_emerg("unexpected fault for address: 0x%08lx, last fault for address: 0x%08lx\n",
 		 addr, my_reason->addr);
 	print_pte(addr);
-	print_symbol(KERN_EMERG "faulting IP is at %s\n", regs->ip);
-	print_symbol(KERN_EMERG "last faulting IP was at %s\n", my_reason->ip);
+	pr_emerg("faulting IP is at %pSR\n", (void *)regs->ip);
+	pr_emerg("last faulting IP was at %pSR\n", (void *)my_reason->ip);
 #ifdef __i386__
 	pr_emerg("eax: %08lx   ebx: %08lx   ecx: %08lx   edx: %08lx\n",
 		 regs->ax, regs->bx, regs->cx, regs->dx);
diff --git a/arch/x86/um/sysrq_32.c b/arch/x86/um/sysrq_32.c
index c9bee5b..30b4200 100644
--- a/arch/x86/um/sysrq_32.c
+++ b/arch/x86/um/sysrq_32.c
@@ -50,18 +50,15 @@ static inline unsigned long print_context_stack(struct thread_info *tinfo,
 #ifdef CONFIG_FRAME_POINTER
 	while (valid_stack_ptr(tinfo, (void *)ebp)) {
 		addr = *(unsigned long *)(ebp + 4);
-		printk("%08lx:  [<%08lx>]", ebp + 4, addr);
-		print_symbol(" %s", addr);
-		printk("\n");
+		printk("%08lx:  [<%08lx>] %pSR\n", ebp + 4, addr, (void *)addr);
 		ebp = *(unsigned long *)ebp;
 	}
 #else
 	while (valid_stack_ptr(tinfo, stack)) {
 		addr = *stack;
 		if (__kernel_text_address(addr)) {
-			printk("%08lx:  [<%08lx>]", (unsigned long) stack, addr);
-			print_symbol(" %s", addr);
-			printk("\n");
+			printk("%08lx:  [<%08lx>] %pSR\n",
+			       (unsigned long)stack, addr, (void *)addr);
 		}
 		stack++;
 	}
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index 3e8a05c..70d3f10 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -409,10 +409,9 @@ void show_regs(struct pt_regs * regs)
 
 static int show_trace_cb(struct stackframe *frame, void *data)
 {
-	if (kernel_text_address(frame->pc)) {
-		printk(" [<%08lx>] ", frame->pc);
-		print_symbol("%s\n", frame->pc);
-	}
+	if (kernel_text_address(frame->pc))
+		printk(" [<%08lx>] %pSR\n", frame->pc, (void *)frame->pc);
+
 	return 0;
 }
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8856d74..5a29cbf 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -97,8 +97,8 @@ static ssize_t dev_attr_show(struct kobject *kobj, struct attribute *attr,
 	if (dev_attr->show)
 		ret = dev_attr->show(dev, dev_attr, buf);
 	if (ret >= (ssize_t)PAGE_SIZE) {
-		print_symbol("dev_attr_show: %s returned bad count\n",
-				(unsigned long)dev_attr->show);
+		printk("dev_attr_show: %pSR returned bad count\n",
+		       dev_attr->show);
 	}
 	return ret;
 }
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
index e2c195b..061fb74 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
@@ -194,10 +194,8 @@ static int print_trace_stack(void *data, char *name)
 # define DUMP_TRACE_CONST const
 static void print_trace_address(void *data, unsigned long addr, int reliable)
 {
-	char fmt[32];
 	touch_nmi_watchdog();
-	sprintf(fmt, " [<%016lx>] %s%%s\n", addr, RELIABLE ? "": "? ");
-	__print_symbol(fmt, addr);
+	printk(" [<%016lx>] %s%pSR\n", addr, RELIABLE ? "": "? ", (void *)addr);
 }
 
 static DUMP_TRACE_CONST struct stacktrace_ops print_trace_ops = {
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index d2bb7ed..d8057e9 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -91,8 +91,8 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 	 * indicate truncated result or overflow in normal use cases.
 	 */
 	if (count >= (ssize_t)PAGE_SIZE) {
-		print_symbol("fill_read_buffer: %s returned bad count\n",
-			(unsigned long)ops->show);
+		printk("fill_read_buffer: %pSR returned bad count\n",
+		       ops->show);
 		/* Try to struggle along */
 		count = PAGE_SIZE - 1;
 	}
diff --git a/kernel/irq/debug.h b/kernel/irq/debug.h
index e75e29e..70f487d9 100644
--- a/kernel/irq/debug.h
+++ b/kernel/irq/debug.h
@@ -13,15 +13,14 @@ static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
 {
 	printk("irq %d, desc: %p, depth: %d, count: %d, unhandled: %d\n",
 		irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
-	printk("->handle_irq():  %p, ", desc->handle_irq);
-	print_symbol("%s\n", (unsigned long)desc->handle_irq);
-	printk("->irq_data.chip(): %p, ", desc->irq_data.chip);
-	print_symbol("%s\n", (unsigned long)desc->irq_data.chip);
+	printk("->handle_irq():  %p, %pSR\n",
+	       desc->handle_irq, desc->handle_irq);
+	printk("->irq_data.chip(): %p, %pSR\n",
+	       desc->irq_data.chip, desc->irq_data.chip);
 	printk("->action(): %p\n", desc->action);
-	if (desc->action) {
-		printk("->action->handler(): %p, ", desc->action->handler);
-		print_symbol("%s\n", (unsigned long)desc->action->handler);
-	}
+	if (desc->action)
+		printk("->action->handler(): %p, %pSR\n",
+		       desc->action->handler, desc->action->handler);
 
 	___P(IRQ_LEVEL);
 	___P(IRQ_PER_CPU);
diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index 4c0d0e5..37e59c4 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -42,7 +42,7 @@ notrace unsigned int debug_smp_processor_id(void)
 	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] "
 			"code: %s/%d\n",
 			preempt_count() - 1, current->comm, current->pid);
-	print_symbol("caller is %s\n", (long)__builtin_return_address(0));
+	printk("caller is %pSR\n", __builtin_return_address(0));
 	dump_stack();
 
 out_enable:
-- 
1.8.1.2.459.gbcd45b4.dirty

