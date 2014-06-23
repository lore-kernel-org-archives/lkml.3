Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbaFWNRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:17:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587AbaFWNRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:17:33 -0400
Message-ID: <1403529423.755.49.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64: make CONFIG_ZONE_DMA user settable
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 23 Jun 2014 09:17:03 -0400
In-Reply-To: <20140623110937.GB15907@arm.com>
References: <1403499924-11214-1-git-send-email-msalter@redhat.com>
	 <20140623110937.GB15907@arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 12:09 +0100, Catalin Marinas wrote:
> On Mon, Jun 23, 2014 at 06:05:24AM +0100, Mark Salter wrote:
> > Commit 19e7640d1f (arm64: Replace ZONE_DMA32 with ZONE_DMA)
> > moves support for 32-bit DMA addressing into ZONE_DMA and renames
> > CONFIG_ZONE_DMA32 to CONFIG_ZONE_DMA.
> > 
> > Commit 2d5a5612bc (arm64: Limit the CMA buffer to 32-bit if ZONE_DMA)
> > forces the CMA buffer to be 32-bit addressable if CONFIG_ZONE_DMA is
> > defined.
> > 
> > These two patches pose a problem for platforms which have no 32-bit
> > addressable DRAM.
> 
> It's actually the bus/dma address that needs to be 32-bit rather than
> the DRAM as seen by the CPU (which can be beyond 32-bit like the
> Keystone platform).

Ah, right.

> 
> > If CONFIG_ZONE_DMA is turned on for such platforms,
> > CMA is unable to reserve a buffer for allocations. CONFIG_ZONE_DMA is
> > not user settable however, so there is no way to turn it off without
> > editing arch/arm64/Kconfig. Even if one edits Kconfig to turn off
> > CONFIG_ZONE_DMA, the kernel fails to build with such a config:
> > 
> >   arch/arm64/mm/init.c: In function ‘zone_sizes_init’:
> >   arch/arm64/mm/init.c:76:13: error: ‘ZONE_DMA’ undeclared (first use in this function)
> >      zone_size[ZONE_DMA] = max_dma - min;
> >                ^
> > 
> > This patch makes CONFIG_ZONE_DMA user settable and fixes the kernel
> > build when it is turned off.
> 
> The reason I left CONFIG_ZONE_DMA not user settable is because on arm64
> we aim for single Image by default. So ZONE_DMA would most likely be
> needed on at least one platform. Even with ZONE_DMA it's just a guess
> without proper system topology description. dma_to_phys() just takes a
> NULL argument for device when trying to guess the physical address for a
> 32-bit DMA mask (and 32-bit devices may have some physical offset wired
> already).
> 
> With the CMA fix, does the kernel work properly with a zero sized DMA
> zone? Any GFP_DMA allocations will fail, including the swiotlb bounce
> buffer. It may be fine if no devices require 32-bit DMA memory but I
> wonder whether on such platforms it would be better to simply add
> all the memory to ZONE_DMA.

The kernel works, but there are no devices needing GFP_DMA. And yes,
the swiotlb init fails because of no GFP_DMA. But that has always
been the case on platforms with no 32-bit memory.

> 
> Which gets us back to finding a way for describing such system topology
> in hardware. We may be able to find a way with DT but unlikely for ACPI.
> 
> My proposal (in the absence of any kind of description) is to still
> create a ZONE_DMA if we have DMA memory below 32-bit, otherwise just add
> everything (>32-bit) to ZONE_DMA. Basically an extension from your CMA
> patch, make dma_phys_limit static in that file and set it to
> memblock_end_of_DRAM() if no 32-bit DMA. Re-use it in the
> zone_sizes_init() function for ZONE_DMA (maybe with a pr_info for no
> 32-bit only DMA zone).

There's a performance issue with all memory being in ZONE_DMA. It means
all normal allocations will fail on ZONE_NORMAL and then have to fall
back to ZONE_DMA. It would be better to put some percentage of memory
in ZONE_DMA.



