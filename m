Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbaFBLzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 07:55:51 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:44749 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbaFBLzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:55:49 -0400
From: Chen Yucong <slaoub@gmail.com>
To: shli@kernel.org
Cc: hughd@google.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Chen Yucong <slaoub@gmail.com>
Subject: [PATCH] swap: Delete  the "last_in_cluster < scan_base" loop in the body of scan_swap_map()
Date: Mon,  2 Jun 2014 19:54:13 +0800
Message-Id: <1401710053-8460-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From commit ebc2a1a69111, we can find that all SWP_SOLIDSTATE "seek is cheap"(SSD case) 
has already gone to si->cluster_info scan_swap_map_try_ssd_cluster() route. So that the
"last_in_cluster < scan_base" loop in the body of scan_swap_map() has already become a 
dead code snippet, and it should have been deleted.

This patch is to delete the redundant loop as Hugh and Shaohua suggested.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 mm/swapfile.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index beeeef8..1b44bd9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -549,26 +549,6 @@ static unsigned long scan_swap_map(struct swap_info_struct *si,
 			}
 		}
 
-		offset = si->lowest_bit;
-		last_in_cluster = offset + SWAPFILE_CLUSTER - 1;
-
-		/* Locate the first empty (unaligned) cluster */
-		for (; last_in_cluster < scan_base; offset++) {
-			if (si->swap_map[offset])
-				last_in_cluster = offset + SWAPFILE_CLUSTER;
-			else if (offset == last_in_cluster) {
-				spin_lock(&si->lock);
-				offset -= SWAPFILE_CLUSTER - 1;
-				si->cluster_next = offset;
-				si->cluster_nr = SWAPFILE_CLUSTER - 1;
-				goto checks;
-			}
-			if (unlikely(--latency_ration < 0)) {
-				cond_resched();
-				latency_ration = LATENCY_LIMIT;
-			}
-		}
-
 		offset = scan_base;
 		spin_lock(&si->lock);
 		si->cluster_nr = SWAPFILE_CLUSTER - 1;
-- 
1.7.10.4

