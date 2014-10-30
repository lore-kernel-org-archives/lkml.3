Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbaJ3LRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:17:50 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:57494 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759381AbaJ3LRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:17:45 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, xen-devel@lists.xenproject.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 10/11] time: Convert x86_platform.set_wallclock()to use timespec64
Date: Thu, 30 Oct 2014 19:15:44 +0800
Message-Id: <1414667745-7703-11-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of addressing 2038 saftey for in-kernel uses, this patch
creates no functional change, converts x86_platform.set_wallclock()
to use timespec64.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 arch/x86/include/asm/intel_mid_vrtc.h        |    2 +-
 arch/x86/include/asm/mc146818rtc.h           |    2 +-
 arch/x86/include/asm/x86_init.h              |    3 ++-
 arch/x86/kernel/kvmclock.c                   |    2 +-
 arch/x86/kernel/rtc.c                        |   16 ++++++++++------
 arch/x86/platform/intel-mid/intel_mid_vrtc.c |    8 ++++----
 arch/x86/xen/time.c                          |    2 +-
 7 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/intel_mid_vrtc.h b/arch/x86/include/asm/intel_mid_vrtc.h
index 86ff468..6ad9082 100644
--- a/arch/x86/include/asm/intel_mid_vrtc.h
+++ b/arch/x86/include/asm/intel_mid_vrtc.h
@@ -4,6 +4,6 @@
 extern unsigned char vrtc_cmos_read(unsigned char reg);
 extern void vrtc_cmos_write(unsigned char val, unsigned char reg);
 extern void vrtc_get_time(struct timespec *now);
-extern int vrtc_set_mmss(const struct timespec *now);
+extern int vrtc_set_mmss(const struct timespec64 *now);
 
 #endif
diff --git a/arch/x86/include/asm/mc146818rtc.h b/arch/x86/include/asm/mc146818rtc.h
index 0f555cc..ca88a23 100644
--- a/arch/x86/include/asm/mc146818rtc.h
+++ b/arch/x86/include/asm/mc146818rtc.h
@@ -95,7 +95,7 @@ static inline unsigned char current_lock_cmos_reg(void)
 unsigned char rtc_cmos_read(unsigned char addr);
 void rtc_cmos_write(unsigned char val, unsigned char addr);
 
-extern int mach_set_rtc_mmss(const struct timespec *now);
+extern int mach_set_rtc_mmss(const struct timespec64 *now);
 extern void mach_get_cmos_time(struct timespec *now);
 
 #define RTC_IRQ 8
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index e45e4da..83ed049 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -143,6 +143,7 @@ struct x86_cpuinit_ops {
 };
 
 struct timespec;
+struct timespec64;
 
 /**
  * struct x86_platform_ops - platform specific runtime functions
@@ -159,7 +160,7 @@ struct timespec;
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
 	void (*get_wallclock)(struct timespec *ts);
-	int (*set_wallclock)(const struct timespec *ts);
+	int (*set_wallclock)(const struct timespec64 *ts);
 	void (*iommu_shutdown)(void);
 	bool (*is_untracked_pat_range)(u64 start, u64 end);
 	void (*nmi_init)(void);
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 7cd3511..e51e1eb 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -71,7 +71,7 @@ static void kvm_get_wallclock(struct timespec *now)
 	preempt_enable();
 }
 
-static int kvm_set_wallclock(const struct timespec *now)
+static int kvm_set_wallclock(const struct timespec64 *now)
 {
 	return -1;
 }
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index ca9622a..2bf87a7 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -38,13 +38,13 @@ EXPORT_SYMBOL(rtc_lock);
  * jump to the next second precisely 500 ms later. Check the Motorola
  * MC146818A or Dallas DS12887 data sheet for details.
  */
-int mach_set_rtc_mmss(const struct timespec *now)
+int mach_set_rtc_mmss(const struct timespec64 *now)
 {
-	unsigned long nowtime = now->tv_sec;
+	time64_t nowtime = now->tv_sec;
 	struct rtc_time tm;
 	int retval = 0;
 
-	rtc_time_to_tm(nowtime, &tm);
+	rtc_time_to_tm64(nowtime, &tm);
 	if (!rtc_valid_tm(&tm)) {
 		retval = set_rtc_time(&tm);
 		if (retval)
@@ -52,8 +52,8 @@ int mach_set_rtc_mmss(const struct timespec *now)
 			       __FUNCTION__, retval);
 	} else {
 		printk(KERN_ERR
-		       "%s: Invalid RTC value: write of %lx to RTC failed\n",
-			__FUNCTION__, nowtime);
+		       "%s: Invalid RTC value: write of %llx to RTC failed\n",
+			__FUNCTION__, (unsigned long long)nowtime);
 		retval = -EINVAL;
 	}
 	return retval;
@@ -135,9 +135,13 @@ void rtc_cmos_write(unsigned char val, unsigned char addr)
 }
 EXPORT_SYMBOL(rtc_cmos_write);
 
+/* TODO: [2038 safety] update_persistent_clock() uses timespec64 */
 int update_persistent_clock(struct timespec now)
 {
-	return x86_platform.set_wallclock(&now);
+	struct timespec64 now64;
+
+	now64 = timespec_to_timespec64(now);
+	return x86_platform.set_wallclock(&now64);
 }
 
 /* not static: needed by APM */
diff --git a/arch/x86/platform/intel-mid/intel_mid_vrtc.c b/arch/x86/platform/intel-mid/intel_mid_vrtc.c
index 4762cff..a370b83 100644
--- a/arch/x86/platform/intel-mid/intel_mid_vrtc.c
+++ b/arch/x86/platform/intel-mid/intel_mid_vrtc.c
@@ -86,14 +86,14 @@ void vrtc_get_time(struct timespec *now)
 	now->tv_nsec = 0;
 }
 
-int vrtc_set_mmss(const struct timespec *now)
+int vrtc_set_mmss(const struct timespec64 *now)
 {
 	unsigned long flags;
 	struct rtc_time tm;
 	int year;
 	int retval = 0;
 
-	rtc_time_to_tm(now->tv_sec, &tm);
+	rtc_time_to_tm64(now->tv_sec, &tm);
 	if (!rtc_valid_tm(&tm) && tm.tm_year >= 72) {
 		/*
 		 * tm.year is the number of years since 1900, and the
@@ -109,8 +109,8 @@ int vrtc_set_mmss(const struct timespec *now)
 		vrtc_cmos_write(tm.tm_sec, RTC_SECONDS);
 		spin_unlock_irqrestore(&rtc_lock, flags);
 	} else {
-		pr_err("%s: Invalid vRTC value: write of %lx to vRTC failed\n",
-			__FUNCTION__, now->tv_sec);
+		pr_err("%s: Invalid vRTC value: write of %llx to vRTC failed\n",
+			__FUNCTION__, (unsigned long long)now->tv_sec);
 		retval = -EINVAL;
 	}
 	return retval;
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 79053ee..b30ed24 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -189,7 +189,7 @@ static void xen_get_wallclock(struct timespec *now)
 	*now = timespec64_to_timespec(now64);
 }
 
-static int xen_set_wallclock(const struct timespec *now)
+static int xen_set_wallclock(const struct timespec64 *now)
 {
 	return -1;
 }
-- 
1.7.9.5

