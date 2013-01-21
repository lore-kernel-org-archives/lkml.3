Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab3AUVO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:14:59 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:43216 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab3AUVO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:14:58 -0500
MIME-Version: 1.0
In-Reply-To: <50FDAC5F.4040605@linaro.org>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com>
 <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 21 Jan 2013 15:14:37 -0600
Message-ID: <CAKGA1b=D5CNikijoOAk5xP6TC-nB_gEGtS05ncrPR68sQTMrxw@mail.gmail.com>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
To: John Stultz <john.stultz@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 3:00 PM, John Stultz <john.stultz@linaro.org> wrote:
> On 01/21/2013 12:41 PM, Arnd Bergmann wrote:
>>
>> Right. It's pretty clear that the above logic does not work
>> with multiplatform.  Maybe we should just make ARCH_MULTIPLATFORM
>> select NO_HZ to make the question much less interesting.
>
> Although, even with NO_HZ, we still have some sense of HZ.

I wonder if you can confirm my understanding of this by the way? The
way I think this works is;

CONFIG_HZ on it's own defines the rate at which the kernel wakes up
from sleeping on the job, and checks for current or expired timer
events such that it can do things like schedule_work (as in
workqueues) or perform scheduler (as in processes/tasks) operations.

CONFIG_NO_HZ turns on logic which effectively only wakes up at a
*maximum* of CONFIG_HZ times per second, but otherwise will go to
sleep and stay that way if no events actually happened (so, we rely on
a timer interrupt popping up).

In this case, no matter whether CONFIG_HZ=1000 or CONFIG_HZ=250 (for
example) combined with CONFIG_NO_HZ and less than e.g. 250 things
happening per second will wake up "exactly" the same number of times?

CONFIG_HZ=1000 with CONFIG_NO_HZ would be an effective, all-round
solution here, then, and CONFIG_HZ=100 should be a reasonable default
(as it is anyway with an otherwise-unconfigured kernel on any other
platform) for !CONFIG_NO_HZ.

I have to admit, the only reason I noticed the above is because I was
reading one of CK's BFS logs and reading it makes it seem like the
above is the case, but I have no idea if he thinks BFS makes that the
case or if the current CFQ scheduler makes that the case, or if this
is simply.. the case.. (can you see this is kind of confusing to me as
this is basically not written anywhere except maybe an LWN article
from 2008 I read up on? :)

>> Regarding the defaults, I would suggest putting them into all the
>> defaults into the defconfig files and removing the other hardcoding
>> otherwise. Ben Dooks and Russell are probably the best to know
>> what triggered the 200 HZ for s3c24xx and for ebsa110. My guess
>> is that the other samsung ones are the result of cargo cult
>> programming.
>>
>> at91 and omap set the HZ value to something that is derived
>> from their hardware timer, but we have also forever had logic
>> to calculate the exact time when that does not match. This code
>> has very recently been moved into the new register_refined_jiffies()
>> function. John can probably tell is if this solves all the problems
>> for these platforms.
>
>
> Yea, as far as timekeeping is concerned, we shouldn't be HZ dependent (and
> the register_refined_jiffies is really only necessary if you're not
> expecting a proper clocksource to eventually be registered), assuming the
> hardware can do something close to the HZ value requested.
>
> So I'd probably want to hear about what history caused the specific 200 HZ
> selections, as I suspect there's actual hardware limitations there. So if
> you can not get actual timer ticks any faster then 200 HZ on that hardware,
> setting HZ higher could cause some jiffies related timer trouble (ie: if the
> kernel thinks HZ is 1000 but the hardware can only do 200, that's a
> different problem then if the hardware actually can only do 999.8 HZ). So
> things like timer-wheel timeouts may not happen when they should.
>
> I suspect the best approach for multi-arch in those cases may be to select
> HZ=100

As above, or "not select anything at all" since HZ=100 if you don't
touch anything, right?

If someone picks HZ=1000 and their platform can't support it, then
that's their own damn problem (don't touch things you don't
understand, right? ;)

> and use HRT to allow more modern systems to have finer-grained
> timers.

My question really has to be is CONFIG_SCHED_HRTICK useful, what
exactly is it going to do on ARM here since nobody can ever have
enabled it? Is it going to keel over and explode if nobody registers a
non-jiffies sched_clock (since the jiffies clock is technically
reporting itself as a ridiculously high resolution clocksource..)?

Or is this one of those things that if your platform doesn't have a
real high resolution timer, you shouldn't enable HRTIMERS and
therefore not enable SCHED_HRTICK as a result? That affects
ARCH_MULTIPLATFORM here. Is the solution as simple as
ARCH_MULTIPLATFORM compliant platforms kind of have to have a high
resolution timer? Documentation to that effect?

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
