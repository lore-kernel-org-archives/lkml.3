Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbaD1NXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:23:50 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52834 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbaD1NXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:23:47 -0400
Date: Mon, 28 Apr 2014 14:23:39 +0100
From: Steve Capper <steve.capper@linaro.org>
To: Jungseok Lee <jays.lee@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        "'Christoffer Dall'" <christoffer.dall@linaro.org>,
        linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com, "'Arnd Bergmann'" <arnd@arndb.de>,
        kgene.kim@samsung.com, ilho215.lee@samsung.com
Subject: Re: [PATCH v3 6/7] arm64: mm: Implement 4 levels of translation
 tables
Message-ID: <20140428132338.GA26829@linaro.org>
References: <000701cf5adc$1aa35350$4fe9f9f0$@samsung.com>
 <20140423160149.GA2895@linaro.org>
 <000f01cf61ca$099017c0$1cb04740$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000f01cf61ca$099017c0$1cb04740$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 12:37:35PM +0900, Jungseok Lee wrote:
> On Thursday, April 24, 2014 1:02 AM, Steve Capper wrote:
> > On Fri, Apr 18, 2014 at 04:59:20PM +0900, Jungseok Lee wrote:

[ ... ]

> > 
> > This is overly complicated. For <4 levels we set x0 to be:
> > ttbr1 + 2*PAGE_SIZE. For 4-levels, we set x0 to be ttbr1 + PAGE_SIZE, then inside the create_pgd_entry
> > macro, we check the VA for FIXADDR_TOP then add another PAGE_SIZE. This is presumably done so the same
> > PUD is used for the swapper block map and the FIXADDR map.
> 
> Is it too complicated to understand the logic?
> 
> 1) For <4 levels:
> PAGE_SIZE is added for FIXADDR map and x0 is passed to create pgd entry.
> 2) For =4 levels:
> PAGE_SIZE is added in the create_pgd_entry macro since FIXADDR map info
> is needed to create pud entry.
> 
> However, I agree that the code should be revised if other people feel
> like it is a labyrinthine logic.
> 
> > If you assume that the PUD always follows the PGD for 4-levels, then you can remove this #ifdef and
> > the conditional VA logic in set_pgd_entry. To make the logic simpler for <4 levels, you could call
> > create_pud_entry in the middle of create_pgd_entry, then put down the actual pgd after.
> 
> create_pud_entry should distinguish block map from FIXADDR map although
> PUD always follows the PGD in case of 4 levels. If we would like to avoid
> unnecessary #ifdef, the conditional logic should be introduced in create_
> pgd_entry macro.
> 
> I cannot find the "best" way even though I've tried to figure it out.
> I would like to find out the most clear and self-descriptive expression.
> 
> Could you give an idea on how to remove both conditional VA logic and #ifdef?


Hello Jungseok,
I had the following logic in my head:
It compiles and runs on the model, but I've not tried it in anger.

=========================================================================

	.macro create_pud_entry, pgd, tbl, virt, pud, tmp1, tmp2
#ifdef CONFIG_ARM64_4_LEVELS
	add	\tbl, \tbl, #PAGE_SIZE		// bump tbl 1 page up.
						// to make room for pud
	add	\pud, \pgd, #PAGE_SIZE		// pgd points to pud which
						// follows pgd
	lsr	\tmp1, \virt, #PUD_SHIFT
	and	\tmp1, \tmp1, #PTRS_PER_PUD - 1	// PUD index
	orr	\tmp2, \tbl, #3			// PUD entry table type
	str	\tmp2, [\pud, \tmp1, lsl #3]
#else
	mov	\pud, \tbl			// pgd points to section table
						// directly for < 4 levels
#endif
	.endm

/*
 * Macro to populate the PGD for the corresponding block entry in the next
 * level (tbl) for the given virtual address.
 *
 * Preserves:	pgd, virt
 * Corrupts:	tmp1, tmp2, tmp3
 * Returns:	tbl -> page where block mappings can be placed
 *	(changed to make room for pud with 4levels, preserved otherwise)
 */
	.macro	create_pgd_entry, pgd, tbl, virt, tmp1, tmp2, tmp3
	create_pud_entry \pgd, \tbl, \virt, \tmp3, \tmp1, \tmp2
	lsr	\tmp1, \virt, #PGDIR_SHIFT
	and	\tmp1, \tmp1, #PTRS_PER_PGD - 1	// PGD index
	orr	\tmp2, \tmp3, #3		// PGD entry table type
	str	\tmp2, [\pgd, \tmp1, lsl #3]
	.endm

=========================================================================

[Note I've changed the extra argument to create_pgd_entry to be at the end
to make it easier to diff callers]

So essentially, we bump up tbl if we are running with 4 levels of page
table. We put the pgd down after the pud, and this allows us to sneak a
pud in after the pgd if we need to, otherwise it points to the target
for the section mapping.

Does this work for you? (I go cross-eyed with too much assembler, so
could have easily missed something).

> 
> > > +	create_pgd_entry x26, x0, x1, x5, x6, x7
> > >
> > 
> > So before this patch we have the following created by
> > __create_page_tables:
> > 
> > +========================+ <--- TEXT_OFFSET + PHYS_OFFSET
> > | FIXADDR (pmd or pte)   |
> > +------------------------+
> > | block map (pmd or pte) |
> > +------------------------+
> > | PGDs for swapper       |
> > +========================+ <--- TTBR1 swapper_pg_dir
> > | block map for idmap    |
> > +------------------------+
> > | PGDs for idmap         |
> > +------------------------+ <--- TTBR0 idmap_pg_dir
> > 
> > 
> > After the patch, for 4 levels activated we have:
> > +========================+ <--- TEXT_OFFSET + PHYS_OFFSET
> > | FIXADDR (ptes)         |
> > +------------------------+
> > | block map (ptes)       |
> > +------------------------+
> > | PUDs for swapper       |
> > +------------------------+
> > | PGDs for swapper       |
> > +========================+ <--- TTBR1 swapper_pg_dir
> > | block map for idmap    |
> > +------------------------+
> > | PUDs for idmap         |
> > +------------------------+
> > | PGDs for idmap         |
> > +------------------------+ <--- TTBR0 idmap_pg_dir
> > 
> > and without 4 levels activated we have:
> > +========================+ <--- TEXT_OFFSET + PHYS_OFFSET
> > | ZERO BYTES             |
> > +------------------------+
> > | FIXADDR (pmd or pte)   |
> > +------------------------+
> > | block map (pmd or pte) |
> > +------------------------+
> > | PGDs for swapper       |
> > +========================+ <--- TTBR1 swapper_pg_dir
> > | ZERO BYTES             |
> > +------------------------+
> > | block map for idmap    |
> > +------------------------+
> > | PGDs for idmap         |
> > +------------------------+ <--- TTBR0 idmap_pg_dir
> 
> This is definitely helpful to understand head.S.
> It would be good to add these figures to Documentation or comments.

Please feel free to grab it if you want... :-).
Otherwise, I can put a patch in for this, as I am working on some logic
to remap the physical memory a PUD blocks for 4K granule.

Cheers,
-- 
Steve
