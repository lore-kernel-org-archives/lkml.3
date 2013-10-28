Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab3J1XIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 19:08:18 -0400
Received: from [204.155.152.216] ([204.155.152.216]:45599 "EHLO shutemov.name"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757233Ab3J1XIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 19:08:17 -0400
Date: Tue, 29 Oct 2013 00:11:26 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dave.jiang@intel.com,
        Mel Gorman <mgorman@suse.de>, akpm@linux-foundation.org,
        dhillf@gmail.com
Subject: Re: [PATCH 2/2] mm: thp: give transparent hugepage code a separate
 copy_page
Message-ID: <20131028221126.GA29431@shutemov.name>
References: <20131028221618.4078637F@viggo.jf.intel.com>
 <20131028221620.042323B3@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028221620.042323B3@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 03:16:20PM -0700, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Right now, the migration code in migrate_page_copy() uses 
> copy_huge_page() for hugetlbfs and thp pages:
> 
>        if (PageHuge(page) || PageTransHuge(page))
>                 copy_huge_page(newpage, page);
> 
> So, yay for code reuse.  But:
> 
> void copy_huge_page(struct page *dst, struct page *src)
> {
>         struct hstate *h = page_hstate(src);
> 
> and a non-hugetlbfs page has no page_hstate().  This
> works 99% of the time because page_hstate() determines
> the hstate from the page order alone.  Since the page
> order of a THP page matches the default hugetlbfs page
> order, it works.
> 
> But, if you change the default huge page size on the
> boot command-line (say default_hugepagesz=1G), then
> we might not even *have* a 2MB hstate so page_hstate()
> returns null and copy_huge_page() oopses pretty fast
> since copy_huge_page() dereferences the hstate:
> 
> void copy_huge_page(struct page *dst, struct page *src)
> {
>         struct hstate *h = page_hstate(src);
>         if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES)) {
> ...
> 
> This patch creates a copy_high_order_page() which can
> be used on THP pages.

We already have copy_user_huge_page() and copy_user_gigantic_page() in
generic code (mm/memory.c). I think copy_gigantic_page() and
copy_huge_page() should be moved there too.

BTW, I think pages_per_huge_page in copy_user_huge_page() is redunand:
compound_order(page) should be enough, right?

-- 
 Kirill A. Shutemov
