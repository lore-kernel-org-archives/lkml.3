Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab3GPRfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:35:14 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:38484 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933656Ab3GPRfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:35:04 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: [RFC PATCH 06/10] alpha: Reorganize rtc handling
Date: Tue, 16 Jul 2013 10:34:14 -0700
Message-Id: <1373996058-13399-7-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373996058-13399-1-git-send-email-rth@twiddle.net>
References: <1373996058-13399-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discontinue use of GENERIC_CMOS_UPDATE; rely on the RTC subsystem.

The marvel platform requires that the rtc only be touched from the
boot cpu.  This had been partially implemented with hooks for
get/set_rtc_time, but read/update_persistent_clock were not handled.
Fixed by adding an rtc_set_mmss hook along the way.

We had read_persistent_clock managing the epoch against which the
rtc hw is based, but this didn't apply to get_rtc_time or set_rtc_time.
This resulted in incorrect values when hwclock(8) gets involved.

Allow the epoch to be set from the kernel command-line, overriding
the autodetection, which is doomed to fail in 2028.  Further, by
implementing the rtc ioctl function, we can expose this epoch to
userland.

Elide the alarm functions that RTC_DRV_CMOS implements.  This was
highly questionable on Alpha, since the interrupt is used by the
system timer.

Cc: rtc-linux@googlegroups.com
Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/Kconfig               |   1 -
 arch/alpha/include/asm/machvec.h |   4 +-
 arch/alpha/include/asm/rtc.h     |  11 --
 arch/alpha/kernel/Makefile       |   1 +
 arch/alpha/kernel/machvec_impl.h |   5 +-
 arch/alpha/kernel/proto.h        |   9 ++
 arch/alpha/kernel/rtc.c          | 323 +++++++++++++++++++++++++++++++++++++++
 arch/alpha/kernel/sys_jensen.c   |   2 -
 arch/alpha/kernel/sys_marvel.c   |  55 +------
 arch/alpha/kernel/time.c         | 146 +-----------------
 drivers/rtc/Kconfig              |  10 +-
 11 files changed, 346 insertions(+), 221 deletions(-)
 create mode 100644 arch/alpha/kernel/rtc.c

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 5991a99..7e268cf 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -17,7 +17,6 @@ config ALPHA
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select GENERIC_SMP_IDLE_THREAD
-	select GENERIC_CMOS_UPDATE
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HAVE_MOD_ARCH_SPECIFIC
diff --git a/arch/alpha/include/asm/machvec.h b/arch/alpha/include/asm/machvec.h
index 4ac9016..75cb364 100644
--- a/arch/alpha/include/asm/machvec.h
+++ b/arch/alpha/include/asm/machvec.h
@@ -33,6 +33,7 @@ struct alpha_machine_vector
 
 	int nr_irqs;
 	int rtc_port;
+	int rtc_boot_cpu_only;
 	unsigned int max_asn;
 	unsigned long max_isa_dma_address;
 	unsigned long irq_probe_mask;
@@ -95,9 +96,6 @@ struct alpha_machine_vector
 
 	struct _alpha_agp_info *(*agp_info)(void);
 
-	unsigned int (*rtc_get_time)(struct rtc_time *);
-	int (*rtc_set_time)(struct rtc_time *);
-
 	const char *vector_name;
 
 	/* NUMA information */
diff --git a/arch/alpha/include/asm/rtc.h b/arch/alpha/include/asm/rtc.h
index d70408d..f71c3b0 100644
--- a/arch/alpha/include/asm/rtc.h
+++ b/arch/alpha/include/asm/rtc.h
@@ -1,12 +1 @@
-#ifndef _ALPHA_RTC_H
-#define _ALPHA_RTC_H
-
-#if defined(CONFIG_ALPHA_MARVEL) && defined(CONFIG_SMP) \
- || defined(CONFIG_ALPHA_GENERIC)
-# define get_rtc_time		alpha_mv.rtc_get_time
-# define set_rtc_time		alpha_mv.rtc_set_time
-#endif
-
 #include <asm-generic/rtc.h>
