Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaGKC5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:57:42 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8308 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaGKC5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:57:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 10 Jul 2014 19:50:34 -0700
Message-ID: <53BF52A0.4070907@nvidia.com>
Date: Fri, 11 Jul 2014 11:57:36 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ben Skeggs <skeggsb@gmail.com>
CC: Daniel Vetter <daniel@ffwll.ch>, Alexandre Courbot <gnurou@gmail.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [Nouveau] [PATCH v4 2/6] drm/nouveau: map pages using DMA API
 on platform devices
References: <1404807961-30530-1-git-send-email-acourbot@nvidia.com>	<1404807961-30530-3-git-send-email-acourbot@nvidia.com>	<20140710125849.GF17271@phenom.ffwll.local>	<53BF4D6B.70904@nvidia.com> <CACAvsv7eER4VmbR81Ym=YE7fQZ9cNuJsb5372SAuSX+PQfYyrQ@mail.gmail.com>
In-Reply-To: <CACAvsv7eER4VmbR81Ym=YE7fQZ9cNuJsb5372SAuSX+PQfYyrQ@mail.gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 11:50 AM, Ben Skeggs wrote:
> On Fri, Jul 11, 2014 at 12:35 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> On 07/10/2014 09:58 PM, Daniel Vetter wrote:
>>>
>>> On Tue, Jul 08, 2014 at 05:25:57PM +0900, Alexandre Courbot wrote:
>>>>
>>>> page_to_phys() is not the correct way to obtain the DMA address of a
>>>> buffer on a non-PCI system. Use the DMA API functions for this, which
>>>> are portable and will allow us to use other DMA API functions for
>>>> buffer synchronization.
>>>>
>>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>>>> ---
>>>>    drivers/gpu/drm/nouveau/core/engine/device/base.c | 8 +++++++-
>>>>    1 file changed, 7 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/gpu/drm/nouveau/core/engine/device/base.c
>>>> b/drivers/gpu/drm/nouveau/core/engine/device/base.c
>>>> index 18c8c7245b73..e4e9e64988fe 100644
>>>> --- a/drivers/gpu/drm/nouveau/core/engine/device/base.c
>>>> +++ b/drivers/gpu/drm/nouveau/core/engine/device/base.c
>>>> @@ -489,7 +489,10 @@ nv_device_map_page(struct nouveau_device *device,
>>>> struct page *page)
>>>>                  if (pci_dma_mapping_error(device->pdev, ret))
>>>>                          ret = 0;
>>>>          } else {
>>>> -               ret = page_to_phys(page);
>>>> +               ret = dma_map_page(&device->platformdev->dev, page, 0,
>>>> +                                  PAGE_SIZE, DMA_BIDIRECTIONAL);
>>>> +               if (dma_mapping_error(&device->platformdev->dev, ret))
>>>> +                       ret = 0;
>>>>          }
>>>>
>>>>          return ret;
>>>> @@ -501,6 +504,9 @@ nv_device_unmap_page(struct nouveau_device *device,
>>>> dma_addr_t addr)
>>>>          if (nv_device_is_pci(device))
>>>>                  pci_unmap_page(device->pdev, addr, PAGE_SIZE,
>>>>                                 PCI_DMA_BIDIRECTIONAL);
>>>
>>>
>>> pci_map/unmap alias to dma_unmap/map when called on the underlying struct
>>> device embedded in pci_device (like for platform drivers). Dunno whether
>>> it's worth to track a pointer to the struct device directly and always
>>> call dma_unmap/map.
>>
>>
>> Isn't it (theoretically) possible to have a platform that does not use the
>> DMA API for its PCI implementation and thus requires the pci_* functions to
>> be called? I could not find such a case in -next, which suggests that all
>> PCI platforms have been converted to the DMA API already and that we could
>> indeed refactor this to always use the DMA functions.
>>
>> But at the same time the way we use APIs should not be directed by their
>> implementation, but by their intent - and unless the PCI API has been
>> deprecated in some way (something I am not aware of), the rule is still that
>> you should use it on a PCI device.
>>
>>
>>>
>>> Just drive-by comment since I'm interested in how you solve this - i915
>>> has similar fun with buffer sharing and coherent and non-coherent
>>> platforms. Although we don't have fun with pci and non-pci based
>>> platforms.
>>
>>
>> Yeah, I am not familiar with i915 but it seems like we are on a similar boat
>> here (excepted ARM is more constrained as to its memory mappings). The
>> strategy in this series is, map buffers used by user-space cached and
>> explicitly synchronize them (since the ownership transition from user to GPU
>> is always clearly performed by syscalls), and use coherent mappings for
>> buffers used by the kernel which are accessed more randomly. This has solved
>> all our coherency issues and resulted in the best performance so far.
> I wonder if we might want to use unsnooped cached mappings of pages on
> non-ARM platforms also, to avoid the overhead of the cache snooping?

You might want to indeed, now that coherency is guaranteed by the sync 
functions originally introduced by Lucas. The only issue I could see is 
that they always invalidate the full buffer whereas bus snooping only 
affects pages that are actually touched. Someone would need to try this 
on a desktop machine and see how it affects performance.

I'd be all for it though, since it would also allow us to get rid of 
this ungraceful nv_device_is_cpu_coherent() function and result in 
simplifying nouveau_bo.c a bit.
