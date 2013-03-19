Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab3CSLi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:38:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45558 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3CSLi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:38:27 -0400
Date: Tue, 19 Mar 2013 04:37:06 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-989dcb645ca715129c5a2b39102c8334a20d9615@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        john.stultz@linaro.org, arjan@infradead.org, liu.h.jason@gmail.com,
        tglx@linutronix.de, lorenzo.pieralisi@arm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        john.stultz@linaro.org, arjan@infradead.org, liu.h.jason@gmail.com,
        tglx@linutronix.de, lorenzo.pieralisi@arm.com
In-Reply-To: <20130306111537.492045206@linutronix.de>
References: <20130306111537.492045206@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tick: Handle broadcast wakeup of multiple cpus
Git-Commit-ID: 989dcb645ca715129c5a2b39102c8334a20d9615
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 19 Mar 2013 04:37:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  989dcb645ca715129c5a2b39102c8334a20d9615
Gitweb:     http://git.kernel.org/tip/989dcb645ca715129c5a2b39102c8334a20d9615
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 6 Mar 2013 11:18:35 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 13 Mar 2013 11:39:39 +0100

tick: Handle broadcast wakeup of multiple cpus

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
Cc: LAK <linux-arm-kernel@lists.infradead.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Arjan van de Veen <arjan@infradead.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Link: http://lkml.kernel.org/r/20130306111537.492045206@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c | 59 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 005c0ca..2100aad 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -393,6 +393,7 @@ int tick_resume_broadcast(void)
 
 static cpumask_var_t tick_broadcast_oneshot_mask;
 static cpumask_var_t tick_broadcast_pending_mask;
+static cpumask_var_t tick_broadcast_force_mask;
 
 /*
  * Exposed for debugging: see timer_list.c
@@ -483,6 +484,10 @@ again:
 		}
 	}
 
+	/* Take care of enforced broadcast requests */
+	cpumask_or(tmpmask, tmpmask, tick_broadcast_force_mask);
+	cpumask_clear(tick_broadcast_force_mask);
+
 	/*
 	 * Wakeup the cpus which have an expired event.
 	 */
@@ -518,6 +523,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 	struct clock_event_device *bc, *dev;
 	struct tick_device *td;
 	unsigned long flags;
+	ktime_t now;
 	int cpu;
 
 	/*
@@ -545,7 +551,16 @@ void tick_broadcast_oneshot_control(unsigned long reason)
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
 				tick_broadcast_set_event(bc, cpu, dev->next_event, 1);
 		}
 	} else {
@@ -566,6 +581,47 @@ void tick_broadcast_oneshot_control(unsigned long reason)
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
@@ -707,5 +763,6 @@ void __init tick_broadcast_init(void)
 #ifdef CONFIG_TICK_ONESHOT
 	alloc_cpumask_var(&tick_broadcast_oneshot_mask, GFP_NOWAIT);
 	alloc_cpumask_var(&tick_broadcast_pending_mask, GFP_NOWAIT);
+	alloc_cpumask_var(&tick_broadcast_force_mask, GFP_NOWAIT);
 #endif
 }
