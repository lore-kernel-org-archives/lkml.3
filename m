Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbaJGXUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:20:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbaJGXUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:20:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3.14 34/37] mm: vmscan: shrink_slab: rename max_pass -> freeable
Date: Tue,  7 Oct 2014 16:19:51 -0700
Message-Id: <20141007231828.100214595@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231827.043235686@linuxfoundation.org>
References: <20141007231827.043235686@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Davydov <vdavydov@parallels.com>

commit d5bc5fd3fcb7b8dfb431694a8c8052466504c10c upstream.

The name `max_pass' is misleading, because this variable actually keeps
the estimate number of freeable objects, not the maximal number of
objects we can scan in this pass, which can be twice that.  Rename it to
reflect its actual meaning.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -224,15 +224,15 @@ shrink_slab_node(struct shrink_control *
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
@@ -244,14 +244,14 @@ shrink_slab_node(struct shrink_control *
 
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
@@ -260,26 +260,26 @@ shrink_slab_node(struct shrink_control *
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
@@ -292,12 +292,12 @@ shrink_slab_node(struct shrink_control *
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
 


