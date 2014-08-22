Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbaHVRJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:09:51 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:42230 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbaHVRJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:09:44 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
X-Google-Original-From: Frederic Weisbecker <frederic@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] nohz: Avoid tick's double reprogramming in highres mode
Date: Fri, 22 Aug 2014 19:09:33 +0200
Message-Id: <1408727373-8166-3-git-send-email-frederic@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408727373-8166-1-git-send-email-frederic@kernel.org>
References: <1408727373-8166-1-git-send-email-frederic@kernel.org>
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
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-sched.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 153870a..cc0a5b6 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1099,6 +1099,10 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	if (regs)
 		tick_sched_handle(ts, regs);
 
+	/* No need to reprogram if we are in idle or full dynticks mode */
+	if (unlikely(ts->tick_stopped))
+		return HRTIMER_NORESTART;
+
 	hrtimer_forward(timer, now, tick_period);
 
 	return HRTIMER_RESTART;
-- 
2.1.0

