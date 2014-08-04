Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaHDPJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:09:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39281 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaHDPJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:09:13 -0400
Message-ID: <53DFA210.2020603@canonical.com>
Date: Mon, 04 Aug 2014 17:09:04 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>,
        airlied@linux.ie
CC: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com
Subject: Re: [PATCH 09/19] drm/radeon: handle lockup in delayed work, v2
References: <20140731153245.15061.63023.stgit@patser> <20140731153342.15061.54264.stgit@patser> <53DBC1EC.1010001@amd.com> <53DBD269.80807@canonical.com> <53DF462B.2060102@amd.com> <53DF4A7D.3040505@canonical.com> <53DF7516.2010408@amd.com> <53DF8BF2.4000309@canonical.com> <53DF9AC4.3010700@amd.com> <53DF9B58.8000403@canonical.com> <53DF9C88.6060107@amd.com> <53DF9F89.60202@canonical.com> <53DFA0EB.5040302@amd.com>
In-Reply-To: <53DFA0EB.5040302@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 04-08-14 17:04, Christian König schreef:
> Am 04.08.2014 um 16:58 schrieb Maarten Lankhorst:
>> op 04-08-14 16:45, Christian König schreef:
>>> Am 04.08.2014 um 16:40 schrieb Maarten Lankhorst:
>>>> op 04-08-14 16:37, Christian König schreef:
>>>>>> It'a pain to deal with gpu reset.
>>>>> Yeah, well that's nothing new.
>>>>>
>>>>>> I've now tried other solutions but that would mean reverting to the old style during gpu lockup recovery, and only running the delayed work when !lockup.
>>>>>> But this meant that the timeout was useless to add. I think the cleanest is keeping the v2 patch, because potentially any waiting code can be called during lockup recovery.
>>>>> The lockup code itself should never call any waiting code and V2 doesn't seem to handle a couple of cases correctly either.
>>>>>
>>>>> How about moving the fence waiting out of the reset code?
>>>> What cases did I miss then?
>>>>
>>>> I'm curious how you want to move the fence waiting out of reset, when there are so many places that could potentially wait, like radeon_ib_get can call radeon_sa_bo_new which can do a wait, or radeon_ring_alloc that can wait on radeon_fence_wait_next, etc.
>>> The IB test itself doesn't needs to be protected by the exclusive lock. Only everything between radeon_save_bios_scratch_regs and radeon_ring_restore.
>> I'm not sure about that, what do you want to do if the ring tests fail? Do you have to retake the exclusive lock?
>
> Just set need_reset again and return -EAGAIN, that should have mostly the same effect as what we are doing right now.
Yeah, except for the locking the ttm delayed workqueue, but that bool should be easy to save/restore.
I think this could work.

~Maarten

