Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbaEMMxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:53:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54515 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759422AbaEMMxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:53:17 -0400
Date: Tue, 13 May 2014 13:53:13 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 19/19] mm: filemap: Avoid unnecessary barries and
 waitqueue lookups in unlock_page fastpath
Message-ID: <20140513125313.GR23991@suse.de>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
 <1399974350-11089-20-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1399974350-11089-20-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 10:45:50AM +0100, Mel Gorman wrote:
>  void unlock_page(struct page *page)
>  {
> +	wait_queue_head_t *wqh = clear_page_waiters(page);
> +
>  	VM_BUG_ON_PAGE(!PageLocked(page), page);
> +
> +	/*
> +	 * No additional barrier needed due to clear_bit_unlock barriering all updates
> +	 * before waking waiters
> +	 */
>  	clear_bit_unlock(PG_locked, &page->flags);
> -	smp_mb__after_clear_bit();
> -	wake_up_page(page, PG_locked);

This is wrong. The smp_mb__after_clear_bit() is still required to ensure
that the cleared bit is visible before the wakeup on all architectures.

---8<---
diff --git a/mm/filemap.c b/mm/filemap.c
index 6ac066e..028b5a1 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -819,11 +819,8 @@ void unlock_page(struct page *page)
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
-	/*
-	 * No additional barrier needed due to clear_bit_unlock barriering all updates
-	 * before waking waiters
-	 */
 	clear_bit_unlock(PG_locked, &page->flags);
+	smp_mb__after_clear_bit();
 
 	/*
 	 * Wake the queue if waiters were detected. Ordinarily this wakeup
