Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbaBUQg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:36:29 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:65267 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218AbaBUQg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:36:27 -0500
Date: Fri, 21 Feb 2014 17:36:41 +0100
From: Juri Lelli <juri.lelli@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC] sched/deadline: Prevent rt_time growth to infinity
Message-Id: <20140221173641.a060b3d6c0993c21e77f29c2@gmail.com>
In-Reply-To: <20140221103715.GP9987@twins.programming.kicks-ass.net>
References: <230991392848160@web13m.yandex.ru>
	<20140221103715.GP9987@twins.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014 11:37:15 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Feb 20, 2014 at 02:16:00AM +0400, Kirill Tkhai wrote:
> > Since deadline tasks share rt bandwidth, we must care about
> > bandwidth timer set. Otherwise rt_time may grow up to infinity
> > in update_curr_dl(), if there are no other available RT tasks
> > on top level bandwidth.
> > 
> > I'm going to decide the problem the way below. Almost untested
> > because of I skipped almost all of recent patches which haveto be applied from lkml.
> > 
> > Please say, if I skipped anything in idea. Maybe better put
> > start_top_rt_bandwidth() into set_curr_task_dl()?
> 
> How about we only increment rt_time when there's an RT bandwidth timer
> active?
> 
> 
> ---
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -568,6 +568,12 @@ static inline struct rt_bandwidth *sched
>  
>  #endif /* CONFIG_RT_GROUP_SCHED */
>  
> +bool sched_rt_bandwidth_active(struct rt_rq *rt_rq)
> +{
> +	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
> +	return hrtimer_active(&rt_b->rt_period_timer);
> +}
> +
>  #ifdef CONFIG_SMP
>  /*
>   * We ran out of runtime, see if we can borrow some from our neighbours.
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -587,6 +587,8 @@ int dl_runtime_exceeded(struct rq *rq, s
>  	return 1;
>  }
>  
> +extern bool sched_rt_bandwidth_active(struct rt_rq *rt_rq);
> +
>  /*
>   * Update the current task's runtime statistics (provided it is still
>   * a -deadline task and has not been removed from the dl_rq).
> @@ -650,11 +652,13 @@ static void update_curr_dl(struct rq *rq
>  		struct rt_rq *rt_rq = &rq->rt;
>  
>  		raw_spin_lock(&rt_rq->rt_runtime_lock);
> -		rt_rq->rt_time += delta_exec;
>  		/*
>  		 * We'll let actual RT tasks worry about the overflow here, we
> -		 * have our own CBS to keep us inline -- see above.
> +		 * have our own CBS to keep us inline; only account when RT
> +		 * bandwidth is relevant.
>  		 */
> +		if (sched_rt_bandwidth_active(rt_rq))
> +			rt_rq->rt_time += delta_exec;
>  		raw_spin_unlock(&rt_rq->rt_runtime_lock);
>  	}
>  }

So, I ran some tests with the above and I'd like to share with you what
I've found. You can find here a trace-cmd trace that should be feeded
to kernelshark to be able to understand what follows (or feel free to
reproduce same scenario :)):
http://retis.sssup.it/~jlelli/traces/trace_rt_time.dat

Here you have a DL task (4/10) and a while(1) RT task, both running
inside a rt_bw of 0.5. RT tasks is activated 500ms after DL. As I
filtered in sched_rt_period_timer(), you can search for time instants
when the rt_bw is replenished. It is evident that the first time after
rt timer is activated back (search for start_bandwidth_timer), we can
eat some bw to FAIR tasks (if any). This is due to the fact that we
reset rt_bw budget at this time, start decrementing rt_time for both DL
and RT tasks, throttle RT tasks when rt_time > runtime, but, since DL
tasks acually executes inside their own server, they don't care about
rt_bw. Good news is that steady state is ok: keeping track of overruns
we are able to stop eating bw to other guys.

My thougths:

 - Peter's patch is an easy fix to Kirill's problem (RT tasks were
   throttled too early);
 - something to add to this solution could be to pre-calculate bw of
   ready DL tasks and subtract it to rt_bw at replenishment time, but
   it sounds quite awkward, pessimistic, and I'm not sure it is gonna
   work;
 - we are stealing bw to best-effort tasks, and just at the beginning
   of the transistion, is it really a problem?
 - I mean, if you want guarantees make your tasks DL! :);
 - in the long run we are gonna have RT tasks scheduled inside CBS
   servers, and all this will be properly fixed up.

Comments?

BTW, rt timer activation/deactivation should probably be fixed for
!RT_GROUP_SCHED with something like this:

---
 kernel/sched/rt.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 6161de8..274f992 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -86,12 +86,12 @@ void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 	raw_spin_lock_init(&rt_rq->rt_runtime_lock);
 }
 
-#ifdef CONFIG_RT_GROUP_SCHED
 static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
 {
 	hrtimer_cancel(&rt_b->rt_period_timer);
 }
 
+#ifdef CONFIG_RT_GROUP_SCHED
 #define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
 
 static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
@@ -1017,8 +1017,12 @@ inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	start_rt_bandwidth(&def_rt_bandwidth);
 }
 
-static inline
-void dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
+static void
+dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+{
+	if (!rt_rq->rt_nr_running)
+		destroy_rt_bandwidth(&def_rt_bandwidth);
+}
 
 #endif /* CONFIG_RT_GROUP_SCHED */
 
-- 
1.7.9.5

