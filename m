Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaEWJnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:43:53 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17478 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaEWJnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:43:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 23 May 2014 02:38:55 -0700
Message-ID: <537F1853.7050800@nvidia.com>
Date: Fri, 23 May 2014 18:43:47 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lucas Stach <l.stach@pengutronix.de>, Alexandre Courbot <gnurou@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] drm/nouveau: disable caching for VRAM BOs on ARM
References: <1400492771-9746-1-git-send-email-acourbot@nvidia.com>	 <1400493433.8467.24.camel@weser.hi.pengutronix.de>	 <5379D7A0.3050509@nvidia.com>	 <1400494582.8467.28.camel@weser.hi.pengutronix.de>	 <CAAVeFuLKTjaZPSxNSK3nEG+XK+mMmPDDq85qMF-EHp3bGwVJYA@mail.gmail.com> <1400837055.4921.4.camel@weser.hi.pengutronix.de>
In-Reply-To: <1400837055.4921.4.camel@weser.hi.pengutronix.de>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 06:24 PM, Lucas Stach wrote:
> Am Freitag, den 23.05.2014, 16:10 +0900 schrieb Alexandre Courbot:
>> On Mon, May 19, 2014 at 7:16 PM, Lucas Stach <l.stach@pengutronix.de> wrote:
>>> Am Montag, den 19.05.2014, 19:06 +0900 schrieb Alexandre Courbot:
>>>> On 05/19/2014 06:57 PM, Lucas Stach wrote:
>>>>> Am Montag, den 19.05.2014, 18:46 +0900 schrieb Alexandre Courbot:
>>>>>> This patch is not meant to be merged, but rather to try and understand
>>>>>> why this is needed and what a more suitable solution could be.
>>>>>>
>>>>>> Allowing BOs to be write-cached results in the following happening when
>>>>>> trying to run any program on Tegra/GK20A:
>>>>>>
>>>>>> Unhandled fault: external abort on non-linefetch (0x1008) at 0xf0036010
>>>>>> ...
>>>>>> (nouveau_bo_rd32) from [<c0357d00>] (nouveau_fence_update+0x5c/0x80)
>>>>>> (nouveau_fence_update) from [<c0357d40>] (nouveau_fence_done+0x1c/0x38)
>>>>>> (nouveau_fence_done) from [<c02c3d00>] (ttm_bo_wait+0xec/0x168)
>>>>>> (ttm_bo_wait) from [<c035e334>] (nouveau_gem_ioctl_cpu_prep+0x44/0x100)
>>>>>> (nouveau_gem_ioctl_cpu_prep) from [<c02aaa84>] (drm_ioctl+0x1d8/0x4f4)
>>>>>> (drm_ioctl) from [<c0355394>] (nouveau_drm_ioctl+0x54/0x80)
>>>>>> (nouveau_drm_ioctl) from [<c00ee7b0>] (do_vfs_ioctl+0x3dc/0x5a0)
>>>>>> (do_vfs_ioctl) from [<c00ee9a8>] (SyS_ioctl+0x34/0x5c)
>>>>>> (SyS_ioctl) from [<c000e6e0>] (ret_fast_syscall+0x0/0x30
>>>>>>
>>>>>> The offending nouveau_bo_rd32 is done over an IO-mapped BO, e.g. a BO
>>>>>> mapped through the BAR.
>>>>>>
>>>>> Um wait, this memory is behind an already mapped bar? I think ioremap on
>>>>> ARM defaults to uncached mappings, so if you want to access the memory
>>>>> behind this bar as WC you need to map the BAR as a whole as WC by using
>>>>> ioremap_wc.
>>>>
>>>> Tried mapping the BAR using ioremap_wc(), but to no avail. On the other
>>>> hand, could it be that VRAM BOs end up creating a mapping over an
>>>> already-mapped region? I seem to remember that ARM might not like it...
>>>
>>> Multiple mapping are generally allowed, as long as they have the same
>>> caching state. It's conflicting mappings (uncached vs cached, or cached
>>> vs wc), that are documented to yield undefined results.
>>
>> Sorry about the confusion. The BAR is *not* mapped to the kernel yet
>> (it is BAR1, there is no BAR3 on GK20A) and an ioremap_*() is
>> performed in ttm_bo_ioremap() to make the part of the BAR where the
>> buffer is mapped visible. It seems that doing an ioremap_wc() on the
>> BAR area on Tegra is what leads to these errors. ioremap() or
>> ioremap_nocache() (which are in effect the same on ARM) do not cause
>> this issue.
>>
> It would be cool if you could ask HW, or the blob developers, if this is
> a general issue. The external abort is clearly the GPUs AXI client
> responding with an error to the read request, though I'm not clear where
> a WC read differs from an uncached one.

Will check that.

>
>> The best way to solve this issue would be to not use the BAR at all
>> since the memory behind these objects can be directly accessed by the
>> CPU. As such it would better be mapped using ttm_bo_kmap_ttm()
>> instead. But right now this is clearly not how nouveau_bo.c is written
>> and it does not look like this can easily be done. :/
>
> Yeah, it sounds like we want this shortcut for stolen VRAM
> implementations.

Actually, isn't it the case that we do not want to use TTM at all for 
stolen VRAM (UMA) devices?

I am trying to wrap my head around this since a while already, and could 
not think of a way to use the current TTM-based nouveau_bo optimally for 
GK20A. Because we cannot do without the idea of VRAM and GART, we will 
always have to "move" objects from one location to another, or deal with 
constraints that do not make sense for UMA devices (like in the current 
case, accessing VRAM objects through the BAR).

I am currently contemplating the idea of writing an alternative non-TTM 
implementation of nouveau_bo for UMA devices, that would (hopefully) be 
much simpler and would spare us a lot of stunts.

On the other hand, this sounds like a considerable work and I would like 
to make sure that my lack of understanding of TTM is not driving me to 
the wrong solution. Thoughts?

Thanks,
Alex.

