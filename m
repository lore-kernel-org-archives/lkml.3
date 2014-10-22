Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058AbaJVUjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:39:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33157 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554AbaJVUjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:39:51 -0400
Date: Wed, 22 Oct 2014 16:39:49 -0400 (EDT)
Message-Id: <20141022.163949.1761351331649936601.davem@davemloft.net>
To: mroos@linux.ee
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141020.145746.428441452740929005.davem@davemloft.net>
References: <20141019.003209.2286339581794609198.davem@davemloft.net>
	<alpine.LRH.2.11.1410191006430.32417@adalberg.ut.ee>
	<20141020.145746.428441452740929005.davem@davemloft.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Oct 2014 13:39:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 20 Oct 2014 14:57:46 -0400 (EDT)

> Just an update, I have an environment where I can perfectly reproduce
> this.  I have a gcc-4.9 SVN built that compiles kernels which crash
> the same way it does for you.
> 
> I'll let you know when I make more progress.

Whilst I don't have access to my reproducer machine until tomorrow in
order to test this myself, I wanted to toss this patch your way so you
could get a head start on me.

The issue is not that gcc-4.9 miscompiles anything, the issue is that
we had an existing bug that is exposed by gcc-4.9 simply allocating
registers in a different order.

per_cpu_patch() is the function that matters.  I verified this by
pulling that function out of setup_64.c and into it's own separate
foo.c file, and only building that source file with gcc-4.9

I poured over the assembler several times over the course of a day or
so, and I'm pretty sure the generated code is fine.  I even extracted
the assembler into a userland test-case and stepped through it for
the code paths that Ultra-III systems trigger.

What happens is that the inner-most registers are corrupted by the
first one of the TLB misses triggered by this code patching.  These
TLB misses are serviced by the firmware because we are still using the
firmware's trap table this early on, and if the code path in the
firmware to service that TLB miss is deep enough we get a register
spill.

This is the top-most of the initial kernel stack's call chain, the
per_cpu_patch() function is invoked right from head_64.S.

What we've traditionally done is save away the firmware's stack
pointer, and jump onto that stack when we make firmware calls.  But
there is absolutely no reason to do that, and it means that by doing
so we have always risked modifying registers erroneously at that
boundary at the top of the initial kernel stack.

So let's get rid of the CIF stack, and just call into the firwmare
using the normal kernel stack.

diff --git a/arch/sparc/include/asm/oplib_64.h b/arch/sparc/include/asm/oplib_64.h
index f346824..741f24a 100644
--- a/arch/sparc/include/asm/oplib_64.h
+++ b/arch/sparc/include/asm/oplib_64.h
@@ -62,7 +62,7 @@ struct linux_mem_p1275 {
 /* You must call prom_init() before using any of the library services,
  * preferably as early as possible.  Pass it the romvec pointer.
  */
-void prom_init(void *cif_handler, void *cif_stack);
+void prom_init(void *cif_handler);
 
 /* Boot argument acquisition, returns the boot command line string. */
 char *prom_getbootargs(void);
diff --git a/arch/sparc/kernel/head_64.S b/arch/sparc/kernel/head_64.S
index 4fdeb80..b8d67c5 100644
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
@@ -706,7 +704,6 @@ tlb_fixup_done:
 	 nop
 #endif
 
-	mov	%l6, %o1			! OpenPROM stack
 	call	prom_init
 	 mov	%l7, %o0			! OpenPROM cif handler
 
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
