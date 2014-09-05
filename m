Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaIEUJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:09:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:63519 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbaIEUJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:09:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,474,1406617200"; 
   d="scan'208";a="475552705"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 03/12] staging/lustre/osc: remove obsolete llog handling code
Date: Fri, 5 Sep 2014 15:08:09 -0500
Message-ID: <1409947698-30781-4-git-send-email-john.hammond@intel.com>
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

In osc_request.c there is no reason to handle any llog contexts since
they are never setup. Remove the functions unused function
osc_llog_init() and the obsolete function osc_llog_finish(). Remove
the llog cleanup code in osc_disconnect() and osc_precleanup().

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 drivers/staging/lustre/lustre/osc/osc_request.c |   47 +----------------------
 1 file changed, 1 insertion(+), 46 deletions(-)

diff --git a/drivers/staging/lustre/lustre/osc/osc_request.c b/drivers/staging/lustre/lustre/osc/osc_request.c
index 86e9e97..ecca3eb 100644
--- a/drivers/staging/lustre/lustre/osc/osc_request.c
+++ b/drivers/staging/lustre/lustre/osc/osc_request.c
@@ -47,10 +47,10 @@
 
 #include "../include/lustre_ha.h"
 #include "../include/lprocfs_status.h"
-#include "../include/lustre_log.h"
 #include "../include/lustre_debug.h"
 #include "../include/lustre_param.h"
 #include "../include/lustre_fid.h"
+#include "../include/obd_class.h"
 #include "osc_internal.h"
 #include "osc_cl_internal.h"
 
@@ -2961,32 +2961,6 @@ static int osc_set_info_async(const struct lu_env *env, struct obd_export *exp,
 	return 0;
 }
 
-
-static int osc_llog_init(struct obd_device *obd, struct obd_llog_group *olg,
-			 struct obd_device *disk_obd, int *index)
-{
-	/* this code is not supposed to be used with LOD/OSP
-	 * to be removed soon */
-	LBUG();
-	return 0;
-}
-
-static int osc_llog_finish(struct obd_device *obd, int count)
-{
-	struct llog_ctxt *ctxt;
-
-	ctxt = llog_get_context(obd, LLOG_MDS_OST_ORIG_CTXT);
-	if (ctxt) {
-		llog_cat_close(NULL, ctxt->loc_handle);
-		llog_cleanup(NULL, ctxt);
-	}
-
-	ctxt = llog_get_context(obd, LLOG_SIZE_REPL_CTXT);
-	if (ctxt)
-		llog_cleanup(NULL, ctxt);
-	return 0;
-}
-
 static int osc_reconnect(const struct lu_env *env,
 			 struct obd_export *exp, struct obd_device *obd,
 			 struct obd_uuid *cluuid,
@@ -3016,22 +2990,8 @@ static int osc_reconnect(const struct lu_env *env,
 static int osc_disconnect(struct obd_export *exp)
 {
 	struct obd_device *obd = class_exp2obd(exp);
-	struct llog_ctxt  *ctxt;
 	int rc;
 
-	ctxt = llog_get_context(obd, LLOG_SIZE_REPL_CTXT);
-	if (ctxt) {
-		if (obd->u.cli.cl_conn_count == 1) {
-			/* Flush any remaining cancel messages out to the
-			 * target */
-			llog_sync(ctxt, exp, 0);
-		}
-		llog_ctxt_put(ctxt);
-	} else {
-		CDEBUG(D_HA, "No LLOG_SIZE_REPL_CTXT found in obd %p\n",
-		       obd);
-	}
-
 	rc = client_disconnect_export(exp);
 	/**
 	 * Initially we put del_shrink_grant before disconnect_export, but it
@@ -3254,9 +3214,6 @@ static int osc_precleanup(struct obd_device *obd, enum obd_cleanup_stage stage)
 		obd_cleanup_client_import(obd);
 		ptlrpc_lprocfs_unregister_obd(obd);
 		lprocfs_obd_cleanup(obd);
-		rc = obd_llog_finish(obd, 0);
-		if (rc != 0)
-			CERROR("failed to cleanup llogging subsystems\n");
 		break;
 		}
 	}
@@ -3337,8 +3294,6 @@ struct obd_ops osc_obd_ops = {
 	.o_get_info	     = osc_get_info,
 	.o_set_info_async       = osc_set_info_async,
 	.o_import_event	 = osc_import_event,
-	.o_llog_init	    = osc_llog_init,
-	.o_llog_finish	  = osc_llog_finish,
 	.o_process_config       = osc_process_config,
 	.o_quotactl	     = osc_quotactl,
 	.o_quotacheck	   = osc_quotacheck,
-- 
1.7.9.5

