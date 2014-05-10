Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaEJQVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 12:21:40 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41544 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaEJQVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 12:21:38 -0400
Message-ID: <536E5108.2040109@linux.vnet.ibm.com>
Date: Sat, 10 May 2014 21:47:12 +0530
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
References: <cover.1399623699.git.viresh.kumar@linaro.org> <189ea71f724d00995a73e63c8ed9ff5b7857a69d.1399623699.git.viresh.kumar@linaro.org> <536CAF29.7070401@linux.vnet.ibm.com> <CAKohpomKj2Up9KibkXEL10rvd6E4fXdKghZAOhOCLt3TV82YLA@mail.gmail.com>
In-Reply-To: <CAKohpomKj2Up9KibkXEL10rvd6E4fXdKghZAOhOCLt3TV82YLA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051016-1542-0000-0000-000001B4ECCD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 04:27 PM, Viresh Kumar wrote:
> On 9 May 2014 16:04, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>> On 05/09/2014 02:10 PM, Viresh Kumar wrote:
> 
>> I looked through the code in arm_arch_timer.c and I think the more
>> fundamental problem lies in the timer handler there. Ideally even before
>> calling the tick event handler the timer handler must be programming the
>> tick device to fire at some __MAX__ time.
> 
> Ideally, the device should have stopped events as we programmed it in
> ONESHOT mode. And should have waited for kernel to set it again..
> 
> But probably that device doesn't have a ONESHOT mode and is firing
> again and again. Anyway the real problem I was trying to solve wasn't
> infinite interrupts coming from event dev, but the first extra event that
> we should have got rid of .. It just happened that we got more problems
> on this particular board.

So on a timer interrupt the tick device, irrespective of if it is in
ONESHOT mode or not, is in an expired state. Thus it will continue to
fire. What has ONESHOT mode got to do with this?

> 
>> Then irrespective of whether the core kernel deems it appropriate to
>> program it or not, the max time by which a timer interrupt will get
>> deferred is __MAX__ and one will not find anomalies like what you saw.
> 
> We will still get a interrupt once the counter overflows. And that is bad too.

Hmm true.
> 
>> The reason this got exposed in NOHZ_FULL config is because in a normal
>> NOHZ scenario when the cpu goes idle, and there are no pending timers in
>> timer_list, even then tick_sched_timer gets cancelled. Precisely the
>> scenario that you have described.
> 
> I haven't tried but it looks like this problem will exist there as well.. Who is
> disabling the event device in that case when tick_sched timer goes off ?
> The same question that is applicable in this case as well..
> 
>>    But we don't get continuous interrupts then because the first time we
>> get an interrupt, we queue the tick_sched_timer and program the tick
>> device to the time of its expiry and therefore *push* the time at which
>> your tick device should fire further.
> 
> Probably not.. We don't get continuous interrupts because that's a special
> case for my platform. But I am quite sure you would be getting one extra
> interrupt after tick period, but because we didn't had anything to service

Hmm? I didn't get this. Why would we?  We ensure that if there are no
pending timers in timer_list the tick_sched_timer is cancelled. We
cannot get spurious interrupts when there are no pending timers in NOHZ
mode.

> hrtimer_interrupt() routine just returned and CPU went into idle.
> 
>> Moreover from the core kernel's perspective also this does not look like
>> the right thing to do. The core timer code cannot *shutdown* a clock
>> device simply because there are no pending timers.
> 
> Why? To me it looks the right thing to do..
> 
>> Some arch may change
>> their notion of *shutdown* to rendering the tick device unusable. Some
>> archs may already do that.
> 
> There is only one definition of 'Shutdown' for me which every platform
> must implement. Stop the event device to give any new events. that's it.
> 
>>    Hence I don't think we should take a drastic measure as to shutdown
>> the clock device in case of no pending timers,
> 
> Sorry, I still don't agree :) .. We don't know when is the next time we need
> to use a service, so free it. What will we get by pushing it to a long
> long time ?
> What would we loose if we SHUTDOWN it now ?
> 
>> My suggestion is as pointed above to set the tick device to a KTIME_MAX
>> equivalent before calling the timer interrupt event handler.
> 
> This would still interrupt on overflow, so isn't the right idea..
> Not currently as there are limitations, but later on with NO_HZ_FULL a core
> should be allowed to go into infinite isolation, unless the application running
> on it wants.. And this pushing to KTIME_MAX wouldn't work in that case..

Hmm yeah looking at the problem that you are trying to solve, that being
completely disabling timer interrupts on cpus that are running just one
process, it appears to me that setting the tick device in SHUTDOWN mode
is the only way to do so. And you are right. We use SHUTDOWN mode to
imply that the device can be switched off. Its upto the arch to react to
it appropriately.

My concern is on powerpc today when we set the device to SHUTDOWN mode
we set the decrementer to a MAX value. Which means we will get
interrupts only spaced out more widely in time. But on NOHZ_FULL mode if
you are looking at completely disabling tick_sched_timer as long as a
single process runs then we might need to change the semantics here.

Regards
Preeti U Murthy
> 
> Thanks for your review and the long chats we had about this problem since
> yesterday on IRC..
> 
> --
> viresh
> 

