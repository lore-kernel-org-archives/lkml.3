Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbaJ3LRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:17:55 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:37353 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758646AbaJ3LRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:17:51 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, xen-devel@lists.xenproject.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 11/11] time: Convert x86_platform.get_wallclock()to use timespec64
Date: Thu, 30 Oct 2014 19:15:45 +0800
Message-Id: <1414667745-7703-12-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of addressing 2038 saftey for in-kernel uses, this patch
creates no functional change, converts x86_platform.get_wallclock()
to use timespec64. Also changes time64.h to avoid build warnings.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 arch/x86/include/asm/intel_mid_vrtc.h        |    2 +-
 arch/x86/include/asm/mc146818rtc.h           |    2 +-
 arch/x86/include/asm/x86_init.h              |    8 +++++---
 arch/x86/kernel/kvmclock.c                   |    7 ++-----
 arch/x86/kernel/rtc.c                        |   14 ++++++++++----
 arch/x86/lguest/boot.c                       |    4 ++--
 arch/x86/platform/intel-mid/intel_mid_vrtc.c |    4 ++--
 arch/x86/xen/time.c                          |    8 ++------
 include/linux/lguest.h                       |    2 +-
 include/linux/time64.h                       |    1 +
 10 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/intel_mid_vrtc.h b/arch/x86/include/asm/intel_mid_vrtc.h
index 6ad9082..1920232 100644
--- a/arch/x86/include/asm/intel_mid_vrtc.h
+++ b/arch/x86/include/asm/intel_mid_vrtc.h
@@ -3,7 +3,7 @@
 
 extern unsigned char vrtc_cmos_read(unsigned char reg);
 extern void vrtc_cmos_write(unsigned char val, unsigned char reg);
-extern void vrtc_get_time(struct timespec *now);
+extern void vrtc_get_time(struct timespec64 *now);
 extern int vrtc_set_mmss(const struct timespec64 *now);
 
 #endif
diff --git a/arch/x86/include/asm/mc146818rtc.h b/arch/x86/include/asm/mc146818rtc.h
index ca88a23..40355e4 100644
--- a/arch/x86/include/asm/mc146818rtc.h
+++ b/arch/x86/include/asm/mc146818rtc.h
@@ -96,7 +96,7 @@ unsigned char rtc_cmos_read(unsigned char addr);
 void rtc_cmos_write(unsigned char val, unsigned char addr);
 
 extern int mach_set_rtc_mmss(const struct timespec64 *now);
-extern void mach_get_cmos_time(struct timespec *now);
+extern void mach_get_cmos_time(struct timespec64 *now);
 
 #define RTC_IRQ 8
 
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 83ed049..fded1e4 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -142,9 +142,11 @@ struct x86_cpuinit_ops {
 	void (*fixup_cpu_id)(struct cpuinfo_x86 *c, int node);
 };
 
-struct timespec;
+#ifdef CONFIG_64BIT
+#include <linux/time64.h>
+#else
 struct timespec64;
-
+#endif
 /**
  * struct x86_platform_ops - platform specific runtime functions
  * @calibrate_tsc:		calibrate TSC
@@ -159,7 +161,7 @@ struct timespec64;
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
-	void (*get_wallclock)(struct timespec *ts);
+	void (*get_wallclock)(struct timespec64 *ts);
 	int (*set_wallclock)(const struct timespec64 *ts);
 	void (*iommu_shutdown)(void);
 	bool (*is_untracked_pat_range)(u64 start, u64 end);
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index e51e1eb..c19ffc7 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -47,11 +47,9 @@ static struct pvclock_wall_clock wall_clock;
  * The wallclock is the time of day when we booted. Since then, some time may
  * have elapsed since the hypervisor wrote the data. So we try to account for
  * that with system time.
- * TODO: [2038 safety] kvm_get_wallclock() should be fixed to use timespec64.
  */
-static void kvm_get_wallclock(struct timespec *now)
+static void kvm_get_wallclock(struct timespec64 *now)
 {
-	struct timespec64 now64;
 	struct pvclock_vcpu_time_info *vcpu_time;
 	int low, high;
 	int cpu;
@@ -65,8 +63,7 @@ static void kvm_get_wallclock(struct timespec *now)
 	cpu = smp_processor_id();
 
 	vcpu_time = &hv_clock[cpu].pvti;
-	pvclock_read_wallclock(&wall_clock, vcpu_time, &now64);
-	*now = timespec64_to_timespec(now64);
+	pvclock_read_wallclock(&wall_clock, vcpu_time, now);
 
 	preempt_enable();
 }
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 2bf87a7..a142180 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -59,7 +59,7 @@ int mach_set_rtc_mmss(const struct timespec64 *now)
 	return retval;
 }
 
