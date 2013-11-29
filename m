Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab3K2Hrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 02:47:47 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:44894 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab3K2Hrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 02:47:42 -0500
Date: Fri, 29 Nov 2013 08:47:36 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.13-rc2
Message-ID: <20131129084736.32c9bb17@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112907-2966-0000-0000-000009851162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
One performance improvement and a few bug fixes. Two of the fixes deal
with the clock related problems we have seen on recent kernels.

Heiko Carstens (2):
      s390/mm: optimize copy_page
      s390/uaccess: add missing page table walk range check

Hendrik Brueckner (1):
      s390/signal: always restore saved runtime instrumentation psw bit

Martin Schwidefsky (3):
      s390/time,vdso: convert to the new update_vsyscall interface
      s390,time: revert direct ktime path for s390 clockevent device
      s390/mm: handle asce-type exceptions as normal page fault

Stefan Weinhuber (1):
      s390/dasd: validate request size before building CCW/TCW request

 arch/s390/Kconfig                       |    2 +-
 arch/s390/include/asm/page.h            |   38 +++++++++----------------
 arch/s390/include/asm/vdso.h            |    5 ++--
 arch/s390/kernel/asm-offsets.c          |    3 +-
 arch/s390/kernel/compat_signal.c        |    2 +-
 arch/s390/kernel/pgm_check.S            |    2 +-
 arch/s390/kernel/signal.c               |    2 +-
 arch/s390/kernel/time.c                 |   46 +++++++++++++++----------------
 arch/s390/kernel/vdso32/clock_gettime.S |   30 ++++++++++----------
 arch/s390/kernel/vdso32/gettimeofday.S  |    9 +++---
 arch/s390/kernel/vdso64/clock_gettime.S |   22 ++++++++-------
 arch/s390/kernel/vdso64/gettimeofday.S  |    9 +++---
 arch/s390/lib/uaccess_pt.c              |    3 ++
 drivers/s390/block/dasd_eckd.c          |    2 ++
 14 files changed, 87 insertions(+), 88 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 314fced..5877e71 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -101,7 +101,7 @@ config S390
 	select GENERIC_CPU_DEVICES if !SMP
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_SMP_IDLE_THREAD
-	select GENERIC_TIME_VSYSCALL_OLD
+	select GENERIC_TIME_VSYSCALL
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
 	select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
 	select HAVE_ARCH_SECCOMP_FILTER
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index 316c850..114258e 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -48,33 +48,21 @@ static inline void clear_page(void *page)
 		: "memory", "cc");
 }
 
