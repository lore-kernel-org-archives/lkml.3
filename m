Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaG2BDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 21:03:31 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:47112 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaG2BD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 21:03:28 -0400
Date: Mon, 28 Jul 2014 18:03:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm:;
Subject: Re: [PATCH v5 08/14] mm, compaction: periodically drop lock and
 restore IRQs in scanners
In-Reply-To: <1406553101-29326-9-git-send-email-vbabka@suse.cz>
Message-ID: <alpine.DEB.2.02.1407281801220.8998@chino.kir.corp.google.com>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-9-git-send-email-vbabka@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Vlastimil Babka wrote:

> Compaction scanners regularly check for lock contention and need_resched()
> through the compact_checklock_irqsave() function. However, if there is no
> contention, the lock can be held and IRQ disabled for potentially long time.
> 
> This has been addressed by commit b2eef8c0d091 ("mm: compaction: minimise the
> time IRQs are disabled while isolating pages for migration") for the migration
> scanner. However, the refactoring done by commit 2a1402aa044b ("mm: compaction:
> acquire the zone->lru_lock as late as possible") has changed the conditions so
> that the lock is dropped only when there's contention on the lock or
> need_resched() is true. Also, need_resched() is checked only when the lock is
> already held. The comment "give a chance to irqs before checking need_resched"
> is therefore misleading, as IRQs remain disabled when the check is done.
> 
> This patch restores the behavior intended by commit b2eef8c0d091 and also tries
> to better balance and make more deterministic the time spent by checking for
> contention vs the time the scanners might run between the checks. It also
> avoids situations where checking has not been done often enough before. The
> result should be avoiding both too frequent and too infrequent contention
> checking, and especially the potentially long-running scans with IRQs disabled
> and no checking of need_resched() or for fatal signal pending, which can happen
> when many consecutive pages or pageblocks fail the preliminary tests and do not
> reach the later call site to compact_checklock_irqsave(), as explained below.
> 
> Before the patch:
> 
> In the migration scanner, compact_checklock_irqsave() was called each loop, if
> reached. If not reached, some lower-frequency checking could still be done if
> the lock was already held, but this would not result in aborting contended
> async compaction until reaching compact_checklock_irqsave() or end of
> pageblock. In the free scanner, it was similar but completely without the
> periodical checking, so lock can be potentially held until reaching the end of
> pageblock.
> 
> After the patch, in both scanners:
> 
> The periodical check is done as the first thing in the loop on each
> SWAP_CLUSTER_MAX aligned pfn, using the new compact_unlock_should_abort()
> function, which always unlocks the lock (if locked) and aborts async compaction
> if scheduling is needed. It also aborts any type of compaction when a fatal
> signal is pending.
> 
> The compact_checklock_irqsave() function is replaced with a slightly different
> compact_trylock_irqsave(). The biggest difference is that the function is not
> called at all if the lock is already held. The periodical need_resched()
> checking is left solely to compact_unlock_should_abort(). The lock contention
> avoidance for async compaction is achieved by the periodical unlock by
> compact_unlock_should_abort() and by using trylock in compact_trylock_irqsave()
> and aborting when trylock fails. Sync compaction does not use trylock.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Acked-by: Minchan Kim <minchan@kernel.org>
> Acked-by: Mel Gorman <mgorman@suse.de>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: David Rientjes <rientjes@google.com>

Minor comment below.

> ---
>  mm/compaction.c | 121 ++++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 73 insertions(+), 48 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 2b8b6d8..1756ed8 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -223,61 +223,72 @@ static void update_pageblock_skip(struct compact_control *cc,
>  }
>  #endif /* CONFIG_COMPACTION */
>  
> -static int should_release_lock(spinlock_t *lock)
> +/*
> + * Compaction requires the taking of some coarse locks that are potentially
> + * very heavily contended. For async compaction, back out if the lock cannot
> + * be taken immediately. For sync compaction, spin on the lock if needed.
> + *
> + * Returns true if the lock is held
> + * Returns false if the lock is not held and compaction should abort
> + */
> +static bool compact_trylock_irqsave(spinlock_t *lock, unsigned long *flags,
> +						struct compact_control *cc)
>  {
> -	/*
> -	 * Sched contention has higher priority here as we may potentially
> -	 * have to abort whole compaction ASAP. Returning with lock contention
> -	 * means we will try another zone, and further decisions are
> -	 * influenced only when all zones are lock contended. That means
> -	 * potentially missing a lock contention is less critical.
> -	 */
> -	if (need_resched())
> -		return COMPACT_CONTENDED_SCHED;
> -	else if (spin_is_contended(lock))
> -		return COMPACT_CONTENDED_LOCK;
> -	else
> -		return COMPACT_CONTENDED_NONE;
> +	if (cc->mode == MIGRATE_ASYNC) {
> +		if (!spin_trylock_irqsave(lock, *flags)) {
> +			cc->contended = COMPACT_CONTENDED_LOCK;
> +			return false;
> +		}
> +	} else {
> +		spin_lock_irqsave(lock, *flags);
> +	}
> +
> +	return true;
>  }
>  
>  /*
>   * Compaction requires the taking of some coarse locks that are potentially
> - * very heavily contended. Check if the process needs to be scheduled or
> - * if the lock is contended. For async compaction, back out in the event
> - * if contention is severe. For sync compaction, schedule.
> + * very heavily contended. The lock should be periodically unlocked to avoid
> + * having disabled IRQs for a long time, even when there is nobody waiting on
> + * the lock. It might also be that allowing the IRQs will result in
> + * need_resched() becoming true. If scheduling is needed, async compaction
> + * aborts. Sync compaction schedules.
> + * Either compaction type will also abort if a fatal signal is pending.
> + * In either case if the lock was locked, it is dropped and not regained.
>   *
> - * Returns true if the lock is held.
> - * Returns false if the lock is released and compaction should abort
> + * Returns true if compaction should abort due to fatal signal pending, or
> + *		async compaction due to need_resched()
> + * Returns false when compaction can continue (sync compaction might have
> + *		scheduled)
>   */
> -static bool compact_checklock_irqsave(spinlock_t *lock, unsigned long *flags,
> -				      bool locked, struct compact_control *cc)
> +static bool compact_unlock_should_abort(spinlock_t *lock,
> +		unsigned long flags, bool *locked, struct compact_control *cc)
>  {
> -	int contended = should_release_lock(lock);
> +	if (*locked) {
> +		spin_unlock_irqrestore(lock, flags);
> +		*locked = false;
> +	}
>  
> -	if (contended) {
> -		if (locked) {
> -			spin_unlock_irqrestore(lock, *flags);
> -			locked = false;
> -		}
> +	if (fatal_signal_pending(current)) {
> +		cc->contended = COMPACT_CONTENDED_SCHED;
> +		return true;
> +	}
>  
> -		/* async aborts if taking too long or contended */
> +	if (need_resched()) {
>  		if (cc->mode == MIGRATE_ASYNC) {
> -			cc->contended = contended;
> -			return false;
> +			cc->contended = COMPACT_CONTENDED_SCHED;
> +			return true;
>  		}
> -
>  		cond_resched();
>  	}
>  
> -	if (!locked)
> -		spin_lock_irqsave(lock, *flags);
> -	return true;
> +	return false;
>  }
>  
>  /*
>   * Aside from avoiding lock contention, compaction also periodically checks
>   * need_resched() and either schedules in sync compaction or aborts async
> - * compaction. This is similar to what compact_checklock_irqsave() does, but
> + * compaction. This is similar to what compact_unlock_should_abort() does, but
>   * is used where no lock is concerned.
>   *
>   * Returns false when no scheduling was needed, or sync compaction scheduled.
> @@ -336,6 +347,16 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  		int isolated, i;
>  		struct page *page = cursor;
>  
> +		/*
> +		 * Periodically drop the lock (if held) regardless of its
> +		 * contention, to give chance to IRQs. Abort async compaction
> +		 * if contended.
> +		 */

I think this comment is out of date since compact_unlock_should_abort() no 
longer returns true if spin_is_contended(), which is good.

> +		if (!(blockpfn % SWAP_CLUSTER_MAX)
> +		    && compact_unlock_should_abort(&cc->zone->lock, flags,
> +								&locked, cc))
> +			break;
> +
>  		nr_scanned++;
>  		if (!pfn_valid_within(blockpfn))
>  			goto isolate_fail;
> @@ -353,8 +374,9 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  		 * spin on the lock and we acquire the lock as late as
>  		 * possible.
>  		 */
> -		locked = compact_checklock_irqsave(&cc->zone->lock, &flags,
> -								locked, cc);
> +		if (!locked)
> +			locked = compact_trylock_irqsave(&cc->zone->lock,
> +								&flags, cc);
>  		if (!locked)
>  			break;
>  
> @@ -552,13 +574,15 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  
>  	/* Time to isolate some pages for migration */
>  	for (; low_pfn < end_pfn; low_pfn++) {
> -		/* give a chance to irqs before checking need_resched() */
> -		if (locked && !(low_pfn % SWAP_CLUSTER_MAX)) {
> -			if (should_release_lock(&zone->lru_lock)) {
> -				spin_unlock_irqrestore(&zone->lru_lock, flags);
> -				locked = false;
> -			}
> -		}
> +		/*
> +		 * Periodically drop the lock (if held) regardless of its
> +		 * contention, to give chance to IRQs. Abort async compaction
> +		 * if contended.
> +		 */
> +		if (!(low_pfn % SWAP_CLUSTER_MAX)
> +		    && compact_unlock_should_abort(&zone->lru_lock, flags,
> +								&locked, cc))
> +			break;
>  
>  		if (!pfn_valid_within(low_pfn))
>  			continue;
> @@ -620,10 +644,11 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  		    page_count(page) > page_mapcount(page))
>  			continue;
>  
> -		/* Check if it is ok to still hold the lock */
> -		locked = compact_checklock_irqsave(&zone->lru_lock, &flags,
> -								locked, cc);
> -		if (!locked || fatal_signal_pending(current))
> +		/* If the lock is not held, try to take it */
> +		if (!locked)
> +			locked = compact_trylock_irqsave(&zone->lru_lock,
> +								&flags, cc);
> +		if (!locked)
>  			break;
>  
>  		/* Recheck PageLRU and PageTransHuge under lock */