-
-#endif
diff --git a/arch/alpha/kernel/Makefile b/arch/alpha/kernel/Makefile
index 84ec46b..0d54650 100644
--- a/arch/alpha/kernel/Makefile
+++ b/arch/alpha/kernel/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_PCI)	+= pci.o pci_iommu.o pci-sysfs.o
 obj-$(CONFIG_SRM_ENV)	+= srm_env.o
 obj-$(CONFIG_MODULES)	+= module.o
 obj-$(CONFIG_PERF_EVENTS) += perf_event.o
+obj-$(CONFIG_RTC_DRV_ALPHA) += rtc.o
 
 ifdef CONFIG_ALPHA_GENERIC
 
diff --git a/arch/alpha/kernel/machvec_impl.h b/arch/alpha/kernel/machvec_impl.h
index 7fa6248..f54bdf6 100644
--- a/arch/alpha/kernel/machvec_impl.h
+++ b/arch/alpha/kernel/machvec_impl.h
@@ -43,10 +43,7 @@
 #define CAT1(x,y)  x##y
 #define CAT(x,y)   CAT1(x,y)
 
-#define DO_DEFAULT_RTC \
-	.rtc_port = 0x70, \
-	.rtc_get_time = common_get_rtc_time, \
-	.rtc_set_time = common_set_rtc_time
+#define DO_DEFAULT_RTC			.rtc_port = 0x70
 
 #define DO_EV4_MMU							\
 	.max_asn =			EV4_MAX_ASN,			\
diff --git a/arch/alpha/kernel/proto.h b/arch/alpha/kernel/proto.h
index d3e52d3..b0c8498 100644
--- a/arch/alpha/kernel/proto.h
+++ b/arch/alpha/kernel/proto.h
@@ -144,8 +144,17 @@ extern void smp_percpu_timer_interrupt(struct pt_regs *);
 extern irqreturn_t timer_interrupt(int irq, void *dev);
 extern void common_init_rtc(void);
 extern unsigned long est_cycle_freq;
+
+/* rtc.c */
+#ifdef CONFIG_RTC_DRV_ALPHA
 extern unsigned int common_get_rtc_time(struct rtc_time *time);
 extern int common_set_rtc_time(struct rtc_time *time);
+extern int common_set_rtc_mmss(unsigned long);
+#else
+# define common_get_rtc_time   NULL
+# define common_set_rtc_time   NULL
+# define common_set_rtc_mmss   NULL
+#endif
 
 /* smc37c93x.c */
 extern void SMC93x_Init(void);
