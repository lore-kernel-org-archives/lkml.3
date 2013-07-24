Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab3GXKYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:24:15 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:43176 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751323Ab3GXKYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:24:12 -0400
From: mail-agent-noreply@emc.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Michal Hocko <mhocko@suse.cz>, Dave Chinner <dchinner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH-v2 2/4] staging/lustre/obdclass: convert lu_object shrinker to count/scan API
Date: Wed, 24 Jul 2013 18:18:53 +0800
Message-Id: <1374661135-17072-3-git-send-email-mail-agent-noreply@emc.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374661135-17072-2-git-send-email-mail-agent-noreply@emc.com>
References: <1374661135-17072-1-git-send-email-mail-agent-noreply@emc.com>
 <1374661135-17072-2-git-send-email-mail-agent-noreply@emc.com>
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <bergwolf@gmail.com>

convert lu_object shrinker to new count/scan API.

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   98 ++++++++++---------
 1 files changed, 52 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/lu_object.c b/drivers/staging/lustre/lustre/obdclass/lu_object.c
index ce0444f..a57d8fb 100644
--- a/drivers/staging/lustre/lustre/obdclass/lu_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/lu_object.c
@@ -1780,7 +1780,6 @@ int lu_env_refill_by_tags(struct lu_env *env, __u32 ctags,
 }
 EXPORT_SYMBOL(lu_env_refill_by_tags);
 
-static struct shrinker *lu_site_shrinker = NULL;
 
 typedef struct lu_site_stats{
 	unsigned	lss_populated;
@@ -1836,61 +1835,68 @@ static void lu_site_stats_get(cfs_hash_t *hs,
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
+	if (!(sc->gfp_mask & __GFP_FS))
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
+	if (!(sc->gfp_mask & __GFP_FS))
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
@@ -1914,6 +1920,12 @@ int lu_printk_printer(const struct lu_env *env,
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
@@ -1948,9 +1960,7 @@ int lu_global_init(void)
 	 * inode, one for ea. Unfortunately setting this high value results in
 	 * lu_object/inode cache consuming all the memory.
 	 */
-	lu_site_shrinker = set_shrinker(DEFAULT_SEEKS, lu_cache_shrink);
-	if (lu_site_shrinker == NULL)
-		return -ENOMEM;
+	register_shrinker(&lu_site_shrinker);
 
 	return result;
 }
@@ -1960,11 +1970,7 @@ int lu_global_init(void)
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
1.7.1