+/*
+ * copy_page uses the mvcl instruction with 0xb0 padding byte in order to
+ * bypass caches when copying a page. Especially when copying huge pages
+ * this keeps L1 and L2 data caches alive.
+ */
 static inline void copy_page(void *to, void *from)
 {
-	if (MACHINE_HAS_MVPG) {
-		register unsigned long reg0 asm ("0") = 0;
-		asm volatile(
-			"	mvpg	%0,%1"
-			: : "a" (to), "a" (from), "d" (reg0)
-			: "memory", "cc");
-	} else
-		asm volatile(
-			"	mvc	0(256,%0),0(%1)\n"
-			"	mvc	256(256,%0),256(%1)\n"
-			"	mvc	512(256,%0),512(%1)\n"
-			"	mvc	768(256,%0),768(%1)\n"
-			"	mvc	1024(256,%0),1024(%1)\n"
-			"	mvc	1280(256,%0),1280(%1)\n"
-			"	mvc	1536(256,%0),1536(%1)\n"
-			"	mvc	1792(256,%0),1792(%1)\n"
-			"	mvc	2048(256,%0),2048(%1)\n"
-			"	mvc	2304(256,%0),2304(%1)\n"
-			"	mvc	2560(256,%0),2560(%1)\n"
-			"	mvc	2816(256,%0),2816(%1)\n"
-			"	mvc	3072(256,%0),3072(%1)\n"
-			"	mvc	3328(256,%0),3328(%1)\n"
-			"	mvc	3584(256,%0),3584(%1)\n"
-			"	mvc	3840(256,%0),3840(%1)\n"
-			: : "a" (to), "a" (from) : "memory");
+	register void *reg2 asm ("2") = to;
+	register unsigned long reg3 asm ("3") = 0x1000;
+	register void *reg4 asm ("4") = from;
+	register unsigned long reg5 asm ("5") = 0xb0001000;
+	asm volatile(
+		"	mvcl	2,4"
+		: "+d" (reg2), "+d" (reg3), "+d" (reg4), "+d" (reg5)
+		: : "memory", "cc");
 }
 
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
diff --git a/arch/s390/include/asm/vdso.h b/arch/s390/include/asm/vdso.h
index a73eb2e..bc9746a 100644
--- a/arch/s390/include/asm/vdso.h
+++ b/arch/s390/include/asm/vdso.h
@@ -26,8 +26,9 @@ struct vdso_data {
 	__u64 wtom_clock_nsec;		/*				0x28 */
 	__u32 tz_minuteswest;		/* Minutes west of Greenwich	0x30 */
 	__u32 tz_dsttime;		/* Type of dst correction	0x34 */
-	__u32 ectg_available;
-	__u32 ntp_mult;			/* NTP adjusted multiplier	0x3C */
+	__u32 ectg_available;		/* ECTG instruction present	0x38 */
+	__u32 tk_mult;			/* Mult. used for xtime_nsec	0x3c */
+	__u32 tk_shift;			/* Shift used for xtime_nsec	0x40 */
 };
 
 struct vdso_per_cpu_data {
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index 2416138..496116c 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -65,7 +65,8 @@ int main(void)
 	DEFINE(__VDSO_WTOM_NSEC, offsetof(struct vdso_data, wtom_clock_nsec));
 	DEFINE(__VDSO_TIMEZONE, offsetof(struct vdso_data, tz_minuteswest));
 	DEFINE(__VDSO_ECTG_OK, offsetof(struct vdso_data, ectg_available));
-	DEFINE(__VDSO_NTP_MULT, offsetof(struct vdso_data, ntp_mult));
+	DEFINE(__VDSO_TK_MULT, offsetof(struct vdso_data, tk_mult));
+	DEFINE(__VDSO_TK_SHIFT, offsetof(struct vdso_data, tk_shift));
 	DEFINE(__VDSO_ECTG_BASE, offsetof(struct vdso_per_cpu_data, ectg_timer_base));
 	DEFINE(__VDSO_ECTG_USER, offsetof(struct vdso_per_cpu_data, ectg_user_time));
 	/* constants used by the vdso */
diff --git a/arch/s390/kernel/compat_signal.c b/arch/s390/kernel/compat_signal.c
index 6e24429..95e7ba0 100644
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -194,7 +194,7 @@ static int restore_sigregs32(struct pt_regs *regs,_sigregs32 __user *sregs)
 		return -EINVAL;
 
 	/* Use regs->psw.mask instead of PSW_USER_BITS to preserve PER bit. */
-	regs->psw.mask = (regs->psw.mask & ~PSW_MASK_USER) |
+	regs->psw.mask = (regs->psw.mask & ~(PSW_MASK_USER | PSW_MASK_RI)) |
 		(__u64)(user_sregs.regs.psw.mask & PSW32_MASK_USER) << 32 |
 		(__u64)(user_sregs.regs.psw.mask & PSW32_MASK_RI) << 32 |
 		(__u64)(user_sregs.regs.psw.addr & PSW32_ADDR_AMODE);
diff --git a/arch/s390/kernel/pgm_check.S b/arch/s390/kernel/pgm_check.S
index 4a460c4..813ec72 100644
--- a/arch/s390/kernel/pgm_check.S
+++ b/arch/s390/kernel/pgm_check.S
@@ -78,7 +78,7 @@ PGM_CHECK_DEFAULT			/* 34 */
 PGM_CHECK_DEFAULT			/* 35 */
 PGM_CHECK_DEFAULT			/* 36 */
 PGM_CHECK_DEFAULT			/* 37 */
-PGM_CHECK_DEFAULT			/* 38 */
+PGM_CHECK_64BIT(do_dat_exception)	/* 38 */
 PGM_CHECK_64BIT(do_dat_exception)	/* 39 */
 PGM_CHECK_64BIT(do_dat_exception)	/* 3a */
 PGM_CHECK_64BIT(do_dat_exception)	/* 3b */
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index fb53587..d8fd508 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -94,7 +94,7 @@ static int restore_sigregs(struct pt_regs *regs, _sigregs __user *sregs)
 		return -EINVAL;
 
 	/* Use regs->psw.mask instead of PSW_USER_BITS to preserve PER bit. */
-	regs->psw.mask = (regs->psw.mask & ~PSW_MASK_USER) |
+	regs->psw.mask = (regs->psw.mask & ~(PSW_MASK_USER | PSW_MASK_RI)) |
 		(user_sregs.regs.psw.mask & (PSW_MASK_USER | PSW_MASK_RI));
 	/* Check for invalid user address space control. */
 	if ((regs->psw.mask & PSW_MASK_ASC) == PSW_ASC_HOME)
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 064c308..dd95f163 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -108,20 +108,10 @@ static void fixup_clock_comparator(unsigned long long delta)
 	set_clock_comparator(S390_lowcore.clock_comparator);
 }
 
