Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbaEMJqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:46:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759665AbaEMJpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:45:55 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 01/19] mm: page_alloc: Do not update zlc unless the zlc is active
Date: Tue, 13 May 2014 10:45:32 +0100
Message-Id: <1399974350-11089-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1399974350-11089-1-git-send-email-mgorman@suse.de>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The zlc is used on NUMA machines to quickly skip over zones that are full.
However it is always updated, even for the first zone scanned when the
zlc might not even be active. As it's a write to a bitmap that potentially
bounces cache line it's deceptively expensive and most machines will not
care. Only update the zlc if it was active.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5dba293..f8b80c3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2044,7 +2044,7 @@ try_this_zone:
 		if (page)
 			break;
 this_zone_full:
-		if (IS_ENABLED(CONFIG_NUMA))
+		if (IS_ENABLED(CONFIG_NUMA) && zlc_active)
 			zlc_mark_zone_full(zonelist, z);
 	}
 
-- 
1.8.4.5

