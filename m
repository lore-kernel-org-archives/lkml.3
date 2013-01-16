Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab3APVl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:41:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3APVl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:41:57 -0500
Date: Wed, 16 Jan 2013 13:41:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Sonny Rao <sonnyrao@google.com>, Bryan Freed <bfreed@google.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/2] mm: prevent to add a page to swap if may_writepage
 is unset
Message-Id: <20130116134155.18092f1a.akpm@linux-foundation.org>
In-Reply-To: <1357712474-27595-2-git-send-email-minchan@kernel.org>
References: <1357712474-27595-1-git-send-email-minchan@kernel.org>
	<1357712474-27595-2-git-send-email-minchan@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Jan 2013 15:21:13 +0900
Minchan Kim <minchan@kernel.org> wrote:
>

This changelog is quite hard to understand :(

> Recently, Luigi reported there are lots of free swap space when
> OOM happens. It's easily reproduced on zram-over-swap, where
> many instance of memory hogs are running and laptop_mode is enabled.
> 
> Luigi reported there was no problem when he disabled laptop_mode.
> The problem when I investigate problem is following as.
> 
> try_to_free_pages disable may_writepage if laptop_mode is enabled.
> shrink_page_list adds lots of anon pages in swap cache by
> add_to_swap, which makes pages Dirty and rotate them to head of
> inactive LRU without pageout. If it is repeated, inactive anon LRU
> is full of Dirty and SwapCache pages.

"Dirty and SwapCache" is ambigious.  Does it mean "dirty pages and
swapcache pages" or does it mean "dirty swapcache pages".  The latter,
I expect.

> 
> In case of that, isolate_lru_pages fails because it try to isolate
> clean page due to may_writepage == 0.
> 
> The may_writepage could be 1 only if total_scanned is higher than
> writeback_threshold in do_try_to_free_pages but unfortunately,
> VM can't isolate anon pages from inactive anon lru list by
> above reason and we already reclaimed all file-backed pages.
> So it ends up OOM killing.

Here, please expand upon "by above reason".  Explain here exactly why
scanning is unsuccessful.

> This patch prevents to add a page to swap cache unnecessary when
> may_writepage is unset so anoymous lru list isn't full of
> Dirty/Swapcache page. So VM can isolate pages from anon lru list,
> which ends up setting may_writepage to 1 and could swap out
> anon lru pages. When OOM triggers, I confirmed swap space was full.
> 
> ...
>
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -780,6 +780,8 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  		if (PageAnon(page) && !PageSwapCache(page)) {
>  			if (!(sc->gfp_mask & __GFP_IO))
>  				goto keep_locked;
> +			if (!sc->may_writepage)
> +				goto keep_locked;
>  			if (!add_to_swap(page))
>  				goto activate_locked;
>  			may_enter_fs = 1;

Needs a comment explaining why we bale out in this case, please.

If I'm understanding it correctly, this change causes the kernel to
move less anonymous memory onto the inactive anon LRU and thereby
causes the scanner to be more successful in locating clean swapcache
pages on that list?  But that makes no sense, because from your
description it appears the intent of the patch is to use *more* swap.
