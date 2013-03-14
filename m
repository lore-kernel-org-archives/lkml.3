Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab3CNWNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:13:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64747 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab3CNWMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:12:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@vger.kernel.org
Cc: patches@linaro.org, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/6] ARM: remove fa526 CPU support
Date: Thu, 14 Mar 2013 23:12:05 +0100
Message-Id: <1363299128-8192-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363299128-8192-1-git-send-email-arnd@arndb.de>
References: <1363299128-8192-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:901GSdjFa4oKHWUU9/CYepaCZFDb6we9RP/M71zWAI5
 lr60iUbuuHnssnetg9G19AOa4g1Vh3a8gUEJAdryUdTPY1fS98
 W2Z6vW5+4gXxv+p742DMb8t3a3qkHx7fEPfJfNcv3JBYRCpMNj
 5zeR+i1eyVAyZFymnfG0yT0UfNWWrUGvFCZHyxMsMt1mwHm/YM
 Qpjv95r8Nc7Yg5YG3bTNEJAOFVOypS40utOqaYHvMivZmHatVr
 WSMXlbXRokmmpxjadYxaiFD18j3x9CIrm20lA0oN9oAMOtsMa4
 Qvqmw1RcRjNdt1oQfHUvM6E7jINsAdVpp6hlC5iotBhNNN/Ee4
 5HDBCP2/7Deo0etFdbDB1l+WtZi7Vg2FIUmQEKzkZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the Cortina Gemini platform gone, nothing in ARM uses
the Faraday 526 CPU core support any more. There is at least
one other platform using this (Moschip MCS814x), but the
efforts to get that merged into mainline appear to have
stalled.

If someone still needs this code, please speak up now,
otherwise we will remove it now. Of course there is
always the option to revert this patch if we need it
again later.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 MAINTAINERS                       |   7 --
 arch/arm/Kconfig                  |   2 +-
 arch/arm/Makefile                 |   1 -
 arch/arm/boot/compressed/head.S   |  28 -----
 arch/arm/include/asm/barrier.h    |   6 -
 arch/arm/include/asm/glue-cache.h |   8 --
 arch/arm/include/asm/glue-proc.h  |   9 --
 arch/arm/include/asm/page.h       |   8 --
 arch/arm/include/asm/tlbflush.h   |  19 ---
 arch/arm/mm/Kconfig               |  32 +----
 arch/arm/mm/Makefile              |   4 -
 arch/arm/mm/cache-fa.S            | 249 --------------------------------------
 arch/arm/mm/copypage-fa.c         |  86 -------------
 arch/arm/mm/proc-fa526.S          | 221 ---------------------------------
 arch/arm/mm/tlb-fa.S              |  69 -----------
 15 files changed, 3 insertions(+), 746 deletions(-)
 delete mode 100644 arch/arm/mm/cache-fa.S
 delete mode 100644 arch/arm/mm/copypage-fa.c
 delete mode 100644 arch/arm/mm/proc-fa526.S
 delete mode 100644 arch/arm/mm/tlb-fa.S

diff --git a/MAINTAINERS b/MAINTAINERS
index 4b59496..f23d90f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -813,13 +813,6 @@ S:	Maintained
 T:	topgit git://git.openezx.org/openezx.git
 F:	arch/arm/mach-pxa/ezx.c
 
