Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbaJ3LRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:17:37 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43417 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759381AbaJ3LRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:17:34 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, xen-devel@lists.xenproject.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 08/11] time: Convert xen_read_wallclock() to use timespec64
Date: Thu, 30 Oct 2014 19:15:42 +0800
Message-Id: <1414667745-7703-9-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of addressing 2038 safety for in-kernel uses, this patch
creates no functional change, converts xen_read_wallclock() to
use timespec64 instead of timespec.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 arch/x86/xen/time.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 16fce39..4e14439 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -169,20 +169,27 @@ static cycle_t xen_clocksource_get_cycles(struct clocksource *cs)
 	return xen_clocksource_read();
 }
 
-static void xen_read_wallclock(struct timespec *ts)
+static void xen_read_wallclock(struct timespec64 *ts)
 {
+	struct timespec ts_unsafe;
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct pvclock_wall_clock *wall_clock = &(s->wc);
         struct pvclock_vcpu_time_info *vcpu_time;
 
 	vcpu_time = &get_cpu_var(xen_vcpu)->time;
-	pvclock_read_wallclock(wall_clock, vcpu_time, ts);
+	/* TODO: [2038 safety] pvclock_read_wallclock() uses timespec64 */
+	pvclock_read_wallclock(wall_clock, vcpu_time, &ts_unsafe);
+	*ts = timespec_to_timespec64(ts_unsafe);
 	put_cpu_var(xen_vcpu);
 }
 
+/* TODO: [2038 safety] xen_get_wallclock() uses timespec64 */
 static void xen_get_wallclock(struct timespec *now)
 {
-	xen_read_wallclock(now);
+	struct timespec64 now64;
+
+	xen_read_wallclock(&now64);
+	*now = timespec64_to_timespec(now64);
 }
 
 static int xen_set_wallclock(const struct timespec *now)
@@ -485,8 +492,7 @@ static const struct pv_time_ops xen_time_ops __initconst = {
 static void __init xen_time_init(void)
 {
 	int cpu = smp_processor_id();
-	struct timespec tp;
-	struct timespec64 tp64;
+	struct timespec64 tp;
 
 	clocksource_register_hz(&xen_clocksource, NSEC_PER_SEC);
 
@@ -497,13 +503,8 @@ static void __init xen_time_init(void)
 		xen_clockevent = &xen_vcpuop_clockevent;
 	}
 
-	/*
-	 * Set initial system time with full resolution
-	 * TODO: [2038 safety] xen_read_wallclock() uses timespec64
-	 */
 	xen_read_wallclock(&tp);
-	tp64 = timespec_to_timespec64(tp);
-	do_settimeofday64(&tp64);
+	do_settimeofday64(&tp);
 
 	setup_force_cpu_cap(X86_FEATURE_TSC);
 
-- 
1.7.9.5

