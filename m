Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab3CZKq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 06:46:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:17701 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182Ab3CZKqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 06:46:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,911,1355126400"; 
   d="scan'208";a="284666087"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave@sr71.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <514B4E2B.2010506@sr71.net>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1363283435-7666-14-git-send-email-kirill.shutemov@linux.intel.com>
 <514B4E2B.2010506@sr71.net>
Subject: Re: [PATCHv2, RFC 13/30] thp, mm: implement
 grab_cache_huge_page_write_begin()
Content-Transfer-Encoding: 7bit
Message-Id: <20130326104810.C7F3AE0085@blue.fi.intel.com>
Date: Tue, 26 Mar 2013 12:48:10 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> > +repeat:
> > +	page = find_lock_page(mapping, index);
> > +	if (page) {
> > +		if (!PageTransHuge(page)) {
> > +			unlock_page(page);
> > +			page_cache_release(page);
> > +			return NULL;
> > +		}
> > +		goto found;
> > +	}
> > +
> > +	page = alloc_pages(gfp_mask & ~gfp_notmask, HPAGE_PMD_ORDER);
> 
> I alluded to this a second ago, but what's wrong with alloc_hugepage()?

It's defined only for !CONFIG_NUMA and only inside mm/huge_memory.c.

> > +found:
> > +	wait_on_page_writeback(page);
> > +	return page;
> > +}
> > +#endif
> 
> So, I diffed :
> 
> -struct page *grab_cache_page_write_begin(struct address_space
> vs.
> +struct page *grab_cache_huge_page_write_begin(struct address_space
> 
> They're just to similar to ignore.  Please consolidate them somehow.

Will do.

> > +found:
> > +	wait_on_page_writeback(page);
> > +	return page;
> > +}
> > +#endif
> 
> In grab_cache_page_write_begin(), this "wait" is:
> 
>         wait_for_stable_page(page);
> 
> Why is it different here?

It was wait_on_page_writeback() in grab_cache_page_write_begin() when I forked
it :(

See 1d1d1a7 mm: only enforce stable page writes if the backing device requires it

Consolidation will fix this.

-- 
 Kirill A. Shutemov
