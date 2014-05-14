Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaENWKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:10:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaENWKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:10:39 -0400
Date: Wed, 14 May 2014 15:10:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/memory-failure.c: fix memory leak by race between
 poison and unpoison
Message-Id: <20140514151037.37592c3bb31f51fdad8c5a42@linux-foundation.org>
In-Reply-To: <1400080891-5145-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1400080891-5145-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014 11:21:31 -0400 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> When a memory error happens on an in-use page or (free and in-use) hugepage,
> the victim page is isolated with its refcount set to one. When you try to
> unpoison it later, unpoison_memory() calls put_page() for it twice in order to
> bring the page back to free page pool (buddy or free hugepage list.)
> However, if another memory error occurs on the page which we are unpoisoning,
> memory_failure() returns without releasing the refcount which was incremented
> in the same call at first, which results in memory leak and unconsistent
> num_poisoned_pages statistics. This patch fixes it.
> 
> ...
>
> --- next-20140512.orig/mm/memory-failure.c
> +++ next-20140512/mm/memory-failure.c
> @@ -1153,6 +1153,8 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
>  	 */
>  	if (!PageHWPoison(p)) {
>  		printk(KERN_ERR "MCE %#lx: just unpoisoned\n", pfn);
> +		atomic_long_sub(nr_pages, &num_poisoned_pages);
> +		put_page(hpage);
>  		res = 0;
>  		goto out;
>  	}

Looking at the surrounding code...

	/*
	 * Lock the page and wait for writeback to finish.
	 * It's very difficult to mess with pages currently under IO
	 * and in many cases impossible, so we just avoid it here.
	 */
	lock_page(hpage);


lock_page() doesn't wait for writeback to finish -
wait_on_page_writeback() does that.  Either the code or the comment
could do with fixing.


