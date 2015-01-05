Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbbAEBiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 20:38:16 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57310 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbbAEBhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 20:37:45 -0500
X-Original-SENDERIP: 10.177.220.158
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH 5/6] mm/slab: cleanup ____cache_alloc()
Date: Mon,  5 Jan 2015 10:37:30 +0900
Message-Id: <1420421851-3281-6-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420421851-3281-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1420421851-3281-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleanup makes code more readable and help future changes.
In the following patch, many code will be added to this function.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/slab.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 1246ac6..449fc6b 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2939,21 +2939,23 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 	local_irq_save(save_flags);
 
 	ac = cpu_cache_get(cachep);
-	if (likely(ac->avail)) {
-		ac->touched = 1;
-		objp = ac_get_obj(cachep, ac, flags, false);
+	if (unlikely(!ac->avail))
+		goto slowpath;
 
-		/*
-		 * Allow for the possibility all avail objects are not allowed
-		 * by the current flags
-		 */
-		if (objp) {
-			STATS_INC_ALLOCHIT(cachep);
-			goto out;
-		}
-		force_refill = true;
+	ac->touched = 1;
+	objp = ac_get_obj(cachep, ac, flags, false);
+
+	/*
+	 * Allow for the possibility all avail objects are not allowed
+	 * by the current flags
+	 */
+	if (likely(objp)) {
+		STATS_INC_ALLOCHIT(cachep);
+		goto out;
 	}
+	force_refill = true;
 
+slowpath:
 	STATS_INC_ALLOCMISS(cachep);
 	objp = cache_alloc_refill(cachep, flags, force_refill);
 
-- 
1.7.9.5

