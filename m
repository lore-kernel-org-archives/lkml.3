Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbbAGM3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 07:29:14 -0500
Received: from forward9l.mail.yandex.net ([84.201.143.142]:55425 "EHLO
	forward9l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbbAGM3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:29:10 -0500
Authentication-Results: smtp4h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1420633741.12772.10.camel@yandex.ru>
Subject: Re: Another SCHED_DEADLINE bug (with bisection and possible fix)
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
To: Luca Abeni <luca.abeni@unitn.it>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 07 Jan 2015 15:29:01 +0300
In-Reply-To: <20150107080155.1d42d123@luca-1225C>
References: <20141230002738.6c12db31@utopia>
	 <2629881420411885@web9m.yandex.ru> <54AAABFB.3060109@unitn.it>
	 <1420499241.3361.14.camel@yandex.ru> <20150107080155.1d42d123@luca-1225C>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Ср, 2015-01-07 at 08:01 +0100, Luca Abeni wrote:
> Hi Kirill,
> 
> On Tue, 06 Jan 2015 02:07:21 +0300
> Kirill Tkhai <tkhai@yandex.ru> wrote:
> 
> > On Пн, 2015-01-05 at 16:21 +0100, Luca Abeni wrote:
> [...]
> > > For reference, I attach the patch I am using locally (based on what
> > > I suggested in my previous mail) and seems to work fine here.
> > > 
> > > Based on your comments, I suspect my patch can be further
> > > simplified by moving the call to init_dl_task_timer() in
> > > __sched_fork().
> > 
> > It seems this way has problems. The first one is that task may become
> > throttled again, and we will start dl_timer again.
> Well, in my understanding if I change the parameters of a
> SCHED_DEADLINE task when it is throttled, it stays throttled... So, the
> task might not become throttled again before the dl timer fires.
> So, I hoped this problem does not exist. But I might be wrong.

You keep zeroing of dl_se->dl_throttled, and further enqueue_task()
places it on the dl_rq. So, further update_curr_dl() may make it throttled
again, and it will try to start dl_timer (which is already set).

> > The second is that
> > it's better to minimize number of combination of situations we have.
> > Let's keep only one combination: timer is set <-> task is throttled.
> Yes, this was my goal too... So, if I change the parameters of a task
> when it is throttled, I leave dl_throttled set to 1 and I leave the
> timer active.

As I see,

dl_se->dl_throttled = 0;

is still in __setparam_dl() after your patch, so you do not leave
it set to 1.

> 
> [...]
> > > > @@ -3250,16 +3251,19 @@ static void
> > > >   __setparam_dl(struct task_struct *p, const struct sched_attr
> > > > *attr) {
> > > >   	struct sched_dl_entity *dl_se = &p->dl;
> > > > +        struct hrtimer *timer = &dl_se->dl_timer;
> > > > +
> > > > +	if (!hrtimer_active(timer) ||
> > > > hrtimer_try_to_cancel(timer) != -1) {
> > > Just for the sake of curiosity, why trying to cancel the timer
> > > ("|| hrtimer_try_to_cancel(timer)") here? If it is active, cannot
> > > we leave it active (without touching dl_throttled, dl_new and
> > > dl_yielded)?
> > > 
> > > I mean: if I try to change the parameters of a task when it is
> > > throttled, I'd like it to stay throttled until the end of the
> > > reservation period... Or am I missing something?
> > 
> > I think that when people change task's parameters, they want the
> > kernel reacts on this immediately. For example, you want to kill
> > throttled deadline task. You change parameters, but nothing happens.
> > I think all developers had this use case when they were debugging
> > deadline class.
> I see... Different people have different requirements :)
> My goal was to do something like adaptive scheduling (or scheduling
> tasks with mode changes), so I did not want that changing the
> scheduling parameters of a task affected the scheduling of the other
> tasks... But if a task exits the throttled state when I change its
> parameters, it might consume much more than the reserved CPU time.
> Also, I suspect this kind of approach can be exploited by malicious
> users: if I create a task with runtime 30ms and period 100ms, and I
> change its scheduling parameters (to runtime=29ms and back) frequently
> enough, I can consume much more than 30% of the CPU time...
> 
> Anyway, I am fine with every patch that fixes the bug :)

Deadline class requires root privileges. So, I do not see a problem
here. Please, see __sched_setscheduler().

If in the future we allow non-privileged users to increase deadline,
we will reflect that in __setparam_dl() too.

Thanks,
Kirill.

