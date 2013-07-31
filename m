Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab3GaG1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:27:10 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:55216 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab3GaG1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:27:08 -0400
Date: Wed, 31 Jul 2013 08:26:59 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Konstantin Weitz <konstantin.weitz@gmail.com>
Subject: Re: [PATCH 1/2] mm: add support for discard of unused ptes
Message-ID: <20130731082659.1b5a5377@mschwide>
In-Reply-To: <20130730134422.98c0977eada81d3ac41a08bb@linux-foundation.org>
References: <1374742461-29160-1-git-send-email-schwidefsky@de.ibm.com>
	<1374742461-29160-2-git-send-email-schwidefsky@de.ibm.com>
	<20130730134422.98c0977eada81d3ac41a08bb@linux-foundation.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073106-0342-0000-0000-000005D498BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jul 2013 13:44:22 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 25 Jul 2013 10:54:20 +0200 Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > From: Konstantin Weitz <konstantin.weitz@gmail.com>
> > 
> > In a virtualized environment and given an appropriate interface the guest
> > can mark pages as unused while they are free (for the s390 implementation
> > see git commit 45e576b1c3d00206 "guest page hinting light"). For the host
> > the unused state is a property of the pte.
> > 
> > This patch adds the primitive 'pte_unused' and code to the host swap out
> > handler so that pages marked as unused by all mappers are not swapped out
> > but discarded instead, thus saving one IO for swap out and potentially
> > another one for swap in.
> > 
> > ...
> >
> > --- a/include/asm-generic/pgtable.h
> > +++ b/include/asm-generic/pgtable.h
> > @@ -193,6 +193,19 @@ static inline int pte_same(pte_t pte_a, pte_t pte_b)
> >  }
> >  #endif
> >  
> > +#ifndef __HAVE_ARCH_PTE_UNUSED
> > +/*
> > + * Some architectures provide facilities to virtualization guests
> > + * so that they can flag allocated pages as unused. This allows the
> > + * host to transparently reclaim unused pages. This function returns
> > + * whether the pte's page is unused.
> > + */
> > +static inline int pte_unused(pte_t pte)
> > +{
> > +	return 0;
> > +}
> > +#endif
> > +
> >  #ifndef __HAVE_ARCH_PMD_SAME
> >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >  static inline int pmd_same(pmd_t pmd_a, pmd_t pmd_b)
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index cd356df..2291f25 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -1234,6 +1234,16 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
> >  		}
> >  		set_pte_at(mm, address, pte,
> >  			   swp_entry_to_pte(make_hwpoison_entry(page)));
> > +	} else if (pte_unused(pteval)) {
> > +		/*
> > +		 * The guest indicated that the page content is of no
> > +		 * interest anymore. Simply discard the pte, vmscan
> > +		 * will take care of the rest.
> > +		 */
> > +		if (PageAnon(page))
> > +			dec_mm_counter(mm, MM_ANONPAGES);
> > +		else
> > +			dec_mm_counter(mm, MM_FILEPAGES);
> >  	} else if (PageAnon(page)) {
> >  		swp_entry_t entry = { .val = page_private(page) };
> 
> Obviously harmless.  Please include this in whatever tree carries
> "[PATCH 2/2] s390/kvm: support collaborative memory management".
 
Cool, thanks. This will go out via the KVM tree then.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

