Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaBZUIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:08:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45019 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbaBZUIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:08:18 -0500
Date: Wed, 26 Feb 2014 12:07:23 -0800
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-8ba14654282ed6bb386d0a2f1ab329bfb293403f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, paul.gortmaker@windriver.com
In-Reply-To: <CAKohpomMZ0TAN2e6N76_g4ZRzxd5vZ1XfuZfxrP7GMxfTNiLVw@mail.gmail.com>
References: <CAKohpomMZ0TAN2e6N76_g4ZRzxd5vZ1XfuZfxrP7GMxfTNiLVw@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timer:
  Spare IPI when deferrable timer is queued on idle remote targets
Git-Commit-ID: 8ba14654282ed6bb386d0a2f1ab329bfb293403f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ba14654282ed6bb386d0a2f1ab329bfb293403f
Gitweb:     http://git.kernel.org/tip/8ba14654282ed6bb386d0a2f1ab329bfb293403f
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Mon, 10 Feb 2014 17:09:54 +0100
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Fri, 14 Feb 2014 17:59:14 +0100

timer: Spare IPI when deferrable timer is queued on idle remote targets

When a timer is enqueued or modified on a remote target, the latter is
expected to see and handle this timer on its next tick. However if the
target is idle and CONFIG_NO_HZ_IDLE=y, the CPU may be sleeping tickless
and the timer may be ignored.

wake_up_nohz_cpu() takes care of that by setting TIF_NEED_RESCHED and
sending an IPI to idle targets so that the tick is reevaluated on the
idle loop through the tick_nohz_idle_*() APIs.

Now this is all performed regardless of the power properties of the
timer. If the timer is deferrable, idle targets don't need to be woken
up. Only the next buzy tick needs to care about it, and no IPI kick
is needed for that to happen.

So lets spare the IPI on idle targets when the timer is deferrable.

Meanwhile we keep the current behaviour on full dynticks targets. We can
spare IPIs on idle full dynticks targets as well but some tricky races
against idle_cpu() must be dealt all along to make sure that the timer
is well handled after idle exit. We can deal with that later since
NO_HZ_FULL already has more important powersaving issues.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/CAKohpomMZ0TAN2e6N76_g4ZRzxd5vZ1XfuZfxrP7GMxfTNiLVw@mail.gmail.com
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/timer.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index accfd24..b75e789 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -939,8 +939,15 @@ void add_timer_on(struct timer_list *timer, int cpu)
 	 * with the timer by holding the timer base lock. This also
 	 * makes sure that a CPU on the way to stop its tick can not
 	 * evaluate the timer wheel.
+	 *
+	 * Spare the IPI for deferrable timers on idle targets though.
+	 * The next busy ticks will take care of it. Except full dynticks
+	 * require special care against races with idle_cpu(), lets deal
+	 * with that later.
 	 */
-	wake_up_nohz_cpu(cpu);
+	if (!tbase_get_deferrable(timer->base) || tick_nohz_full_cpu(cpu))
+		wake_up_nohz_cpu(cpu);
+
 	spin_unlock_irqrestore(&base->lock, flags);
 }
 EXPORT_SYMBOL_GPL(add_timer_on);
