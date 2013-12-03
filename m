Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab3LCOF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:05:58 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:50264 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3LCOFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:05:04 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Eremin <dmitry.eremin@intel.com>,
        Ned Bass <bass6@llnl.gov>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v3 13/15] staging/lustre/pinger: remove never implemented suspend timeouts functionality
Date: Tue,  3 Dec 2013 21:58:51 +0800
Message-Id: <1386079133-6459-14-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
References: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

This is part of original Lustre tree commit. It removes never implemented
suspend timeouts functionality from pinger.c which was commented out
since 2007 and going to be replaced by adaptive timeouts. Also removed all
references to this functionality from ldlm_lockd.c, ldlm_request.c and
import.c which actually nevers executes or do nothing.

Lustre-change: http://review.whamcloud.com/6139
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3204
Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Signed-off-by: Ned Bass <bass6@llnl.gov>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_ha.h  |    3 -
 drivers/staging/lustre/lustre/include/lustre_net.h |    2 -
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |    3 -
 drivers/staging/lustre/lustre/ptlrpc/import.c      |    2 -
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |   65 --------------------
 5 files changed, 75 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_ha.h b/drivers/staging/lustre/lustre/include/lustre_ha.h
index 105f6d6..f3ae02b 100644
--- a/drivers/staging/lustre/lustre/include/lustre_ha.h
+++ b/drivers/staging/lustre/lustre/include/lustre_ha.h
@@ -58,9 +58,6 @@ void ptlrpc_activate_import(struct obd_import *imp);
 void ptlrpc_deactivate_import(struct obd_import *imp);
 void ptlrpc_invalidate_import(struct obd_import *imp);
 void ptlrpc_fail_import(struct obd_import *imp, __u32 conn_cnt);
-int ptlrpc_check_suspend(void);
-void ptlrpc_activate_timeouts(struct obd_import *imp);
-void ptlrpc_deactivate_timeouts(struct obd_import *imp);
 
 /** @} ha */
 
diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index 91f28e3..6c5479b 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -3403,10 +3403,8 @@ int ptlrpc_del_timeout_client(struct list_head *obd_list,
 			      enum timeout_event event);
 struct ptlrpc_request * ptlrpc_prep_ping(struct obd_import *imp);
 int ptlrpc_obd_ping(struct obd_device *obd);
-cfs_time_t ptlrpc_suspend_wakeup_time(void);
 void ping_evictor_start(void);
 void ping_evictor_stop(void);
-int ptlrpc_check_and_wait_suspend(struct ptlrpc_request *req);
 void ptlrpc_pinger_ir_up(void);
 void ptlrpc_pinger_ir_down(void);
 /** @} */
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
index 4974bec..a8f8c1c 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
@@ -97,9 +97,6 @@ int ldlm_expired_completion_wait(void *data)
 	if (lock->l_conn_export == NULL) {
 		static cfs_time_t next_dump = 0, last_dump = 0;
 
-		if (ptlrpc_check_suspend())
-			return 0;
-
 		LCONSOLE_WARN("lock timed out (enqueued at "CFS_TIME_T", "
 			      CFS_DURATION_T"s ago)\n",
 			      lock->l_last_activity,
diff --git a/drivers/staging/lustre/lustre/ptlrpc/import.c b/drivers/staging/lustre/lustre/ptlrpc/import.c
index 283173a..f465547 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/import.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/import.c
@@ -170,7 +170,6 @@ int ptlrpc_set_import_discon(struct obd_import *imp, __u32 conn_cnt)
 			       target_len, target_start,
 			       libcfs_nid2str(imp->imp_connection->c_peer.nid));
 		}
-		ptlrpc_deactivate_timeouts(imp);
 		IMPORT_SET_STATE_NOLOCK(imp, LUSTRE_IMP_DISCON);
 		spin_unlock(&imp->imp_lock);
 
@@ -383,7 +382,6 @@ void ptlrpc_activate_import(struct obd_import *imp)
 
 	spin_lock(&imp->imp_lock);
 	imp->imp_invalid = 0;
-	ptlrpc_activate_timeouts(imp);
 	spin_unlock(&imp->imp_lock);
 	obd_import_event(obd, imp, IMP_EVENT_ACTIVE);
 }
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pinger.c b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
index 4684b03..6dff502 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pinger.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
@@ -141,9 +141,6 @@ static inline int ptlrpc_next_reconnect(struct obd_import *imp)
 		return cfs_time_shift(obd_timeout);
 }
 
-static atomic_t suspend_timeouts = ATOMIC_INIT(0);
-static cfs_time_t suspend_wakeup_time = 0;
-
 cfs_duration_t pinger_check_timeout(cfs_time_t time)
 {
 	struct timeout_item *item;
@@ -163,67 +160,6 @@ cfs_duration_t pinger_check_timeout(cfs_time_t time)
 					 cfs_time_current());
 }
 
-static wait_queue_head_t suspend_timeouts_waitq;
-
-cfs_time_t ptlrpc_suspend_wakeup_time(void)
-{
-	return suspend_wakeup_time;
-}
-
-void ptlrpc_deactivate_timeouts(struct obd_import *imp)
-{
-	/*XXX: disabled for now, will be replaced by adaptive timeouts */
-#if 0
-	if (imp->imp_no_timeout)
-		return;
-	imp->imp_no_timeout = 1;
-	atomic_inc(&suspend_timeouts);
-	CDEBUG(D_HA|D_WARNING, "deactivate timeouts %u\n",
-	       atomic_read(&suspend_timeouts));
-#endif
-}
-
-void ptlrpc_activate_timeouts(struct obd_import *imp)
-{
-	/*XXX: disabled for now, will be replaced by adaptive timeouts */
-#if 0
-	if (!imp->imp_no_timeout)
-		return;
-	imp->imp_no_timeout = 0;
-	LASSERT(atomic_read(&suspend_timeouts) > 0);
-	if (atomic_dec_and_test(&suspend_timeouts)) {
-		suspend_wakeup_time = cfs_time_current();
-		wake_up(&suspend_timeouts_waitq);
-	}
-	CDEBUG(D_HA|D_WARNING, "activate timeouts %u\n",
-	       atomic_read(&suspend_timeouts));
-#endif
-}
-
-int ptlrpc_check_suspend(void)
-{
-	if (atomic_read(&suspend_timeouts))
-		return 1;
-	return 0;
-}
-
-int ptlrpc_check_and_wait_suspend(struct ptlrpc_request *req)
-{
-	struct l_wait_info lwi;
-
-	if (atomic_read(&suspend_timeouts)) {
-		DEBUG_REQ(D_NET, req, "-- suspend %d regular timeout",
-			  atomic_read(&suspend_timeouts));
-		lwi = LWI_INTR(NULL, NULL);
-		l_wait_event(suspend_timeouts_waitq,
-			     atomic_read(&suspend_timeouts) == 0, &lwi);
-		DEBUG_REQ(D_NET, req, "-- recharge regular timeout");
-		return 1;
-	}
-	return 0;
-}
-
-
 static bool ir_up;
 
 void ptlrpc_pinger_ir_up(void)
@@ -378,7 +314,6 @@ int ptlrpc_start_pinger(void)
 		return -EALREADY;
 
 	init_waitqueue_head(&pinger_thread.t_ctl_waitq);
-	init_waitqueue_head(&suspend_timeouts_waitq);
 
 	strcpy(pinger_thread.t_name, "ll_ping");
 
-- 
1.7.9.5

