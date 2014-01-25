Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaAYOXi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:23:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52403 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaAYOXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:23:33 -0500
Date: Sat, 25 Jan 2014 06:22:36 -0800
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-855a0fc30b70d6ae681badd24d6625f9a9abb787@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, john.stultz@linaro.org, alex.shi@linaro.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        khilman@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, john.stultz@linaro.org, alex.shi@linaro.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, khilman@linaro.org
In-Reply-To: <1387320692-28460-9-git-send-email-fweisbec@gmail.com>
References: <1387320692-28460-9-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] nohz:
  Get timekeeping max deferment outside jiffies_lock
Git-Commit-ID: 855a0fc30b70d6ae681badd24d6625f9a9abb787
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:22:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  855a0fc30b70d6ae681badd24d6625f9a9abb787
Gitweb:     http://git.kernel.org/tip/855a0fc30b70d6ae681badd24d6625f9a9abb787
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 17 Dec 2013 00:16:37 +0100
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 15 Jan 2014 23:07:11 +0100

nohz: Get timekeeping max deferment outside jiffies_lock

We don't need to fetch the timekeeping max deferment under the
jiffies_lock seqlock.

If the clocksource is updated concurrently while we stop the tick,
stop machine is called and the tick will be reevaluated again along with
uptodate jiffies and its related values.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>
Link: http://lkml.kernel.org/r/1387320692-28460-9-git-send-email-fweisbec@gmail.com
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-sched.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e4d0f09..68331d1 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -533,12 +533,13 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
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
