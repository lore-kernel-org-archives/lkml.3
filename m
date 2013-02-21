Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067Ab3BUWwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:52:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:53428 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab3BUWvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:51:40 -0500
Message-Id: <20130221224231.033750368@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Feb 2013 22:51:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC patch 5/8] timekeeping: Store cycle_last value in timekeeper
 struct as well
References: <20130221220147.719832397@linutronix.de>
Content-Disposition: inline;
 filename=timekeeping-store-cycle-last-in-timekeeper.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For implementing a shadow timekeeper and a split calculation/update
region we need to store the cycle_last value in the timekeeper and
update the value in the clocksource struct only in the update region.

Add the extra storage to the timekeeper.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeper_internal.h |    2 ++
 kernel/time/timekeeping.c           |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/timekeeper_internal.h
===================================================================
--- linux-2.6.orig/include/linux/timekeeper_internal.h
+++ linux-2.6/include/linux/timekeeper_internal.h
@@ -20,6 +20,8 @@ struct timekeeper {
 	u32			shift;
 	/* Number of clock cycles in one NTP interval. */
 	cycle_t			cycle_interval;
+	/* Last cycle value (also stored in clock->cycle_last) */
+	cycle_t			cycle_last;
 	/* Number of clock shifted nano seconds in one NTP interval. */
 	u64			xtime_interval;
 	/* shifted nano seconds left over when rounding cycle_interval */
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -99,7 +99,7 @@ static void tk_setup_internals(struct ti
 
 	old_clock = tk->clock;
 	tk->clock = clock;
-	clock->cycle_last = clock->read(clock);
+	tk->cycle_last = clock->cycle_last = clock->read(clock);
 
 	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = NTP_INTERVAL_LENGTH;
@@ -250,7 +250,7 @@ static void timekeeping_forward_now(stru
 	clock = tk->clock;
 	cycle_now = clock->read(clock);
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-	clock->cycle_last = cycle_now;
+	tk->cycle_last = clock->cycle_last = cycle_now;
 
 	tk->xtime_nsec += cycle_delta * tk->mult;
 


