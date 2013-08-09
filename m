Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967754Ab3HIHrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 03:47:40 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:41973 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967517Ab3HIHrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 03:47:37 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 03/16] iommu/exynos: fix page table maintenance
Date: Fri, 09 Aug 2013 09:47:28 +0200
Message-ID: <2636561.5XtHkCUpfO@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.4-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130809131520.270b7be7454b1862b146e592@samsung.com>
References: <002701ce941a$eecebdb0$cc6c3910$@samsung.com> <1516548.d7oQuzQS7g@amdc1227> <20130809131520.270b7be7454b1862b146e592@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo,

On Friday 09 of August 2013 13:15:20 Cho KyongHo wrote:
> On Thu, 08 Aug 2013 15:54:50 +0200, Tomasz Figa wrote:
> > On Thursday 08 of August 2013 18:37:43 Cho KyongHo wrote:
> > > This prevents allocating lv2 page table for the lv1 page table entry
> > > 
> >   ^ What this is this this about? :)
> 
> As you might indicate, 'this' means this patch :)

Yep, I was just nitpicking, but still I would go with something among 
following lines:

8<---
Currently if lv2 page table allocation is requested for a lv1 page table 
entry that already has 1MB page mapping, the driver returns -EADDRINUSE. 
However this case should not happen, unless there is a bug in the generic 
IOMMU allocator, so BUG_ON() is the right error handling here, which is 
implemented by this patch.
--->8

> > > that already has 1MB page mapping. In addition, changed to BUG_ON
> > > instead of returning -EADDRINUSE.
> > 
> > The change mentioned in last sentence should be a separate patch.
> 
> Ok :)

Well, actually I was confused by subject of this patch.

It looks like this change is actually the main part of it and the only 
unrelated changes are using defined macros for page masks and introduction 
of clear_page_table() function. Since we both agreed that the latter can 
be dropped only the former should be separated from this patch.

Maybe you could use following patch subject:

iommu/exynos: fix handling of possible BUG cases in page table setup code

> > > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > > ---
> > > 
> > >  drivers/iommu/exynos-iommu.c |   68
> > > 
> > > ++++++++++++++++++++++++----------------- 1 files changed, 40
> > > insertions(+), 28 deletions(-)
> > > 
> > > diff --git a/drivers/iommu/exynos-iommu.c
> > > b/drivers/iommu/exynos-iommu.c index d545a25..d90e6fa 100644
> > > --- a/drivers/iommu/exynos-iommu.c
> > > +++ b/drivers/iommu/exynos-iommu.c
> > > @@ -52,11 +52,11 @@
> > > 
> > >  #define lv2ent_large(pent) ((*(pent) & 3) == 1)
> > >  
> > >  #define section_phys(sent) (*(sent) & SECT_MASK)
> > > 
> > > -#define section_offs(iova) ((iova) & 0xFFFFF)
> > > +#define section_offs(iova) ((iova) & ~SECT_MASK)
> > > 
> > >  #define lpage_phys(pent) (*(pent) & LPAGE_MASK)
> > > 
> > > -#define lpage_offs(iova) ((iova) & 0xFFFF)
> > > +#define lpage_offs(iova) ((iova) & ~LPAGE_MASK)
> > > 
> > >  #define spage_phys(pent) (*(pent) & SPAGE_MASK)
> > > 
> > > -#define spage_offs(iova) ((iova) & 0xFFF)
> > > +#define spage_offs(iova) ((iova) & ~SPAGE_MASK)
> > > 
> > >  #define lv1ent_offset(iova) ((iova) >> SECT_ORDER)
> > >  #define lv2ent_offset(iova) (((iova) & 0xFF000) >> SPAGE_ORDER)
> > > 
> > > @@ -856,13 +856,15 @@ finish:
> > >  static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned
> > >  long
> > > 
> > > iova, short *pgcounter)
> > > 
> > >  {
> > > 
> > > +	BUG_ON(lv1ent_section(sent));
> > 
> > Is this condition really a critical one, to the point that the system
> > should not continue execution?
> 
> Discussed with Grant. He thought that creating mapping on a valid
> mapping is just a BUG and I finally agreed with him. Is there a case
> that the condition in BUG_ON is true intentionally?

Yes, he explained this as well. It's fine for me then.

> > > +
> > > 
> > >  	if (lv1ent_fault(sent)) {
> > >  	
> > >  		unsigned long *pent;
> > >  		
> > >  		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
> > >  		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
> > >  		if (!pent)
> > > 
> > > -			return NULL;
> > > +			return ERR_PTR(-ENOMEM);
> > > 
> > >  		*sent = mk_lv1ent_page(__pa(pent));
> > >  		*pgcounter = NUM_LV2ENTRIES;
> > > 
> > > @@ -875,15 +877,11 @@ static unsigned long *alloc_lv2entry(unsigned
> > > long *sent, unsigned long iova,
> > > 
> > >  static int lv1set_section(unsigned long *sent, phys_addr_t paddr,
> > >  short
> > > 
> > > *pgcnt) {
> > > -	if (lv1ent_section(sent))
> > > -		return -EADDRINUSE;
> > > +	BUG_ON(lv1ent_section(sent));
> > 
> > Ditto.
> > 
> > >  	if (lv1ent_page(sent)) {
> > > 
> > > -		if (*pgcnt != NUM_LV2ENTRIES)
> > > -			return -EADDRINUSE;
> > > -
> > > +		BUG_ON(*pgcnt != NUM_LV2ENTRIES);
> > 
> > Ditto.
> > 
> > >  		kfree(page_entry(sent, 0));
> > > 
> > > -
> > > 
> > >  		*pgcnt = 0;
> > >  	
> > >  	}
> > > 
> > > @@ -894,24 +892,24 @@ static int lv1set_section(unsigned long *sent,
> > > phys_addr_t paddr, short *pgcnt) return 0;
> > > 
> > >  }
> > > 
> > > +static void clear_page_table(unsigned long *ent, int n)
> > > +{
> > > +	if (n > 0)
> > > +		memset(ent, 0, sizeof(*ent) * n);
> > > +}
> > 
> > I don't see the point of creating this function. It seems to be used
> > only once, in addition with a constant as n, so the check for n > 0
> > is unnecessary.
> > 
> > And even if there is a need for this change, it should be done in
> > separate patch, as this one is not about stylistic changes, but
> > fixing page table maintenance (at least based on your commit
> > message).
> 
> I know what you are concerning about.
> It was introduced in v8 patches to recover previous fault entries before
> returning -EADDRINUSE. It is still remained though "return -EADDRINUSE"
> is changed into BUG_ON().
> I also think that it needs to be removed.

OK, thanks.

Best regards,
Tomasz

