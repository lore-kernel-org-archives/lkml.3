Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906AbaGDBmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 21:42:02 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:51681 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaGDBmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 21:42:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140703115037.938f4c5dcd5a110529ff0df6@gmail.com>
References: <1404091570-5041-1-git-send-email-zzhsuny@gmail.com>
	<20140701130816.GR6758@twins.programming.kicks-ass.net>
	<20140701155915.55de01236e0540e1f0754560@gmail.com>
	<CADFvMYKzpihC3GLwNFZW0KCrZQY5FDSH5EQd4iLmHLK+hauDWA@mail.gmail.com>
	<20140703115037.938f4c5dcd5a110529ff0df6@gmail.com>
Date: Thu, 3 Jul 2014 21:41:59 -0400
Message-ID: <CADFvMYJ4doDgYmXdbYZhDLRQRSYTaSZ5peHeFSzcF491h3E0Hw@mail.gmail.com>
Subject: Re: [PATCH] [sched] Don't account time after deadline twice
From: Zhihui Zhang <zzhsuny@gmail.com>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We calculate difference between two readings of a clock to see how
much time has elapsed.  Part of the time between rq_clock(rq) -
dl_se->deadline can indeed be accounted for by reading a different
clock
(i.e., rq_clock_task()) if the task was running during the period.
And that is how dl_se->runtime is obtained. After all, both clocks are
running independently, right? Furthermore, the caller of
dl_runtime_exceeded() will still use rq_clock() and dl_se->deadline to
determine if we throttle or replenish. Anyway, I have failed to see
any steal of time.  Could you please give a concrete example (perhaps
with numbers)?

thanks,

-Zhihui

On Thu, Jul 3, 2014 at 5:50 AM, Juri Lelli <juri.lelli@gmail.com> wrote:
> On Wed, 2 Jul 2014 19:44:04 -0400
> Zhihui Zhang <zzhsuny@gmail.com> wrote:
>
>> My point is that rq_clock(rq) - dl_se->deadline is already part of
>> dl_se->runtime, which is decremented before calling dl_runtime_exceeded().
>
> But, we decrement dl_se->runtime looking at rq_clock_task(rq), that is
> in general <= rq_clock(rq), that we use to handle deadlines. So, if we
> do like you suggest, in some cases we could end up stealing some
> bandwidth from the system. Indeed, we prefer some pessimism here.
>
> Thanks,
>
> - Juri
>
>> So the following line is not needed in the case of both overrun and missing
>> deadline:
>>
>>     dl_se->runtime -= rq_clock(rq) - dl_se->deadline;
>>
>> Or did I miss anything?
>>
>> thanks,
>>
>>
>> On Tue, Jul 1, 2014 at 9:59 AM, Juri Lelli <juri.lelli@gmail.com> wrote:
>>
>> > On Tue, 1 Jul 2014 15:08:16 +0200
>> > Peter Zijlstra <peterz@infradead.org> wrote:
>> >
>> > > On Sun, Jun 29, 2014 at 09:26:10PM -0400, Zhihui Zhang wrote:
>> > > > Unless we want to double-penalize an overrun task, the time after the
>> > deadline
>> > > > and before the current time is already accounted in the negative
>> > dl_se->runtime
>> > > > value. So we can leave it as is in the case of dmiss && rorun.
>> > >
>> > > Juri?
>> > >
>> > > > Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
>> > > > ---
>> > > >  kernel/sched/deadline.c | 6 ++----
>> > > >  1 file changed, 2 insertions(+), 4 deletions(-)
>> > > >
>> > > > diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>> > > > index fc4f98b1..67df0d6 100644
>> > > > --- a/kernel/sched/deadline.c
>> > > > +++ b/kernel/sched/deadline.c
>> > > > @@ -579,10 +579,8 @@ int dl_runtime_exceeded(struct rq *rq, struct
>> > sched_dl_entity *dl_se)
>> > > >      * the next instance. Thus, if we do not account that, we are
>> > > >      * stealing bandwidth from the system at each deadline miss!
>> > > >      */
>> > > > -   if (dmiss) {
>> > > > -           dl_se->runtime = rorun ? dl_se->runtime : 0;
>> >
>> > If we didn't return 0 before, we are going to throttle (or replenish)
>> > the entity, and you want runtime to be <=0. So, this is needed.
>> >
>> > > > -           dl_se->runtime -= rq_clock(rq) - dl_se->deadline;
>> > > > -   }
>> >
>> > A little pessimism in some cases, due to the fact that we use both
>> > rq_clock and rq_clock_task (for the budget).
>> >
>> > Thanks,
>> >
>> > - Juri
>> >
>> > > > +   if (dmiss && !rorun)
>> > > > +           dl_se->runtime = dl_se->deadline - rq_clock(rq);
>> > > >
>> > > >     return 1;
>> > > >  }
>> > > > --
>> > > > 1.8.1.2
>> > > >
>> >
