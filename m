Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaESIAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:00:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33105 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaESIAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:00:09 -0400
Message-ID: <5379BA04.8000901@canonical.com>
Date: Mon, 19 May 2014 10:00:04 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        airlied@linux.ie
CC: nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v1 08/16] drm/radeon: use common fence implementation
 for fences
References: <20140514145134.21163.32350.stgit@patser> <20140514145809.21163.64947.stgit@patser> <53738BCC.2070809@vodafone.de> <5374131D.4010906@canonical.com> <53748702.6070606@vodafone.de> <53748AFA.8010109@canonical.com> <53748BFD.1050608@vodafone.de> <5374BB4A.6070102@canonical.com> <5374BEE2.4060608@vodafone.de> <5374CC9A.9090905@canonical.com> <5374E1B5.2020408@vodafone.de> <5374E410.1080203@canonical.com> <5374E792.4070607@vodafone.de>
In-Reply-To: <5374E792.4070607@vodafone.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 15-05-14 18:13, Christian König schreef:
> Am 15.05.2014 17:58, schrieb Maarten Lankhorst:
>> op 15-05-14 17:48, Christian König schreef:
>>> Am 15.05.2014 16:18, schrieb Maarten Lankhorst:
>>>> op 15-05-14 15:19, Christian König schreef:
>>>>> Am 15.05.2014 15:04, schrieb Maarten Lankhorst:
>>>>>> op 15-05-14 11:42, Christian König schreef:
>>>>>>> Am 15.05.2014 11:38, schrieb Maarten Lankhorst:
>>>>>>>> op 15-05-14 11:21, Christian König schreef:
>>>>>>>>> Am 15.05.2014 03:06, schrieb Maarten Lankhorst:
>>>>>>>>>> op 14-05-14 17:29, Christian König schreef:
>>>>>>>>>>>> +    /* did fence get signaled after we enabled the sw irq? */
>>>>>>>>>>>> +    if (atomic64_read(&fence->rdev->fence_drv[fence->ring].last_seq) >= fence->seq) {
>>>>>>>>>>>> + radeon_irq_kms_sw_irq_put(fence->rdev, fence->ring);
>>>>>>>>>>>> +        return false;
>>>>>>>>>>>> +    }
>>>>>>>>>>>> +
>>>>>>>>>>>> +    fence->fence_wake.flags = 0;
>>>>>>>>>>>> +    fence->fence_wake.private = NULL;
>>>>>>>>>>>> +    fence->fence_wake.func = radeon_fence_check_signaled;
>>>>>>>>>>>> + __add_wait_queue(&fence->rdev->fence_queue, &fence->fence_wake);
>>>>>>>>>>>> +    fence_get(f);
>>>>>>>>>>> That looks like a race condition to me. The fence needs to be added to the wait queue before the check, not after.
>>>>>>>>>>>
>>>>>>>>>>> Apart from that the whole approach looks like a really bad idea to me. How for example is lockup detection supposed to happen with this? 
>>>>>>>>>> It's not a race condition because fence_queue.lock is held when this function is called.
>>>>>>>>> Ah, I see. That's also the reason why you moved the wake_up_all out of the processing function.
>>>>>>>> Correct. :-)
>>>>>>>>>> Lockup's a bit of a weird problem, the changes wouldn't allow core ttm code to handle the lockup any more,
>>>>>>>>>> but any driver specific wait code would still handle this. I did this by design, because in future patches the wait
>>>>>>>>>> function may be called from outside of the radeon driver. The official wait function takes a timeout parameter,
>>>>>>>>>> so lockups wouldn't be fatal if the timeout is set to something like 30*HZ for example, it would still return
>>>>>>>>>> and report that the function timed out.
>>>>>>>>> Timeouts help with the detection of the lockup, but not at all with the handling of them.
>>>>>>>>>
>>>>>>>>> What we essentially need is a wait callback into the driver that is called in non atomic context without any locks held.
>>>>>>>>>
>>>>>>>>> This way we can block for the fence to become signaled with a timeout and can then also initiate the reset handling if necessary.
>>>>>>>>>
>>>>>>>>> The way you designed the interface now means that the driver never gets a chance to wait for the hardware to become idle and so never has the opportunity to the reset the whole thing.
>>>>>>>> You could set up a hangcheck timer like intel does, and end up with a reliable hangcheck detection that doesn't depend on cpu waits. :-) Or override the default wait function and restore the old behavior.
>>>>>>>
>>>>>>> Overriding the default wait function sounds better, please implement it this way.
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Christian. 
>>>>>>
>>>>>> Does this modification look sane?
>>>>> Adding the timeout is on my todo list for quite some time as well, so this part makes sense.
>>>>>
>>>>>> +static long __radeon_fence_wait(struct fence *f, bool intr, long timeout)
>>>>>> +{
>>>>>> +    struct radeon_fence *fence = to_radeon_fence(f);
>>>>>> +    u64 target_seq[RADEON_NUM_RINGS] = {};
>>>>>> +
>>>>>> +    target_seq[fence->ring] = fence->seq;
>>>>>> +    return radeon_fence_wait_seq_timeout(fence->rdev, target_seq, intr, timeout);
>>>>>> +}
>>>>> When this call is comming from outside the radeon driver you need to lock rdev->exclusive_lock here to make sure not to interfere with a possible reset.
>>>> Ah thanks, I'll add that.
>>>>
>>>>>>      .get_timeline_name = radeon_fence_get_timeline_name,
>>>>>>      .enable_signaling = radeon_fence_enable_signaling,
>>>>>>      .signaled = __radeon_fence_signaled,
>>>>> Do we still need those callback when we implemented the wait callback?
>>>> .get_timeline_name is used for debugging (trace events).
>>>> .signaled is the non-blocking call to check if the fence is signaled or not.
>>>> .enable_signaling is used for adding callbacks upon fence completion, the default 'fence_default_wait' uses it, so
>>>> when it works no separate implementation is needed unless you want to do more than just waiting.
>>>> It's also used when fence_add_callback is called. i915 can be patched to use it. ;-)
>>>
>>> I just meant enable_signaling, the other ones are fine with me. The problem with enable_signaling is that it's called with a spin lock held, so we can't sleep.
>>>
>>> While resetting the GPU could be moved out into a timer the problem here is that I can't lock rdev->exclusive_lock in such situations.
>>>
>>> This means when i915 would call into radeon to enable signaling for a fence we can't make sure that there is not GPU reset running on another CPU. And touching the IRQ registers while a reset is going on is a really good recipe to lockup the whole system.
>> If you increase the irq counter on all rings before doing a gpu reset, adjust the state and call sw_irq_put when done this race could never happen. Or am I missing something?
>>
> Beside that's being extremely ugly in the case of a hard PCI reset even touching any register or just accessing VRAM in this moment can crash the box. Just working around the enable/disable of the interrupt here won't help us much.
>
> Adding another spin lock won't work so well either, because the reset function itself wants to sleep as well.
>
> The only solution I see off hand is making the critical reset code path work in atomic context as well, but that's not really doable cause AFAIK we need to work with functions from the PCI subsystem and spinning on a lock for up to a second is not really desirable also.
I've checked the code a little but that can be the case now as well. the new implementation's __radeon_fence_wait will be protected by the exclusive_lock,, but enable_signaling is only protected by the fence_queue.lock and is_signaled is not protected. But this is not a change from the current situation, so it would only become a problem if the gpu hangs in a cross-device situation.

I think adding 1 to the irq refcount in the reset sequence and adding a down_read_trylock on the exclusive lock would help. If the trylock fails we could perform only the safe actions without touching any of the gpu registers or vram, adding the refcount is needed to ensure enable_signaling works as intended.

~Maarten