-ARM/FARADAY FA526 PORT
-M:	Hans Ulli Kroll <ulli.kroll@googlemail.com>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-T:	git git://git.berlios.de/gemini-board
-F:	arch/arm/mm/*-fa*
-
 ARM/FOOTBRIDGE ARCHITECTURE
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b62699a..9d2e825 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -980,7 +980,7 @@ menu "Multiple platform selection"
 comment "CPU Core family selection"
 
 config ARCH_MULTI_V4
-	bool "ARMv4 based platforms (FA526, StrongARM)"
+	bool "ARMv4 based platforms (StrongARM)"
 	depends on !ARCH_MULTI_V6_V7
 	select ARCH_MULTI_V4_V5
 
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 50e755b..b514a0a 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -82,7 +82,6 @@ tune-$(CONFIG_CPU_ARM920T)	:=-mtune=arm9tdmi
 tune-$(CONFIG_CPU_ARM922T)	:=-mtune=arm9tdmi
 tune-$(CONFIG_CPU_ARM925T)	:=-mtune=arm9tdmi
 tune-$(CONFIG_CPU_ARM926T)	:=-mtune=arm9tdmi
-tune-$(CONFIG_CPU_FA526)	:=-mtune=arm9tdmi
 tune-$(CONFIG_CPU_SA110)	:=-mtune=strongarm110
 tune-$(CONFIG_CPU_SA1100)	:=-mtune=strongarm1100
 tune-$(CONFIG_CPU_XSCALE)	:=$(call cc-option,-mtune=xscale,-mtune=strongarm110) -Wa,-mcpu=xscale
diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index fe4d9c3..4e985f0 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -726,21 +726,6 @@ __armv7_mmu_cache_on:
 		mcr	p15, 0, r0, c7, c5, 4	@ ISB
 		mov	pc, r12
 
-__fa526_cache_on:
-		mov	r12, lr
-		mov	r6, #CB_BITS | 0x12	@ U
-		bl	__setup_mmu
-		mov	r0, #0
-		mcr	p15, 0, r0, c7, c7, 0	@ Invalidate whole cache
-		mcr	p15, 0, r0, c7, c10, 4	@ drain write buffer
-		mcr	p15, 0, r0, c8, c7, 0	@ flush UTLB
-		mrc	p15, 0, r0, c1, c0, 0	@ read control reg
-		orr	r0, r0, #0x1000		@ I-cache enable
-		bl	__common_mmu_cache_on
-		mov	r0, #0
-		mcr	p15, 0, r0, c8, c7, 0	@ flush UTLB
-		mov	pc, r12
-
 __common_mmu_cache_on:
 #ifndef CONFIG_THUMB2_KERNEL
 #ifndef DEBUG
@@ -898,12 +883,6 @@ proc_types:
 		b	__armv5tej_mmu_cache_flush
 #endif
 
-		.word	0x66015261		@ FA526
-		.word	0xff01fff1
-		W(b)	__fa526_cache_on
-		W(b)	__armv4_mmu_cache_off
-		W(b)	__fa526_cache_flush
-
 		@ These match on the architecture ID
 
 		.word	0x00020000		@ ARMv4T
@@ -1048,13 +1027,6 @@ __armv4_mpu_cache_flush:
 		mcr	p15, 0, ip, c7, c10, 4	@ drain WB
 		mov	pc, lr
 		
-__fa526_cache_flush:
-		mov	r1, #0
-		mcr	p15, 0, r1, c7, c14, 0	@ clean and invalidate D cache
-		mcr	p15, 0, r1, c7, c5, 0	@ flush I cache
-		mcr	p15, 0, r1, c7, c10, 4	@ drain WB
-		mov	pc, lr
-
 __armv6_mmu_cache_flush:
 		mov	r1, #0
 		mcr	p15, 0, r1, c7, c14, 0	@ clean+invalidate D
diff --git a/arch/arm/include/asm/barrier.h b/arch/arm/include/asm/barrier.h
index 8dcd9c7..7158a84 100644
--- a/arch/arm/include/asm/barrier.h
+++ b/arch/arm/include/asm/barrier.h
@@ -24,12 +24,6 @@
 				    : : "r" (0) : "memory")
 #define dmb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 5" \
 				    : : "r" (0) : "memory")
-#elif defined(CONFIG_CPU_FA526)
-#define isb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c5, 4" \
-				    : : "r" (0) : "memory")
-#define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" \
-				    : : "r" (0) : "memory")
-#define dmb() __asm__ __volatile__ ("" : : : "memory")
 #else
 #define isb() __asm__ __volatile__ ("" : : : "memory")
 #define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" \
diff --git a/arch/arm/include/asm/glue-cache.h b/arch/arm/include/asm/glue-cache.h
index cca9f15..adc0955 100644
--- a/arch/arm/include/asm/glue-cache.h
+++ b/arch/arm/include/asm/glue-cache.h
@@ -41,14 +41,6 @@
 # define MULTI_CACHE 1
 #endif
 
-#if defined(CONFIG_CPU_FA526)
-# ifdef _CACHE
-#  define MULTI_CACHE 1
-# else
-#  define _CACHE fa
-# endif
-#endif
-
 #if defined(CONFIG_CPU_ARM926T)
 # ifdef _CACHE
 #  define MULTI_CACHE 1
diff --git a/arch/arm/include/asm/glue-proc.h b/arch/arm/include/asm/glue-proc.h
index ac1dd54..8e42e0d 100644
--- a/arch/arm/include/asm/glue-proc.h
+++ b/arch/arm/include/asm/glue-proc.h
@@ -77,15 +77,6 @@
 # endif
 #endif
 
-#ifdef CONFIG_CPU_FA526
-# ifdef CPU_NAME
-#  undef  MULTI_CPU
-#  define MULTI_CPU
-# else
-#  define CPU_NAME cpu_fa526
-# endif
-#endif
-
 #ifdef CONFIG_CPU_ARM925T
 # ifdef CPU_NAME
 #  undef  MULTI_CPU
diff --git a/arch/arm/include/asm/page.h b/arch/arm/include/asm/page.h
index 812a494..15595fa 100644
--- a/arch/arm/include/asm/page.h
+++ b/arch/arm/include/asm/page.h
@@ -67,14 +67,6 @@
 # endif
 #endif
 
-#ifdef CONFIG_CPU_COPY_FA
-# ifdef _USER
-#  define MULTI_USER 1
-# else
-#  define _USER fa
-# endif
-#endif
-
 #ifdef CONFIG_CPU_SA1100
 # ifdef _USER
 #  define MULTI_USER 1
diff --git a/arch/arm/include/asm/tlbflush.h b/arch/arm/include/asm/tlbflush.h
index 4db8c88..7d4a918d 100644
--- a/arch/arm/include/asm/tlbflush.h
+++ b/arch/arm/include/asm/tlbflush.h
@@ -57,7 +57,6 @@
  *	  v4wb  - ARMv4 with write buffer without I TLB flush entry instruction
  *	  v4wbi - ARMv4 with write buffer with I TLB flush entry instruction
  *	  fr    - Feroceon (v4wbi with non-outer-cacheable page table walks)
- *	  fa    - Faraday (v4 with write buffer with UTLB)
  *	  v6wbi - ARMv6 with write buffer with I TLB flush entry instruction
  *	  v7wbi - identical to v6wbi
  */
