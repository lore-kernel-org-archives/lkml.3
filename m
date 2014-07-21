Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbaGUV5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:57:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbaGUV5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:57:16 -0400
Message-ID: <1405979809.25580.133.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64: make CONFIG_ZONE_DMA user settable
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jul 2014 17:56:49 -0400
In-Reply-To: <20140718110718.GC19850@arm.com>
References: <1403499924-11214-1-git-send-email-msalter@redhat.com>
	 <20140623110937.GB15907@arm.com> <1403529423.755.49.camel@deneb.redhat.com>
	 <20140624141455.GE4489@arm.com> <1403620714.755.69.camel@deneb.redhat.com>
	 <20140718110718.GC19850@arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-18 at 12:07 +0100, Catalin Marinas wrote:
> On Tue, Jun 24, 2014 at 03:38:34PM +0100, Mark Salter wrote:
> > On Tue, 2014-06-24 at 15:14 +0100, Catalin Marinas wrote:
> > > On Mon, Jun 23, 2014 at 02:17:03PM +0100, Mark Salter wrote:
> > > > On Mon, 2014-06-23 at 12:09 +0100, Catalin Marinas wrote:
> > > > > My proposal (in the absence of any kind of description) is to still
> > > > > create a ZONE_DMA if we have DMA memory below 32-bit, otherwise just add
> > > > > everything (>32-bit) to ZONE_DMA. Basically an extension from your CMA
> > > > > patch, make dma_phys_limit static in that file and set it to
> > > > > memblock_end_of_DRAM() if no 32-bit DMA. Re-use it in the
> > > > > zone_sizes_init() function for ZONE_DMA (maybe with a pr_info for no
> > > > > 32-bit only DMA zone).
> > > > 
> > > > There's a performance issue with all memory being in ZONE_DMA. It means
> > > > all normal allocations will fail on ZONE_NORMAL and then have to fall
> > > > back to ZONE_DMA. It would be better to put some percentage of memory
> > > > in ZONE_DMA.
> > > 
> > > Is the performance penalty real or just theoretical? I haven't run any
> > > benchmarks myself.
> > 
> > It is real insofar as you must eat cycles eliminating ZONE_NORMAL from
> > consideration in the page allocation hot path. How much that really
> > costs, I don't know. But it seems like it could be easily avoided by
> > limiting ZONE_DMA size. Is there any reason it needs to be larger than
> > 4GiB?
> 
> Basically ZONE_DMA should allow a 32-bit dma mask. When memory starts
> above 4G, in the absence of an IOMMU, it is likely that 32-bit devices
> get some offset for the top bits to be able to address the bottom of the
> memory. The problem is that dma_to_phys() that early in the kernel has
> no idea about DMA offsets until later (they can be specified in DT per
> device).
> 
> The patch belows tries to guess a DMA offset and use the bottom 32-bit
> of the DRAM as ZONE_DMA.
> 
> -------8<-----------------------
> 
> From 133656f8378dbb838ad5f12ea29aa9303d7ca922 Mon Sep 17 00:00:00 2001
> From: Catalin Marinas <catalin.marinas@arm.com>
> Date: Fri, 18 Jul 2014 11:54:37 +0100
> Subject: [PATCH] arm64: Create non-empty ZONE_DMA when DRAM starts above 4GB
> 
> ZONE_DMA is created to allow 32-bit only devices to access memory in the
> absence of an IOMMU. On systems where the memory starts above 4GB, it is
> expected that some devices have a DMA offset hardwired to be able to
> access the bottom of the memory. Linux currently supports DT bindings
> for the DMA offsets but they are not (easily) available early during
> boot.
> 
> This patch tries to guess a DMA offset and assumes that ZONE_DMA
> corresponds to the 32-bit mask above the start of DRAM.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Mark Salter <msalter@redhat.com>
> ---

Tested-by: Mark Salter <msalter@redhat.com>

Thanks.


