Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab3IMKyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 06:54:31 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:45277 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab3IMKy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 06:54:27 -0400
Message-ID: <5232EB72.9050904@linux.vnet.ibm.com>
Date: Fri, 13 Sep 2013 16:09:46 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Preeti Murthy <preeti.lkml@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Stephen Boyd <sboyd@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] tick: broadcast: Deny per-cpu clockevents from being
 broadcast sources
References: <1379004640-15117-1-git-send-email-soren.brinkmann@xilinx.com> <1379004640-15117-2-git-send-email-soren.brinkmann@xilinx.com> <alpine.DEB.2.02.1309122224420.4089@ionos.tec.linutronix.de> <5232CC15.8090208@linaro.org> <CAM4v1pPQwBfQ3V6M2VGsc-Fh+VhLkQE2JZeoVc=_3kniODNEhA@mail.gmail.com>
In-Reply-To: <CAM4v1pPQwBfQ3V6M2VGsc-Fh+VhLkQE2JZeoVc=_3kniODNEhA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091310-1618-0000-0000-0000049F4CAF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Soren,

On 09/13/2013 03:50 PM, Preeti Murthy wrote:
> Hi,
> 
> So the patch that Daniel points out http://lwn.net/Articles/566270/ ,
> enables broadcast functionality
> without using an external global clock device. It uses one of the per cpu
> clock devices to enable the broadcast functionality.
> 
> The way it achieves this is by creating a pseudo clock device and
> associating it with one of the cpus clock device and
> by having a hrtimer queued on the same cpu. This pseudo clock device acts
> as the broadcast device, and the
>  per cpu clock device that it is associated with acts as the broadcast
> source.
> 
> The disadvantages that Soren mentions in having a per cpu clock device as
> the broadcast source can be overcome
> by following the approach proposed in this patch n the way described below:
> 
> 1. What if the cpu, whose clock device is the broadcast source goes offline?
> 
> The solution that the above patch proposes is associate the pseudo clock
> device with another cpu and move the hrtimer
> whose function is explained in the next point to another cpu. The broadcast
> functionality continues to remain active transparently.
> 
> 2. The cpu that requires broadcast functionality is different from the cpu
> whose clock device is the broadcast source.
> So how will the former cpu program/control the clock device of the latter
> cpu?
> 
> The above patch queues a hrtimer on the cpu whose clock device is the
> broadcast source, which expires at
> max(tick_broadcast_period,  dev->next_event), where tick_broadcast_period
> is what we define and dev is the
> pseudo device whose next event is set by the broadcast framework.
> 
> On expiry of this hrtimer, do broadcast handling and reprogram the hrtimer
> with same as above,
> max(tick_broadcast_period,  dev->next_event).
> 
> This ensures that a cpu that requires broadcast function to be activated
> need not program the broadcast source,
> which also happens to be a per cpu clock device. The hrtimer queued on the
> cpu whose clock device is the
> broadcast source takes care of when to do broadcast handling.
> tick_broadcast_period ensures that we do
> not miss wakeups. This is introduced to overcome the constraint of a cpu
> not being able to program the clock
> device of another cpu.
> 
> Soren, do let me know if the above approach described in the patch has not
> addressed any of the challenges
> that you see with having a  per cpu clock device as the broadcast source.
> 
> Regards
> Preeti U Murthy
> 
> 
> On Fri, Sep 13, 2013 at 1:55 PM, Daniel Lezcano
> <daniel.lezcano@linaro.org>wrote:
> 
>> On 09/12/2013 10:30 PM, Thomas Gleixner wrote:
>>> On Thu, 12 Sep 2013, Soren Brinkmann wrote:
>>>> From: Stephen Boyd <sboyd@codeaurora.org>
>>>>
>>>> On most ARM systems the per-cpu clockevents are truly per-cpu in
>>>> the sense that they can't be controlled on any other CPU besides
>>>> the CPU that they interrupt. If one of these clockevents were to
>>>> become a broadcast source we will run into a lot of trouble
>>>> because the broadcast source is enabled on the first CPU to go
>>>> into deep idle (if that CPU suffers from FEAT_C3_STOP) and that
>>>> could be a different CPU than what the clockevent is interrupting
>>>> (or even worse the CPU that the clockevent interrupts could be
>>>> offline).
>>>>
>>>> Theoretically it's possible to support per-cpu clockevents as the
>>>> broadcast source but so far we haven't needed this and supporting
>>>> it is rather complicated. Let's just deny the possibility for now
>>>> until this becomes a reality (let's hope it never does!).
>>>
>>> Well, we can't do it this way. There are globally accessible clock
>>> event devices which deliver only to cpu0. So the mask check might be
>>> causing failure here.
>>>
>>> Just add a feature flag CLOCK_EVT_FEAT_PERCPU to the clock event
>>> device and check for it.
>>
>> It sounds probably more understandable than dealing with the cpumasks.
>>
>> I am wondering if this is semantically opposed to
>> http://lwn.net/Articles/566270/ ?
>>
>> [PATCH V3 0/6] cpuidle/ppc: Enable broadcast support for deep idle states
>>
>>   -- Daniel

So the point I am trying to make is that the fix that you have proposed
on this thread is valid. It is difficult to ensure that a per cpu clock
device doubles up as the broadcast source without significant code
changes to the current broadcast code and the timer code.

But the patch [PATCH V3 0/6] cpuidle/ppc: Enable broadcast support for
deep idle states, attempts to overcome the disadvantage on certain
architectures of not having an external clock device to perform
broadcast *without* significant code changes in broadcast or timer.

This patch does not conflict with what you are proposing in this thread
of having a feature flag CLOCK_EVT_FEAT_PERCPU, since the pseudo clock
device that the patch introduces will not have this flag set anyway.

So ideally architectures, without having a planned infrastructure in
them cannot nominate their per cpu clock device as the broadcast source.
And if they do have some infrastructure to support a per cpu clock
device as broadcast source, they should ensure that the device passes
your test as is proposed in this patch. So your fix is valid IMHO. That
said it is still possible to manage without an external clock device for
performing broadcast.

Regards
Preeti U Murthy

