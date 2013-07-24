Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab3GXKYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:24:17 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:43165 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751272Ab3GXKYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:24:10 -0400
From: mail-agent-noreply@emc.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Michal Hocko <mhocko@suse.cz>, Dave Chinner <dchinner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH-v2 1/4] staging/lustre/ldlm: convert to shrinkers to count/scan API
Date: Wed, 24 Jul 2013 18:18:52 +0800
Message-Id: <1374661135-17072-2-git-send-email-mail-agent-noreply@emc.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374661135-17072-1-git-send-email-mail-agent-noreply@emc.com>
References: <1374661135-17072-1-git-send-email-mail-agent-noreply@emc.com>
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <bergwolf@gmail.com>

convert ldlm shrinker to new count/scan API.

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c |  148 +++++++++++++-----------
 1 files changed, 79 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
index 101af4b..9ac7e4d 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
@@ -524,7 +524,7 @@ static int ldlm_cli_pool_shrink(struct ldlm_pool *pl,
 				int nr, unsigned int gfp_mask)
 {
 	struct ldlm_namespace *ns;
-	int canceled = 0, unused;
+	int unused;
 
 	ns = ldlm_pl2ns(pl);
 
@@ -543,14 +543,10 @@ static int ldlm_cli_pool_shrink(struct ldlm_pool *pl,
 	unused = ns->ns_nr_unused;
 	spin_unlock(&ns->ns_lock);
 
-	if (nr) {
-		canceled = ldlm_cancel_lru(ns, nr, LCF_ASYNC,
-					   LDLM_CANCEL_SHRINK);
-	}
-	/*
-	 * Return the number of potentially reclaimable locks.
-	 */
-	return ((unused - canceled) / 100) * sysctl_vfs_cache_pressure;
+	if (nr == 0)
+		return (unused / 100) * sysctl_vfs_cache_pressure;
+	else
+		return ldlm_cancel_lru(ns, nr, LCF_ASYNC, LDLM_CANCEL_SHRINK);
 }
 
 struct ldlm_pool_ops ldlm_srv_pool_ops = {
@@ -604,9 +600,10 @@ int ldlm_pool_recalc(struct ldlm_pool *pl)
 	return recalc_interval_sec;
 }
 
-/**
+/*
  * Pool shrink wrapper. Will call either client or server pool recalc callback
- * depending what pool \a pl is used.
+ * depending what pool pl is used. When nr == 0, just return the number of
+ * freeable locks. Otherwise, return the number of canceled locks.
  */
 int ldlm_pool_shrink(struct ldlm_pool *pl, int nr,
 		     unsigned int gfp_mask)
@@ -1025,29 +1022,24 @@ static int ldlm_pool_granted(struct ldlm_pool *pl)
 }
 
 static struct ptlrpc_thread *ldlm_pools_thread;
-static struct shrinker *ldlm_pools_srv_shrinker;
-static struct shrinker *ldlm_pools_cli_shrinker;
 static struct completion ldlm_pools_comp;
 
 /*
- * Cancel \a nr locks from all namespaces (if possible). Returns number of
- * cached locks after shrink is finished. All namespaces are asked to
- * cancel approximately equal amount of locks to keep balancing.
+ * count locks from all namespaces (if possible). Returns number of
+ * cached locks.
  */