diff --git a/arch/alpha/kernel/rtc.c b/arch/alpha/kernel/rtc.c
new file mode 100644
index 0000000..c8d284d
--- /dev/null
+++ b/arch/alpha/kernel/rtc.c
@@ -0,0 +1,323 @@
+/*
+ *  linux/arch/alpha/kernel/rtc.c
+ *
+ *  Copyright (C) 1991, 1992, 1995, 1999, 2000  Linus Torvalds
+ *
+ * This file contains date handling.
+ */
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/string.h>
+#include <linux/mc146818rtc.h>
+#include <linux/bcd.h>
+#include <linux/rtc.h>
+#include <linux/platform_device.h>
+
+#include <asm/rtc.h>
+
+#include "proto.h"
+
+
+/*
+ * Support for the RTC device.
+ *
+ * We don't want to use the rtc-cmos driver, because we don't want to support
+ * alarms, as that would be indistinguishable from timer interrupts.
+ *
+ * Further, generic code is really, really tied to a 1900 epoch.  This is
+ * true in __get_rtc_time as well as the users of struct rtc_time e.g.
+ * rtc_tm_to_time.  Thankfully all of the other epochs in use are later
+ * than 1900, and so it's easy to adjust.
+ */
+
+static unsigned long rtc_epoch;
+
+static int __init
+specifiy_epoch(char *str)
+{
+	unsigned long epoch = simple_strtoul(str, NULL, 0);
+	if (epoch < 1900)
+		printk("Ignoring invalid user specified epoch %lu\n", epoch);
+	else
+		rtc_epoch = epoch;
+	return 1;
+}
+__setup("epoch=", specifiy_epoch);
+
+static void __init
+init_rtc_epoch(void)
+{
+	int epoch, year, ctrl;
+
+	if (rtc_epoch != 0) {
+		/* The epoch was specified on the command-line.  */
+		return;
+	}
+
+	/* Detect the epoch in use on this computer.  */
+	ctrl = CMOS_READ(RTC_CONTROL);
+	year = CMOS_READ(RTC_YEAR);
+	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
+		year = bcd2bin(year);
+
+	/* PC-like is standard; used for year >= 70 */
+	epoch = 1900;
+	if (year < 20) {
+		epoch = 2000;
+	} else if (year >= 20 && year < 48) {
+		/* NT epoch */
+		epoch = 1980;
+	} else if (year >= 48 && year < 70) {
+		/* Digital UNIX epoch */
+		epoch = 1952;
+	}
+	rtc_epoch = epoch;
+
+	printk(KERN_INFO "Using epoch %d for rtc year %d\n", epoch, year);
+}
+
+static int
+alpha_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	__get_rtc_time(tm);
+
+	/* Adjust for non-default epochs.  It's easier to depend on the
+	   generic __get_rtc_time and adjust the epoch here than create
+	   a copy of __get_rtc_time with the edits we need.  */
+	if (rtc_epoch != 1900) {
+		int year = tm->tm_year;
+		/* Undo the century adjustment made in __get_rtc_time.  */
+		if (year >= 100)
+			year -= 100;
+		year += rtc_epoch - 1900;
+		/* Redo the century adjustment with the epoch in place.  */
+		if (year <= 69)
+			year += 100;
+		tm->tm_year = year;
+	}
+
+	return rtc_valid_tm(tm);
+}
+
+static int
+alpha_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct rtc_time xtm;
+
+	if (rtc_epoch != 1900) {
+		xtm = *tm;
+		xtm.tm_year -= rtc_epoch - 1900;
+		tm = &xtm;
+	}
+
+	return __set_rtc_time(tm);
+}
+
+static int
+alpha_rtc_set_mmss(struct device *dev, unsigned long nowtime)
+{
+	int retval = 0;
+	int real_seconds, real_minutes, cmos_minutes;
+	unsigned char save_control, save_freq_select;
+
+	/* Note: This code only updates minutes and seconds.  Comments
+	   indicate this was to avoid messing with unknown time zones,
+	   and with the epoch nonsense described above.  In order for
+	   this to work, the existing clock cannot be off by more than
+	   15 minutes.
+
+	   ??? This choice is may be out of date.  The x86 port does
+	   not have problems with timezones, and the epoch processing has
+	   now been fixed in alpha_set_rtc_time.
+
+	   In either case, one can always force a full rtc update with
+	   the userland hwclock program, so surely 15 minute accuracy
+	   is no real burden.  */
+
+	/* In order to set the CMOS clock precisely, we have to be called
+	   500 ms after the second nowtime has started, because when
+	   nowtime is written into the registers of the CMOS clock, it will
+	   jump to the next second precisely 500 ms later. Check the Motorola
+	   MC146818A or Dallas DS12887 data sheet for details.  */
+
+	/* irq are locally disabled here */
+	spin_lock(&rtc_lock);
+	/* Tell the clock it's being set */
+	save_control = CMOS_READ(RTC_CONTROL);
+	CMOS_WRITE((save_control|RTC_SET), RTC_CONTROL);
+
+	/* Stop and reset prescaler */
+	save_freq_select = CMOS_READ(RTC_FREQ_SELECT);
+	CMOS_WRITE((save_freq_select|RTC_DIV_RESET2), RTC_FREQ_SELECT);
+
+	cmos_minutes = CMOS_READ(RTC_MINUTES);
+	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
+		cmos_minutes = bcd2bin(cmos_minutes);
+
+	real_seconds = nowtime % 60;
+	real_minutes = nowtime / 60;
+	if (((abs(real_minutes - cmos_minutes) + 15) / 30) & 1) {
+		/* correct for half hour time zone */
+		real_minutes += 30;
+	}
+	real_minutes %= 60;
+
+	if (abs(real_minutes - cmos_minutes) < 30) {
+		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
+			real_seconds = bin2bcd(real_seconds);
+			real_minutes = bin2bcd(real_minutes);
+		}
+		CMOS_WRITE(real_seconds,RTC_SECONDS);
+		CMOS_WRITE(real_minutes,RTC_MINUTES);
+	} else {
+		printk_once(KERN_NOTICE
+			    "set_rtc_mmss: can't update from %d to %d\n",
+			    cmos_minutes, real_minutes);
+		retval = -1;
+	}
+
+	/* The following flags have to be released exactly in this order,
+	 * otherwise the DS12887 (popular MC146818A clone with integrated
+	 * battery and quartz) will not reset the oscillator and will not
+	 * update precisely 500 ms later. You won't find this mentioned in
+	 * the Dallas Semiconductor data sheets, but who believes data
+	 * sheets anyway ...                           -- Markus Kuhn
+	 */
+	CMOS_WRITE(save_control, RTC_CONTROL);
+	CMOS_WRITE(save_freq_select, RTC_FREQ_SELECT);
+	spin_unlock(&rtc_lock);
+
+	return retval;
+}
+
+static int
+alpha_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case RTC_EPOCH_READ:
+		return put_user(rtc_epoch, (unsigned long __user *)arg);
+	case RTC_EPOCH_SET:
+		if (arg < 1900)
+			return -EINVAL;
+		rtc_epoch = arg;
+		return 0;
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
+static const struct rtc_class_ops alpha_rtc_ops = {
+	.read_time = alpha_rtc_read_time,
+	.set_time = alpha_rtc_set_time,
+	.set_mmss = alpha_rtc_set_mmss,
+	.ioctl = alpha_rtc_ioctl,
+};
+
+/*
+ * Similarly, except do the actual CMOS access on the boot cpu only.
+ * This requires marshalling the data across an interprocessor call.
+ */
+
+#if defined(CONFIG_SMP) && \
+    (defined(CONFIG_ALPHA_GENERIC) || defined(CONFIG_ALPHA_MARVEL))
+# define HAVE_REMOTE_RTC 1
+
+union remote_data {
+	struct rtc_time *tm;
+	unsigned long now;
+	long retval;
+};
+
+static void
+do_remote_read(void *data)
+{
+	union remote_data *x = data;
+	x->retval = alpha_rtc_read_time(NULL, x->tm);
+}
+
+static int
+remote_read_time(struct device *dev, struct rtc_time *tm)
+{
+	union remote_data x;
+	if (smp_processor_id() != boot_cpuid) {
+		x.tm = tm;
+		smp_call_function_single(boot_cpuid, do_remote_read, &x, 1);
+		return x.retval;
+	}
+	return alpha_rtc_read_time(NULL, tm);
+}
+
+static void
+do_remote_set(void *data)
+{
+	union remote_data *x = data;
+	x->retval = alpha_rtc_set_time(NULL, x->tm);
+}
+
+static int
+remote_set_time(struct device *dev, struct rtc_time *tm)
+{
+	union remote_data x;
+	if (smp_processor_id() != boot_cpuid) {
+		x.tm = tm;
+		smp_call_function_single(boot_cpuid, do_remote_set, &x, 1);
+		return x.retval;
+	}
+	return alpha_rtc_set_time(NULL, tm);
+}
+
+static void
+do_remote_mmss(void *data)
+{
+	union remote_data *x = data;
+	x->retval = alpha_rtc_set_mmss(NULL, x->now);
+}
+
+static int
+remote_set_mmss(struct device *dev, unsigned long now)
+{
+	union remote_data x;
+	if (smp_processor_id() != boot_cpuid) {
+		x.now = now;
+		smp_call_function_single(boot_cpuid, do_remote_mmss, &x, 1);
+		return x.retval;
+	}
+	return alpha_rtc_set_mmss(NULL, now);
+}
+
+static const struct rtc_class_ops remote_rtc_ops = {
+	.read_time = remote_read_time,
+	.set_time = remote_set_time,
+	.set_mmss = remote_set_mmss,
+	.ioctl = alpha_rtc_ioctl,
+};
+#endif
+
+static int __init
+alpha_rtc_init(void)
+{
+	const struct rtc_class_ops *ops;
+	struct platform_device *pdev;
+	struct rtc_device *rtc;
+	const char *name;
+
+	init_rtc_epoch();
+	name = "rtc-alpha";
+	ops = &alpha_rtc_ops;
+
+#ifdef HAVE_REMOTE_RTC
+	if (alpha_mv.rtc_boot_cpu_only)
+		ops = &remote_rtc_ops;
+#endif
+
+	pdev = platform_device_register_simple(name, -1, NULL, 0);
+	rtc = devm_rtc_device_register(&pdev->dev, name, ops, THIS_MODULE);
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
+
+	platform_set_drvdata(pdev, rtc);
+	return 0;
+}
+device_initcall(alpha_rtc_init);
diff --git a/arch/alpha/kernel/sys_jensen.c b/arch/alpha/kernel/sys_jensen.c
index 5a0af11..608f2a7 100644
--- a/arch/alpha/kernel/sys_jensen.c
+++ b/arch/alpha/kernel/sys_jensen.c
@@ -224,8 +224,6 @@ struct alpha_machine_vector jensen_mv __initmv = {
 	.machine_check		= jensen_machine_check,
 	.max_isa_dma_address	= ALPHA_MAX_ISA_DMA_ADDRESS,
 	.rtc_port		= 0x170,
-	.rtc_get_time		= common_get_rtc_time,
-	.rtc_set_time		= common_set_rtc_time,
 
 	.nr_irqs		= 16,
 	.device_interrupt	= jensen_device_interrupt,
diff --git a/arch/alpha/kernel/sys_marvel.c b/arch/alpha/kernel/sys_marvel.c
index 53d6e4a..03d63c6 100644
--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -22,7 +22,6 @@
 #include <asm/hwrpb.h>
 #include <asm/tlbflush.h>
 #include <asm/vga.h>
-#include <asm/rtc.h>
 
 #include "proto.h"
 #include "err_impl.h"
@@ -400,57 +399,6 @@ marvel_init_rtc(void)
 	init_rtc_irq();
 }
 
