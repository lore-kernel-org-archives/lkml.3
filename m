Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab3BRKsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 05:48:53 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64533 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab3BRKsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 05:48:52 -0500
MIME-Version: 1.0
Date: Mon, 18 Feb 2013 18:48:50 +0800
Message-ID: <CAFNq8R4UYvygk8+X+NZgyGjgU5vBsEv1UM6MiUxah6iW8=0HrQ@mail.gmail.com>
Subject: Should a swapped out page be deleted from swap cache?
From: Li Haifeng <omycle@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For explain my question, the two points should be displayed as below.

1.  If an anonymous page is swapped out, this page will be deleted
from swap cache and be put back into buddy system.

2. When a page is swapped out, the sharing count of swap slot must not
be zero. That is, page_swapcount(page) will not return zero.

Are both of them above right?

According the two points above, I was confused to the line 655 below.
When a page is swapped out, the return value of page_swapcount(page)
will not be zero. So, the page couldn't be deleted from swap cache.

 644  * If swap is getting full, or if there are no more mappings of this page,
 645  * then try_to_free_swap is called to free its swap space.
 646  */
 647 int try_to_free_swap(struct page *page)
 648 {
 649         VM_BUG_ON(!PageLocked(page));
 650
 651         if (!PageSwapCache(page))
 652                 return 0;
 653         if (PageWriteback(page))
 654                 return 0;
 655         if (page_swapcount(page))//Has referenced by other swap out page.
 656                 return 0;
 657
 658         /*
 659          * Once hibernation has begun to create its image of memory,
 660          * there's a danger that one of the calls to try_to_free_swap()
 661          * - most probably a call from __try_to_reclaim_swap() while
 662          * hibernation is allocating its own swap pages for the image,
 663          * but conceivably even a call from memory reclaim - will free
 664          * the swap from a page which has already been recorded in the
 665          * image as a clean swapcache page, and then reuse its swap for
 666          * another page of the image.  On waking from hibernation, the
 667          * original page might be freed under memory pressure, then
 668          * later read back in from swap, now with the wrong data.
 669          *
 670          * Hibration suspends storage while it is writing the image
 671          * to disk so check that here.
 672          */
 673         if (pm_suspended_storage())
 674                 return 0;
 675
 676         delete_from_swap_cache(page);
 677         SetPageDirty(page);
 678         return 1;
 679 }

Thanks.
