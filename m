Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaJ0Frx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:47:53 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40764 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaJ0Fru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:47:50 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH RFC 11/12] time: Convert xen_read_wallclock() to use timespec64
Date: Mon, 27 Oct 2014 13:46:41 +0800
Message-Id: <1414388802-5866-10-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
References: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel uses 32-bit signed value(time_t) for seconds since 1970-01-01:00:00:00, so it
will overflow at 2038-01-19 03:14:08 on 32-bit systems. We call this "2038 safety" issue.

As part of addressing 2038 safety for in-kernel uses, this patch creates no functional change
in existing users, converts xen_read_wallclock() to use timespec64 instead of timespec.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 arch/x86/xen/time.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index cf1b591..2ce064a 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -169,20 +169,33 @@ static cycle_t xen_clocksource_get_cycles(struct clocksource *cs)
 	return xen_clocksource_read();
 }
 
-static void xen_read_wallclock(struct timespec *ts)
+static void xen_read_wallclock(struct timespec64 *ts)
 {
+	struct timespec ts32;
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct pvclock_wall_clock *wall_clock = &(s->wc);
         struct pvclock_vcpu_time_info *vcpu_time;
 
 	vcpu_time = &get_cpu_var(xen_vcpu)->time;
-	pvclock_read_wallclock(wall_clock, vcpu_time, ts);
+	/*
+	 * TODO: [2038 safety] pvclock_read_wallclock() should be changed
+	 * to use timespec64 for 2038 safety as soon as possible.
+	 */
+	pvclock_read_wallclock(wall_clock, vcpu_time, &ts32);
+	*ts = timespec_to_timespec64(ts32);
 	put_cpu_var(xen_vcpu);
 }
 
+/*
+ * TODO: [2038 safety] xen_get_wallclock() should be changed to use
+ * timespec64 for 2038 safety as soon as possible.
+ */
 static void xen_get_wallclock(struct timespec *now)
 {
-	xen_read_wallclock(now);
+	struct timespec64 now64;
+
+	xen_read_wallclock(&now64);
+	*now = timespec64_to_timespec(now64);
 }
 
 static int xen_set_wallclock(const struct timespec *now)
@@ -485,8 +498,7 @@ static const struct pv_time_ops xen_time_ops __initconst = {
 static void __init xen_time_init(void)
 {
 	int cpu = smp_processor_id();
-	struct timespec tp;
-	struct timespec64 tp64;
+	struct timespec64 tp;
 
 	clocksource_register_hz(&xen_clocksource, NSEC_PER_SEC);
 
@@ -497,14 +509,9 @@ static void __init xen_time_init(void)
 		xen_clockevent = &xen_vcpuop_clockevent;
 	}
 
-	/*
-	 * Set initial system time with full resolution.
-	 * TODO: [2038 safety] xen_read_wallclock() should be changed to use
-	 * timespec64 for 2038 safety as soon as possible.
-	 */
+	/* Set initial system time with full resolution. */
 	xen_read_wallclock(&tp);
-	tp64 = timespec_to_timespec64(tp);
-	do_settimeofday(&tp64);
+	do_settimeofday(&tp);
 
 	setup_force_cpu_cap(X86_FEATURE_TSC);
 
-- 
1.7.9.5

