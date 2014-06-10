Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaFJPYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:24:33 -0400
Received: from mta-out1.inet.fi ([62.71.2.199]:43751 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbaFJPYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:24:30 -0400
Date: Tue, 10 Jun 2014 18:24:08 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH, RFC 00/10] THP refcounting redesign
Message-ID: <20140610152408.GB3728@node.dhcp.inet.fi>
References: <1402329861-7037-1-git-send-email-kirill.shutemov@linux.intel.com>
 <5396BD90.4060104@suse.cz>
 <20140610135246.GA3728@node.dhcp.inet.fi>
 <20140610142909.GC19660@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610142909.GC19660@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 04:29:09PM +0200, Andrea Arcangeli wrote:
> Hello,
> 
> On Tue, Jun 10, 2014 at 04:52:46PM +0300, Kirill A. Shutemov wrote:
> > I mean the whole compound page will not be freed until the last part page
> > is unmapped. It can lead to excessive memory overhead for some workloads.
> 
> That is why a refcounting design like this wouldn't have been feasible
> so far, as it's not entirely "transparent" anymore and we couldn't
> risk breaking apps... I mean the worst case this could lead to the
> anonymous real RSS of the app to be 512 times bigger than virtual size
> allocated by the app in vmas. Sounds very unlikely but still not safe
> to deploy such a thing on random apps, without quite some testing of a
> variety of apps.

Agreed. It need to be handled one way or another before moving forward.

> If I understand correctly, the memory footprint problem doesn't exist
> with swapping because swapping calls split_huge_page_to_list() and
> that works as long as there are no gup() pins? (-EBUSY is returned if
> there's a pin on any head or tail page)

Correct.

> So if there are transient gup() pins swapping will try again to
> split_huge_page later (non transient gup pins should use mmu notifiers
> and not hold any pin in the first place).
> 
> Even for swapping it increases the "pinned" region by a worst case of
> 512 times, but if there's lots of direct-io in flight the virtual
> addresses pinned are usually contiguous and if there's a THP the
> physical side is also contiguous for 512 4k pages so it probably
> doesn't reduce the ability to swap in any significant way even if
> there's direct-io in flight.
> 
> > We can try to be smarter and call split_huge_page() instead of
> > split_huge_pmd() if see that the huge page is not mapped as 2M or
> > something. But we don't have a cheap way to check this...
> 
> I wonder, why don't you still do the split_huge_page immediately
> inside split_huge_pmd, it would fail with -EBUSY if it's pinned.

I want keep split_huge_pmd() process-local: for shared it's not needed to
split the page in all processes if one of them call mprotect(), munmap(),
etc.

We probably could split the page if we can see that it mapped only once
with PMD which is most common case.


> If split_huge_page fails because of transient gup pins, then you can
> defer the split_huge_page to khugepaged if it notices we're wasting
> memory during its scan, clearly it shall be speculative without
> freezing the refcounts with compound_lock, and only call the
> split_huge_page if it then notices it can free memory.
> 
> > be more common, since they can be mapped individually now. Acctually, I'm
> > not sure if these operation is cheap enough: we still use compound_lock
> > there to serialize against splitting.
> 
> This is the main cons in my view, simplifying the get_page/put_page
> refcounting would be nice, but you're still taking the tail pins on
> the tail pages and so in my view it doesn't move the needle in terms
> of get_page/put_page, it's a bit faster but it still has all tail page
> pins accounting and it's not just a head page accounting like it was
> before THP was introduced and it needed to deal with gup on tail pages
> under splitting.
> 
> This patch allows split_huge_page to fail fail (currently it cannot
> fail), split_huge_pmd still cannot fail, so it'd be nice if we could
> remove all tail pins too if split_huge_page could fail.
> 
> Can't you just account all tail pins in the head like it was before
> with only hugetlbfs and return -EBUSY if the head_page->count doesn't
> match mapcount or something like that? What exactly the tail pins do
> in this model other than to allow you to return -EBUSY?

That's exactly what I do. The compound_lock is needed to protect
head_page->_count from being updated from get_page()/put_page() on tail
page while we're splitting. Otherwise we will not be able distribute pins
correctly.

I had silly idea: can we use most significant bit of head_page->_count as
bit for compound lock? This allows (I think) to use one atomic_cmpxchg()
to update counter case from get_page()/put_page() with respect to compound
lock instead of lock;update;unlock. Something like lockref, but for bit
spinlock.
Does it sound too broken?

Anyway, I want first check how high get_page()/put_page() will be on
profile.

-- 
 Kirill A. Shutemov
