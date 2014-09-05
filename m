Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaIEUKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:10:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:63650 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaIEUKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:10:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,474,1406617200"; 
   d="scan'208";a="598712904"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 09/12] staging/lustre/mgc: remove server specific llog handling
Date: Fri, 5 Sep 2014 15:08:15 -0500
Message-ID: <1409947698-30781-10-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409947698-30781-1-git-send-email-john.hammond@intel.com>
References: <1409947698-30781-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.106]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

In mgc_process_cfg_log() remove code to handle
LLOG_CONFIG_ORIG_CTXT. This context is not setup on clients.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 drivers/staging/lustre/lustre/mgc/mgc_request.c |   84 ++---------------------
 1 file changed, 4 insertions(+), 80 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index cb0e6f9..bc263ad 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -1461,54 +1461,11 @@ out:
 	return rc;
 }
 
-static int mgc_llog_local_copy(const struct lu_env *env,
-			       struct obd_device *obd,
-			       struct llog_ctxt *rctxt,
-			       struct llog_ctxt *lctxt, char *logname)
-{
-	char	*temp_log;
-	int	 rc;
-
-
-
-	/*
-	 * - copy it to backup using llog_backup()
-	 * - copy remote llog to logname using llog_backup()
-	 * - if failed then move backup to logname again
-	 */
-
-	OBD_ALLOC(temp_log, strlen(logname) + 1);
-	if (!temp_log)
-		return -ENOMEM;
-	sprintf(temp_log, "%sT", logname);
-
-	/* make a copy of local llog at first */
-	rc = llog_backup(env, obd, lctxt, lctxt, logname, temp_log);
-	if (rc < 0 && rc != -ENOENT)
-		goto out;
-	/* copy remote llog to the local copy */
-	rc = llog_backup(env, obd, rctxt, lctxt, logname, logname);
-	if (rc == -ENOENT) {
-		/* no remote llog, delete local one too */
-		llog_erase(env, lctxt, NULL, logname);
-	} else if (rc < 0) {
-		/* error during backup, get local one back from the copy */
-		llog_backup(env, obd, lctxt, lctxt, temp_log, logname);
-out:
-		CERROR("%s: failed to copy remote log %s: rc = %d\n",
-		       obd->obd_name, logname, rc);
-	}
-	llog_erase(env, lctxt, NULL, temp_log);
-	OBD_FREE(temp_log, strlen(logname) + 1);
-	return rc;
-}
-
 /* local_only means it cannot get remote llogs */
 static int mgc_process_cfg_log(struct obd_device *mgc,
 			       struct config_llog_data *cld, int local_only)
 {
-	struct llog_ctxt	*ctxt, *lctxt = NULL;
-	struct dt_object        *cl_mgc_dir = mgc->u.cli.cl_mgc_configs_dir;
+	struct llog_ctxt	*ctxt;
 	struct lustre_sb_info	*lsi = NULL;
 	int			 rc = 0;
 	bool			 sptlrpc_started = false;
@@ -1538,40 +1495,9 @@ static int mgc_process_cfg_log(struct obd_device *mgc,
 	ctxt = llog_get_context(mgc, LLOG_CONFIG_REPL_CTXT);
 	LASSERT(ctxt);
 
-	lctxt = llog_get_context(mgc, LLOG_CONFIG_ORIG_CTXT);
-
-	/* Copy the setup log locally if we can. Don't mess around if we're
-	 * running an MGS though (logs are already local). */
-	if (lctxt && lsi && IS_SERVER(lsi) && !IS_MGS(lsi) &&
-	    cl_mgc_dir != NULL &&
-	    lu2dt_dev(cl_mgc_dir->do_lu.lo_dev) == lsi->lsi_dt_dev) {
-		if (!local_only)
-			/* Only try to copy log if we have the lock. */
-			rc = mgc_llog_local_copy(env, mgc, ctxt, lctxt,
-						 cld->cld_logname);
-		if (local_only || rc) {
-			if (llog_is_empty(env, lctxt, cld->cld_logname)) {
-				LCONSOLE_ERROR_MSG(0x13a,
-						   "Failed to get MGS log %s and no local copy.\n",
-						   cld->cld_logname);
-				rc = -ENOENT;
-				goto out_pop;
-			}
-			CDEBUG(D_MGC,
-			       "Failed to get MGS log %s, using local copy for now, will try to update later.\n",
-			       cld->cld_logname);
-		}
-		/* Now, whether we copied or not, start using the local llog.
-		 * If we failed to copy, we'll start using whatever the old
-		 * log has. */
-		llog_ctxt_put(ctxt);
-		ctxt = lctxt;
-		lctxt = NULL;
-	} else {
-		if (local_only) /* no local log at client side */ {
-			rc = -EIO;
-			goto out_pop;
-		}
+	if (local_only) /* no local log at client side */ {
+		rc = -EIO;
+		goto out_pop;
 	}
 
 	if (cld_is_sptlrpc(cld)) {
@@ -1587,8 +1513,6 @@ static int mgc_process_cfg_log(struct obd_device *mgc,
 
 out_pop:
 	__llog_ctxt_put(env, ctxt);
-	if (lctxt)
-		__llog_ctxt_put(env, lctxt);
 
 	/*
 	 * update settings on existing OBDs. doing it inside
-- 
1.7.9.5

