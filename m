Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaBSAEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:04:01 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41744 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750851AbaBSAD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:03:59 -0500
Date: Wed, 19 Feb 2014 00:03:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        James Bottomley <James.Bottomley@parallels.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, ARM SoC <arm@kernel.org>
Subject: Re: [GIT PULL] ARM fixes
Message-ID: <20140219000352.GP21483@n2100.arm.linux.org.uk>
References: <20140217234644.GA5171@rmk-PC.arm.linux.org.uk> <CA+55aFy7ApiQRudxPAd3v5k_apppxRnePHb1HZPH13erqhmX=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy7ApiQRudxPAd3v5k_apppxRnePHb1HZPH13erqhmX=g@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 03:49:03PM -0800, Linus Torvalds wrote:
> On Mon, Feb 17, 2014 at 3:46 PM, Russell King <rmk@arm.linux.org.uk> wrote:
> >
> > One fix touches code outside of arch/arm, which is related to sorting
> > out the DMA masks correctly.  There is a long standing issue with the
> > conversion from PFNs to addresses where people assume that shifting an
> > unsigned long left by PAGE_SHIFT results in a correct address.
> 
> You should probably have used PFN_PHYS(), which does this correctly.
> Your explicit u64 isn't exactly wrong, but phys_addr_t is really the
> right type for the result.

Almost, but not quite.  If we're going to avoid u64, then dma_addr_t
woudl be the right type here because we're talking about DMA addresses.
We could also switch to keeping this as PFNs - block internally converts
it to a PFN anyway:

void blk_queue_bounce_limit(struct request_queue *q, u64 max_addr)
{
        unsigned long b_pfn = max_addr >> PAGE_SHIFT;
...

and that is ultimately assigned to q->limits.bounce_pfn.  So, if we
arranged for blk_queue_bounce_limit() to take a PFN, and then modified
it's two callers, then we don't need to care about converting between
phys and pfns.

Maybe blk_queue_bounce_pfn_limit() so we ensure all users get caught?

> That said, it's admittedly a disgusting name, and I wonder if we
> should introduce a nicer-named "pfn_to_phys()" that matches the other
> "xyz_to_abc()" functions we have (including "pfn_to_virt()")

We have these on ARM:

arch/arm/include/asm/memory.h:#define	__pfn_to_phys(pfn)	((phys_addr_t)(pfn) << PAGE_SHIFT)
arch/arm/include/asm/memory.h:#define	__phys_to_pfn(paddr)	((unsigned long)((paddr) >> PAGE_SHIFT))

it probably makes sense to pick those right out, maybe losing the
__ prefix on them.

> Looking at it, the Xen people then do this disgusting thing:
> "__va(PFN_PHYS(pfn))" which is both ugly and pointless (__va() isn't
> going to work for a phys_addr_t anyway). And <linux/mm.h> has this
> gem:
> 
>   __va(PFN_PHYS(page_to_pfn(page)));

Wow.  Two things spring to mind there... highmem pages, and don't we
already have page_address() for that?

> Anyway, I pulled your change to scsi_lib.c, since it's certainly no
> worse than what we used to have, but James and company cc'd too.

Thanks.  I do worry about all the other places which I also found -
but the first step is getting concensus on what the macro should be.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
