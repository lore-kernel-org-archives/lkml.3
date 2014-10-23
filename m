Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaJWVYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:24:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43910 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaJWVYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:24:50 -0400
Date: Thu, 23 Oct 2014 17:22:58 -0400 (EDT)
Message-Id: <20141023.172258.1371479087269518956.davem@davemloft.net>
To: mroos@linux.ee
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141023.130258.548864295965807596.davem@davemloft.net>
References: <20141022.163949.1761351331649936601.davem@davemloft.net>
	<alpine.LRH.2.11.1410230221360.28745@adalberg.ut.ee>
	<20141023.130258.548864295965807596.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Oct 2014 14:24:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 23 Oct 2014 13:02:58 -0400 (EDT)

> From: Meelis Roos <mroos@linux.ee>
> Date: Thu, 23 Oct 2014 02:22:36 +0300 (EEST)
> 
>>> Whilst I don't have access to my reproducer machine until tomorrow in
>>> order to test this myself, I wanted to toss this patch your way so you
>>> could get a head start on me.
>> 
>> Unfortunately it fails earlier during the boot:
>> 
>> [   25.232318] clocksource: mult[53555555] shift[24]
>> [   25.288559] clockevent: mult[3126e98] shift[32]
>> [   25.342813] Console: colour dummy device 80x25
>> [   25.395990] console [tty0] enabled
>> [   25.436726] bootconsole [earlyprom0] disabled
>> ERROR: Last Trap: Memory Address not Aligned
>> 
>> ok
> 
> I can reproduce and I know what the problem is, fixed patch coming up
> shortly.

Ok, please test this patch below.

I tested the full matrix of pre-gcc-4.9, gcc-4.9, hypervisor boot
without HOTPLUG_CPU enabled, hypervisor boot with HOTPLUG_CPU enabled,
pre-hypervisor boot.

====================
[PATCH] sparc64: Fix register corruption in top-most kernel stack frame during boot.

Meelis Roos reported that kernels built with gcc-4.9 do not boot, we
eventually narrowed this down to only impacting machines using
UltraSPARC-III and derivitive cpus.

The crash happens right when the first user process is spawned:

[   54.451346] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000004
[   54.451346]
[   54.571516] CPU: 1 PID: 1 Comm: init Not tainted 3.16.0-rc2-00211-gd7933ab #96
[   54.666431] Call Trace:
[   54.698453]  [0000000000762f8c] panic+0xb0/0x224
[   54.759071]  [000000000045cf68] do_exit+0x948/0x960
[   54.823123]  [000000000042cbc0] fault_in_user_windows+0xe0/0x100
[   54.902036]  [0000000000404ad0] __handle_user_windows+0x0/0x10
[   54.978662] Press Stop-A (L1-A) to return to the boot prom
[   55.050713] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000004

Further investigation showed that compiling only per_cpu_patch() with
an older compiler fixes the boot.

Detailed analysis showed that the function is not being miscompiled by
gcc-4.9, but it is using a different register allocation ordering.

With the gcc-4.9 compiled function, something during the code patching
causes some of the %i* input registers to get corrupted.  Perhaps
we have a TLB miss path into the firmware that is deep enough to
cause a register window spill and subsequent restore when we get
back from the TLB miss trap.

Let's plug this up by doing two things:

1) Stop using the firmware stack for client interface calls into
   the firmware.  Just use the kernel's stack.

2) As soon as we can, call into a new function "start_early_boot()"
   to put a one-register-window buffer between the firmware's
   deepest stack frame and the top-most initial kernel one.

Reported-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/oplib_64.h |  3 ++-
 arch/sparc/kernel/entry.h         |  3 ---
 arch/sparc/kernel/head_64.S       | 38 +-------------------------------------
 arch/sparc/kernel/hvtramp.S       |  1 -
 arch/sparc/kernel/setup_64.c      | 28 ++++++++++++++++++++--------
 arch/sparc/kernel/trampoline_64.S | 12 +++++++-----
 arch/sparc/prom/cif.S             |  5 ++---
 arch/sparc/prom/init_64.c         |  6 +++---
 arch/sparc/prom/p1275.c           |  2 --
 9 files changed, 35 insertions(+), 63 deletions(-)

