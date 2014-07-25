Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451AbaGYMcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:32:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40076 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbaGYMcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:32:42 -0400
Date: Fri, 25 Jul 2014 13:32:37 +0100
From: Mel Gorman <mgorman@suse.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Minchan Kim <minchan@kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH V4 08/15] mm, compaction: periodically drop lock and
 restore IRQs in scanners
Message-ID: <20140725123237.GC10819@suse.de>
References: <1405518503-27687-1-git-send-email-vbabka@suse.cz>
 <1405518503-27687-9-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1405518503-27687-9-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 03:48:16PM +0200, Vlastimil Babka wrote:
> Compaction scanners regularly check for lock contention and need_resched()
> through the compact_checklock_irqsave() function. However, if there is no
> contention, the lock can be held and IRQ disabled for potentially long time.
> 
> This has been addressed by commit b2eef8c0d0 ("mm: compaction: minimise the
> time IRQs are disabled while isolating pages for migration") for the migration
> scanner. However, the refactoring done by commit 2a1402aa04 ("mm: compaction:
> acquire the zone->lru_lock as late as possible") has changed the conditions so
> that the lock is dropped only when there's contention on the lock or
> need_resched() is true. Also, need_resched() is checked only when the lock is
> already held. The comment "give a chance to irqs before checking need_resched"
> is therefore misleading, as IRQs remain disabled when the check is done.
> 
> This patch restores the behavior intended by commit b2eef8c0d0 and also tries
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
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
