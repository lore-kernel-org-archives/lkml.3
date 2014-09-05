Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbaIEOrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:47:43 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60123 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbaIEOrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:47:42 -0400
Date: Fri, 5 Sep 2014 10:47:23 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Dave Hansen <dave@sr71.net>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@intel.com>, Tejun Heo <tj@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: regression caused by cgroups optimization in 3.17-rc2
Message-ID: <20140905144723.GB13392@cmpxchg.org>
References: <54061505.8020500@sr71.net>
 <5406262F.4050705@intel.com>
 <54062F32.5070504@sr71.net>
 <20140904142721.GB14548@dhcp22.suse.cz>
 <5408CB2E.3080101@sr71.net>
 <20140905092537.GC26243@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905092537.GC26243@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 11:25:37AM +0200, Michal Hocko wrote:
> @@ -900,10 +900,10 @@ void lru_add_drain_all(void)
>   * grabbed the page via the LRU.  If it did, give up: shrink_inactive_list()
>   * will free it.
>   */
> -void release_pages(struct page **pages, int nr, bool cold)
> +static void release_lru_pages(struct page **pages, int nr,
> +			      struct list_head *pages_to_free)
>  {
>  	int i;
> -	LIST_HEAD(pages_to_free);
>  	struct zone *zone = NULL;
>  	struct lruvec *lruvec;
>  	unsigned long uninitialized_var(flags);
> @@ -943,11 +943,26 @@ void release_pages(struct page **pages, int nr, bool cold)
>  		/* Clear Active bit in case of parallel mark_page_accessed */
>  		__ClearPageActive(page);
>  
> -		list_add(&page->lru, &pages_to_free);
> +		list_add(&page->lru, pages_to_free);
>  	}
>  	if (zone)
>  		spin_unlock_irqrestore(&zone->lru_lock, flags);
> +}
> +/*
> + * Batched page_cache_release(). Frees and uncharges all given pages
> + * for which the reference count drops to 0.
> + */
> +void release_pages(struct page **pages, int nr, bool cold)
> +{
> +	LIST_HEAD(pages_to_free);
>  
> +	while (nr) {
> +		int batch = min(nr, PAGEVEC_SIZE);
> +
> +		release_lru_pages(pages, batch, &pages_to_free);
> +		pages += batch;
> +		nr -= batch;
> +	}

We might be able to process a lot more pages in one go if nobody else
needs the lock or the CPU.  Can't we just cycle the lock or reschedule
if necessary?

diff --git a/mm/swap.c b/mm/swap.c
index 6b2dc3897cd5..ee0cf21dd521 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -944,6 +944,15 @@ void release_pages(struct page **pages, int nr, bool cold)
 		__ClearPageActive(page);
 
 		list_add(&page->lru, &pages_to_free);
+
+		if (should_resched() ||
+		    (zone && spin_needbreak(&zone->lru_lock))) {
+			if (zone) {
+				spin_unlock_irqrestore(&zone->lru_lock, flags);
+				zone = NULL;
+			}
+			cond_resched();
+		}
 	}
 	if (zone)
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 3e0ec83d000c..c487ca4682a4 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -262,19 +262,12 @@ void free_page_and_swap_cache(struct page *page)
  */
 void free_pages_and_swap_cache(struct page **pages, int nr)
 {
-	struct page **pagep = pages;
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
+		free_swap_cache(pages[i]);
+	release_pages(pages, nr, false);
 }
 
 /*
