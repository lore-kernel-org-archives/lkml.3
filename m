Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaDRU4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 16:56:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:62858 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbaDRU4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 16:56:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,886,1389772800"; 
   d="scan'208";a="523070632"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Michel Lespinasse <walken@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Bob Liu <lliubbo@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
In-Reply-To: <20140416131942.aaf8e560e45062c9857a2648@linux-foundation.org>
References: <1397598515-25017-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20140416131942.aaf8e560e45062c9857a2648@linux-foundation.org>
Subject: Re: [PATCH] thp: close race between split and zap huge pages
Content-Transfer-Encoding: 7bit
Message-Id: <20140418205602.B9EFDE0098@blue.fi.intel.com>
Date: Fri, 18 Apr 2014 23:56:02 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 16 Apr 2014 00:48:35 +0300 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> 
> > Sasha Levin has reported two THP BUGs[1][2]. I believe both of them have
> > the same root cause. Let's look to them one by one.
> > 
> > The first bug[1] is "kernel BUG at mm/huge_memory.c:1829!".
> > It's BUG_ON(mapcount != page_mapcount(page)) in __split_huge_page().
> > >From my testing I see that page_mapcount() is higher than mapcount here.
> > 
> > I think it happens due to race between zap_huge_pmd() and
> > page_check_address_pmd(). page_check_address_pmd() misses PMD
> > which is under zap:
> 
> Why did this bug happen?
> 
> In other words, what earlier mistakes had we made which led to you
> getting this locking wrong?

Locking model for perfect (without missing any page table entry) rmap walk is
not straight-forward and seems not documented properly anywhere.

Actually, the same bug was made for page_check_address() on introduction split
PTE lock (see c0718806cf95 mm: rmap with inner ptlock) and fixed later (see
479db0bf408e mm: dirty page tracking race fix).

> Based on that knowledge, what can we do to reduce the likelihood of
> such mistakes being made in the future?  (Hint: the answer to this
> will involve making changes to this patch).

Patch to add local comment is below.

But we really need proper documentation on rmap expectations from somebody who
understands it better than me.
Rik? Andrea?

> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -1536,16 +1536,23 @@ pmd_t *page_check_address_pmd(struct page *page,
> >  			      enum page_check_address_pmd_flag flag,
> >  			      spinlock_t **ptl)
> >  {
> > +	pgd_t *pgd;
> > +	pud_t *pud;
> >  	pmd_t *pmd;
> >  
> >  	if (address & ~HPAGE_PMD_MASK)
> >  		return NULL;
> >  
> > -	pmd = mm_find_pmd(mm, address);
> > -	if (!pmd)
> > +	pgd = pgd_offset(mm, address);
> > +	if (!pgd_present(*pgd))
> >  		return NULL;
> > +	pud = pud_offset(pgd, address);
> > +	if (!pud_present(*pud))
> > +		return NULL;
> > +	pmd = pmd_offset(pud, address);
> > +
> >  	*ptl = pmd_lock(mm, pmd);
> > -	if (pmd_none(*pmd))
> > +	if (!pmd_present(*pmd))
> >  		goto unlock;
> >  	if (pmd_page(*pmd) != page)
> >  		goto unlock;
> 
> So how do other callers of mm_find_pmd() manage to avoid this race, or
> are they all buggy?

None of them involved in rmap walk over pmds. In this case speculative pmd
checks without ptl are fine.

> Is mm_find_pmd() really so simple and obvious that we can afford to
> leave it undocumented?

I think it is. rmap is not.

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d02a83852ee9..98165f222cef 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1552,6 +1552,11 @@ pmd_t *page_check_address_pmd(struct page *page,
        pmd = pmd_offset(pud, address);
 
        *ptl = pmd_lock(mm, pmd);
+       /*
+        * Check if pmd present *only* with ptl taken. For perfect rmap walk we
+        * want to be serialized against zap_huge_pmd() and can't just
+        * speculatively skip non-present pmd without getting ptl.
+        */
        if (!pmd_present(*pmd))
                goto unlock;
        if (pmd_page(*pmd) != page)
-- 
 Kirill A. Shutemov
