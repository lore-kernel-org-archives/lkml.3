Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaBUXui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:50:38 -0500
Received: from forward11.mail.yandex.net ([95.108.130.93]:41500 "EHLO
	forward11.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaBUXug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:50:36 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20140221175305.1e170b45be08fe05c93a33b4@gmail.com>
References: <230991392848160@web13m.yandex.ru>
	<20140221103715.GP9987@twins.programming.kicks-ass.net>
	<20140221173641.a060b3d6c0993c21e77f29c2@gmail.com> <20140221175305.1e170b45be08fe05c93a33b4@gmail.com>
Subject: Re: [RFC] sched/deadline: Prevent rt_time growth to infinity
MIME-Version: 1.0
Message-Id: <57671393026602@web10j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 22 Feb 2014 03:50:02 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



21.02.2014, 20:52, "Juri Lelli" <juri.lelli@gmail.com>:
> On Fri, 21 Feb 2014 17:36:41 +0100
> Juri Lelli <juri.lelli@gmail.com> wrote:
>
>> šOn Fri, 21 Feb 2014 11:37:15 +0100
>> šPeter Zijlstra <peterz@infradead.org> wrote:
>>> šOn Thu, Feb 20, 2014 at 02:16:00AM +0400, Kirill Tkhai wrote:
>>>> šSince deadline tasks share rt bandwidth, we must care about
>>>> šbandwidth timer set. Otherwise rt_time may grow up to infinity
>>>> šin update_curr_dl(), if there are no other available RT tasks
>>>> šon top level bandwidth.
>>>>
>>>> šI'm going to decide the problem the way below. Almost untested
>>>> šbecause of I skipped almost all of recent patches which haveto be applied from lkml.
>>>>
>>>> šPlease say, if I skipped anything in idea. Maybe better put
>>>> šstart_top_rt_bandwidth() into set_curr_task_dl()?
>>> šHow about we only increment rt_time when there's an RT bandwidth timer
>>> šactive?
>>>
>>> š---
>>> š--- a/kernel/sched/rt.c
>>> š+++ b/kernel/sched/rt.c
>>> š@@ -568,6 +568,12 @@ static inline struct rt_bandwidth *sched
>>>
>>> šš#endif /* CONFIG_RT_GROUP_SCHED */
>>>
>>> š+bool sched_rt_bandwidth_active(struct rt_rq *rt_rq)
>>> š+{
>>> š+ struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
>>> š+ return hrtimer_active(&rt_b->rt_period_timer);
>>> š+}
>>> š+
>>> šš#ifdef CONFIG_SMP
>>> šš/*
>>> ššš* We ran out of runtime, see if we can borrow some from our neighbours.
>>> š--- a/kernel/sched/deadline.c
>>> š+++ b/kernel/sched/deadline.c
>>> š@@ -587,6 +587,8 @@ int dl_runtime_exceeded(struct rq *rq, s
>>> ššššššššššreturn 1;
>>> šš}
>>>
>>> š+extern bool sched_rt_bandwidth_active(struct rt_rq *rt_rq);
>>> š+
>>> šš/*
>>> ššš* Update the current task's runtime statistics (provided it is still
>>> ššš* a -deadline task and has not been removed from the dl_rq).
>>> š@@ -650,11 +652,13 @@ static void update_curr_dl(struct rq *rq
>>> ššššššššššššššššššstruct rt_rq *rt_rq = &rq->rt;
>>>
>>> ššššššššššššššššššraw_spin_lock(&rt_rq->rt_runtime_lock);
>>> š- rt_rq->rt_time += delta_exec;
>>> šššššššššššššššššš/*
>>> ššššššššššššššššššš* We'll let actual RT tasks worry about the overflow here, we
>>> š- * have our own CBS to keep us inline -- see above.
>>> š+ * have our own CBS to keep us inline; only account when RT
>>> š+ * bandwidth is relevant.
>>> ššššššššššššššššššš*/
>>> š+ if (sched_rt_bandwidth_active(rt_rq))
>>> š+ rt_rq->rt_time += delta_exec;
>>> ššššššššššššššššššraw_spin_unlock(&rt_rq->rt_runtime_lock);
>>> šššššššššš}
>>> šš}
>> šSo, I ran some tests with the above and I'd like to share with you what
>> šI've found. You can find here a trace-cmd trace that should be feeded
>> što kernelshark to be able to understand what follows (or feel free to
>> šreproduce same scenario :)):
>> šhttp://retis.sssup.it/~jlelli/traces/trace_rt_time.dat
>>
>> šHere you have a DL task (4/10) and a while(1) RT task, both running
>> šinside a rt_bw of 0.5. RT tasks is activated 500ms after DL. As I
>> šfiltered in sched_rt_period_timer(), you can search for time instants
>> šwhen the rt_bw is replenished. It is evident that the first time after
>> šrt timer is activated back (search for start_bandwidth_timer), we can
>> šeat some bw to FAIR tasks (if any). This is due to the fact that we
>> šreset rt_bw budget at this time, start decrementing rt_time for both DL
>
> The reset happens when rt_bw replenishment timer fires, after a bit:
>
> šsched_rt_period_timer <-- __run_hrtimer