-static int s390_next_ktime(ktime_t expires,
+static int s390_next_event(unsigned long delta,
 			   struct clock_event_device *evt)
 {
-	struct timespec ts;
-	u64 nsecs;
-
-	ts.tv_sec = ts.tv_nsec = 0;
-	monotonic_to_bootbased(&ts);
-	nsecs = ktime_to_ns(ktime_add(timespec_to_ktime(ts), expires));
-	do_div(nsecs, 125);
-	S390_lowcore.clock_comparator = sched_clock_base_cc + (nsecs << 9);
-	/* Program the maximum value if we have an overflow (== year 2042) */
-	if (unlikely(S390_lowcore.clock_comparator < sched_clock_base_cc))
-		S390_lowcore.clock_comparator = -1ULL;
+	S390_lowcore.clock_comparator = get_tod_clock() + delta;
 	set_clock_comparator(S390_lowcore.clock_comparator);
 	return 0;
 }
@@ -146,15 +136,14 @@ void init_cpu_timer(void)
 	cpu = smp_processor_id();
 	cd = &per_cpu(comparators, cpu);
 	cd->name		= "comparator";
-	cd->features		= CLOCK_EVT_FEAT_ONESHOT |
-				  CLOCK_EVT_FEAT_KTIME;
+	cd->features		= CLOCK_EVT_FEAT_ONESHOT;
 	cd->mult		= 16777;
 	cd->shift		= 12;
 	cd->min_delta_ns	= 1;
 	cd->max_delta_ns	= LONG_MAX;
 	cd->rating		= 400;
 	cd->cpumask		= cpumask_of(cpu);
-	cd->set_next_ktime	= s390_next_ktime;
+	cd->set_next_event	= s390_next_event;
 	cd->set_mode		= s390_set_mode;
 
 	clockevents_register_device(cd);
@@ -221,21 +210,30 @@ struct clocksource * __init clocksource_default_clock(void)
 	return &clocksource_tod;
 }
 
-void update_vsyscall_old(struct timespec *wall_time, struct timespec *wtm,
-			struct clocksource *clock, u32 mult)
+void update_vsyscall(struct timekeeper *tk)
 {
-	if (clock != &clocksource_tod)
+	u64 nsecps;
+
+	if (tk->clock != &clocksource_tod)
 		return;
 
 	/* Make userspace gettimeofday spin until we're done. */
 	++vdso_data->tb_update_count;
 	smp_wmb();
-	vdso_data->xtime_tod_stamp = clock->cycle_last;
-	vdso_data->xtime_clock_sec = wall_time->tv_sec;
-	vdso_data->xtime_clock_nsec = wall_time->tv_nsec;
-	vdso_data->wtom_clock_sec = wtm->tv_sec;
-	vdso_data->wtom_clock_nsec = wtm->tv_nsec;
-	vdso_data->ntp_mult = mult;
+	vdso_data->xtime_tod_stamp = tk->clock->cycle_last;
+	vdso_data->xtime_clock_sec = tk->xtime_sec;
+	vdso_data->xtime_clock_nsec = tk->xtime_nsec;
+	vdso_data->wtom_clock_sec =
+		tk->xtime_sec + tk->wall_to_monotonic.tv_sec;
+	vdso_data->wtom_clock_nsec = tk->xtime_nsec +
+		+ (tk->wall_to_monotonic.tv_nsec << tk->shift);
+	nsecps = (u64) NSEC_PER_SEC << tk->shift;
+	while (vdso_data->wtom_clock_nsec >= nsecps) {
+		vdso_data->wtom_clock_nsec -= nsecps;
+		vdso_data->wtom_clock_sec++;
+	}
+	vdso_data->tk_mult = tk->mult;
+	vdso_data->tk_shift = tk->shift;
 	smp_wmb();
 	++vdso_data->tb_update_count;
 }
