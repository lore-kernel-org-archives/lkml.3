Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaFWBcw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:32:52 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39753 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbaFWBct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:32:49 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 06/18] staging/lustre/mgc: mgc import reconnect race
Date: Sun, 22 Jun 2014 21:32:10 -0400
Message-Id: <1403487142-4880-7-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andriy Skulysh <Andriy_Skulysh@xyratex.com>

mgc import can be reconnected by pinger or
ptlrpc_reconnect_import().
ptlrpc_invalidate_import() isn't protected against
alteration of imp_invalid state. Import can be
reconnected by pinger which makes imp_invalid
equal to false. Thus LASSERT(imp->imp_invalid) fails
in ptlrpc_invalidate_import().

It is safe to call ptlrpc_invalidate_import() when
import is deactivated, but ptlrpc_reconnect_import() doesn't
deactivate it.
Let's use only pinger when available to reconnect import

Signed-off-by: Andriy Skulysh <Andriy_Skulysh@xyratex.com>
Reviewed-on: http://review.whamcloud.com/9967
Xyratex-bug-id: MRP-1746
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4913
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/obd_mount.c | 13 ++-----
 drivers/staging/lustre/lustre/ptlrpc/import.c      | 41 +++++++++++++++++-----
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |  5 +++
 3 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/obd_mount.c b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
index a034aee..03d9a6a 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_mount.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
@@ -219,7 +219,6 @@ int lustre_start_mgc(struct super_block *sb)
 	lnet_nid_t nid;
 	char *mgcname = NULL, *niduuid = NULL, *mgssec = NULL;
 	char *ptr;
-	int recov_bk;
 	int rc = 0, i = 0, j, len;
 
 	LASSERT(lsi->lsi_lmd);
@@ -269,6 +268,8 @@ int lustre_start_mgc(struct super_block *sb)
 
 	obd = class_name2obd(mgcname);
 	if (obd && !obd->obd_stopping) {
+		int recov_bk;
+
 		rc = obd_set_info_async(NULL, obd->obd_self_export,
 					strlen(KEY_MGSSEC), KEY_MGSSEC,
 					strlen(mgssec), mgssec, NULL);
@@ -429,16 +430,6 @@ int lustre_start_mgc(struct super_block *sb)
 	   so we know when we can get rid of the mgc. */
 	atomic_set(&obd->u.cli.cl_mgc_refcount, 1);
 
-	/* Try all connections, but only once. */
-	recov_bk = 1;
-	rc = obd_set_info_async(NULL, obd->obd_self_export,
-				sizeof(KEY_INIT_RECOV_BACKUP),
-				KEY_INIT_RECOV_BACKUP,
-				sizeof(recov_bk), &recov_bk, NULL);
-	if (rc)
-		/* nonfatal */
-		CWARN("can't set %s %d\n", KEY_INIT_RECOV_BACKUP, rc);
-
 	/* We connect to the MGS at setup, and don't disconnect until cleanup */
 	data->ocd_connect_flags = OBD_CONNECT_VERSION | OBD_CONNECT_AT |
 				  OBD_CONNECT_FULL20 | OBD_CONNECT_IMP_RECOV |
diff --git a/drivers/staging/lustre/lustre/ptlrpc/import.c b/drivers/staging/lustre/lustre/ptlrpc/import.c
index 8573f32..b4def8a 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/import.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/import.c
@@ -275,6 +275,7 @@ void ptlrpc_invalidate_import(struct obd_import *imp)
 	if (!imp->imp_invalid || imp->imp_obd->obd_no_recov)
 		ptlrpc_deactivate_import(imp);
 
+	CFS_FAIL_TIMEOUT(OBD_FAIL_MGS_CONNECT_NET, 3 * cfs_fail_val / 2);
 	LASSERT(imp->imp_invalid);
 
 	/* Wait forever until inflight == 0. We really can't do it another
@@ -392,6 +393,19 @@ void ptlrpc_activate_import(struct obd_import *imp)
 }
 EXPORT_SYMBOL(ptlrpc_activate_import);
 
+static void ptlrpc_pinger_force(struct obd_import *imp)
+{
+	CDEBUG(D_HA, "%s: waking up pinger s:%s\n", obd2cli_tgt(imp->imp_obd),
+	       ptlrpc_import_state_name(imp->imp_state));
+
+	spin_lock(&imp->imp_lock);
+	imp->imp_force_verify = 1;
+	spin_unlock(&imp->imp_lock);
+
+	if (imp->imp_state != LUSTRE_IMP_CONNECTING)
+		ptlrpc_pinger_wake_up();
+}
+
 void ptlrpc_fail_import(struct obd_import *imp, __u32 conn_cnt)
 {
 	LASSERT(!imp->imp_dlm_fake);
@@ -406,20 +420,30 @@ void ptlrpc_fail_import(struct obd_import *imp, __u32 conn_cnt)
 			ptlrpc_deactivate_import(imp);
 		}
 
-		CDEBUG(D_HA, "%s: waking up pinger\n",
-		       obd2cli_tgt(imp->imp_obd));
-
-		spin_lock(&imp->imp_lock);
-		imp->imp_force_verify = 1;
-		spin_unlock(&imp->imp_lock);
-
-		ptlrpc_pinger_wake_up();
+		ptlrpc_pinger_force(imp);
 	}
 }
 EXPORT_SYMBOL(ptlrpc_fail_import);
 
 int ptlrpc_reconnect_import(struct obd_import *imp)
 {
+#ifdef ENABLE_PINGER
+	struct l_wait_info lwi;
+	int secs = cfs_time_seconds(obd_timeout);
+	int rc;
+
+	ptlrpc_pinger_force(imp);
+
+	CDEBUG(D_HA, "%s: recovery started, waiting %u seconds\n",
+	       obd2cli_tgt(imp->imp_obd), secs);
+
+	lwi = LWI_TIMEOUT(secs, NULL, NULL);
+	rc = l_wait_event(imp->imp_recovery_waitq,
+			  !ptlrpc_import_in_recovery(imp), &lwi);
+	CDEBUG(D_HA, "%s: recovery finished s:%s\n", obd2cli_tgt(imp->imp_obd),
+	       ptlrpc_import_state_name(imp->imp_state));
+	return rc;
+#else
 	ptlrpc_set_import_discon(imp, 0);
 	/* Force a new connect attempt */
 	ptlrpc_invalidate_import(imp);
@@ -444,6 +468,7 @@ int ptlrpc_reconnect_import(struct obd_import *imp)
 	/* Attempt a new connect */
 	ptlrpc_recover_import(imp, NULL, 0);
 	return 0;
+#endif
 }
 EXPORT_SYMBOL(ptlrpc_reconnect_import);
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pinger.c b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
index 38099d9..2898087 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pinger.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
@@ -224,6 +224,11 @@ static void ptlrpc_pinger_process_import(struct obd_import *imp,
 		       "or recovery disabled: %s)\n",
 		       imp->imp_obd->obd_uuid.uuid, obd2cli_tgt(imp->imp_obd),
 		       ptlrpc_import_state_name(level));
+		if (force) {
+			spin_lock(&imp->imp_lock);
+			imp->imp_force_verify = 1;
+			spin_unlock(&imp->imp_lock);
+		}
 	} else if ((imp->imp_pingable && !suppress) || force_next || force) {
 		ptlrpc_ping(imp);
 	}
-- 
1.9.0