-struct marvel_rtc_time {
-	struct rtc_time *time;
-	int retval;
-};
-
-#ifdef CONFIG_SMP
-static void
-smp_get_rtc_time(void *data)
-{
-	struct marvel_rtc_time *mrt = data;
-	mrt->retval = __get_rtc_time(mrt->time);
-}
-
-static void
-smp_set_rtc_time(void *data)
-{
-	struct marvel_rtc_time *mrt = data;
-	mrt->retval = __set_rtc_time(mrt->time);
-}
-#endif
-
-static unsigned int
-marvel_get_rtc_time(struct rtc_time *time)
-{
-#ifdef CONFIG_SMP
-	struct marvel_rtc_time mrt;
-
-	if (smp_processor_id() != boot_cpuid) {
-		mrt.time = time;
-		smp_call_function_single(boot_cpuid, smp_get_rtc_time, &mrt, 1);
-		return mrt.retval;
-	}
-#endif
-	return __get_rtc_time(time);
-}
-
-static int
-marvel_set_rtc_time(struct rtc_time *time)
-{
-#ifdef CONFIG_SMP
-	struct marvel_rtc_time mrt;
-
-	if (smp_processor_id() != boot_cpuid) {
-		mrt.time = time;
-		smp_call_function_single(boot_cpuid, smp_set_rtc_time, &mrt, 1);
-		return mrt.retval;
-	}
-#endif
-	return __set_rtc_time(time);
-}
-
 static void
 marvel_smp_callin(void)
 {
@@ -492,8 +440,7 @@ struct alpha_machine_vector marvel_ev7_mv __initmv = {
 	.vector_name		= "MARVEL/EV7",
 	DO_EV7_MMU,
 	.rtc_port		= 0x70,
-	.rtc_get_time		= marvel_get_rtc_time,
-	.rtc_set_time		= marvel_set_rtc_time,
+	.rtc_boot_cpu_only	= 1,
 	DO_MARVEL_IO,
 	.machine_check		= marvel_machine_check,
 	.max_isa_dma_address	= ALPHA_MAX_ISA_DMA_ADDRESS,
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index 7938bf9..dbd56ec 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -3,13 +3,7 @@
  *
  *  Copyright (C) 1991, 1992, 1995, 1999, 2000  Linus Torvalds
  *
- * This file contains the PC-specific time handling details:
- * reading the RTC at bootup, etc..
- * 1994-07-02    Alan Modra
- *	fixed set_rtc_mmss, fixed time.year for >= 2000, new mktime
- * 1995-03-26    Markus Kuhn
- *      fixed 500 ms bug at call to set_rtc_mmss, fixed DS12887
- *      precision CMOS clock update
+ * This file contains the clocksource time handling.
  * 1997-09-10	Updated NTP code according to technical memorandum Jan '96
  *		"A Kernel Model for Precision Timekeeping" by Dave Mills
  * 1997-01-09    Adrian Sun
@@ -21,9 +15,6 @@
  * 1999-04-16	Thorsten Kranzkowski (dl8bcu@gmx.net)
  *	fixed algorithm in do_gettimeofday() for calculating the precise time
  *	from processor cycle counter (now taking lost_ticks into account)
- * 2000-08-13	Jan-Benedict Glaw <jbglaw@lug-owl.de>
- * 	Fixed time_init to be aware of epoches != 1900. This prevents
- * 	booting up in 2048 for me;) Code is stolen from rtc.c.
  * 2003-06-03	R. Scott Bailey <scott.bailey@eds.com>
  *	Tighten sanity in time_init from 1% (10,000 PPM) to 250 PPM
  */
@@ -46,7 +37,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/hwrpb.h>
-#include <asm/rtc.h>
 
 #include <linux/mc146818rtc.h>
 #include <linux/time.h>
@@ -56,8 +46,6 @@
 #include "proto.h"
 #include "irq_impl.h"
 
-static int set_rtc_mmss(unsigned long);
-
 DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL(rtc_lock);
 
@@ -110,53 +98,6 @@ static inline __u32 rpcc(void)
     return result;
 }
 
