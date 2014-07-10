Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbaGJRBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 13:01:46 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33245 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaGJRBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 13:01:44 -0400
From: bsegall@google.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yuyang Du <yuyang.du@intel.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, fengguang.wu@intel.com
Subject: Re: [PATCH 2/2] sched: Rewrite per entity runnable load average tracking
References: <1404268256-3019-1-git-send-email-yuyang.du@intel.com>
	<1404268256-3019-2-git-send-email-yuyang.du@intel.com>
	<20140707104646.GK6758@twins.programming.kicks-ass.net>
	<xm26r41wyfgc.fsf@sword-of-the-dawn.mtv.corp.google.com>
	<20140708000840.GB25653@intel.com>
	<xm26k37nye7d.fsf@sword-of-the-dawn.mtv.corp.google.com>
	<20140709010753.GD25653@intel.com>
	<20140709184543.GI9918@twins.programming.kicks-ass.net>
	<xm26bnsyxsf7.fsf@sword-of-the-dawn.mtv.corp.google.com>
	<20140710100859.GW3935@laptop>
Date: Thu, 10 Jul 2014 10:01:42 -0700
In-Reply-To: <20140710100859.GW3935@laptop> (Peter Zijlstra's message of "Thu,
	10 Jul 2014 12:08:59 +0200")
Message-ID: <xm267g3lxi4p.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Jul 09, 2014 at 12:07:08PM -0700, bsegall@google.com wrote:
>> Peter Zijlstra <peterz@infradead.org> writes:
>> 
>> > On Wed, Jul 09, 2014 at 09:07:53AM +0800, Yuyang Du wrote:
>> >> That is chalenging... Can someone (Peter) grant us a lock of the remote rq? :)
>> >
>> > Nope :-).. we got rid of that lock for a good reason.
>> >
>> > Also, this is one area where I feel performance really trumps
>> > correctness, we can fudge the blocked load a little. So the
>> > sched_clock_cpu() difference is a strict upper bound on the
>> > rq_clock_task() difference (and under 'normal' circumstances shouldn't
>> > be much off).
>> 
>> Well, unless IRQ_TIME_ACCOUNTING or such is on, in which case you lose.
>> Or am I misunderstanding the suggestion?
>
> If its on its still an upper bound, and typically the difference is not
> too large I think.
>
> Since clock_task is the regular clock minus some local amount, the
> difference between two regular clock reads is always a strict upper
> bound on clock_task differences.
>
>> Actually the simplest thing
>> would probably be to grab last_update_time (which on 32-bit could be
>> done with the _copy hack) and use that. Then I think the accuracy is
>> only worse than current in that you can lose runnable load as well as
>> blocked load, and that it isn't as easily corrected - currently if the
>> blocked tasks wake up they'll add the correct numbers to
>> runnable_load_avg, even if blocked_load_avg is screwed up and hit zero.
>> This code would have to wait until it stabilized again.
>
> The problem with that is that last_update_time is measured in
> clock_task, and you cannot transfer these values between CPUs.
> clock_task can drift unbounded between CPUs.

Yes, but we don't need to - we just use the remote last_update_time to
do a final update on p->se.avg, and then subtract that from cfs_rq->avg
with atomics (and then set p->se.avg.last_update_time to 0 as now). This
throws away any time since last_update_time, but that's no worse than
current, which throws away any time since decay_counter, and they're
both called from enqueue/dequeue/tick/update_blocked_averages.