-static int ldlm_pools_shrink(ldlm_side_t client, int nr,
-			     unsigned int gfp_mask)
+static unsigned long ldlm_pools_count(ldlm_side_t client, unsigned int gfp_mask)
 {
-	int total = 0, cached = 0, nr_ns;
+	int total = 0, nr_ns;
 	struct ldlm_namespace *ns;
 	struct ldlm_namespace *ns_old = NULL; /* loop detection */
 	void *cookie;
 
-	if (client == LDLM_NAMESPACE_CLIENT && nr != 0 &&
-	    !(gfp_mask & __GFP_FS))
-		return -1;
+	if (client == LDLM_NAMESPACE_CLIENT && !(gfp_mask & __GFP_FS))
+		return 0;
 
-	CDEBUG(D_DLMTRACE, "Request to shrink %d %s locks from all pools\n",
-	       nr, client == LDLM_NAMESPACE_CLIENT ? "client" : "server");
+	CDEBUG(D_DLMTRACE, "Request to count %s locks from all pools\n",
+	       client == LDLM_NAMESPACE_CLIENT ? "client" : "server");
 
 	cookie = cl_env_reenter();
 
@@ -1055,8 +1047,7 @@ static int ldlm_pools_shrink(ldlm_side_t client, int nr,
 	 * Find out how many resources we may release.
 	 */
 	for (nr_ns = ldlm_namespace_nr_read(client);
-	     nr_ns > 0; nr_ns--)
-	{
+	     nr_ns > 0; nr_ns--) {
 		mutex_lock(ldlm_namespace_lock(client));
 		if (list_empty(ldlm_namespace_list(client))) {
 			mutex_unlock(ldlm_namespace_lock(client));
@@ -1086,17 +1077,27 @@ static int ldlm_pools_shrink(ldlm_side_t client, int nr,
 		ldlm_namespace_put(ns);
 	}
 
-	if (nr == 0 || total == 0) {
-		cl_env_reexit(cookie);
-		return total;
-	}
+	cl_env_reexit(cookie);
+	return total;
+}
+
+static unsigned long ldlm_pools_scan(ldlm_side_t client, int nr, unsigned int gfp_mask)
+{
+	unsigned long freed = 0;
+	int tmp, nr_ns;
+	struct ldlm_namespace *ns;
+	void *cookie;
+
+	if (client == LDLM_NAMESPACE_CLIENT && !(gfp_mask & __GFP_FS))
+		return -1;
+
+	cookie = cl_env_reenter();
 
 	/*
-	 * Shrink at least ldlm_namespace_nr(client) namespaces.
+	 * Shrink at least ldlm_namespace_nr_read(client) namespaces.
 	 */
-	for (nr_ns = ldlm_namespace_nr_read(client) - nr_ns;
-	     nr_ns > 0; nr_ns--)
-	{
+	for (tmp = nr_ns = ldlm_namespace_nr_read(client);
+	     tmp > 0; tmp--) {
 		int cancel, nr_locks;
 
 		/*
@@ -1105,12 +1106,6 @@ static int ldlm_pools_shrink(ldlm_side_t client, int nr,
 		mutex_lock(ldlm_namespace_lock(client));
 		if (list_empty(ldlm_namespace_list(client))) {
 			mutex_unlock(ldlm_namespace_lock(client));
-			/*
-			 * If list is empty, we can't return any @cached > 0,
-			 * that probably would cause needless shrinker
-			 * call.
-			 */
-			cached = 0;
 			break;
 		}
 		ns = ldlm_namespace_first_locked(client);
@@ -1119,29 +1114,42 @@ static int ldlm_pools_shrink(ldlm_side_t client, int nr,
 		mutex_unlock(ldlm_namespace_lock(client));
 
 		nr_locks = ldlm_pool_granted(&ns->ns_pool);
-		cancel = 1 + nr_locks * nr / total;
-		ldlm_pool_shrink(&ns->ns_pool, cancel, gfp_mask);
-		cached += ldlm_pool_granted(&ns->ns_pool);
+		/*
+		 * We use to shrink propotionally but with new shrinker API,
+		 * we lost the total number of freeable locks.
+		 */
+		cancel = 1 + min_t(int, nr_locks, nr / nr_ns);
+		freed += ldlm_pool_shrink(&ns->ns_pool, cancel, gfp_mask);
 		ldlm_namespace_put(ns);
 	}
 	cl_env_reexit(cookie);
-	/* we only decrease the SLV in server pools shrinker, return -1 to
-	 * kernel to avoid needless loop. LU-1128 */
-	return (client == LDLM_NAMESPACE_SERVER) ? -1 : cached;
+	/*
+	 * we only decrease the SLV in server pools shrinker, return
+	 * SHRINK_STOP to kernel to avoid needless loop. LU-1128
+	 */
+	return (client == LDLM_NAMESPACE_SERVER) ? SHRINK_STOP : freed;
+}
+
+static unsigned long ldlm_pools_srv_count(struct shrinker *s, struct shrink_control *sc)
+{
+	return ldlm_pools_count(LDLM_NAMESPACE_SERVER, sc->gfp_mask);
 }
 
-static int ldlm_pools_srv_shrink(SHRINKER_ARGS(sc, nr_to_scan, gfp_mask))
+static unsigned long ldlm_pools_srv_scan(struct shrinker *s, struct shrink_control *sc)
 {
-	return ldlm_pools_shrink(LDLM_NAMESPACE_SERVER,
-				 shrink_param(sc, nr_to_scan),
-				 shrink_param(sc, gfp_mask));
+	return ldlm_pools_scan(LDLM_NAMESPACE_SERVER, sc->nr_to_scan,
+			       sc->gfp_mask);
 }
 
-static int ldlm_pools_cli_shrink(SHRINKER_ARGS(sc, nr_to_scan, gfp_mask))
+static unsigned long ldlm_pools_cli_count(struct shrinker *s, struct shrink_control *sc)
 {
-	return ldlm_pools_shrink(LDLM_NAMESPACE_CLIENT,
-				 shrink_param(sc, nr_to_scan),
-				 shrink_param(sc, gfp_mask));
+	return ldlm_pools_count(LDLM_NAMESPACE_CLIENT, sc->gfp_mask);
+}
+
+static unsigned long ldlm_pools_cli_scan(struct shrinker *s, struct shrink_control *sc)
+{
+	return ldlm_pools_scan(LDLM_NAMESPACE_CLIENT, sc->nr_to_scan,
+			       sc->gfp_mask);
 }
 
 int ldlm_pools_recalc(ldlm_side_t client)
@@ -1224,7 +1232,7 @@ int ldlm_pools_recalc(ldlm_side_t client)
 	}
 
 	/*
-	 * Recalc at least ldlm_namespace_nr(client) namespaces.
+	 * Recalc at least ldlm_namespace_nr_read(client) namespaces.
 	 */
 	for (nr = ldlm_namespace_nr_read(client); nr > 0; nr--) {
 		int     skip;
@@ -1397,6 +1405,18 @@ static void ldlm_pools_thread_stop(void)
 	EXIT;
 }
 
+static struct shrinker ldlm_pools_srv_shrinker = {
+	.count_objects	= ldlm_pools_srv_count,
+	.scan_objects	= ldlm_pools_srv_scan,
+	.seeks		= DEFAULT_SEEKS,
+};
+
+static struct shrinker ldlm_pools_cli_shrinker = {
+	.count_objects	= ldlm_pools_cli_count,
+	.scan_objects	= ldlm_pools_cli_scan,
+	.seeks		= DEFAULT_SEEKS,
+};
+
 int ldlm_pools_init(void)
 {
 	int rc;
@@ -1404,12 +1424,8 @@ int ldlm_pools_init(void)
 
 	rc = ldlm_pools_thread_start();
 	if (rc == 0) {
-		ldlm_pools_srv_shrinker =
-			set_shrinker(DEFAULT_SEEKS,
-					 ldlm_pools_srv_shrink);
-		ldlm_pools_cli_shrinker =
-			set_shrinker(DEFAULT_SEEKS,
-					 ldlm_pools_cli_shrink);
+		register_shrinker(&ldlm_pools_srv_shrinker);
+		register_shrinker(&ldlm_pools_cli_shrinker);
 	}
 	RETURN(rc);
 }
@@ -1417,14 +1433,8 @@ EXPORT_SYMBOL(ldlm_pools_init);
 
 void ldlm_pools_fini(void)
 {
-	if (ldlm_pools_srv_shrinker != NULL) {
-		remove_shrinker(ldlm_pools_srv_shrinker);
-		ldlm_pools_srv_shrinker = NULL;
-	}
-	if (ldlm_pools_cli_shrinker != NULL) {
-		remove_shrinker(ldlm_pools_cli_shrinker);
-		ldlm_pools_cli_shrinker = NULL;
-	}
+	unregister_shrinker(&ldlm_pools_srv_shrinker);
+	unregister_shrinker(&ldlm_pools_cli_shrinker);
 	ldlm_pools_thread_stop();
 }
 EXPORT_SYMBOL(ldlm_pools_fini);
-- 
1.7.1