diff --git a/arch/s390/kernel/vdso32/clock_gettime.S b/arch/s390/kernel/vdso32/clock_gettime.S
index b2224e0..5be8e47 100644
--- a/arch/s390/kernel/vdso32/clock_gettime.S
+++ b/arch/s390/kernel/vdso32/clock_gettime.S
@@ -38,25 +38,26 @@ __kernel_clock_gettime:
 	sl	%r1,__VDSO_XTIME_STAMP+4(%r5)
 	brc	3,2f
 	ahi	%r0,-1
-2:	ms	%r0,__VDSO_NTP_MULT(%r5)	/* cyc2ns(clock,cycle_delta) */
+2:	ms	%r0,__VDSO_TK_MULT(%r5)		/*  * tk->mult */
 	lr	%r2,%r0
-	l	%r0,__VDSO_NTP_MULT(%r5)
+	l	%r0,__VDSO_TK_MULT(%r5)
 	ltr	%r1,%r1
 	mr	%r0,%r0
 	jnm	3f
-	a	%r0,__VDSO_NTP_MULT(%r5)
+	a	%r0,__VDSO_TK_MULT(%r5)
 3:	alr	%r0,%r2
-	srdl	%r0,12
-	al	%r0,__VDSO_XTIME_NSEC(%r5)	/*  + xtime */
+	al	%r0,__VDSO_XTIME_NSEC(%r5)	/*  + tk->xtime_nsec */
 	al	%r1,__VDSO_XTIME_NSEC+4(%r5)
 	brc	12,4f
 	ahi	%r0,1
-4:	l	%r2,__VDSO_XTIME_SEC+4(%r5)
-	al	%r0,__VDSO_WTOM_NSEC(%r5)	/*  + wall_to_monotonic */
+4:	al	%r0,__VDSO_WTOM_NSEC(%r5)	/*  + wall_to_monotonic.nsec */
 	al	%r1,__VDSO_WTOM_NSEC+4(%r5)
 	brc	12,5f
 	ahi	%r0,1
-5:	al	%r2,__VDSO_WTOM_SEC+4(%r5)
+5:	l	%r2,__VDSO_TK_SHIFT(%r5)	/* Timekeeper shift */
+	srdl	%r0,0(%r2)			/*  >> tk->shift */
+	l	%r2,__VDSO_XTIME_SEC+4(%r5)
+	al	%r2,__VDSO_WTOM_SEC+4(%r5)
 	cl	%r4,__VDSO_UPD_COUNT+4(%r5)	/* check update counter */
 	jne	1b
 	basr	%r5,0
@@ -86,20 +87,21 @@ __kernel_clock_gettime:
 	sl	%r1,__VDSO_XTIME_STAMP+4(%r5)
 	brc	3,12f
 	ahi	%r0,-1
-12:	ms	%r0,__VDSO_NTP_MULT(%r5)	/* cyc2ns(clock,cycle_delta) */
+12:	ms	%r0,__VDSO_TK_MULT(%r5)		/*  * tk->mult */
 	lr	%r2,%r0
-	l	%r0,__VDSO_NTP_MULT(%r5)
+	l	%r0,__VDSO_TK_MULT(%r5)
 	ltr	%r1,%r1
 	mr	%r0,%r0
 	jnm	13f
-	a	%r0,__VDSO_NTP_MULT(%r5)
+	a	%r0,__VDSO_TK_MULT(%r5)
 13:	alr	%r0,%r2
-	srdl	%r0,12
-	al	%r0,__VDSO_XTIME_NSEC(%r5)	/*  + xtime */
+	al	%r0,__VDSO_XTIME_NSEC(%r5)	/*  + tk->xtime_nsec */
 	al	%r1,__VDSO_XTIME_NSEC+4(%r5)
 	brc	12,14f
 	ahi	%r0,1
-14:	l	%r2,__VDSO_XTIME_SEC+4(%r5)
+14:	l	%r2,__VDSO_TK_SHIFT(%r5)	/* Timekeeper shift */
+	srdl	%r0,0(%r2)			/*  >> tk->shift */
+	l	%r2,__VDSO_XTIME_SEC+4(%r5)
 	cl	%r4,__VDSO_UPD_COUNT+4(%r5)	/* check update counter */
 	jne	11b
 	basr	%r5,0
