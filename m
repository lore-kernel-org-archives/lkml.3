Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaHDOiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:38:10 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:55549
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750919AbaHDOiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:38:07 -0400
X-WSS-ID: 0N9SDZ8-08-OJ4-02
X-M-MSG: 
Message-ID: <53DF9AC4.3010700@amd.com>
Date: Mon, 4 Aug 2014 16:37:56 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>, <airlied@linux.ie>
CC: <thellstrom@vmware.com>, <nouveau@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <bskeggs@redhat.com>, <alexander.deucher@amd.com>
Subject: Re: [PATCH 09/19] drm/radeon: handle lockup in delayed work, v2
References: <20140731153245.15061.63023.stgit@patser>
 <20140731153342.15061.54264.stgit@patser> <53DBC1EC.1010001@amd.com>
 <53DBD269.80807@canonical.com> <53DF462B.2060102@amd.com>
 <53DF4A7D.3040505@canonical.com> <53DF7516.2010408@amd.com>
 <53DF8BF2.4000309@canonical.com>
In-Reply-To: <53DF8BF2.4000309@canonical.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [10.224.152.188]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(377424004)(199002)(189002)(51704005)(19580395003)(83322001)(19580405001)(44976005)(80316001)(65956001)(80022001)(65806001)(23676002)(76482001)(97736001)(77982001)(81342001)(4396001)(86362001)(50466002)(74662001)(64126003)(64706001)(20776003)(47776003)(74502001)(81542001)(31966008)(36756003)(46102001)(106466001)(68736004)(85202003)(92566001)(95666004)(101416001)(85182001)(87936001)(54356999)(85852003)(102836001)(76176999)(83072002)(105586002)(83506001)(50986999)(33656002)(84676001)(85306004)(92726001)(99396002)(21056001)(79102001)(65816999)(93886004)(87266999)(107046002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB042;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0293D40691
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It'a pain to deal with gpu reset.

Yeah, well that's nothing new.

> I've now tried other solutions but that would mean reverting to the old style during gpu lockup recovery, and only running the delayed work when !lockup.
> But this meant that the timeout was useless to add. I think the cleanest is keeping the v2 patch, because potentially any waiting code can be called during lockup recovery.

The lockup code itself should never call any waiting code and V2 doesn't 
seem to handle a couple of cases correctly either.

How about moving the fence waiting out of the reset code?

Christian.

Am 04.08.2014 um 15:34 schrieb Maarten Lankhorst:
> Hey,
>
> op 04-08-14 13:57, Christian König schreef:
>> Am 04.08.2014 um 10:55 schrieb Maarten Lankhorst:
>>> op 04-08-14 10:36, Christian König schreef:
>>>> Hi Maarten,
>>>>
>>>> Sorry for the delay. I've got way to much todo recently.
>>>>
>>>> Am 01.08.2014 um 19:46 schrieb Maarten Lankhorst:
>>>>> On 01-08-14 18:35, Christian König wrote:
>>>>>> Am 31.07.2014 um 17:33 schrieb Maarten Lankhorst:
>>>>>>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>>>>>> ---
>>>>>>> V1 had a nasty bug breaking gpu lockup recovery. The fix is not
>>>>>>> allowing radeon_fence_driver_check_lockup to take exclusive_lock,
>>>>>>> and kill it during lockup recovery instead.
>>>>>> That looks like the delayed work starts running as soon as we submit a fence, and not when it's needed for waiting.
>>>>>>
>>>>>> Since it's a backup for failing IRQs I would rather put it into radeon_irq_kms.c and start/stop it when the IRQs are started/stoped.
>>>>> The delayed work is not just for failing irq's, it's also the handler that's used to detect lockups, which is why I trigger after processing fences, and reset the timer after processing.
>>>> The idea was turning the delayed work on and off when we turn the irq on and off as well, processing of the delayed work handler can still happen in radeon_fence.c
>>>>
>>>>> Specifically what happened was this scenario:
>>>>>
>>>>> - lock up occurs
>>>>> - write lock taken by gpu_reset
>>>>> - delayed work runs, tries to acquire read lock, blocks
>>>>> - gpu_reset tries to cancel delayed work synchronously
>>>>> - has to wait for delayed work to finish -> deadlock
>>>> Why do you want to disable the work item from the lockup handler in the first place?
>>>>
>>>> Just take the exclusive lock in the work item, when it concurrently runs with the lockup handler it will just block for the lockup handler to complete.
>>> With the delayed work radeon_fence_wait no longer handles unreliable interrupts itself, so it has to run from the lockup handler.
>>> But an alternative solution could be adding a radeon_fence_wait_timeout, ignore the timeout and check if fence is signaled on timeout.
>>> This would probably be a cleaner solution.
>> Yeah, agree. Manually specifying a timeout in the fence wait on lockup handling sounds like the best alternative to me.
> It'a pain to deal with gpu reset.
>
> I've now tried other solutions but that would mean reverting to the old style during gpu lockup recovery, and only running the delayed work when !lockup.
> But this meant that the timeout was useless to add. I think the cleanest is keeping the v2 patch, because potentially any waiting code can be called during lockup recovery.
>
> ~Maarten
>

