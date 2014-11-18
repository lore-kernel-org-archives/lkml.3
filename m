Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaKRIrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:47:23 -0500
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:56561 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaKRIrW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:47:22 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        Steve Capper <steve.capper@linaro.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 06/19] mm: store mapcount for compound page separate
Thread-Topic: [PATCH 06/19] mm: store mapcount for compound page separate
Thread-Index: AQHP+QfhC/Yx8W8vu0evpav335us2Zxljo2A
Date: Tue, 18 Nov 2014 08:43:00 +0000
Message-ID: <20141118084337.GA16714@hori1.linux.bs1.fc.nec.co.jp>
References: <1415198994-15252-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1415198994-15252-7-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1415198994-15252-7-git-send-email-kirill.shutemov@linux.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.25]
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <55EA7FAC64A2D24D80368801FDB9F162@gisp.nec.co.jp>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 04:49:41PM +0200, Kirill A. Shutemov wrote:
> We're going to allow mapping of individual 4k pages of THP compound and
> we need a cheap way to find out how many time the compound page is
> mapped with PMD -- compound_mapcount() does this.
> 
> page_mapcount() counts both: PTE and PMD mappings of the page.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---

...

> @@ -1837,6 +1839,9 @@ static void __split_huge_page_refcount(struct page *page,
>  	atomic_sub(tail_count, &page->_count);
>  	BUG_ON(atomic_read(&page->_count) <= 0);
>  
> +	page->_mapcount = *compound_mapcount_ptr(page);

Is atomic_set() necessary?

> +	page[1].mapping = page->mapping;
> +
>  	__mod_zone_page_state(zone, NR_ANON_TRANSPARENT_HUGEPAGES, -1);
>  
>  	ClearPageCompound(page);

...

> @@ -760,6 +763,8 @@ static bool free_pages_prepare(struct page *page, unsigned int order)
>  		bad += free_pages_check(page + i);
>  	if (bad)
>  		return false;
> +	if (order)
> +		page[1].mapping = NULL;
>  
>  	if (!PageHighMem(page)) {
>  		debug_check_no_locks_freed(page_address(page),
> @@ -6632,10 +6637,12 @@ static void dump_page_flags(unsigned long flags)
>  void dump_page_badflags(struct page *page, const char *reason,
>  		unsigned long badflags)
>  {
> -	printk(KERN_ALERT
> -	       "page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
> +	pr_alert("page:%p count:%d mapcount:%d mapping:%p index:%#lx",
>  		page, atomic_read(&page->_count), page_mapcount(page),
>  		page->mapping, page->index);
> +	if (PageCompound(page))

> +		printk(" compound_mapcount: %d", compound_mapcount(page));
> +	printk("\n");

These two printk() should be pr_alert(), too?

>  	dump_page_flags(page->flags);
>  	if (reason)
>  		pr_alert("page dumped because: %s\n", reason);
> diff --git a/mm/rmap.c b/mm/rmap.c
> index f706a6af1801..eecc9301847d 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -986,9 +986,30 @@ void page_add_anon_rmap(struct page *page,
>  void do_page_add_anon_rmap(struct page *page,
>  	struct vm_area_struct *vma, unsigned long address, int flags)
>  {
> -	int first = atomic_inc_and_test(&page->_mapcount);
> +	bool compound = flags & RMAP_COMPOUND;
> +	bool first;
> +
> +	VM_BUG_ON_PAGE(!PageLocked(compound_head(page)), page);
> +
> +	if (PageTransCompound(page)) {
> +		struct page *head_page = compound_head(page);
> +
> +		if (compound) {
> +			VM_BUG_ON_PAGE(!PageTransHuge(page), page);
> +			first = atomic_inc_and_test(compound_mapcount_ptr(page));

Is compound_mapcount_ptr() well-defined for tail pages?
This function seems to access struct page of the page next to a given page,
so if the given page is the last tail page of a thp, page outside the thp
will be accessed. Do you have a prevention from this?
atomic_inc_and_test(compound_mapcount_ptr(head_page)) is what you intended?

> +		} else {
> +			/* Anon THP always mapped first with PMD */
> +			first = 0;
> +			VM_BUG_ON_PAGE(!compound_mapcount(head_page),
> +					head_page);
> +			atomic_inc(&page->_mapcount);
> +		}
> +	} else {
> +		VM_BUG_ON_PAGE(compound, page);
> +		first = atomic_inc_and_test(&page->_mapcount);
> +	}
> +
>  	if (first) {
> -		bool compound = flags & RMAP_COMPOUND;
>  		int nr = compound ? hpage_nr_pages(page) : 1;
>  		/*
>  		 * We use the irq-unsafe __{inc|mod}_zone_page_stat because

...

> @@ -1032,10 +1052,19 @@ void page_add_new_anon_rmap(struct page *page,
>  
>  	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
>  	SetPageSwapBacked(page);
> -	atomic_set(&page->_mapcount, 0); /* increment count (starts at -1) */
>  	if (compound) {
> +		atomic_t *compound_mapcount;
> +
>  		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
> +		compound_mapcount = (atomic_t *)&page[1].mapping;

You can use compound_mapcount_ptr() here.

Thanks,
Naoya Horiguchi

> +		/* increment count (starts at -1) */
> +		atomic_set(compound_mapcount, 0);
>  		__inc_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
> +	} else {
> +		/* Anon THP always mapped first with PMD */
> +		VM_BUG_ON_PAGE(PageTransCompound(page), page);
> +		/* increment count (starts at -1) */
> +		atomic_set(&page->_mapcount, 0);
>  	}
>  	__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, nr);
>  	__page_set_anon_rmap(page, vma, address, 1);