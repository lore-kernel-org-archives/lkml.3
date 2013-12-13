Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab3LMItI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:49:08 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:36329 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3LMItG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:49:06 -0500
MIME-Version: 1.0
In-Reply-To: <20131212182414.GF2480@laptop.programming.kicks-ass.net>
References: <1386593950-26475-1-git-send-email-chris.redpath@arm.com>
 <1386593950-26475-3-git-send-email-chris.redpath@arm.com> <20131210114825.GF12849@twins.programming.kicks-ass.net>
 <52A71605.5090509@arm.com> <20131210151428.GH12849@twins.programming.kicks-ass.net>
 <52A7397F.4000806@arm.com> <20131212182414.GF2480@laptop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 13 Dec 2013 09:48:45 +0100
Message-ID: <CAKfTPtDsPkXGAGr_AmKxcaBBfVO-fEyg+2DAw76SmBcd+y9P=A@mail.gmail.com>
Subject: Re: [PATCH 2/2] sched: update runqueue clock before migrations away
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Redpath <chris.redpath@arm.com>, "pjt@google.com" <pjt@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bsegall@google.com" <bsegall@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 December 2013 19:24, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Dec 10, 2013 at 03:55:43PM +0000, Chris Redpath wrote:
>> >That's guestimating the last_runnable_update based on decay_count, and
>> >per the previous the decay count can get slightly out of sync.
>>
>> The guesstimation works fine, the issue is only that we can't tell at
>> this point how much time that entity was asleep when the CPU it ran on
>> has no tick and since it is too expensive to synchronize the clocks,
>> there isn't (currently) a way to find out without updating the rq we
>> came from.
>>
>> I can't see anything handy lying around in struct rq, but is there a
>> copy of the jiffies held anywhere per-cpu presuming it would stop being
>> updated when the tick stops? If not, I could store one somewhere as part
>> of turning the tick off and then we could use the difference between
>> that and the current jiffies count to estimate the amount of time in
>> limbo. That would almost certainly be accurate enough for me - a few ms
>> won't hurt but when we lose seconds it does.
>
> Would pre_schedule_idle() -> rq_last_tick_reset() -> rq->last_sched_tick
> be useful?
>
> I suppose we could easily lift that to NO_HZ_COMMON.
>
> Which raises another point; I dislike this idle pre/post business. Why
> can't the post_schedule_idle() calls be done from pick_next_task_idle()
> and pre_schedule_idle() done from put_prev_task_idle() ?

The update of runnable_avg for a cpu that becomes idle, must be done
before the call to idle_balance which will use it; So idle_enter_fair
is called in pre_schedule_idle.
idle_exit_fair has been put in the post_schedule function in order to
be symmetric and coherent but nothing prevent from moving it in
pick_next_task_idle.

Vincent

>
> That would avoid the post_schedule() rq->lock dance.
>
> Vince?
