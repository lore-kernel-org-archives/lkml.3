Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761753Ab3LIWDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 17:03:51 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:56753 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761743Ab3LIWDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 17:03:48 -0500
Date: Mon, 9 Dec 2013 14:03:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch] mm, page_alloc: allow __GFP_NOFAIL to allocate below watermarks
 after reclaim
Message-ID: <alpine.DEB.2.02.1312091402580.11026@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If direct reclaim has failed to free memory, __GFP_NOFAIL allocations
can potentially loop forever in the page allocator.  In this case, it's
better to give them the ability to access below watermarks so that they
may allocate similar to the same privilege given to GFP_ATOMIC
allocations.

We're careful to ensure this is only done after direct reclaim has had
the chance to free memory, however.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2629,6 +2629,11 @@ rebalance:
 						pages_reclaimed)) {
 		/* Wait for some write requests to complete then retry */
 		wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
+
+		/* Allocations that cannot fail must allocate from somewhere */
+		if (gfp_mask & __GFP_NOFAIL)
+			alloc_flags |= ALLOC_HARDER;
+
 		goto rebalance;
 	} else {
 		/*
