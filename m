Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803AbaEMOSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:18:03 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34413 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbaEMOR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:17:58 -0400
Date: Tue, 13 May 2014 16:17:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 19/19] mm: filemap: Avoid unnecessary barries and
 waitqueue lookups in unlock_page fastpath
Message-ID: <20140513141748.GD2485@laptop.programming.kicks-ass.net>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
 <1399974350-11089-20-git-send-email-mgorman@suse.de>
 <20140513125313.GR23991@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513125313.GR23991@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 01:53:13PM +0100, Mel Gorman wrote:
> On Tue, May 13, 2014 at 10:45:50AM +0100, Mel Gorman wrote:
> >  void unlock_page(struct page *page)
> >  {
> > +	wait_queue_head_t *wqh = clear_page_waiters(page);
> > +
> >  	VM_BUG_ON_PAGE(!PageLocked(page), page);
> > +
> > +	/*
> > +	 * No additional barrier needed due to clear_bit_unlock barriering all updates
> > +	 * before waking waiters
> > +	 */
> >  	clear_bit_unlock(PG_locked, &page->flags);
> > -	smp_mb__after_clear_bit();
> > -	wake_up_page(page, PG_locked);
> 
> This is wrong. The smp_mb__after_clear_bit() is still required to ensure
> that the cleared bit is visible before the wakeup on all architectures.

wakeup implies a mb, and I just noticed that our Documentation is
'obsolete' and only mentions it implies a wmb.

Also, if you're going to use smp_mb__after_atomic() you can use
clear_bit() and not use clear_bit_unlock().



---
Subject: doc: Update wakeup barrier documentation

As per commit e0acd0a68ec7 ("sched: fix the theoretical signal_wake_up()
vs schedule() race") both wakeup and schedule now imply a full barrier.

Furthermore, the barrier is unconditional when calling try_to_wake_up()
and has been for a fair while.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 Documentation/memory-barriers.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 46412bded104..dae5158c2382 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -1881,9 +1881,9 @@ The whole sequence above is available in various canned forms, all of which
 	event_indicated = 1;
 	wake_up_process(event_daemon);
 
-A write memory barrier is implied by wake_up() and co. if and only if they wake
-something up.  The barrier occurs before the task state is cleared, and so sits
-between the STORE to indicate the event and the STORE to set TASK_RUNNING:
+A full memory barrier is implied by wake_up() and co. The barrier occurs
+before the task state is cleared, and so sits between the STORE to indicate
+the event and the STORE to set TASK_RUNNING:
 
 	CPU 1				CPU 2
 	===============================	===============================
