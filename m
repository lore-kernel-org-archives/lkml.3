Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaAPXcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:32:12 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:39384 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaAPXcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:32:10 -0500
MIME-Version: 1.0
In-Reply-To: <20140115201224.GD5201@phenom.dumpdata.com>
References: <1389708830-5841-1-git-send-email-akinobu.mita@gmail.com>
	<1389708830-5841-3-git-send-email-akinobu.mita@gmail.com>
	<20140115201224.GD5201@phenom.dumpdata.com>
Date: Fri, 17 Jan 2014 08:32:09 +0900
Message-ID: <CAC5umyitWHvWiWn9B3wtTNBhbO7Rz_ghqmxhwu9caq40msnfAA@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] x86: enable DMA CMA with swiotlb
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/16 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>:
> On Tue, Jan 14, 2014 at 11:13:47PM +0900, Akinobu Mita wrote:
>> The DMA Contiguous Memory Allocator support on x86 is disabled when
>> swiotlb config option is enabled.  So DMA CMA is always disabled on
>> x86_64 because swiotlb is always enabled.  This attempts to support
>> for DMA CMA with enabling swiotlb config option.
>>
>> The contiguous memory allocator on x86 is integrated in the function
>> dma_generic_alloc_coherent() which is .alloc callback in nommu_dma_ops
>> for dma_alloc_coherent().
>>
>> x86_swiotlb_alloc_coherent() which is .alloc callback in swiotlb_dma_ops
>> tries to allocate with dma_generic_alloc_coherent() firstly and then
>> swiotlb_alloc_coherent() is called as a fallback.
>>
>> The main part of supporting DMA CMA with swiotlb is that changing
>> x86_swiotlb_free_coherent() which is .free callback in swiotlb_dma_ops
>> for dma_free_coherent() so that it can distinguish memory allocated by
>> dma_generic_alloc_coherent() from one allocated by swiotlb_alloc_coherent()
>> and release it with dma_generic_free_coherent() which can handle contiguous
>> memory.  This change requires making is_swiotlb_buffer() global function.
>>
>> This also needs to change .free callback in the dma_map_ops for amd_gart
>> and sta2x11, because these dma_ops are also using
>> dma_generic_alloc_coherent().
>>
>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: Don Dutile <ddutile@redhat.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Andi Kleen <andi@firstfloor.org>
>> Cc: x86@kernel.org
>> Cc: iommu@lists.linux-foundation.org
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>> No change from the previous version
>>
>>  arch/x86/Kconfig               | 2 +-
>>  arch/x86/include/asm/swiotlb.h | 7 +++++++
>>  arch/x86/kernel/amd_gart_64.c  | 2 +-
>>  arch/x86/kernel/pci-swiotlb.c  | 9 ++++++---
>>  arch/x86/pci/sta2x11-fixup.c   | 6 ++----
>>  include/linux/swiotlb.h        | 2 ++
>>  lib/swiotlb.c                  | 2 +-
>
> It looks reasonable from my perspective (as swiotlb maintainer).
>
> Not too thrilled about the  'is_swiotlb_buffer' but that code is
> quite small so it should be fast enough.

Thanks.  Can I get your Acked-by for this patch?
