Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab3LQPwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:52:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47984 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab3LQPwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:52:01 -0500
Date: Tue, 17 Dec 2013 16:51:44 +0100
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
Message-ID: <20131217155144.GQ21999@twins.programming.kicks-ass.net>
References: <1386593950-26475-1-git-send-email-chris.redpath@arm.com>
 <1386593950-26475-3-git-send-email-chris.redpath@arm.com>
 <20131210114825.GF12849@twins.programming.kicks-ass.net>
 <52A71605.5090509@arm.com>
 <20131210151428.GH12849@twins.programming.kicks-ass.net>
 <52A7397F.4000806@arm.com>
 <20131212182414.GF2480@laptop.programming.kicks-ass.net>
 <52B05B09.5090807@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B05B09.5090807@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 02:09:13PM +0000, Chris Redpath wrote:
> On 12/12/13 18:24, Peter Zijlstra wrote:
> >Would pre_schedule_idle() -> rq_last_tick_reset() -> rq->last_sched_tick
> >be useful?
> >
> >I suppose we could easily lift that to NO_HZ_COMMON.
> >
> 
> Many thanks for the tip Peter, I have tried this out and it does provide
> enough information to be able to correct the problem. The new version
> doesn't update the rq, just carries the extra unaccounted time (estimated
> from the jiffies) over to be processed during enqueue.
> 
> However before I send a new patch set I have a question about the existing
> behavior. Ben, you may already know the answer to this?
> 
> During a wake migration we call __synchronize_entity_decay in
> migrate_task_rq_fair, which will decay avg.runnable_avg_sum. We also record
> the amount of periods we decayed for as a negative number in
> avg.decay_count.
> 
> We then enqueue the task on its target runqueue, and again we decay the load
> by the number of periods it has been off-rq.
> 
> if (unlikely(se->avg.decay_count <= 0)) {
> 	se->avg.last_runnable_update = rq_clock_task(rq_of(cfs_rq));
> 	if (se->avg.decay_count) {
> 		se->avg.last_runnable_update -= (-se->avg.decay_count)
> 							<< 20;
> >>>		update_entity_load_avg(se, 0);
> 
> Am I misunderstanding how this is supposed to work or have we been always
> double-accounting sleep time for wake migrations?

The way I understood this is that on migrate we sync from dequeue to
migrate point, and subtract the 'current (at point of migrate)' blocked
load from the src rq, and add it to the dst rq.

Then on enqueue we sync again, but now from migrate to enqueue.
