Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964849Ab3DIOwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:52:49 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:48945 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936814Ab3DIOwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:52:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponv-AKZzM98Ujeek4oXQx+8ba+sMgMbM9eV8PgQR38kZw@mail.gmail.com>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	<d12b25130db5a8b645929eb93d1cf4ddc2d68826.1352196505.git.viresh.kumar@linaro.org>
	<1354024039.6276.72.camel@gandalf.local.home>
	<CAKohponv-AKZzM98Ujeek4oXQx+8ba+sMgMbM9eV8PgQR38kZw@mail.gmail.com>
Date: Tue, 9 Apr 2013 20:22:45 +0530
Message-ID: <CAKohpo=St0z0L9ei248s3KL_DqZtewQ50o7d=BTdwLFcpM+x3w@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 4/4] timer: Migrate running timer
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de, Steven Rostedt <rostedt@goodmis.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tj@kernel.org, mingo@redhat.com,
        peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, john stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Steven replied to a personal Ping!!, including everybody again]

On 9 April 2013 19:25, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2013-04-09 at 14:05 +0530, Viresh Kumar wrote:
>> Ping!!
>>
>
> Remind me again. What problem are you trying to solve?

I was trying to migrate a running timer which arms itself, so that we don't
keep a cpu busy just for servicing this timer.

>> On 20 March 2013 20:43, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> >
>> > Hi Steven/Thomas,
>> >
>> > I came back to this patch after completing some other stuff and posting
>> > wq part of this patchset separately.
>> >
>> > I got your point and understand how this would fail.
>> >
>> > @Thomas: I need your opinion first. Do you like this concept of migrating
>> > running timer or not? Or you see some basic problem with this concept?
>
> I'll let Thomas answer this, but to me, this sounds really racy.

Sure.

>> > If no (i.e. i can go ahead with another version), then i have some solution to
>> > fix earlier problems reported by Steven:
>> >
>> > The problem lies with del_timer_sync() which just checks
>> > base->running_timer != timer to check if timer is currently running or not.
>> >
>> > What if we add another variable in struct timer_list, that will store if we are
>> > running timer callback or not. And so, before we call callback in timer core,
>> > we will set this variable and will reset it after finishing callback.
>> >
>> > del_timer_sync() will have something like:
>> >
>> > if (base->running_timer != timer)
>> >     remove timer and return;
>
> For example, this didn't fix the issue. You removed the timer when it
> was still running, because base->running_timer did not equal timer.

You are correct and i was stupid. I wanted to write this instead:

del_timer_sync() will have something like:

if (base->running_timer != timer)
    if (timer->running_callback)
        go back to its loop...
    else
        remove timer and return;

i.e. if we aren't running on our base cpu, just check if our callback is
executing somewhere else due to migration.
