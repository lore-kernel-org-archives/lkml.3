Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897AbaFJO3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:29:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbaFJO3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:29:20 -0400
Date: Tue, 10 Jun 2014 16:29:09 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH, RFC 00/10] THP refcounting redesign
Message-ID: <20140610142909.GC19660@redhat.com>
References: <1402329861-7037-1-git-send-email-kirill.shutemov@linux.intel.com>
 <5396BD90.4060104@suse.cz>
 <20140610135246.GA3728@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610135246.GA3728@node.dhcp.inet.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 10, 2014 at 04:52:46PM +0300, Kirill A. Shutemov wrote:
> I mean the whole compound page will not be freed until the last part page
> is unmapped. It can lead to excessive memory overhead for some workloads.

That is why a refcounting design like this wouldn't have been feasible
so far, as it's not entirely "transparent" anymore and we couldn't
risk breaking apps... I mean the worst case this could lead to the
anonymous real RSS of the app to be 512 times bigger than virtual size
allocated by the app in vmas. Sounds very unlikely but still not safe
to deploy such a thing on random apps, without quite some testing of a
variety of apps.

If I understand correctly, the memory footprint problem doesn't exist
with swapping because swapping calls split_huge_page_to_list() and
that works as long as there are no gup() pins? (-EBUSY is returned if
there's a pin on any head or tail page)

So if there are transient gup() pins swapping will try again to
split_huge_page later (non transient gup pins should use mmu notifiers
and not hold any pin in the first place).

Even for swapping it increases the "pinned" region by a worst case of
512 times, but if there's lots of direct-io in flight the virtual
addresses pinned are usually contiguous and if there's a THP the
physical side is also contiguous for 512 4k pages so it probably
doesn't reduce the ability to swap in any significant way even if
there's direct-io in flight.

> We can try to be smarter and call split_huge_page() instead of
> split_huge_pmd() if see that the huge page is not mapped as 2M or
> something. But we don't have a cheap way to check this...

I wonder, why don't you still do the split_huge_page immediately
inside split_huge_pmd, it would fail with -EBUSY if it's pinned.

If split_huge_page fails because of transient gup pins, then you can
defer the split_huge_page to khugepaged if it notices we're wasting
memory during its scan, clearly it shall be speculative without
freezing the refcounts with compound_lock, and only call the
split_huge_page if it then notices it can free memory.

> be more common, since they can be mapped individually now. Acctually, I'm
> not sure if these operation is cheap enough: we still use compound_lock
> there to serialize against splitting.

This is the main cons in my view, simplifying the get_page/put_page
refcounting would be nice, but you're still taking the tail pins on
the tail pages and so in my view it doesn't move the needle in terms
of get_page/put_page, it's a bit faster but it still has all tail page
pins accounting and it's not just a head page accounting like it was
before THP was introduced and it needed to deal with gup on tail pages
under splitting.

This patch allows split_huge_page to fail fail (currently it cannot
fail), split_huge_pmd still cannot fail, so it'd be nice if we could
remove all tail pins too if split_huge_page could fail.

Can't you just account all tail pins in the head like it was before
with only hugetlbfs and return -EBUSY if the head_page->count doesn't
match mapcount or something like that? What exactly the tail pins do
in this model other than to allow you to return -EBUSY?

The major reason we have to do the special tail pin refcounting with
gup is that split_huge_page cannot fail now, so at any given time we
must know which tail page was pinned, if we can fail split_huge_page
there's no point to know anymore which exact tail page holds the gup
pin, and we should only be able to say "yes we can" or "no we cannot
split_huge_page" and just for that the tailpage refcounting doesn't
look so critical to keep.

There would still be the risk of wasting memory with gup pins vs
munmap (I don't see a way to fix it if split_huge_page can fail with
-EBUSY) but khugepaged can fixup that later and deal with the transient
gup pins.

Thanks,
Andrea
