Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbaGPVXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:23:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:59580 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaGPVDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:03:50 -0400
Message-Id: <20140716205052.257794289@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:03:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 01/64] tile: Convert VDSO timekeeping to the precise
 mechanism
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=tile-fix-broken-vdso.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code was only halfarsed converted to the new VSDO update mechanism
and still uses the inaccurate base value which lacks the fractional
part of xtime_nsec. Fix it up.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/tile/kernel/time.c               |    9 ++++-----
 arch/tile/kernel/vdso/vgettimeofday.c |    7 ++++---
 2 files changed, 8 insertions(+), 8 deletions(-)

Index: tip/arch/tile/kernel/time.c
===================================================================
--- tip.orig/arch/tile/kernel/time.c
+++ tip/arch/tile/kernel/time.c
@@ -260,7 +260,6 @@ void update_vsyscall_tz(void)
 
 void update_vsyscall(struct timekeeper *tk)
 {
-	struct timespec wall_time = tk_xtime(tk);
 	struct timespec *wtm = &tk->wall_to_monotonic;
 	struct clocksource *clock = tk->clock;
 
@@ -271,12 +270,12 @@ void update_vsyscall(struct timekeeper *
 	++vdso_data->tb_update_count;
 	smp_wmb();
 	vdso_data->xtime_tod_stamp = clock->cycle_last;
-	vdso_data->xtime_clock_sec = wall_time.tv_sec;
-	vdso_data->xtime_clock_nsec = wall_time.tv_nsec;
+	vdso_data->xtime_clock_sec = tk->xtime_sec;
+	vdso_data->xtime_clock_nsec = tk->xtime_nsec;
 	vdso_data->wtom_clock_sec = wtm->tv_sec;
 	vdso_data->wtom_clock_nsec = wtm->tv_nsec;
-	vdso_data->mult = clock->mult;
-	vdso_data->shift = clock->shift;
+	vdso_data->mult = tk->mult;
+	vdso_data->shift = tk->shift;
 	smp_wmb();
 	++vdso_data->tb_update_count;
 }
Index: tip/arch/tile/kernel/vdso/vgettimeofday.c
===================================================================
--- tip.orig/arch/tile/kernel/vdso/vgettimeofday.c
+++ tip/arch/tile/kernel/vdso/vgettimeofday.c
@@ -83,10 +83,11 @@ int __vdso_gettimeofday(struct timeval *
 		if (count & 1)
 			continue;
 
-		cycles = (get_cycles() - vdso_data->xtime_tod_stamp);
-		ns = (cycles * vdso_data->mult) >> vdso_data->shift;
 		sec = vdso_data->xtime_clock_sec;
-		ns += vdso_data->xtime_clock_nsec;
+		cycles = get_cycles() - vdso_data->xtime_tod_stamp;
+		ns = (cycles * vdso_data->mult) + vdso_data->xtime_clock_nsec;
+		ns >>= vdso_data->shift;
+
 		if (ns >= NSEC_PER_SEC) {
 			ns -= NSEC_PER_SEC;
 			sec += 1;


