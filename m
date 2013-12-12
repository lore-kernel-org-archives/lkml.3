Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab3LLSYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:24:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44339 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3LLSYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:24:22 -0500
Date: Thu, 12 Dec 2013 19:24:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Redpath <chris.redpath@arm.com>
Cc: "pjt@google.com" <pjt@google.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bsegall@google.com" <bsegall@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/2] sched: update runqueue clock before migrations away
Message-ID: <20131212182414.GF2480@laptop.programming.kicks-ass.net>
References: <1386593950-26475-1-git-send-email-chris.redpath@arm.com>
 <1386593950-26475-3-git-send-email-chris.redpath@arm.com>
 <20131210114825.GF12849@twins.programming.kicks-ass.net>
 <52A71605.5090509@arm.com>
 <20131210151428.GH12849@twins.programming.kicks-ass.net>
 <52A7397F.4000806@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A7397F.4000806@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 03:55:43PM +0000, Chris Redpath wrote:
> >That's guestimating the last_runnable_update based on decay_count, and
> >per the previous the decay count can get slightly out of sync.
> 
> The guesstimation works fine, the issue is only that we can't tell at
> this point how much time that entity was asleep when the CPU it ran on
> has no tick and since it is too expensive to synchronize the clocks,
> there isn't (currently) a way to find out without updating the rq we
> came from.
> 
> I can't see anything handy lying around in struct rq, but is there a
> copy of the jiffies held anywhere per-cpu presuming it would stop being
> updated when the tick stops? If not, I could store one somewhere as part
> of turning the tick off and then we could use the difference between
> that and the current jiffies count to estimate the amount of time in
> limbo. That would almost certainly be accurate enough for me - a few ms
> won't hurt but when we lose seconds it does.

Would pre_schedule_idle() -> rq_last_tick_reset() -> rq->last_sched_tick
be useful?

I suppose we could easily lift that to NO_HZ_COMMON.

Which raises another point; I dislike this idle pre/post business. Why
can't the post_schedule_idle() calls be done from pick_next_task_idle()
and pre_schedule_idle() done from put_prev_task_idle() ?

That would avoid the post_schedule() rq->lock dance.

Vince?
