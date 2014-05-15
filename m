Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaEOBGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 21:06:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36184 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaEOBGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 21:06:41 -0400
Message-ID: <5374131D.4010906@canonical.com>
Date: Thu, 15 May 2014 03:06:37 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        airlied@linux.ie
CC: nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v1 08/16] drm/radeon: use common fence implementation
 for fences
References: <20140514145134.21163.32350.stgit@patser> <20140514145809.21163.64947.stgit@patser> <53738BCC.2070809@vodafone.de>
In-Reply-To: <53738BCC.2070809@vodafone.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 14-05-14 17:29, Christian König schreef:
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
> That looks like a race condition to me. The fence needs to be added to the wait queue before the check, not after.
>
> Apart from that the whole approach looks like a really bad idea to me. How for example is lockup detection supposed to happen with this? 
It's not a race condition because fence_queue.lock is held when this function is called.

Lockup's a bit of a weird problem, the changes wouldn't allow core ttm code to handle the lockup any more,
but any driver specific wait code would still handle this. I did this by design, because in future patches the wait
function may be called from outside of the radeon driver. The official wait function takes a timeout parameter,
so lockups wouldn't be fatal if the timeout is set to something like 30*HZ for example, it would still return
and report that the function timed out.

~Maarten
