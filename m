Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab3CFLSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:18:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:42509 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402Ab3CFLSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:18:37 -0500
Message-Id: <20130306111537.492045206@linutronix.de>
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
Subject: [patch 4/7] tick: Handle broadcast wakeup of multiple cpus
References: <20130306111351.883117670@linutronix.de>
Content-Disposition: inline; filename=tick-broadcast-handle-mass-wakeup.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some brilliant hardware implementations wake multiple cores when the
broadcast timer fires. This leads to the following interesting
problem:

CPU0				CPU1
wakeup from idle		wakeup from idle

leave broadcast mode		leave broadcast mode
 restart per cpu timer		 restart per cpu timer
 	     	 		go back to idle
handle broadcast
 (empty mask)			
				enter broadcast mode
				programm broadcast device
enter broadcast mode
programm broadcast device

So what happens is that due to the forced reprogramming of the cpu
local timer, we need to set a event in the future. Now if we manage to
go back to idle before the timer fires, we switch off the timer and
arm the broadcast device with an already expired time (covered by
forced mode). So in the worst case we repeat the above ping pong
forever.
					
Unfortunately we have no information about what caused the wakeup, but
we can check current time against the expiry time of the local cpu. If
the local event is already in the past, we know that the broadcast
timer is about to fire and send an IPI. So we mark ourself as an IPI
target even if we left broadcast mode and avoid the reprogramming of
the local cpu timer.

This still leaves the possibility that a CPU which is not handling the
broadcast interrupt is going to reach idle again before the IPI
arrives. This can't be solved in the core code and will be handled in
follow up patches.

Reported-by: Jason Liu <liu.h.jason@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c |   59 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

Index: tip/kernel/time/tick-broadcast.c
===================================================================
--- tip.orig/kernel/time/tick-broadcast.c
+++ tip/kernel/time/tick-broadcast.c
@@ -393,6 +393,7 @@ int tick_resume_broadcast(void)
 
 static cpumask_var_t tick_broadcast_oneshot_mask;
 static cpumask_var_t tick_broadcast_pending_mask;
+static cpumask_var_t tick_broadcast_force_mask;
 
 /*
  * Exposed for debugging: see timer_list.c
@@ -462,6 +463,10 @@ again:
 		}
 	}
 
+	/* Take care of enforced broadcast requests */
+	cpumask_or(tmpmask, tmpmask, tick_broadcast_force_mask);
+	cpumask_clear(tick_broadcast_force_mask);
+
 	/*
 	 * Wakeup the cpus which have an expired event.
 	 */
@@ -497,6 +502,7 @@ void tick_broadcast_oneshot_control(unsi
 	struct clock_event_device *bc, *dev;
 	struct tick_device *td;
 	unsigned long flags;
+	ktime_t now;
 	int cpu;
 
 	/*
@@ -524,7 +530,16 @@ void tick_broadcast_oneshot_control(unsi
 		WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
 		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_oneshot_mask)) {
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
-			if (dev->next_event.tv64 < bc->next_event.tv64)
+			/*
+			 * We only reprogram the broadcast timer if we
+			 * did not mark ourself in the force mask and
+			 * if the cpu local event is earlier than the
+			 * broadcast event. If the current CPU is in
+			 * the force mask, then we are going to be
+			 * woken by the IPI right away.
+			 */
+			if (!cpumask_test_cpu(cpu, tick_broadcast_force_mask) &&
+			    dev->next_event.tv64 < bc->next_event.tv64)
 				tick_broadcast_set_event(dev->next_event, 1);
 		}
 	} else {
@@ -545,6 +560,47 @@ void tick_broadcast_oneshot_control(unsi
 				       tick_broadcast_pending_mask))
 				goto out;
 
+			/*
+			 * If the pending bit is not set, then we are
+			 * either the CPU handling the broadcast
+			 * interrupt or we got woken by something else.
+			 *
+			 * We are not longer in the broadcast mask, so
+			 * if the cpu local expiry time is already
+			 * reached, we would reprogram the cpu local
+			 * timer with an already expired event.
+			 *
+			 * This can lead to a ping-pong when we return
+			 * to idle and therefor rearm the broadcast
+			 * timer before the cpu local timer was able
+			 * to fire. This happens because the forced
+			 * reprogramming makes sure that the event
+			 * will happen in the future and depending on
+			 * the min_delta setting this might be far
+			 * enough out that the ping-pong starts.
+			 *
+			 * If the cpu local next_event has expired
+			 * then we know that the broadcast timer
+			 * next_event has expired as well and
+			 * broadcast is about to be handled. So we
+			 * avoid reprogramming and enforce that the
+			 * broadcast handler, which did not run yet,
+			 * will invoke the cpu local handler.
+			 *
+			 * We cannot call the handler directly from
+			 * here, because we might be in a NOHZ phase
+			 * and we did not go through the irq_enter()
+			 * nohz fixups.
+			 */
+			now = ktime_get();
+			if (dev->next_event.tv64 <= now.tv64) {
+				cpumask_set_cpu(cpu, tick_broadcast_force_mask);
+				goto out;
+			}
+			/*
+			 * We got woken by something else. Reprogram
+			 * the cpu local timer device.
+			 */
 			tick_program_event(dev->next_event, 1);
 		}
 	}
@@ -686,5 +742,6 @@ void tick_broadcast_init(void)
 #ifdef CONFIG_TICK_ONESHOT
 	alloc_cpumask_var(&tick_broadcast_oneshot_mask, GFP_NOWAIT);
 	alloc_cpumask_var(&tick_broadcast_pending_mask, GFP_NOWAIT);
+	alloc_cpumask_var(&tick_broadcast_force_mask, GFP_NOWAIT);
 #endif
 }


