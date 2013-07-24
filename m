Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab3GXKYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:24:23 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:43259 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751531Ab3GXKYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:24:20 -0400
From: mail-agent-noreply@emc.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Michal Hocko <mhocko@suse.cz>, Dave Chinner <dchinner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH-v2 3/4] staging/lustre/ptlrpc: convert to new shrinker API
Date: Wed, 24 Jul 2013 18:18:54 +0800
Message-Id: <1374661135-17072-4-git-send-email-mail-agent-noreply@emc.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374661135-17072-3-git-send-email-mail-agent-noreply@emc.com>
References: <1374661135-17072-1-git-send-email-mail-agent-noreply@emc.com>
 <1374661135-17072-2-git-send-email-mail-agent-noreply@emc.com>
 <1374661135-17072-3-git-send-email-mail-agent-noreply@emc.com>
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <bergwolf@gmail.com>

Convert sptlrpc encode pool shrinker to use scan/count API.

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c |   76 +++++++++++++----------
 1 files changed, 42 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
index 9013745..e90c8fb 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
@@ -121,13 +121,6 @@ static struct ptlrpc_enc_page_pool {
 } page_pools;
 
 /*
- * memory shrinker
- */
-const int pools_shrinker_seeks = DEFAULT_SEEKS;
-static struct shrinker *pools_shrinker = NULL;
-
-
-/*
  * /proc/fs/lustre/sptlrpc/encrypt_page_pools
  */
 int sptlrpc_proc_enc_pool_seq_show(struct seq_file *m, void *v)
@@ -226,30 +219,46 @@ static void enc_pools_release_free_pages(long npages)
 }
 
 /*
- * could be called frequently for query (@nr_to_scan == 0).
  * we try to keep at least PTLRPC_MAX_BRW_PAGES pages in the pool.
  */
-static int enc_pools_shrink(SHRINKER_ARGS(sc, nr_to_scan, gfp_mask))
+static unsigned long enc_pools_shrink_count(struct shrinker *s,
+					    struct shrink_control *sc)
 {
-	if (unlikely(shrink_param(sc, nr_to_scan) != 0)) {
+	/*
+	 * if no pool access for a long time, we consider it's fully idle.
+	 * a little race here is fine.
+	 */
+	if (unlikely(cfs_time_current_sec() - page_pools.epp_last_access >
+		     CACHE_QUIESCENT_PERIOD)) {
 		spin_lock(&page_pools.epp_lock);
-		shrink_param(sc, nr_to_scan) = min_t(unsigned long,
-						   shrink_param(sc, nr_to_scan),
-						   page_pools.epp_free_pages -
-						   PTLRPC_MAX_BRW_PAGES);
-		if (shrink_param(sc, nr_to_scan) > 0) {
-			enc_pools_release_free_pages(shrink_param(sc,
-								  nr_to_scan));
-			CDEBUG(D_SEC, "released %ld pages, %ld left\n",
-			       (long)shrink_param(sc, nr_to_scan),
-			       page_pools.epp_free_pages);
-
-			page_pools.epp_st_shrinks++;
-			page_pools.epp_last_shrink = cfs_time_current_sec();
-		}
+		page_pools.epp_idle_idx = IDLE_IDX_MAX;
 		spin_unlock(&page_pools.epp_lock);
 	}
 
+	LASSERT(page_pools.epp_idle_idx <= IDLE_IDX_MAX);
+	return max((int)page_pools.epp_free_pages - PTLRPC_MAX_BRW_PAGES, 0) *
+		(IDLE_IDX_MAX - page_pools.epp_idle_idx) / IDLE_IDX_MAX;
+}
+
+/*
+ * we try to keep at least PTLRPC_MAX_BRW_PAGES pages in the pool.
+ */
+static unsigned long enc_pools_shrink_scan(struct shrinker *s,
+					   struct shrink_control *sc)
+{
+	spin_lock(&page_pools.epp_lock);
+	sc->nr_to_scan = min_t(unsigned long, sc->nr_to_scan,
+			      page_pools.epp_free_pages - PTLRPC_MAX_BRW_PAGES);
+	if (sc->nr_to_scan > 0) {
+		enc_pools_release_free_pages(sc->nr_to_scan);
+		CDEBUG(D_SEC, "released %ld pages, %ld left\n",
+		       (long)sc->nr_to_scan, page_pools.epp_free_pages);
+
+		page_pools.epp_st_shrinks++;
+		page_pools.epp_last_shrink = cfs_time_current_sec();
+	}
+	spin_unlock(&page_pools.epp_lock);
+
 	/*
 	 * if no pool access for a long time, we consider it's fully idle.
 	 * a little race here is fine.
@@ -262,8 +271,7 @@ static int enc_pools_shrink(SHRINKER_ARGS(sc, nr_to_scan, gfp_mask))
 	}
 
 	LASSERT(page_pools.epp_idle_idx <= IDLE_IDX_MAX);
-	return max((int)page_pools.epp_free_pages - PTLRPC_MAX_BRW_PAGES, 0) *
-		(IDLE_IDX_MAX - page_pools.epp_idle_idx) / IDLE_IDX_MAX;
+	return sc->nr_to_scan;
 }
 
 static inline
@@ -699,6 +707,12 @@ static inline void enc_pools_free(void)
 		       sizeof(*page_pools.epp_pools));
 }
 
+static struct shrinker pools_shrinker = {
+	.count_objects	= enc_pools_shrink_count,
+	.scan_objects	= enc_pools_shrink_scan,
+	.seeks		= DEFAULT_SEEKS,
+};
+
 int sptlrpc_enc_pool_init(void)
 {
 	/*
@@ -736,12 +750,7 @@ int sptlrpc_enc_pool_init(void)
 	if (page_pools.epp_pools == NULL)
 		return -ENOMEM;
 
-	pools_shrinker = set_shrinker(pools_shrinker_seeks,
-					  enc_pools_shrink);
-	if (pools_shrinker == NULL) {
-		enc_pools_free();
-		return -ENOMEM;
-	}
+	register_shrinker(&pools_shrinker);
 
 	return 0;
 }
@@ -750,11 +759,10 @@ void sptlrpc_enc_pool_fini(void)
 {
 	unsigned long cleaned, npools;
 
-	LASSERT(pools_shrinker);
 	LASSERT(page_pools.epp_pools);
 	LASSERT(page_pools.epp_total_pages == page_pools.epp_free_pages);
 
-	remove_shrinker(pools_shrinker);
+	unregister_shrinker(&pools_shrinker);
 
 	npools = npages_to_npools(page_pools.epp_total_pages);
 	cleaned = enc_pools_cleanup(page_pools.epp_pools, npools);
-- 
1.7.1

