Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933791Ab3LIPAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:00:10 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37359 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933765Ab3LIPAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:00:05 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Mikhail Pershin <mike.pershin@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 04/13] staging/lustre/target: move OUT to the unified target code
Date: Mon,  9 Dec 2013 22:56:56 +0800
Message-Id: <1386601025-422-5-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
References: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikhail Pershin <mike.pershin@intel.com>

- Move OUT handler to the unified target code, so it can be
  used by both MDS and OST.

Lustre-change: http://review.whamcloud.com/6763
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3467
Signed-off-by: Mikhail Pershin <mike.pershin@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
[pick client side of change. target is mostly server side code -- PengTao]
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_request.c |   32 +----------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 0b43251..d1ad91c3 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -2076,15 +2076,6 @@ int mdc_set_info_async(const struct lu_env *env,
 		sptlrpc_import_flush_my_ctx(imp);
 		return 0;
 	}
-	if (KEY_IS(KEY_MDS_CONN)) {
-		/* mds-mds import */
-		spin_lock(&imp->imp_lock);
-		imp->imp_server_timeout = 1;
-		spin_unlock(&imp->imp_lock);
-		imp->imp_client->cli_request_portal = MDS_MDS_PORTAL;
-		CDEBUG(D_OTHER, "%s: timeout / 2\n", exp->exp_obd->obd_name);
-		return 0;
-	}
 	if (KEY_IS(KEY_CHANGELOG_CLEAR)) {
 		rc = do_set_info_async(imp, MDS_SET_INFO, LUSTRE_MDS_VERSION,
 				       keylen, key, vallen, val, set);
@@ -2594,27 +2585,6 @@ static int mdc_renew_capa(struct obd_export *exp, struct obd_capa *oc,
 	return 0;
 }
 
-static int mdc_connect(const struct lu_env *env,
-		       struct obd_export **exp,
-		       struct obd_device *obd, struct obd_uuid *cluuid,
-		       struct obd_connect_data *data,
-		       void *localdata)
-{
-	struct obd_import *imp = obd->u.cli.cl_import;
-
-	/* mds-mds import features */
-	if (data && (data->ocd_connect_flags & OBD_CONNECT_MDS_MDS)) {
-		spin_lock(&imp->imp_lock);
-		imp->imp_server_timeout = 1;
-		spin_unlock(&imp->imp_lock);
-		imp->imp_client->cli_request_portal = MDS_MDS_PORTAL;
-		CDEBUG(D_OTHER, "%s: Set 'mds' portal and timeout\n",
-		       obd->obd_name);
-	}
-
-	return client_connect_import(env, exp, obd, cluuid, data, NULL);
-}
-
 struct obd_ops mdc_obd_ops = {
 	.o_owner	    = THIS_MODULE,
 	.o_setup	    = mdc_setup,
@@ -2622,7 +2592,7 @@ struct obd_ops mdc_obd_ops = {
 	.o_cleanup	  = mdc_cleanup,
 	.o_add_conn	 = client_import_add_conn,
 	.o_del_conn	 = client_import_del_conn,
-	.o_connect	  = mdc_connect,
+	.o_connect          = client_connect_import,
 	.o_disconnect       = client_disconnect_export,
 	.o_iocontrol	= mdc_iocontrol,
 	.o_set_info_async   = mdc_set_info_async,
-- 
1.7.9.5

