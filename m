Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaGXLhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:37:14 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:56657 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaGXLhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:37:12 -0400
MIME-Version: 1.0
In-Reply-To: <4843763.ps2D25LEeM@wuerfel>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<1405413956-2772-14-git-send-email-lftan@altera.com>
	<4843763.ps2D25LEeM@wuerfel>
Date: Thu, 24 Jul 2014 19:37:11 +0800
X-Google-Sender-Auth: JKeB5nhwDRpqvmkGKHjEeyc8N58
Message-ID: <CAFiDJ582FiLAS=B13O3PV_d-FkR31j=5bN_LcXBSWkrGsHK_Gw@mail.gmail.com>
Subject: Re: [PATCH v2 13/29] nios2: DMA mapping API
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 5:38 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 15 July 2014 16:45:40 Ley Foon Tan wrote:
>
>> +static inline void __dma_sync(void *vaddr, size_t size,
>> +                           enum dma_data_direction direction)
>> +{
>> +     switch (direction) {
>> +     case DMA_FROM_DEVICE:   /* invalidate cache */
>> +             invalidate_dcache_range((unsigned long)vaddr,
>> +                     (unsigned long)(vaddr + size));
>> +             break;
>> +     case DMA_TO_DEVICE:     /* flush and invalidate cache */
>> +     case DMA_BIDIRECTIONAL:
>> +             flush_dcache_range((unsigned long)vaddr,
>> +                     (unsigned long)(vaddr + size));
>> +             break;
>> +     default:
>> +             BUG();
>> +     }
>> +}
>
> This seems strange. More on that below.
>
>> +#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
>> +#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
>> +
> ...
>> +static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
>> +                               enum dma_data_direction direction)
>> +{
>> +     __dma_sync(vaddr, size, direction);
>> +}
>
> IIRC dma_cache_sync should be empty if you define dma_alloc_noncoherent
> to be the same as dma_alloc_coherent: It's already coherent, so no sync
> should be needed. What does the CPU do if you try to invalidate the cache
> on a coherent mapping?
Okay, I got what you mean here. I will leave this dma_cache_sync()
function empty.
The CPU just do nothing if we try to invalidate cache on a coherent region.
BTW, I found many other architectures still provide dma_cache_sync()
even they define dma_alloc_noncoherent
same as dma_alloc_coherent. Eg: blackfin, x86 or xtense.
>
>> +void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
>> +                          size_t size, enum dma_data_direction direction)
>> +{
>> +     BUG_ON(!valid_dma_direction(direction));
>> +
>> +     __dma_sync(phys_to_virt(dma_handle), size, direction);
>> +}
>> +EXPORT_SYMBOL(dma_sync_single_for_cpu);
>> +
>> +void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
>> +                             size_t size, enum dma_data_direction direction)
>> +{
>> +     BUG_ON(!valid_dma_direction(direction));
>> +
>> +     __dma_sync(phys_to_virt(dma_handle), size, direction);
>> +}
>> +EXPORT_SYMBOL(dma_sync_single_for_device);
>
> More importantly: you do the same operation for both _for_cpu and _for_device.
> I assume your CPU can never do speculative cache prefetches, so it's not
> incorrect, but you do twice the number of invalidations and flushes that
> you need.
>
> Why would you do anything for _for_cpu here?
I am a bit confused for _for_cpu and _for_device here. I found some
architectures like c6x and hexagon have same operation for both
_for_cpu and _for_device as well.
I have spent some times look at other architectures and below is what
I found. Please correct me if I am wrong, especially
for_device():DMA_FROM_DEVICE.

_for_cpu():
case DMA_BIDIRECTIONAL:
case DMA_FROM_DEVICE:
     /* invalidate cache */
break;
case DMA_TO_DEVICE:
   /* do nothing */
break;

-------------------------
_for_device():
case DMA_BIDIRECTIONAL:
case DMA_TO_DEVICE:
     /* flush and invalidate cache */
break;
case DMA_FROM_DEVICE:
 /* should we invalidate cache or do nothing? */
break;

Thanks for review.

Regards
Ley Foon