diff --git a/arch/s390/kernel/vdso32/gettimeofday.S b/arch/s390/kernel/vdso32/gettimeofday.S
index 2d36331..fd621a9 100644
--- a/arch/s390/kernel/vdso32/gettimeofday.S
+++ b/arch/s390/kernel/vdso32/gettimeofday.S
@@ -35,15 +35,14 @@ __kernel_gettimeofday:
 	sl	%r1,__VDSO_XTIME_STAMP+4(%r5)
 	brc	3,3f
 	ahi	%r0,-1
-3:	ms	%r0,__VDSO_NTP_MULT(%r5)	/* cyc2ns(clock,cycle_delta) */
+3:	ms	%r0,__VDSO_TK_MULT(%r5)		/*  * tk->mult */
 	st	%r0,24(%r15)
-	l	%r0,__VDSO_NTP_MULT(%r5)
+	l	%r0,__VDSO_TK_MULT(%r5)
 	ltr	%r1,%r1
 	mr	%r0,%r0
 	jnm	4f
-	a	%r0,__VDSO_NTP_MULT(%r5)
+	a	%r0,__VDSO_TK_MULT(%r5)
 4:	al	%r0,24(%r15)
-	srdl	%r0,12
 	al	%r0,__VDSO_XTIME_NSEC(%r5)	/*  + xtime */
 	al	%r1,__VDSO_XTIME_NSEC+4(%r5)
 	brc	12,5f
@@ -51,6 +50,8 @@ __kernel_gettimeofday:
 5:	mvc	24(4,%r15),__VDSO_XTIME_SEC+4(%r5)
 	cl	%r4,__VDSO_UPD_COUNT+4(%r5)	/* check update counter */
 	jne	1b
+	l	%r4,__VDSO_TK_SHIFT(%r5)	/* Timekeeper shift */
+	srdl	%r0,0(%r4)			/*  >> tk->shift */
 	l	%r4,24(%r15)			/* get tv_sec from stack */
 	basr	%r5,0
 6:	ltr	%r0,%r0
diff --git a/arch/s390/kernel/vdso64/clock_gettime.S b/arch/s390/kernel/vdso64/clock_gettime.S
index d46c95e..0add107 100644
--- a/arch/s390/kernel/vdso64/clock_gettime.S
+++ b/arch/s390/kernel/vdso64/clock_gettime.S
@@ -34,14 +34,15 @@ __kernel_clock_gettime:
 	tmll	%r4,0x0001			/* pending update ? loop */
 	jnz	0b
 	stck	48(%r15)			/* Store TOD clock */
+	lgf	%r2,__VDSO_TK_SHIFT(%r5)	/* Timekeeper shift */
+	lg	%r0,__VDSO_XTIME_SEC(%r5)	/* tk->xtime_sec */
+	alg	%r0,__VDSO_WTOM_SEC(%r5)	/*  + wall_to_monotonic.sec */
 	lg	%r1,48(%r15)
 	sg	%r1,__VDSO_XTIME_STAMP(%r5)	/* TOD - cycle_last */
-	msgf	%r1,__VDSO_NTP_MULT(%r5)	/*  * NTP adjustment */
-	srlg	%r1,%r1,12			/* cyc2ns(clock,cycle_delta) */
-	alg	%r1,__VDSO_XTIME_NSEC(%r5)	/*  + xtime */
-	lg	%r0,__VDSO_XTIME_SEC(%r5)
-	alg	%r1,__VDSO_WTOM_NSEC(%r5)	/*  + wall_to_monotonic */
-	alg	%r0,__VDSO_WTOM_SEC(%r5)
+	msgf	%r1,__VDSO_TK_MULT(%r5)		/*  * tk->mult */
+	alg	%r1,__VDSO_XTIME_NSEC(%r5)	/*  + tk->xtime_nsec */
+	alg	%r1,__VDSO_WTOM_NSEC(%r5)	/*  + wall_to_monotonic.nsec */
+	srlg	%r1,%r1,0(%r2)			/*  >> tk->shift */
 	clg	%r4,__VDSO_UPD_COUNT(%r5)	/* check update counter */
 	jne	0b
 	larl	%r5,13f
@@ -62,12 +63,13 @@ __kernel_clock_gettime:
 	tmll	%r4,0x0001			/* pending update ? loop */
 	jnz	5b
 	stck	48(%r15)			/* Store TOD clock */