-void mach_get_cmos_time(struct timespec *now)
+void mach_get_cmos_time(struct timespec64 *now)
 {
 	unsigned int status, year, mon, day, hour, min, sec, century = 0;
 	unsigned long flags;
@@ -108,7 +108,7 @@ void mach_get_cmos_time(struct timespec *now)
 	} else
 		year += CMOS_YEARS_OFFS;
 
-	now->tv_sec = mktime(year, mon, day, hour, min, sec);
+	now->tv_sec = mktime64(year, mon, day, hour, min, sec);
 	now->tv_nsec = 0;
 }
 
@@ -144,10 +144,16 @@ int update_persistent_clock(struct timespec now)
 	return x86_platform.set_wallclock(&now64);
 }
 
-/* not static: needed by APM */
+/* 
+ * not static: needed by APM.
+ * TODO: [2038 safety] read_persistent_clock() uses timespec64.
+ */
 void read_persistent_clock(struct timespec *ts)
 {
-	x86_platform.get_wallclock(ts);
+	struct timespec ts64;
+
+	x86_platform.get_wallclock(&ts64);
+	*ts = timespec64_to_timespec(ts64);
 }
 
 
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index aae9413..4d2ccb6 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -881,9 +881,9 @@ int lguest_setup_irq(unsigned int irq)
  * It would be far better for everyone if the Guest had its own clock, but
  * until then the Host gives us the time on every interrupt.
  */
-static void lguest_get_wallclock(struct timespec *now)
+static void lguest_get_wallclock(struct timespec64 *now)
 {
-	*now = lguest_data.time;
+	*now = timespec_to_timespec64(lguest_data.time);
 }
 
 /*
diff --git a/arch/x86/platform/intel-mid/intel_mid_vrtc.c b/arch/x86/platform/intel-mid/intel_mid_vrtc.c
index a370b83..dbd540c 100644
--- a/arch/x86/platform/intel-mid/intel_mid_vrtc.c
+++ b/arch/x86/platform/intel-mid/intel_mid_vrtc.c
@@ -56,7 +56,7 @@ void vrtc_cmos_write(unsigned char val, unsigned char reg)
 }
 EXPORT_SYMBOL_GPL(vrtc_cmos_write);
 
-void vrtc_get_time(struct timespec *now)
+void vrtc_get_time(struct timespec64 *now)
 {
 	u8 sec, min, hour, mday, mon;
 	unsigned long flags;
@@ -82,7 +82,7 @@ void vrtc_get_time(struct timespec *now)
 	pr_info("vRTC: sec: %d min: %d hour: %d day: %d "
 		"mon: %d year: %d\n", sec, min, hour, mday, mon, year);
 
-	now->tv_sec = mktime(year, mon, mday, hour, min, sec);
+	now->tv_sec = mktime64(year, mon, mday, hour, min, sec);
 	now->tv_nsec = 0;
 }
 
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index b30ed24..dd35a3e 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -180,13 +180,9 @@ static void xen_read_wallclock(struct timespec64 *ts)
 	put_cpu_var(xen_vcpu);
 }
 
-/* TODO: [2038 safety] xen_get_wallclock() uses timespec64 */
-static void xen_get_wallclock(struct timespec *now)
+static void xen_get_wallclock(struct timespec64 *now)
 {
-	struct timespec64 now64;
-
-	xen_read_wallclock(&now64);
-	*now = timespec64_to_timespec(now64);
+	xen_read_wallclock(now);
 }
 
 static int xen_set_wallclock(const struct timespec64 *now)
diff --git a/include/linux/lguest.h b/include/linux/lguest.h
index 9962c6b..1640121 100644
--- a/include/linux/lguest.h
+++ b/include/linux/lguest.h
@@ -35,7 +35,7 @@ struct lguest_data {
 	unsigned long cr2;
 
 	/* Wallclock time set by the Host. */
-	struct timespec time;
+	struct timespec time; /* TODO: [2038 safety] to use timespec64 */
 
 	/*
 	 * Interrupt pending set by the Host.  The Guest should do a hypercall
diff --git a/include/linux/time64.h b/include/linux/time64.h
index 2f0cde4..f2172e4 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -57,6 +57,7 @@ static inline struct timespec64 timespec_to_timespec64(const struct timespec ts)
 
 #else
 
+#include <linux/math64.h>
 static inline struct timespec timespec64_to_timespec(const struct timespec64 ts64)
 {
 	struct timespec ret;
-- 
1.7.9.5

