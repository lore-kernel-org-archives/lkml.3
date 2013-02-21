Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3BUJNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 04:13:22 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47680 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab3BUJNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 04:13:19 -0500
Message-ID: <5125E572.1090005@ti.com>
Date: Thu, 21 Feb 2013 14:44:26 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linaro-dev >> Lists Linaro-dev" <linaro-dev@lists.linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [resend] Timer broadcast question
References: <5123BE35.8070902@linaro.org> <alpine.LFD.2.02.1302191904560.22263@ionos> <5123C299.3080005@linaro.org> <5125BC7C.7080007@ti.com> <5125E256.7060208@linaro.org>
In-Reply-To: <5125E256.7060208@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 February 2013 02:31 PM, Daniel Lezcano wrote:
> On 02/21/2013 07:19 AM, Santosh Shilimkar wrote:
>> On Tuesday 19 February 2013 11:51 PM, Daniel Lezcano wrote:
>>> On 02/19/2013 07:10 PM, Thomas Gleixner wrote:
>>>> On Tue, 19 Feb 2013, Daniel Lezcano wrote:
>>>>> I am working on identifying the different wakeup sources from the
>>>>> interrupts and I have a question regarding the timer broadcast.
>>>>>
>>>>> The broadcast timer is setup to the next event and that will wake up
>>>>> any
>>>>> idle cpu belonging to the "broadcast cpumask", right ?
>>>>>
>>>>> The cpu which has been woken up will look for each cpu the next-event
>>>>> and send an IPI to wake it up.
>>>>>
>>>>> Although, it is possible the sender of this IPI may not be concerned by
>>>>> the timer expiration and has been woken up just for sending the IPI,
>>>>> right ?
>>>>
>>>> Correct.
>>>>
>>>>> If this is correct, is it possible to setup the timer irq affinity to a
>>>>> cpu which will be concerned by the timer expiration ? so we prevent an
>>>>> unnecessary wake up for a cpu.
>>>>
>>>> It is possible, but we never implemented it.
>>>>
>>>> If we go there, we want to make that conditional on a property flag,
>>>> because some interrupt controllers especially on x86 only allow to
>>>> move the affinity from interrupt context, which is pointless.
>>>
>>> Thanks Thomas for your quick answer. I will write a RFC patchset.
>>>
>> Last year I implemented the affinity hook for broad-cast code and
>> experimented with it. Since the system I was using was dual core,
>> it wasn't much beneficial and hence gave up later. I did remember
>> discussing the approach with few folks in the conference.
>
> I did a brief test with a similar patch on a ARM u8500 board. The timer
> is tied with CPU0 by default, setting the dynamic irq affinity reduce
> considerably the number of IPI. The difference with your patch is the
> affinity is set to one CPU, the first one which is supposed to be wake
> up by the timer expiration.
>
> This is easy to spot with a small program doing usleep wired on CPU1.
>
> We see CPU0 waking up to send an IPI to CPU1 and going to idle again.
>
> I don't know how that behaves with OMAP4 with this patch (which I guess
> it is the board you used), but the coupled idle state traces could be
> ambiguous if you relied on it to check the benefit of this patch.
>
Across OMAP4 and OMAP5 based devices, only the general purpose OMAP5
devices the approach was useful. Rest of the devices had constraints
of master CPU(CPU0) waking up first always which in turns means pining
the affinity to that CPU always which the current code already does.
That was also another reason I didn't persue it further.

> IMO, it is worth to implement such solution and perhaps we can extend it
> to optimize the package idle time with the generic power domain tied
> with the irq. Anyway, it is a random thought let's see that later :)
>
It is surely a good optimization especially for multi-core CPUIdle.

>> Patch in the end of the email (also attached) for generic broadcast
>> code. I didn't look at all corner case though. In arch code then
>> you need to setup "broadcast_affinity" hook which should be able
>> to get handle of the arch irqchip and call the respective affinity
>> handler. Just 3 lines function should do the trick.
>>
>> As Thomas said, effectiveness of such optimization solely depends
>> on how well the affinity (in low powers) supported by your IRQ chip.
>>
>> Hope this is helpful for you.
>
> Thanks a lot for your patch and your feedbacks.
>
Am glad that it was helpful.

Regards,
Santosh

