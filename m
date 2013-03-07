Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557Ab3CGQdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 11:33:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56903 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3CGQdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 11:33:16 -0500
Date: Thu, 7 Mar 2013 08:31:55 -0800
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-f9ae39d04ccdec8d8ecf532191b7056c279a22c0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <1362219013-18173-2-git-send-email-daniel.lezcano@linaro.org>
References: <1362219013-18173-2-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tick:
  Pass broadcast device to tick_broadcast_set_event()
Git-Commit-ID: f9ae39d04ccdec8d8ecf532191b7056c279a22c0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 07 Mar 2013 08:32:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9ae39d04ccdec8d8ecf532191b7056c279a22c0
Gitweb:     http://git.kernel.org/tip/f9ae39d04ccdec8d8ecf532191b7056c279a22c0
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Sat, 2 Mar 2013 11:10:10 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 7 Mar 2013 16:13:26 +0100

tick: Pass broadcast device to tick_broadcast_set_event()

Pass the broadcast timer to tick_broadcast_set_event() instead of
reevaluating tick_broadcast_device.evtdev.

[ tglx: Massaged changelog ]

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: viresh.kumar@linaro.org
Cc: jacob.jun.pan@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: santosh.shilimkar@ti.com
Cc: linaro-kernel@lists.linaro.org
Cc: patches@linaro.org
Cc: rickard.andersson@stericsson.com
Cc: vincent.guittot@linaro.org
Cc: linus.walleij@stericsson.com
Cc: john.stultz@linaro.org
Link: http://lkml.kernel.org/r/1362219013-18173-2-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 35b8875..70dd98c 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -401,10 +401,9 @@ struct cpumask *tick_get_broadcast_oneshot_mask(void)
 	return tick_broadcast_oneshot_mask;
 }
 
-static int tick_broadcast_set_event(ktime_t expires, int force)
+static int tick_broadcast_set_event(struct clock_event_device *bc,
+				    ktime_t expires, int force)
 {
-	struct clock_event_device *bc = tick_broadcast_device.evtdev;
-
 	if (bc->mode != CLOCK_EVT_MODE_ONESHOT)
 		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 
@@ -474,7 +473,7 @@ again:
 		 * Rearm the broadcast device. If event expired,
 		 * repeat the above
 		 */
-		if (tick_broadcast_set_event(next_event, 0))
+		if (tick_broadcast_set_event(dev, next_event, 0))
 			goto again;
 	}
 	raw_spin_unlock(&tick_broadcast_lock);
@@ -516,7 +515,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_oneshot_mask)) {
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
 			if (dev->next_event.tv64 < bc->next_event.tv64)
-				tick_broadcast_set_event(dev->next_event, 1);
+				tick_broadcast_set_event(bc, dev->next_event, 1);
 		}
 	} else {
 		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_oneshot_mask)) {
@@ -582,7 +581,7 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 			clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 			tick_broadcast_init_next_event(tmpmask,
 						       tick_next_period);
-			tick_broadcast_set_event(tick_next_period, 1);
+			tick_broadcast_set_event(bc, tick_next_period, 1);
 		} else
 			bc->next_event.tv64 = KTIME_MAX;
 	} else {
