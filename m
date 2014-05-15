Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbaEOJij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:38:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38287 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbaEOJiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:38:05 -0400
Message-ID: <53748AFA.8010109@canonical.com>
Date: Thu, 15 May 2014 11:38:02 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        airlied@linux.ie
CC: nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v1 08/16] drm/radeon: use common fence implementation
 for fences
References: <20140514145134.21163.32350.stgit@patser> <20140514145809.21163.64947.stgit@patser> <53738BCC.2070809@vodafone.de> <5374131D.4010906@canonical.com> <53748702.6070606@vodafone.de>
In-Reply-To: <53748702.6070606@vodafone.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 15-05-14 11:21, Christian König schreef:
> Am 15.05.2014 03:06, schrieb Maarten Lankhorst:
>> op 14-05-14 17:29, Christian König schreef:
>>>> +    /* did fence get signaled after we enabled the sw irq? */
>>>> +    if (atomic64_read(&fence->rdev->fence_drv[fence->ring].last_seq) >= fence->seq) {
>>>> +        radeon_irq_kms_sw_irq_put(fence->rdev, fence->ring);
>>>> +        return false;
>>>> +    }
>>>> +
>>>> +    fence->fence_wake.flags = 0;
>>>> +    fence->fence_wake.private = NULL;
>>>> +    fence->fence_wake.func = radeon_fence_check_signaled;
>>>> +    __add_wait_queue(&fence->rdev->fence_queue, &fence->fence_wake);
>>>> +    fence_get(f);
>>> That looks like a race condition to me. The fence needs to be added to the wait queue before the check, not after.
>>>
>>> Apart from that the whole approach looks like a really bad idea to me. How for example is lockup detection supposed to happen with this? 
>> It's not a race condition because fence_queue.lock is held when this function is called.
> Ah, I see. That's also the reason why you moved the wake_up_all out of the processing function.
Correct. :-)
>> Lockup's a bit of a weird problem, the changes wouldn't allow core ttm code to handle the lockup any more,
>> but any driver specific wait code would still handle this. I did this by design, because in future patches the wait
>> function may be called from outside of the radeon driver. The official wait function takes a timeout parameter,
>> so lockups wouldn't be fatal if the timeout is set to something like 30*HZ for example, it would still return
>> and report that the function timed out.
> Timeouts help with the detection of the lockup, but not at all with the handling of them.
>
> What we essentially need is a wait callback into the driver that is called in non atomic context without any locks held.
>
> This way we can block for the fence to become signaled with a timeout and can then also initiate the reset handling if necessary.
>
> The way you designed the interface now means that the driver never gets a chance to wait for the hardware to become idle and so never has the opportunity to the reset the whole thing.
You could set up a hangcheck timer like intel does, and end up with a reliable hangcheck detection that doesn't depend on cpu waits. :-) Or override the default wait function and restore the old behavior.

~Maarten

