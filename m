Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab3D2Qmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:42:49 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:34336 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab3D2Qmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:42:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130429161917.GB19814@mtj.dyndns.org>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
	<480f5d6da920e2f2b868f311228c81635727799e.1366803121.git.viresh.kumar@linaro.org>
	<CAP245DWtwguSp8ubid_KJnLSOqvCbmTXN+0Bg_MtDrUhBqve-Q@mail.gmail.com>
	<CAKohpokN_o-RUX6MDwqqfzu4NKRysG-hSzmB=MHV7Y0aDbztuA@mail.gmail.com>
	<20130424161208.GA16991@mtj.dyndns.org>
	<CAP245DUGuaSQbP4026N8kgn6-NqXFJWR3zKoYud=HQ_b+v5+Xw@mail.gmail.com>
	<CAKohpo=U5OqN7SM7XyOWv-WoUHOoJvGc6wcGH61+uikPK3novg@mail.gmail.com>
	<20130426191118.GD1433@mtj.dyndns.org>
	<CAKohpokJSwi24goSG=dTKkH0p+-YgsVURa_4giyU-u2TuK1bdA@mail.gmail.com>
	<20130429161917.GB19814@mtj.dyndns.org>
Date: Mon, 29 Apr 2013 22:12:46 +0530
Message-ID: <CAKohponFvoi9HqdzJO61i3vb6iJonAA-kDLgKp2iPDphz8qP5Q@mail.gmail.com>
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

On 29 April 2013 21:49, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Apr 29, 2013 at 12:06:28PM +0530, Viresh Kumar wrote:
> Yeap, !WQ_UNBOUND workqueues == per-cpu workqueues.

Sigh!! You were talking about thread per cpu here... Sorry for missing
it earlier :(

>> At this time local cpu may be busy or idle (Atleast according to scheduler).
>> We don't want a idle cpu (From schedulers perspective) to be used for
>> running this work's handler due to two reasons.
>> - idle cpu may be in WFI or deeper idle states and so we can avoid waking
>>   it up.
>
> I have no idea what WFI is but the physical CPU is already awake at
> that time.  It can't be idle - it's running queue_work().  It could be
> running in lower freq tho, which each code piece doesn't really have
> much control over.

Stupid point. WFI: Wait for interrupt (low power mode of cpu).

>> - We will make idle cpu look busy and so other kernel stuff may be scheduled
>>   on it now. But we could have kept it idle for a long time.
>
> Hmmm... yeah, about the same thing I wrote, it's not really about not
> waking up the CPU right now physically but avoiding forcing the
> scheduler scheduling a pinned task on an otherwise quiescent CPU.
> This effectively allows the scheduler to migrate such work items
> towards a CPU which the scheduler considers to be better (in power or
> whatever) leading to noticeable powersave.

Correct.

>> And what timer are you talking about? I am not talking about deffered work only,
>> but normal work too.
>
> Deferred work item == timer + work item.

Ya, i knew that :)

>> I might have wrongly phrased some part of my patch (maybe used workqueue
>> instead of work), will fix that up.
>
> I think it'd be necessary to distinguish the physical CPU being idle
> and the scheduler considers it to be idle (no task to schedule on it)
> and explain how increasing the latter can lead to powersave.  As it's
> currently written, it seemingly, to me anyway, suggests that the
> proposed change somehow avoids waking up actually idle CPU, which
> isn't the case as queue_work() *always* schedules on the local CPU.
> The local CPU can't be idle by definition.

Yes you are correct. I will fix it.