Juri, sorry, I forgot to wrote I mean the situation when only one task is on_rq
at every moment.

DL, RT, DL, RT, ...

rt_runtime = n;
rt_period  = 2n;

| DL's working, RT's sleeping  | RT's working, DL's sleeping  |   all sleep               |
------------------------------------------------------------------------------------------|
| (1)     duration = n         | (2)     duration = n         | (3)     duration = n      |  (repeat)
|------------------------------|------------------------------|---------------------------|
| (rt_bw timer is not running) |                   (rt_bw timer is running)               |


According to the patch, rt_bw timer is working only if we have queued RT task.

In the case above part (1) has no queued RT tasks, so timer is not working.
rt_time is not being increased too.

We have ratio 2/3.

Thanks,
Kirill

>
> Apologies,
>
> - Juri
>
>> šand RT tasks, throttle RT tasks when rt_time > runtime, but, since DL
>> štasks acually executes inside their own server, they don't care about
>> šrt_bw. Good news is that steady state is ok: keeping track of overruns
>> šwe are able to stop eating bw to other guys.
>>
>> šMy thougths:
>>
>> šš- Peter's patch is an easy fix to Kirill's problem (RT tasks were
>> ššššthrottled too early);
>> šš- something to add to this solution could be to pre-calculate bw of
>> ššššready DL tasks and subtract it to rt_bw at replenishment time, but
>> ššššit sounds quite awkward, pessimistic, and I'm not sure it is gonna
>> ššššwork;
>> šš- we are stealing bw to best-effort tasks, and just at the beginning
>> ššššof the transistion, is it really a problem?
>> šš- I mean, if you want guarantees make your tasks DL! :);
>> šš- in the long run we are gonna have RT tasks scheduled inside CBS
>> ššššservers, and all this will be properly fixed up.
>>
>> šComments?
>>
>> šBTW, rt timer activation/deactivation should probably be fixed for
>> š!RT_GROUP_SCHED with something like this:
>>
>> š---
>> šškernel/sched/rt.c | šš10 +++++++---
>> šš1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> šdiff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
>> šindex 6161de8..274f992 100644
>> š--- a/kernel/sched/rt.c
>> š+++ b/kernel/sched/rt.c
>> š@@ -86,12 +86,12 @@ void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
>> ššššššššššraw_spin_lock_init(&rt_rq->rt_runtime_lock);
>> šš}
>>
>> š-#ifdef CONFIG_RT_GROUP_SCHED
>> ššstatic void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
>> šš{
>> ššššššššššhrtimer_cancel(&rt_b->rt_period_timer);
>> šš}
>>
>> š+#ifdef CONFIG_RT_GROUP_SCHED
>> šš#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
>>
>> ššstatic inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
>> š@@ -1017,8 +1017,12 @@ inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
>> ššššššššššstart_rt_bandwidth(&def_rt_bandwidth);
>> šš}
>>
>> š-static inline
>> š-void dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
>> š+static void
>> š+dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
>> š+{
>> š+ if (!rt_rq->rt_nr_running)
>> š+ destroy_rt_bandwidth(&def_rt_bandwidth);
>> š+}
>>
>> šš#endif /* CONFIG_RT_GROUP_SCHED */
