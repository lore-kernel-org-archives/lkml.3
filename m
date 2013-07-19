Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935419Ab3GSIDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:03:41 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:62526 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935394Ab3GSIDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:03:33 -0400
MIME-Version: 1.0
In-Reply-To: <51E7EEDC.9080003@samsung.com>
References: <1373880874-9270-1-git-send-email-ricardo.ribalda@gmail.com>
 <51E65577.7010403@samsung.com> <CAPybu_3Je7+0Qh2OdptncnxC12G15Scad+A3yUeF898sVWKo8w@mail.gmail.com>
 <51E69F49.10500@samsung.com> <CAPybu_0b9ADaUFFHuw=tKkVR4fiu9bGNJVgy4MGbuE-zAA9sZQ@mail.gmail.com>
 <51E7960C.8050707@samsung.com> <CAPybu_36Pe5+RO+qmUXTQtbESnrJg4hwey1mXXRH4urc9i4GAg@mail.gmail.com>
 <51E7EEDC.9080003@samsung.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 19 Jul 2013 10:03:12 +0200
Message-ID: <CAPybu_1px6n4=bcF0=KyBVR4NR=ihrnDQTdfTH+wuWJ8UaZCHg@mail.gmail.com>
Subject: Re: [PATCH] videobuf2-dma-sg: Minimize the number of dma segments
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Marek

I have prepared a new set of patches, please take a look to them. The
series implements the coherent allocation, segments compaction and use
of sg_table, it does not implement the dma_map/dma_unmap/dma_sync, I
rather work on that one when you are back.

Thanks for your help

On Thu, Jul 18, 2013 at 3:34 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello,
>
>
> On 7/18/2013 9:39 AM, Ricardo Ribalda Delgado wrote:
>>
>> Hello again:
>>
>> I have started to implemt it, but I think there is more hidden work in
>> this task as it seems. In order to call dma_map_sg and
>> max_dma_segment_size I need acess to the struct device, but (correct
>> me if I am wrong), vb2 is device agnostic. Adding the above
>> functionality will mean not only updating marvell-ccic and solo6x10,
>> but updating all the vb2 buffers.
>
>
> For getting device pointer, vb2-dma-sg need to be extended with so called
> 'allocator context'. Please check how it is done in vb2-dma-contig
> (vb2_dma_contig_init_ctx() function).
>
>
>
>> Also after some readings, maybe the sg compactation should not be done
>> here, but in dma_map_sg. According to the doc:
>>
>> """
>> The implementation is free to merge several consecutive sglist entries
>> into one (e.g. if DMA mapping is done with PAGE_SIZE granularity, any
>> consecutive sglist entries can be merged into one provided the first one
>> ends and the second one starts on a page boundary - in fact this is a huge
>> advantage for cards which either cannot do scatter-gather or have very
>> limited number of scatter-gather entries) and returns the actual number
>> of sg entries it mapped them to. On failure 0 is returned.
>> """
>>
>> So, my proposal would be to alloc with alloc_pages to try to get
>> memory as coherent as possible, then split the page, set the sg in
>> PAGE_SIZE lenghts, and then let the dma_map_sg do its magic. if it
>> doesnt do compactation, fix dma_map_sg, so more driver could take
>> advantage of it.
>
>
> Right, this approach is probably the best one, but this way you would need
> to do the compaction in every dma-mapping implementation for every supported
> architecture. IMHO vb2-dma-sg can help dma-mapping by at least by allocating
> memory in larger chunks and constructing shorter scatter list. Updating
> dma-mapping functions across all architectures is a lot of work and testing,
> so for initial version we should focus on vb2-dma-sg. Memory allocators
> already do some work to ease mapping a buffer to dma space.
>
>
>> I could also of course fix marvell-ccic and solo6x10 to use sg_table.
>>
>> Does anything of this make sense?
>
>
> I would also like to help you as much as possible, but for the next 10 days
> I will be not available for both personal reasons and holidays. If you have
> any questions, feel free to leave them on my mail, I will reply asap I get
> back.
>
>
> Best regards
> --
> Marek Szyprowski
> Samsung R&D Institute Poland
>
>



-- 
Ricardo Ribalda
