Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbaGITHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:07:12 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38912 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbaGITHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:07:10 -0400
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
Date: Wed, 09 Jul 2014 12:07:08 -0700
In-Reply-To: <20140709184543.GI9918@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Wed, 9 Jul 2014 20:45:43 +0200")
Message-ID: <xm26bnsyxsf7.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Jul 09, 2014 at 09:07:53AM +0800, Yuyang Du wrote:
>> That is chalenging... Can someone (Peter) grant us a lock of the remote rq? :)
>
> Nope :-).. we got rid of that lock for a good reason.
>
> Also, this is one area where I feel performance really trumps
> correctness, we can fudge the blocked load a little. So the
> sched_clock_cpu() difference is a strict upper bound on the
> rq_clock_task() difference (and under 'normal' circumstances shouldn't
> be much off).

Well, unless IRQ_TIME_ACCOUNTING or such is on, in which case you lose.
Or am I misunderstanding the suggestion? Actually the simplest thing
would probably be to grab last_update_time (which on 32-bit could be
done with the _copy hack) and use that. Then I think the accuracy is
only worse than current in that you can lose runnable load as well as
blocked load, and that it isn't as easily corrected - currently if the
blocked tasks wake up they'll add the correct numbers to
runnable_load_avg, even if blocked_load_avg is screwed up and hit zero.
This code would have to wait until it stabilized again.

>
> So we could simply use a timestamps from dequeue and one from enqueue,
> and use that.
>
> As to the remote subtraction, a RMW on another cacheline than the
> rq->lock one should be good; esp since we don't actually observe the
> per-rq total often (once per tick or so) I think, no?

Yeah, it's definitely a different cacheline, and the current code only
reads per-ms or on loadbalance migration.

>
> The thing is, we do not want to disturb scheduling on whatever cpu the
> task last ran on if we wake it to another cpu. Taking rq->lock wrecks
> that for sure. 
