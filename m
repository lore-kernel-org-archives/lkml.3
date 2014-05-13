Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaEMFB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 01:01:58 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55726 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaEMFB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 01:01:56 -0400
Message-ID: <5371A639.8020400@linux.vnet.ibm.com>
Date: Tue, 13 May 2014 10:27:29 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqQ==?= =?UTF-8?B?ZMOpcmljIFdlaXNiZWNrZXI=?= 
	<fweisbec@gmail.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Kevin Hilman <khilman@linaro.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] hrtimer: reprogram event for expires=KTIME_MAX in
 hrtimer_force_reprogram()
References: <cover.1399623699.git.viresh.kumar@linaro.org> <189ea71f724d00995a73e63c8ed9ff5b7857a69d.1399623699.git.viresh.kumar@linaro.org> <536CAF29.7070401@linux.vnet.ibm.com> <CAKohpomKj2Up9KibkXEL10rvd6E4fXdKghZAOhOCLt3TV82YLA@mail.gmail.com> <536E5108.2040109@linux.vnet.ibm.com> <CAKohpo=YDfxHV7gMq0hK6c0MagooBkBW08Tr-8k3kDySqrhqqA@mail.gmail.com>
In-Reply-To: <CAKohpo=YDfxHV7gMq0hK6c0MagooBkBW08Tr-8k3kDySqrhqqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051305-0928-0000-0000-000001D78501
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 11:23 AM, Viresh Kumar wrote:
> On 10 May 2014 21:47, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>> On 05/09/2014 04:27 PM, Viresh Kumar wrote:
>>> On 9 May 2014 16:04, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> 
>>> Ideally, the device should have stopped events as we programmed it in
>>> ONESHOT mode. And should have waited for kernel to set it again..
>>>
>>> But probably that device doesn't have a ONESHOT mode and is firing
>>> again and again. Anyway the real problem I was trying to solve wasn't
>>> infinite interrupts coming from event dev, but the first extra event that
>>> we should have got rid of .. It just happened that we got more problems
>>> on this particular board.
>>
>> So on a timer interrupt the tick device, irrespective of if it is in
>> ONESHOT mode or not, is in an expired state. Thus it will continue to
>> fire. What has ONESHOT mode got to do with this?
> 
> So, the arch specific timer handler must be clearing it I suppose and it
> shouldn't have fired again after 5 ms as it is not reprogrammed.
> 
> Probably that's an implementation specific stuff.. I have seen timers which
> have two modes, periodic: they fire continuously and oneshot: they get
> disabled after firing and have to be reprogrammed.

Yes that is implementation specific. From a core kernel code's
perspective, periodic mode is where the clock device will fire
periodically; it resets itself on every expiry. Oneshot mode is where
the clock device should explicitly be programmed to fire and can be
programmed for any point in time unlike periodic where the clock device
should be programmed only at periodic intervals. That is it. Beyond that
the core kernel cannot assume anything more.

Its possible that in oneshot mode some implementations disable the clock
device on expiry. Some might not. Hence the core code must make
decisions which *will not break either of these implementations*. For
example on PowerPC we do not disable the clock device. Instead we reset
the clock device to fire after 4seconds by default on expiry unless
there is some timer queued which sets the clock device to fire
appropriately.

The point is the implementations have their reasons for implementing
these modes and the core kernel code cannot be based on "Ideally the
device should have stopped" assumptions.

> 
>>>> The reason this got exposed in NOHZ_FULL config is because in a normal
>>>> NOHZ scenario when the cpu goes idle, and there are no pending timers in
>>>> timer_list, even then tick_sched_timer gets cancelled. Precisely the
>>>> scenario that you have described.
>>>
>>> I haven't tried but it looks like this problem will exist there as well.. Who is
>>> disabling the event device in that case when tick_sched timer goes off ?
>>> The same question that is applicable in this case as well..
>>>
>>>>    But we don't get continuous interrupts then because the first time we
>>>> get an interrupt, we queue the tick_sched_timer and program the tick
>>>> device to the time of its expiry and therefore *push* the time at which
>>>> your tick device should fire further.
>>>
>>> Probably not.. We don't get continuous interrupts because that's a special
>>> case for my platform. But I am quite sure you would be getting one extra
>>> interrupt after tick period, but because we didn't had anything to service
>>
>> Hmm? I didn't get this. Why would we?  We ensure that if there are no
>> pending timers in timer_list the tick_sched_timer is cancelled. We
>> cannot get spurious interrupts when there are no pending timers in NOHZ
>> mode.
> 
> Okay, there are no pending timers to fire and even we have disabled
> tick_sched_timer as well.. But the event dev isn't SHUTDOWN or reprogrammed.
> And so it must fire after tick interval? Exactly the same issue we are getting
> here in NO_HZ_FULL..

Not after tick interval. If there is a pending hrtimer, the event dev
will fire at its expiry time. If there are no pending hrtimers as well
as timers in timer_list, then its upto the arch to decide how it will
handle "no pending timer events in the future". It can set the clock
device to expire at some far off time for an example.

> 
> And the worst part is we aren't getting these interrupts in traces as well.
> Somebody probably need to revisit the trace_irq_handler_entry part as well
> to catch such problems.
> 
>> Hmm yeah looking at the problem that you are trying to solve, that being
>> completely disabling timer interrupts on cpus that are running just one
>> process, it appears to me that setting the tick device in SHUTDOWN mode
>> is the only way to do so. And you are right. We use SHUTDOWN mode to
>> imply that the device can be switched off. Its upto the arch to react to
>> it appropriately.
> 
> So, from the mail where tglx blasted me off, we have a better solution to
> implement now :)
> 
>> My concern is on powerpc today when we set the device to SHUTDOWN mode
>> we set the decrementer to a MAX value. Which means we will get
>> interrupts only spaced out more widely in time. But on NOHZ_FULL mode if
>> you are looking at completely disabling tick_sched_timer as long as a
>> single process runs then we might need to change the semantics here.
> 
> Lets see if we can do some nice stuff with ONESHOT_STOPPED state..

Indeed. That is a very clean way to getting this done. We were trying to
extrapolate the existing code to solve this problem. That was bound to
snap :)

Regards
Preeti U Murthy
> 

