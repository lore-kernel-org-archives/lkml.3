Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbbAGHCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:02:11 -0500
Received: from mail3.unitn.it ([193.205.206.24]:64947 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbbAGHCJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:02:09 -0500
Date: Wed, 7 Jan 2015 08:01:55 +0100
From: Luca Abeni <luca.abeni@unitn.it>
To: tkhai@yandex.ru
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Another SCHED_DEADLINE bug (with bisection and possible fix)
Message-ID: <20150107080155.1d42d123@luca-1225C>
In-Reply-To: <1420499241.3361.14.camel@yandex.ru>
References: <20141230002738.6c12db31@utopia>
	<2629881420411885@web9m.yandex.ru>
	<54AAABFB.3060109@unitn.it>
	<1420499241.3361.14.camel@yandex.ru>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

On Tue, 06 Jan 2015 02:07:21 +0300
Kirill Tkhai <tkhai@yandex.ru> wrote:

> On Пн, 2015-01-05 at 16:21 +0100, Luca Abeni wrote:
[...]
> > For reference, I attach the patch I am using locally (based on what
> > I suggested in my previous mail) and seems to work fine here.
> > 
> > Based on your comments, I suspect my patch can be further
> > simplified by moving the call to init_dl_task_timer() in
> > __sched_fork().
> 
> It seems this way has problems. The first one is that task may become
> throttled again, and we will start dl_timer again.
Well, in my understanding if I change the parameters of a
SCHED_DEADLINE task when it is throttled, it stays throttled... So, the
task might not become throttled again before the dl timer fires.
So, I hoped this problem does not exist. But I might be wrong.

> The second is that
> it's better to minimize number of combination of situations we have.
> Let's keep only one combination: timer is set <-> task is throttled.
Yes, this was my goal too... So, if I change the parameters of a task
when it is throttled, I leave dl_throttled set to 1 and I leave the
timer active.

[...]
> > > @@ -3250,16 +3251,19 @@ static void
> > >   __setparam_dl(struct task_struct *p, const struct sched_attr
> > > *attr) {
> > >   	struct sched_dl_entity *dl_se = &p->dl;
> > > +        struct hrtimer *timer = &dl_se->dl_timer;
> > > +
> > > +	if (!hrtimer_active(timer) ||
> > > hrtimer_try_to_cancel(timer) != -1) {
> > Just for the sake of curiosity, why trying to cancel the timer
> > ("|| hrtimer_try_to_cancel(timer)") here? If it is active, cannot
> > we leave it active (without touching dl_throttled, dl_new and
> > dl_yielded)?
> > 
> > I mean: if I try to change the parameters of a task when it is
> > throttled, I'd like it to stay throttled until the end of the
> > reservation period... Or am I missing something?
> 
> I think that when people change task's parameters, they want the
> kernel reacts on this immediately. For example, you want to kill
> throttled deadline task. You change parameters, but nothing happens.
> I think all developers had this use case when they were debugging
> deadline class.
I see... Different people have different requirements :)
My goal was to do something like adaptive scheduling (or scheduling
tasks with mode changes), so I did not want that changing the
scheduling parameters of a task affected the scheduling of the other
tasks... But if a task exits the throttled state when I change its
parameters, it might consume much more than the reserved CPU time.
Also, I suspect this kind of approach can be exploited by malicious
users: if I create a task with runtime 30ms and period 100ms, and I
change its scheduling parameters (to runtime=29ms and back) frequently
enough, I can consume much more than 30% of the CPU time...

Anyway, I am fine with every patch that fixes the bug :)



			Thanks,
				Luca
