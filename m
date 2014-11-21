Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbaKUMDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:03:30 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:33190 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbaKUMD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:03:28 -0500
Date: Fri, 21 Nov 2014 14:02:55 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Steve Capper <steve.capper@linaro.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 06/19] mm: store mapcount for compound page separate
Message-ID: <20141121120255.GC16647@node.dhcp.inet.fi>
References: <1415198994-15252-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1415198994-15252-7-git-send-email-kirill.shutemov@linux.intel.com>
 <87h9xt6pzw.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h9xt6pzw.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 11:42:51AM +0530, Aneesh Kumar K.V wrote:
> "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> writes:
> 
> > We're going to allow mapping of individual 4k pages of THP compound and
> > we need a cheap way to find out how many time the compound page is
> > mapped with PMD -- compound_mapcount() does this.
> >
> > page_mapcount() counts both: PTE and PMD mappings of the page.
> >
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  include/linux/mm.h   | 17 +++++++++++++++--
> >  include/linux/rmap.h |  4 ++--
> >  mm/huge_memory.c     | 23 ++++++++++++++---------
> >  mm/hugetlb.c         |  4 ++--
> >  mm/memory.c          |  2 +-
> >  mm/migrate.c         |  2 +-
> >  mm/page_alloc.c      | 13 ++++++++++---
> >  mm/rmap.c            | 50 +++++++++++++++++++++++++++++++++++++++++++-------
> >  8 files changed, 88 insertions(+), 27 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 1825c468f158..aef03acff228 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -435,6 +435,19 @@ static inline struct page *compound_head(struct page *page)
> >  	return page;
> >  }
> >  
> > +static inline atomic_t *compound_mapcount_ptr(struct page *page)
> > +{
> > +	return (atomic_t *)&page[1].mapping;
> > +}
> > +
> > +static inline int compound_mapcount(struct page *page)
> > +{
> > +	if (!PageCompound(page))
> > +		return 0;
> > +	page = compound_head(page);
> > +	return atomic_read(compound_mapcount_ptr(page)) + 1;
> > +}
> 
> 
> How about 
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 6e0b286649f1..59c9cf3d8510 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -46,6 +46,11 @@ struct page {
>  	unsigned long flags;		/* Atomic flags, some possibly
>  					 * updated asynchronously */
>  	union {
> +		/*
> +		  * For THP we use this to track the compound
> +		  * page mapcount.
> +		  */
> +		atomic_t _compound_mapcount;
>  		struct address_space *mapping;	/* If low bit clear, points to
>  						 * inode address_space, or NULL.
>  						 * If page mapped as anonymous
> 
> and 
> 
> static inline atomic_t *compound_mapcount_ptr(struct page *page)
> {
>         return (atomic_t *)&page[1]._compound_mapcount;
> }

Cast is redundant ;)

See answer to Christoph.

-- 
 Kirill A. Shutemov
