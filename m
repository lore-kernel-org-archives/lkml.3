Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaBYPAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 10:00:10 -0500
Received: from forward20.mail.yandex.net ([95.108.253.145]:54405 "EHLO
	forward20.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaBYO6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:58:51 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20140225151515.617714e2f2cd6c558531ba61@gmail.com>
References: <230991392848160@web13m.yandex.ru>
	<20140221103715.GP9987@twins.programming.kicks-ass.net>
	<20140221173641.a060b3d6c0993c21e77f29c2@gmail.com>
	<5307F5DB.3000705@yandex.ru> <20140225151515.617714e2f2cd6c558531ba61@gmail.com>
Subject: Re: [RFC] sched/deadline: Prevent rt_time growth to infinity
MIME-Version: 1.0
Message-Id: <188151393340326@web24g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 25 Feb 2014 18:58:46 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



25.02.2014, 18:14, "Juri Lelli" <juri.lelli@gmail.com>:
> On Sat, 22 Feb 2014 04:56:59 +0400
> Kirill Tkhai <tkhai@yandex.ru> wrote:
>
>> šOn 21.02.2014 20:36, Juri Lelli wrote:
>>> šOn Fri, 21 Feb 2014 11:37:15 +0100
>>> šPeter Zijlstra <peterz@infradead.org> wrote:
>>>> šOn Thu, Feb 20, 2014 at 02:16:00AM +0400, Kirill Tkhai wrote:
>>>>> šSince deadline tasks share rt bandwidth, we must care about
>>>>> šbandwidth timer set. Otherwise rt_time may grow up to infinity
>>>>> šin update_curr_dl(), if there are no other available RT tasks
>>>>> šon top level bandwidth.
>>>>>
>>>>> šI'm going to decide the problem the way below. Almost untested
>>>>> šbecause of I skipped almost all of recent patches which haveto be applied from lkml.
>>>>>
>>>>> šPlease say, if I skipped anything in idea. Maybe better put
>>>>> šstart_top_rt_bandwidth() into set_curr_task_dl()?
>>>> šHow about we only increment rt_time when there's an RT bandwidth timer
>>>> šactive?
>>>>
>>>> š---
>>>> š--- a/kernel/sched/rt.c
>>>> š+++ b/kernel/sched/rt.c
>>>> š@@ -568,6 +568,12 @@ static inline struct rt_bandwidth *sched
>>>>
>>>> šš#endif /* CONFIG_RT_GROUP_SCHED */
>>>>
>>>> š+bool sched_rt_bandwidth_active(struct rt_rq *rt_rq)
>>>> š+{
>>>> š+ struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
>>>> š+ return hrtimer_active(&rt_b->rt_period_timer);
>>>> š+}
>>>> š+
>>>> šš#ifdef CONFIG_SMP
>>>> šš/*
>>>> ššš* We ran out of runtime, see if we can borrow some from our neighbours.
>>>> š--- a/kernel/sched/deadline.c
>>>> š+++ b/kernel/sched/deadline.c
>>>> š@@ -587,6 +587,8 @@ int dl_runtime_exceeded(struct rq *rq, s
>>>> ššššššššššreturn 1;
>>>> šš}
>>>>
>>>> š+extern bool sched_rt_bandwidth_active(struct rt_rq *rt_rq);
>>>> š+
>>>> šš/*
>>>> ššš* Update the current task's runtime statistics (provided it is still
>>>> ššš* a -deadline task and has not been removed from the dl_rq).
>>>> š@@ -650,11 +652,13 @@ static void update_curr_dl(struct rq *rq
>>>> ššššššššššššššššššstruct rt_rq *rt_rq = &rq->rt;
>>>>
>>>> ššššššššššššššššššraw_spin_lock(&rt_rq->rt_runtime_lock);
>>>> š- rt_rq->rt_time += delta_exec;
>>>> šššššššššššššššššš/*
>>>> ššššššššššššššššššš* We'll let actual RT tasks worry about the overflow here, we
>>>> š- * have our own CBS to keep us inline -- see above.
>>>> š+ * have our own CBS to keep us inline; only account when RT
>>>> š+ * bandwidth is relevant.
>>>> ššššššššššššššššššš*/
>>>> š+ if (sched_rt_bandwidth_active(rt_rq))
>>>> š+ rt_rq->rt_time += delta_exec;
>>>> ššššššššššššššššššraw_spin_unlock(&rt_rq->rt_runtime_lock);
>>>> šššššššššš}
>>>> šš}
>>> šSo, I ran some tests with the above and I'd like to share with you what
>>> šI've found. You can find here a trace-cmd trace that should be feeded
>>> što kernelshark to be able to understand what follows (or feel free to
>>> šreproduce same scenario :)):
>>> šhttp://retis.sssup.it/~jlelli/traces/trace_rt_time.dat
>>>
>>> šHere you have a DL task (4/10) and a while(1) RT task, both running
>>> šinside a rt_bw of 0.5. RT tasks is activated 500ms after DL. As I
>>> šfiltered in sched_rt_period_timer(), you can search for time instants
>>> šwhen the rt_bw is replenished. It is evident that the first time after
>>> šrt timer is activated back (search for start_bandwidth_timer), we can
>>> šeat some bw to FAIR tasks (if any). This is due to the fact that we
>>> šreset rt_bw budget at this time, start decrementing rt_time for both DL
>>> šand RT tasks, throttle RT tasks when rt_time > runtime, but, since DL
>>> štasks acually executes inside their own server, they don't care about
>>> šrt_bw. Good news is that steady state is ok: keeping track of overruns
>>> šwe are able to stop eating bw to other guys.
>>>
>>> šMy thougths:
>>>
>>> šš- Peter's patch is an easy fix to Kirill's problem (RT tasks were
>>> ššššthrottled too early);
>>> šš- something to add to this solution could be to pre-calculate bw of
>>> ššššready DL tasks and subtract it to rt_bw at replenishment time, but
>>> ššššit sounds quite awkward, pessimistic, and I'm not sure it is gonna
>>> ššššwork;
>>> šš- we are stealing bw to best-effort tasks, and just at the beginning
>>> ššššof the transistion, is it really a problem?
>>> šš- I mean, if you want guarantees make your tasks DL! :);
>>> šš- in the long run we are gonna have RT tasks scheduled inside CBS
>>> ššššservers, and all this will be properly fixed up.
>>>
>>> šComments?
>>>
>>> šBTW, rt timer activation/deactivation should probably be fixed for
>>> š!RT_GROUP_SCHED with something like this:
>>>
>>> š---
>>> šškernel/sched/rt.c | šš10 +++++++---
>>> šš1 file changed, 7 insertions(+), 3 deletions(-)
>>>
>>> šdiff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
>>> šindex 6161de8..274f992 100644
>>> š--- a/kernel/sched/rt.c
>>> š+++ b/kernel/sched/rt.c
>>> š@@ -86,12 +86,12 @@ void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
>>> ššššššššššraw_spin_lock_init(&rt_rq->rt_runtime_lock);
>>> šš}
>>>
>>> š-#ifdef CONFIG_RT_GROUP_SCHED
>>> ššstatic void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
>>> šš{
>>> ššššššššššhrtimer_cancel(&rt_b->rt_period_timer);
>>> šš}
>>>
>>> š+#ifdef CONFIG_RT_GROUP_SCHED
>>> šš#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
>>>
>>> ššstatic inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
>>> š@@ -1017,8 +1017,12 @@ inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
>>> ššššššššššstart_rt_bandwidth(&def_rt_bandwidth);
>>> šš}
>>>
>>> š-static inline
>>> š-void dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
>>> š+static void
>>> š+dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
>>> š+{
>>> š+ if (!rt_rq->rt_nr_running)
>>> š+ destroy_rt_bandwidth(&def_rt_bandwidth);
>>> š+}
>>>
>>> šš#endif /* CONFIG_RT_GROUP_SCHED */
>> šIt looks with both patches applied, we may get into a situation,
>> šwhen all CPU time is shared between RT and DL tasks:
>>
>> šrt_runtime = n
>> šrt_period š= 2n
>>
>> š| RT working, DL sleeping š| DL working, RT sleeping ššššš|
>> š-----------------------------------------------------------
>> š| (1) ššššduration = n šššš| (2) ššššduration = n šššššššš| (repeat)
>> š|--------------------------|------------------------------|
>> š| (rt_bw timer is running) | (rt_bw timer is not running) |
>>
>> šNo time for fair tasks at all.
>
> Ok, this situation is pathological. DL bandwidth is guaranteed at
> admission control, while RT isn't. In this case RT tasks are doomed by
> construction. Still you'd like to let FAIR tasks execute :).
>
> I argumented on a slightly different solution in what follows, what you
> think?
>
> Thanks,
>
> - Juri
>
> From e44fe2eef34433a7799cfc153f467f7c62813596 Mon Sep 17 00:00:00 2001
> From: Juri Lelli <juri.lelli@gmail.com>
> Date: Fri, 21 Feb 2014 11:37:15 +0100
> Subject: [PATCH] sched/deadline: Prevent rt_time growth to infinity
>
> Kirill Tkhai noted:
> Since deadline tasks share rt bandwidth, we must care about
> bandwidth timer set. Otherwise rt_time may grow up to infinity
> in update_curr_dl(), if there are no other available RT tasks
> on top level bandwidth.
>
> RT task were in fact throttled right after they got enqueued,
> and never executed again (rt_time never again went below rt_runtime).
>
> Peter than proposed to accrue DL execution on rt_time only when
> rt timer is active, and proposed a patch (this patch is a slight
> modification of that) to implement that behavior. While this
> solves Kirill problem, it has a drawback.
>
> Indeed, Kirill noted again:
> It looks we may get into a situation, when all CPU time is shared
> between RT and DL tasks:
>
> rt_runtime = n
> rt_period š= 2n
>
> | RT working, DL sleeping š| DL working, RT sleeping ššššš|
> -----------------------------------------------------------
> | (1) ššššduration = n šššš| (2) ššššduration = n šššššššš| (repeat)
> |--------------------------|------------------------------|
> | (rt_bw timer is running) | (rt_bw timer is not running) |
>
> No time for fair tasks at all.
>
> While this can happen during the first period, if rq is always backlogged,
> RT tasks won't have the opportunity to execute anymore: rt_time reached
> rt_runtime during (1), suppose after (2) RT is enqueued back, it gets
> throttled since rt timer didn't fire, replenishment is from now on eaten up
> by DL tasks that accrue their execution on rt_time (while rt timer is
> active - we have an RT task waiting for replenishment). FAIR tasks are
> not touched after this first period. Ok, this is not ideal, and the situation
> is even worse!
>
> What above (the nice case), practically never happens in reality, where
> your rt timer is not aligned to tasks periods, tasks are in general not
> periodic, etc.. Long story short, you always risk to overload your system.
>
> This patch is based on Peter's idea, but exploits an additional fact:
> if you don't have RT tasks enqueued, it makes little sense to continue
> incrementing rt_time once you reached the upper limit (DL tasks have their
> own mechanism for throttling).
>
> This cures both problems:
>
> š- no matter how many DL instances in the past, you'll have an rt_time
> šššslightly above rt_runtime when an RT task is enqueued, and from that
> šššpoint on (after the first replenishment), the task will normally execute;
>
> š- you can still eat up all bandwidth during the first period, but not
> šššanymore after that, remember that DL execution will increment rt_time
> ššštill the upper limit is reached.
>
> The situation is still not perfect! But, we have a simple solution for now,
> that limits how much you can jeopardize your system, as we keep working
> towards the right answer: RT groups scheduled using deadline servers.

