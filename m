Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaJ0Fr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:47:56 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45449 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaJ0Fry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:47:54 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH RFC 12/12] time: Convert pvclock_read_wallclock() to use timespec64
Date: Mon, 27 Oct 2014 13:46:42 +0800
Message-Id: <1414388802-5866-11-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
References: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel uses 32-bit signed value(time_t) for seconds since 1970-01-01:00:00:00, so it
will overflow at 2038-01-19 03:14:08 on 32-bit systems. We call this "2038 safety" issue.

As part of addressing 2038 safety for in-kernel uses, this patch creates no functional change
in existing users, converts pvclock_read_wallclock() to use timespec64 instead of timespec.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 arch/x86/include/asm/pvclock.h |    2 +-
 arch/x86/kernel/kvmclock.c     |    7 +++++--
 arch/x86/kernel/pvclock.c      |    8 ++++----
 arch/x86/xen/time.c            |   10 ++--------
 4 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
index d6b078e..3323413 100644
--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -11,7 +11,7 @@ void pvclock_set_flags(u8 flags);
 unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src);
 void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
 			    struct pvclock_vcpu_time_info *vcpu,
-			    struct timespec *ts);
+			    struct timespec64 *ts);
 void pvclock_resume(void);
 
 void pvclock_touch_watchdogs(void);
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index d9156ce..7cd3511 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -46,10 +46,12 @@ static struct pvclock_wall_clock wall_clock;
 /*
  * The wallclock is the time of day when we booted. Since then, some time may
  * have elapsed since the hypervisor wrote the data. So we try to account for
- * that with system time
+ * that with system time.
+ * TODO: [2038 safety] kvm_get_wallclock() should be fixed to use timespec64.
  */
 static void kvm_get_wallclock(struct timespec *now)
 {
+	struct timespec64 now64;
 	struct pvclock_vcpu_time_info *vcpu_time;
 	int low, high;
 	int cpu;
@@ -63,7 +65,8 @@ static void kvm_get_wallclock(struct timespec *now)
 	cpu = smp_processor_id();
 
 	vcpu_time = &hv_clock[cpu].pvti;
-	pvclock_read_wallclock(&wall_clock, vcpu_time, now);
+	pvclock_read_wallclock(&wall_clock, vcpu_time, &now64);
+	*now = timespec64_to_timespec(now64);
 
 	preempt_enable();
 }
diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 2f355d2..ae3ae07 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -117,17 +117,17 @@ cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 
 void pvclock_read_wallclock(struct pvclock_wall_clock *wall_clock,
 			    struct pvclock_vcpu_time_info *vcpu_time,
-			    struct timespec *ts)
+			    struct timespec64 *ts)
 {
 	u32 version;
 	u64 delta;
-	struct timespec now;
+	struct timespec64 now;
 
 	/* get wallclock at system boot */
 	do {
 		version = wall_clock->version;
 		rmb();		/* fetch version before time */
-		now.tv_sec  = wall_clock->sec;
+		now.tv_sec  = (time64_t)wall_clock->sec; /* TODO: [2038 safety] wall_clock->sec uses time64_t */
 		now.tv_nsec = wall_clock->nsec;
 		rmb();		/* fetch time before checking version */
 	} while ((wall_clock->version & 1) || (version != wall_clock->version));
@@ -138,7 +138,7 @@ void pvclock_read_wallclock(struct pvclock_wall_clock *wall_clock,
 	now.tv_nsec = do_div(delta, NSEC_PER_SEC);
 	now.tv_sec = delta;
 
-	set_normalized_timespec(ts, now.tv_sec, now.tv_nsec);
+	set_normalized_timespec64(ts, now.tv_sec, now.tv_nsec);
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 2ce064a..97dd201 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -171,18 +171,12 @@ static cycle_t xen_clocksource_get_cycles(struct clocksource *cs)
 
 static void xen_read_wallclock(struct timespec64 *ts)
 {
-	struct timespec ts32;
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct pvclock_wall_clock *wall_clock = &(s->wc);
-        struct pvclock_vcpu_time_info *vcpu_time;
+	struct pvclock_vcpu_time_info *vcpu_time;
 
 	vcpu_time = &get_cpu_var(xen_vcpu)->time;
-	/*
-	 * TODO: [2038 safety] pvclock_read_wallclock() should be changed
-	 * to use timespec64 for 2038 safety as soon as possible.
-	 */
-	pvclock_read_wallclock(wall_clock, vcpu_time, &ts32);
-	*ts = timespec_to_timespec64(ts32);
+	pvclock_read_wallclock(wall_clock, vcpu_time, ts);
 	put_cpu_var(xen_vcpu);
 }
 
-- 
1.7.9.5

