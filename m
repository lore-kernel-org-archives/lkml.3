Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaIEUJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:09:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:63595 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbaIEUJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:09:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,474,1406617200"; 
   d="scan'208";a="598712750"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 07/12] staging/lustre/mgc: inline mgc_cancel()
Date: Fri, 5 Sep 2014 15:08:13 -0500
Message-ID: <1409947698-30781-8-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409947698-30781-1-git-send-email-john.hammond@intel.com>
References: <1409947698-30781-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.108]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

The function mgc_cancel() is never invoked as an OBD device method and
is only called directly from mgc_process_log() so remove it.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 drivers/staging/lustre/lustre/mgc/mgc_request.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index 970e91c..cb0e6f9 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -904,14 +904,6 @@ static int mgc_enqueue(struct obd_export *exp, struct lov_stripe_md *lsm,
 	return rc;
 }
 
-static int mgc_cancel(struct obd_export *exp, struct lov_stripe_md *md,
-		      __u32 mode, struct lustre_handle *lockh)
-{
-	ldlm_lock_decref(lockh, mode);
-
-	return 0;
-}
-
 static void mgc_notify_active(struct obd_device *unused)
 {
 	/* wakeup mgc_requeue_thread to requeue mgc lock */
@@ -1679,12 +1671,8 @@ int mgc_process_log(struct obd_device *mgc, struct config_llog_data *cld)
 	mutex_unlock(&cld->cld_lock);
 
 	/* Now drop the lock so MGS can revoke it */
-	if (!rcl) {
-		rcl = mgc_cancel(mgc->u.cli.cl_mgc_mgsexp, NULL,
-				 LCK_CR, &lockh);
-		if (rcl)
-			CERROR("Can't drop cfg lock: %d\n", rcl);
-	}
+	if (!rcl)
+		ldlm_lock_decref(&lockh, LCK_CR);
 
 	return rc;
 }
@@ -1814,7 +1802,6 @@ struct obd_ops mgc_obd_ops = {
 	.o_connect      = client_connect_import,
 	.o_disconnect   = client_disconnect_export,
 	/* .o_enqueue      = mgc_enqueue, */
-	.o_cancel       = mgc_cancel,
 	/* .o_iocontrol    = mgc_iocontrol, */
 	.o_set_info_async = mgc_set_info_async,
 	.o_get_info       = mgc_get_info,
-- 
1.7.9.5

