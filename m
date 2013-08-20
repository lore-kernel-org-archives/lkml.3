Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751027Ab3HTJwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:52:13 -0400
Received: from outgoing.email.vodafone.de ([139.7.28.128]:52448 "EHLO
	outgoing.email.vodafone.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822Ab3HTJwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:52:11 -0400
X-Authentication-Info: Sender authenticated as deathsimple@vodafone.de (using CRAM-MD5)
Message-ID: <52133C2A.2090200@vodafone.de>
Date: Tue, 20 Aug 2013 11:51:38 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: dri-devel@lists.freedesktop.org, linux-arch@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org,
        Alex Deucher <alexander.deucher@amd.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] drm/radeon: rework to new fence interface
References: <20130815124308.14812.58197.stgit@patser> <5211F0C5.2040705@canonical.com> <5212112C.70808@vodafone.de> <52127411.2010106@canonical.com> <52132AE0.4010702@vodafone.de> <521338A9.4040206@canonical.com>
In-Reply-To: <521338A9.4040206@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.08.2013 11:36, schrieb Maarten Lankhorst:
[SNIP]

>>>>> [SNIP]
>>>>> +/**
>>>>> + * radeon_fence_enable_signaling - enable signalling on fence
>>>>> + * @fence: fence
>>>>> + *
>>>>> + * This function is called with fence_queue lock held, and adds a callback
>>>>> + * to fence_queue that checks if this fence is signaled, and if so it
>>>>> + * signals the fence and removes itself.
>>>>> + */
>>>>> +static bool radeon_fence_enable_signaling(struct fence *f)
>>>>> +{
>>>>> +    struct radeon_fence *fence = to_radeon_fence(f);
>>>>> +
>>>>> +    if (atomic64_read(&fence->rdev->fence_drv[fence->ring].last_seq) >= fence->seq ||
>>>>> +        !fence->rdev->ddev->irq_enabled)
>>>>> +        return false;
>>>>> +
>>>> Do I get that right that you rely on IRQs to be enabled and working here? Cause that would be a quite bad idea from the conceptual side.
>>> For cross-device synchronization it would be nice to have working irqs, it allows signalling fences faster,
>>> and it allows for callbacks on completion to be called. For internal usage it's no more required than it was before.
>> That's a big NAK.
>>
>> The fence processing is actually very fine tuned to avoid IRQs and as far as I can see you just leave them enabled by decrementing the atomic from IRQ context. Additional to that we need allot of special handling in case of a hardware lockup here, which isn't done if you abuse the fence interface like this.
> I think it's not needed to leave the irq enabled, it's a leftover from when I was debugging the mac and no interrupt occurred at all.
>
>> Also your approach of leaking the IRQ context outside of the driver is a very bad idea from the conceptual side. Please don't modify the fence interface at all and instead use the wait functions already exposed by radeon_fence.c. If you need some kind of signaling mechanism then wait inside a workqueue instead.
> The fence takes up the role of a single shot workqueue here. Manually resetting the counter and calling wake_up_all would end up waking all active fences, there's no special handling needed inside radeon for this.

Yeah that's actually the point here, you NEED to activate ALL fences, 
otherwise the fence handling inside the driver won't work.

> The fence api does provide a synchronous wait function, but this causes a stall of whomever waits on it.

Which is perfectly fine. What actually is the use case of not stalling a 
process who wants to wait for something?

> When I was testing this with intel I used the fence callback to poke a register in i915, this allowed it to not block until it hits the wait op in the command stream, and even then only if the callback was not called first.
>
> It's documented that the callbacks can be called from any context and will be called with irqs disabled, so nothing scary should be done. The kernel provides enough debug mechanisms to find any violators.
> PROVE_LOCKING and DEBUG_ATOMIC_SLEEP for example.

No thanks, we even abandoned that concept internal in the driver. Please 
use the blocking wait functions instead.

Christian.
