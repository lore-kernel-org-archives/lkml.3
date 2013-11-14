Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab3KNQRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:17:45 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:45534 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab3KNQQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:16:36 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Mikhail Pershin <mike.pershin@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 33/40] staging/lustre/target: move OUT to the unified target code
Date: Fri, 15 Nov 2013 00:13:35 +0800
Message-Id: <1384445622-12346-34-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikhail Pershin <mike.pershin@intel.com>

- Move OUT handler to the unified target code, so it can be
  used by both MDS and OST.
- Make OFD able to handle OUT requests.
- Rename MDS_MDS_PORTAL to the OUT_PORTAL and MDS_OUT_... defines
  just OUT_... since they are independent from MDS now.

Lustre-change: http://review.whamcloud.com/6763
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3467
Signed-off-by: Mikhail Pershin <mike.pershin@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
[pick client side of change. target is mostly server side code -- PengTao]
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      |    3 +-
 drivers/staging/lustre/lustre/include/lustre_net.h |    8 ++---
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |   32 +-------------------
 .../staging/lustre/lustre/obdecho/echo_client.c    |    2 +-
 4 files changed, 7 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index bc4eaf2..5505cc5 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -131,8 +131,7 @@
 //#define PTLBD_BULK_PORTAL	      21
 #define MDS_SETATTR_PORTAL	     22
 #define MDS_READPAGE_PORTAL	    23
-#define MDS_MDS_PORTAL		 24
-
+#define OUT_PORTAL			24
 #define MGC_REPLY_PORTAL	       25
 #define MGS_REQUEST_PORTAL	     26
 #define MGS_REPLY_PORTAL	       27
diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index 6c5479b..80227e9 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -370,8 +370,8 @@
  * include linkea (4K maxim), together with other updates, we set it to 9K:
  * lustre_msg + ptlrpc_body + UPDATE_BUF_SIZE (8K)
  */
-#define MDS_OUT_MAXREQSIZE	(9 * 1024)
-#define MDS_OUT_MAXREPSIZE	MDS_MAXREPSIZE
+#define OUT_MAXREQSIZE	(9 * 1024)
+#define OUT_MAXREPSIZE	MDS_MAXREPSIZE
 
 /** MDS_BUFSIZE = max_reqsize (w/o LOV EA) + max sptlrpc payload size */
 #define MDS_BUFSIZE		max(MDS_MAXREQSIZE + SPTLRPC_MAX_PAYLOAD, \
@@ -397,11 +397,11 @@
 				    160 * 1024)
 
 /**
- * MDS_OUT_BUFSIZE = max_out_reqsize + max sptlrpc payload (~1K) which is
+ * OUT_BUFSIZE = max_out_reqsize + max sptlrpc payload (~1K) which is
  * about 10K, for the same reason as MDS_REG_BUFSIZE, we also give some
  * extra bytes to each request buffer to improve buffer utilization rate.
   */
-#define MDS_OUT_BUFSIZE		max(MDS_OUT_MAXREQSIZE + SPTLRPC_MAX_PAYLOAD, \
+#define OUT_BUFSIZE		max(OUT_MAXREQSIZE + SPTLRPC_MAX_PAYLOAD, \
 				    24 * 1024)
 
 /** FLD_MAXREQSIZE == lustre_msg + __u32 padding + ptlrpc_body + opc */
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index c6e4fb2..e418b58 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -2098,15 +2098,6 @@ int mdc_set_info_async(const struct lu_env *env,
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
@@ -2616,27 +2607,6 @@ static int mdc_renew_capa(struct obd_export *exp, struct obd_capa *oc,
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
@@ -2644,7 +2614,7 @@ struct obd_ops mdc_obd_ops = {
 	.o_cleanup	  = mdc_cleanup,
 	.o_add_conn	 = client_import_add_conn,
 	.o_del_conn	 = client_import_del_conn,
-	.o_connect	  = mdc_connect,
+	.o_connect          = client_connect_import,
 	.o_disconnect       = client_disconnect_export,
 	.o_iocontrol	= mdc_iocontrol,
 	.o_set_info_async   = mdc_set_info_async,
diff --git a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
index 1fb0ac4..d7a3395 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -2758,7 +2758,7 @@ echo_client_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 	if (env == NULL)
 		return -ENOMEM;
 
-	rc = lu_env_init(env, LCT_DT_THREAD);
+	rc = lu_env_init(env, LCT_DT_THREAD | LCT_MD_THREAD);
 	if (rc)
 		GOTO(out, rc = -ENOMEM);
 
-- 
1.7.9.5

