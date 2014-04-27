Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbaD0RHu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:07:50 -0400
Received: from linuxhacker.ru ([217.76.32.60]:47977 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbaD0RHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:45 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 09/47] staging/lustre/ptlrpc: don't try to recover no_recov connection
Date: Sun, 27 Apr 2014 13:06:33 -0400
Message-Id: <1398618431-29757-10-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Dilger <andreas.dilger@intel.com>

If a connection has been stopped with ptlrpc_pinger_del_import() and
marked obd_no_recov, don't reconnect in ptlrpc_disconnect_import() if
the import is already disconnected.  Otherwise, without the pinger it
will just wait there indefinitely for the reconnection that will never
happen.

Put the obd_no_recov check inside ptlrpc_import_in_recovery() so that
any threads waiting on the connection to recover would also be broken
out of their sleep if obd_no_recov is set.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-on: http://review.whamcloud.com/8996
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4413
Reviewed-by: Nathaniel Clark <nathaniel.l.clark@intel.com>
Reviewed-by: wangdi <di.wang@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/import.c  | 29 +++++++++++++++++---------
 drivers/staging/lustre/lustre/ptlrpc/recover.c |  5 ++++-
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/import.c b/drivers/staging/lustre/lustre/ptlrpc/import.c
index a04a1cc..b231452 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/import.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/import.c
@@ -1404,26 +1404,33 @@ int ptlrpc_disconnect_import(struct obd_import *imp, int noclose)
 {
 	struct ptlrpc_request *req;
 	int rq_opc, rc = 0;
-	int nowait = imp->imp_obd->obd_force;
 
-	if (nowait)
+	if (imp->imp_obd->obd_force)
 		GOTO(set_state, rc);
 
 	switch (imp->imp_connect_op) {
-	case OST_CONNECT: rq_opc = OST_DISCONNECT; break;
-	case MDS_CONNECT: rq_opc = MDS_DISCONNECT; break;
-	case MGS_CONNECT: rq_opc = MGS_DISCONNECT; break;
+	case OST_CONNECT:
+		rq_opc = OST_DISCONNECT;
+		break;
+	case MDS_CONNECT:
+		rq_opc = MDS_DISCONNECT;
+		break;
+	case MGS_CONNECT:
+		rq_opc = MGS_DISCONNECT;
+		break;
 	default:
-		CERROR("don't know how to disconnect from %s (connect_op %d)\n",
-		       obd2cli_tgt(imp->imp_obd), imp->imp_connect_op);
-		return -EINVAL;
+		rc = -EINVAL;
+		CERROR("%s: don't know how to disconnect from %s "
+		       "(connect_op %d): rc = %d\n",
+		       imp->imp_obd->obd_name, obd2cli_tgt(imp->imp_obd),
+		       imp->imp_connect_op, rc);
+		return rc;
 	}
 
 	if (ptlrpc_import_in_recovery(imp)) {
 		struct l_wait_info lwi;
 		cfs_duration_t timeout;
 
-
 		if (AT_OFF) {
 			if (imp->imp_server_timeout)
 				timeout = cfs_time_seconds(obd_timeout / 2);
@@ -1446,7 +1453,6 @@ int ptlrpc_disconnect_import(struct obd_import *imp, int noclose)
 	spin_lock(&imp->imp_lock);
 	if (imp->imp_state != LUSTRE_IMP_FULL)
 		GOTO(out, 0);
-
 	spin_unlock(&imp->imp_lock);
 
 	req = ptlrpc_request_alloc_pack(imp, &RQF_MDS_DISCONNECT,
@@ -1479,6 +1485,9 @@ out:
 	memset(&imp->imp_remote_handle, 0, sizeof(imp->imp_remote_handle));
 	spin_unlock(&imp->imp_lock);
 
+	if (rc == -ETIMEDOUT || rc == -ENOTCONN || rc == -ESHUTDOWN)
+		rc = 0;
+
 	return rc;
 }
 EXPORT_SYMBOL(ptlrpc_disconnect_import);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/recover.c b/drivers/staging/lustre/lustre/ptlrpc/recover.c
index 48ae328..4cff2f7 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/recover.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/recover.c
@@ -369,11 +369,14 @@ EXPORT_SYMBOL(ptlrpc_recover_import);
 int ptlrpc_import_in_recovery(struct obd_import *imp)
 {
 	int in_recovery = 1;
+
 	spin_lock(&imp->imp_lock);
 	if (imp->imp_state == LUSTRE_IMP_FULL ||
 	    imp->imp_state == LUSTRE_IMP_CLOSED ||
-	    imp->imp_state == LUSTRE_IMP_DISCON)
+	    imp->imp_state == LUSTRE_IMP_DISCON ||
+	    imp->imp_obd->obd_no_recov)
 		in_recovery = 0;
 	spin_unlock(&imp->imp_lock);
+
 	return in_recovery;
 }
-- 
1.8.5.3

