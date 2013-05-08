Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab3EHQLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:11:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757959Ab3EHQDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:03:13 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Dave Hansen <dave@sr71.net>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 05/22] oom: Use number of online nodes when deciding whether to suppress messages
Date: Wed,  8 May 2013 17:02:50 +0100
Message-Id: <1368028987-8369-6-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368028987-8369-1-git-send-email-mgorman@suse.de>
References: <1368028987-8369-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 29423e77 (oom: suppress show_mem() for many nodes in irq context
on page alloc failure) was meant to suppress printing excessive amounts
of information in IRQ context on large machines. However, it uses a kernel
config variable which the maximum supported number of nodes, not the number
of online nodes to make the decision. Effectively, on some distribution
configurations the message will be suppressed even on small machines. This
patch uses nr_online_nodes to decide whether to suppress messges.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f170260..a66a6fa 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1978,20 +1978,6 @@ this_zone_full:
 	return page;
 }
 
-/*
- * Large machines with many possible nodes should not always dump per-node
- * meminfo in irq context.
- */
-static inline bool should_suppress_show_mem(void)
-{
-	bool ret = false;
-
-#if NODES_SHIFT > 8
-	ret = in_interrupt();
-#endif
-	return ret;
-}
-
 static DEFINE_RATELIMIT_STATE(nopage_rs,
 		DEFAULT_RATELIMIT_INTERVAL,
 		DEFAULT_RATELIMIT_BURST);
@@ -2034,8 +2020,15 @@ void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...)
 		current->comm, order, gfp_mask);
 
 	dump_stack();
-	if (!should_suppress_show_mem())
-		show_mem(filter);
+
+	/*
+	 * Large machines with many possible nodes should not always dump
+	 * per-node meminfo in irq context.
+	 */
+	if (in_interrupt() && nr_online_nodes > (1 << 8))
+		return;
+
+	show_mem(filter);
 }
 
 static inline int
-- 
1.8.1.4