Excellent, Juri! This is almost perfect.

Thanks,
Kirill

> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
> ---
> škernel/sched/deadline.c | ššš8 ++++++--
> škernel/sched/rt.c šššššš| ššš8 ++++++++
> š2 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 15cbc17..f59d774 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -564,6 +564,8 @@ int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
> šššššššššreturn 1;
> š}
>
> +extern bool sched_rt_bandwidth_account(struct rt_rq *rt_rq);
> +
> š/*
> šš* Update the current task's runtime statistics (provided it is still
> šš* a -deadline task and has not been removed from the dl_rq).
> @@ -627,11 +629,13 @@ static void update_curr_dl(struct rq *rq)
> šššššššššššššššššstruct rt_rq *rt_rq = &rq->rt;
>
> šššššššššššššššššraw_spin_lock(&rt_rq->rt_runtime_lock);
> - rt_rq->rt_time += delta_exec;
> ššššššššššššššššš/*
> šššššššššššššššššš* We'll let actual RT tasks worry about the overflow here, we
> - * have our own CBS to keep us inline -- see above.
> + * have our own CBS to keep us inline; only account when RT
> + * bandwidth is relevant.
> šššššššššššššššššš*/
> + if (sched_rt_bandwidth_account(rt_rq))
> + rt_rq->rt_time += delta_exec;
> šššššššššššššššššraw_spin_unlock(&rt_rq->rt_runtime_lock);
> ššššššššš}
> š}
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 7dba25a..7f372e1 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -538,6 +538,14 @@ static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
>
> š#endif /* CONFIG_RT_GROUP_SCHED */
>
> +bool sched_rt_bandwidth_account(struct rt_rq *rt_rq)
> +{
> + struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
> +
> + return (hrtimer_active(&rt_b->rt_period_timer) ||
> + rt_rq->rt_time < rt_b->rt_runtime);
> +}
> +
> š#ifdef CONFIG_SMP
> š/*
> šš* We ran out of runtime, see if we can borrow some from our neighbours.
> --
> 1.7.9.5
