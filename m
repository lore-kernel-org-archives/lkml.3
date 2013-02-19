Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab3BSKft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:35:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932631Ab3BSKeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:34:12 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/10] GFS2: Split glock lru processing into two parts
Date: Tue, 19 Feb 2013 10:07:38 +0000
Message-Id: <1361268460-3092-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
References: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent here is to split the processing of the glock lru
list into two parts, so that the selection of glocks and the
disposal are separate functions. The plan is then, that further
updates can then be made to these functions in the future
to improve the selection of glocks and also the efficiency of
glock disposal.

The new feature which this patch brings is sorting the
glocks to be disposed of into glock number (and thus also
disk block number) order. Not all glocks will need i/o in
order to dispose of them, but some will, and at least we'll
generate mostly disk block order i/o now.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 3ad8fd3..cf35155 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -30,6 +30,7 @@
 #include <linux/rculist_bl.h>
 #include <linux/bit_spinlock.h>
 #include <linux/percpu.h>
+#include <linux/list_sort.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -1376,50 +1377,93 @@ void gfs2_glock_complete(struct gfs2_glock *gl, int ret)
 		gfs2_glock_put(gl);
 }
 
+static int glock_cmp(void *priv, struct list_head *a, struct list_head *b)
+{
+	struct gfs2_glock *gla, *glb;
+
+	gla = list_entry(a, struct gfs2_glock, gl_lru);
+	glb = list_entry(b, struct gfs2_glock, gl_lru);
+
+	if (gla->gl_name.ln_number > glb->gl_name.ln_number)
+		return 1;
+	if (gla->gl_name.ln_number < glb->gl_name.ln_number)
+		return -1;
+
+	return 0;
+}
+
+/**
+ * gfs2_dispose_glock_lru - Demote a list of glocks
+ * @list: The list to dispose of
+ *
+ * Disposing of glocks may involve disk accesses, so that here we sort
+ * the glocks by number (i.e. disk location of the inodes) so that if
+ * there are any such accesses, they'll be sent in order (mostly).
+ *
+ * Must be called under the lru_lock, but may drop and retake this
+ * lock. While the lru_lock is dropped, entries may vanish from the
+ * list, but no new entries will appear on the list (since it is
+ * private)
+ */
+
+static void gfs2_dispose_glock_lru(struct list_head *list)
+__releases(&lru_lock)
+__acquires(&lru_lock)
+{
+	struct gfs2_glock *gl;
+
+	list_sort(NULL, list, glock_cmp);
+
+	while(!list_empty(list)) {
+		gl = list_entry(list->next, struct gfs2_glock, gl_lru);
+		list_del_init(&gl->gl_lru);
+		clear_bit(GLF_LRU, &gl->gl_flags);
+		gfs2_glock_hold(gl);
+		spin_unlock(&lru_lock);
+		spin_lock(&gl->gl_spin);
+		if (demote_ok(gl))
+			handle_callback(gl, LM_ST_UNLOCKED, 0);
+		WARN_ON(!test_and_clear_bit(GLF_LOCK, &gl->gl_flags));
+		smp_mb__after_clear_bit();
+		if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
+			gfs2_glock_put_nolock(gl);
+		spin_unlock(&gl->gl_spin);
+		spin_lock(&lru_lock);
+	}
+}
+
 /**
  * gfs2_scan_glock_lru - Scan the LRU looking for locks to demote
  * @nr: The number of entries to scan
  *
+ * This function selects the entries on the LRU which are able to
+ * be demoted, and then kicks off the process by calling
+ * gfs2_dispose_glock_lru() above.
  */
 
 static void gfs2_scan_glock_lru(int nr)
 {
 	struct gfs2_glock *gl;
-	int may_demote;
-	int nr_skipped = 0;
 	LIST_HEAD(skipped);
+	LIST_HEAD(dispose);
 
 	spin_lock(&lru_lock);
 	while(nr && !list_empty(&lru_list)) {
 		gl = list_entry(lru_list.next, struct gfs2_glock, gl_lru);
-		list_del_init(&gl->gl_lru);
-		clear_bit(GLF_LRU, &gl->gl_flags);
-		atomic_dec(&lru_count);
 
 		/* Test for being demotable */
 		if (!test_and_set_bit(GLF_LOCK, &gl->gl_flags)) {
-			gfs2_glock_hold(gl);
-			spin_unlock(&lru_lock);
-			spin_lock(&gl->gl_spin);
-			may_demote = demote_ok(gl);
-			if (may_demote) {
-				handle_callback(gl, LM_ST_UNLOCKED, 0);
-				nr--;
-			}
-			clear_bit(GLF_LOCK, &gl->gl_flags);
-			smp_mb__after_clear_bit();
-			if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
-				gfs2_glock_put_nolock(gl);
-			spin_unlock(&gl->gl_spin);
-			spin_lock(&lru_lock);
+			list_move(&gl->gl_lru, &dispose);
+			atomic_dec(&lru_count);
+			nr--;
 			continue;
 		}
-		nr_skipped++;
-		list_add(&gl->gl_lru, &skipped);
-		set_bit(GLF_LRU, &gl->gl_flags);
+
+		list_move(&gl->gl_lru, &skipped);
 	}
 	list_splice(&skipped, &lru_list);
-	atomic_add(nr_skipped, &lru_count);
+	if (!list_empty(&dispose))
+		gfs2_dispose_glock_lru(&dispose);
 	spin_unlock(&lru_lock);
 }
 
-- 
1.7.4

