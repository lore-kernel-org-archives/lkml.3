Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaIDO13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:27:29 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:62829 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbaIDO11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:27:27 -0400
Date: Thu, 4 Sep 2014 16:27:21 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Dave Hansen <dave@sr71.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@intel.com>, Tejun Heo <tj@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: regression caused by cgroups optimization in 3.17-rc2
Message-ID: <20140904142721.GB14548@dhcp22.suse.cz>
References: <54061505.8020500@sr71.net>
 <5406262F.4050705@intel.com>
 <54062F32.5070504@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54062F32.5070504@sr71.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry to reply so late]

On Tue 02-09-14 13:57:22, Dave Hansen wrote:
> I, of course, forgot to include the most important detail.  This appears
> to be pretty run-of-the-mill spinlock contention in the resource counter
> code.  Nearly 80% of the CPU is spent spinning in the charge or uncharge
> paths in the kernel.  It is apparently spinning on res_counter->lock in
> both the charge and uncharge paths.
> 
> It already does _some_ batching here on the free side, but that
> apparently breaks down after ~40 threads.
> 
> It's a no-brainer since the patch in question removed an optimization
> skipping the charging, and now we're seeing overhead from the charging.
> 
> Here's the first entry from perf top:
> 
>     80.18%    80.18%  [kernel]               [k] _raw_spin_lock
>                   |
>                   --- _raw_spin_lock
>                      |
>                      |--66.59%-- res_counter_uncharge_until
>                      |          res_counter_uncharge
>                      |          uncharge_batch
>                      |          uncharge_list
>                      |          mem_cgroup_uncharge_list
>                      |          release_pages
>                      |          free_pages_and_swap_cache

Ouch. free_pages_and_swap_cache completely kills the uncharge batching
because it reduces it to PAGEVEC_SIZE batches.

I think we really do not need PAGEVEC_SIZE batching anymore. We are
already batching on tlb_gather layer. That one is limited so I think
the below should be safe but I have to think about this some more. There
is a risk of prolonged lru_lock wait times but the number of pages is
limited to 10k and the heavy work is done outside of the lock. If this
is really a problem then we can tear LRU part and the actual
freeing/uncharging into a separate functions in this path.

Could you test with this half baked patch, please? I didn't get to test
it myself unfortunately.
---
diff --git a/mm/swap_state.c b/mm/swap_state.c
index ef1f39139b71..154444918685 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -265,18 +265,12 @@ void free_page_and_swap_cache(struct page *page)
 void free_pages_and_swap_cache(struct page **pages, int nr)
 {
 	struct page **pagep = pages;
+	int i;
 
 	lru_add_drain();
-	while (nr) {
-		int todo = min(nr, PAGEVEC_SIZE);
-		int i;
-
-		for (i = 0; i < todo; i++)
-			free_swap_cache(pagep[i]);
-		release_pages(pagep, todo, false);
-		pagep += todo;
-		nr -= todo;
-	}
+	for (i = 0; i < nr; i++)
+		free_swap_cache(pagep[i]);
+	release_pages(pagep, nr, false);
 }
 
 /*
-- 
Michal Hocko
SUSE Labs
