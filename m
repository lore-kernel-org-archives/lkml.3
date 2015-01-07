Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbbAGNEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:04:45 -0500
Received: from forward5l.mail.yandex.net ([84.201.143.138]:54452 "EHLO
	forward5l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbbAGNEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:04:44 -0500
Authentication-Results: smtp2o.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1420635879.14676.12.camel@yandex.ru>
Subject: Re: Another SCHED_DEADLINE bug (with bisection and possible fix)
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
To: Luca Abeni <luca.abeni@unitn.it>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 07 Jan 2015 16:04:39 +0300
In-Reply-To: <54AD2A56.70307@unitn.it>
References: <20141230002738.6c12db31@utopia>
		 <2629881420411885@web9m.yandex.ru> <54AAABFB.3060109@unitn.it>
		 <1420499241.3361.14.camel@yandex.ru> <20150107080155.1d42d123@luca-1225C>
	 <1420633741.12772.10.camel@yandex.ru> <54AD2A56.70307@unitn.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Ср, 2015-01-07 at 13:45 +0100, Luca Abeni wrote:
> On 01/07/2015 01:29 PM, Kirill Tkhai wrote:
> [...]
> >>>> Based on your comments, I suspect my patch can be further
> >>>> simplified by moving the call to init_dl_task_timer() in
> >>>> __sched_fork().
> >>>
> >>> It seems this way has problems. The first one is that task may become
> >>> throttled again, and we will start dl_timer again.
> >> Well, in my understanding if I change the parameters of a
> >> SCHED_DEADLINE task when it is throttled, it stays throttled... So, the
> >> task might not become throttled again before the dl timer fires.
> >> So, I hoped this problem does not exist. But I might be wrong.
> >
> > You keep zeroing of dl_se->dl_throttled
> Right... Now that you point this out, I realize that dl_se->dl_throttled = 0
> should be inside the if().
> 
> > and further enqueue_task() places it on the dl_rq.
> I was under the impression that no further enqueue_task() will happen (since
> the task is throttled, it is not on runqueue, so __sched_setscheduler() will
> not dequeue/enqueue it).
> But I am probably missing something else :)

We have two concept of "on runqueue". The first one is rq->on_rq. It means
that a task is "queued". The second is on_dl_rq(dl_se).

When task is not "queued", it's always not on dl_rq.

When task is "queued" it may be in two states:
1)on_dl_rq() -- this means the task is not throttled;
2)!on_dl_rq() -- is task as throttled.

So when we are discussing about a throttled task, the task is "queued". If
you clear dl_throttled, __sched_setscheduler() places it back it the both
meaning: on_rq and on_dl_rq, and the task becomes available for picking
in __schedule().

> 
> >>> The second is that
> >>> it's better to minimize number of combination of situations we have.
> >>> Let's keep only one combination: timer is set <-> task is throttled.
> >> Yes, this was my goal too... So, if I change the parameters of a task
> >> when it is throttled, I leave dl_throttled set to 1 and I leave the
> >> timer active.
> >
> > As I see,
> >
> > dl_se->dl_throttled = 0;
> >
> > is still in __setparam_dl() after your patch, so you do not leave
> > it set to 1.
> You are right, my fault.
> 
> [...]
> >>> I think that when people change task's parameters, they want the
> >>> kernel reacts on this immediately. For example, you want to kill
> >>> throttled deadline task. You change parameters, but nothing happens.
> >>> I think all developers had this use case when they were debugging
> >>> deadline class.
> >> I see... Different people have different requirements :)
> >> My goal was to do something like adaptive scheduling (or scheduling
> >> tasks with mode changes), so I did not want that changing the
> >> scheduling parameters of a task affected the scheduling of the other
> >> tasks... But if a task exits the throttled state when I change its
> >> parameters, it might consume much more than the reserved CPU time.
> >> Also, I suspect this kind of approach can be exploited by malicious
> >> users: if I create a task with runtime 30ms and period 100ms, and I
> >> change its scheduling parameters (to runtime=29ms and back) frequently
> >> enough, I can consume much more than 30% of the CPU time...
> >>
> >> Anyway, I am fine with every patch that fixes the bug :)
> >
> > Deadline class requires root privileges. So, I do not see a problem
> > here. Please, see __sched_setscheduler().
> I know... But the final goal is to allow non-root users to use SCHED_DEADLINE,
> so I was thinking about future problems.

I think everything may change many times before we implement that. It's better
to keep the code in the consistent state.

> > If in the future we allow non-privileged users to increase deadline,
> > we will reflect that in __setparam_dl() too.
> Ok.

Does my patch help you? It helps me, but anyway I need your confirmation.

Thanks,
Kirill.

