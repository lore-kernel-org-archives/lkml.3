Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3D2Ggb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 02:36:31 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:64669 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3D2Gg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 02:36:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130426191118.GD1433@mtj.dyndns.org>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
	<480f5d6da920e2f2b868f311228c81635727799e.1366803121.git.viresh.kumar@linaro.org>
	<CAP245DWtwguSp8ubid_KJnLSOqvCbmTXN+0Bg_MtDrUhBqve-Q@mail.gmail.com>
	<CAKohpokN_o-RUX6MDwqqfzu4NKRysG-hSzmB=MHV7Y0aDbztuA@mail.gmail.com>
	<20130424161208.GA16991@mtj.dyndns.org>
	<CAP245DUGuaSQbP4026N8kgn6-NqXFJWR3zKoYud=HQ_b+v5+Xw@mail.gmail.com>
	<CAKohpo=U5OqN7SM7XyOWv-WoUHOoJvGc6wcGH61+uikPK3novg@mail.gmail.com>
	<20130426191118.GD1433@mtj.dyndns.org>
Date: Mon, 29 Apr 2013 12:06:28 +0530
Message-ID: <CAKohpokJSwi24goSG=dTKkH0p+-YgsVURa_4giyU-u2TuK1bdA@mail.gmail.com>
Subject: Re: [PATCH V5 1/5] workqueues: Introduce new flag WQ_POWER_EFFICIENT
 for power oriented workqueues
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>, davem@davemloft.net,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robin Randhawa <robin.randhawa@arm.com>,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>,
        Steve Bannister <Steve.Bannister@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Patch Tracking <patches@linaro.org>, airlied@redhat.com,
        mingo@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Tejun,

On 27 April 2013 00:41, Tejun Heo <tj@kernel.org> wrote:
> Hey, Viresh.
>
> It's already too late for the upcoming merge window, but things
> generally look good to me and I'll apply the patchset once wq/for-3.11
> opens.  One nitpick tho.

Obviously. I understand this and agree with you on it. It should go in 3.11 now.

> On Thu, Apr 25, 2013 at 09:13:44AM +0530, Viresh Kumar wrote:
>> +     workqueue.power_efficient
>> +                     Workqueues can be performance or power-oriented.
>> +                     Currently, most workqueues are bound to the CPU they
>                                    ^^^^
>                                    per-cpu would be better
>
>> +                     were created on. This gives good performance (due to
>> +                     cache effects) at the cost of potentially waking up
>> +                     otherwise idle cores just to process some work. To save
>> +                     power, we can allow the work to be rescheduled on a core
>> +                     that is already awake.
>
> The above description is confusing to me.  As have been discussed
> multiple times before, per-cpu workqueue in itself doesn't wake up the
> CPU physically.  The timer may but per-cpu workqueue doesn't.  It was
> confusing when this patchset was first posted and the above phrasing
> is still confusing.  What the patchset tries to do is preventing the
> scheduler from perceiving the CPU as active due to the activated
> worker thread pinned to that CPU, right?  The knob doesn't really do
> anything about waking up the processor in itself.  It just avoids
> feeding the scheduler with noisy activation events and allows it to
> allocate work item execution according to the scheduler's view of CPU
> active/idleness.  As the scheduler has longer / larger scope of
> overall CPU activities and means to regulate them, this leads to more
> power-efficient allocation of work item executions, right?  It'd be
> really great if the descriptions and the comment above the flag makes
> this abundantly clear because it's not something too apparent.

Whatever you wrote above confused me even more :)
This is what i had in my mind until now. Its not about per-cpu workqueue.

Lets take example of system_wq. It doesn't have WQ_UNBOUND flag set.
Now if we call queue_work_on() with cpu x and sytem_wq, then work
will execute on cpu x. If we call queue_work() then it will queue the work
on local cpu.

At this time local cpu may be busy or idle (Atleast according to scheduler).
We don't want a idle cpu (From schedulers perspective) to be used for
running this work's handler due to two reasons.
- idle cpu may be in WFI or deeper idle states and so we can avoid waking
  it up.
- We will make idle cpu look busy and so other kernel stuff may be scheduled
  on it now. But we could have kept it idle for a long time.

And what timer are you talking about? I am not talking about deffered work only,
but normal work too.

I might have wrongly phrased some part of my patch (maybe used workqueue
instead of work), will fix that up.

--
viresh
