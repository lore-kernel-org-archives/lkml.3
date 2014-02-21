Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbaBUKhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 05:37:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33518 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbaBUKhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 05:37:21 -0500
Date: Fri, 21 Feb 2014 11:37:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC] sched/deadline: Prevent rt_time growth to infinity
Message-ID: <20140221103715.GP9987@twins.programming.kicks-ass.net>
References: <230991392848160@web13m.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <230991392848160@web13m.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 02:16:00AM +0400, Kirill Tkhai wrote:
> Since deadline tasks share rt bandwidth, we must care about
> bandwidth timer set. Otherwise rt_time may grow up to infinity
> in update_curr_dl(), if there are no other available RT tasks
> on top level bandwidth.
> 
> I'm going to decide the problem the way below. Almost untested
> because of I skipped almost all of recent patches which haveto be applied from lkml.
> 
> Please say, if I skipped anything in idea. Maybe better put
> start_top_rt_bandwidth() into set_curr_task_dl()?

How about we only increment rt_time when there's an RT bandwidth timer
active?


---
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -568,6 +568,12 @@ static inline struct rt_bandwidth *sched
 
 #endif /* CONFIG_RT_GROUP_SCHED */
 
+bool sched_rt_bandwidth_active(struct rt_rq *rt_rq)
+{
+	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+	return hrtimer_active(&rt_b->rt_period_timer);
+}
+
 #ifdef CONFIG_SMP
 /*
  * We ran out of runtime, see if we can borrow some from our neighbours.
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -587,6 +587,8 @@ int dl_runtime_exceeded(struct rq *rq, s
 	return 1;
 }
 
+extern bool sched_rt_bandwidth_active(struct rt_rq *rt_rq);
+
 /*
  * Update the current task's runtime statistics (provided it is still
  * a -deadline task and has not been removed from the dl_rq).
@@ -650,11 +652,13 @@ static void update_curr_dl(struct rq *rq
 		struct rt_rq *rt_rq = &rq->rt;
 
 		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		rt_rq->rt_time += delta_exec;
 		/*
 		 * We'll let actual RT tasks worry about the overflow here, we
-		 * have our own CBS to keep us inline -- see above.
+		 * have our own CBS to keep us inline; only account when RT
+		 * bandwidth is relevant.
 		 */
+		if (sched_rt_bandwidth_active(rt_rq))
+			rt_rq->rt_time += delta_exec;
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 	}
 }
