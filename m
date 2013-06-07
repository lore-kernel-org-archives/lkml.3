Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3FGM4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:56:39 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:40174 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab3FGM4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:56:35 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andreas Dilger <andreas.dilger@intel.com>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@openvz.org>, Peng Tao <bergwolf@gmail.com>,
        Dave Chinner <dchinner@redhat.com>, Peng Tao <tao.peng@emc.com>
Subject: [PATCH 2/5] staging/lustre/obdclass: convert lu_object shrinker to count/scan API
Date: Fri,  7 Jun 2013 20:53:43 +0800
Message-Id: <1370609626-3734-3-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370609626-3734-1-git-send-email-bergwolf@gmail.com>
References: <1370609626-3734-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert lu_object shrinker to new count/scan API.

Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   98 +++++++++++---------
 1 file changed, 52 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/lu_object.c b/drivers/staging/lustre/lustre/obdclass/lu_object.c
index fdf0ed3..1b88a74 100644
--- a/drivers/staging/lustre/lustre/obdclass/lu_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/lu_object.c
@@ -1783,7 +1783,6 @@ int lu_env_refill_by_tags(struct lu_env *env, __u32 ctags,
 }
 EXPORT_SYMBOL(lu_env_refill_by_tags);
 
-static struct shrinker *lu_site_shrinker = NULL;
 
 typedef struct lu_site_stats{
 	unsigned	lss_populated;
@@ -1839,61 +1838,68 @@ static void lu_site_stats_get(cfs_hash_t *hs,
  * objects without taking the  lu_sites_guard lock, but this is not
  * possible in the current implementation.
  */
-static int lu_cache_shrink(SHRINKER_ARGS(sc, nr_to_scan, gfp_mask))
+static unsigned long lu_cache_shrink_count(struct shrinker *sk,
+					   struct shrink_control *sc)
 {
 	lu_site_stats_t stats;
 	struct lu_site *s;
 	struct lu_site *tmp;
-	int cached = 0;
-	int remain = shrink_param(sc, nr_to_scan);
-	LIST_HEAD(splice);
-
-	if (!(shrink_param(sc, gfp_mask) & __GFP_FS)) {
-		if (remain != 0)
-			return -1;
-		else
-			/* We must not take the lu_sites_guard lock when
-			 * __GFP_FS is *not* set because of the deadlock
-			 * possibility detailed above. Additionally,
-			 * since we cannot determine the number of
-			 * objects in the cache without taking this
-			 * lock, we're in a particularly tough spot. As
-			 * a result, we'll just lie and say our cache is
-			 * empty. This _should_ be ok, as we can't
-			 * reclaim objects when __GFP_FS is *not* set
-			 * anyways.
-			 */
-			return 0;
-	}
+	unsigned long cached = 0;
 
-	CDEBUG(D_INODE, "Shrink %d objects\n", remain);
+	if (!sc->gfp_mask & __GFP_FS)
+		return 0;
 
 	mutex_lock(&lu_sites_guard);
 	list_for_each_entry_safe(s, tmp, &lu_sites, ls_linkage) {
-		if (shrink_param(sc, nr_to_scan) != 0) {
-			remain = lu_site_purge(&lu_shrink_env, s, remain);
-			/*
-			 * Move just shrunk site to the tail of site list to
-			 * assure shrinking fairness.
-			 */
-			list_move_tail(&s->ls_linkage, &splice);
-		}
-
 		memset(&stats, 0, sizeof(stats));
 		lu_site_stats_get(s->ls_obj_hash, &stats, 0);
 		cached += stats.lss_total - stats.lss_busy;
-		if (shrink_param(sc, nr_to_scan) && remain <= 0)
-			break;
 	}
-	list_splice(&splice, lu_sites.prev);
 	mutex_unlock(&lu_sites_guard);
 
 	cached = (cached / 100) * sysctl_vfs_cache_pressure;
-	if (shrink_param(sc, nr_to_scan) == 0)
-		CDEBUG(D_INODE, "%d objects cached\n", cached);
+	CDEBUG(D_INODE, "%ld objects cached\n", cached);
 	return cached;
 }
 
+static unsigned long lu_cache_shrink_scan(struct shrinker *sk,
+					  struct shrink_control *sc)
+{
+	struct lu_site *s;
+	struct lu_site *tmp;
+	unsigned long remain = sc->nr_to_scan, freed = 0;
+	LIST_HEAD(splice);
+
+	if (!sc->gfp_mask & __GFP_FS)
+		/* We must not take the lu_sites_guard lock when
+		 * __GFP_FS is *not* set because of the deadlock
+		 * possibility detailed above. Additionally,
+		 * since we cannot determine the number of
+		 * objects in the cache without taking this
+		 * lock, we're in a particularly tough spot. As
+		 * a result, we'll just lie and say our cache is
+		 * empty. This _should_ be ok, as we can't
+		 * reclaim objects when __GFP_FS is *not* set
+		 * anyways.
+		 */
+		return SHRINK_STOP;
+
+	mutex_lock(&lu_sites_guard);
+	list_for_each_entry_safe(s, tmp, &lu_sites, ls_linkage) {
+		freed = lu_site_purge(&lu_shrink_env, s, remain);
+		remain -= freed;
+		/*
+		 * Move just shrunk site to the tail of site list to
+		 * assure shrinking fairness.
+		 */
+		list_move_tail(&s->ls_linkage, &splice);
+	}
+	list_splice(&splice, lu_sites.prev);
+	mutex_unlock(&lu_sites_guard);
+
+	return sc->nr_to_scan - remain;
+}
+
 /*
  * Debugging stuff.
  */
@@ -1917,6 +1923,12 @@ int lu_printk_printer(const struct lu_env *env,
 	return 0;
 }
 
+static struct shrinker lu_site_shrinker = {
+	.count_objects	= lu_cache_shrink_count,
+	.scan_objects	= lu_cache_shrink_scan,
+	.seeks 		= DEFAULT_SEEKS,
+};
+
 /**
  * Initialization of global lu_* data.
  */
@@ -1951,9 +1963,7 @@ int lu_global_init(void)
 	 * inode, one for ea. Unfortunately setting this high value results in
 	 * lu_object/inode cache consuming all the memory.
 	 */
-	lu_site_shrinker = set_shrinker(DEFAULT_SEEKS, lu_cache_shrink);
-	if (lu_site_shrinker == NULL)
-		return -ENOMEM;
+	register_shrinker(&lu_site_shrinker);
 
 	return result;
 }
@@ -1963,11 +1973,7 @@ int lu_global_init(void)
  */
 void lu_global_fini(void)
 {
-	if (lu_site_shrinker != NULL) {
-		remove_shrinker(lu_site_shrinker);
-		lu_site_shrinker = NULL;
-	}
-
+	unregister_shrinker(&lu_site_shrinker);
 	lu_context_key_degister(&lu_global_key);
 
 	/*
-- 
1.7.9.5

