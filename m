Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaGPVQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:16:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:59705 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbaGPVE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:26 -0400
Message-Id: <20140716205054.275233581@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 25/64] input: evdev: Use ktime_mono_to_real()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=input-evdev-use-ktime-mono-to-real.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the monotonic timestamp with ktime_mono_to_real() in
evdev_events().

In evdev_queue_syn_dropped() we can call either ktime_get() or
ktime_get_real() depending on the clkid. No point in having two calls
for CLOCK_REALTIME.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/input/evdev.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: tip/drivers/input/evdev.c
===================================================================
--- tip.orig/drivers/input/evdev.c
+++ tip/drivers/input/evdev.c
@@ -108,9 +108,8 @@ static void evdev_queue_syn_dropped(stru
 	struct input_event ev;
 	ktime_t time;
 
-	time = ktime_get();
-	if (client->clkid != CLOCK_MONOTONIC)
-		time = ktime_sub(time, ktime_get_monotonic_offset());
+	time = (client->clkid == CLOCK_MONOTONIC) ?
+		ktime_get() : ktime_get_real();
 
 	ev.time = ktime_to_timeval(time);
 	ev.type = EV_SYN;
@@ -202,7 +201,7 @@ static void evdev_events(struct input_ha
 	ktime_t time_mono, time_real;
 
 	time_mono = ktime_get();
-	time_real = ktime_sub(time_mono, ktime_get_monotonic_offset());
+	time_real = ktime_mono_to_real(time_mono);
 
 	rcu_read_lock();
 


