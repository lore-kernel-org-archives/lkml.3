Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3KTXfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 18:35:36 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:62114 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3KTXfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 18:35:34 -0500
MIME-Version: 1.0
In-Reply-To: <20131120140005.GA9124@phenom.dumpdata.com>
References: <1384903939-3371-1-git-send-email-akinobu.mita@gmail.com>
	<20131120140005.GA9124@phenom.dumpdata.com>
Date: Thu, 21 Nov 2013 08:35:34 +0900
Message-ID: <CAC5umyh93+8Hea-DJBGJsDeiVSWhzRyExnSrARen4_KOyZM6Qg@mail.gmail.com>
Subject: Re: [PATCH] x86: enable DMA CMA with swiotlb
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/20 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>:
> On Wed, Nov 20, 2013 at 08:32:19AM +0900, Akinobu Mita wrote:
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
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: x86@kernel.org
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> ---
>>  arch/x86/Kconfig               | 2 +-
>>  arch/x86/include/asm/swiotlb.h | 7 +++++++
>>  arch/x86/kernel/amd_gart_64.c  | 2 +-
>>  arch/x86/kernel/pci-swiotlb.c  | 9 ++++++---
>>  arch/x86/pci/sta2x11-fixup.c   | 6 ++----
>>  include/linux/swiotlb.h        | 2 ++
>>  lib/swiotlb.c                  | 2 +-
>
> Looks OK, but before this goes anywhere I need to run regression tests
> on IA64 and the other users of SWIOTLB.

Thanks a lot for your review.
