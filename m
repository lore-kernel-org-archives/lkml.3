Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaFLTeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:34:31 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36657 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaFLTeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:34:08 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] timer: Kick dynticks targets on mod_timer*() calls
Date: Thu, 12 Jun 2014 21:34:01 +0200
Message-Id: <1402601641-28462-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402601641-28462-1-git-send-email-fweisbec@gmail.com>
References: <1402601641-28462-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

When a timer is enqueued or modified on a dynticks target, that CPU
must re-evaluate the next tick to service that timer.

The tick re-evaluation is performed by an IPI kick on the target.
Now while we correctly call wake_up_nohz_cpu() from add_timer_on(), the
mod_timer*() API family doesn't support so well dynticks targets.

The reason for this is likely that __mod_timer() isn't supposed to
select an idle target for a timer, unless that target is the current
CPU, in which case a dynticks idle kick isn't actually needed.

But there is a small race window lurking behind that assumption: the
elected target has all the time to turn dynticks idle between the call
to get_nohz_timer_target() and the locking of its base. Hence a risk
that we enqueue a timer on a dynticks idle destination without kicking
it. As a result, the timer might be serviced too late in the future.

Also a target elected by __mod_timer() can be in full dynticks mode
and thus require to be kicked as well. And unlike idle dynticks, this
concern both local and remote targets.

To fix this whole issue, lets centralize the dynticks kick to
internal_add_timer() so that it is well handled for all sort of timer
enqueue. Even timer migration is concerned so that a full dynticks target
is correctly kicked as needed when timers are migrating to it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/timer.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 9e5f4f2..aca5dfe 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -410,6 +410,22 @@ static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
 			base->next_timer = timer->expires;
 	}
 	base->all_timers++;
+
+	/*
+	 * Check whether the other CPU is in dynticks mode and needs
+	 * to be triggered to reevaluate the timer wheel.
+	 * We are protected against the other CPU fiddling
+	 * with the timer by holding the timer base lock. This also
+	 * makes sure that a CPU on the way to stop its tick can not
+	 * evaluate the timer wheel.
+	 *
+	 * Spare the IPI for deferrable timers on idle targets though.
+	 * The next busy ticks will take care of it. Except full dynticks
+	 * require special care against races with idle_cpu(), lets deal
+	 * with that later.
+	 */
+	if (!tbase_get_deferrable(base) || tick_nohz_full_cpu(base->cpu))
+		wake_up_nohz_cpu(base->cpu);
 }
 
 #ifdef CONFIG_TIMER_STATS
@@ -949,22 +965,6 @@ void add_timer_on(struct timer_list *timer, int cpu)
 	timer_set_base(timer, base);
 	debug_activate(timer, timer->expires);
 	internal_add_timer(base, timer);
-	/*
-	 * Check whether the other CPU is in dynticks mode and needs
-	 * to be triggered to reevaluate the timer wheel.
-	 * We are protected against the other CPU fiddling
-	 * with the timer by holding the timer base lock. This also
-	 * makes sure that a CPU on the way to stop its tick can not
-	 * evaluate the timer wheel.
-	 *
-	 * Spare the IPI for deferrable timers on idle targets though.
-	 * The next busy ticks will take care of it. Except full dynticks
-	 * require special care against races with idle_cpu(), lets deal
-	 * with that later.
-	 */
-	if (!tbase_get_deferrable(timer->base) || tick_nohz_full_cpu(cpu))
-		wake_up_nohz_cpu(cpu);
-
 	spin_unlock_irqrestore(&base->lock, flags);
 }
 EXPORT_SYMBOL_GPL(add_timer_on);
-- 
1.8.3.1

