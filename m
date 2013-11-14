Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab3KNQzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:55:25 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:50924 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab3KNQjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:39:35 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jinshan Xiong <jinshan.xiong@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 17/39] staging/lustre/llite: reset writeback index in ll_writepages
Date: Fri, 15 Nov 2013 00:32:40 +0800
Message-Id: <1384446782-13741-18-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jinshan Xiong <jinshan.xiong@intel.com>

Otherwise after one round the writeback index will become beyond
the file size and ->writepages() turns into an empty operation.

Also, a safety guard is added to limit the wait time for grant to
10 minutes(take recovery into consideration) at maximum in the
osc_enter_cache() function. Otherwise, EDQUOT will be returned to
the applications to start sync write.

Lustre-change: http://review.whamcloud.com/6554
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3416
Signed-off-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Reviewed-by: Niu Yawei <yawei.niu@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/rw.c      |    5 ++--
 drivers/staging/lustre/lustre/osc/osc_cache.c |   32 +++++++++++++++++--------
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/rw.c b/drivers/staging/lustre/lustre/llite/rw.c
index 112368f..9fe12d3 100644
--- a/drivers/staging/lustre/lustre/llite/rw.c
+++ b/drivers/staging/lustre/lustre/llite/rw.c
@@ -1262,8 +1262,9 @@ int ll_writepages(struct address_space *mapping, struct writeback_control *wbc)
 
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0)) {
 		if (end == OBD_OBJECT_EOF)
-			end = i_size_read(inode);
-		mapping->writeback_index = (end >> PAGE_CACHE_SHIFT) + 1;
+			mapping->writeback_index = 0;
+		else
+			mapping->writeback_index = (end >> PAGE_CACHE_SHIFT) +1;
 	}
 	return result;
 }
diff --git a/drivers/staging/lustre/lustre/osc/osc_cache.c b/drivers/staging/lustre/lustre/osc/osc_cache.c
index 00295da..7d63a37 100644
--- a/drivers/staging/lustre/lustre/osc/osc_cache.c
+++ b/drivers/staging/lustre/lustre/osc/osc_cache.c
@@ -1296,15 +1296,19 @@ static int osc_completion(const struct lu_env *env, struct osc_async_page *oap,
 	return 0;
 }
 
-#define OSC_DUMP_GRANT(cli, fmt, args...) do {				      \
+#define OSC_DUMP_GRANT(lvl, cli, fmt, args...) do {			      \
 	struct client_obd *__tmp = (cli);				      \
-	CDEBUG(D_CACHE, "%s: { dirty: %ld/%ld dirty_pages: %d/%d "	      \
-	       "dropped: %ld avail: %ld, reserved: %ld, flight: %d } " fmt,   \
+	CDEBUG(lvl, "%s: grant { dirty: %ld/%ld dirty_pages: %d/%d "	      \
+	       "dropped: %ld avail: %ld, reserved: %ld, flight: %d } "	      \
+	       "lru {in list: %d, left: %d, waiters: %d }" fmt,		      \
 	       __tmp->cl_import->imp_obd->obd_name,			      \
 	       __tmp->cl_dirty, __tmp->cl_dirty_max,			      \
 	       atomic_read(&obd_dirty_pages), obd_max_dirty_pages,	      \
 	       __tmp->cl_lost_grant, __tmp->cl_avail_grant,		      \
-	       __tmp->cl_reserved_grant, __tmp->cl_w_in_flight, ##args);      \
+	       __tmp->cl_reserved_grant, __tmp->cl_w_in_flight,		      \
+	       atomic_read(&__tmp->cl_lru_in_list),			      \
+	       atomic_read(&__tmp->cl_lru_busy),			      \
+	       atomic_read(&__tmp->cl_lru_shrinkers), ##args);	      \
 } while (0)
 
 /* caller must hold loi_list_lock */
@@ -1441,7 +1445,7 @@ static int osc_enter_cache_try(struct client_obd *cli,
 {
 	int rc;
 
-	OSC_DUMP_GRANT(cli, "need:%d.\n", bytes);
+	OSC_DUMP_GRANT(D_CACHE, cli, "need:%d.\n", bytes);
 
 	rc = osc_reserve_grant(cli, bytes);
 	if (rc < 0)
@@ -1485,10 +1489,11 @@ static int osc_enter_cache(const struct lu_env *env, struct client_obd *cli,
 	struct osc_object *osc = oap->oap_obj;
 	struct lov_oinfo  *loi = osc->oo_oinfo;
 	struct osc_cache_waiter ocw;
-	struct l_wait_info lwi = LWI_INTR(LWI_ON_SIGNAL_NOOP, NULL);
+	struct l_wait_info lwi = LWI_TIMEOUT_INTR(cfs_time_seconds(600), NULL,
+						  LWI_ON_SIGNAL_NOOP, NULL);
 	int rc = -EDQUOT;
 
-	OSC_DUMP_GRANT(cli, "need:%d.\n", bytes);
+	OSC_DUMP_GRANT(D_CACHE, cli, "need:%d.\n", bytes);
 
 	client_obd_list_lock(&cli->cl_loi_list_lock);
 
@@ -1526,8 +1531,15 @@ static int osc_enter_cache(const struct lu_env *env, struct client_obd *cli,
 
 		client_obd_list_lock(&cli->cl_loi_list_lock);
 
-		/* l_wait_event is interrupted by signal */
+		/* l_wait_event is interrupted by signal, or timed out */
 		if (rc < 0) {
+			if (rc == -ETIMEDOUT) {
+				OSC_DUMP_GRANT(D_ERROR, cli,
+						"try to reserve %d.\n", bytes);
+				osc_extent_tree_dump(D_ERROR, osc);
+				rc = -EDQUOT;
+			}
+
 			list_del_init(&ocw.ocw_entry);
 			GOTO(out, rc);
 		}
@@ -1542,7 +1554,7 @@ static int osc_enter_cache(const struct lu_env *env, struct client_obd *cli,
 	}
 out:
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
-	OSC_DUMP_GRANT(cli, "returned %d.\n", rc);
+	OSC_DUMP_GRANT(D_CACHE, cli, "returned %d.\n", rc);
 	return rc;
 }
 
@@ -2868,7 +2880,7 @@ int osc_cache_writeback_range(const struct lu_env *env, struct osc_object *obj,
 			result = rc;
 	}
 
-	OSC_IO_DEBUG(obj, "cache page out.\n");
+	OSC_IO_DEBUG(obj, "pageout [%lu, %lu], %d.\n", start, end, result);
 	return result;
 }
 
-- 
1.7.9.5

