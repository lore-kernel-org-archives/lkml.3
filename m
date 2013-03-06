Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab3CFLVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:21:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:42503 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384Ab3CFLSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:18:36 -0500
Message-Id: <20130306111537.431082074@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 06 Mar 2013 11:18:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Arjan van de Veen <arjan@infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jason Liu <liu.h.jason@gmail.com>
Subject: [patch 3/7] tick: Avoid programming the local cpu timer if broadcast
 pending
References: <20130306111351.883117670@linutronix.de>
Content-Disposition: inline;
 filename=tick-avoid-programming-local-cpu-timer-if-broadcast-pending.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the local cpu timer stops in deep idle, we arm the broadcast device
and get woken by an IPI. Now when we return from deep idle we reenable
the local cpu timer unconditionally before handling the IPI. But
that's a pointless exercise: the timer is already expired and the IPI
is on the way. And it's an expensive exercise as we use the forced
reprogramming mode so that we do not lose a timer event. This forced
reprogramming will loop at least once in the retry.

To avoid this reprogramming, we mark the cpu in a pending bit mask
before we send the IPI. Now when the IPI target cpu wakes up, it will
see the pending bit set and skip the reprogramming. The reprogramming
of the cpu local timer will happen in the IPI handler which runs the
cpu local timer interrupt function.

Reported-by: Jason Liu <liu.h.jason@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

Index: tip/kernel/time/tick-broadcast.c
===================================================================
--- tip.orig/kernel/time/tick-broadcast.c
+++ tip/kernel/time/tick-broadcast.c
@@ -392,6 +392,7 @@ int tick_resume_broadcast(void)
 #ifdef CONFIG_TICK_ONESHOT
 
 static cpumask_var_t tick_broadcast_oneshot_mask;
+static cpumask_var_t tick_broadcast_pending_mask;
 
 /*
  * Exposed for debugging: see timer_list.c
@@ -448,10 +449,17 @@ again:
 	/* Find all expired events */
 	for_each_cpu(cpu, tick_broadcast_oneshot_mask) {
 		td = &per_cpu(tick_cpu_device, cpu);
-		if (td->evtdev->next_event.tv64 <= now.tv64)
+		if (td->evtdev->next_event.tv64 <= now.tv64) {
 			cpumask_set_cpu(cpu, tmpmask);
-		else if (td->evtdev->next_event.tv64 < next_event.tv64)
+			/*
+			 * Mark the remote cpu in the pending mask, so
+			 * it can avoid reprogramming the cpu local
+			 * timer in tick_broadcast_oneshot_control().
+			 */
+			cpumask_set_cpu(cpu, tick_broadcast_pending_mask);
+		} else if (td->evtdev->next_event.tv64 < next_event.tv64) {
 			next_event.tv64 = td->evtdev->next_event.tv64;
+		}
 	}
 
 	/*
@@ -513,6 +521,7 @@ void tick_broadcast_oneshot_control(unsi
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
+		WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
 		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_oneshot_mask)) {
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
 			if (dev->next_event.tv64 < bc->next_event.tv64)
@@ -521,10 +530,25 @@ void tick_broadcast_oneshot_control(unsi
 	} else {
 		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_oneshot_mask)) {
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
-			if (dev->next_event.tv64 != KTIME_MAX)
-				tick_program_event(dev->next_event, 1);
+			if (dev->next_event.tv64 == KTIME_MAX)
+				goto out;
+			/*
+			 * The cpu which was handling the broadcast
+			 * timer marked this cpu in the broadcast
+			 * pending mask and fired the broadcast
+			 * IPI. So we are going to handle the expired
+			 * event anyway via the broadcast IPI
+			 * handler. No need to reprogram the timer
+			 * with an already expired event.
+			 */
+			if (cpumask_test_and_clear_cpu(cpu,
+				       tick_broadcast_pending_mask))
+				goto out;
+
+			tick_program_event(dev->next_event, 1);
 		}
 	}
+out:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
@@ -661,5 +685,6 @@ void tick_broadcast_init(void)
 	alloc_cpumask_var(&tmpmask, GFP_NOWAIT);
 #ifdef CONFIG_TICK_ONESHOT
 	alloc_cpumask_var(&tick_broadcast_oneshot_mask, GFP_NOWAIT);
+	alloc_cpumask_var(&tick_broadcast_pending_mask, GFP_NOWAIT);
 #endif
 }


