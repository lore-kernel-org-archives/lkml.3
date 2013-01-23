Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab3AWHYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 02:24:15 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:38481 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab3AWHYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 02:24:12 -0500
Message-ID: <50FF9004.50807@synopsys.com>
Date: Wed, 23 Jan 2013 12:53:48 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mark Salter <msalter@redhat.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        <linux-arch@vger.kernel.org>, <linux-c6x-dev@linux-c6x.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-c6x-dev] [PATCH 3/9] c6x: Provide dma_mmap_coherent()
 and dma_get_sgtable()
References: <1358073890-3610-1-git-send-email-geert@linux-m68k.org>  <1358073890-3610-3-git-send-email-geert@linux-m68k.org>  <1358177872.4357.53.camel@t520.localdomain> <50F4D83A.7020803@synopsys.com>  <CAMuHMdWjZAY19GPpjoXKfWb3pOp2RbZXDvb4nr5pMmjEMFuB4w@mail.gmail.com>  <50F56286.8070200@samsung.com>  <1358269008.10591.11.camel@dabdike.int.hansenpartnership.com>  <50FE66C6.4040900@samsung.com> <1358850164.2387.16.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1358850164.2387.16.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013 03:52 PM, James Bottomley wrote:
> On Tue, 2013-01-22 at 11:15 +0100, Marek Szyprowski wrote:
>> Hello,
>>
>> On 1/15/2013 5:56 PM, James Bottomley wrote:
>>> On Tue, 2013-01-15 at 15:07 +0100, Marek Szyprowski wrote:
>>>> Hello,
>>>>
>>>> On 1/15/2013 10:13 AM, Geert Uytterhoeven wrote:
>>>>> Marek?
>>>>>
>>>>> On Tue, Jan 15, 2013 at 5:16 AM, Vineet Gupta
>>>>> <Vineet.Gupta1@synopsys.com> wrote:
>>>>>> On Monday 14 January 2013 09:07 PM, Mark Salter wrote:
>>>>>>> On Sun, 2013-01-13 at 11:44 +0100, Geert Uytterhoeven wrote:
>>>>>>>> c6x/allmodconfig (assumed):
>>>>>>>>
>>>>>>>> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
>>>>>>>> drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ‘dma_mmap_coherent’
>>>>>>>> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
>>>>>>>> drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ‘dma_get_sgtable’
>>>>>>>>
>>>>>>>> For architectures using dma_map_ops, dma_mmap_coherent() and
>>>>>>>> dma_get_sgtable() are provided in <asm-generic/dma-mapping-common.h>.
>>>>>>>>
>>>>>>>> C6x does not use dma_map_ops, hence it should implement them as inline
>>>>>>>> stubs using dma_common_mmap() and dma_common_get_sgtable().
>>>>>>>>
>>>>>>> So are dma_mmap_coherent() and dma_get_sgtable() part of the DMA API
>>>>>>> now? I don't them in Documentation/DMA*.txt anywhere.
>>>>>>>
>>>>>>> Why does the default dma_common_mmap() for !CONFIG_MMU return an
>>>>>>> error?
>>>>>>>
>>>>>>> Wouldn't it be better to provide default implementations that an arch
>>>>>>> could override rather than having to patch all "no dma_map_ops"
>>>>>>> architectures?
>>>>>>>
>>>>>> Speaking for the still-reviewed ARC Port, I completely agree with Mark.
>>>>
>>>> dma_mmap_coherent() was partially in the DMA mapping API for some time, but
>>>> it was available only on a few architectures (afair ARM, powerpc and avr32).
>>>> This caused significant problems for writing unified device drivers or some
>>>> device helper modules which were aimed to work on more than one
>>>> architecture.
>>>>
>>>> dma_get_sgtable() is an extension discussed during the Linaro meetings. It
>>>> is required to correctly implement buffer sharing between device driver
>>>> without hacks or any assumptions about memory layout in the device drivers.
>>>>
>>>> I have implemented some generic code for both of those two functions,
>>>> keeping
>>>> in mind that on some hardware architectures (like already mentioned VIVT)
>>>> it might be not possible to provide coherent mapping to userspace. It is
>>>> perfectly fine for those functions to return an error in such case.
>>>
>>> It's not possible on VIPT either.  This means that the API is unusable
>>> on quite a large number of architectures.  Surely, if we're starting to
>>> write drivers using this, we need to fix the API before more people try
>>> to use it.
>>
>> I don't get this one. On ARM coherent mappings are implemented as 
>> non-cacheable,
>> both in userspace and kernel-space, so having a coherent mapping is 
>> possible on
>> VIPT architecture.
> 
> Only if you have an uncacheable bit in the architecture page table ...
> which some of ours don't.
> 
> Regardless, setting pages Uncacheable is really a hack job on shared
> buffers because it creates a huge slow down .... like an order of
> magnitude more than simply copying the page, which I believe is the
> current solution.

IMHO, setting the page uncached, even for shared buffer, is the only option for
arches with non snooping DMA - independent of VIPT issue.

-Vineet
