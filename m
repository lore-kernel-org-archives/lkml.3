Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaJGPeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:34:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbaJGPeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:34:01 -0400
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH 3/5] mm, compaction: defer only on COMPACT_COMPLETE
Date: Tue,  7 Oct 2014 17:33:37 +0200
Message-Id: <1412696019-21761-4-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1412696019-21761-1-git-send-email-vbabka@suse.cz>
References: <1412696019-21761-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deferred compaction is employed to avoid compacting zone where sync direct
compaction has recently failed. As such, it makes sense to only defer when
a full zone was scanned, which is when compact_zone returns with
COMPACT_COMPLETE. It's less useful to defer when compact_zone returns with
apparent success (COMPACT_PARTIAL), followed by a watermark check failure,
which can happen due to parallel allocation activity. It also does not make
much sense to defer compaction which was completely skipped (COMPACT_SKIP) for
being unsuitable in the first place.

This patch therefore makes deferred compaction trigger only when
COMPACT_COMPLETE is returned from compact_zone(). Results of stress-highalloc
becnmark show the difference is within measurement error, so the issue is
rather cosmetic.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
---
 mm/compaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 4b3e0bd..9107588 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1340,7 +1340,7 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			goto break_loop;
 		}
 
-		if (mode != MIGRATE_ASYNC) {
+		if (mode != MIGRATE_ASYNC && status == COMPACT_COMPLETE) {
 			/*
 			 * We think that allocation won't succeed in this zone
 			 * so we defer compaction there. If it ends up
-- 
1.8.4.5

