Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaEOPfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:35:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaEOPfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:35:23 -0400
Date: Thu, 15 May 2014 17:34:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20140515153424.GB30668@redhat.com>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de> <1399974350-11089-20-git-send-email-mgorman@suse.de> <20140513125313.GR23991@suse.de> <20140513141748.GD2485@laptop.programming.kicks-ass.net> <20140514161152.GA2615@redhat.com> <20140514192945.GA10830@redhat.com> <20140515104808.GF23991@suse.de> <20140515132058.GL30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515132058.GL30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15, Peter Zijlstra wrote:
>
> So I suppose I'm failing to see the problem with something like:

Yeeees, I was thinking about something like this too ;)

> static inline void lock_page(struct page *page)
> {
> 	if (!trylock_page(page))
> 		__lock_page(page);
> }
>
> static inline void unlock_page(struct page *page)
> {
> 	clear_bit_unlock(&page->flags, PG_locked);
> 	if (PageWaiters(page))
> 		__unlock_page();
> }

but in this case we need mb() before PageWaiters(), I guess.

> void __lock_page(struct page *page)
> {
> 	struct wait_queue_head_t *wqh = page_waitqueue(page);
> 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
>
> 	spin_lock_irq(&wqh->lock);
> 	if (!PageWaiters(page))
> 		SetPageWaiters(page);
>
> 	wait.flags |= WQ_FLAG_EXCLUSIVE;
> 	preempt_disable();

why?

> 	do {
> 		if (list_empty(&wait->task_list))
> 			__add_wait_queue_tail(wqh, &wait);
>
> 		set_current_state(TASK_UNINTERRUPTIBLE);
>
> 		if (test_bit(wait.key.bit_nr, wait.key.flags)) {
> 			spin_unlock_irq(&wqh->lock);
> 			schedule_preempt_disabled();
> 			spin_lock_irq(&wqh->lock);

OK, probably to avoid the preemption before schedule(). Still can't
undestand why this makes sense, but in this case it would be better
to do disable/enable under "if (test_bit())" ?

Of course, this needs more work for lock_page_killable(), but this
should be simple.

Oleg.

