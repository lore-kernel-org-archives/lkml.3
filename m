Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaGPVE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:04:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:59691 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaGPVEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:22 -0400
Message-Id: <20140716205054.022564048@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 22/64] timekeeping;
 Use ktime based data for ktime_get_update_offsets_tick()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=timekeeping-use-ktime-for-hrtimer-if-2.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to juggle with timespecs.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -1636,22 +1636,22 @@ ktime_t ktime_get_update_offsets_tick(kt
 							ktime_t *offs_tai)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
-	struct timespec64 ts;
-	ktime_t now;
 	unsigned int seq;
+	ktime_t base;
+	u64 nsecs;
 
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
 
-		ts = tk_xtime(tk);
+		base = tk->base_mono;
+		nsecs = tk->xtime_nsec >> tk->shift;
+
 		*offs_real = tk->offs_real;
 		*offs_boot = tk->offs_boot;
 		*offs_tai = tk->offs_tai;
 	} while (read_seqcount_retry(&tk_core.seq, seq));
 
-	now = ktime_set(ts.tv_sec, ts.tv_nsec);
-	now = ktime_sub(now, *offs_real);
-	return now;
+	return ktime_add_ns(base, nsecs);
 }
 
 #ifdef CONFIG_HIGH_RES_TIMERS


