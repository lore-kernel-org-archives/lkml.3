Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3BEIrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:47:13 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43992 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab3BEIrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:47:09 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-a4-5110c709b365
Date: Tue, 5 Feb 2013 17:47:05 +0900
From: Minchan Kim <minchan@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kmpark@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de
Subject: Re: [PATCH] mm: cma: fix accounting of CMA pages placed in high
 memory
Message-ID: <20130205084705.GC11197@blaptop>
References: <1359973626-3900-1-git-send-email-m.szyprowski@samsung.com>
 <20130204150657.6d05f76a.akpm@linux-foundation.org>
 <CAH9JG2Usd4HJKrBXwX3aEc3i6068zU=F=RjcoQ8E8uxYGrwXgg@mail.gmail.com>
 <20130204234358.GB2610@blaptop>
 <CAH9JG2VDOVv4-QrDs1FeyQNPzEDq+bf+qiSZ0snEqLGSed3PqA@mail.gmail.com>
 <20130205004032.GD2610@blaptop>
 <5110C506.2060209@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5110C506.2060209@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 09:38:30AM +0100, Marek Szyprowski wrote:
> Hello,
> 
> On 2/5/2013 1:40 AM, Minchan Kim wrote:
> 
> ...
> 
> >> Previous time, it's not fully tested and now we checked it with
> >> highmem support patches.
> >
> >I get it. Sigh. then [1] inline attached below wan't good.
> >We have to code like this?
> >
> >[1] 6a6dccba, mm: cma: don't replace lowmem pages with highmem
> >
> >diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >index b97cf12..0707e0a 100644
> >--- a/mm/page_alloc.c
> >+++ b/mm/page_alloc.c
> >@@ -5671,11 +5671,10 @@ static struct page *
> >  __alloc_contig_migrate_alloc(struct page *page, unsigned long private,
> >                              int **resultp)
> >  {
> >-       gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
> >-
> >-       if (PageHighMem(page))
> >-               gfp_mask |= __GFP_HIGHMEM;
> >-
> >+       gfp_t gfp_mask = GFP_HIGHUSER_MOVABLE;
> >+       struct address_space *mapping = page_mapping(page);
> >+       if (mapping)
> >+               gfp_mask = mapping_gfp_mask(mapping);
> >         return alloc_page(gfp_mask);
> >  }
> 
> Am I right that this code will allocate more pages from himem? Old approach

Yes.

> never migrate lowmem page to himem, what is now possible as gfp mask
> is always
> taken from mapping_gfp flags. I only wonder if forcing GFP_HIGHUSER_MOVABLE

-ENOPARSE. What is not possbile ~~ take from mapping_gfp flags.
Could you clarify your statement?

> for pages without the mapping is a correct. Shouldn't we use avoid himem in

CMA pages is for pages for user, NOT kernel so HIGHUSER_MOVABLE makes sense.

> such case?

I don't get it. :(
We have to recomment use of highmem for user space pages.
Am I missing something?

Sorry, I should go out of office now so forgive my late response.



> 
> Best regards
> -- 
> Marek Szyprowski
> Samsung Poland R&D Center
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
