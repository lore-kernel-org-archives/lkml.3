Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964895Ab3GLNaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:30:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59577 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964859Ab3GLNaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:30:14 -0400
Date: Fri, 12 Jul 2013 06:29:39 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-971ee28cbd1ccd87b3164facd9359a534c1d2892@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <20130628091853.GE29209@dyad.programming.kicks-ass.net>
References: <20130628091853.GE29209@dyad.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix HRTICK
Git-Commit-ID: 971ee28cbd1ccd87b3164facd9359a534c1d2892
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 06:29:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  971ee28cbd1ccd87b3164facd9359a534c1d2892
Gitweb:     http://git.kernel.org/tip/971ee28cbd1ccd87b3164facd9359a534c1d2892
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 28 Jun 2013 11:18:53 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Jul 2013 13:52:58 +0200

sched: Fix HRTICK

David reported that the HRTICK sched feature was borken; which was enough
motivation for me to finally fix it ;-)

We should not allow hrtimer code to do softirq wakeups while holding scheduler
locks. The hrtimer code only needs this when we accidentally try to program an
expired time. We don't much care about those anyway since we have the regular
tick to fall back to.

Reported-by: David Ahern <dsahern@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130628091853.GE29209@dyad.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9b1f2e5..0d8eb45 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -370,13 +370,6 @@ static struct rq *this_rq_lock(void)
 #ifdef CONFIG_SCHED_HRTICK
 /*
  * Use HR-timers to deliver accurate preemption points.
- *
- * Its all a bit involved since we cannot program an hrt while holding the
- * rq->lock. So what we do is store a state in in rq->hrtick_* and ask for a
- * reschedule event.
- *
- * When we get rescheduled we reprogram the hrtick_timer outside of the
- * rq->lock.
  */
 
 static void hrtick_clear(struct rq *rq)
@@ -404,6 +397,15 @@ static enum hrtimer_restart hrtick(struct hrtimer *timer)
 }
 
 #ifdef CONFIG_SMP
+
+static int __hrtick_restart(struct rq *rq)
+{
+	struct hrtimer *timer = &rq->hrtick_timer;
+	ktime_t time = hrtimer_get_softexpires(timer);
+
+	return __hrtimer_start_range_ns(timer, time, 0, HRTIMER_MODE_ABS_PINNED, 0);
+}
+
 /*
  * called from hardirq (IPI) context
  */
@@ -412,7 +414,7 @@ static void __hrtick_start(void *arg)
 	struct rq *rq = arg;
 
 	raw_spin_lock(&rq->lock);
-	hrtimer_restart(&rq->hrtick_timer);
+	__hrtick_restart(rq);
 	rq->hrtick_csd_pending = 0;
 	raw_spin_unlock(&rq->lock);
 }
@@ -430,7 +432,7 @@ void hrtick_start(struct rq *rq, u64 delay)
 	hrtimer_set_expires(timer, time);
 
 	if (rq == this_rq()) {
-		hrtimer_restart(timer);
+		__hrtick_restart(rq);
 	} else if (!rq->hrtick_csd_pending) {
 		__smp_call_function_single(cpu_of(rq), &rq->hrtick_csd, 0);
 		rq->hrtick_csd_pending = 1;
