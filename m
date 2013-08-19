Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab3HSTh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 15:37:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39995 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3HSTh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 15:37:57 -0400
Message-ID: <52127411.2010106@canonical.com>
Date: Mon, 19 Aug 2013 21:37:53 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
CC: dri-devel@lists.freedesktop.org, linux-arch@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org,
        Alex Deucher <alexander.deucher@amd.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] drm/radeon: rework to new fence interface
References: <20130815124308.14812.58197.stgit@patser> <5211F0C5.2040705@canonical.com> <5212112C.70808@vodafone.de>
In-Reply-To: <5212112C.70808@vodafone.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 19-08-13 14:35, Christian König schreef:
> Am 19.08.2013 12:17, schrieb Maarten Lankhorst:
>> [SNIP]
>> @@ -190,25 +225,24 @@ void radeon_fence_process(struct radeon_device *rdev, int ring)
>>           }
>>       } while (atomic64_xchg(&rdev->fence_drv[ring].last_seq, seq) > seq);
>>   -    if (wake) {
>> +    if (wake)
>>           rdev->fence_drv[ring].last_activity = jiffies;
>> -        wake_up_all(&rdev->fence_queue);
>> -    }
>> +    return wake;
>>   }
>
> Very bad idea, when sequence numbers change, you always want to wake up the whole fence queue here.
Yes, and the callers of this function call wake_up_all or wake_up_all_locked themselves, based on the return value..

>> [SNIP]
>> +/**
>> + * radeon_fence_enable_signaling - enable signalling on fence
>> + * @fence: fence
>> + *
>> + * This function is called with fence_queue lock held, and adds a callback
>> + * to fence_queue that checks if this fence is signaled, and if so it
>> + * signals the fence and removes itself.
>> + */
>> +static bool radeon_fence_enable_signaling(struct fence *f)
>> +{
>> +    struct radeon_fence *fence = to_radeon_fence(f);
>> +
>> +    if (atomic64_read(&fence->rdev->fence_drv[fence->ring].last_seq) >= fence->seq ||
>> +        !fence->rdev->ddev->irq_enabled)
>> +        return false;
>> +
>
> Do I get that right that you rely on IRQs to be enabled and working here? Cause that would be a quite bad idea from the conceptual side.
For cross-device synchronization it would be nice to have working irqs, it allows signalling fences faster,
and it allows for callbacks on completion to be called. For internal usage it's no more required than it was before.
>> +    radeon_irq_kms_sw_irq_get(fence->rdev, fence->ring);
>> +
>> +    if (__radeon_fence_process(fence->rdev, fence->ring))
>> +        wake_up_all_locked(&fence->rdev->fence_queue);
>> +
>> +    /* did fence get signaled after we enabled the sw irq? */
>> +    if (atomic64_read(&fence->rdev->fence_drv[fence->ring].last_seq) >= fence->seq) {
>> +        radeon_irq_kms_sw_irq_put(fence->rdev, fence->ring);
>> +        return false;
>> +    }
>> +
>> +    fence->fence_wake.flags = 0;
>> +    fence->fence_wake.private = NULL;
>> +    fence->fence_wake.func = radeon_fence_check_signaled;
>> +    __add_wait_queue(&fence->rdev->fence_queue, &fence->fence_wake);
>> +    fence_get(f);
>> +
>> +    return true;
>> +}
>> +
>>   /**
>>    * radeon_fence_signaled - check if a fence has signaled
>>    *
>>
>
> Christian.
>
~Maarten

