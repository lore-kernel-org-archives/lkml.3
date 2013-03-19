Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab3CSLhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:37:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45540 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3CSLhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:37:39 -0400
Date: Tue, 19 Mar 2013 04:35:55 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-26517f3e99248668315aee9460dcea21628cdd7f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        john.stultz@linaro.org, arjan@infradead.org, liu.h.jason@gmail.com,
        tglx@linutronix.de, lorenzo.pieralisi@arm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        john.stultz@linaro.org, arjan@infradead.org, liu.h.jason@gmail.com,
        tglx@linutronix.de, lorenzo.pieralisi@arm.com
In-Reply-To: <20130306111537.431082074@linutronix.de>
References: <20130306111537.431082074@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tick:
  Avoid programming the local cpu timer if broadcast pending
Git-Commit-ID: 26517f3e99248668315aee9460dcea21628cdd7f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 19 Mar 2013 04:36:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26517f3e99248668315aee9460dcea21628cdd7f
Gitweb:     http://git.kernel.org/tip/26517f3e99248668315aee9460dcea21628cdd7f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 6 Mar 2013 11:18:35 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 13 Mar 2013 11:39:39 +0100

tick: Avoid programming the local cpu timer if broadcast pending

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
Cc: LAK <linux-arm-kernel@lists.infradead.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Arjan van de Veen <arjan@infradead.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Link: http://lkml.kernel.org/r/20130306111537.431082074@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 380910d..005c0ca 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -392,6 +392,7 @@ int tick_resume_broadcast(void)
 #ifdef CONFIG_TICK_ONESHOT
 
 static cpumask_var_t tick_broadcast_oneshot_mask;
+static cpumask_var_t tick_broadcast_pending_mask;
 
 /*
  * Exposed for debugging: see timer_list.c
@@ -470,6 +471,12 @@ again:
 		td = &per_cpu(tick_cpu_device, cpu);
 		if (td->evtdev->next_event.tv64 <= now.tv64) {
 			cpumask_set_cpu(cpu, tmpmask);
+			/*
+			 * Mark the remote cpu in the pending mask, so
+			 * it can avoid reprogramming the cpu local
+			 * timer in tick_broadcast_oneshot_control().
+			 */
+			cpumask_set_cpu(cpu, tick_broadcast_pending_mask);
 		} else if (td->evtdev->next_event.tv64 < next_event.tv64) {
 			next_event.tv64 = td->evtdev->next_event.tv64;
 			next_cpu = cpu;
@@ -535,6 +542,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
+		WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
 		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_oneshot_mask)) {
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
 			if (dev->next_event.tv64 < bc->next_event.tv64)
@@ -543,10 +551,25 @@ void tick_broadcast_oneshot_control(unsigned long reason)
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
 
@@ -683,5 +706,6 @@ void __init tick_broadcast_init(void)
 	alloc_cpumask_var(&tmpmask, GFP_NOWAIT);
 #ifdef CONFIG_TICK_ONESHOT
 	alloc_cpumask_var(&tick_broadcast_oneshot_mask, GFP_NOWAIT);
+	alloc_cpumask_var(&tick_broadcast_pending_mask, GFP_NOWAIT);
 #endif
 }
