Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab3BSKhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:37:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932578Ab3BSKeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:34:01 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/10] GFS2: Separate LRU scanning from shrinker
Date: Tue, 19 Feb 2013 10:07:31 +0000
Message-Id: <1361268460-3092-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
References: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This breaks out the LRU scanning function from the shrinker in
preparation for adding other callers to the LRU scanner.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 992c5c0..3ad8fd3 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1376,23 +1376,19 @@ void gfs2_glock_complete(struct gfs2_glock *gl, int ret)
 		gfs2_glock_put(gl);
 }
 
+/**
+ * gfs2_scan_glock_lru - Scan the LRU looking for locks to demote
+ * @nr: The number of entries to scan
+ *
+ */
 
-static int gfs2_shrink_glock_memory(struct shrinker *shrink,
-				    struct shrink_control *sc)
+static void gfs2_scan_glock_lru(int nr)
 {
 	struct gfs2_glock *gl;
 	int may_demote;
 	int nr_skipped = 0;
-	int nr = sc->nr_to_scan;
-	gfp_t gfp_mask = sc->gfp_mask;
 	LIST_HEAD(skipped);
 
-	if (nr == 0)
-		goto out;
-
-	if (!(gfp_mask & __GFP_FS))
-		return -1;
-
 	spin_lock(&lru_lock);
 	while(nr && !list_empty(&lru_list)) {
 		gl = list_entry(lru_list.next, struct gfs2_glock, gl_lru);
@@ -1425,7 +1421,17 @@ static int gfs2_shrink_glock_memory(struct shrinker *shrink,
 	list_splice(&skipped, &lru_list);
 	atomic_add(nr_skipped, &lru_count);
 	spin_unlock(&lru_lock);
-out:
+}
+
+static int gfs2_shrink_glock_memory(struct shrinker *shrink,
+				    struct shrink_control *sc)
+{
+	if (sc->nr_to_scan) {
+		if (!(sc->gfp_mask & __GFP_FS))
+			return -1;
+		gfs2_scan_glock_lru(sc->nr_to_scan);
+	}
+
 	return (atomic_read(&lru_count) / 100) * sysctl_vfs_cache_pressure;
 }
 
-- 
1.7.4