@@ -83,22 +82,6 @@
 # define v4_always_flags	(-1UL)
 #endif
 
-#define fa_tlb_flags	(TLB_WB | TLB_DCLEAN | TLB_BARRIER | \
-			 TLB_V4_U_FULL | TLB_V4_U_PAGE)
-
-#ifdef CONFIG_CPU_TLB_FA
-# define fa_possible_flags	fa_tlb_flags
-# define fa_always_flags	fa_tlb_flags
-# ifdef _TLB
-#  define MULTI_TLB 1
-# else
-#  define _TLB fa
-# endif
-#else
-# define fa_possible_flags	0
-# define fa_always_flags	(-1UL)
-#endif
-
 #define v4wbi_tlb_flags	(TLB_WB | TLB_DCLEAN | \
 			 TLB_V4_I_FULL | TLB_V4_D_FULL | \
 			 TLB_V4_I_PAGE | TLB_V4_D_PAGE)
@@ -293,7 +276,6 @@ extern struct cpu_tlb_fns cpu_tlb;
 				 v4wbi_possible_flags | \
 				 fr_possible_flags | \
 				 v4wb_possible_flags | \
-				 fa_possible_flags | \
 				 v6wbi_possible_flags | \
 				 v7wbi_possible_flags)
 
@@ -301,7 +283,6 @@ extern struct cpu_tlb_fns cpu_tlb;
 				 v4wbi_always_flags & \
 				 fr_always_flags & \
 				 v4wb_always_flags & \
-				 fa_always_flags & \
 				 v6wbi_always_flags & \
 				 v7wbi_always_flags)
 
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 025d173..aa878d4 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -143,24 +143,6 @@ config CPU_ARM926T
 	  Say Y if you want support for the ARM926T processor.
 	  Otherwise, say N.
 
-# FA526
-config CPU_FA526
-	bool
-	select CPU_32v4
-	select CPU_ABRT_EV4
-	select CPU_CACHE_FA
-	select CPU_CACHE_VIVT
-	select CPU_COPY_FA if MMU
-	select CPU_CP15_MMU
-	select CPU_PABRT_LEGACY
-	select CPU_TLB_FA if MMU
-	help
-	  The FA526 is a version of the ARMv4 compatible processor with
-	  Branch Target Buffer, Unified TLB and cache line size 16.
-
-	  Say Y if you want support for the FA526 processor.
-	  Otherwise, say N.
-
 # ARM940T
 config CPU_ARM940T
 	bool "Support ARM940T processor" if ARCH_INTEGRATOR
@@ -507,9 +489,6 @@ config CPU_COPY_V4WB
 config CPU_COPY_FEROCEON
 	bool
 
-config CPU_COPY_FA
-	bool
-
 config CPU_COPY_V6
 	bool
 
@@ -535,13 +514,6 @@ config CPU_TLB_FEROCEON
 	help
 	  Feroceon TLB (v4wbi with non-outer-cachable page table walks).
 
-config CPU_TLB_FA
-	bool
-	help
-	  Faraday ARM FA526 architecture, unified TLB with writeback cache
-	  and invalidate instruction cache entry. Branch target buffer is
-	  also supported.
-
 config CPU_TLB_V6
 	bool
 
@@ -731,7 +703,7 @@ config CPU_DCACHE_SIZE
 
 config CPU_DCACHE_WRITETHROUGH
 	bool "Force write through D-cache"
-	depends on (CPU_ARM740T || CPU_ARM920T || CPU_ARM922T || CPU_ARM925T || CPU_ARM926T || CPU_ARM940T || CPU_ARM946E || CPU_ARM1020 || CPU_FA526) && !CPU_DCACHE_DISABLE
+	depends on (CPU_ARM740T || CPU_ARM920T || CPU_ARM922T || CPU_ARM925T || CPU_ARM926T || CPU_ARM940T || CPU_ARM946E || CPU_ARM1020) && !CPU_DCACHE_DISABLE
 	default y if CPU_ARM925T
 	help
 	  Say Y here to use the data cache in writethrough mode. Unless you
@@ -746,7 +718,7 @@ config CPU_CACHE_ROUND_ROBIN
 
 config CPU_BPREDICT_DISABLE
 	bool "Disable branch prediction"
-	depends on CPU_ARM1020 || CPU_V6 || CPU_V6K || CPU_MOHAWK || CPU_XSC3 || CPU_V7 || CPU_FA526
+	depends on CPU_ARM1020 || CPU_V6 || CPU_V6K || CPU_MOHAWK || CPU_XSC3 || CPU_V7
 	help
 	  Say Y here to disable branch prediction.  If unsure, say N.
 
