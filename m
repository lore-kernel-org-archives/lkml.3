Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab3J3Pbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:31:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab3J3Pbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:31:53 -0400
Date: Wed, 30 Oct 2013 11:31:38 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, dave.jiang@intel.com, Mel Gorman <mgorman@suse.de>,
        akpm@linux-foundation.org, dhillf@gmail.com
Message-ID: <1383147098-1rzrc5t2-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20131028221126.GA29431@shutemov.name>
References: <20131028221618.4078637F@viggo.jf.intel.com>
 <20131028221620.042323B3@viggo.jf.intel.com>
 <20131028221126.GA29431@shutemov.name>
Subject: Re: [PATCH 2/2] mm: thp: give transparent hugepage code a
 separatecopy_page
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 12:11:26AM +0200, Kirill A. Shutemov wrote:
> On Mon, Oct 28, 2013 at 03:16:20PM -0700, Dave Hansen wrote:
> > 
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> > 
> > Right now, the migration code in migrate_page_copy() uses 
> > copy_huge_page() for hugetlbfs and thp pages:
> > 
> >        if (PageHuge(page) || PageTransHuge(page))
> >                 copy_huge_page(newpage, page);
> > 
> > So, yay for code reuse.  But:
> > 
> > void copy_huge_page(struct page *dst, struct page *src)
> > {
> >         struct hstate *h = page_hstate(src);
> > 
> > and a non-hugetlbfs page has no page_hstate().  This
> > works 99% of the time because page_hstate() determines
> > the hstate from the page order alone.  Since the page
> > order of a THP page matches the default hugetlbfs page
> > order, it works.
> > 
> > But, if you change the default huge page size on the
> > boot command-line (say default_hugepagesz=1G), then
> > we might not even *have* a 2MB hstate so page_hstate()
> > returns null and copy_huge_page() oopses pretty fast
> > since copy_huge_page() dereferences the hstate:
> > 
> > void copy_huge_page(struct page *dst, struct page *src)
> > {
> >         struct hstate *h = page_hstate(src);
> >         if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES)) {
> > ...
> > 
> > This patch creates a copy_high_order_page() which can
> > be used on THP pages.
> 
> We already have copy_user_huge_page() and copy_user_gigantic_page() in
> generic code (mm/memory.c). I think copy_gigantic_page() and
> copy_huge_page() should be moved there too.

I agree this.

> BTW, I think pages_per_huge_page in copy_user_huge_page() is redunand:
> compound_order(page) should be enough, right?

I guess that thp code is very strict on performance, so developers chose
to pass it as an argument instead of calculating compound_order in each call.
I think the performance gain is small (maybe invisible),
but it's not a bad idea to me.

Thanks,
Naoya
