Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbaIIBmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 21:42:03 -0400
Received: from linuxhacker.ru ([217.76.32.60]:35851 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbaIIBmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 21:42:00 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Hugues <morisset.hugues@gmail.com>,
        Mikhail Pershin <mike.pershin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 1/2] staging/lustre: use osc_reply_portal for OUT services
Date: Mon,  8 Sep 2014 21:41:27 -0400
Message-Id: <1410226888-20377-2-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410226888-20377-1-git-send-email-green@linuxhacker.ru>
References: <1410226888-20377-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikhail Pershin <mike.pershin@intel.com>

OUT service is used to server both MDS-MDS updates and MDS-OST
therefore services on MDT and OST are set to use the same request
and reply portals to be fully unified and able to serve any type
of requests.

Signed-off-by: Mikhail Pershin <mike.pershin@intel.com>
Reviewed-on: http://review.whamcloud.com/8390
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3467
Reviewed-by: wangdi <di.wang@intel.com>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/fld/fld_request.c    |  1 +
 .../lustre/lustre/include/lustre/lustre_idl.h      |  2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c      | 29 ++++++++++++++--------
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/lustre/lustre/fld/fld_request.c b/drivers/staging/lustre/lustre/fld/fld_request.c
index 02454db..0d361ff 100644
--- a/drivers/staging/lustre/lustre/fld/fld_request.c
+++ b/drivers/staging/lustre/lustre/fld/fld_request.c
@@ -426,6 +426,7 @@ int fld_client_rpc(struct obd_export *exp,
 
 	ptlrpc_request_set_replen(req);
 	req->rq_request_portal = FLD_REQUEST_PORTAL;
+	req->rq_reply_portal = MDC_REPLY_PORTAL;
 	ptlrpc_at_set_req_timeout(req);
 
 	if (fld_op == FLD_LOOKUP &&
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index e529ad4..7b7457c 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -128,7 +128,7 @@
 //#define PTLBD_BULK_PORTAL	      21
 #define MDS_SETATTR_PORTAL	     22
 #define MDS_READPAGE_PORTAL	    23
-#define MDS_MDS_PORTAL		 24
+#define OUT_PORTAL		    24
 
 #define MGC_REPLY_PORTAL	       25
 #define MGS_REQUEST_PORTAL	     26
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
index 9b3dac4..c21e30a 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
@@ -267,15 +267,10 @@ int client_obd_setup(struct obd_device *obddev, struct lustre_cfg *lcfg)
 	char *name = obddev->obd_type->typ_name;
 	ldlm_ns_type_t ns_type = LDLM_NS_TYPE_UNKNOWN;
 	int rc;
-	char	*cli_name = lustre_cfg_buf(lcfg, 0);
 
 	/* In a more perfect world, we would hang a ptlrpc_client off of
 	 * obd_type and just use the values from there. */
-	if (!strcmp(name, LUSTRE_OSC_NAME) ||
-	    (!(strcmp(name, LUSTRE_OSP_NAME)) &&
-	     (is_osp_on_mdt(cli_name) &&
-	       strstr(lustre_cfg_buf(lcfg, 1), "OST") != NULL))) {
-		/* OSC or OSP_on_MDT for OSTs */
+	if (!strcmp(name, LUSTRE_OSC_NAME)) {
 		rq_portal = OST_REQUEST_PORTAL;
 		rp_portal = OSC_REPLY_PORTAL;
 		connect_op = OST_CONNECT;
@@ -283,17 +278,29 @@ int client_obd_setup(struct obd_device *obddev, struct lustre_cfg *lcfg)
 		cli->cl_sp_to = LUSTRE_SP_OST;
 		ns_type = LDLM_NS_TYPE_OSC;
 	} else if (!strcmp(name, LUSTRE_MDC_NAME) ||
-		   !strcmp(name, LUSTRE_LWP_NAME) ||
-		   (!strcmp(name, LUSTRE_OSP_NAME) &&
-		    (is_osp_on_mdt(cli_name) &&
-		     strstr(lustre_cfg_buf(lcfg, 1), "OST") == NULL))) {
-		/* MDC or OSP_on_MDT for other MDTs */
+		   !strcmp(name, LUSTRE_LWP_NAME)) {
 		rq_portal = MDS_REQUEST_PORTAL;
 		rp_portal = MDC_REPLY_PORTAL;
 		connect_op = MDS_CONNECT;
 		cli->cl_sp_me = LUSTRE_SP_CLI;
 		cli->cl_sp_to = LUSTRE_SP_MDT;
 		ns_type = LDLM_NS_TYPE_MDC;
+	} else if (!strcmp(name, LUSTRE_OSP_NAME)) {
+		if (strstr(lustre_cfg_buf(lcfg, 1), "OST") == NULL) {
+			/* OSP_on_MDT for other MDTs */
+			connect_op = MDS_CONNECT;
+			cli->cl_sp_to = LUSTRE_SP_MDT;
+			ns_type = LDLM_NS_TYPE_MDC;
+			rq_portal = OUT_PORTAL;
+		} else {
+			/* OSP on MDT for OST */
+			connect_op = OST_CONNECT;
+			cli->cl_sp_to = LUSTRE_SP_OST;
+			ns_type = LDLM_NS_TYPE_OSC;
+			rq_portal = OST_REQUEST_PORTAL;
+		}
+		rp_portal = OSC_REPLY_PORTAL;
+		cli->cl_sp_me = LUSTRE_SP_CLI;
 	} else if (!strcmp(name, LUSTRE_MGC_NAME)) {
 		rq_portal = MGS_REQUEST_PORTAL;
 		rp_portal = MGC_REPLY_PORTAL;
-- 
1.9.3

