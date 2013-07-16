Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676Ab3GPRgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:36:31 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:44071 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933612Ab3GPRfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:35:07 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org
Subject: [RFC PATCH 07/10] alpha: Add an rtc driver for the qemu wallclock PALcall
Date: Tue, 16 Jul 2013 10:34:15 -0700
Message-Id: <1373996058-13399-8-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373996058-13399-1-git-send-email-rth@twiddle.net>
References: <1373996058-13399-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the normal case, one wants the guest to follow the host time.
QEMU has a cserve call that retrieves the wall clock.

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/include/asm/pal.h | 56 ++++++++++++++++++++++++++++++++++++++
 arch/alpha/kernel/Makefile   |  3 +-
 arch/alpha/kernel/rtc.c      | 65 +++++++++++++++++++++++++++++++++++++++-----
 drivers/rtc/Kconfig          |  7 +++++
 4 files changed, 122 insertions(+), 9 deletions(-)

diff --git a/arch/alpha/include/asm/pal.h b/arch/alpha/include/asm/pal.h
index e78ec9b..ccaa49a 100644
--- a/arch/alpha/include/asm/pal.h
+++ b/arch/alpha/include/asm/pal.h
@@ -112,5 +112,61 @@ __CALL_PAL_RW1(wtint, unsigned long, unsigned long);
 #define tbiap()		__tbi(-1, /* no second argument */)
 #define tbia()		__tbi(-2, /* no second argument */)
 
+/*
+ * QEMU Cserv routines..
+ */
+
+static inline unsigned long
+qemu_get_walltime(void)
+{
+	register unsigned long v0 __asm__("$0");
+	register unsigned long a0 __asm__("$16") = 3;
+
+	asm("call_pal %2 # cserve get_time"
+	    : "=r"(v0), "+r"(a0)
+	    : "i"(PAL_cserve)
+	    : "$17", "$18", "$19", "$20", "$21");
+
+	return v0;
+}
+
+static inline unsigned long
+qemu_get_alarm(void)
+{
+	register unsigned long v0 __asm__("$0");
+	register unsigned long a0 __asm__("$16") = 4;
+
+	asm("call_pal %2 # cserve get_alarm"
+	    : "=r"(v0), "+r"(a0)
+	    : "i"(PAL_cserve)
+	    : "$17", "$18", "$19", "$20", "$21");
+
+	return v0;
+}
+
+static inline void
+qemu_set_alarm_rel(unsigned long expire)
+{
+	register unsigned long a0 __asm__("$16") = 5;
+	register unsigned long a1 __asm__("$17") = expire;
+
+	asm volatile("call_pal %2 # cserve set_alarm_rel"
+		     : "+r"(a0), "+r"(a1)
+		     : "i"(PAL_cserve)
+		     : "$0", "$18", "$19", "$20", "$21");
+}
+
+static inline void
+qemu_set_alarm_abs(unsigned long expire)
+{
+	register unsigned long a0 __asm__("$16") = 6;
+	register unsigned long a1 __asm__("$17") = expire;
+
+	asm volatile("call_pal %2 # cserve set_alarm_abs"
+		     : "+r"(a0), "+r"(a1)
+		     : "i"(PAL_cserve)
+		     : "$0", "$18", "$19", "$20", "$21");
+}
+
 #endif /* !__ASSEMBLY__ */
 #endif /* __ALPHA_PAL_H */
diff --git a/arch/alpha/kernel/Makefile b/arch/alpha/kernel/Makefile
index 0d54650..bf04ee8 100644
--- a/arch/alpha/kernel/Makefile
+++ b/arch/alpha/kernel/Makefile
@@ -8,7 +8,7 @@ ccflags-y	:= -Wno-sign-compare
 
 obj-y    := entry.o traps.o process.o osf_sys.o irq.o \
 	    irq_alpha.o signal.o setup.o ptrace.o time.o \
-	    alpha_ksyms.o systbls.o err_common.o io.o
+	    alpha_ksyms.o systbls.o err_common.o io.o rtc.o
 
 obj-$(CONFIG_VGA_HOSE)	+= console.o
 obj-$(CONFIG_SMP)	+= smp.o
@@ -16,7 +16,6 @@ obj-$(CONFIG_PCI)	+= pci.o pci_iommu.o pci-sysfs.o
 obj-$(CONFIG_SRM_ENV)	+= srm_env.o
 obj-$(CONFIG_MODULES)	+= module.o
 obj-$(CONFIG_PERF_EVENTS) += perf_event.o
