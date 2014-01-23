Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbaAWO4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:56:08 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:40000 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbaAWO4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:56:06 -0500
MIME-Version: 1.0
In-Reply-To: <20140123113754.GW31570@twins.programming.kicks-ass.net>
References: <20140121111754.580142558@infradead.org> <20140121112258.459329467@infradead.org>
 <CAKfTPtDVvyH45fF9=Z-AZuf7c74uqvVfCdGDqksWSviDJj1JXA@mail.gmail.com> <20140123113754.GW31570@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 23 Jan 2014 15:52:44 +0100
Message-ID: <CAKfTPtBzVb89wTHjPM4LeOfpHLS-B0dkEWbE8DpowRG2Bi_VyQ@mail.gmail.com>
Subject: Re: [PATCH 4/9] sched: Clean up idle task SMP logic
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 January 2014 12:37, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jan 21, 2014 at 06:27:11PM +0100, Vincent Guittot wrote:
>> On 21 January 2014 12:17, Peter Zijlstra <peterz@infradead.org> wrote:
>
>> If i have correctly followed the new function path that is introduced
>> by the patchset, idle_enter_fair is called after idle_balance whereas
>> it must be called before in order to update the
>> runnable_avg_sum/period of the rq before evaluating the interest of
>> pulling cfs task
>
> Its idle_exit_fair, that's moved from pre_schedule to put_prev_task and
> thus indeed has crossed idle_balance.

ok, so i probably mix the changes introduced by your patches and a
potential issue that was already present before

idle_enter/exit_fair are used to be sure to account correctly the run
time of a rq in its sched_avg field, so they must be called before
entering/leaving idle. Your patch ensures that they will be called
correctly. Now, the idle_balance is used to check the interest of
pulling task on this newly idle CPU and it could use the sched_avg
field in a near future regarding the discussion around a energy aware
scheduler. as a result, we must update the sched_avg field before
running the idle_balance (that's not the case even before your
patches)

So one solution is probably to move idle_enter_fair into the idle_balance

Regards,
Vincent

>
> Yeah, I can leave that pre_schedule thing in place, however all that has
> be thinking.
>
> Ideally we'd do something like the below; but I must admit to still
> being slightly confused about the idle_{enter,exit}_fair() calls, their
> comment doesn't seem to clarify things.
>
> Steve, I don't think I wrecked rt/deadline by pulling in the
> pre_schedule call into pick_next_task(), but then, who knows :-)
>
> The only thing I really don't like is having that double conditional for
> the direct fair_sched_class call, but I didn't see a way around that,
> other than dropping that entirely. Then again, we cut out a conditional
> and indirect call by getting rid of pre_schedule() -- so it might just
> balance out.
>

[snip]
