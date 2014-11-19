Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaKSNBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:01:18 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:58607 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbaKSNBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:01:17 -0500
Date: Wed, 19 Nov 2014 15:00:50 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Steve Capper <steve.capper@linaro.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 06/19] mm: store mapcount for compound page separate
Message-ID: <20141119130050.GA29884@node.dhcp.inet.fi>
References: <1415198994-15252-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1415198994-15252-7-git-send-email-kirill.shutemov@linux.intel.com>
 <546C761D.6050407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546C761D.6050407@redhat.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 11:51:09AM +0100, Jerome Marchand wrote:
> On 11/05/2014 03:49 PM, Kirill A. Shutemov wrote:
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
> 
> IIUC your patch overloads the unused mapping field of the first tail
> page to store the PMD mapcount. That's a non obvious trick. Why not make
> it more explicit by adding a new field (say compound_mapcount - and the
> appropriate comment of course) to the union to which mapping already belong?

I don't think we want to bloat struct page description: nobody outside of
helpers should use it direcly. And it's exactly what we did to store
compound page destructor and compound page order.

> The patch description would benefit from more explanation too.

Agreed.

-- 
 Kirill A. Shutemov