diff --git a/arch/sparc/include/asm/oplib_64.h b/arch/sparc/include/asm/oplib_64.h
index f346824..2e3a4ad 100644
--- a/arch/sparc/include/asm/oplib_64.h
+++ b/arch/sparc/include/asm/oplib_64.h
@@ -62,7 +62,8 @@ struct linux_mem_p1275 {
 /* You must call prom_init() before using any of the library services,
  * preferably as early as possible.  Pass it the romvec pointer.
  */
-void prom_init(void *cif_handler, void *cif_stack);
+void prom_init(void *cif_handler);
+void prom_init_report(void);
 
 /* Boot argument acquisition, returns the boot command line string. */
 char *prom_getbootargs(void);
diff --git a/arch/sparc/kernel/entry.h b/arch/sparc/kernel/entry.h
index ebaba61..88d322b 100644
--- a/arch/sparc/kernel/entry.h
+++ b/arch/sparc/kernel/entry.h
@@ -65,13 +65,10 @@ struct pause_patch_entry {
 extern struct pause_patch_entry __pause_3insn_patch,
 	__pause_3insn_patch_end;
 
-void __init per_cpu_patch(void);
 void sun4v_patch_1insn_range(struct sun4v_1insn_patch_entry *,
 			     struct sun4v_1insn_patch_entry *);
 void sun4v_patch_2insn_range(struct sun4v_2insn_patch_entry *,
 			     struct sun4v_2insn_patch_entry *);
-void __init sun4v_patch(void);
-void __init boot_cpu_id_too_large(int cpu);
 extern unsigned int dcache_parity_tl1_occurred;
 extern unsigned int icache_parity_tl1_occurred;
 
diff --git a/arch/sparc/kernel/head_64.S b/arch/sparc/kernel/head_64.S
index 4fdeb80..43e27ce 100644
--- a/arch/sparc/kernel/head_64.S
+++ b/arch/sparc/kernel/head_64.S
@@ -672,14 +672,12 @@ tlb_fixup_done:
 	sethi	%hi(init_thread_union), %g6
 	or	%g6, %lo(init_thread_union), %g6
 	ldx	[%g6 + TI_TASK], %g4
-	mov	%sp, %l6
 
 	wr	%g0, ASI_P, %asi
 	mov	1, %g1
 	sllx	%g1, THREAD_SHIFT, %g1
 	sub	%g1, (STACKFRAME_SZ + STACK_BIAS), %g1
 	add	%g6, %g1, %sp
-	mov	0, %fp
 
 	/* Set per-cpu pointer initially to zero, this makes
 	 * the boot-cpu use the in-kernel-image per-cpu areas
@@ -706,44 +704,10 @@ tlb_fixup_done:
 	 nop
 #endif
 
-	mov	%l6, %o1			! OpenPROM stack
 	call	prom_init
 	 mov	%l7, %o0			! OpenPROM cif handler
 
-	/* Initialize current_thread_info()->cpu as early as possible.
-	 * In order to do that accurately we have to patch up the get_cpuid()
-	 * assembler sequences.  And that, in turn, requires that we know
-	 * if we are on a Starfire box or not.  While we're here, patch up
-	 * the sun4v sequences as well.
-	 */
-	call	check_if_starfire
-	 nop
-	call	per_cpu_patch
-	 nop
-	call	sun4v_patch
-	 nop
-
-#ifdef CONFIG_SMP
-	call	hard_smp_processor_id
-	 nop
-	cmp	%o0, NR_CPUS
-	blu,pt	%xcc, 1f
-	 nop
-	call	boot_cpu_id_too_large
-	 nop
-	/* Not reached... */
-
-1:
-#else
-	mov	0, %o0
-#endif
-	sth	%o0, [%g6 + TI_CPU]
-
-	call	prom_init_report
-	 nop
-
-	/* Off we go.... */
-	call	start_kernel
+	call start_early_boot
 	 nop
 	/* Not reached... */
 
diff --git a/arch/sparc/kernel/hvtramp.S b/arch/sparc/kernel/hvtramp.S
index b7ddcdd..cdbfec2 100644
--- a/arch/sparc/kernel/hvtramp.S
+++ b/arch/sparc/kernel/hvtramp.S
@@ -109,7 +109,6 @@ hv_cpu_startup:
 	sllx		%g5, THREAD_SHIFT, %g5
 	sub		%g5, (STACKFRAME_SZ + STACK_BIAS), %g5
 	add		%g6, %g5, %sp
-	mov		0, %fp
 
 	call		init_irqwork_curcpu
 	 nop
diff --git a/arch/sparc/kernel/setup_64.c b/arch/sparc/kernel/setup_64.c
index e629b83..c38d19f 100644
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -30,6 +30,7 @@
 #include <linux/cpu.h>
 #include <linux/initrd.h>
 #include <linux/module.h>
+#include <linux/start_kernel.h>
 
 #include <asm/io.h>
 #include <asm/processor.h>
@@ -162,7 +163,7 @@ char reboot_command[COMMAND_LINE_SIZE];
 
 static struct pt_regs fake_swapper_regs = { { 0, }, 0, 0, 0, 0 };
 
-void __init per_cpu_patch(void)
+static void __init per_cpu_patch(void)
 {
 	struct cpuid_patch_entry *p;
 	unsigned long ver;
@@ -254,7 +255,7 @@ void sun4v_patch_2insn_range(struct sun4v_2insn_patch_entry *start,
 	}
 }
 
-void __init sun4v_patch(void)
+static void __init sun4v_patch(void)
 {
 	extern void sun4v_hvapi_init(void);
 
@@ -323,14 +324,25 @@ static void __init pause_patch(void)
 	}
 }
 
-#ifdef CONFIG_SMP
-void __init boot_cpu_id_too_large(int cpu)
+void __init start_early_boot(void)
 {
-	prom_printf("Serious problem, boot cpu id (%d) >= NR_CPUS (%d)\n",
-		    cpu, NR_CPUS);
-	prom_halt();
+	int cpu;
+
+	check_if_starfire();
+	per_cpu_patch();
+	sun4v_patch();
+
+	cpu = hard_smp_processor_id();
+	if (cpu >= NR_CPUS) {
+		prom_printf("Serious problem, boot cpu id (%d) >= NR_CPUS (%d)\n",
+			    cpu, NR_CPUS);
+		prom_halt();
+	}
+	current_thread_info()->cpu = cpu;
+
+	prom_init_report();
+	start_kernel();
 }
-#endif
 
 /* On Ultra, we support all of the v8 capabilities. */
 unsigned long sparc64_elf_hwcap = (HWCAP_SPARC_FLUSH | HWCAP_SPARC_STBAR |
diff --git a/arch/sparc/kernel/trampoline_64.S b/arch/sparc/kernel/trampoline_64.S
index 737f8cb..88ede1d 100644
--- a/arch/sparc/kernel/trampoline_64.S
+++ b/arch/sparc/kernel/trampoline_64.S
@@ -109,10 +109,13 @@ startup_continue:
 	brnz,pn		%g1, 1b
 	 nop
 
-	sethi		%hi(p1275buf), %g2
-	or		%g2, %lo(p1275buf), %g2
-	ldx		[%g2 + 0x10], %l2
-	add		%l2, -(192 + 128), %sp
+	/* Get onto temporary stack which will be in the locked
+	 * kernel image.
+	 */
+	sethi		%hi(tramp_stack), %g1
+	or		%g1, %lo(tramp_stack), %g1
+	add		%g1, TRAMP_STACK_SIZE, %g1
+	sub		%g1, STACKFRAME_SZ + STACK_BIAS + 256, %sp
 	flushw
 
 	/* Setup the loop variables:
@@ -394,7 +397,6 @@ after_lock_tlb:
 	sllx		%g5, THREAD_SHIFT, %g5
 	sub		%g5, (STACKFRAME_SZ + STACK_BIAS), %g5
 	add		%g6, %g5, %sp
-	mov		0, %fp
 
 	rdpr		%pstate, %o1
 	or		%o1, PSTATE_IE, %o1
diff --git a/arch/sparc/prom/cif.S b/arch/sparc/prom/cif.S
index 9c86b4b..8050f38 100644
--- a/arch/sparc/prom/cif.S
+++ b/arch/sparc/prom/cif.S
@@ -11,11 +11,10 @@
 	.text
 	.globl	prom_cif_direct
 prom_cif_direct:
+	save	%sp, -192, %sp
 	sethi	%hi(p1275buf), %o1
 	or	%o1, %lo(p1275buf), %o1
-	ldx	[%o1 + 0x0010], %o2	! prom_cif_stack
-	save	%o2, -192, %sp
-	ldx	[%i1 + 0x0008], %l2	! prom_cif_handler
+	ldx	[%o1 + 0x0008], %l2	! prom_cif_handler
 	mov	%g4, %l0
 	mov	%g5, %l1
 	mov	%g6, %l3
diff --git a/arch/sparc/prom/init_64.c b/arch/sparc/prom/init_64.c
index d95db75..110b0d7 100644
--- a/arch/sparc/prom/init_64.c
+++ b/arch/sparc/prom/init_64.c
@@ -26,13 +26,13 @@ phandle prom_chosen_node;
  * It gets passed the pointer to the PROM vector.
  */
 
-extern void prom_cif_init(void *, void *);
+extern void prom_cif_init(void *);
 
-void __init prom_init(void *cif_handler, void *cif_stack)
+void __init prom_init(void *cif_handler)
 {
 	phandle node;
 
-	prom_cif_init(cif_handler, cif_stack);
+	prom_cif_init(cif_handler);
 
 	prom_chosen_node = prom_finddevice(prom_chosen_path);
 	if (!prom_chosen_node || (s32)prom_chosen_node == -1)
diff --git a/arch/sparc/prom/p1275.c b/arch/sparc/prom/p1275.c
index b2340f0..545d8bb 100644
--- a/arch/sparc/prom/p1275.c
+++ b/arch/sparc/prom/p1275.c
@@ -20,7 +20,6 @@
 struct {
 	long prom_callback;			/* 0x00 */
 	void (*prom_cif_handler)(long *);	/* 0x08 */
-	unsigned long prom_cif_stack;		/* 0x10 */
 } p1275buf;
 
 extern void prom_world(int);
@@ -52,5 +51,4 @@ void p1275_cmd_direct(unsigned long *args)
 void prom_cif_init(void *cif_handler, void *cif_stack)
 {
 	p1275buf.prom_cif_handler = (void (*)(long *))cif_handler;
-	p1275buf.prom_cif_stack = (unsigned long)cif_stack;
 }
-- 
1.8.1.2

