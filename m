Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbbAVDpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 22:45:38 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:46887 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbbAVDpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 22:45:30 -0500
MIME-Version: 1.0
In-Reply-To: <54B4FF30.2030607@samsung.com>
References: <ffdc5455d698d2525f2d126d0adabf9418fd76b1.1418990609.git.robin.murphy@arm.com>
 <54B4FF30.2030607@samsung.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 22 Jan 2015 09:15:08 +0530
Message-ID: <CAO_48GHXaNE4m5TErg0=nkDZrvi65mp8u4h7ao011OL4mhSDUw@mail.gmail.com>
Subject: Re: [PATCH RESEND] dma-mapping: tidy up dma_parms default handling
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>, Will Deacon <will.deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        joro@8bytes.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        iommu@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robin,

On 13 January 2015 at 16:49, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> Hello,
>
> On 2015-01-09 17:56, Robin Murphy wrote:
>>
>> Many DMA controllers and other devices set max_segment_size to
>> indicate their scatter-gather capability, but have no interest in
>> segment_boundary_mask. However, the existence of a dma_parms structure
>> precludes the use of any default value, leaving them as zeros (assuming
>> a properly kzalloc'ed structure). If a well-behaved IOMMU (or SWIOTLB)
>> then tries to respect this by ensuring a mapped segment does not cross
>> a zero-byte boundary, hilarity ensues.
>>
>> Since zero is a nonsensical value for either parameter, treat it as an
>> indicator for "default", as might be expected. In the process, clean up
>> a bit by replacing the bare constants with slightly more meaningful
>> macros and removing the superfluous "else" statements.
>>
>> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
>
>
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

Please feel free to add my
Reviewed-by: Sumit Semwal <sumit.semwal@linaro.org>
>
>> ---
>>
>> Hi, various maintainers from Git logs ;)
>>
>> This one's a bit tricky to find a home for - I think technically it's
>> probably an IOMMU patch, but then the long-underlying problem doesn't
>> seem to have blown up anything until arm64, and my motivation is to
>> make bits of Juno work, which seems to nudge it towards arm64/arm-soc
>> territory. Could anyone suggest which tree is most appropriate?
>>
>> Thanks,
>> Robin.
>>
>>
>>   include/linux/dma-mapping.h | 17 ++++++++++-------
>>   1 file changed, 10 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
>> index c3007cb..99ba736 100644
>> --- a/include/linux/dma-mapping.h
>> +++ b/include/linux/dma-mapping.h
>> @@ -141,7 +141,9 @@ static inline void arch_teardown_dma_ops(struct device
>> *dev) { }
>>     static inline unsigned int dma_get_max_seg_size(struct device *dev)
>>   {
>> -       return dev->dma_parms ? dev->dma_parms->max_segment_size : 65536;
>> +       if (dev->dma_parms && dev->dma_parms->max_segment_size)
>> +               return dev->dma_parms->max_segment_size;
>> +       return SZ_64K;
>>   }
>>     static inline unsigned int dma_set_max_seg_size(struct device *dev,
>> @@ -150,14 +152,15 @@ static inline unsigned int
>> dma_set_max_seg_size(struct device *dev,
>>         if (dev->dma_parms) {
>>                 dev->dma_parms->max_segment_size = size;
>>                 return 0;
>> -       } else
>> -               return -EIO;
>> +       }
>> +       return -EIO;
>>   }
>>     static inline unsigned long dma_get_seg_boundary(struct device *dev)
>>   {
>> -       return dev->dma_parms ?
>> -               dev->dma_parms->segment_boundary_mask : 0xffffffff;
>> +       if (dev->dma_parms && dev->dma_parms->segment_boundary_mask)
>> +               return dev->dma_parms->segment_boundary_mask;
>> +       return DMA_BIT_MASK(32);
>>   }
>>     static inline int dma_set_seg_boundary(struct device *dev, unsigned
>> long mask)
>> @@ -165,8 +168,8 @@ static inline int dma_set_seg_boundary(struct device
>> *dev, unsigned long mask)
>>         if (dev->dma_parms) {
>>                 dev->dma_parms->segment_boundary_mask = mask;
>>                 return 0;
>> -       } else
>> -               return -EIO;
>> +       }
>> +       return -EIO;
>>   }
>>     #ifndef dma_max_pfn
>
>
> Best regards
> --
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Thanks and regards,

Sumit Semwal
Kernel Team Lead - Linaro Mobile Group
Linaro.org │ Open source software for ARM SoCs
