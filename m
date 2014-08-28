Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbaH1Smq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:42:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbaH1ShZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:25 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 96/97] mm: page_alloc: abort fair zone allocation policy when remotes nodes are encountered
Date: Thu, 28 Aug 2014 19:35:44 +0100
Message-Id: <1409250945-30874-97-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit f7b5d647946aae1647bf5cd26c16b3a793c1ac49 upstream.

The purpose of numa_zonelist_order=zone is to preserve lower zones for
use with 32-bit devices.  If locality is preferred then the
numa_zonelist_order=node policy should be used.

Unfortunately, the fair zone allocation policy overrides this by
skipping zones on remote nodes until the lower one is found.  While this
makes sense from a page aging and performance perspective, it breaks the
expected zonelist policy.  This patch restores the expected behaviour
for zone-list ordering.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee24ebb..16e6740 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1955,7 +1955,7 @@ zonelist_scan:
 		 */
 		if (alloc_flags & ALLOC_FAIR) {
 			if (!zone_local(preferred_zone, zone))
-				continue;
+				break;
 			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
 				continue;
 		}
-- 
1.8.4.5

