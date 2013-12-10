Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab3LJLNC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:13:02 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:34238 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab3LJLMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:12:05 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/3] m68k: Convert arch/m68k/kernel/traps.c to pr_*()
Date: Tue, 10 Dec 2013 12:11:59 +0100
Message-Id: <1386673920-5670-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386673920-5670-1-git-send-email-geert@linux-m68k.org>
References: <1386673920-5670-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fix a few printf-style formats, to get rid of the following compiler
warnings when DEBUG is enabled:

arch/m68k/kernel/traps.c: In function ‘access_error060’:
arch/m68k/kernel/traps.c:166: warning: format ‘%d’ expects type ‘int’, but argument 2 has type ‘long unsigned int’
arch/m68k/kernel/traps.c: In function ‘bus_error030’:
arch/m68k/kernel/traps.c:568: warning: format ‘%#lx’ expects type ‘long unsigned int’, but argument 2 has type ‘void *’
arch/m68k/kernel/traps.c:682: warning: format ‘%#lx’ expects type ‘long unsigned int’, but argument 2 has type ‘void *’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/traps.c |  232 ++++++++++++++++++++--------------------------
 1 file changed, 101 insertions(+), 131 deletions(-)

diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index 88fcd8c70e7b..6c9ca24830e9 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -133,9 +133,7 @@ static inline void access_error060 (struct frame *fp)
 {
 	unsigned long fslw = fp->un.fmt4.pc; /* is really FSLW for access error */
 
-#ifdef DEBUG
-	printk("fslw=%#lx, fa=%#lx\n", fslw, fp->un.fmt4.effaddr);
-#endif
+	pr_debug("fslw=%#lx, fa=%#lx\n", fslw, fp->un.fmt4.effaddr);
 
 	if (fslw & MMU060_BPE) {
 		/* branch prediction error -> clear branch cache */
@@ -162,9 +160,7 @@ static inline void access_error060 (struct frame *fp)
 		}
 		if (fslw & MMU060_W)
 			errorcode |= 2;
-#ifdef DEBUG
-		printk("errorcode = %d\n", errorcode );
-#endif
+		pr_debug("errorcode = %ld\n", errorcode);
 		do_page_fault(&fp->ptregs, addr, errorcode);
 	} else if (fslw & (MMU060_SEE)){
 		/* Software Emulation Error.
@@ -173,8 +169,9 @@ static inline void access_error060 (struct frame *fp)
 		send_fault_sig(&fp->ptregs);
 	} else if (!(fslw & (MMU060_RE|MMU060_WE)) ||
 		   send_fault_sig(&fp->ptregs) > 0) {
-		printk("pc=%#lx, fa=%#lx\n", fp->ptregs.pc, fp->un.fmt4.effaddr);
-		printk( "68060 access error, fslw=%lx\n", fslw );
+		pr_err("pc=%#lx, fa=%#lx\n", fp->ptregs.pc,
+		       fp->un.fmt4.effaddr);
+		pr_err("68060 access error, fslw=%lx\n", fslw);
 		trap_c( fp );
 	}
 }
@@ -225,9 +222,7 @@ static inline int do_040writeback1(unsigned short wbs, unsigned long wba,
 	set_fs(old_fs);
 
 
-#ifdef DEBUG
-	printk("do_040writeback1, res=%d\n",res);
-#endif
+	pr_debug("do_040writeback1, res=%d\n", res);
 
 	return res;
 }
@@ -249,7 +244,7 @@ static inline void do_040writebacks(struct frame *fp)
 	int res = 0;
 #if 0
 	if (fp->un.fmt7.wb1s & WBV_040)
-		printk("access_error040: cannot handle 1st writeback. oops.\n");
+		pr_err("access_error040: cannot handle 1st writeback. oops.\n");
 #endif
 
 	if ((fp->un.fmt7.wb2s & WBV_040) &&
@@ -302,14 +297,12 @@ static inline void access_error040(struct frame *fp)
 	unsigned short ssw = fp->un.fmt7.ssw;
 	unsigned long mmusr;
 
-#ifdef DEBUG
-	printk("ssw=%#x, fa=%#lx\n", ssw, fp->un.fmt7.faddr);
-        printk("wb1s=%#x, wb2s=%#x, wb3s=%#x\n", fp->un.fmt7.wb1s,
+	pr_debug("ssw=%#x, fa=%#lx\n", ssw, fp->un.fmt7.faddr);
+	pr_debug("wb1s=%#x, wb2s=%#x, wb3s=%#x\n", fp->un.fmt7.wb1s,
 		fp->un.fmt7.wb2s, fp->un.fmt7.wb3s);
-	printk ("wb2a=%lx, wb3a=%lx, wb2d=%lx, wb3d=%lx\n",
+	pr_debug("wb2a=%lx, wb3a=%lx, wb2d=%lx, wb3d=%lx\n",
 		fp->un.fmt7.wb2a, fp->un.fmt7.wb3a,
 		fp->un.fmt7.wb2d, fp->un.fmt7.wb3d);
-#endif
 
 	if (ssw & ATC_040) {
 		unsigned long addr = fp->un.fmt7.faddr;
@@ -324,9 +317,7 @@ static inline void access_error040(struct frame *fp)
 
 		/* MMU error, get the MMUSR info for this access */
 		mmusr = probe040(!(ssw & RW_040), addr, ssw);
-#ifdef DEBUG
-		printk("mmusr = %lx\n", mmusr);
-#endif
+		pr_debug("mmusr = %lx\n", mmusr);
 		errorcode = 1;
 		if (!(mmusr & MMU_R_040)) {
 			/* clear the invalid atc entry */
@@ -340,14 +331,10 @@ static inline void access_error040(struct frame *fp)
 			errorcode |= 2;
 
 		if (do_page_fault(&fp->ptregs, addr, errorcode)) {
-#ifdef DEBUG
-			printk("do_page_fault() !=0\n");
-#endif
+			pr_debug("do_page_fault() !=0\n");
 			if (user_mode(&fp->ptregs)){
 				/* delay writebacks after signal delivery */
-#ifdef DEBUG
-			        printk(".. was usermode - return\n");
-#endif
+				pr_debug(".. was usermode - return\n");
 				return;
 			}
 			/* disable writeback into user space from kernel
@@ -355,9 +342,7 @@ static inline void access_error040(struct frame *fp)
                          * the writeback won't do good)
 			 */
 disable_wb:
-#ifdef DEBUG
-			printk(".. disabling wb2\n");
-#endif
+			pr_debug(".. disabling wb2\n");
 			if (fp->un.fmt7.wb2a == fp->un.fmt7.faddr)
 				fp->un.fmt7.wb2s &= ~WBV_040;
 			if (fp->un.fmt7.wb3a == fp->un.fmt7.faddr)
@@ -371,7 +356,7 @@ disable_wb:
 		current->thread.signo = SIGBUS;
 		current->thread.faddr = fp->un.fmt7.faddr;
 		if (send_fault_sig(&fp->ptregs) >= 0)
-			printk("68040 bus error (ssw=%x, faddr=%lx)\n", ssw,
+			pr_err("68040 bus error (ssw=%x, faddr=%lx)\n", ssw,
 			       fp->un.fmt7.faddr);
 		goto disable_wb;
 	}
@@ -394,19 +379,17 @@ static inline void bus_error030 (struct frame *fp)
 	unsigned short ssw = fp->un.fmtb.ssw;
 	extern unsigned long _sun3_map_test_start, _sun3_map_test_end;
 
-#ifdef DEBUG
 	if (ssw & (FC | FB))
-		printk ("Instruction fault at %#010lx\n",
+		pr_debug("Instruction fault at %#010lx\n",
 			ssw & FC ?
 			fp->ptregs.format == 0xa ? fp->ptregs.pc + 2 : fp->un.fmtb.baddr - 2
 			:
 			fp->ptregs.format == 0xa ? fp->ptregs.pc + 4 : fp->un.fmtb.baddr);
 	if (ssw & DF)
-		printk ("Data %s fault at %#010lx in %s (pc=%#lx)\n",
+		pr_debug("Data %s fault at %#010lx in %s (pc=%#lx)\n",
 			ssw & RW ? "read" : "write",
 			fp->un.fmtb.daddr,
 			space_names[ssw & DFC], fp->ptregs.pc);
-#endif
 
 	/*
 	 * Check if this page should be demand-mapped. This needs to go before
@@ -429,7 +412,7 @@ static inline void bus_error030 (struct frame *fp)
 			  return;
 			/* instruction fault or kernel data fault! */
 			if (ssw & (FC | FB))
-				printk ("Instruction fault at %#010lx\n",
+				pr_err("Instruction fault at %#010lx\n",
 					fp->ptregs.pc);
 			if (ssw & DF) {
 				/* was this fault incurred testing bus mappings? */
@@ -439,12 +422,12 @@ static inline void bus_error030 (struct frame *fp)
 					return;
 				}
 
-				printk ("Data %s fault at %#010lx in %s (pc=%#lx)\n",
+				pr_err("Data %s fault at %#010lx in %s (pc=%#lx)\n",
 					ssw & RW ? "read" : "write",
 					fp->un.fmtb.daddr,
 					space_names[ssw & DFC], fp->ptregs.pc);
 			}
-			printk ("BAD KERNEL BUSERR\n");
+			pr_err("BAD KERNEL BUSERR\n");
 
 			die_if_kernel("Oops", &fp->ptregs,0);
 			force_sig(SIGKILL, current);
@@ -473,12 +456,11 @@ static inline void bus_error030 (struct frame *fp)
 		else if (buserr_type & SUN3_BUSERR_INVALID)
 			errorcode = 0x00;
 		else {
-#ifdef DEBUG
-			printk ("*** unexpected busfault type=%#04x\n", buserr_type);
-			printk ("invalid %s access at %#lx from pc %#lx\n",
-				!(ssw & RW) ? "write" : "read", addr,
-				fp->ptregs.pc);
-#endif
+			pr_debug("*** unexpected busfault type=%#04x\n",
+				 buserr_type);
+			pr_debug("invalid %s access at %#lx from pc %#lx\n",
+				 !(ssw & RW) ? "write" : "read", addr,
+				 fp->ptregs.pc);
 			die_if_kernel ("Oops", &fp->ptregs, buserr_type);
 			force_sig (SIGBUS, current);
 			return;
@@ -509,9 +491,7 @@ static inline void bus_error030 (struct frame *fp)
 		if (!mmu_emu_handle_fault(addr, 1, 0))
 			do_page_fault (&fp->ptregs, addr, 0);
        } else {
-#ifdef DEBUG
-		printk ("protection fault on insn access (segv).\n");
-#endif
+		pr_debug("protection fault on insn access (segv).\n");
 		force_sig (SIGSEGV, current);
        }
 }
@@ -525,22 +505,22 @@ static inline void bus_error030 (struct frame *fp)
 	unsigned short ssw = fp->un.fmtb.ssw;
 #ifdef DEBUG
 	unsigned long desc;
+#endif
 
-	printk ("pid = %x  ", current->pid);
-	printk ("SSW=%#06x  ", ssw);
+	pr_debug("pid = %x  ", current->pid);
+	pr_debug("SSW=%#06x  ", ssw);
 
 	if (ssw & (FC | FB))
-		printk ("Instruction fault at %#010lx\n",
+		pr_debug("Instruction fault at %#010lx\n",
 			ssw & FC ?
 			fp->ptregs.format == 0xa ? fp->ptregs.pc + 2 : fp->un.fmtb.baddr - 2
 			:
 			fp->ptregs.format == 0xa ? fp->ptregs.pc + 4 : fp->un.fmtb.baddr);
 	if (ssw & DF)
-		printk ("Data %s fault at %#010lx in %s (pc=%#lx)\n",
+		pr_debug("Data %s fault at %#010lx in %s (pc=%#lx)\n",
 			ssw & RW ? "read" : "write",
 			fp->un.fmtb.daddr,
 			space_names[ssw & DFC], fp->ptregs.pc);
-#endif
 
 	/* ++andreas: If a data fault and an instruction fault happen
 	   at the same time map in both pages.  */
@@ -554,27 +534,23 @@ static inline void bus_error030 (struct frame *fp)
 			      "pmove %%psr,%1"
 			      : "=a&" (desc), "=m" (temp)
 			      : "a" (addr), "d" (ssw));
+		pr_debug("mmusr is %#x for addr %#lx in task %p\n",
+			 temp, addr, current);
+		pr_debug("descriptor address is 0x%p, contents %#lx\n",
+			 __va(desc), *(unsigned long *)__va(desc));
 #else
 		asm volatile ("ptestr %2,%1@,#7\n\t"
 			      "pmove %%psr,%0"
 			      : "=m" (temp) : "a" (addr), "d" (ssw));
 #endif
 		mmusr = temp;
-
-#ifdef DEBUG
-		printk("mmusr is %#x for addr %#lx in task %p\n",
-		       mmusr, addr, current);
-		printk("descriptor address is %#lx, contents %#lx\n",
-		       __va(desc), *(unsigned long *)__va(desc));
-#endif
-
 		errorcode = (mmusr & MMU_I) ? 0 : 1;
 		if (!(ssw & RW) || (ssw & RM))
 			errorcode |= 2;
 
 		if (mmusr & (MMU_I | MMU_WP)) {
 			if (ssw & 4) {
-				printk("Data %s fault at %#010lx in %s (pc=%#lx)\n",
+				pr_err("Data %s fault at %#010lx in %s (pc=%#lx)\n",
 				       ssw & RW ? "read" : "write",
 				       fp->un.fmtb.daddr,
 				       space_names[ssw & DFC], fp->ptregs.pc);
@@ -587,9 +563,10 @@ static inline void bus_error030 (struct frame *fp)
 		} else if (!(mmusr & MMU_I)) {
 			/* probably a 020 cas fault */
 			if (!(ssw & RM) && send_fault_sig(&fp->ptregs) > 0)
-				printk("unexpected bus error (%#x,%#x)\n", ssw, mmusr);
+				pr_err("unexpected bus error (%#x,%#x)\n", ssw,
+				       mmusr);
 		} else if (mmusr & (MMU_B|MMU_L|MMU_S)) {
-			printk("invalid %s access at %#lx from pc %#lx\n",
+			pr_err("invalid %s access at %#lx from pc %#lx\n",
 			       !(ssw & RW) ? "write" : "read", addr,
 			       fp->ptregs.pc);
 			die_if_kernel("Oops",&fp->ptregs,mmusr);
@@ -600,7 +577,7 @@ static inline void bus_error030 (struct frame *fp)
 			static volatile long tlong;
 #endif
 
-			printk("weird %s access at %#lx from pc %#lx (ssw is %#x)\n",
+			pr_err("weird %s access at %#lx from pc %#lx (ssw is %#x)\n",
 			       !(ssw & RW) ? "write" : "read", addr,
 			       fp->ptregs.pc, ssw);
 			asm volatile ("ptestr #1,%1@,#0\n\t"
@@ -609,18 +586,16 @@ static inline void bus_error030 (struct frame *fp)
 				      : "a" (addr));
 			mmusr = temp;
 
-			printk ("level 0 mmusr is %#x\n", mmusr);
+			pr_err("level 0 mmusr is %#x\n", mmusr);
 #if 0
 			asm volatile ("pmove %%tt0,%0"
 				      : "=m" (tlong));
-			printk("tt0 is %#lx, ", tlong);
+			pr_debug("tt0 is %#lx, ", tlong);
 			asm volatile ("pmove %%tt1,%0"
 				      : "=m" (tlong));
-			printk("tt1 is %#lx\n", tlong);
-#endif
-#ifdef DEBUG
-			printk("Unknown SIGSEGV - 1\n");
+			pr_debug("tt1 is %#lx\n", tlong);
 #endif
+			pr_debug("Unknown SIGSEGV - 1\n");
 			die_if_kernel("Oops",&fp->ptregs,mmusr);
 			force_sig(SIGSEGV, current);
 			return;
@@ -641,10 +616,9 @@ static inline void bus_error030 (struct frame *fp)
 		return;
 
 	if (fp->ptregs.sr & PS_S) {
-		printk("Instruction fault at %#010lx\n",
-			fp->ptregs.pc);
+		pr_err("Instruction fault at %#010lx\n", fp->ptregs.pc);
 	buserr:
-		printk ("BAD KERNEL BUSERR\n");
+		pr_err("BAD KERNEL BUSERR\n");
 		die_if_kernel("Oops",&fp->ptregs,0);
 		force_sig(SIGKILL, current);
 		return;
@@ -668,28 +642,22 @@ static inline void bus_error030 (struct frame *fp)
 		      "pmove %%psr,%1"
 		      : "=a&" (desc), "=m" (temp)
 		      : "a" (addr));
+	pr_debug("mmusr is %#x for addr %#lx in task %p\n",
+		temp, addr, current);
+	pr_debug("descriptor address is 0x%p, contents %#lx\n",
+		__va(desc), *(unsigned long *)__va(desc));
 #else
 	asm volatile ("ptestr #1,%1@,#7\n\t"
 		      "pmove %%psr,%0"
 		      : "=m" (temp) : "a" (addr));
 #endif
 	mmusr = temp;
-
-#ifdef DEBUG
-	printk ("mmusr is %#x for addr %#lx in task %p\n",
-		mmusr, addr, current);
-	printk ("descriptor address is %#lx, contents %#lx\n",
-		__va(desc), *(unsigned long *)__va(desc));
-#endif
-
 	if (mmusr & MMU_I)
 		do_page_fault (&fp->ptregs, addr, 0);
 	else if (mmusr & (MMU_B|MMU_L|MMU_S)) {
-		printk ("invalid insn access at %#lx from pc %#lx\n",
+		pr_err("invalid insn access at %#lx from pc %#lx\n",
 			addr, fp->ptregs.pc);
-#ifdef DEBUG
-		printk("Unknown SIGSEGV - 2\n");
-#endif
+		pr_debug("Unknown SIGSEGV - 2\n");
 		die_if_kernel("Oops",&fp->ptregs,mmusr);
 		force_sig(SIGSEGV, current);
 		return;
@@ -791,9 +759,7 @@ asmlinkage void buserr_c(struct frame *fp)
 	if (user_mode(&fp->ptregs))
 		current->thread.esp0 = (unsigned long) fp;
 
-#ifdef DEBUG
-	printk ("*** Bus Error *** Format is %x\n", fp->ptregs.format);
-#endif
+	pr_debug("*** Bus Error *** Format is %x\n", fp->ptregs.format);
 
 #if defined(CONFIG_COLDFIRE) && defined(CONFIG_MMU)
 	if (CPU_IS_COLDFIRE) {
@@ -836,9 +802,7 @@ asmlinkage void buserr_c(struct frame *fp)
 #endif
 	default:
 	  die_if_kernel("bad frame format",&fp->ptregs,0);
-#ifdef DEBUG
-	  printk("Unknown SIGSEGV - 4\n");
-#endif
+	  pr_debug("Unknown SIGSEGV - 4\n");
 	  force_sig(SIGSEGV, current);
 	}
 }
@@ -852,7 +816,7 @@ void show_trace(unsigned long *stack)
 	unsigned long addr;
 	int i;
 
-	printk("Call Trace:");
+	pr_info("Call Trace:");
 	addr = (unsigned long)stack + THREAD_SIZE - 1;
 	endstack = (unsigned long *)(addr & -THREAD_SIZE);
 	i = 0;
@@ -869,13 +833,13 @@ void show_trace(unsigned long *stack)
 		if (__kernel_text_address(addr)) {
 #ifndef CONFIG_KALLSYMS
 			if (i % 5 == 0)
-				printk("\n       ");
+				pr_cont("\n       ");
 #endif
-			printk(" [<%08lx>] %pS\n", addr, (void *)addr);
+			pr_cont(" [<%08lx>] %pS\n", addr, (void *)addr);
 			i++;
 		}
 	}
-	printk("\n");
+	pr_cont("\n");
 }
 
 void show_registers(struct pt_regs *regs)
@@ -887,81 +851,87 @@ void show_registers(struct pt_regs *regs)
 	int i;
 
 	print_modules();
-	printk("PC: [<%08lx>] %pS\n", regs->pc, (void *)regs->pc);
-	printk("SR: %04x  SP: %p  a2: %08lx\n", regs->sr, regs, regs->a2);
-	printk("d0: %08lx    d1: %08lx    d2: %08lx    d3: %08lx\n",
+	pr_info("PC: [<%08lx>] %pS\n", regs->pc, (void *)regs->pc);
+	pr_info("SR: %04x  SP: %p  a2: %08lx\n", regs->sr, regs, regs->a2);
+	pr_info("d0: %08lx    d1: %08lx    d2: %08lx    d3: %08lx\n",
 	       regs->d0, regs->d1, regs->d2, regs->d3);
-	printk("d4: %08lx    d5: %08lx    a0: %08lx    a1: %08lx\n",
+	pr_info("d4: %08lx    d5: %08lx    a0: %08lx    a1: %08lx\n",
 	       regs->d4, regs->d5, regs->a0, regs->a1);
 
-	printk("Process %s (pid: %d, task=%p)\n",
+	pr_info("Process %s (pid: %d, task=%p)\n",
 		current->comm, task_pid_nr(current), current);
 	addr = (unsigned long)&fp->un;
-	printk("Frame format=%X ", regs->format);
+	pr_info("Frame format=%X ", regs->format);
 	switch (regs->format) {
 	case 0x2:
-		printk("instr addr=%08lx\n", fp->un.fmt2.iaddr);
+		pr_cont("instr addr=%08lx\n", fp->un.fmt2.iaddr);
 		addr += sizeof(fp->un.fmt2);
 		break;
 	case 0x3:
-		printk("eff addr=%08lx\n", fp->un.fmt3.effaddr);
+		pr_cont("eff addr=%08lx\n", fp->un.fmt3.effaddr);
 		addr += sizeof(fp->un.fmt3);
 		break;
 	case 0x4:
-		printk((CPU_IS_060 ? "fault addr=%08lx fslw=%08lx\n"
-			: "eff addr=%08lx pc=%08lx\n"),
-			fp->un.fmt4.effaddr, fp->un.fmt4.pc);
+		if (CPU_IS_060)
+			pr_cont("fault addr=%08lx fslw=%08lx\n",
+				fp->un.fmt4.effaddr, fp->un.fmt4.pc);
+		else
+			pr_cont("eff addr=%08lx pc=%08lx\n",
+				fp->un.fmt4.effaddr, fp->un.fmt4.pc);
 		addr += sizeof(fp->un.fmt4);
 		break;
 	case 0x7:
-		printk("eff addr=%08lx ssw=%04x faddr=%08lx\n",
+		pr_cont("eff addr=%08lx ssw=%04x faddr=%08lx\n",
 			fp->un.fmt7.effaddr, fp->un.fmt7.ssw, fp->un.fmt7.faddr);
-		printk("wb 1 stat/addr/data: %04x %08lx %08lx\n",
+		pr_info("wb 1 stat/addr/data: %04x %08lx %08lx\n",
 			fp->un.fmt7.wb1s, fp->un.fmt7.wb1a, fp->un.fmt7.wb1dpd0);
-		printk("wb 2 stat/addr/data: %04x %08lx %08lx\n",
+		pr_info("wb 2 stat/addr/data: %04x %08lx %08lx\n",
 			fp->un.fmt7.wb2s, fp->un.fmt7.wb2a, fp->un.fmt7.wb2d);
-		printk("wb 3 stat/addr/data: %04x %08lx %08lx\n",
+		pr_info("wb 3 stat/addr/data: %04x %08lx %08lx\n",
 			fp->un.fmt7.wb3s, fp->un.fmt7.wb3a, fp->un.fmt7.wb3d);
-		printk("push data: %08lx %08lx %08lx %08lx\n",
+		pr_info("push data: %08lx %08lx %08lx %08lx\n",
 			fp->un.fmt7.wb1dpd0, fp->un.fmt7.pd1, fp->un.fmt7.pd2,
 			fp->un.fmt7.pd3);
 		addr += sizeof(fp->un.fmt7);
 		break;
 	case 0x9:
-		printk("instr addr=%08lx\n", fp->un.fmt9.iaddr);
+		pr_cont("instr addr=%08lx\n", fp->un.fmt9.iaddr);
 		addr += sizeof(fp->un.fmt9);
 		break;
 	case 0xa:
-		printk("ssw=%04x isc=%04x isb=%04x daddr=%08lx dobuf=%08lx\n",
+		pr_cont("ssw=%04x isc=%04x isb=%04x daddr=%08lx dobuf=%08lx\n",
 			fp->un.fmta.ssw, fp->un.fmta.isc, fp->un.fmta.isb,
 			fp->un.fmta.daddr, fp->un.fmta.dobuf);
 		addr += sizeof(fp->un.fmta);
 		break;
 	case 0xb:
-		printk("ssw=%04x isc=%04x isb=%04x daddr=%08lx dobuf=%08lx\n",
+		pr_cont("ssw=%04x isc=%04x isb=%04x daddr=%08lx dobuf=%08lx\n",
 			fp->un.fmtb.ssw, fp->un.fmtb.isc, fp->un.fmtb.isb,
 			fp->un.fmtb.daddr, fp->un.fmtb.dobuf);
-		printk("baddr=%08lx dibuf=%08lx ver=%x\n",
+		pr_info("baddr=%08lx dibuf=%08lx ver=%x\n",
 			fp->un.fmtb.baddr, fp->un.fmtb.dibuf, fp->un.fmtb.ver);
 		addr += sizeof(fp->un.fmtb);
 		break;
 	default:
-		printk("\n");
+		pr_cont("\n");
 	}
 	show_stack(NULL, (unsigned long *)addr);
 
-	printk("Code:");
+	pr_info("Code:");
 	set_fs(KERNEL_DS);
 	cp = (u16 *)regs->pc;
 	for (i = -8; i < 16; i++) {
 		if (get_user(c, cp + i) && i >= 0) {
-			printk(" Bad PC value.");
+			pr_cont(" Bad PC value.");
 			break;
 		}
-		printk(i ? " %04x" : " <%04x>", c);
+		if (i)
+			pr_cont(" %04x", c);
+		else
+			pr_cont(" <%04x>", c);
 	}
 	set_fs(old_fs);
-	printk ("\n");
+	pr_cont("\n");
 }
 
 void show_stack(struct task_struct *task, unsigned long *stack)
@@ -978,16 +948,16 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 	}
 	endstack = (unsigned long *)(((unsigned long)stack + THREAD_SIZE - 1) & -THREAD_SIZE);
 
-	printk("Stack from %08lx:", (unsigned long)stack);
+	pr_info("Stack from %08lx:", (unsigned long)stack);
 	p = stack;
 	for (i = 0; i < kstack_depth_to_print; i++) {
 		if (p + 1 > endstack)
 			break;
 		if (i % 8 == 0)
-			printk("\n       ");
-		printk(" %08lx", *p++);
+			pr_cont("\n       ");
+		pr_cont(" %08lx", *p++);
 	}
-	printk("\n");
+	pr_cont("\n");
 	show_trace(stack);
 }
 
@@ -1005,32 +975,32 @@ void bad_super_trap (struct frame *fp)
 
 	console_verbose();
 	if (vector < ARRAY_SIZE(vec_names))
-		printk ("*** %s ***   FORMAT=%X\n",
+		pr_err("*** %s ***   FORMAT=%X\n",
 			vec_names[vector],
 			fp->ptregs.format);
 	else
-		printk ("*** Exception %d ***   FORMAT=%X\n",
+		pr_err("*** Exception %d ***   FORMAT=%X\n",
 			vector, fp->ptregs.format);
 	if (vector == VEC_ADDRERR && CPU_IS_020_OR_030) {
 		unsigned short ssw = fp->un.fmtb.ssw;
 
-		printk ("SSW=%#06x  ", ssw);
+		pr_err("SSW=%#06x  ", ssw);
 
 		if (ssw & RC)
-			printk ("Pipe stage C instruction fault at %#010lx\n",
+			pr_err("Pipe stage C instruction fault at %#010lx\n",
 				(fp->ptregs.format) == 0xA ?
 				fp->ptregs.pc + 2 : fp->un.fmtb.baddr - 2);
 		if (ssw & RB)
-			printk ("Pipe stage B instruction fault at %#010lx\n",
+			pr_err("Pipe stage B instruction fault at %#010lx\n",
 				(fp->ptregs.format) == 0xA ?
 				fp->ptregs.pc + 4 : fp->un.fmtb.baddr);
 		if (ssw & DF)
-			printk ("Data %s fault at %#010lx in %s (pc=%#lx)\n",
+			pr_err("Data %s fault at %#010lx in %s (pc=%#lx)\n",
 				ssw & RW ? "read" : "write",
 				fp->un.fmtb.daddr, space_names[ssw & DFC],
 				fp->ptregs.pc);
 	}
-	printk ("Current process id is %d\n", task_pid_nr(current));
+	pr_err("Current process id is %d\n", task_pid_nr(current));
 	die_if_kernel("BAD KERNEL TRAP", &fp->ptregs, 0);
 }
 
@@ -1162,7 +1132,7 @@ void die_if_kernel (char *str, struct pt_regs *fp, int nr)
 		return;
 
 	console_verbose();
-	printk("%s: %08x\n",str,nr);
+	pr_crit("%s: %08x\n", str, nr);
 	show_registers(fp);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
 	do_exit(SIGSEGV);
-- 
1.7.9.5

