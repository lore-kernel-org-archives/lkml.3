Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab3AUWgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:36:20 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:52954 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab3AUWgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:36:16 -0500
Message-ID: <50FDC2DD.7090406@linaro.org>
Date: Mon, 21 Jan 2013 14:36:13 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matt Sealey <matt@genesi-usa.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org> <CAKGA1b=D5CNikijoOAk5xP6TC-nB_gEGtS05ncrPR68sQTMrxw@mail.gmail.com>
In-Reply-To: <CAKGA1b=D5CNikijoOAk5xP6TC-nB_gEGtS05ncrPR68sQTMrxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 01:14 PM, Matt Sealey wrote:
> On Mon, Jan 21, 2013 at 3:00 PM, John Stultz <john.stultz@linaro.org> wrote:
>> On 01/21/2013 12:41 PM, Arnd Bergmann wrote:
>>> Right. It's pretty clear that the above logic does not work
>>> with multiplatform.  Maybe we should just make ARCH_MULTIPLATFORM
>>> select NO_HZ to make the question much less interesting.
>> Although, even with NO_HZ, we still have some sense of HZ.
> I wonder if you can confirm my understanding of this by the way? The
> way I think this works is;
>
> CONFIG_HZ on it's own defines the rate at which the kernel wakes up
> from sleeping on the job, and checks for current or expired timer
> events such that it can do things like schedule_work (as in
> workqueues) or perform scheduler (as in processes/tasks) operations.

CONFIG_HZ defines the length of a jiffy.

In the absence of NOHZ and HRT, HZ defines how frequently the 
timer/scheduler tick will fire.

> CONFIG_NO_HZ turns on logic which effectively only wakes up at a
> *maximum* of CONFIG_HZ times per second, but otherwise will go to
> sleep and stay that way if no events actually happened (so, we rely on
> a timer interrupt popping up).

NOHZ adds logic which basically allows us to skip ticks if the cpu is idle.

And HRT adds logic which allows us to fire timers more frequently then HZ.

> In this case, no matter whether CONFIG_HZ=1000 or CONFIG_HZ=250 (for
> example) combined with CONFIG_NO_HZ and less than e.g. 250 things
> happening per second will wake up "exactly" the same number of times?
Ideally, if both systems are completely idle, they may see similar 
number of actual interrupts.

But when the cpus are running processes, the HZ=1000 system will see 
more frequent interrupts, since the timer/scheduler interrupt will jump 
in 4 times more frequently.


> CONFIG_HZ=1000 with CONFIG_NO_HZ would be an effective, all-round
> solution here, then, and CONFIG_HZ=100 should be a reasonable default
> (as it is anyway with an otherwise-unconfigured kernel on any other
> platform) for !CONFIG_NO_HZ.

Eeehhh... I'm not sure this is follows.

>>
>> Yea, as far as timekeeping is concerned, we shouldn't be HZ dependent (and
>> the register_refined_jiffies is really only necessary if you're not
>> expecting a proper clocksource to eventually be registered), assuming the
>> hardware can do something close to the HZ value requested.
>>
>> So I'd probably want to hear about what history caused the specific 200 HZ
>> selections, as I suspect there's actual hardware limitations there. So if
>> you can not get actual timer ticks any faster then 200 HZ on that hardware,
>> setting HZ higher could cause some jiffies related timer trouble (ie: if the
>> kernel thinks HZ is 1000 but the hardware can only do 200, that's a
>> different problem then if the hardware actually can only do 999.8 HZ). So
>> things like timer-wheel timeouts may not happen when they should.
>>
>> I suspect the best approach for multi-arch in those cases may be to select
>> HZ=100
> As above, or "not select anything at all" since HZ=100 if you don't
> touch anything, right?

Well, Russell brought up a case that doesn't handle this. If a system 
*can't* do HZ=100, but can do HZ=200.

Though there are hacks, of course, that might get around this (skip 
every other interrupt at 200HZ).

> If someone picks HZ=1000 and their platform can't support it, then
> that's their own damn problem (don't touch things you don't
> understand, right? ;)
Well, ideally with kconfig we try to add proper dependencies so 
impossible options aren't left to the user.
HZ is a common enough knob to turn on most systems, I don't know if 
leaving the user rope to hang himself is a great idea.

>
>> and use HRT to allow more modern systems to have finer-grained
>> timers.
> My question really has to be is CONFIG_SCHED_HRTICK useful, what
> exactly is it going to do on ARM here since nobody can ever have
> enabled it? Is it going to keel over and explode if nobody registers a
> non-jiffies sched_clock (since the jiffies clock is technically
> reporting itself as a ridiculously high resolution clocksource..)?
??? Not following this at all.  jiffies is the *MOST* coarse resolution 
clocksource there is (at least that I'm aware of.. I recall someone 
wanting to do a 60Hz clocksource, but I don't think that ever happened).

> Or is this one of those things that if your platform doesn't have a
> real high resolution timer, you shouldn't enable HRTIMERS and
> therefore not enable SCHED_HRTICK as a result? That affects
> ARCH_MULTIPLATFORM here. Is the solution as simple as
> ARCH_MULTIPLATFORM compliant platforms kind of have to have a high
> resolution timer? Documentation to that effect?

SO HRITMERS was designed to be be build time enabled, while still giving 
you a functioning system if it was booted on a system that didn't 
support clockevents.  We boot with standard HZ, and only switch over to 
HRT mode if we have a proper clocksource and clockevent driver.

However, HRTIMERS or NOHZ doesn't fix the case of having a system boot 
with HZ=1000 or HZ=100 if the system can *only* do HZ=200.

thanks
-john



