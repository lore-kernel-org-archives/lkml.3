Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbaK0Cgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 21:36:36 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:62272 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaK0Cgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 21:36:35 -0500
Message-ID: <54768E23.7080406@huawei.com>
Date: Thu, 27 Nov 2014 10:36:19 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: For the problem when using swiotlb
References: <5469E26B.2010905@huawei.com> <20141121175118.GA10451@localhost> <20141121180925.GG19783@e104818-lin.cambridge.arm.com> <2166613.l2i4mdmtLA@wuerfel> <20141125105815.GB18858@e104818-lin.cambridge.arm.com> <20141125112905.GC3836@n2100.arm.linux.org.uk> <20141125122302.GC18858@e104818-lin.cambridge.arm.com>
In-Reply-To: <20141125122302.GC18858@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/25 20:23, Catalin Marinas wrote:
> On Tue, Nov 25, 2014 at 11:29:05AM +0000, Russell King - ARM Linux wrote:
>> On Tue, Nov 25, 2014 at 10:58:15AM +0000, Catalin Marinas wrote:
>>> Since we don't have a coherent_dma_supported() function, we defer the
>>> validity check of coherent_dma_mask to dma_alloc_coherent() (and here we
>>> can remove bouncing since swiotlb has relatively small buffers).
>>
>> Bouncing of coherent DMA buffers is insane; if you have to bounce them,
>> they're by definition not coherent.
> 
> "Bouncing" is not a proper term here. What I meant is not using the
> swiotlb bounce buffers for the dma_alloc_coherent(). The
> swiotlb_alloc_coherent() allows this but it doesn't do any
> copying/bouncing in such scenario (it would not make sense, as you said
> below).
> 

After the long discussion, I think the idea is clear, the drivers should set
correct dma mask and coherent dma mask to use the buffer avoiding using swiotlb,
and my case is fixed by this way.

On my aarch64 board, the coherent dma mask is always bigger than swiotlb bounce,
so dma_supported() looks no sense here, but maybe useful for other board, Thanks everyone.

Regards
Ding

>> Think about one of the common uses of coherent DMA buffers: ring buffers,
>> where both the CPU and the DMA agent write to the ring:
>>
>> - CPU writes to ring, loading address and length, then writing to the
>>   status word for the ring entry.
>> - DMA reads the ring status word, sees it owns the entry, processes it,
>>   DMA writes to the ring status word to give it back.
>>
>> What this means is that if you are bouncing the buffer, you are copying
>> it whole-sale between the CPU visible version and the DMA visible
>> version, which means that you can miss DMA updates to it.  So, bouncing
>> a coherent DMA buffer is simply not an acceptable implementation for
>> dma_alloc_coherent().
> 
> I agree, not arguing against this.
> 
>> As for validity of masks, it is defined in the DMA API documentation that
>> if a DMA mask is suitable for the streaming APIs, then it is also suitable
>> for the coherent APIs.  The reverse is left open, and so may not
>> necessarily be true.
>>
>> In other words:
>>
>> 	err = dma_set_mask(dev, mask);
>> 	if (err == 0)
>> 		assert(dma_set_coherent_mask(dev, mask) == 0);
>>
>> must always succeed, but reversing the two calls has no guarantee.
> 
> That would succeed on arm64 currently.
> 
> The problem is that swiotlb bounce buffers allow for smaller than 32-bit
> dma_mask for streaming DMA since it can do bouncing. With coherent
> allocations, we could allow the same smaller than 32-bit
> coherent_dma_mask, however allocations may fail since they fall back to
> the swiotlb reserved buffer which is relatively small.
> 
> What I want to avoid is threads like this where people ask for bigger
> swiotlb buffers for coherent allocations most likely because they do the
> wrong thing with their dma masks (or dma-ranges property). If the arm64
> dma_alloc_coherent() code avoids calling swiotlb_alloc_coherent() and
> just limits itself to ZONE_DMA, we make it clear that the swiotlb
> buffers are only used for streaming DMA (bouncing).
> 
> Once we avoid swiotlb buffers for coherent DMA, the problem is that even
> though your assertion above would pass, dma_alloc_coherent() may fail if
> coherent_dma_mask is smaller than the end of ZONE_DMA (and pfn offsets
> considered). Basically breaking the assumption that you mentioned above
> with regards to coherent_dma_mask suitability.
> 
> I think the best we can get is for dma_supported() to ignore
> swiotlb_dma_supported() and simply check for ZONE_DMA (similar to the
> arm32 one). We guarantee that swiotlb bounce buffers are within ZONE_DMA
> already, so no need for calling swiotlb_dma_supported(). If we ever have
> devices with smaller than 32-bit mask on arm64, we will have to reduce
> ZONE_DMA.
> 
>> Note that there seems to be only one driver which has different coherent
>> and streaming DMA masks today:
>>
>> drivers/media/pci/sta2x11/sta2x11_vip.c:
>>         if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(26))) {
>>         err = dma_set_coherent_mask(&vip->pdev->dev, DMA_BIT_MASK(29));
> 
> This would work if we have a ZONE_DMA of 29-bit while the swiotlb bounce
> buffer within 26-bit. If we go with the above ZONE_DMA only check, we
> would need ZONE_DMA of 26-bit.
> 