+	lgf	%r2,__VDSO_TK_SHIFT(%r5)	/* Timekeeper shift */
 	lg	%r1,48(%r15)
 	sg	%r1,__VDSO_XTIME_STAMP(%r5)	/* TOD - cycle_last */
-	msgf	%r1,__VDSO_NTP_MULT(%r5)	/*  * NTP adjustment */
-	srlg	%r1,%r1,12			/* cyc2ns(clock,cycle_delta) */
-	alg	%r1,__VDSO_XTIME_NSEC(%r5)	/*  + xtime */
-	lg	%r0,__VDSO_XTIME_SEC(%r5)
+	msgf	%r1,__VDSO_TK_MULT(%r5)		/*  * tk->mult */
+	alg	%r1,__VDSO_XTIME_NSEC(%r5)	/*  + tk->xtime_nsec */
+	srlg	%r1,%r1,0(%r2)			/*  >> tk->shift */
+	lg	%r0,__VDSO_XTIME_SEC(%r5)	/* tk->xtime_sec */
 	clg	%r4,__VDSO_UPD_COUNT(%r5)	/* check update counter */
 	jne	5b
 	larl	%r5,13f
diff --git a/arch/s390/kernel/vdso64/gettimeofday.S b/arch/s390/kernel/vdso64/gettimeofday.S
index 36ee674..d0860d1 100644
--- a/arch/s390/kernel/vdso64/gettimeofday.S
+++ b/arch/s390/kernel/vdso64/gettimeofday.S
@@ -31,12 +31,13 @@ __kernel_gettimeofday:
 	stck	48(%r15)			/* Store TOD clock */
 	lg	%r1,48(%r15)
 	sg	%r1,__VDSO_XTIME_STAMP(%r5)	/* TOD - cycle_last */
-	msgf	%r1,__VDSO_NTP_MULT(%r5)	/*  * NTP adjustment */
-	srlg	%r1,%r1,12			/* cyc2ns(clock,cycle_delta) */
-	alg	%r1,__VDSO_XTIME_NSEC(%r5)	/*  + xtime.tv_nsec */
-	lg	%r0,__VDSO_XTIME_SEC(%r5)	/* xtime.tv_sec */
+	msgf	%r1,__VDSO_TK_MULT(%r5)		/*  * tk->mult */
+	alg	%r1,__VDSO_XTIME_NSEC(%r5)	/*  + tk->xtime_nsec */
+	lg	%r0,__VDSO_XTIME_SEC(%r5)	/* tk->xtime_sec */
 	clg	%r4,__VDSO_UPD_COUNT(%r5)	/* check update counter */
 	jne	0b
+	lgf	%r5,__VDSO_TK_SHIFT(%r5)	/* Timekeeper shift */
+	srlg	%r1,%r1,0(%r5)			/*  >> tk->shift */
 	larl	%r5,5f
 2:	clg	%r1,0(%r5)
 	jl	3f
diff --git a/arch/s390/lib/uaccess_pt.c b/arch/s390/lib/uaccess_pt.c
index 97e03ca..dbdab3e 100644
--- a/arch/s390/lib/uaccess_pt.c
+++ b/arch/s390/lib/uaccess_pt.c
@@ -78,11 +78,14 @@ static size_t copy_in_kernel(size_t count, void __user *to,
  * contains the (negative) exception code.
  */
 #ifdef CONFIG_64BIT
+
 static unsigned long follow_table(struct mm_struct *mm,
 				  unsigned long address, int write)
 {
 	unsigned long *table = (unsigned long *)__pa(mm->pgd);
 
+	if (unlikely(address > mm->context.asce_limit - 1))
+		return -0x38UL;
 	switch (mm->context.asce_bits & _ASCE_TYPE_MASK) {
 	case _ASCE_TYPE_REGION1:
 		table = table + ((address >> 53) & 0x7ff);
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index cee7e27..95e4578 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -3224,6 +3224,8 @@ static struct dasd_ccw_req *dasd_eckd_build_cp(struct dasd_device *startdev,
 
 	fcx_multitrack = private->features.feature[40] & 0x20;
 	data_size = blk_rq_bytes(req);
+	if (data_size % blksize)
+		return ERR_PTR(-EINVAL);
 	/* tpm write request add CBC data on each track boundary */
 	if (rq_data_dir(req) == WRITE)
 		data_size += (last_trk - first_trk) * 4;

