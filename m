Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbaKSVOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:14:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785AbaKSVOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Shawn Guo <shawn.guo@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        David Rientjes <rientjes@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 116/122] mm, compaction: properly signal and act upon lock and need_sched() contention
Date: Wed, 19 Nov 2014 12:52:46 -0800
Message-Id: <20141119205212.696690221@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka <vbabka@suse.cz>

commit be9765722e6b7ece8263cbab857490332339bd6f upstream.

Compaction uses compact_checklock_irqsave() function to periodically check
for lock contention and need_resched() to either abort async compaction,
or to free the lock, schedule and retake the lock.  When aborting,
cc->contended is set to signal the contended state to the caller.  Two
problems have been identified in this mechanism.

First, compaction also calls directly cond_resched() in both scanners when
no lock is yet taken.  This call either does not abort async compaction,
or set cc->contended appropriately.  This patch introduces a new
compact_should_abort() function to achieve both.  In isolate_freepages(),
the check frequency is reduced to once by SWAP_CLUSTER_MAX pageblocks to
match what the migration scanner does in the preliminary page checks.  In
case a pageblock is found suitable for calling isolate_freepages_block(),
the checks within there are done on higher frequency.

Second, isolate_freepages() does not check if isolate_freepages_block()
aborted due to contention, and advances to the next pageblock.  This
violates the principle of aborting on contention, and might result in
pageblocks not being scanned completely, since the scanning cursor is
advanced.  This problem has been noticed in the code by Joonsoo Kim when
reviewing related patches.  This patch makes isolate_freepages_block()
check the cc->contended flag and abort.

In case isolate_freepages() has already isolated some pages before
aborting due to contention, page migration will proceed, which is OK since
we do not want to waste the work that has been done, and page migration
has own checks for contention.  However, we do not want another isolation
attempt by either of the scanners, so cc->contended flag check is added
also to compaction_alloc() and compact_finished() to make sure compaction
is aborted right after the migration.

The outcome of the patch should be reduced lock contention by async
compaction and lower latencies for higher-order allocations where direct
compaction is involved.

[akpm@linux-foundation.org: fix typo in comment]
Reported-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Tested-by: Shawn Guo <shawn.guo@linaro.org>
Tested-by: Kevin Hilman <khilman@linaro.org>
Tested-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/compaction.c |   54 ++++++++++++++++++++++++++++++++++++++++++++----------
 mm/internal.h   |    5 ++++-
 2 files changed, 48 insertions(+), 11 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -222,6 +222,30 @@ static bool compact_checklock_irqsave(sp
 	return true;
 }
 
+/*
+ * Aside from avoiding lock contention, compaction also periodically checks
+ * need_resched() and either schedules in sync compaction or aborts async
+ * compaction. This is similar to what compact_checklock_irqsave() does, but
+ * is used where no lock is concerned.
+ *
+ * Returns false when no scheduling was needed, or sync compaction scheduled.
+ * Returns true when async compaction should abort.
+ */
+static inline bool compact_should_abort(struct compact_control *cc)
+{
+	/* async compaction aborts if contended */
+	if (need_resched()) {
+		if (cc->mode == MIGRATE_ASYNC) {
+			cc->contended = true;
+			return true;
+		}
+
+		cond_resched();
+	}
+
+	return false;
+}
+
 /* Returns true if the page is within a block suitable for migration to */
 static bool suitable_migration_target(struct page *page)
 {
@@ -494,11 +518,8 @@ isolate_migratepages_range(struct zone *
 			return 0;
 	}
 
-	if (cond_resched()) {
-		/* Async terminates prematurely on need_resched() */
-		if (cc->mode == MIGRATE_ASYNC)
-			return 0;
-	}
+	if (compact_should_abort(cc))
+		return 0;
 
 	/* Time to isolate some pages for migration */
 	for (; low_pfn < end_pfn; low_pfn++) {
@@ -720,9 +741,11 @@ static void isolate_freepages(struct zon
 		/*
 		 * This can iterate a massively long zone without finding any
 		 * suitable migration targets, so periodically check if we need
-		 * to schedule.
+		 * to schedule, or even abort async compaction.
 		 */
-		cond_resched();
+		if (!(block_start_pfn % (SWAP_CLUSTER_MAX * pageblock_nr_pages))
+						&& compact_should_abort(cc))
+			break;
 
 		if (!pfn_valid(block_start_pfn))
 			continue;
@@ -760,6 +783,13 @@ static void isolate_freepages(struct zon
 		 */
 		if (isolated)
 			cc->finished_update_free = true;
+
+		/*
+		 * isolate_freepages_block() might have aborted due to async
+		 * compaction being contended
+		 */
+		if (cc->contended)
+			break;
 	}
 
 	/* split_free_page does not map the pages */
@@ -786,9 +816,13 @@ static struct page *compaction_alloc(str
 	struct compact_control *cc = (struct compact_control *)data;
 	struct page *freepage;
 
-	/* Isolate free pages if necessary */
+	/*
+	 * Isolate free pages if necessary, and if we are not aborting due to
+	 * contention.
+	 */
 	if (list_empty(&cc->freepages)) {
-		isolate_freepages(cc->zone, cc);
+		if (!cc->contended)
+			isolate_freepages(cc->zone, cc);
 
 		if (list_empty(&cc->freepages))
 			return NULL;
@@ -858,7 +892,7 @@ static int compact_finished(struct zone
 	unsigned int order;
 	unsigned long watermark;
 
-	if (fatal_signal_pending(current))
+	if (cc->contended || fatal_signal_pending(current))
 		return COMPACT_PARTIAL;
 
 	/* Compaction run completes if the migrate and free scanner meet */
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -144,7 +144,10 @@ struct compact_control {
 	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
 	struct zone *zone;
-	bool contended;			/* True if a lock was contended */
+	bool contended;			/* True if a lock was contended, or
+					 * need_resched() true during async
+					 * compaction
+					 */
 };
 
 unsigned long


