Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3LQSDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:03:09 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:40802 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab3LQSDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:03:07 -0500
From: bsegall@google.com
To: Chris Redpath <chris.redpath@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "pjt\@google.com" <pjt@google.com>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "alex.shi\@linaro.org" <alex.shi@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/2] sched: update runqueue clock before migrations away
References: <1386593950-26475-1-git-send-email-chris.redpath@arm.com>
	<1386593950-26475-3-git-send-email-chris.redpath@arm.com>
	<20131210114825.GF12849@twins.programming.kicks-ass.net>
	<52A71605.5090509@arm.com>
	<20131210151428.GH12849@twins.programming.kicks-ass.net>
	<52A7397F.4000806@arm.com>
	<20131212182414.GF2480@laptop.programming.kicks-ass.net>
	<52B05B09.5090807@arm.com>
Date: Tue, 17 Dec 2013 10:03:01 -0800
In-Reply-To: <52B05B09.5090807@arm.com> (Chris Redpath's message of "Tue, 17
	Dec 2013 14:09:13 +0000")
Message-ID: <xm26vbynmk2y.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Redpath <chris.redpath@arm.com> writes:

> On 12/12/13 18:24, Peter Zijlstra wrote:
>> Would pre_schedule_idle() -> rq_last_tick_reset() -> rq->last_sched_tick
>> be useful?
>>
>> I suppose we could easily lift that to NO_HZ_COMMON.
>>
>
> Many thanks for the tip Peter, I have tried this out and it does provide enough
> information to be able to correct the problem. The new version doesn't update
> the rq, just carries the extra unaccounted time (estimated from the jiffies)
> over to be processed during enqueue.
>
> However before I send a new patch set I have a question about the existing
> behavior. Ben, you may already know the answer to this?
>
> During a wake migration we call __synchronize_entity_decay in
> migrate_task_rq_fair, which will decay avg.runnable_avg_sum. We also record the
> amount of periods we decayed for as a negative number in avg.decay_count.
>
> We then enqueue the task on its target runqueue, and again we decay the load by
> the number of periods it has been off-rq.
>
> if (unlikely(se->avg.decay_count <= 0)) {
> 	se->avg.last_runnable_update = rq_clock_task(rq_of(cfs_rq));
> 	if (se->avg.decay_count) {
> 		se->avg.last_runnable_update -= (-se->avg.decay_count)
> 							<< 20;
>>>>		update_entity_load_avg(se, 0);
>
> Am I misunderstanding how this is supposed to work or have we been always
> double-accounting sleep time for wake migrations?

__synchronize_entity_decay will decay load_avg_contrib in order to
figure out how much to remove from old_cfs_rq->blocked_load.
update_entity_load_avg will update the underlying runnable_avg_sum/period that
is used to update load_avg_contrib.

(Normally we update runnable_avg_sum, which updates load_avg_contrib via
__update_entity_load_avg_contrib. Here we go in the reverse direction
because we don't hold the right rq locks at the right times.)
