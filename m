Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaI3XXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 19:23:07 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:65048 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaI3XXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 19:23:05 -0400
MIME-Version: 1.0
In-Reply-To: <542ABF77.1020402@hurleysoftware.com>
References: <1397567329-3771-1-git-send-email-akinobu.mita@gmail.com>
	<5426CA0A.7000806@hurleysoftware.com>
	<CAC5umyhgs8---HZLa7_DOSbqW0uPbLgqTfBweScZSR9oWbG9xg@mail.gmail.com>
	<54294C0B.1060705@hurleysoftware.com>
	<CAC5umyjP4OscSC8igVLYPEm-6gqiXt9md46sLu77Vut5UiPb=g@mail.gmail.com>
	<542ABF77.1020402@hurleysoftware.com>
Date: Wed, 1 Oct 2014 08:23:02 +0900
Message-ID: <CAC5umygXqxUx2BnFxnbmGh7OsxBBtMM1CqhKGeQiPWZwbUhF_g@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] enhance DMA CMA on x86
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-30 23:34 GMT+09:00 Peter Hurley <peter@hurleysoftware.com>:
> On 09/29/2014 10:32 AM, Akinobu Mita wrote:
>> 2014-09-29 21:09 GMT+09:00 Peter Hurley <peter@hurleysoftware.com>:
>>> On 09/27/2014 08:31 PM, Akinobu Mita wrote:
>>>> 2014-09-27 23:30 GMT+09:00 Peter Hurley <peter@hurleysoftware.com>:
>>>>> On 04/15/2014 09:08 AM, Akinobu Mita wrote:
>>>>>> This patch set enhances the DMA Contiguous Memory Allocator on x86.
>>>
>>> [...]
>>>
>>>>> What this patchset does is restrict all iommu configurations which can
>>>>> map all of system memory to one _very_ small physical region, thus disabling
>>>>> the whole point of an iommu.
>>>>>
>>>>> Now I know why my GPU is causing paging to disk! And why my RAID controller
>>>>> stalls for ages when I do a git log at the same time as a kernel build!
>>>>
>>>> The solution I have for this is that instead of trying to
>>>> dma_alloc_from_contiguous() firstly, call alloc_pages() in dma_alloc_coherent().
>>>> dma_alloc_from_contiguous() should be called only when alloc_pages() is failed
>>>> or DMA_ATTR_FORCE_CONTIGUOUS is specified in dma_attr.
>>>
>>> Why is all this extra complexity being added when there are no X86 users
>>> of DMA_ATTR_FORCE_CONTIGUOUS?
>>
>> I misunderstood DMA_ATTR_FORCE_CONTIGUOUS.  It is specified to request
>> that underlaying DMA mapping span physically contiguous with IOMMU.
>> But current alloc_dma_coherent() for intel-iommu always returns
>> physically contiguous memory, so it is ignored on x86.
>>
>>>>> And the apparent goal of this patchset is to enable DMA allocation below
>>>>> 4GB, which is already supported in the existing page allocator with the
>>>>> GFP_DMA32 flag?!
>>>>
>>>> The goal of this patchset is to enable huge DMA allocation which
>>>> alloc_pages() can't (> MAX_ORDER) for the devices that require it.
>>>
>>> What x86 devices need > MAX_ORDER DMA allocation and why can't they allocate
>>> directly from dma_alloc_from_contiguous()?
>>
>> I need this for UFS unified memory extension which is apparently not in
>> mainline for now.
>> http://www.jedec.org/standards-documents/docs/jesd220-1
>> http://www.jedec.org/sites/default/files/T_Fujisawa_MF_2013.pdf
>>
>> But there must be some other use cases on x86, too.  Because I have
>> received several emails privately from developers who care its status.
>>
>> And allocating directly from dma_alloc_from_contiguous() in the driver
>> doesn't work with IOMMU, as it just returns memory regoin and doesn't
>> create DMA mapping.
>
>
> I read the UFS Unified Memory Extension v1.0 (JESD220-1) specification and
> it is not clear to me that using DMA mapping is the right approach to
> supporting UM, at least on x86.

Without DMA mapping, there is no way for the devices to access host
memory.  Unified memory extension requires a single contiguous memory
region instead of multiple scattered mapping.

> And without a mainline user, the merits of this approach are not evident.
> I cannot even find a production x86 UFS controller, much less one that
> supports UME.
>
> The only PCI UFS controller I could find (and that mainline supports) is
> Samsung's x86 FPGA-based test unit for developing UFS devices in a x86 test
> environment, and not a production x86 design.
>
> Samsung's own roadmap (http://www.slideshare.net/linaroorg/next-gen-mobilestorageufs)
> mentions nothing about bringing UFS to x86 designs.
>
> Unless there's something else I've missed, I don't think these patches
> belong in mainline.

Removing CONFIG_CMA_DMA support from x86_64 will disappoint me, but it's
personal opinion.  FWIW, MIPS also starts supporting it in linux-next.
