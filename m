Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbaEODee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 23:34:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54122 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaEODed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 23:34:33 -0400
Message-ID: <1400124866.26173.19.camel@cyc>
Subject: Re: [PATCH] mm/memory-failure.c: fix memory leak by race between
 poison and unpoison
From: cyc <soldier.cyc81@gmail.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Thu, 15 May 2014 11:34:26 +0800
In-Reply-To: <1400080891-5145-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1400080891-5145-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2014-05-14三的 11:21 -0400，Naoya Horiguchi写道：
> When a memory error happens on an in-use page or (free and in-use) hugepage,
> the victim page is isolated with its refcount set to one. When you try to
> unpoison it later, unpoison_memory() calls put_page() for it twice in order to
> bring the page back to free page pool (buddy or free hugepage list.)
> However, if another memory error occurs on the page which we are unpoisoning,
> memory_failure() returns without releasing the refcount which was incremented
> in the same call at first, which results in memory leak and unconsistent
> num_poisoned_pages statistics. This patch fixes it.

We assume that a new memory error occurs on the hugepage which we are
unpoisoning. 

          A   unpoisoned  B    poisoned    C          
hugepage: |---------------+++++++++++++++++|

There are two cases, so shown.
  1. the victim page belongs to A-B, the memory_failure will be blocked
by lock_page() until unlock_page() invoked by unpoison_memory().
  2. the victim page belongs to B-C, the memory_failure() will return
very soon at the beginning of this function.

So the new memory error will have no effect what you say so.

thx!
cyc 

> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: <stable@vger.kernel.org>    [2.6.32+]
> ---
>  mm/memory-failure.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git next-20140512.orig/mm/memory-failure.c next-20140512/mm/memory-failure.c
> index 9872af1b1e9d..93a08bd78c78 100644
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


