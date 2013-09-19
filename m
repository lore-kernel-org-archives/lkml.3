Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab3ISJoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:44:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37793 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3ISJoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:44:04 -0400
Date: Thu, 19 Sep 2013 11:44:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: will.deacon@arm.com, catalin.marinas@arm.com
Subject: Re: 3.12-rc1: no longer compiles for Nokia n900 (omap based),
 display no longer works
Message-ID: <20130919094402.GA27253@amd.pavel.ucw.cz>
References: <20130919093002.GA23806@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919093002.GA23806@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-09-19 11:30:02, Pavel Machek wrote:
> Hi!
> 
> I get:
> 
>   CC      arch/arm/kernel/machine_kexec.o
> /tmp/ccCFXeXG.s: Assembler messages:
> /tmp/ccCFXeXG.s:217: Error: garbage following instruction -- `dsb
> nshst'
> /tmp/ccCFXeXG.s:225: Error: garbage following instruction -- `dsb nsh'
> make[1]: *** [arch/arm/kernel/suspend.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> 
> pavel@amd:/data/l/linux-n900$ arm-linux-gnueabi-gcc --version
> arm-linux-gnueabi-gcc (Debian 4.3.5-4) 4.3.5
> 
> Minimum required gcc is 3.2, so I'm safe.
> 
> I suspect
> 
> commit 62cbbc42e0019aff6310259f275ae812463f8836
> Author: Will Deacon <will.deacon@arm.com>
> Date:   Thu May 23 18:43:58 2013 +0100

And

commit 6af396a6b6c698eb3834184518fc9a59bc22c817
Author: Will Deacon <will.deacon@arm.com>
Date:   Wed Jun 12 10:03:30 2013 +0100

and

commit 73a6fdc48bf52e93c26874dc8c0f0f8d5585a809
Author: Will Deacon <will.deacon@arm.com>
Date:   Mon May 13 11:39:50 2013 +0100

and

commit 6abdd491698a27f7df04a32ca12cc453810e4396
Author: Will Deacon <will.deacon@arm.com>
Date:   Mon May 13 12:01:12 2013 +0100

Now I've reverted those, and it seems to build... and boot, but
something in 3.12-rc1 broke display :-(. (dmesg diff attached at the
end, maybe someone knows...)

Signed-off-by: Pavel Machek <pavel@ucw.cz>
									Pavel
diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index 15f2d5b..bfd37e5 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -351,7 +351,7 @@ static inline void flush_cache_vmap(unsigned long start, unsigned long end)
 		 * set_pte_at() called from vmap_pte_range() does not
 		 * have a DSB after cleaning the cache line.
 		 */
-		dsb(ishst);
+		dsb();
 }
 
 static inline void flush_cache_vunmap(unsigned long start, unsigned long end)
diff --git a/arch/arm/include/asm/spinlock.h b/arch/arm/include/asm/spinlock.h
index 4f2c280..b07c09e 100644
--- a/arch/arm/include/asm/spinlock.h
+++ b/arch/arm/include/asm/spinlock.h
@@ -46,7 +46,7 @@ static inline void dsb_sev(void)
 {
 #if __LINUX_ARM_ARCH__ >= 7
 	__asm__ __volatile__ (
-		"dsb ishst\n"
+		"dsb\n"
 		SEV
 	);
 #else
diff --git a/arch/arm/include/asm/switch_to.h b/arch/arm/include/asm/switch_to.h
index c99e259..fa09e6b 100644
--- a/arch/arm/include/asm/switch_to.h
+++ b/arch/arm/include/asm/switch_to.h
@@ -4,16 +4,6 @@
 #include <linux/thread_info.h>
 
 /*
- * For v7 SMP cores running a preemptible kernel we may be pre-empted
- * during a TLB maintenance operation, so execute an inner-shareable dsb
- * to ensure that the maintenance completes in case we migrate to another
- * CPU.
- */
-#if defined(CONFIG_PREEMPT) && defined(CONFIG_SMP) && defined(CONFIG_CPU_V7)
-#define finish_arch_switch(prev)	dsb(ish)
-#endif
-
-/*
  * switch_to(prev, next) should switch from task `prev' to `next'
  * `prev' will never be the same as `next'.  schedule() itself
  * contains the memory barrier to tell GCC not to cache `current'.
diff --git a/arch/arm/include/asm/tlbflush.h b/arch/arm/include/asm/tlbflush.h
index 3896026..8471824 100644
--- a/arch/arm/include/asm/tlbflush.h
+++ b/arch/arm/include/asm/tlbflush.h
@@ -335,13 +335,13 @@ static inline void local_flush_tlb_all(void)
 	const unsigned int __tlb_flag = __cpu_tlb_flags;
 
 	if (tlb_flag(TLB_WB))
-		dsb(nshst);
+		dsb();
 
 	__local_flush_tlb_all();
 	tlb_op(TLB_V7_UIS_FULL, "c8, c7, 0", zero);
 
 	if (tlb_flag(TLB_BARRIER)) {
-		dsb(nsh);
+		dsb();
 		isb();
 	}
 }
@@ -352,13 +352,13 @@ static inline void __flush_tlb_all(void)
 	const unsigned int __tlb_flag = __cpu_tlb_flags;
 
 	if (tlb_flag(TLB_WB))
-		dsb(ishst);
+		dsb();
 
 	__local_flush_tlb_all();
 	tlb_op(TLB_V7_UIS_FULL, "c8, c3, 0", zero);
 
 	if (tlb_flag(TLB_BARRIER)) {
-		dsb(ish);
+		dsb();
 		isb();
 	}
 }
@@ -388,13 +388,13 @@ static inline void local_flush_tlb_mm(struct mm_struct *mm)
 	const unsigned int __tlb_flag = __cpu_tlb_flags;
 
 	if (tlb_flag(TLB_WB))
-		dsb(nshst);
+		dsb();
 
 	__local_flush_tlb_mm(mm);
 	tlb_op(TLB_V7_UIS_ASID, "c8, c7, 2", asid);
 
 	if (tlb_flag(TLB_BARRIER))
-		dsb(nsh);
+		dsb();
 }
 
 static inline void __flush_tlb_mm(struct mm_struct *mm)
@@ -402,7 +402,7 @@ static inline void __flush_tlb_mm(struct mm_struct *mm)
 	const unsigned int __tlb_flag = __cpu_tlb_flags;
 
 	if (tlb_flag(TLB_WB))
-		dsb(ishst);
+		dsb();
 
 	__local_flush_tlb_mm(mm);
 #ifdef CONFIG_ARM_ERRATA_720789
@@ -412,7 +412,7 @@ static inline void __flush_tlb_mm(struct mm_struct *mm)
 #endif
 
 	if (tlb_flag(TLB_BARRIER))
-		dsb(ish);
+		dsb();
 }
 
 static inline void
@@ -445,13 +445,13 @@ local_flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
 	uaddr = (uaddr & PAGE_MASK) | ASID(vma->vm_mm);
 
 	if (tlb_flag(TLB_WB))
-		dsb(nshst);
+		dsb();
 
 	__local_flush_tlb_page(vma, uaddr);
 	tlb_op(TLB_V7_UIS_PAGE, "c8, c7, 1", uaddr);
 
 	if (tlb_flag(TLB_BARRIER))
-		dsb(nsh);
+		dsb();
 }
 
 static inline void
@@ -462,7 +462,7 @@ __flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
 	uaddr = (uaddr & PAGE_MASK) | ASID(vma->vm_mm);
 
 	if (tlb_flag(TLB_WB))
-		dsb(ishst);
+		dsb();
 
 	__local_flush_tlb_page(vma, uaddr);
 #ifdef CONFIG_ARM_ERRATA_720789
@@ -472,7 +472,7 @@ __flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
 #endif
 
 	if (tlb_flag(TLB_BARRIER))
-		dsb(ish);
+		dsb();
 }
 
 static inline void __local_flush_tlb_kernel_page(unsigned long kaddr)
@@ -498,13 +498,13 @@ static inline void local_flush_tlb_kernel_page(unsigned long kaddr)
 	kaddr &= PAGE_MASK;
 
 	if (tlb_flag(TLB_WB))
-		dsb(nshst);
+		dsb();
 
 	__local_flush_tlb_kernel_page(kaddr);
 	tlb_op(TLB_V7_UIS_PAGE, "c8, c7, 1", kaddr);
 
 	if (tlb_flag(TLB_BARRIER)) {
-		dsb(nsh);
+		dsb();
 		isb();
 	}
 }
@@ -516,13 +516,13 @@ static inline void __flush_tlb_kernel_page(unsigned long kaddr)
 	kaddr &= PAGE_MASK;
 
 	if (tlb_flag(TLB_WB))
-		dsb(ishst);
+		dsb();
 
 	__local_flush_tlb_kernel_page(kaddr);
 	tlb_op(TLB_V7_UIS_PAGE, "c8, c3, 1", kaddr);
 
 	if (tlb_flag(TLB_BARRIER)) {
-		dsb(ish);
+		dsb();
 		isb();
 	}
 }
@@ -578,7 +578,7 @@ static inline void dummy_flush_tlb_a15_erratum(void)
 	 * Dummy TLBIMVAIS. Using the unmapped address 0 and ASID 0.
 	 */
 	asm("mcr p15, 0, %0, c8, c3, 1" : : "r" (0));
-	dsb(ish);
+	dsb();
 }
 #else
 static inline int erratum_a15_798181(void)
@@ -612,7 +612,7 @@ static inline void flush_pmd_entry(void *pmd)
 	tlb_l2_op(TLB_L2CLEAN_FR, "c15, c9, 1  @ L2 flush_pmd", pmd);
 
 	if (tlb_flag(TLB_WB))
-		dsb(ishst);
+		dsb();
 }
 
 static inline void clean_pmd_entry(void *pmd)
diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
index b5c467a..515b000 100644
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -282,7 +282,7 @@ ENTRY(v7_coherent_user_range)
 	add	r12, r12, r2
 	cmp	r12, r1
 	blo	1b
-	dsb	ishst
+	dsb
 	icache_line_size r2, r3
 	sub	r3, r2, #1
 	bic	r12, r0, r3
@@ -294,7 +294,7 @@ ENTRY(v7_coherent_user_range)
 	mov	r0, #0
 	ALT_SMP(mcr	p15, 0, r0, c7, c1, 6)	@ invalidate BTB Inner Shareable
 	ALT_UP(mcr	p15, 0, r0, c7, c5, 6)	@ invalidate BTB
-	dsb	ishst
+	dsb
 	isb
 	mov	pc, lr
 
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index c63d9bd..f68734f 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -83,7 +83,7 @@ ENTRY(cpu_v7_dcache_clean_area)
 	add	r0, r0, r2
 	subs	r1, r1, r2
 	bhi	2b
-	dsb	ishst
+	dsb
 	mov	pc, lr
 ENDPROC(cpu_v7_dcache_clean_area)
 
diff --git a/arch/arm/mm/tlb-v7.S b/arch/arm/mm/tlb-v7.S
index 3553087..ea94765 100644
--- a/arch/arm/mm/tlb-v7.S
+++ b/arch/arm/mm/tlb-v7.S
@@ -35,7 +35,7 @@
 ENTRY(v7wbi_flush_user_tlb_range)
 	vma_vm_mm r3, r2			@ get vma->vm_mm
 	mmid	r3, r3				@ get vm_mm->context.id
