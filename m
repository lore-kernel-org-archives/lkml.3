Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab3KSXLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:11:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab3KSXLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:11:48 -0500
Date: Tue, 19 Nov 2013 15:11:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Khalid Aziz <khalid.aziz@oracle.com>,
        Pravin Shelar <pshelar@nicira.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/3] mm: hugetlbfs: fix hugetlbfs optimization
Message-Id: <20131119151146.a1e1f9073a0e5d35c4e83bab@linux-foundation.org>
In-Reply-To: <1384537668-10283-2-git-send-email-aarcange@redhat.com>
References: <1384537668-10283-1-git-send-email-aarcange@redhat.com>
	<1384537668-10283-2-git-send-email-aarcange@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Nov 2013 18:47:46 +0100 Andrea Arcangeli <aarcange@redhat.com> wrote:

> The patch from commit 7cb2ef56e6a8b7b368b2e883a0a47d02fed66911 can
> cause dereference of a dangling pointer if split_huge_page runs during
> PageHuge() if there are updates to the tail_page->private field.
> 
> Also it is repeating compound_head twice for hugetlbfs and it is
> running compound_head+compound_trans_head for THP when a single one is
> needed in both cases.
> 
> The new code within the PageSlab() check doesn't need to verify that
> the THP page size is never bigger than the smallest hugetlbfs page
> size, to avoid memory corruption.
> 
> A longstanding theoretical race condition was found while fixing the
> above (see the change right after the skip_unlock label, that is
> relevant for the compound_lock path too).
> 
> By re-establishing the _mapcount tail refcounting for all compound
> pages, this also fixes the below problem:
> 
> echo 0 >/sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> 
> ...
>
> +/*
> + * PageHeadHuge() only returns true for hugetlbfs head page, but not for
> + * normal or transparent huge pages.
> + */
> +int PageHeadHuge(struct page *page_head)
> +{
> +	compound_page_dtor *dtor;
> +
> +	if (!PageHead(page_head))
> +		return 0;
> +
> +	dtor = get_compound_page_dtor(page_head);
> +
> +	return dtor == free_huge_page;
> +}
> +EXPORT_SYMBOL_GPL(PageHeadHuge);

This is all rather verbose.  How about we do this?

--- a/mm/hugetlb.c~mm-hugetlbc-simplify-pageheadhuge-and-pagehuge
+++ a/mm/hugetlb.c
@@ -690,15 +690,11 @@ static void prep_compound_gigantic_page(
  */
 int PageHuge(struct page *page)
 {
-	compound_page_dtor *dtor;
-
 	if (!PageCompound(page))
 		return 0;
 
 	page = compound_head(page);
-	dtor = get_compound_page_dtor(page);
-
-	return dtor == free_huge_page;
+	return get_compound_page_dtor(page) == free_huge_page;
 }
 EXPORT_SYMBOL_GPL(PageHuge);
 
@@ -708,14 +704,10 @@ EXPORT_SYMBOL_GPL(PageHuge);
  */
 int PageHeadHuge(struct page *page_head)
 {
-	compound_page_dtor *dtor;
-
 	if (!PageHead(page_head))
 		return 0;
 
-	dtor = get_compound_page_dtor(page_head);
-
-	return dtor == free_huge_page;
+	return get_compound_page_dtor(page_head) == free_huge_page;
 }
 EXPORT_SYMBOL_GPL(PageHeadHuge);
 
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -82,19 +82,6 @@ static void __put_compound_page(struct page *page)
>  
>  static void put_compound_page(struct page *page)

This function has become quite crazy.  I sat down to refamiliarize but
immediately failed.

: static void put_compound_page(struct page *page)
: {
: 	if (unlikely(PageTail(page))) {
:	...
: 	} else if (put_page_testzero(page)) {
: 		if (PageHead(page))

How can a page be both PageTail() and PageHead()?

: 			__put_compound_page(page);
: 		else
: 			__put_single_page(page);
: 	}
: }
: 
: 
