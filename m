Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbaEOPE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:04:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbaEOPEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:04:24 -0400
Date: Thu, 15 May 2014 17:03:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] mm: filemap: Avoid unnecessary barries and waitqueue
	lookups in unlock_page fastpath v4
Message-ID: <20140515150325.GA30668@redhat.com>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de> <1399974350-11089-20-git-send-email-mgorman@suse.de> <20140513125313.GR23991@suse.de> <20140513141748.GD2485@laptop.programming.kicks-ass.net> <20140514161152.GA2615@redhat.com> <20140514192945.GA10830@redhat.com> <20140515104808.GF23991@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515104808.GF23991@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15, Mel Gorman wrote:
>
> This patch introduces a new page flag for 64-bit capable machines,
> PG_waiters, to signal there are processes waiting on PG_lock and uses it to
> avoid memory barriers and waitqueue hash lookup in the unlock_page fastpath.

I can't apply this patch, it depends on something else, so I am not sure
I read it correctly. I'll try to read it later, just one question for now.

>  void unlock_page(struct page *page)
>  {
> +	wait_queue_head_t *wqh = clear_page_waiters(page);
> +
>  	VM_BUG_ON_PAGE(!PageLocked(page), page);
> -	clear_bit_unlock(PG_locked, &page->flags);
> +
> +	/*
> +	 * clear_bit_unlock is not necessary in this case as there is no
> +	 * need to strongly order the clearing of PG_waiters and PG_locked.

OK,

> +	 * The smp_mb__after_atomic() barrier is still required for RELEASE
> +	 * semantics as there is no guarantee that a wakeup will take place
> +	 */
> +	clear_bit(PG_locked, &page->flags);
>  	smp_mb__after_atomic();

But clear_bit_unlock() provides the release semantics, so why mb__after is
better?

> -	wake_up_page(page, PG_locked);
> +
> +	/*
> +	 * Wake the queue if waiters were detected. Ordinarily this wakeup
> +	 * would be unconditional to catch races between the lock bit being
> +	 * set and a new process joining the queue. However, that would
> +	 * require the waitqueue to be looked up every time. Instead we
> +	 * optimse for the uncontended and non-race case and recover using
> +	 * a timeout in sleep_on_page.
> +	 */
> +	if (wqh)
> +		__wake_up_bit(wqh, &page->flags, PG_locked);

This is what I can't understand. Given that PageWaiters() logic is racy
anyway (and timeout(HZ) should save us), why do we need to call
clear_page_waiters() beforehand? Why unlock_page/end_page_writeback can't
simply call wake_up_page_bit() which checks/clears PG_waiters at the end?

Oleg.

