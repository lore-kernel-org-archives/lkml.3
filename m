Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbaGXMFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:05:30 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:51472 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaGXMF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:05:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org
Subject: Re: [PATCH v2 13/29] nios2: DMA mapping API
Date: Thu, 24 Jul 2014 14:05:16 +0200
Message-ID: <5059148.8xZUvoce2l@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAFiDJ582FiLAS=B13O3PV_d-FkR31j=5bN_LcXBSWkrGsHK_Gw@mail.gmail.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <4843763.ps2D25LEeM@wuerfel> <CAFiDJ582FiLAS=B13O3PV_d-FkR31j=5bN_LcXBSWkrGsHK_Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1OZKlXThrOlS46ynJ4gN12tJly+jRAxhhTij2ukDGHw
 Mz7UjH/q2KQJkuW/OV/WK7btxlx59tljAJWD4UiCCglPTj0e47
 ecg1csYY6Xxu3cxuXu+bHTVAvuDKhz8hG96qwPuNdEGSs8nk0k
 k6FCn6iUXFCeav4pRVS5tyMnnyU8yBApqJh3+Yv/ALsnLMVm5b
 v7gEAeYhMOea+pB/PpQRPFGn09hvdO2Ki3kxmI/JeRm6VVQN1s
 tfcNclrd6DLJmT1tYUQXVKPjXNgBkYKHlJFqWXyekVETLqRs5j
 bs9rTtuIRwV4FaqHY7D0Jt1g2mf4x9iawqTpC/HpOomORQby2s
 /lOhd/EyXvASW0W9lFEY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2014 19:37:11 Ley Foon Tan wrote:
> On Tue, Jul 15, 2014 at 5:38 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 15 July 2014 16:45:40 Ley Foon Tan wrote:
> >> +#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
> >> +#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
> >> +
> > ...
> >> +static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
> >> +                               enum dma_data_direction direction)
> >> +{
> >> +     __dma_sync(vaddr, size, direction);
> >> +}
> >
> > IIRC dma_cache_sync should be empty if you define dma_alloc_noncoherent
> > to be the same as dma_alloc_coherent: It's already coherent, so no sync
> > should be needed. What does the CPU do if you try to invalidate the cache
> > on a coherent mapping?
> Okay, I got what you mean here. I will leave this dma_cache_sync()
> function empty.
> The CPU just do nothing if we try to invalidate cache on a coherent region.
> BTW, I found many other architectures still provide dma_cache_sync()
> even they define dma_alloc_noncoherent
> same as dma_alloc_coherent. Eg: blackfin, x86 or xtense.

They are probably all wrong ;-)

It's not a big issue though, since the x86 operation is cheap and the
other ones don't support any of the drivers that use dma_cache_sync.

> >> +void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
> >> +                          size_t size, enum dma_data_direction direction)
> >> +{
> >> +     BUG_ON(!valid_dma_direction(direction));
> >> +
> >> +     __dma_sync(phys_to_virt(dma_handle), size, direction);
> >> +}
> >> +EXPORT_SYMBOL(dma_sync_single_for_cpu);
> >> +
> >> +void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
> >> +                             size_t size, enum dma_data_direction direction)
> >> +{
> >> +     BUG_ON(!valid_dma_direction(direction));
> >> +
> >> +     __dma_sync(phys_to_virt(dma_handle), size, direction);
> >> +}
> >> +EXPORT_SYMBOL(dma_sync_single_for_device);
> >
> > More importantly: you do the same operation for both _for_cpu and _for_device.
> > I assume your CPU can never do speculative cache prefetches, so it's not
> > incorrect, but you do twice the number of invalidations and flushes that
> > you need.
> >
> > Why would you do anything for _for_cpu here?
> I am a bit confused for _for_cpu and _for_device here. I found some
> architectures like c6x and hexagon have same operation for both
> _for_cpu and _for_device as well.

(adding their maintainers to cc)

Yes, you are right, they seem to have the same bug and could see a noticeable
DMA performance improvement if they change it as well.

> I have spent some times look at other architectures and below is what
> I found. Please correct me if I am wrong, especially
> for_device():DMA_FROM_DEVICE.
> 
> _for_cpu():
> case DMA_BIDIRECTIONAL:
> case DMA_FROM_DEVICE:
>      /* invalidate cache */
> break;
> case DMA_TO_DEVICE:
>    /* do nothing */
> break;

This seems fine: for a FROM_DEVICE mapping, we have flushed all
dirty entries during the _for_device or the map operation,
so if any clean entries are around, they need to be invalidated
in order to read the data from the device.

for TO_DEVICE, we don't care about the cache, because we are
going to overwrite the data, and we don't need to do anything.

> -------------------------
> _for_device():
> case DMA_BIDIRECTIONAL:
> case DMA_TO_DEVICE:
>      /* flush and invalidate cache */
> break;
> case DMA_FROM_DEVICE:
>  /* should we invalidate cache or do nothing? */
> break;

You actually don't need to invalidate the TO_DEVICE mappings
in both _for_device and _for_cpu. You have to flush them
in for_device, and you have to invalidate them at least once,
but don't need to invalidate them again in for_cpu if you have
done that already in for_device and your CPU does not do any
speculative prefetches that might populate the dcache.

In case of for_device FROM_DEVICE, you have to invalidate or
flush the caches to ensure that no dirty cache lines are
written to memory, but only if your CPU has a write-back
cache rather than write-through.

For bidirectional mappings, you may have to flush and invalidate.

	Arnd
