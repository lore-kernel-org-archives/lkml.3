Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab3KNQov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:44:51 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41034 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128Ab3KNQoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:44:13 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Swapnil Pimpale <spimpale@ddn.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 11/26] staging/lustre/ptlrpc: Return a meaningful status from ptlrpcd_init()
Date: Fri, 15 Nov 2013 00:42:58 +0800
Message-Id: <1384447393-13838-12-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Swapnil Pimpale <spimpale@ddn.com>

This patch has the following:
1) Fix for the return value from ptlrpcd_init(). It will now return a
correct status instead of returning zero always.
2) ptlrpcd_addref() should not increment ptlrpcd_users on error.
3) Added code in a mdc_setup() and mgc_setup() to test the return
value of ptlrpcd_addref() and return on error.

Lustre-change: http://review.whamcloud.com/7522
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3808
Signed-off-by: Swapnil Pimpale <spimpale@ddn.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_request.c |   15 +++++++++------
 drivers/staging/lustre/lustre/mgc/libmgc.c      |    4 +++-
 drivers/staging/lustre/lustre/mgc/mgc_request.c |    8 +++++---
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c  |   13 ++++++++-----
 4 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 4c30fa8..651fcb1 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -2364,20 +2364,22 @@ struct ldlm_valblock_ops inode_lvbo = {
 
 static int mdc_setup(struct obd_device *obd, struct lustre_cfg *cfg)
 {
-	struct client_obd *cli = &obd->u.cli;
-	struct lprocfs_static_vars lvars = { 0 };
-	int rc;
+	struct client_obd		*cli = &obd->u.cli;
+	struct lprocfs_static_vars	lvars = { 0 };
+	int				rc;
 
 	OBD_ALLOC(cli->cl_rpc_lock, sizeof (*cli->cl_rpc_lock));
 	if (!cli->cl_rpc_lock)
 		return -ENOMEM;
 	mdc_init_rpc_lock(cli->cl_rpc_lock);
 
-	ptlrpcd_addref();
+	rc = ptlrpcd_addref();
+	if (rc < 0)
+		GOTO(err_rpc_lock, rc);
 
 	OBD_ALLOC(cli->cl_close_lock, sizeof (*cli->cl_close_lock));
 	if (!cli->cl_close_lock)
-		GOTO(err_rpc_lock, rc = -ENOMEM);
+		GOTO(err_ptlrpcd_decref, rc = -ENOMEM);
 	mdc_init_rpc_lock(cli->cl_close_lock);
 
 	rc = client_obd_setup(obd, cfg);
@@ -2403,9 +2405,10 @@ static int mdc_setup(struct obd_device *obd, struct lustre_cfg *cfg)
 
 err_close_lock:
 	OBD_FREE(cli->cl_close_lock, sizeof (*cli->cl_close_lock));
+err_ptlrpcd_decref:
+	ptlrpcd_decref();
 err_rpc_lock:
 	OBD_FREE(cli->cl_rpc_lock, sizeof (*cli->cl_rpc_lock));
-	ptlrpcd_decref();
 	return rc;
 }
 
diff --git a/drivers/staging/lustre/lustre/mgc/libmgc.c b/drivers/staging/lustre/lustre/mgc/libmgc.c
index 9b40c57..3269ad1 100644
--- a/drivers/staging/lustre/lustre/mgc/libmgc.c
+++ b/drivers/staging/lustre/lustre/mgc/libmgc.c
@@ -57,7 +57,9 @@ static int mgc_setup(struct obd_device *obd, struct lustre_cfg *lcfg)
 {
 	int rc;
 
-	ptlrpcd_addref();
+	rc = ptlrpcd_addref();
+	if (rc < 0)
+		return rc;
 
 	rc = client_obd_setup(obd, lcfg);
 	if (rc)
diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index 94e11bd..b6a55c6 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -852,10 +852,12 @@ static int mgc_cleanup(struct obd_device *obd)
 
 static int mgc_setup(struct obd_device *obd, struct lustre_cfg *lcfg)
 {
-	struct lprocfs_static_vars lvars;
-	int rc;
+	struct lprocfs_static_vars	lvars;
+	int				rc;
 
-	ptlrpcd_addref();
+	rc = ptlrpcd_addref();
+	if (rc < 0)
+		return rc;
 
 	rc = client_obd_setup(obd, lcfg);
 	if (rc)
diff --git a/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c b/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
index 337eefd..d73ed94 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
@@ -727,9 +727,9 @@ static void ptlrpcd_fini(void)
 
 static int ptlrpcd_init(void)
 {
-	int nthreads = num_online_cpus();
-	char name[16];
-	int size, i = -1, j, rc = 0;
+	int	nthreads = num_online_cpus();
+	char	name[16];
+	int	size, i = -1, j, rc = 0;
 
 	if (max_ptlrpcds > 0 && max_ptlrpcds < nthreads)
 		nthreads = max_ptlrpcds;
@@ -786,7 +786,7 @@ out:
 		ptlrpcds = NULL;
 	}
 
-	return 0;
+	return rc;
 }
 
 int ptlrpcd_addref(void)
@@ -794,8 +794,11 @@ int ptlrpcd_addref(void)
 	int rc = 0;
 
 	mutex_lock(&ptlrpcd_mutex);
-	if (++ptlrpcd_users == 1)
+	if (++ptlrpcd_users == 1) {
 		rc = ptlrpcd_init();
+		if (rc < 0)
+			ptlrpcd_users--;
+	}
 	mutex_unlock(&ptlrpcd_mutex);
 	return rc;
 }
-- 
1.7.9.5

