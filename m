Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3FJPiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:38:07 -0400
Received: from www.sr71.net ([198.145.64.142]:35184 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab3FJPiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:38:05 -0400
Message-ID: <51B2029A.8050504@sr71.net>
Date: Fri, 07 Jun 2013 08:56:10 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 14/39] thp, mm: rewrite delete_from_page_cache() to
 support huge pages
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com> <1368321816-17719-15-git-send-email-kirill.shutemov@linux.intel.com> <519BD595.5040405@sr71.net> <20130528122812.0D624E0090@blue.fi.intel.com> <20130607151025.241EFE0090@blue.fi.intel.com>
In-Reply-To: <20130607151025.241EFE0090@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 08:10 AM, Kirill A. Shutemov wrote:
> +	/*
> +	 * When we add a huge page to page cache we take only reference to head
> +	 * page, but on split we need to take addition reference to all tail
> +	 * pages since they are still in page cache after splitting.
> +	 */
> +	init_tail_refcount = PageAnon(page) ? 0 : 1;

What's the "init" for in the name?

In add_to_page_cache_locked() in patch 12/39, you do
> +       spin_lock_irq(&mapping->tree_lock);
> +       for (i = 0; i < nr; i++) {
> +               page_cache_get(page + i);

That looks to me to be taking references to the tail pages.  What gives? :)

>  	for (i = HPAGE_PMD_NR - 1; i >= 1; i--) {
>  		struct page *page_tail = page + i;
>  
> @@ -1587,8 +1595,9 @@ static void __split_huge_page_refcount(struct page *page,
>  		 * atomic_set() here would be safe on all archs (and
>  		 * not only on x86), it's safer to use atomic_add().
>  		 */
> -		atomic_add(page_mapcount(page) + page_mapcount(page_tail) + 1,
> -			   &page_tail->_count);
> +		atomic_add(init_tail_refcount + page_mapcount(page) +
> +				page_mapcount(page_tail) + 1,
> +				&page_tail->_count);
>  
>  		/* after clearing PageTail the gup refcount can be released */
>  		smp_mb();

This does look much better in general, though.

