Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3IKF1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:27:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab3IKE5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:25 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=jD3GpYgDkRwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=on9A85mscvoA:10 a=drOt6m5kAAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=DD9uoUFLPhUvRMlZd7oA:9 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=gzQFJSC74NTI_W8x:21 a=ZeZaF3KfvYI8Xqha:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042912.392962994@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [121/251] ARM: move vector stubs
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0121-ARM-move-vector-stubs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

[ Upstream commit 19accfd373847ac3d10623c5d20f948846299741 ]

Move the machine vector stubs into the page above the vector page,
which we can prevent from being visible to userspace.  Also move
the reset stub, and place the swi vector at a location that the
'ldr' can get to it.

This hides pointers into the kernel which could give valuable
information to attackers, and reduces the number of exploitable
instructions at a fixed address.

Cc: <stable@vger.kernel.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/Kconfig             |    3 ++-
 arch/arm/kernel/entry-armv.S |   50 ++++++++++++++++++++----------------------
 arch/arm/kernel/traps.c      |    4 ++--
 arch/arm/mm/mmu.c            |   10 ++++++++-
 4 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 589bdba..ca5e665 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -183,7 +183,8 @@ config VECTORS_BASE
 	default DRAM_BASE if REMAP_VECTORS_TO_RAM
 	default 0x00000000
 	help
-	  The base address of exception vectors.
+	  The base address of exception vectors.  This must be two pages
+	  in size.
 
 config ARM_PATCH_PHYS_VIRT
 	bool "Patch physical to virtual translations at runtime" if EMBEDDED
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 9c80c1d..a4af8e8 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -986,9 +986,9 @@ __kuser_helper_end:
 /*
  * Vector stubs.
  *
- * This code is copied to 0xffff0200 so we can use branches in the
- * vectors, rather than ldr's.  Note that this code must not
- * exceed 0x300 bytes.
+ * This code is copied to 0xffff1000 so we can use branches in the
+ * vectors, rather than ldr's.  Note that this code must not exceed
+ * a page size.
  *
  * Common stub entry macro:
  *   Enter in IRQ mode, spsr = SVC/USR CPSR, lr = SVC/USR PC
@@ -1037,6 +1037,15 @@ ENDPROC(vector_\name)
 
 	.globl	__stubs_start
 __stubs_start:
+	@ This must be the first word
+	.word	vector_swi
+
+vector_rst:
+ ARM(	swi	SYS_ERROR0	)
+ THUMB(	svc	#0		)
+ THUMB(	nop			)
+	b	vector_und
+
 /*
  * Interrupt dispatcher
  */
@@ -1131,6 +1140,16 @@ __stubs_start:
 	.align	5
 
 /*=============================================================================
+ * Address exception handler
+ *-----------------------------------------------------------------------------
+ * These aren't too critical.
+ * (they're not supposed to happen, and won't happen in 32-bit data mode).
+ */
+
+vector_addrexcptn:
+	b	vector_addrexcptn
+
+/*=============================================================================
  * Undefined FIQs
  *-----------------------------------------------------------------------------
  * Enter in FIQ mode, spsr = ANY CPSR, lr = ANY PC
@@ -1143,35 +1162,14 @@ __stubs_start:
 vector_fiq:
 	subs	pc, lr, #4
 
-/*=============================================================================
- * Address exception handler
- *-----------------------------------------------------------------------------
- * These aren't too critical.
- * (they're not supposed to happen, and won't happen in 32-bit data mode).
- */
-
-vector_addrexcptn:
-	b	vector_addrexcptn
-
-/*
- * We group all the following data together to optimise
- * for CPUs with separate I & D caches.
- */
-	.align	5
-
-.LCvswi:
-	.word	vector_swi
-
 	.globl	__stubs_end
 __stubs_end:
 
-	.equ	stubs_offset, __vectors_start + 0x200 - __stubs_start
+	.equ	stubs_offset, __vectors_start + 0x1000 - __stubs_start
 
 	.globl	__vectors_start
 __vectors_start:
- ARM(	swi	SYS_ERROR0	)
- THUMB(	svc	#0		)
- THUMB(	nop			)
+	W(b)	vector_rst + stubs_offset
 	W(b)	vector_und + stubs_offset
 	W(ldr)	pc, .LCvswi + stubs_offset
 	W(b)	vector_pabt + stubs_offset
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index a4f84b0..366aa93 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -843,7 +843,7 @@ void __init early_trap_init(void *vectors_base)
 	 * are visible to the instruction stream.
 	 */
 	memcpy((void *)vectors, __vectors_start, __vectors_end - __vectors_start);
-	memcpy((void *)vectors + 0x200, __stubs_start, __stubs_end - __stubs_start);
+	memcpy((void *)vectors + 0x1000, __stubs_start, __stubs_end - __stubs_start);
 	memcpy((void *)vectors + 0x1000 - kuser_sz, __kuser_helper_start, kuser_sz);
 
 	/*
@@ -858,6 +858,6 @@ void __init early_trap_init(void *vectors_base)
 	memcpy((void *)(vectors + KERN_SIGRETURN_CODE - CONFIG_VECTORS_BASE),
 	       sigreturn_codes, sizeof(sigreturn_codes));
 
-	flush_icache_range(vectors, vectors + PAGE_SIZE);
+	flush_icache_range(vectors, vectors + PAGE_SIZE * 2);
 	modify_domain(DOMAIN_USER, DOMAIN_CLIENT);
 }
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index c2fa21d..889f3de 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1080,7 +1080,7 @@ static void __init devicemaps_init(struct machine_desc *mdesc)
 	/*
 	 * Allocate the vector page early.
 	 */
-	vectors = early_alloc(PAGE_SIZE);
+	vectors = early_alloc(PAGE_SIZE * 2);
 
 	early_trap_init(vectors);
 
@@ -1130,10 +1130,18 @@ static void __init devicemaps_init(struct machine_desc *mdesc)
 
 	if (!vectors_high()) {
 		map.virtual = 0;
+		map.length = PAGE_SIZE * 2;
 		map.type = MT_LOW_VECTORS;
 		create_mapping(&map);
 	}
 
+	/* Now create a kernel read-only mapping */
+	map.pfn += 1;
+	map.virtual = 0xffff0000 + PAGE_SIZE;
+	map.length = PAGE_SIZE;
+	map.type = MT_LOW_VECTORS;
+	create_mapping(&map);
+
 	/*
 	 * Ask the machine support to map in the statically mapped devices.
 	 */
-- 
1.7.10.4