diff --git a/arch/arm/mm/Makefile b/arch/arm/mm/Makefile
index 4e333fa..b714ad6 100644
--- a/arch/arm/mm/Makefile
+++ b/arch/arm/mm/Makefile
@@ -39,7 +39,6 @@ obj-$(CONFIG_CPU_CACHE_V4WT)	+= cache-v4wt.o
 obj-$(CONFIG_CPU_CACHE_V4WB)	+= cache-v4wb.o
 obj-$(CONFIG_CPU_CACHE_V6)	+= cache-v6.o
 obj-$(CONFIG_CPU_CACHE_V7)	+= cache-v7.o
-obj-$(CONFIG_CPU_CACHE_FA)	+= cache-fa.o
 
 AFLAGS_cache-v6.o	:=-Wa,-march=armv6
 AFLAGS_cache-v7.o	:=-Wa,-march=armv7-a
@@ -51,7 +50,6 @@ obj-$(CONFIG_CPU_COPY_V6)	+= copypage-v6.o context.o
 obj-$(CONFIG_CPU_SA1100)	+= copypage-v4mc.o
 obj-$(CONFIG_CPU_XSCALE)	+= copypage-xscale.o
 obj-$(CONFIG_CPU_XSC3)		+= copypage-xsc3.o
-obj-$(CONFIG_CPU_COPY_FA)	+= copypage-fa.o
 
 obj-$(CONFIG_CPU_TLB_V4WT)	+= tlb-v4.o
 obj-$(CONFIG_CPU_TLB_V4WB)	+= tlb-v4wb.o
@@ -59,7 +57,6 @@ obj-$(CONFIG_CPU_TLB_V4WBI)	+= tlb-v4wbi.o
 obj-$(CONFIG_CPU_TLB_FEROCEON)	+= tlb-v4wbi.o	# reuse v4wbi TLB functions
 obj-$(CONFIG_CPU_TLB_V6)	+= tlb-v6.o
 obj-$(CONFIG_CPU_TLB_V7)	+= tlb-v7.o
-obj-$(CONFIG_CPU_TLB_FA)	+= tlb-fa.o
 
 AFLAGS_tlb-v6.o		:=-Wa,-march=armv6
 AFLAGS_tlb-v7.o		:=-Wa,-march=armv7-a
@@ -74,7 +71,6 @@ obj-$(CONFIG_CPU_ARM925T)	+= proc-arm925.o
 obj-$(CONFIG_CPU_ARM926T)	+= proc-arm926.o
 obj-$(CONFIG_CPU_ARM940T)	+= proc-arm940.o
 obj-$(CONFIG_CPU_ARM946E)	+= proc-arm946.o
-obj-$(CONFIG_CPU_FA526)		+= proc-fa526.o
 obj-$(CONFIG_CPU_ARM1020)	+= proc-arm1020.o
 obj-$(CONFIG_CPU_ARM1020E)	+= proc-arm1020e.o
 obj-$(CONFIG_CPU_ARM1022)	+= proc-arm1022.o
