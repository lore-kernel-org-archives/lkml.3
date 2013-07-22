Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab3GVQLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:11:06 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:61961 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634Ab3GVQLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:11:01 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Drokin <green@whamcloud.com>,
        Oleg Drokin <oleg.drokin@intel.com>, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 14/48] staging/lustre: Only wake up ldlm_poold as frequently as the check interval
Date: Tue, 23 Jul 2013 00:06:35 +0800
Message-Id: <1374509230-3324-15-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Drokin <green@whamcloud.com>

We used to wake up ldlm poold every second, but that's overkill,
we should just see how much time is left until next closest recalc
interval hits and sleep this much.
This will make "per-second" client grant statistic not actually
per-second, but I don't think we need any precision in that code

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2924
Lustre-change: http://review.whamcloud.com/5793
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
Reviewed-by: Vitaly Fertman <vitaly_fertman@xyratex.com>
Reviewed-by: Hiroya Nozaki <nozaki.hiroya@jp.fujitsu.com>
Reviewed-by: Niu Yawei <yawei.niu@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_dlm.h |    2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |   24 ++++++++++++--------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_dlm.h b/drivers/staging/lustre/lustre/include/lustre_dlm.h
index 48cb6f8..25437b7 100644
--- a/drivers/staging/lustre/lustre/include/lustre_dlm.h
+++ b/drivers/staging/lustre/lustre/include/lustre_dlm.h
@@ -1643,7 +1643,7 @@ void unlock_res_and_lock(struct ldlm_lock *lock);
  * There are not used outside of ldlm.
  * @{
  */
-void ldlm_pools_recalc(ldlm_side_t client);
+int ldlm_pools_recalc(ldlm_side_t client);
 int ldlm_pools_init(void);
 void ldlm_pools_fini(void);
 
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
index 1e6802f..3277a0d 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
@@ -578,7 +578,6 @@ int ldlm_pool_recalc(struct ldlm_pool *pl)
 		goto recalc;
 
 	spin_lock(&pl->pl_lock);
-	recalc_interval_sec = cfs_time_current_sec() - pl->pl_recalc_time;
 	if (recalc_interval_sec > 0) {
 		/*
 		 * Update pool statistics every 1s.
@@ -598,12 +597,12 @@ int ldlm_pool_recalc(struct ldlm_pool *pl)
 		count = pl->pl_ops->po_recalc(pl);
 		lprocfs_counter_add(pl->pl_stats, LDLM_POOL_RECALC_STAT,
 				    count);
-		return count;
 	}
+	recalc_interval_sec = pl->pl_recalc_time - cfs_time_current_sec() +
+			      pl->pl_recalc_period;
 
-	return 0;
+	return recalc_interval_sec;
 }
-EXPORT_SYMBOL(ldlm_pool_recalc);
 
 /**
  * Pool shrink wrapper. Will call either client or server pool recalc callback
@@ -1144,12 +1143,13 @@ static int ldlm_pools_cli_shrink(SHRINKER_ARGS(sc, nr_to_scan, gfp_mask))
 				 shrink_param(sc, gfp_mask));
 }
 
-void ldlm_pools_recalc(ldlm_side_t client)
+int ldlm_pools_recalc(ldlm_side_t client)
 {
 	__u32 nr_l = 0, nr_p = 0, l;
 	struct ldlm_namespace *ns;
 	struct ldlm_namespace *ns_old = NULL;
 	int nr, equal = 0;
+	int time = 50; /* seconds of sleep if no active namespaces */
 
 	/*
 	 * No need to setup pool limit for client pools.
@@ -1285,16 +1285,22 @@ void ldlm_pools_recalc(ldlm_side_t client)
 		 * After setup is done - recalc the pool.
 		 */
 		if (!skip) {
-			ldlm_pool_recalc(&ns->ns_pool);
+			int ttime = ldlm_pool_recalc(&ns->ns_pool);
+
+			if (ttime < time)
+				time = ttime;
+
 			ldlm_namespace_put(ns);
 		}
 	}
+	return time;
 }
 EXPORT_SYMBOL(ldlm_pools_recalc);
 
 static int ldlm_pools_thread_main(void *arg)
 {
 	struct ptlrpc_thread *thread = (struct ptlrpc_thread *)arg;
+	int s_time, c_time;
 	ENTRY;
 
 	thread_set_flags(thread, SVC_RUNNING);
@@ -1309,14 +1315,14 @@ static int ldlm_pools_thread_main(void *arg)
 		/*
 		 * Recal all pools on this tick.
 		 */
-		ldlm_pools_recalc(LDLM_NAMESPACE_SERVER);
-		ldlm_pools_recalc(LDLM_NAMESPACE_CLIENT);
+		s_time = ldlm_pools_recalc(LDLM_NAMESPACE_SERVER);
+		c_time = ldlm_pools_recalc(LDLM_NAMESPACE_CLIENT);
 
 		/*
 		 * Wait until the next check time, or until we're
 		 * stopped.
 		 */
-		lwi = LWI_TIMEOUT(cfs_time_seconds(LDLM_POOLS_THREAD_PERIOD),
+		lwi = LWI_TIMEOUT(cfs_time_seconds(min(s_time, c_time)),
 				  NULL, NULL);
 		l_wait_event(thread->t_ctl_waitq,
 			     thread_is_stopping(thread) ||
-- 
1.7.9.5

