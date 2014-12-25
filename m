Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaLYMbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 07:31:49 -0500
Received: from pegasos-out.vodafone.de ([80.84.1.38]:54182 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaLYMbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 07:31:48 -0500
X-Spam-Flag: NO
X-Spam-Score: 0.157
Authentication-Results: rohrpostix2.prod.vfnet.de (amavisd-new); dkim=softfail
	(invalid, public key: DNS query timeout for
	mail._domainkey.vodafone.de) header.i=@vodafone.de
X-DKIM: OpenDKIM Filter v2.6.8 pegasos-out.vodafone.de F342423
Message-ID: <549C038E.1030206@vodafone.de>
Date: Thu, 25 Dec 2014 13:31:10 +0100
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oded Gabbay <oded.gabbay@amd.com>, Andi Kleen <ak@linux.intel.com>,
        Alex Deucher <alexdeucher@gmail.com>
CC: Dana Elifaz <Dana.Elifaz@amd.com>, rusty@rustcorp.com.au,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Alexander Deucher <Alexander.Deucher@amd.com>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [PATCH] drm/radeon: Try to init amdkfd only if 64 bit kernel
References: <1419246673-7222-1-git-send-email-oded.gabbay@amd.com> <CADnq5_MY3+4BdWzUYffTnRWF3J4Z7nb6zyrGZK4RNwVU3axvuw@mail.gmail.com> <20141222184940.GB17192@tassilo.jf.intel.com> <20141222190041.GC17192@tassilo.jf.intel.com> <54986EA2.106@amd.com>
In-Reply-To: <54986EA2.106@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.12.2014 um 20:18 schrieb Oded Gabbay:
>
> On 12/22/2014 09:00 PM, Andi Kleen wrote:
>> On Mon, Dec 22, 2014 at 10:49:40AM -0800, Andi Kleen wrote:
>>> On Mon, Dec 22, 2014 at 11:58:43AM -0500, Alex Deucher wrote:
>>>> On Mon, Dec 22, 2014 at 6:11 AM, Oded Gabbay <oded.gabbay@amd.com> wrote:
>>>>> amdkfd driver can be compiled only in 64-bit kernel. Therefore, there is no
>>>>> point in trying to initialize amdkfd in 32-bit kernel.
>>>>>
>>>>> In addition, in case of specific configuration of 32-bit kernel, no modules and
>>>>> random kernel base, the symbol_request function doesn't work as expected - It
>>>>> doesn't return NULL if the symbol doesn't exists. That makes the kernel panic.
>>>>> Therefore, the as amdkfd doesn't compile in 32-bit kernel, the best way is just
>>>>> to return false immediately.
>>>>>
>>>>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>>>> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
>>> Sorry but the patch is just bogus. X-bit only code is usually
>>> a very bad sign for the code. This is not windows programing after all.
> Hi Andi,
>
> Strange, I have never programmed for Windows in my life (except maybe in a
> few courses during my degree) :)
>>> Even if you wanted to do a 64bit only driver -- which
>>> you probably don't -- the standard way would be to exclude
>>> it in Kconfig.
> So amdkfd actually *only* supports 64bit user processes, because AMD's HSA
> stack on Linux supports *only* 64bit user processes. So, yes, I definitely
> want to do a 64bit only driver.
> If you look at kfd_open(), it fails the open of /dev/kfd if the process is
> 32bit.
> In addition, in Kconfig of amdkfd, it is written:
> "depends on DRM_RADEON && AMD_IOMMU_V2 && X86_64"
>
> The problem here is that there is code in radeon, which is a driver that can
> compile in 32bit, which tries to load amdkfd. I didn't see a point in trying
> to load a driver which can't be compiled in 32bit.

Well in this case couldn't we make the code in radeon depend on whether 
or not the KFD driver is compiled in or not instead of checking the 
system architecture?

Regards,
Christian.

>
>>> Please root-cause why symbol_request doesn't work on 32bit
>>> and fix it properly.
> I didn't say it doesn't always work.
> The actual thing that doesn't work is the define symbol_get and only in a
> specific case of 32bit kernel AND CONFIG_MODULES is unset AND
> CONFIG_RANDOMIZE_BASE is set.
> The define in that case is:
> #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak)); &(x); })
>
> Why it doesn't work (doesn't return NULL when symbol doesn't exists) ?
> I don't know, probably because of some elf/makefile/c language magic. I'm
> not that big of an expert on those issues, and I wanted to provide a fix for
> this problem during the -rc stages. If someone can help me solving the root
> cause, I would be more than happy.
>
> 	Oded
>>> +rusty.
>> And also with correct email.
>>
>> -Andi
>>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

