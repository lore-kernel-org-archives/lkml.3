Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030704Ab3HIOqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:46:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:54184 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030533Ab3HIOqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:46:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,846,1367996400"; 
   d="scan'208";a="279907687"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Ning Qu <quning@google.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1375994967.29639.4.camel@concerto>
References: <1375582645-29274-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1375582645-29274-23-git-send-email-kirill.shutemov@linux.intel.com>
 <1375994967.29639.4.camel@concerto>
Subject: Re: [PATCH 22/23] thp, mm: split huge page on mmap file page
Content-Transfer-Encoding: 7bit
Message-Id: <20130809145006.95333E0090@blue.fi.intel.com>
Date: Fri,  9 Aug 2013 17:50:06 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Khalid Aziz wrote:
> On Sun, 2013-08-04 at 05:17 +0300, Kirill A. Shutemov wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > 
> > We are not ready to mmap file-backed tranparent huge pages. Let's split
> > them on fault attempt.
> > 
> > Later we'll implement mmap() properly and this code path be used for
> > fallback cases.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  mm/filemap.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index ed65af5..f7857ef 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -1743,6 +1743,8 @@ retry_find:
> >  			goto no_cached_page;
> >  	}
> >  
> > +	if (PageTransCompound(page))
> > +		split_huge_page(compound_trans_head(page));
> 
> Since PageTransCompound(page) returns true for transparent huge pages as
> well as hugetlbfs pages, could this code split hugetlbfs pages on an
> mmap() on to hugetlbfs pages? hugetlbfs pages are not supposed to be
> split, right?

hugetlbfs page cannot (should not) be here. hugetlb uses different
vm_ops->fault handeler.

-- 
 Kirill A. Shutemov
