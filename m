Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaB1XOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 18:14:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaB1XO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 18:14:29 -0500
Date: Fri, 28 Feb 2014 15:14:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: sasha.levin@oracle.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        riel@redhat.com
Subject: Re: [PATCH v2] mm, hugetlbfs: fix rmapping for anonymous hugepages
 with page_pgoff()
Message-Id: <20140228151427.dd232b07960dcf876112e191@linux-foundation.org>
In-Reply-To: <5310ea8b.c425e00a.2cd9.ffffe097SMTPIN_ADDED_BROKEN@mx.google.com>
References: <1393475977-3381-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1393475977-3381-3-git-send-email-n-horiguchi@ah.jp.nec.com>
	<20140227131957.d81cf9a643f4d3fd6b8d8b16@linux-foundation.org>
	<530fb3ee.03cb0e0a.407a.ffffffbcSMTPIN_ADDED_BROKEN@mx.google.com>
	<5310ea8b.c425e00a.2cd9.ffffe097SMTPIN_ADDED_BROKEN@mx.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014 14:59:02 -0500 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> page->index stores pagecache index when the page is mapped into file mapping
> region, and the index is in pagecache size unit, so it depends on the page
> size. Some of users of reverse mapping obviously assumes that page->index
> is in PAGE_CACHE_SHIFT unit, so they don't work for anonymous hugepage.
> 
> For example, consider that we have 3-hugepage vma and try to mbind the 2nd
> hugepage to migrate to another node. Then the vma is split and migrate_page()
> is called for the 2nd hugepage (belonging to the middle vma.)
> In migrate operation, rmap_walk_anon() tries to find the relevant vma to
> which the target hugepage belongs, but here we miscalculate pgoff.
> So anon_vma_interval_tree_foreach() grabs invalid vma, which fires VM_BUG_ON.
> 
> This patch introduces a new API that is usable both for normal page and
> hugepage to get PAGE_SIZE offset from page->index. Users should clearly
> distinguish page_index for pagecache index and page_pgoff for page offset.
> 
> ..
>
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -307,6 +307,22 @@ static inline loff_t page_file_offset(struct page *page)
>  	return ((loff_t)page_file_index(page)) << PAGE_CACHE_SHIFT;
>  }
>  
> +static inline unsigned int page_size_order(struct page *page)
> +{
> +	return unlikely(PageHuge(page)) ?
> +		huge_page_size_order(page) :
> +		(PAGE_CACHE_SHIFT - PAGE_SHIFT);
> +}

Could use some nice documentation, please.  Why it exists, what it
does.  Particularly: what sort of pages it can and can't operate on,
and why.

The presence of PAGE_CACHE_SIZE is unfortunate - it at least implies
that the page is a pagecache page.  I dunno, maybe just use "0"?

