Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaBBRLe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 12:11:34 -0500
Received: from relay.parallels.com ([195.214.232.42]:50542 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaBBRLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 12:11:32 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <rientjes@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH TRIVIAL] mm: vmscan: shrink_slab: rename max_pass -> freeable
Date: Sun, 2 Feb 2014 21:11:30 +0400
Message-ID: <1391361090-526-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.25.206]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name `max_pass' is misleading, because this variable actually keeps
the estimate number of freeable objects, not the maximal number of
objects we can scan in this pass, which can be twice that. Rename it to
reflect its actual meaning.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/vmscan.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a9c74b409681..fa3385865fc6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -224,15 +224,15 @@ shrink_slab_node(struct shrink_control *shrinkctl, struct shrinker *shrinker,
 	unsigned long freed = 0;
 	unsigned long long delta;
 	long total_scan;
-	long max_pass;
+	long freeable;
 	long nr;
 	long new_nr;
 	int nid = shrinkctl->nid;
 	long batch_size = shrinker->batch ? shrinker->batch
 					  : SHRINK_BATCH;
 
-	max_pass = shrinker->count_objects(shrinker, shrinkctl);
-	if (max_pass == 0)
+	freeable = shrinker->count_objects(shrinker, shrinkctl);
+	if (freeable == 0)
 		return 0;
 
 	/*
@@ -244,14 +244,14 @@ shrink_slab_node(struct shrink_control *shrinkctl, struct shrinker *shrinker,
 
 	total_scan = nr;
 	delta = (4 * nr_pages_scanned) / shrinker->seeks;
-	delta *= max_pass;
+	delta *= freeable;
 	do_div(delta, lru_pages + 1);
 	total_scan += delta;
 	if (total_scan < 0) {
 		printk(KERN_ERR
 		"shrink_slab: %pF negative objects to delete nr=%ld\n",
 		       shrinker->scan_objects, total_scan);
-		total_scan = max_pass;
+		total_scan = freeable;
 	}
 
 	/*
@@ -260,26 +260,26 @@ shrink_slab_node(struct shrink_control *shrinkctl, struct shrinker *shrinker,
 	 * shrinkers to return -1 all the time. This results in a large
 	 * nr being built up so when a shrink that can do some work
 	 * comes along it empties the entire cache due to nr >>>
-	 * max_pass.  This is bad for sustaining a working set in
+	 * freeable. This is bad for sustaining a working set in
 	 * memory.
 	 *
 	 * Hence only allow the shrinker to scan the entire cache when
 	 * a large delta change is calculated directly.
 	 */
-	if (delta < max_pass / 4)
-		total_scan = min(total_scan, max_pass / 2);
+	if (delta < freeable / 4)
+		total_scan = min(total_scan, freeable / 2);
 
 	/*
 	 * Avoid risking looping forever due to too large nr value:
 	 * never try to free more than twice the estimate number of
 	 * freeable entries.
 	 */
-	if (total_scan > max_pass * 2)
-		total_scan = max_pass * 2;
+	if (total_scan > freeable * 2)
+		total_scan = freeable * 2;
 
 	trace_mm_shrink_slab_start(shrinker, shrinkctl, nr,
 				nr_pages_scanned, lru_pages,
-				max_pass, delta, total_scan);
+				freeable, delta, total_scan);
 
 	/*
 	 * Normally, we should not scan less than batch_size objects in one
@@ -292,12 +292,12 @@ shrink_slab_node(struct shrink_control *shrinkctl, struct shrinker *shrinker,
 	 *
 	 * We detect the "tight on memory" situations by looking at the total
 	 * number of objects we want to scan (total_scan). If it is greater
-	 * than the total number of objects on slab (max_pass), we must be
+	 * than the total number of objects on slab (freeable), we must be
 	 * scanning at high prio and therefore should try to reclaim as much as
 	 * possible.
 	 */
 	while (total_scan >= batch_size ||
-	       total_scan >= max_pass) {
+	       total_scan >= freeable) {
 		unsigned long ret;
 		unsigned long nr_to_scan = min(batch_size, total_scan);
 
-- 
1.7.10.4