-obj-$(CONFIG_RTC_DRV_ALPHA) += rtc.o
 
 ifdef CONFIG_ALPHA_GENERIC
 
diff --git a/arch/alpha/kernel/rtc.c b/arch/alpha/kernel/rtc.c
index c8d284d..fd910ff 100644
--- a/arch/alpha/kernel/rtc.c
+++ b/arch/alpha/kernel/rtc.c
@@ -16,10 +16,12 @@
 #include <linux/platform_device.h>
 
 #include <asm/rtc.h>
+#include <asm/pal.h>
 
 #include "proto.h"
 
 
+#ifdef CONFIG_RTC_DRV_ALPHA
 /*
  * Support for the RTC device.
  *
@@ -293,20 +295,68 @@ static const struct rtc_class_ops remote_rtc_ops = {
 	.set_mmss = remote_set_mmss,
 	.ioctl = alpha_rtc_ioctl,
 };
-#endif
+#endif /* HAVE_REMOTE_RTC */
+#endif /* CONFIG_RTC_DRV_ALPHA */
+
+#ifdef CONFIG_RTC_DRV_ALPHA_QEMU
+/*
+ * Support for the QEMU wall clock as an RTC device.
+ */
+
+static int
+qemu_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	unsigned long nsec = qemu_get_walltime();
+	unsigned long sec = nsec / NSEC_PER_SEC;
 
+	rtc_time_to_tm(sec, tm);
+	return 0;
+}
+
+static int
+qemu_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	return -EOPNOTSUPP;
+}
+
+static int
+qemu_rtc_set_mmss(struct device *dev, unsigned long sec)
+{
+	return -EOPNOTSUPP;
+}
+
+static const struct rtc_class_ops qemu_rtc_ops = {
+	.read_time = qemu_rtc_read_time,
+	.set_time = qemu_rtc_set_time,
+	.set_mmss = qemu_rtc_set_mmss,
+};
+#endif /* CONFIG_RTC_DRV_ALPHA_QEMU */
+
+#if defined(CONFIG_RTC_DRV_ALPHA) || defined(CONFIG_RTC_DRV_ALPHA_QEMU)
 static int __init
-alpha_rtc_init(void)
+rtc_init(void)
 {
 	const struct rtc_class_ops *ops;
 	struct platform_device *pdev;
 	struct rtc_device *rtc;
 	const char *name;
 
+#ifdef CONFIG_RTC_DRV_ALPHA_QEMU
+	if (alpha_using_qemu) {
+		name = "rtc-qemu";
+		ops = &qemu_rtc_ops;
+
+		pdev = platform_device_register_simple(name, -1, NULL, 0);
+		rtc = devm_rtc_device_register(&pdev->dev, name, ops, NULL);
+		if (!IS_ERR(rtc))
+			platform_set_drvdata(pdev, rtc);
+	}
+#endif /* ALPHA_QEMU */
+
+#ifdef CONFIG_RTC_DRV_ALPHA
 	init_rtc_epoch();
 	name = "rtc-alpha";
 	ops = &alpha_rtc_ops;
-
 #ifdef HAVE_REMOTE_RTC
 	if (alpha_mv.rtc_boot_cpu_only)
 		ops = &remote_rtc_ops;
@@ -314,10 +364,11 @@ alpha_rtc_init(void)
 
 	pdev = platform_device_register_simple(name, -1, NULL, 0);
 	rtc = devm_rtc_device_register(&pdev->dev, name, ops, THIS_MODULE);
-	if (IS_ERR(rtc))
-		return PTR_ERR(rtc);
+	if (!IS_ERR(rtc))
+		platform_set_drvdata(pdev, rtc);
+#endif /* ALPHA */
 
-	platform_set_drvdata(pdev, rtc);
 	return 0;
 }
-device_initcall(alpha_rtc_init);
+device_initcall(rtc_init);
+#endif
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index a4d3f9a..1884ca4 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -631,6 +631,13 @@ config RTC_DRV_ALPHA
 	  Direct support for the real-time clock found on every Alpha
 	  system, specifically MC146818 compatibles.  If in doubt, say Y.
 
+config RTC_DRV_ALPHA_QEMU
+	bool "Alpha QEMU paravirtual RTC"
+	depends on ALPHA
+	default y if ALPHA_QEMU
+	help
+	  Support for the paravirtual real-time clock found in QEMU.
+
 config RTC_DRV_VRTC
 	tristate "Virtual RTC for Intel MID platforms"
 	depends on X86_INTEL_MID
-- 
1.8.1.4

