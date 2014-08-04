Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaHDIzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 04:55:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37316 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaHDIzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 04:55:32 -0400
Message-ID: <53DF4A7D.3040505@canonical.com>
Date: Mon, 04 Aug 2014 10:55:25 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>,
        airlied@linux.ie
CC: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com
Subject: Re: [PATCH 09/19] drm/radeon: handle lockup in delayed work, v2
References: <20140731153245.15061.63023.stgit@patser> <20140731153342.15061.54264.stgit@patser> <53DBC1EC.1010001@amd.com> <53DBD269.80807@canonical.com> <53DF462B.2060102@amd.com>
In-Reply-To: <53DF462B.2060102@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 04-08-14 10:36, Christian König schreef:
> Hi Maarten,
>
> Sorry for the delay. I've got way to much todo recently.
>
> Am 01.08.2014 um 19:46 schrieb Maarten Lankhorst:
>>
>> On 01-08-14 18:35, Christian König wrote:
>>> Am 31.07.2014 um 17:33 schrieb Maarten Lankhorst:
>>>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>>> ---
>>>> V1 had a nasty bug breaking gpu lockup recovery. The fix is not
>>>> allowing radeon_fence_driver_check_lockup to take exclusive_lock,
>>>> and kill it during lockup recovery instead.
>>> That looks like the delayed work starts running as soon as we submit a fence, and not when it's needed for waiting.
>>>
>>> Since it's a backup for failing IRQs I would rather put it into radeon_irq_kms.c and start/stop it when the IRQs are started/stoped.
>> The delayed work is not just for failing irq's, it's also the handler that's used to detect lockups, which is why I trigger after processing fences, and reset the timer after processing.
>
> The idea was turning the delayed work on and off when we turn the irq on and off as well, processing of the delayed work handler can still happen in radeon_fence.c
>
>>
>> Specifically what happened was this scenario:
>>
>> - lock up occurs
>> - write lock taken by gpu_reset
>> - delayed work runs, tries to acquire read lock, blocks
>> - gpu_reset tries to cancel delayed work synchronously
>> - has to wait for delayed work to finish -> deadlock
>
> Why do you want to disable the work item from the lockup handler in the first place?
>
> Just take the exclusive lock in the work item, when it concurrently runs with the lockup handler it will just block for the lockup handler to complete.
With the delayed work radeon_fence_wait no longer handles unreliable interrupts itself, so it has to run from the lockup handler.
But an alternative solution could be adding a radeon_fence_wait_timeout, ignore the timeout and check if fence is signaled on timeout.
This would probably be a cleaner solution.

~Maarten