-	dsb	ish
+	dsb
 	mov	r0, r0, lsr #PAGE_SHIFT		@ align address
 	mov	r1, r1, lsr #PAGE_SHIFT
 	asid	r3, r3				@ mask ASID
@@ -56,7 +56,7 @@ ENTRY(v7wbi_flush_user_tlb_range)
 	add	r0, r0, #PAGE_SZ
 	cmp	r0, r1
 	blo	1b
-	dsb	ish
+	dsb
 	mov	pc, lr
 ENDPROC(v7wbi_flush_user_tlb_range)
 
@@ -69,7 +69,7 @@ ENDPROC(v7wbi_flush_user_tlb_range)
  *	- end   - end address (exclusive, may not be aligned)
  */
 ENTRY(v7wbi_flush_kern_tlb_range)
-	dsb	ish
+	dsb
 	mov	r0, r0, lsr #PAGE_SHIFT		@ align address
 	mov	r1, r1, lsr #PAGE_SHIFT
 	mov	r0, r0, lsl #PAGE_SHIFT
@@ -84,7 +84,7 @@ ENTRY(v7wbi_flush_kern_tlb_range)
 	add	r0, r0, #PAGE_SZ
 	cmp	r0, r1
 	blo	1b
-	dsb	ish
+	dsb
 	isb
 	mov	pc, lr
 ENDPROC(v7wbi_flush_kern_tlb_range)
diff --git a/dmesg.qemu b/dmesg.qemu
index 452bc2e..9355be1 100644
--- a/dmesg.qemu
+++ b/dmesg.qemu
@@ -27,6 +27,7 @@ Booting secondary
    No USB host detected

  Loading initfs image info

  Serial console enabled

+omap2_inth_read: Bad register 0x000020
  Booting Linux on physical CPU 0x0

  Initializing cgroup subsys cpu

  revision 3 (ARMv7), cr=10c53c7d

@@ -65,12 +66,15 @@ Booting secondary
  Initializing cgroup subsys blkio

  CPU: Testing write buffer coherency: ok

  devtmpfs: initialized

