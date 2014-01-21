Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaAUUbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:31:53 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49935 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaAUUbu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:31:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAKfTPtDEKnM+er0NLxCKN4gK_KP3hnzPd13k7qqYtyWKCgdP4w@mail.gmail.com>
References: <1390320738-4555-1-git-send-email-vincent.guittot@linaro.org>
 <xm26d2jlkwn1.fsf@sword-of-the-dawn.mtv.corp.google.com> <CAKfTPtDEKnM+er0NLxCKN4gK_KP3hnzPd13k7qqYtyWKCgdP4w@mail.gmail.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 21 Jan 2014 12:31:18 -0800
Message-ID: <CAPM31RLjHnn=Ma7peuDUqK75bANw7Mb-UT-1QmzG0c8LAObQ8g@mail.gmail.com>
Subject: Re: [PATCH] sched: fix sched_entity avg statistics update
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 12:00 PM, Vincent Guittot
<vincent.guittot@linaro.org> wrote:
>
> Le 21 janv. 2014 19:39, <bsegall@google.com> a écrit :
>
>
>>
>> Vincent Guittot <vincent.guittot@linaro.org> writes:
>>
>> > With the current implementation, the load average statistics of a sched
>> > entity
>> > change according to other activity on the CPU even if this activity is
>> > done
>> > between the running window of the sched entity and have no influence on
>> > the
>> > running duration of the task.
>> >
>> > When a task wakes up on the same CPU, we currently update
>> > last_runnable_update
>> > with the return  of __synchronize_entity_decay without updating the
>> > runnable_avg_sum and runnable_avg_period accordingly. In fact, we have
>> > to sync
>> > the load_contrib of the se with the rq's blocked_load_contrib before
>> > removing
>> > it from the latter (with __synchronize_entity_decay) but we must keep
>> > last_runnable_update unchanged for updating runnable_avg_sum/period
>> > during the
>> > next update_entity_load_avg.
>>
>> ... Gah, that's correct, we had this right the first time. Could you do
>> this as a full revert of 282cf499f03ec1754b6c8c945c9674b02631fb0f (ie
>> remove the now inaccurate comment, or maybe replace it with a correct
>> one).
>
> Ok i'm going to remove comment as well and replace it with a new description
>

I think I need to go through and do a comments patch like we did with
the wake-affine math; it's too easy to make a finicky mistake like
this when not touching this path for a while.

OK, so there are two numerical components we're juggling here:

1) The actual quotient for the current runnable average, stored as
(runnable_avg_sum / runnable_avg period).  Last updated at
last_runnable_update.
2) The last time we computed the quotient in (1) and accumulated it in
within cfs_rq->{runnable, blocked}_load_avg, this is stored in
load_avg_contrib.  We track the passage of off-rq time and migrations
against this value using decay_count.
[ All of the values above are stored on se / se->avg ]

When we are re-enqueuing something and we wish to remove its
contribution from blocked_load_avg, we must update load_avg_contrib in
(2) using the total time it spent off rq (using a jiffy rounded
approximation in decay_count).  However, Alex's patch (which this
reverts) also adjusted the quotient by modifying its last update time
so as to make it look up-to-date, effectively skipping the most recent
idle span.

I think we could make the connection between (1) and (2) more explicit
if we moved the subsequent "if (wakeup) logic" within the else.  We
can then have a comment that refers to (1) and (2) explicitly, perhaps
something like:

Task re-woke on same cpu (or else migrate_task_rq_fair() would have
made count negative).  Perform an approximate decay on
load_avg_contrib to match blocked_load_avg, and compute a precise
runnable_avg_sum quotient update that will be accumulated into
runnable_load_avg below.


>
>> >
>> > Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> > ---
>> >  kernel/sched/fair.c |    3 +--
>> >  1 file changed, 1 insertion(+), 2 deletions(-)
>> >
>> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> > index e64b079..5b0ef90 100644
>> > --- a/kernel/sched/fair.c
>> > +++ b/kernel/sched/fair.c
>> > @@ -2370,8 +2370,7 @@ static inline void enqueue_entity_load_avg(struct
>> > cfs_rq *cfs_rq,
>> >                * would have made count negative); we must be careful to
>> > avoid
>> >                * double-accounting blocked time after synchronizing
>> > decays.
>> >                */
>> > -             se->avg.last_runnable_update +=
>> > __synchronize_entity_decay(se)
>> > -                                                     << 20;
>> > +             __synchronize_entity_decay(se);
>> >       }
>> >
>> >       /* migrated tasks did not contribute to our blocked load */
