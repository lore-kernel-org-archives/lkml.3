Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaGaQqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:46:16 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38991 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaGaQqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:46:13 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] nohz: Avoid tick's double reprogramming in highres mode
Date: Thu, 31 Jul 2014 18:45:56 +0200
Message-Id: <1406825156-11901-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1406825156-11901-1-git-send-email-fweisbec@gmail.com>
References: <1406825156-11901-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

In highres mode, the tick reschedules itself unconditionally to the
next jiffies.

However while this clock reprogramming is relevant when the tick is
in periodic mode, it's not that interesting when we run in dynticks mode
because irq exit is likely going to overwrite the next tick to some
randomly deferred future.

So lets just get rid of this tick self rescheduling in dynticks mode.
This way we can avoid some clockevents double write in favourable
scenarios like when we stop the tick completely in idle while no other
hrtimer is pending.

Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-sched.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index b07ba8e..a7098f7 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1087,6 +1087,10 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	if (regs)
 		tick_sched_handle(ts, regs);
 
+	/* Do not restart, when we are in idle or full dynticks mode */
+	if (unlikely(ts->tick_stopped))
+		return HRTIMER_NORESTART;
+
 	hrtimer_forward(timer, now, tick_period);
 
 	return HRTIMER_RESTART;
-- 
1.8.3.1

