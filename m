Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3LHJkd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 04:40:33 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:46064 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3LHJk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 04:40:27 -0500
From: "ethan.zhao" <ethan.kernel@gmail.com>
To: hristoph@lameter.com, alokk@calsoftinc.com, shobhit@calsoftinc.com,
        shai@scalex86.org, cl@linux.com
Cc: linux-kernel@vger.kernel.org, "ethan.zhao" <ethan.kernel@gmail.com>
Subject: [PATCH] mm/slab.c: check pointer slabp before using it in alloc_slabmgmt()
Date: Sun,  8 Dec 2013 17:38:53 +0800
Message-Id: <1386495533-413-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the NULL check of slabp to the right place before refer its memeber in
function alloc_slabmgmt().

This bug may be introduced by rewriting of funcion kmemleak_scan_area(),
the first parameter changed from slabp to &slabp->list.

Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
---
 mm/slab.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 2580db0..b6d27bc 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2612,6 +2612,8 @@ static struct slab *alloc_slabmgmt(struct kmem_cache *cachep, void *objp,
 		/* Slab management obj is off-slab. */
 		slabp = kmem_cache_alloc_node(cachep->slabp_cache,
 					      local_flags, nodeid);
+		if (!slabp)
+			return NULL;
 		/*
 		 * If the first object in the slab is leaked (it's allocated
 		 * but no one has a reference to it), we want to make sure
@@ -2620,8 +2622,6 @@ static struct slab *alloc_slabmgmt(struct kmem_cache *cachep, void *objp,
 		 */
 		kmemleak_scan_area(&slabp->list, sizeof(struct list_head),
 				   local_flags);
-		if (!slabp)
-			return NULL;
 	} else {
 		slabp = objp + colour_off;
 		colour_off += cachep->slab_size;
-- 
1.8.3.4 (Apple Git-47)

