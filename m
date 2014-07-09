Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbaGIIN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:13:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbaGIINQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:13:16 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 5/6] mm: page_alloc: Abort fair zone allocation policy when remotes nodes are encountered
Date: Wed,  9 Jul 2014 09:13:07 +0100
Message-Id: <1404893588-21371-6-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1404893588-21371-1-git-send-email-mgorman@suse.de>
References: <1404893588-21371-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of numa_zonelist_order=zone is to preserve lower zones
for use with 32-bit devices. If locality is preferred then the
numa_zonelist_order=node policy should be used. Unfortunately, the fair
zone allocation policy overrides this by skipping zones on remote nodes
until the lower one is found. While this makes sense from a page aging
and performance perspective, it breaks the expected zonelist policy. This
patch restores the expected behaviour for zone-list ordering.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index aa46f00..0bf384a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1957,7 +1957,7 @@ zonelist_scan:
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