+ VFP support v0.3: implementor 41 architecture 3 part 30 variant c rev 2

  omap_hdq1w_reset: hdq1w: softreset failed (waited 10000 usec)

  omap_hwmod: sham: cannot be enabled for reset (3)

  omap_hwmod: aes: cannot be enabled for reset (3)

  pinctrl core: initialized pinctrl subsystem

  NET: Registered protocol family 16

  DMA: preallocated 256 KiB pool for atomic coherent allocations

+ cpuidle: using governor ladder

+ cpuidle: using governor menu

  Reprogramming SDRC clock to 332000000 Hz

  OMAP GPIO hardware version 2.5

  platform 49022000.mcbsp: alias fck already exists

@@ -114,7 +118,7 @@ Booting secondary
  WARNING: CPU: 0 PID: 1 at drivers/video/omap2/dss/dss.c:540 dss_set_clock_div+0xa0/0xcc()

  clk rate mismatch: 86400000 != 172800000

  Modules linked in:

- CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0+ #326

+ CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-rc1+ #327

  (show_stack+0x14/0x1c)

  (warn_slowpath_common+0x64/0x84)

  (warn_slowpath_fmt+0x30/0x40)

@@ -124,25 +128,23 @@ Booting secondary
  (driver_probe_device+0xc0/0x21c)

  (__driver_attach+0x60/0x84)

  (bus_for_each_dev+0x50/0x98)

- (bus_add_driver+0xb4/0x21c)

- (driver_register+0xa4/0x144)

+ (bus_add_driver+0xb4/0x244)

+ (driver_register+0xa4/0xec)

  (platform_driver_probe+0x1c/0xa8)

- (omap_dss_init2+0x20/0xcc)

+ (omap_dss_init+0x1c/0xbc)

  (do_one_initcall+0x94/0x134)

  (kernel_init_freeable+0xe0/0x1b8)

  (kernel_init+0x8/0x15c)

  (ret_from_fork+0x14/0x3c)

 ---

  OMAP DSS rev 2.0

- omapfb omapfb: no driver for display: lcd

+ omapfb omapfb: no displays

+ omapfb omapfb: failed to setup omapfb

  platform omapfb: Driver omapfb requests probe deferral

  Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled

- omap_uart serial.5: did not get pins for uart0 error: -19

- serial.5: ttyO0 at MMIO 0x4806a000 (irq = 88) is a OMAP UART0

- omap_uart serial.6: did not get pins for uart1 error: -19

- serial.6: ttyO1 at MMIO 0x4806c000 (irq = 89) is a OMAP UART1

- omap_uart serial.7: did not get pins for uart2 error: -19

- serial.7: ttyO2 at MMIO 0x49020000 (irq = 90) is a OMAP UART2

+ serial.5: ttyO0 at MMIO 0x4806a000 (irq = 88, base_baud = 3000000) is a OMAP UART0

+ serial.6: ttyO1 at MMIO 0x4806c000 (irq = 89, base_baud = 3000000) is a OMAP UART1

+ serial.7: ttyO2 at MMIO 0x49020000 (irq = 90, base_baud = 3000000) is a OMAP UART2

  enabled

  brd: module loaded

  loop: module loaded

@@ -151,11 +153,8 @@ Booting secondary
  omap-dma-engine 48056000.dma-controller: allocating channel for 35

  omap-dma-engine 48056000.dma-controller: allocating channel for 40

  omap-dma-engine 48056000.dma-controller: allocating channel for 39

- acx565akm spi1.2: omapfb: acx565akm rev 12 LCD detected

  musb-hdrc musb-hdrc.0.auto: musb_init_controller failed with status -6

  omap_wdt: OMAP Watchdog Timer Rev 0x31: initial timeout 60 sec

- cpuidle: using governor ladder

- cpuidle: using governor menu

  ledtrig-cpu: registered to indicate activity on CPUs

  TCP: cubic registered

  Initializing XFRM netlink socket

@@ -163,10 +162,11 @@ Booting secondary
  NET: Registered protocol family 15

  NET: Registered protocol family 35

  Key type dns_resolver registered

- VFP support v0.3: implementor 41 architecture 3 part 30 variant c rev 2

  ThumbEE CPU extension supported.

  registered taskstats version 1

- Console: switching to colour frame buffer device 100x30

+ omapfb omapfb: no displays

+ omapfb omapfb: failed to setup omapfb

+ platform omapfb: Driver omapfb requests probe deferral

  drivers/rtc/hctosys.c: unable to open rtc device (rtc0)

  ALSA device list:

    No soundcards found.



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