-int update_persistent_clock(struct timespec now)
-{
-	return set_rtc_mmss(now.tv_sec);
-}
-
-void read_persistent_clock(struct timespec *ts)
-{
-	unsigned int year, mon, day, hour, min, sec, epoch;
-
-	sec = CMOS_READ(RTC_SECONDS);
-	min = CMOS_READ(RTC_MINUTES);
-	hour = CMOS_READ(RTC_HOURS);
-	day = CMOS_READ(RTC_DAY_OF_MONTH);
-	mon = CMOS_READ(RTC_MONTH);
-	year = CMOS_READ(RTC_YEAR);
-
-	if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		sec = bcd2bin(sec);
-		min = bcd2bin(min);
-		hour = bcd2bin(hour);
-		day = bcd2bin(day);
-		mon = bcd2bin(mon);
-		year = bcd2bin(year);
-	}
-
-	/* PC-like is standard; used for year >= 70 */
-	epoch = 1900;
-	if (year < 20)
-		epoch = 2000;
-	else if (year >= 20 && year < 48)
-		/* NT epoch */
-		epoch = 1980;
-	else if (year >= 48 && year < 70)
-		/* Digital UNIX epoch */
-		epoch = 1952;
-
-	printk(KERN_INFO "Using epoch = %d\n", epoch);
-
-	if ((year += epoch) < 1970)
-		year += 100;
-
-	ts->tv_sec = mktime(year, mon, day, hour, min, sec);
-	ts->tv_nsec = 0;
-}
-
-
-
 /*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "xtime_update()" routine every clocktick
@@ -245,16 +186,6 @@ common_init_rtc(void)
 	init_rtc_irq();
 }
 
-unsigned int common_get_rtc_time(struct rtc_time *time)
-{
-	return __get_rtc_time(time);
-}
-
-int common_set_rtc_time(struct rtc_time *time)
-{
-	return __set_rtc_time(time);
-}
-
 /* Validate a computed cycle counter result against the known bounds for
    the given processor core.  There's too much brokenness in the way of
    timing hardware for any one method to work everywhere.  :-(
@@ -455,78 +386,3 @@ time_init(void)
 	/* Startup the timer source. */
 	alpha_mv.init_rtc();
 }
