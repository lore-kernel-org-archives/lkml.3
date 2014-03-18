Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbaCRNHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:07:17 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40751 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbaCRNHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:07:14 -0400
From: Peng Tao <bergwolf@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 4/5] staging/lustre/libcfs: remove schedule_timeout_and_set_state
Date: Tue, 18 Mar 2014 21:05:55 +0800
Message-Id: <1395147956-2056-5-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1395147956-2056-4-git-send-email-bergwolf@gmail.com>
References: <1395147956-2056-1-git-send-email-bergwolf@gmail.com>
 <1395147956-2056-2-git-send-email-bergwolf@gmail.com>
 <1395147956-2056-3-git-send-email-bergwolf@gmail.com>
 <1395147956-2056-4-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/libcfs_prim.h      |    1 -
 drivers/staging/lustre/lnet/lnet/router.c          |    4 ++--
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |    4 ++--
 drivers/staging/lustre/lustre/libcfs/fail.c        |    4 ++--
 .../lustre/lustre/libcfs/linux/linux-prim.c        |    8 --------
 drivers/staging/lustre/lustre/obdclass/genops.c    |    4 ++--
 drivers/staging/lustre/lustre/obdecho/echo.c       |    3 ++-
 .../staging/lustre/lustre/obdecho/echo_client.c    |    4 ++--
 drivers/staging/lustre/lustre/ptlrpc/sec.c         |    4 ++--
 9 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
index 41fad1a..5d13124 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
@@ -49,7 +49,6 @@ void cfs_pause(cfs_duration_t ticks);
  * Timer
  */
 typedef  void (cfs_timer_func_t)(ulong_ptr_t);
-void schedule_timeout_and_set_state(long, int64_t);
 
 void add_wait_queue_exclusive_head(wait_queue_head_t *, wait_queue_t *);
 
diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
index d1ee442..8ea8942 100644
--- a/drivers/staging/lustre/lnet/lnet/router.c
+++ b/drivers/staging/lustre/lnet/lnet/router.c
@@ -1209,8 +1209,8 @@ rescan:
 		/* Call cfs_pause() here always adds 1 to load average
 		 * because kernel counts # active tasks as nr_running
 		 * + nr_uninterruptible. */
-		schedule_timeout_and_set_state(TASK_INTERRUPTIBLE,
-						   cfs_time_seconds(1));
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(cfs_time_seconds(1));
 	}
 
 	LASSERT(the_lnet.ln_rc_state == LNET_RC_STATE_STOPPING);
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
index d87048d..7e63cf3 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
@@ -192,8 +192,8 @@ static void ldlm_handle_cp_callback(struct ptlrpc_request *req,
 	if (OBD_FAIL_CHECK(OBD_FAIL_LDLM_CANCEL_BL_CB_RACE)) {
 		int to = cfs_time_seconds(1);
 		while (to > 0) {
-			schedule_timeout_and_set_state(
-				TASK_INTERRUPTIBLE, to);
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(to);
 			if (lock->l_granted_mode == lock->l_req_mode ||
 			    lock->l_flags & LDLM_FL_DESTROYED)
 				break;
diff --git a/drivers/staging/lustre/lustre/libcfs/fail.c b/drivers/staging/lustre/lustre/libcfs/fail.c
index c54448d..ba43ff7 100644
--- a/drivers/staging/lustre/lustre/libcfs/fail.c
+++ b/drivers/staging/lustre/lustre/libcfs/fail.c
@@ -127,8 +127,8 @@ int __cfs_fail_timeout_set(__u32 id, __u32 value, int ms, int set)
 	if (ret) {
 		CERROR("cfs_fail_timeout id %x sleeping for %dms\n",
 		       id, ms);
-		schedule_timeout_and_set_state(TASK_UNINTERRUPTIBLE,
-						   cfs_time_seconds(ms) / 1000);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(cfs_time_seconds(ms) / 1000);
 		set_current_state(TASK_RUNNING);
 		CERROR("cfs_fail_timeout id %x awake\n", id);
 	}
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
index 8aa00e5..fdb4cdb 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
@@ -70,14 +70,6 @@ add_wait_queue_exclusive_head(wait_queue_head_t *waitq, wait_queue_t *link)
 }
 EXPORT_SYMBOL(add_wait_queue_exclusive_head);
 
-void
-schedule_timeout_and_set_state(long state, int64_t timeout)
-{
-	set_current_state(state);
-	schedule_timeout(timeout);
-}
-EXPORT_SYMBOL(schedule_timeout_and_set_state);
-
 /* deschedule for a bit... */
 void
 cfs_pause(cfs_duration_t ticks)
diff --git a/drivers/staging/lustre/lustre/obdclass/genops.c b/drivers/staging/lustre/lustre/obdclass/genops.c
index 169c9ed..f2bdea3 100644
--- a/drivers/staging/lustre/lustre/obdclass/genops.c
+++ b/drivers/staging/lustre/lustre/obdclass/genops.c
@@ -1534,8 +1534,8 @@ void obd_exports_barrier(struct obd_device *obd)
 	spin_lock(&obd->obd_dev_lock);
 	while (!list_empty(&obd->obd_unlinked_exports)) {
 		spin_unlock(&obd->obd_dev_lock);
-		schedule_timeout_and_set_state(TASK_UNINTERRUPTIBLE,
-						   cfs_time_seconds(waited));
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(cfs_time_seconds(waited));
 		if (waited > 5 && IS_PO2(waited)) {
 			LCONSOLE_WARN("%s is waiting for obd_unlinked_exports "
 				      "more than %d seconds. "
diff --git a/drivers/staging/lustre/lustre/obdecho/echo.c b/drivers/staging/lustre/lustre/obdecho/echo.c
index debb9ce..96a807f 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo.c
@@ -606,7 +606,8 @@ static int echo_cleanup(struct obd_device *obd)
 
 	/* XXX Bug 3413; wait for a bit to ensure the BL callback has
 	 * happened before calling ldlm_namespace_free() */
-	schedule_timeout_and_set_state(TASK_UNINTERRUPTIBLE, cfs_time_seconds(1));
+	set_current_state(TASK_UNINTERRUPTIBLE);
+	schedule_timeout(cfs_time_seconds(1));
 
 	ldlm_namespace_free(obd->obd_namespace, NULL, obd->obd_force);
 	obd->obd_namespace = NULL;
diff --git a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
index 268a202..754aa8e 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -997,8 +997,8 @@ static struct lu_device *echo_device_free(const struct lu_env *env,
 		spin_unlock(&ec->ec_lock);
 		CERROR("echo_client still has objects at cleanup time, "
 		       "wait for 1 second\n");
-		schedule_timeout_and_set_state(TASK_UNINTERRUPTIBLE,
-						   cfs_time_seconds(1));
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(cfs_time_seconds(1));
 		lu_site_purge(env, &ed->ed_site->cs_lu, -1);
 		spin_lock(&ec->ec_lock);
 	}
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec.c b/drivers/staging/lustre/lustre/ptlrpc/sec.c
index 9145dd2..d8041805 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec.c
@@ -543,8 +543,8 @@ int sptlrpc_req_replace_dead_ctx(struct ptlrpc_request *req)
 		       "ctx (%p, fl %lx) doesn't switch, relax a little bit\n",
 		       newctx, newctx->cc_flags);
 
-		schedule_timeout_and_set_state(TASK_INTERRUPTIBLE,
-						   HZ);
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(HZ);
 	} else {
 		/*
 		 * it's possible newctx == oldctx if we're switching
-- 
1.7.7.6

