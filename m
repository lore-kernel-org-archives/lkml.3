Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaAUUDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:03:43 -0500
Received: from mail-gg0-f179.google.com ([209.85.161.179]:44491 "EHLO
	mail-gg0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaAUUDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:03:41 -0500
From: bsegall@google.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, daniel.lezcano@linaro.org,
        pjt@google.com
Subject: Re: [PATCH 8/9] sched/fair: Optimize cgroup pick_next_task_fair
References: <20140121111754.580142558@infradead.org>
	<20140121112258.708117448@infradead.org>
	<xm2661pdkuiw.fsf@sword-of-the-dawn.mtv.corp.google.com>
	<20140121193759.GR11314@laptop.programming.kicks-ass.net>
Date: Tue, 21 Jan 2014 12:03:38 -0800
In-Reply-To: <20140121193759.GR11314@laptop.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Tue, 21 Jan 2014 20:37:59 +0100")
Message-ID: <xm261u01kspx.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Tue, Jan 21, 2014 at 11:24:39AM -0800, bsegall@google.com wrote:
>> Peter Zijlstra <peterz@infradead.org> writes:
>
>> > +#ifdef CONFIG_FAIR_GROUP_SCHED
>> > +	/*
>> > +	 * If we haven't yet done put_prev_entity and the selected task is
>> > +	 * a different task than we started out with, try and touch the least
>> > +	 * amount of cfs_rq trees.
>> > +	 */
>> > +	if (prev) {
>> > +		if (prev != p) {
>> > +			pse = &prev->se;
>> > +
>> > +			while (!(cfs_rq = is_same_group(se, pse))) {
>> > +				int se_depth = se->depth;
>> > +				int pse_depth = pse->depth;
>> > +
>> > +				if (se_depth <= pse_depth) {
>> > +					put_prev_entity(cfs_rq_of(pse), pse);
>> > +					pse = parent_entity(pse);
>> > +				}
>> > +				if (se_depth >= pse_depth) {
>> > +					set_next_entity(cfs_rq_of(se), se);
>> > +					se = parent_entity(se);
>> > +				}
>> > +			}
>> >  
>> > +			put_prev_entity(cfs_rq, pse);
>> > +			set_next_entity(cfs_rq, se);
>> > +		}
>
> (A)
>
>> > +		/*
>> > +		 * In case the common cfs_rq got throttled, just give up and
>> > +		 * put the stack and retry.
>> > +		 */
>> > +		if (unlikely(check_cfs_rq_runtime(cfs_rq))) {
>> > +			put_prev_task_fair(rq, p);
>> > +			prev = NULL;
>> > +			goto again;
>> > +		}
>> 
>> This double-calls put_prev_entity on any non-common cfs_rqs and ses,
>> which means double __enqueue_entity, among other things. Just doing the
>> put_prev loop from se->parent should fix that.
>
> I'm not seeing that, so at point (A) we've completely switched over from
> @prev to @p, we've put all pse until the common parent and set all se
> back to @p.
>
> So if we then do: put_prev_task_fair(rq, p), we simply undo all the
> set_next_entity(se) we just did, and continue from the common parent
> upwards.
>
>> However, any sort of abort means that we may have already done
>> set_next_entity on some children, which even with the changes to
>> pick_next_entity will cause problems, up to and including double
>> __dequeue_entity I think.
>
> But the abort is only done after we've completely set up @p as the
> current task.
>
> Yes, completely tearing it down again is probably a waste, but given
> that bandwidth enforcement should be rare and I didn't want to
> complicate things even further for rare cases.


Ah, I missed that this was p, not prev. That makes a lot more sense, and
I agree that this should be fine.

>
>> Also, this way we never do check_cfs_rq_runtime on any parents of the
>> common cfs_rq, which could even have been the reason for the resched to
>> begin with. I'm not sure if there would be any problem doing it on the
>> way down or not, I don't see any problems at a glance.
>
> Oh, so we allow a parent to have less runtime than the sum of all its
> children?

Yeah, the check is currently max(children) <= parent, and unthrottled
children are also allowed.

>
> Indeed, in that case we can miss something... we could try to call
> check_cfs_rq_runtime() from the initial top-down selection loop? When
> true, just put the entire stack and don't pretend to be smart?

Yeah, I think that should work. I wasn't sure if there could be a
problem of doing throttle_cfs_rq(parent); throttle_cfs_rq(child);, but
thinking about, that has to be ok, because schedule can do that if
deactivate throttled the parent, schedule calls update_rq_clock, and
then put_prev throttled the child.