-
-/*
- * In order to set the CMOS clock precisely, set_rtc_mmss has to be
- * called 500 ms after the second nowtime has started, because when
- * nowtime is written into the registers of the CMOS clock, it will
- * jump to the next second precisely 500 ms later. Check the Motorola
- * MC146818A or Dallas DS12887 data sheet for details.
- *
- * BUG: This routine does not handle hour overflow properly; it just
- *      sets the minutes. Usually you won't notice until after reboot!
- */
-
-
-static int
-set_rtc_mmss(unsigned long nowtime)
-{
-	int retval = 0;
-	int real_seconds, real_minutes, cmos_minutes;
-	unsigned char save_control, save_freq_select;
-
-	/* irq are locally disabled here */
-	spin_lock(&rtc_lock);
-	/* Tell the clock it's being set */
-	save_control = CMOS_READ(RTC_CONTROL);
-	CMOS_WRITE((save_control|RTC_SET), RTC_CONTROL);
-
-	/* Stop and reset prescaler */
-	save_freq_select = CMOS_READ(RTC_FREQ_SELECT);
-	CMOS_WRITE((save_freq_select|RTC_DIV_RESET2), RTC_FREQ_SELECT);
-
-	cmos_minutes = CMOS_READ(RTC_MINUTES);
-	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		cmos_minutes = bcd2bin(cmos_minutes);
-
-	/*
-	 * since we're only adjusting minutes and seconds,
-	 * don't interfere with hour overflow. This avoids
-	 * messing with unknown time zones but requires your
-	 * RTC not to be off by more than 15 minutes
-	 */
-	real_seconds = nowtime % 60;
-	real_minutes = nowtime / 60;
-	if (((abs(real_minutes - cmos_minutes) + 15)/30) & 1) {
-		/* correct for half hour time zone */
-		real_minutes += 30;
-	}
-	real_minutes %= 60;
-
-	if (abs(real_minutes - cmos_minutes) < 30) {
-		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-			real_seconds = bin2bcd(real_seconds);
-			real_minutes = bin2bcd(real_minutes);
-		}
-		CMOS_WRITE(real_seconds,RTC_SECONDS);
-		CMOS_WRITE(real_minutes,RTC_MINUTES);
-	} else {
-		printk_once(KERN_NOTICE
-		       "set_rtc_mmss: can't update from %d to %d\n",
-		       cmos_minutes, real_minutes);
- 		retval = -1;
-	}
-
-	/* The following flags have to be released exactly in this order,
-	 * otherwise the DS12887 (popular MC146818A clone with integrated
-	 * battery and quartz) will not reset the oscillator and will not
-	 * update precisely 500 ms later. You won't find this mentioned in
-	 * the Dallas Semiconductor data sheets, but who believes data
-	 * sheets anyway ...                           -- Markus Kuhn
-	 */
-	CMOS_WRITE(save_control, RTC_CONTROL);
-	CMOS_WRITE(save_freq_select, RTC_FREQ_SELECT);
-	spin_unlock(&rtc_lock);
-
-	return retval;
-}
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 9e3498b..a4d3f9a 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -606,7 +606,7 @@ comment "Platform RTC drivers"
 
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS'"
-	depends on X86 || ALPHA || ARM || M32R || ATARI || PPC || MIPS || SPARC64
+	depends on X86 || ARM || M32R || ATARI || PPC || MIPS || SPARC64
 	default y if X86
 	help
 	  Say "yes" here to get direct support for the real time clock
@@ -623,6 +623,14 @@ config RTC_DRV_CMOS
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-cmos.
 
+config RTC_DRV_ALPHA
+	bool "Alpha PC-style CMOS"
+	depends on ALPHA
+	default y
+	help
+	  Direct support for the real-time clock found on every Alpha
+	  system, specifically MC146818 compatibles.  If in doubt, say Y.
+
 config RTC_DRV_VRTC
 	tristate "Virtual RTC for Intel MID platforms"
 	depends on X86_INTEL_MID
-- 
1.8.1.4

