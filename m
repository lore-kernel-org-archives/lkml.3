Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab3GWLly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 07:41:54 -0400
Received: from relay1.sgi.com ([192.48.179.29]:48641 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332Ab3GWLlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 07:41:52 -0400
Date: Tue, 23 Jul 2013 06:41:50 -0500
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Robin Holt <holt@sgi.com>,
        Nathan Zimmer <nzimmer@sgi.com>, Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Rob Landley <rob@landley.net>,
        Mike Travis <travis@sgi.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC 4/4] Sparse initialization of struct page array.
Message-ID: <20130723114150.GH3421@sgi.com>
References: <1373594635-131067-1-git-send-email-holt@sgi.com>
 <1373594635-131067-5-git-send-email-holt@sgi.com>
 <CAE9FiQW1s2UwCY6OjzD3+2wG8SjCr1QyCpajhZbk_XhmnFQW4Q@mail.gmail.com>
 <20130715174551.GA58640@asylum.americas.sgi.com>
 <51E4375E.1010704@zytor.com>
 <20130715182615.GF3421@sgi.com>
 <51E43F91.1040906@zytor.com>
 <20130723083211.GE16088@gmail.com>
 <20130723110947.GF3421@sgi.com>
 <20130723111549.GG3421@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723111549.GG3421@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 06:15:49AM -0500, Robin Holt wrote:
> I think the other critical path which is affected is in expand().
> There, we just call ensure_page_is_initialized() blindly which does
> the check against the other page.  The below is a nearly zero addition.
> Sorry for the confusion.  My morning coffee has not kicked in yet.

I don't have access to the 16TiB system until Thursday unless the other
testing on it fails early.  I did boot a 2TiB system with the a change
which set the Unitialized_2m flag on all pages in that 2MiB range
during memmap_init_zone.  That makes the expand check test against
the referenced page instead of having to go back to the 2MiB page.
It appears to have added less than a second to the 2TiB boot so I hope
it has equally little impact to the 16TiB boot.

I will clean up this patch some more and resend the currently untested
set later today.

Thanks,
Robin

> 
> Robin
> 
> On Tue, Jul 23, 2013 at 06:09:47AM -0500, Robin Holt wrote:
> > On Tue, Jul 23, 2013 at 10:32:11AM +0200, Ingo Molnar wrote:
> > > 
> > > * H. Peter Anvin <hpa@zytor.com> wrote:
> > > 
> > > > On 07/15/2013 11:26 AM, Robin Holt wrote:
> > > >
> > > > > Is there a fairly cheap way to determine definitively that the struct 
> > > > > page is not initialized?
> > > > 
> > > > By definition I would assume no.  The only way I can think of would be 
> > > > to unmap the memory associated with the struct page in the TLB and 
> > > > initialize the struct pages at trap time.
> > > 
> > > But ... the only fastpath impact I can see of delayed initialization right 
> > > now is this piece of logic in prep_new_page():
> > > 
> > > @@ -903,6 +964,10 @@ static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
> > > 
> > >         for (i = 0; i < (1 << order); i++) {
> > >                 struct page *p = page + i;
> > > +
> > > +               if (PageUninitialized2Mib(p))
> > > +                       expand_page_initialization(page);
> > > +
> > >                 if (unlikely(check_new_page(p)))
> > >                         return 1;
> > > 
> > > That is where I think it can be made zero overhead in the 
> > > already-initialized case, because page-flags are already used in 
> > > check_new_page():
> > 
> > The problem I see here is that the page flags we need to check for the
> > uninitialized flag are in the "other" page for the page aligned at the
> > 2MiB virtual address, not the page currently being referenced.
> > 
> > Let me try a version of the patch where we set the PG_unintialized_2m
> > flag on all pages, including the aligned pages and see what that does
> > to performance.
> > 
> > Robin
> > 
> > > 
> > > static inline int check_new_page(struct page *page)
> > > {
> > >         if (unlikely(page_mapcount(page) |
> > >                 (page->mapping != NULL)  |
> > >                 (atomic_read(&page->_count) != 0)  |
> > >                 (page->flags & PAGE_FLAGS_CHECK_AT_PREP) |
> > >                 (mem_cgroup_bad_page_check(page)))) {
> > >                 bad_page(page);
> > >                 return 1;
> > > 
> > > see that PAGE_FLAGS_CHECK_AT_PREP flag? That always gets checked for every 
> > > struct page on allocation.
> > > 
> > > We can micro-optimize that low overhead to zero-overhead, by integrating 
> > > the PageUninitialized2Mib() check into check_new_page(). This can be done 
> > > by adding PG_uninitialized2mib to PAGE_FLAGS_CHECK_AT_PREP and doing:
> > > 
> > > 
> > > 	if (unlikely(page->flags & PAGE_FLAGS_CHECK_AT_PREP)) {
> > > 		if (PageUninitialized2Mib(p))
> > > 			expand_page_initialization(page);
> > > 		...
> > > 	}
> > > 
> > >         if (unlikely(page_mapcount(page) |
> > >                 (page->mapping != NULL)  |
> > >                 (atomic_read(&page->_count) != 0)  |
> > >                 (mem_cgroup_bad_page_check(page)))) {
> > >                 bad_page(page);
> > > 
> > >                 return 1;
> > > 
> > > this will result in making it essentially zero-overhead, the 
> > > expand_page_initialization() logic is now in a slowpath.
> > > 
> > > Am I missing anything here?
> > > 
> > > Thanks,
> > > 
> > > 	Ingo
