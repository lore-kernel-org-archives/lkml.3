Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbaBUR4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:56:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:42636 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118AbaBUR4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:56:07 -0500
Message-Id: <20140221174639.461201411@linutronix.de>
User-Agent: quilt/0.60-1
Date: Fri, 21 Feb 2014 17:56:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Alexey Perevalov <a.perevalov@samsung.com>, kyungmin.park@samsung.com,
        cw00.choi@samsung.com
Subject: [RFC patch 1/5] hrtimer: Always check for HRTIMER_MODE_REL
References: <20140221173936.583477951@linutronix.de>
Content-Disposition: inline; filename=hrtimer-check-for-not-relative.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have not just HRTIMER_MODE_REL and HRTIMER_MODE_ABS, so a direct
check for mode == HRTIMER_MODE_ABS is not sufficient.

Always check for the HRTIMER_MODE_REL bit.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/hrtimer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: tip/kernel/hrtimer.c
===================================================================
--- tip.orig/kernel/hrtimer.c
+++ tip/kernel/hrtimer.c
@@ -1186,7 +1186,7 @@ static void __hrtimer_init(struct hrtime
 
 	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
 
-	if (clock_id == CLOCK_REALTIME && mode != HRTIMER_MODE_ABS)
+	if (clock_id == CLOCK_REALTIME && (mode & HRTIMER_MODE_REL))
 		clock_id = CLOCK_MONOTONIC;
 
 	base = hrtimer_clockid_to_base(clock_id);
@@ -1620,7 +1620,7 @@ long hrtimer_nanosleep(struct timespec *
 		goto out;
 
 	/* Absolute timers do not update the rmtp value and restart: */
-	if (mode == HRTIMER_MODE_ABS) {
+	if (!(mode & HRTIMER_MODE_REL)) {
 		ret = -ERESTARTNOHAND;
 		goto out;
 	}