diff --git a/arch/arm/mm/cache-fa.S b/arch/arm/mm/cache-fa.S
deleted file mode 100644
index e505bef..0000000
--- a/arch/arm/mm/cache-fa.S
+++ /dev/null
@@ -1,249 +0,0 @@
-/*
- *  linux/arch/arm/mm/cache-fa.S
- *
- *  Copyright (C) 2005 Faraday Corp.
- *  Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * Based on cache-v4wb.S:
- *  Copyright (C) 1997-2002 Russell king
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- *  Processors: FA520 FA526 FA626	
- */
-#include <linux/linkage.h>
-#include <linux/init.h>
-#include <asm/memory.h>
-#include <asm/page.h>
-
-#include "proc-macros.S"
-
-/*
- * The size of one data cache line.
- */
-#define CACHE_DLINESIZE	16
-
-/*
- * The total size of the data cache.
- */
-#ifdef CONFIG_ARCH_GEMINI
-#define CACHE_DSIZE	8192
-#else
-#define CACHE_DSIZE	16384 
-#endif 
-
-/* FIXME: put optimal value here. Current one is just estimation */
-#define CACHE_DLIMIT	(CACHE_DSIZE * 2)
-
-/*
- *	flush_icache_all()
- *
- *	Unconditionally clean and invalidate the entire icache.
- */
-ENTRY(fa_flush_icache_all)
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
-	mov	pc, lr
-ENDPROC(fa_flush_icache_all)
-
-/*
- *	flush_user_cache_all()
- *
- *	Clean and invalidate all cache entries in a particular address
- *	space.
- */
-ENTRY(fa_flush_user_cache_all)
-	/* FALLTHROUGH */
-/*
- *	flush_kern_cache_all()
- *
- *	Clean and invalidate the entire cache.
- */
-ENTRY(fa_flush_kern_cache_all)
-	mov	ip, #0
-	mov	r2, #VM_EXEC
-__flush_whole_cache:
-	mcr	p15, 0, ip, c7, c14, 0		@ clean/invalidate D cache
-	tst	r2, #VM_EXEC
-	mcrne	p15, 0, ip, c7, c5, 0		@ invalidate I cache
-	mcrne	p15, 0, ip, c7, c5, 6		@ invalidate BTB
-	mcrne	p15, 0, ip, c7, c10, 4		@ drain write buffer
-	mcrne	p15, 0, ip, c7, c5, 4		@ prefetch flush
-	mov	pc, lr
-
-/*
- *	flush_user_cache_range(start, end, flags)
- *
- *	Invalidate a range of cache entries in the specified
- *	address space.
- *
- *	- start - start address (inclusive, page aligned)
- *	- end	- end address (exclusive, page aligned)
- *	- flags	- vma_area_struct flags describing address space
- */
-ENTRY(fa_flush_user_cache_range)
-	mov	ip, #0
-	sub	r3, r1, r0			@ calculate total size
-	cmp	r3, #CACHE_DLIMIT		@ total size >= limit?
-	bhs	__flush_whole_cache		@ flush whole D cache
-
-1:	tst	r2, #VM_EXEC
-	mcrne	p15, 0, r0, c7, c5, 1		@ invalidate I line
-	mcr	p15, 0, r0, c7, c14, 1		@ clean and invalidate D entry
-	add	r0, r0, #CACHE_DLINESIZE
-	cmp	r0, r1
-	blo	1b
-	tst	r2, #VM_EXEC
-	mcrne	p15, 0, ip, c7, c5, 6		@ invalidate BTB
-	mcrne	p15, 0, ip, c7, c10, 4		@ data write barrier
-	mcrne	p15, 0, ip, c7, c5, 4		@ prefetch flush
-	mov	pc, lr
-
-/*
- *	coherent_kern_range(start, end)
- *
- *	Ensure coherency between the Icache and the Dcache in the
- *	region described by start.  If you have non-snooping
- *	Harvard caches, you need to implement this function.
- *
- *	- start  - virtual start address
- *	- end	 - virtual end address
- */
-ENTRY(fa_coherent_kern_range)
-	/* fall through */
-
-/*
- *	coherent_user_range(start, end)
- *
- *	Ensure coherency between the Icache and the Dcache in the
- *	region described by start.  If you have non-snooping
- *	Harvard caches, you need to implement this function.
- *
- *	- start  - virtual start address
- *	- end	 - virtual end address
- */
-ENTRY(fa_coherent_user_range)
-	bic	r0, r0, #CACHE_DLINESIZE - 1
-1:	mcr	p15, 0, r0, c7, c14, 1		@ clean and invalidate D entry
-	mcr	p15, 0, r0, c7, c5, 1		@ invalidate I entry
-	add	r0, r0, #CACHE_DLINESIZE
-	cmp	r0, r1
-	blo	1b
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c5, 6		@ invalidate BTB
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
-	mcr	p15, 0, r0, c7, c5, 4		@ prefetch flush
-	mov	pc, lr
-
-/*
- *	flush_kern_dcache_area(void *addr, size_t size)
- *
- *	Ensure that the data held in the page kaddr is written back
- *	to the page in question.
- *
- *	- addr	- kernel address
- *	- size	- size of region
- */
-ENTRY(fa_flush_kern_dcache_area)
-	add	r1, r0, r1
-1:	mcr	p15, 0, r0, c7, c14, 1		@ clean & invalidate D line
-	add	r0, r0, #CACHE_DLINESIZE
-	cmp	r0, r1
-	blo	1b
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
-	mov	pc, lr
-
-/*
- *	dma_inv_range(start, end)
- *
- *	Invalidate (discard) the specified virtual address range.
- *	May not write back any entries.  If 'start' or 'end'
- *	are not cache line aligned, those lines must be written
- *	back.
- *
- *	- start  - virtual start address
- *	- end	 - virtual end address
- */
-fa_dma_inv_range:
-	tst	r0, #CACHE_DLINESIZE - 1
-	bic	r0, r0, #CACHE_DLINESIZE - 1
-	mcrne	p15, 0, r0, c7, c14, 1		@ clean & invalidate D entry
-	tst	r1, #CACHE_DLINESIZE - 1
-	bic	r1, r1, #CACHE_DLINESIZE - 1
-	mcrne	p15, 0, r1, c7, c14, 1		@ clean & invalidate D entry
-1:	mcr	p15, 0, r0, c7, c6, 1		@ invalidate D entry
-	add	r0, r0, #CACHE_DLINESIZE
-	cmp	r0, r1
-	blo	1b
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
-	mov	pc, lr
-
-/*
- *	dma_clean_range(start, end)
- *
- *	Clean (write back) the specified virtual address range.
- *
- *	- start  - virtual start address
- *	- end	 - virtual end address
- */
-fa_dma_clean_range:
-	bic	r0, r0, #CACHE_DLINESIZE - 1
-1:	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
-	add	r0, r0, #CACHE_DLINESIZE
-	cmp	r0, r1
-	blo	1b
-	mov	r0, #0	
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
-	mov	pc, lr
-
-/*
- *	dma_flush_range(start,end)
- *	- start   - virtual start address of region
- *	- end     - virtual end address of region
- */
-ENTRY(fa_dma_flush_range)
-	bic	r0, r0, #CACHE_DLINESIZE - 1
-1:	mcr	p15, 0, r0, c7, c14, 1		@ clean & invalidate D entry
-	add	r0, r0, #CACHE_DLINESIZE
-	cmp	r0, r1
-	blo	1b
-	mov	r0, #0	
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
-	mov	pc, lr
-
-/*
- *	dma_map_area(start, size, dir)
- *	- start	- kernel virtual start address
- *	- size	- size of region
- *	- dir	- DMA direction
- */
-ENTRY(fa_dma_map_area)
-	add	r1, r1, r0
-	cmp	r2, #DMA_TO_DEVICE
-	beq	fa_dma_clean_range
-	bcs	fa_dma_inv_range
-	b	fa_dma_flush_range
-ENDPROC(fa_dma_map_area)
-
-/*
- *	dma_unmap_area(start, size, dir)
- *	- start	- kernel virtual start address
- *	- size	- size of region
- *	- dir	- DMA direction
- */
-ENTRY(fa_dma_unmap_area)
-	mov	pc, lr
-ENDPROC(fa_dma_unmap_area)
-
-	.globl	fa_flush_kern_cache_louis
-	.equ	fa_flush_kern_cache_louis, fa_flush_kern_cache_all
-
-	__INITDATA
-
-	@ define struct cpu_cache_fns (see <asm/cacheflush.h> and proc-macros.S)
-	define_cache_functions fa
diff --git a/arch/arm/mm/copypage-fa.c b/arch/arm/mm/copypage-fa.c
deleted file mode 100644
index d130a5e..0000000
--- a/arch/arm/mm/copypage-fa.c
+++ /dev/null
@@ -1,86 +0,0 @@
-/*
- *  linux/arch/arm/lib/copypage-fa.S
- *
- *  Copyright (C) 2005 Faraday Corp.
- *  Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * Based on copypage-v4wb.S:
- *  Copyright (C) 1995-1999 Russell King
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/init.h>
-#include <linux/highmem.h>
-
-/*
- * Faraday optimised copy_user_page
- */
-static void __naked
-fa_copy_user_page(void *kto, const void *kfrom)
-{
-	asm("\
-	stmfd	sp!, {r4, lr}			@ 2\n\
-	mov	r2, %0				@ 1\n\
-1:	ldmia	r1!, {r3, r4, ip, lr}		@ 4\n\
-	stmia	r0, {r3, r4, ip, lr}		@ 4\n\
-	mcr	p15, 0, r0, c7, c14, 1		@ 1   clean and invalidate D line\n\
-	add	r0, r0, #16			@ 1\n\
-	ldmia	r1!, {r3, r4, ip, lr}		@ 4\n\
-	stmia	r0, {r3, r4, ip, lr}		@ 4\n\
-	mcr	p15, 0, r0, c7, c14, 1		@ 1   clean and invalidate D line\n\
-	add	r0, r0, #16			@ 1\n\
-	subs	r2, r2, #1			@ 1\n\
-	bne	1b				@ 1\n\
-	mcr	p15, 0, r2, c7, c10, 4		@ 1   drain WB\n\
-	ldmfd	sp!, {r4, pc}			@ 3"
-	:
-	: "I" (PAGE_SIZE / 32));
-}
-
-void fa_copy_user_highpage(struct page *to, struct page *from,
-	unsigned long vaddr, struct vm_area_struct *vma)
-{
-	void *kto, *kfrom;
-
-	kto = kmap_atomic(to);
-	kfrom = kmap_atomic(from);
-	fa_copy_user_page(kto, kfrom);
-	kunmap_atomic(kfrom);
-	kunmap_atomic(kto);
-}
-
-/*
- * Faraday optimised clear_user_page
- *
- * Same story as above.
- */
-void fa_clear_user_highpage(struct page *page, unsigned long vaddr)
-{
-	void *ptr, *kaddr = kmap_atomic(page);
-	asm volatile("\
-	mov	r1, %2				@ 1\n\
-	mov	r2, #0				@ 1\n\
-	mov	r3, #0				@ 1\n\
-	mov	ip, #0				@ 1\n\
-	mov	lr, #0				@ 1\n\
-1:	stmia	%0, {r2, r3, ip, lr}		@ 4\n\
-	mcr	p15, 0, %0, c7, c14, 1		@ 1   clean and invalidate D line\n\
-	add	%0, %0, #16			@ 1\n\
-	stmia	%0, {r2, r3, ip, lr}		@ 4\n\
-	mcr	p15, 0, %0, c7, c14, 1		@ 1   clean and invalidate D line\n\
-	add	%0, %0, #16			@ 1\n\
-	subs	r1, r1, #1			@ 1\n\
-	bne	1b				@ 1\n\
-	mcr	p15, 0, r1, c7, c10, 4		@ 1   drain WB"
-	: "=r" (ptr)
-	: "0" (kaddr), "I" (PAGE_SIZE / 32)
-	: "r1", "r2", "r3", "ip", "lr");
-	kunmap_atomic(kaddr);
-}
-
-struct cpu_user_fns fa_user_fns __initdata = {
-	.cpu_clear_user_highpage = fa_clear_user_highpage,
-	.cpu_copy_user_highpage	= fa_copy_user_highpage,
-};
diff --git a/arch/arm/mm/proc-fa526.S b/arch/arm/mm/proc-fa526.S
deleted file mode 100644
index d217e97..0000000
--- a/arch/arm/mm/proc-fa526.S
+++ /dev/null
@@ -1,221 +0,0 @@
-/*
- *  linux/arch/arm/mm/proc-fa526.S: MMU functions for FA526
- *
- *  Written by : Luke Lee
- *  Copyright (C) 2005 Faraday Corp.
- *  Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- *
- * These are the low level assembler for performing cache and TLB
- * functions on the fa526.
- */
-#include <linux/linkage.h>
-#include <linux/init.h>
-#include <asm/assembler.h>
-#include <asm/hwcap.h>
-#include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
-#include <asm/page.h>
-#include <asm/ptrace.h>
-
-#include "proc-macros.S"
-
-#define CACHE_DLINESIZE	16
-
-	.text
-/*
- * cpu_fa526_proc_init()
- */
-ENTRY(cpu_fa526_proc_init)
-	mov	pc, lr
-
-/*
- * cpu_fa526_proc_fin()
- */
-ENTRY(cpu_fa526_proc_fin)
-	mrc	p15, 0, r0, c1, c0, 0		@ ctrl register
-	bic	r0, r0, #0x1000			@ ...i............
-	bic	r0, r0, #0x000e			@ ............wca.
-	mcr	p15, 0, r0, c1, c0, 0		@ disable caches
-	nop
-	nop
-	mov	pc, lr
-
-/*
- * cpu_fa526_reset(loc)
- *
- * Perform a soft reset of the system.  Put the CPU into the
- * same state as it would be if it had been reset, and branch
- * to what would be the reset vector.
- *
- * loc: location to jump to for soft reset
- */
-	.align	4
-	.pushsection	.idmap.text, "ax"
-ENTRY(cpu_fa526_reset)
-/* TODO: Use CP8 if possible... */
-	mov	ip, #0
-	mcr	p15, 0, ip, c7, c7, 0		@ invalidate I,D caches
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
-#ifdef CONFIG_MMU
-	mcr	p15, 0, ip, c8, c7, 0		@ invalidate I & D TLBs
-#endif
-	mrc	p15, 0, ip, c1, c0, 0		@ ctrl register
-	bic	ip, ip, #0x000f			@ ............wcam
-	bic	ip, ip, #0x1100			@ ...i...s........
-	bic	ip, ip, #0x0800			@ BTB off
-	mcr	p15, 0, ip, c1, c0, 0		@ ctrl register
-	nop
-	nop
-	mov	pc, r0
-ENDPROC(cpu_fa526_reset)
-	.popsection
-
-/*
- * cpu_fa526_do_idle()
- */
-	.align	4
-ENTRY(cpu_fa526_do_idle)
-	mcr	p15, 0, r0, c7, c0, 4		@ Wait for interrupt
-	mov	pc, lr
-
-
-ENTRY(cpu_fa526_dcache_clean_area)
-1:	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
-	add	r0, r0, #CACHE_DLINESIZE
-	subs	r1, r1, #CACHE_DLINESIZE
-	bhi	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
-
-/* =============================== PageTable ============================== */
-
-/*
- * cpu_fa526_switch_mm(pgd)
- *
- * Set the translation base pointer to be as described by pgd.
- *
- * pgd: new page tables
- */
-	.align	4
-ENTRY(cpu_fa526_switch_mm)
-#ifdef CONFIG_MMU
-	mov	ip, #0
-#ifdef CONFIG_CPU_DCACHE_WRITETHROUGH
-	mcr	p15, 0, ip, c7, c6, 0		@ invalidate D cache
-#else
-	mcr	p15, 0, ip, c7, c14, 0		@ clean and invalidate whole D cache
-#endif
-	mcr	p15, 0, ip, c7, c5, 0		@ invalidate I cache
-	mcr	p15, 0, ip, c7, c5, 6		@ invalidate BTB since mm changed
-	mcr	p15, 0, ip, c7, c10, 4		@ data write barrier
-	mcr	p15, 0, ip, c7, c5, 4		@ prefetch flush
-	mcr	p15, 0, r0, c2, c0, 0		@ load page table pointer
-	mcr	p15, 0, ip, c8, c7, 0		@ invalidate UTLB
-#endif
-	mov	pc, lr
-
-/*
- * cpu_fa526_set_pte_ext(ptep, pte, ext)
- *
- * Set a PTE and flush it out
- */
-	.align	4
-ENTRY(cpu_fa526_set_pte_ext)
-#ifdef CONFIG_MMU
-	armv3_set_pte_ext
-	mov	r0, r0
-	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-#endif
-	mov	pc, lr
-
-	__CPUINIT
-
-	.type	__fa526_setup, #function
-__fa526_setup:
-	/* On return of this routine, r0 must carry correct flags for CFG register */
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c7		@ invalidate I,D caches on v4
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer on v4
-#ifdef CONFIG_MMU
-	mcr	p15, 0, r0, c8, c7		@ invalidate I,D TLBs on v4
-#endif
-	mcr	p15, 0, r0, c7, c5, 5		@ invalidate IScratchpad RAM
-
-	mov	r0, #1
-	mcr	p15, 0, r0, c1, c1, 0		@ turn-on ECR
-
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c5, 6		@ invalidate BTB All
-	mcr	p15, 0, r0, c7, c10, 4		@ data write barrier
-	mcr	p15, 0, r0, c7, c5, 4		@ prefetch flush
-
-	mov	r0, #0x1f			@ Domains 0, 1 = manager, 2 = client
-	mcr	p15, 0, r0, c3, c0		@ load domain access register
-
-	mrc	p15, 0, r0, c1, c0		@ get control register v4
-	ldr	r5, fa526_cr1_clear
-	bic	r0, r0, r5
-	ldr	r5, fa526_cr1_set
-	orr	r0, r0, r5
-	mov	pc, lr
-	.size	__fa526_setup, . - __fa526_setup
-
-	/*
-	 * .RVI ZFRS BLDP WCAM
-	 * ..11 1001 .111 1101
-	 *
-	 */
-	.type	fa526_cr1_clear, #object
-	.type	fa526_cr1_set, #object
-fa526_cr1_clear:
-	.word	0x3f3f
-fa526_cr1_set:
-	.word	0x397D
-
-	__INITDATA
-
-	@ define struct processor (see <asm/proc-fns.h> and proc-macros.S)
-	define_processor_functions fa526, dabort=v4_early_abort, pabort=legacy_pabort
-
-	.section ".rodata"
-
-	string	cpu_arch_name, "armv4"
-	string	cpu_elf_name, "v4"
-	string	cpu_fa526_name, "FA526"
-
-	.align
-
-	.section ".proc.info.init", #alloc, #execinstr
-
-	.type	__fa526_proc_info,#object
-__fa526_proc_info:
-	.long	0x66015261
-	.long	0xff01fff1
-	.long   PMD_TYPE_SECT | \
-		PMD_SECT_BUFFERABLE | \
-		PMD_SECT_CACHEABLE | \
-		PMD_BIT4 | \
-		PMD_SECT_AP_WRITE | \
-		PMD_SECT_AP_READ
-	.long   PMD_TYPE_SECT | \
-		PMD_BIT4 | \
-		PMD_SECT_AP_WRITE | \
-		PMD_SECT_AP_READ
-	b	__fa526_setup
-	.long	cpu_arch_name
-	.long	cpu_elf_name
-	.long	HWCAP_SWP | HWCAP_HALF
-	.long	cpu_fa526_name
-	.long	fa526_processor_functions
-	.long	fa_tlb_fns
-	.long	fa_user_fns
-	.long	fa_cache_fns
-	.size	__fa526_proc_info, . - __fa526_proc_info
diff --git a/arch/arm/mm/tlb-fa.S b/arch/arm/mm/tlb-fa.S
deleted file mode 100644
index d3ddcf9..0000000
--- a/arch/arm/mm/tlb-fa.S
+++ /dev/null
@@ -1,69 +0,0 @@
-/*
- *  linux/arch/arm/mm/tlb-fa.S
- *
- *  Copyright (C) 2005 Faraday Corp.
- *  Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * Based on tlb-v4wbi.S:
- *  Copyright (C) 1997-2002 Russell King
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- *  ARM architecture version 4, Faraday variation.
- *  This assume an unified TLBs, with a write buffer, and branch target buffer (BTB)
- *
- *  Processors: FA520 FA526 FA626
- */
-#include <linux/linkage.h>
-#include <linux/init.h>
-#include <asm/asm-offsets.h>
-#include <asm/tlbflush.h>
-#include "proc-macros.S"
-
-
-/*
- *	flush_user_tlb_range(start, end, mm)
- *
- *	Invalidate a range of TLB entries in the specified address space.
- *
- *	- start - range start address
- *	- end   - range end address
- *	- mm    - mm_struct describing address space
- */
-	.align	4
-ENTRY(fa_flush_user_tlb_range)
-	vma_vm_mm ip, r2
-	act_mm	r3				@ get current->active_mm
-	eors	r3, ip, r3			@ == mm ?
-	movne	pc, lr				@ no, we dont do anything
-	mov	r3, #0
-	mcr	p15, 0, r3, c7, c10, 4		@ drain WB
-	bic	r0, r0, #0x0ff
-	bic	r0, r0, #0xf00
-1:	mcr	p15, 0, r0, c8, c7, 1		@ invalidate UTLB entry
-	add	r0, r0, #PAGE_SZ
-	cmp	r0, r1
-	blo	1b
-	mcr	p15, 0, r3, c7, c10, 4		@ data write barrier
-	mov	pc, lr
-
-
-ENTRY(fa_flush_kern_tlb_range)
-	mov	r3, #0
-	mcr	p15, 0, r3, c7, c10, 4		@ drain WB
-	bic	r0, r0, #0x0ff
-	bic	r0, r0, #0xf00
-1:	mcr	p15, 0, r0, c8, c7, 1		@ invalidate UTLB entry
-	add	r0, r0, #PAGE_SZ
-	cmp	r0, r1
-	blo	1b
-	mcr	p15, 0, r3, c7, c10, 4		@ data write barrier
-	mcr	p15, 0, r3, c7, c5, 4		@ prefetch flush (isb)
-	mov	pc, lr
-
-	__INITDATA
-
-	/* define struct cpu_tlb_fns (see <asm/tlbflush.h> and proc-macros.S) */
-	define_tlb_functions fa, fa_tlb_flags
-- 
1.8.1.2

