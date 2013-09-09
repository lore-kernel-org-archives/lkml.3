Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab3IIKJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:09:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46846 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab3IIKJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:09:02 -0400
Date: Mon, 9 Sep 2013 12:08:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Gerlando Falauto <gerlando.falauto@keymile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Brunck, Holger" <Holger.Brunck@keymile.com>,
        "Longchamp, Valentin" <Valentin.Longchamp@keymile.com>,
        "Bigler, Stefan" <Stefan.Bigler@keymile.com>
Subject: Re: kernel deadlock
Message-ID: <20130909100853.GJ31370@twins.programming.kicks-ass.net>
References: <521F6D06.1040107@keymile.com>
 <E92455D61233364C88CCD4A6DAB2E2850E09518110@SRVDEHAN1MX1.keymile.net>
 <521FDD12.7050000@linaro.org>
 <52212511.9050206@keymile.com>
 <5221264F.4070402@linaro.org>
 <5225F8EF.3040701@keymile.com>
 <52261BBB.60904@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52261BBB.60904@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 10:26:19AM -0700, John Stultz wrote:
> Enabling the SCHED_FEAT(HRTICK, true) bit tends to cause lots of issues
> on the various hardware I have, tripping the lockdep warnings on various
> other issues:

Does whatever kernel you guys are running have this commit:

---
commit 971ee28cbd1ccd87b3164facd9359a534c1d2892
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Jun 28 11:18:53 2013 +0200

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
