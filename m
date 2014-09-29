Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbaI2Oc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:32:58 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:64118 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbaI2Ocz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:32:55 -0400
MIME-Version: 1.0
In-Reply-To: <54294C0B.1060705@hurleysoftware.com>
References: <1397567329-3771-1-git-send-email-akinobu.mita@gmail.com>
	<5426CA0A.7000806@hurleysoftware.com>
	<CAC5umyhgs8---HZLa7_DOSbqW0uPbLgqTfBweScZSR9oWbG9xg@mail.gmail.com>
	<54294C0B.1060705@hurleysoftware.com>
Date: Mon, 29 Sep 2014 23:32:55 +0900
Message-ID: <CAC5umyjP4OscSC8igVLYPEm-6gqiXt9md46sLu77Vut5UiPb=g@mail.gmail.com>
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

2014-09-29 21:09 GMT+09:00 Peter Hurley <peter@hurleysoftware.com>:
> On 09/27/2014 08:31 PM, Akinobu Mita wrote:
>> 2014-09-27 23:30 GMT+09:00 Peter Hurley <peter@hurleysoftware.com>:
>>> On 04/15/2014 09:08 AM, Akinobu Mita wrote:
>>>> This patch set enhances the DMA Contiguous Memory Allocator on x86.
>
> [...]
>
>>> What this patchset does is restrict all iommu configurations which can
>>> map all of system memory to one _very_ small physical region, thus disabling
>>> the whole point of an iommu.
>>>
>>> Now I know why my GPU is causing paging to disk! And why my RAID controller
>>> stalls for ages when I do a git log at the same time as a kernel build!
>>
>> The solution I have for this is that instead of trying to
>> dma_alloc_from_contiguous() firstly, call alloc_pages() in dma_alloc_coherent().
>> dma_alloc_from_contiguous() should be called only when alloc_pages() is failed
>> or DMA_ATTR_FORCE_CONTIGUOUS is specified in dma_attr.
>
> Why is all this extra complexity being added when there are no X86 users
> of DMA_ATTR_FORCE_CONTIGUOUS?

I misunderstood DMA_ATTR_FORCE_CONTIGUOUS.  It is specified to request
that underlaying DMA mapping span physically contiguous with IOMMU.
But current alloc_dma_coherent() for intel-iommu always returns
physically contiguous memory, so it is ignored on x86.

>>> And the apparent goal of this patchset is to enable DMA allocation below
>>> 4GB, which is already supported in the existing page allocator with the
>>> GFP_DMA32 flag?!
>>
>> The goal of this patchset is to enable huge DMA allocation which
>> alloc_pages() can't (> MAX_ORDER) for the devices that require it.
>
> What x86 devices need > MAX_ORDER DMA allocation and why can't they allocate
> directly from dma_alloc_from_contiguous()?

I need this for UFS unified memory extension which is apparently not in
mainline for now.
http://www.jedec.org/standards-documents/docs/jesd220-1
http://www.jedec.org/sites/default/files/T_Fujisawa_MF_2013.pdf

But there must be some other use cases on x86, too.  Because I have
received several emails privately from developers who care its status.

And allocating directly from dma_alloc_from_contiguous() in the driver
doesn't work with IOMMU, as it just returns memory regoin and doesn't
create DMA mapping.
