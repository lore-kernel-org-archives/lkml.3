Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaIEUMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:12:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:23946 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbaIEUJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:09:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,474,1406617200"; 
   d="scan'208";a="598712649"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 06/12] staging/lustre/mdc: inline llog methods
Date: Fri, 5 Sep 2014 15:08:12 -0500
Message-ID: <1409947698-30781-7-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409947698-30781-1-git-send-email-john.hammond@intel.com>
References: <1409947698-30781-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.107]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

In mdc_setup() and mdc_precleanup() call mdc_llog_init() and
mdc_llog_finish() directly rather than through the OBD method wrappers
obd_llog_init() and obd_llod_finish(). Simplify the prototypes of
mdc_llog_init() and mdc_llog_finish() according to their uses.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_request.c |   67 ++++++++++-------------
 1 file changed, 29 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index bc219d1..780cb00 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -2394,6 +2394,33 @@ struct ldlm_valblock_ops inode_lvbo = {
 	.lvbo_free = mdc_resource_inode_free,
 };
 
+static int mdc_llog_init(struct obd_device *obd)
+{
+	struct obd_llog_group	*olg = &obd->obd_olg;
+	struct llog_ctxt	*ctxt;
+	int			 rc;
+
+	rc = llog_setup(NULL, obd, olg, LLOG_CHANGELOG_REPL_CTXT, obd,
+			&llog_client_ops);
+	if (rc)
+		return rc;
+
+	ctxt = llog_group_get_ctxt(olg, LLOG_CHANGELOG_REPL_CTXT);
+	llog_initiator_connect(ctxt);
+	llog_ctxt_put(ctxt);
+
+	return 0;
+}
+
+static void mdc_llog_finish(struct obd_device *obd)
+{
+	struct llog_ctxt *ctxt;
+
+	ctxt = llog_get_context(obd, LLOG_CHANGELOG_REPL_CTXT);
+	if (ctxt)
+		llog_cleanup(NULL, ctxt);
+}
+
 static int mdc_setup(struct obd_device *obd, struct lustre_cfg *cfg)
 {
 	struct client_obd *cli = &obd->u.cli;
@@ -2426,7 +2453,7 @@ static int mdc_setup(struct obd_device *obd, struct lustre_cfg *cfg)
 
 	obd->obd_namespace->ns_lvbo = &inode_lvbo;
 
-	rc = obd_llog_init(obd, &obd->obd_olg, obd, NULL);
+	rc = mdc_llog_init(obd);
 	if (rc) {
 		mdc_cleanup(obd);
 		CERROR("failed to setup llogging subsystems\n");
@@ -2487,9 +2514,7 @@ static int mdc_precleanup(struct obd_device *obd, enum obd_cleanup_stage stage)
 		ptlrpc_lprocfs_unregister_obd(obd);
 		lprocfs_obd_cleanup(obd);
 
-		rc = obd_llog_finish(obd, 0);
-		if (rc != 0)
-			CERROR("failed to cleanup llogging subsystems\n");
+		mdc_llog_finish(obd);
 		break;
 	}
 	return rc;
@@ -2507,38 +2532,6 @@ static int mdc_cleanup(struct obd_device *obd)
 	return client_obd_cleanup(obd);
 }
 
-
-static int mdc_llog_init(struct obd_device *obd, struct obd_llog_group *olg,
-			 struct obd_device *tgt, int *index)
-{
-	struct llog_ctxt	*ctxt;
-	int			 rc;
-
-	LASSERT(olg == &obd->obd_olg);
-
-	rc = llog_setup(NULL, obd, olg, LLOG_CHANGELOG_REPL_CTXT, tgt,
-			&llog_client_ops);
-	if (rc)
-		return rc;
-
-	ctxt = llog_group_get_ctxt(olg, LLOG_CHANGELOG_REPL_CTXT);
-	llog_initiator_connect(ctxt);
-	llog_ctxt_put(ctxt);
-
-	return 0;
-}
-
-static int mdc_llog_finish(struct obd_device *obd, int count)
-{
-	struct llog_ctxt *ctxt;
-
-	ctxt = llog_get_context(obd, LLOG_CHANGELOG_REPL_CTXT);
-	if (ctxt)
-		llog_cleanup(NULL, ctxt);
-
-	return 0;
-}
-
 static int mdc_process_config(struct obd_device *obd, u32 len, void *buf)
 {
 	struct lustre_cfg *lcfg = buf;
@@ -2672,8 +2665,6 @@ struct obd_ops mdc_obd_ops = {
 	.o_fid_fini	    = client_fid_fini,
 	.o_fid_alloc	= mdc_fid_alloc,
 	.o_import_event     = mdc_import_event,
-	.o_llog_init	= mdc_llog_init,
-	.o_llog_finish      = mdc_llog_finish,
 	.o_get_info	 = mdc_get_info,
 	.o_process_config   = mdc_process_config,
 	.o_get_uuid	 = mdc_get_uuid,
-- 
1.7.9.5

