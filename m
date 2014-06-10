Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaFJXkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:40:09 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:40683 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaFJXkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:40:07 -0400
Date: Tue, 10 Jun 2014 16:40:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 02/10] mm, compaction: report compaction as contended
 only due to lock contention
In-Reply-To: <5396AF88.4060703@suse.cz>
Message-ID: <alpine.DEB.2.02.1406101639170.32203@chino.kir.corp.google.com>
References: <1402305982-6928-1-git-send-email-vbabka@suse.cz> <1402305982-6928-2-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1406091647140.17705@chino.kir.corp.google.com> <5396AF88.4060703@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Vlastimil Babka wrote:

> > > diff --git a/mm/compaction.c b/mm/compaction.c
> > > index b73b182..d37f4a8 100644
> > > --- a/mm/compaction.c
> > > +++ b/mm/compaction.c
> > > @@ -185,9 +185,14 @@ static void update_pageblock_skip(struct
> > > compact_control *cc,
> > >   }
> > >   #endif /* CONFIG_COMPACTION */
> > > 
> > > -static inline bool should_release_lock(spinlock_t *lock)
> > > +enum compact_contended should_release_lock(spinlock_t *lock)
> > >   {
> > > -	return need_resched() || spin_is_contended(lock);
> > > +	if (need_resched())
> > > +		return COMPACT_CONTENDED_SCHED;
> > > +	else if (spin_is_contended(lock))
> > > +		return COMPACT_CONTENDED_LOCK;
> > > +	else
> > > +		return COMPACT_CONTENDED_NONE;
> > >   }
> > > 
> > >   /*
> > 
> > I think eventually we're going to remove the need_resched() heuristic
> > entirely and so enum compact_contended might be overkill, but do we need
> > to worry about spin_is_contended(lock) && need_resched() reporting
> > COMPACT_CONTENDED_SCHED here instead of COMPACT_CONTENDED_LOCK?
> 
> Hm right, maybe I should reorder the two tests.
> 

Yes, please.

> > > @@ -202,7 +207,9 @@ static inline bool should_release_lock(spinlock_t
> > > *lock)
> > >   static bool compact_checklock_irqsave(spinlock_t *lock, unsigned long
> > > *flags,
> > >   				      bool locked, struct compact_control *cc)
> > >   {
> > > -	if (should_release_lock(lock)) {
> > > +	enum compact_contended contended = should_release_lock(lock);
> > > +
> > > +	if (contended) {
> > >   		if (locked) {
> > >   			spin_unlock_irqrestore(lock, *flags);
> > >   			locked = false;
> > > @@ -210,7 +217,7 @@ static bool compact_checklock_irqsave(spinlock_t
> > > *lock, unsigned long *flags,
> > > 
> > >   		/* async aborts if taking too long or contended */
> > >   		if (cc->mode == MIGRATE_ASYNC) {
> > > -			cc->contended = true;
> > > +			cc->contended = contended;
> > >   			return false;
> > >   		}
> > > 
> > > @@ -236,7 +243,7 @@ static inline bool compact_should_abort(struct
> > > compact_control *cc)
> > >   	/* async compaction aborts if contended */
> > >   	if (need_resched()) {
> > >   		if (cc->mode == MIGRATE_ASYNC) {
> > > -			cc->contended = true;
> > > +			cc->contended = COMPACT_CONTENDED_SCHED;
> > >   			return true;
> > >   		}
> > > 
> > > @@ -1095,7 +1102,8 @@ static unsigned long compact_zone_order(struct zone
> > > *zone, int order,
> > >   	VM_BUG_ON(!list_empty(&cc.freepages));
> > >   	VM_BUG_ON(!list_empty(&cc.migratepages));
> > > 
> > > -	*contended = cc.contended;
> > > +	/* We only signal lock contention back to the allocator */
> > > +	*contended = cc.contended == COMPACT_CONTENDED_LOCK;
> > >   	return ret;
> > >   }
> > > 
> > 
> > Hmm, since the only thing that matters for cc->contended is
> > COMPACT_CONTENDED_LOCK, it may make sense to just leave this as a bool
> > within struct compact_control instead of passing the actual reason around
> > when it doesn't matter.
> 
> That's what I thought first. But we set cc->contended in
> isolate_freepages_block() and then check it in isolate_freepages() and
> compaction_alloc() to make sure we don't continue the free scanner once
> contention (or need_resched()) is detected. And introducing an enum, even if
> temporary measure, seemed simpler than making that checking more complex. This
> way it can stay the same once we get rid of need_resched().
> 

Ok, we can always reconsider it later after need_resched() is removed.
