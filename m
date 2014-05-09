Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbaEIK5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:57:37 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:39467 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580AbaEIK5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:57:33 -0400
MIME-Version: 1.0
In-Reply-To: <536CAF29.7070401@linux.vnet.ibm.com>
References: <cover.1399623699.git.viresh.kumar@linaro.org>
	<189ea71f724d00995a73e63c8ed9ff5b7857a69d.1399623699.git.viresh.kumar@linaro.org>
	<536CAF29.7070401@linux.vnet.ibm.com>
Date: Fri, 9 May 2014 16:27:33 +0530
Message-ID: <CAKohpomKj2Up9KibkXEL10rvd6E4fXdKghZAOhOCLt3TV82YLA@mail.gmail.com>
Subject: Re: [PATCH 1/2] hrtimer: reprogram event for expires=KTIME_MAX in hrtimer_force_reprogram()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 May 2014 16:04, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> On 05/09/2014 02:10 PM, Viresh Kumar wrote:

> I looked through the code in arm_arch_timer.c and I think the more
> fundamental problem lies in the timer handler there. Ideally even before
> calling the tick event handler the timer handler must be programming the
> tick device to fire at some __MAX__ time.

Ideally, the device should have stopped events as we programmed it in
ONESHOT mode. And should have waited for kernel to set it again..

But probably that device doesn't have a ONESHOT mode and is firing
again and again. Anyway the real problem I was trying to solve wasn't
infinite interrupts coming from event dev, but the first extra event that
we should have got rid of .. It just happened that we got more problems
on this particular board.

> Then irrespective of whether the core kernel deems it appropriate to
> program it or not, the max time by which a timer interrupt will get
> deferred is __MAX__ and one will not find anomalies like what you saw.

We will still get a interrupt once the counter overflows. And that is bad too.

> The reason this got exposed in NOHZ_FULL config is because in a normal
> NOHZ scenario when the cpu goes idle, and there are no pending timers in
> timer_list, even then tick_sched_timer gets cancelled. Precisely the
> scenario that you have described.

I haven't tried but it looks like this problem will exist there as well.. Who is
disabling the event device in that case when tick_sched timer goes off ?
The same question that is applicable in this case as well..

>    But we don't get continuous interrupts then because the first time we
> get an interrupt, we queue the tick_sched_timer and program the tick
> device to the time of its expiry and therefore *push* the time at which
> your tick device should fire further.

Probably not.. We don't get continuous interrupts because that's a special
case for my platform. But I am quite sure you would be getting one extra
interrupt after tick period, but because we didn't had anything to service
hrtimer_interrupt() routine just returned and CPU went into idle.

> Moreover from the core kernel's perspective also this does not look like
> the right thing to do. The core timer code cannot *shutdown* a clock
> device simply because there are no pending timers.

Why? To me it looks the right thing to do..

> Some arch may change
> their notion of *shutdown* to rendering the tick device unusable. Some
> archs may already do that.

There is only one definition of 'Shutdown' for me which every platform
must implement. Stop the event device to give any new events. that's it.

>    Hence I don't think we should take a drastic measure as to shutdown
> the clock device in case of no pending timers,

Sorry, I still don't agree :) .. We don't know when is the next time we need
to use a service, so free it. What will we get by pushing it to a long
long time ?
What would we loose if we SHUTDOWN it now ?

> My suggestion is as pointed above to set the tick device to a KTIME_MAX
> equivalent before calling the timer interrupt event handler.

This would still interrupt on overflow, so isn't the right idea..
Not currently as there are limitations, but later on with NO_HZ_FULL a core
should be allowed to go into infinite isolation, unless the application running
on it wants.. And this pushing to KTIME_MAX wouldn't work in that case..

Thanks for your review and the long chats we had about this problem since
yesterday on IRC..

--
viresh
