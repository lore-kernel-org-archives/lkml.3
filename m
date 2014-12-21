Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaLUMUW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 07:20:22 -0500
Received: from pegasos-out.vodafone.de ([80.84.1.38]:43182 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaLUMUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 07:20:21 -0500
X-Spam-Flag: NO
X-Spam-Score: 0.157
Authentication-Results: rohrpostix2.prod.vfnet.de (amavisd-new); dkim=softfail
	(invalid, public key: DNS query timeout for
	mail._domainkey.vodafone.de) header.i=@vodafone.de
X-DKIM: OpenDKIM Filter v2.6.8 pegasos-out.vodafone.de 8BAC2670D2
Message-ID: <5496BAE0.5090901@vodafone.de>
Date: Sun, 21 Dec 2014 13:19:44 +0100
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oded Gabbay <oded.gabbay@amd.com>, dri-devel@lists.freedesktop.org
CC: linux-kernel@vger.kernel.org, Alexander.Deucher@amd.com
Subject: Re: [PATCH 1/3] amdkfd: Don't clear *kfd2kgd on kfd_module_init
References: <1419108374-7020-1-git-send-email-oded.gabbay@amd.com> <1419108374-7020-2-git-send-email-oded.gabbay@amd.com> <5496AEAD.3090003@vodafone.de> <5496B04C.50502@amd.com>
In-Reply-To: <5496B04C.50502@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.12.2014 um 12:34 schrieb Oded Gabbay:
>
>
> On 12/21/2014 01:27 PM, Christian König wrote:
>> Am 20.12.2014 um 21:46 schrieb Oded Gabbay:
>>> When amdkfd and radeon are compiled inside the kernel image (not as 
>>> modules),
>>> radeon will load before amdkfd and will set *kfd2kgd to its interface
>>> structure. Therefore, we must not set *kfd2kgd to NULL when amdkfd 
>>> is loaded
>>> because it will override radeon's initialization and cause kernel BUG.
>>>
>>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>>
>> You should probably rather fix the dependency between the two modules 
>> to get an
>> determined load order instead of doing such nasty workarounds.
>>
>> Christian.
>
> The problem is that when modules are compiled inside the kernel, there 
> is NO determined load order and there is no mechanism to enforce that. 
> If there is/was such a mechanism, I would of course prefer to use it.

There should be an determined order based on the symbol use, otherwise 
initializing most of the kernel modules wouldn't work as expected. For 
example radeon depends on the drm module must be loaded before radeon is 
loaded.

>
> Actually, I don't understand why the kernel doesn't enforce the order 
> according to the use of exported symbols, like it does with modules.

Yeah, that's indeed rather strange. There must be something in the 
amdkfd code which broke that somehow.

As far as I understand you the desired init order is radeon and 
amd_iommu_v2 first and then amdkfd, right? So what happens when you boot 
with radeon, amd_iommu_v2 and amdkfd blacklisted for automatically load 
and only load amdkfd manually?

> There will always be dependencies between kgd (radeon) and amdkfd and 
> between amdkfd and amd_iommu_v2. I don't think I can eliminate those 
> dependencies, not without a very complex solution. And the fact that 
> this complex solution occurs only in a very specific use case (all 
> modules compiled in), makes me less inclined to do that.
>
> So I don't see it as a "nasty workaround". I would call it just a 
> "workaround" for a specific use case, which should be solved by a 
> generic solution to the kernel enforcing load orders.

The normal kernel module handling already should provide the correct 
init order, so I would still call this a rather nasty workaround because 
we couldn't find the underlying problem.

Christian.

>
>     Oded
>>
>>> ---
>>>   drivers/gpu/drm/amd/amdkfd/kfd_module.c | 5 ++---
>>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_module.c
>>> b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
>>> index 95d5af1..236562f 100644
>>> --- a/drivers/gpu/drm/amd/amdkfd/kfd_module.c
>>> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
>>> @@ -34,7 +34,7 @@
>>>   #define KFD_DRIVER_MINOR    7
>>>   #define KFD_DRIVER_PATCHLEVEL    0
>>> -const struct kfd2kgd_calls *kfd2kgd;
>>> +const struct kfd2kgd_calls *kfd2kgd = NULL;
>>>   static const struct kgd2kfd_calls kgd2kfd = {
>>>       .exit        = kgd2kfd_exit,
>>>       .probe        = kgd2kfd_probe,
>>> @@ -84,14 +84,13 @@ EXPORT_SYMBOL(kgd2kfd_init);
>>>   void kgd2kfd_exit(void)
>>>   {
>>> +    kfd2kgd = NULL;
>>>   }
>>>   static int __init kfd_module_init(void)
>>>   {
>>>       int err;
>>> -    kfd2kgd = NULL;
>>> -
>>>       /* Verify module parameters */
>>>       if ((sched_policy < KFD_SCHED_POLICY_HWS) ||
>>>           (sched_policy > KFD_SCHED_POLICY_NO_HWS)) {
>>

