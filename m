Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaF0QEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:04:35 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:27101 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751150AbaF0QEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:04:34 -0400
Date: Fri, 27 Jun 2014 17:04:10 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: David Rientjes <rientjes@google.com>
Cc: "msalter@redhat.com" <msalter@redhat.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: fix CONFIG_ZONE_DMA on systems with no 32-bit
 addressable DRAM
Message-ID: <20140627160410.GM15296@arm.com>
References: <1403499940-11258-1-git-send-email-msalter@redhat.com>
 <alpine.DEB.2.02.1406241718210.22030@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406241718210.22030@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 01:26:02AM +0100, David Rientjes wrote:
> On Mon, 23 Jun 2014, Mark Salter wrote:
> 
> > Commit 2d5a5612bc (arm64: Limit the CMA buffer to 32-bit if ZONE_DMA)
> > forces the CMA buffer to be 32-bit addressable if CONFIG_ZONE_DMA is
> > defined. This breaks CMA on platforms with no 32-bit addressable DRAM.
> > This patch checks to make sure there is 32-bit addressable DRAM before
> > setting the 32-bit limit. If there is none, no limit is placed on the
> > CMA buffer. This allows a single kernel (with CONFIG_ZONE_DMA defined)
> > to support platforms requiring the 32-bit limit and platforms with no
> > 32-bit limit.
> > 
> > Signed-off-by: Mark Salter <msalter@redhat.com>
> > ---
> >  arch/arm64/mm/init.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> > index c5415e2..2925576 100644
> > --- a/arch/arm64/mm/init.c
> > +++ b/arch/arm64/mm/init.c
> > @@ -149,8 +149,17 @@ void __init arm64_memblock_init(void)
> >  	early_init_fdt_scan_reserved_mem();
> >  
> >  	/* 4GB maximum for 32-bit only capable devices */
> > -	if (IS_ENABLED(CONFIG_ZONE_DMA))
> > +	if (IS_ENABLED(CONFIG_ZONE_DMA)) {
> >  		dma_phys_limit = dma_to_phys(NULL, DMA_BIT_MASK(32)) + 1;
> > +		/*
> > +		 * If platform doesn't have DRAM within the dma_phys_limit,
> > +		 * remove the limit altogether. This allows one kernel (with
> > +		 * CONFIG_ZONE_DMA defined) to support platforms with 32-bit
> > +		 * only devices and platforms with no 32-bit DRAM.
> > +		 */
> > +		if (dma_phys_limit <= memblock_start_of_DRAM())
> > +			dma_phys_limit = 0;
> > +	}
> >  	dma_contiguous_reserve(dma_phys_limit);
> >  
> >  	memblock_allow_resize();
> 
> It is a shame that we have very similar logic, all dependent on 
> memblock_start_of_DRAM(), in both zone_sizes_init() and 
> arm64_memblock_init() and the latter having to be called before the 
> former.  I assume there's no way to make this cleaner in the bootstrap 
> code so the dma_to_phys(NULL, DMA_BIT_MASK(32)) + 1 limit can be handled 
> properly in a single location?

Probably and I suggested something along the lines of only calculating
it once in reply to the "[PATCH] arm64: make CONFIG_ZONE_DMA user
settable" message. I'll follow up on the other thread (Mark considers
there's a penalty issue with all memory in the DMA zone).

-- 
Catalin
