Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab3LQWvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:51:50 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60819 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3LQWvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:51:47 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 08/13] nohz: Get timekeeping max deferment outside jiffies_lock
Date: Tue, 17 Dec 2013 23:51:27 +0100
Message-Id: <1387320692-28460-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to fetch the timekeeping max deferment under the
jiffies_lock seqlock.

If the clocksource is updated concurrently while we stop the tick,
stop machine is called and the tick will be reevaluated again along with
uptodate jiffies and its related values.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>
---
 kernel/time/tick-sched.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 9a91c31..0d2d774 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -532,12 +532,13 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	u64 time_delta;
 
+	time_delta = timekeeping_max_deferment();
+
 	/* Read jiffies and the time when jiffies were updated last */
 	do {
 		seq = read_seqbegin(&jiffies_lock);
 		last_update = last_jiffies_update;
 		last_jiffies = jiffies;
-		time_delta = timekeeping_max_deferment();
 	} while (read_seqretry(&jiffies_lock, seq));
 
 	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
-- 
1.8.3.1

