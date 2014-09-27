Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaI0Oar (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 10:30:47 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33896 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752180AbaI0Oap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 10:30:45 -0400
Message-ID: <5426CA0A.7000806@hurleysoftware.com>
Date: Sat, 27 Sep 2014 10:30:34 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH v3 0/5] enhance DMA CMA on x86
References: <1397567329-3771-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1397567329-3771-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 09:08 AM, Akinobu Mita wrote:
> This patch set enhances the DMA Contiguous Memory Allocator on x86.
> 
> Currently the DMA CMA is only supported with pci-nommu dma_map_ops
> and furthermore it can't be enabled on x86_64.  But I would like to
> allocate big contiguous memory with dma_alloc_coherent() and tell it
> to the device that requires it, regardless of which dma mapping
> implementation is actually used in the system.
> 
> So this makes it work with swiotlb and intel-iommu dma_map_ops, too.
> And this also extends "cma=" kernel parameter to specify placement
> constraint by the physical address range of memory allocations.  For
> example, CMA allocates memory below 4GB by "cma=64M@0-4G", it is
> required for the devices only supporting 32-bit addressing on 64-bit
> systems without iommu.
> 
> * Changes from v2
> - Rebased on current Linus tree
> - Add Acked-by line
> - Fix gfp flags check for __GFP_ATOMIC, reported by Marek Szyprowski
> - Avoid CMA area on highmem with cma= option, reported by Marek Szyprowski
> 
> * Changes from v1
> - fix dma_alloc_coherent() with __GFP_ZERO
> - add placement specifier for "cma=" kernel parameter
> 
> Akinobu Mita (5):
>   x86: make dma_alloc_coherent() return zeroed memory if CMA is enabled
>   x86: enable DMA CMA with swiotlb
>   intel-iommu: integrate DMA CMA
>   memblock: introduce memblock_alloc_range()
>   cma: add placement specifier for "cma=" kernel parameter

This patchset breaks every x86 iommu configuration when CONFIG_DMA_CMA is
on, which is the base configuration for Ubuntu x86 and amd64 distro kernels.

Granted, the patchset leveraged existing code from the nommu configuration,
but that base (ie., calling dma_alloc_from_contiguous() in
dma_generic_alloc_config()) was an ill-conceived test configuration designed
to allow ARM developers to validate the CMA allocator on x86 boxen and
KVM guests, not as a general-purpose replacement for the existing page
allocator. The test code should have had a separate CONFIG_ knob.

What this patchset does is restrict all iommu configurations which can
map all of system memory to one _very_ small physical region, thus disabling
the whole point of an iommu.

Now I know why my GPU is causing paging to disk! And why my RAID controller
stalls for ages when I do a git log at the same time as a kernel build!

And the apparent goal of this patchset is to enable DMA allocation below
4GB, which is already supported in the existing page allocator with the
GFP_DMA32 flag?!

Regards,
Peter Hurley
