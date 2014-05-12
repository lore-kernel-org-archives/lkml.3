Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaELFx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 01:53:57 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:51361 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaELFx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 01:53:56 -0400
MIME-Version: 1.0
In-Reply-To: <536E5108.2040109@linux.vnet.ibm.com>
References: <cover.1399623699.git.viresh.kumar@linaro.org>
	<189ea71f724d00995a73e63c8ed9ff5b7857a69d.1399623699.git.viresh.kumar@linaro.org>
	<536CAF29.7070401@linux.vnet.ibm.com>
	<CAKohpomKj2Up9KibkXEL10rvd6E4fXdKghZAOhOCLt3TV82YLA@mail.gmail.com>
	<536E5108.2040109@linux.vnet.ibm.com>
Date: Mon, 12 May 2014 11:23:55 +0530
Message-ID: <CAKohpo=YDfxHV7gMq0hK6c0MagooBkBW08Tr-8k3kDySqrhqqA@mail.gmail.com>
Subject: Re: [PATCH 1/2] hrtimer: reprogram event for expires=KTIME_MAX in hrtimer_force_reprogram()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Kevin Hilman <khilman@linaro.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 May 2014 21:47, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> On 05/09/2014 04:27 PM, Viresh Kumar wrote:
>> On 9 May 2014 16:04, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:

>> Ideally, the device should have stopped events as we programmed it in
>> ONESHOT mode. And should have waited for kernel to set it again..
>>
>> But probably that device doesn't have a ONESHOT mode and is firing
>> again and again. Anyway the real problem I was trying to solve wasn't
>> infinite interrupts coming from event dev, but the first extra event that
>> we should have got rid of .. It just happened that we got more problems
>> on this particular board.
>
> So on a timer interrupt the tick device, irrespective of if it is in
> ONESHOT mode or not, is in an expired state. Thus it will continue to
> fire. What has ONESHOT mode got to do with this?

So, the arch specific timer handler must be clearing it I suppose and it
shouldn't have fired again after 5 ms as it is not reprogrammed.

Probably that's an implementation specific stuff.. I have seen timers which
have two modes, periodic: they fire continuously and oneshot: they get
disabled after firing and have to be reprogrammed.

>>> The reason this got exposed in NOHZ_FULL config is because in a normal
>>> NOHZ scenario when the cpu goes idle, and there are no pending timers in
>>> timer_list, even then tick_sched_timer gets cancelled. Precisely the
>>> scenario that you have described.
>>
>> I haven't tried but it looks like this problem will exist there as well.. Who is
>> disabling the event device in that case when tick_sched timer goes off ?
>> The same question that is applicable in this case as well..
>>
>>>    But we don't get continuous interrupts then because the first time we
>>> get an interrupt, we queue the tick_sched_timer and program the tick
>>> device to the time of its expiry and therefore *push* the time at which
>>> your tick device should fire further.
>>
>> Probably not.. We don't get continuous interrupts because that's a special
>> case for my platform. But I am quite sure you would be getting one extra
>> interrupt after tick period, but because we didn't had anything to service
>
> Hmm? I didn't get this. Why would we?  We ensure that if there are no
> pending timers in timer_list the tick_sched_timer is cancelled. We
> cannot get spurious interrupts when there are no pending timers in NOHZ
> mode.

Okay, there are no pending timers to fire and even we have disabled
tick_sched_timer as well.. But the event dev isn't SHUTDOWN or reprogrammed.
And so it must fire after tick interval? Exactly the same issue we are getting
here in NO_HZ_FULL..

And the worst part is we aren't getting these interrupts in traces as well.
Somebody probably need to revisit the trace_irq_handler_entry part as well
to catch such problems.

> Hmm yeah looking at the problem that you are trying to solve, that being
> completely disabling timer interrupts on cpus that are running just one
> process, it appears to me that setting the tick device in SHUTDOWN mode
> is the only way to do so. And you are right. We use SHUTDOWN mode to
> imply that the device can be switched off. Its upto the arch to react to
> it appropriately.

So, from the mail where tglx blasted me off, we have a better solution to
implement now :)

> My concern is on powerpc today when we set the device to SHUTDOWN mode
> we set the decrementer to a MAX value. Which means we will get
> interrupts only spaced out more widely in time. But on NOHZ_FULL mode if
> you are looking at completely disabling tick_sched_timer as long as a
> single process runs then we might need to change the semantics here.

Lets see if we can do some nice stuff with ONESHOT_STOPPED state..
