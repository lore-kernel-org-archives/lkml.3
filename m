Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab3HFInq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:43:46 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56320 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab3HFIno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:43:44 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-4a-5200b73c09da
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 3/4] mm, rmap: minimize lock hold when unlink_anon_vmas
Date: Tue,  6 Aug 2013 17:43:39 +0900
Message-Id: <1375778620-31593-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375778620-31593-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375778620-31593-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we free the avc objects with holding a lock. To minimize
lock hold time, we just move the avc objects to another list
with holding a lock. Then, iterate them and free objects without holding
a lock. This makes lock hold time minimized.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/rmap.c b/mm/rmap.c
index 1603f64..9cfb282 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -330,6 +330,7 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
 	struct anon_vma *root = NULL;
+	LIST_HEAD(avc_list);
 
 	/*
 	 * Unlink each anon_vma chained to the VMA.  This list is ordered
@@ -348,10 +349,14 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		if (RB_EMPTY_ROOT(&anon_vma->rb_root))
 			continue;
 
+		list_move(&avc->same_vma, &avc_list);
+	}
+	unlock_anon_vma_root(root);
+
+	list_for_each_entry_safe(avc, next, &avc_list, same_vma) {
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
-	unlock_anon_vma_root(root);
 
 	/*
 	 * Iterate the list once more, it now only contains empty and unlinked
@@ -363,7 +368,6 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 
 		put_anon_vma(anon_vma);
 
-		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
 }
-- 
1.7.9.5

