Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaFBOdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:33:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041AbaFBOds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:33:48 -0400
Message-ID: <538C8B45.6070803@suse.cz>
Date: Mon, 02 Jun 2014 16:33:41 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Shawn Guo <shawn.guo@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Rik van Riel <riel@redhat.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Olof Johansson <olof@lixom.net>, Greg Thelen <gthelen@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -mm] mm, compaction: properly signal and act upon lock and
 need_sched() contention - fix
References: <1399904111-23520-1-git-send-email-vbabka@suse.cz>	<1400233673-11477-1-git-send-email-vbabka@suse.cz>	<CAGa+x87-NRyK6kUiXNL_bRNEGm+DR6M3HPSLYEoq4t6Nrtnd_g@mail.gmail.com>	<CAAQ0ZWQDVxAzZVm86ATXd1JGUVoLXj_Y5Ske7htxH_6a4GPKRg@mail.gmail.com>	<537F082F.50501@suse.cz> <CAOMZO5BKaicq7NkoJO4vU5W3hiDike6kSdH+2eD=h0B5BsDjTg@mail.gmail.com>
In-Reply-To: <CAOMZO5BKaicq7NkoJO4vU5W3hiDike6kSdH+2eD=h0B5BsDjTg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

compact_should_abort() returns true instead of false and vice versa
due to changes between v1 and v2 of the patch. This makes both async
and sync compaction abort with high probability, and has been reported
to cause e.g. soft lockups on some ARM boards, or drivers calling
dma_alloc_coherent() fail to probe with CMA enabled on different boards.

This patch fixes the return value to match comments and callers expecations.

Reported-and-tested-by: Kevin Hilman <khilman@linaro.org>
Reported-and-tested-by: Shawn Guo <shawn.guo@linaro.org>
Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/compaction.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index a525cd4..5175019 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -237,13 +237,13 @@ static inline bool compact_should_abort(struct compact_control *cc)
 	if (need_resched()) {
 		if (cc->mode == MIGRATE_ASYNC) {
 			cc->contended = true;
-			return false;
+			return true;
 		}
 
 		cond_resched();
 	}
 
-	return true;
+	return false;
 }
 
 /* Returns true if the page is within a block suitable for migration to */
-- 1.8.4.5 
