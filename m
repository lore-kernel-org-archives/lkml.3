Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaHDL5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:57:20 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:14680
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752166AbaHDL5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:57:19 -0400
X-WSS-ID: 0N9S6JE-07-5GK-02
X-M-MSG: 
Message-ID: <53DF7516.2010408@amd.com>
Date: Mon, 4 Aug 2014 13:57:10 +0200
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
 <53DF4A7D.3040505@canonical.com>
In-Reply-To: <53DF4A7D.3040505@canonical.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [10.224.152.197]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(24454002)(377424004)(51704005)(85852003)(83072002)(79102001)(101416001)(77982001)(59896001)(92726001)(65956001)(81542001)(97736001)(86362001)(80022001)(65806001)(4396001)(81342001)(21056001)(85202003)(105586002)(107046002)(106466001)(85306004)(95666004)(74662001)(64126003)(102836001)(85182001)(50986999)(46102001)(76176999)(54356999)(84676001)(65816999)(33656002)(83506001)(87936001)(87266999)(19580395003)(64706001)(19580405001)(50466002)(80316001)(83322001)(76482001)(44976005)(36756003)(99396002)(23676002)(20776003)(68736004)(74502001)(47776003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB033;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0293D40691
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.08.2014 um 10:55 schrieb Maarten Lankhorst:
> op 04-08-14 10:36, Christian König schreef:
>> Hi Maarten,
>>
>> Sorry for the delay. I've got way to much todo recently.
>>
>> Am 01.08.2014 um 19:46 schrieb Maarten Lankhorst:
>>> On 01-08-14 18:35, Christian König wrote:
>>>> Am 31.07.2014 um 17:33 schrieb Maarten Lankhorst:
>>>>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>>>> ---
>>>>> V1 had a nasty bug breaking gpu lockup recovery. The fix is not
>>>>> allowing radeon_fence_driver_check_lockup to take exclusive_lock,
>>>>> and kill it during lockup recovery instead.
>>>> That looks like the delayed work starts running as soon as we submit a fence, and not when it's needed for waiting.
>>>>
>>>> Since it's a backup for failing IRQs I would rather put it into radeon_irq_kms.c and start/stop it when the IRQs are started/stoped.
>>> The delayed work is not just for failing irq's, it's also the handler that's used to detect lockups, which is why I trigger after processing fences, and reset the timer after processing.
>> The idea was turning the delayed work on and off when we turn the irq on and off as well, processing of the delayed work handler can still happen in radeon_fence.c
>>
>>> Specifically what happened was this scenario:
>>>
>>> - lock up occurs
>>> - write lock taken by gpu_reset
>>> - delayed work runs, tries to acquire read lock, blocks
>>> - gpu_reset tries to cancel delayed work synchronously
>>> - has to wait for delayed work to finish -> deadlock
>> Why do you want to disable the work item from the lockup handler in the first place?
>>
>> Just take the exclusive lock in the work item, when it concurrently runs with the lockup handler it will just block for the lockup handler to complete.
> With the delayed work radeon_fence_wait no longer handles unreliable interrupts itself, so it has to run from the lockup handler.
> But an alternative solution could be adding a radeon_fence_wait_timeout, ignore the timeout and check if fence is signaled on timeout.
> This would probably be a cleaner solution.

Yeah, agree. Manually specifying a timeout in the fence wait on lockup 
handling sounds like the best alternative to me.

Christian.

>
> ~Maarten
>

