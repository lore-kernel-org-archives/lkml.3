Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaIEUJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:09:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:23946 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaIEUJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:09:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,474,1406617200"; 
   d="scan'208";a="598712622"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 05/12] staging/lustre/mdc: remove unused OBD methods
Date: Fri, 5 Sep 2014 15:08:11 -0500
Message-ID: <1409947698-30781-6-git-send-email-john.hammond@intel.com>
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

Remove the unused OBD device methods mdc_pin() and mdc_unpin().

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_request.c |   90 -----------------------
 1 file changed, 90 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index e6e2515..bc219d1 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -2263,94 +2263,6 @@ int mdc_get_info(const struct lu_env *env, struct obd_export *exp,
 	return rc;
 }
 
-static int mdc_pin(struct obd_export *exp, const struct lu_fid *fid,
-		   struct obd_capa *oc, struct obd_client_handle *handle,
-		   int flags)
-{
-	struct ptlrpc_request *req;
-	struct mdt_body       *body;
-	int		    rc;
-
-	req = ptlrpc_request_alloc(class_exp2cliimp(exp), &RQF_MDS_PIN);
-	if (req == NULL)
-		return -ENOMEM;
-
-	mdc_set_capa_size(req, &RMF_CAPA1, oc);
-
-	rc = ptlrpc_request_pack(req, LUSTRE_MDS_VERSION, MDS_PIN);
-	if (rc) {
-		ptlrpc_request_free(req);
-		return rc;
-	}
-
-	mdc_pack_body(req, fid, oc, 0, 0, -1, flags);
-
-	ptlrpc_request_set_replen(req);
-
-	mdc_get_rpc_lock(exp->exp_obd->u.cli.cl_rpc_lock, NULL);
-	rc = ptlrpc_queue_wait(req);
-	mdc_put_rpc_lock(exp->exp_obd->u.cli.cl_rpc_lock, NULL);
-	if (rc) {
-		CERROR("Pin failed: %d\n", rc);
-		goto err_out;
-	}
-
-	body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
-	if (body == NULL) {
-		rc = -EPROTO;
-		goto err_out;
-	}
-
-	handle->och_fh = body->handle;
-	handle->och_magic = OBD_CLIENT_HANDLE_MAGIC;
-
-	handle->och_mod = obd_mod_alloc();
-	if (handle->och_mod == NULL) {
-		DEBUG_REQ(D_ERROR, req, "can't allocate md_open_data");
-		rc = -ENOMEM;
-		goto err_out;
-	}
-	handle->och_mod->mod_open_req = req; /* will be dropped by unpin */
-
-	return 0;
-
-err_out:
-	ptlrpc_req_finished(req);
-	return rc;
-}
-
-static int mdc_unpin(struct obd_export *exp, struct obd_client_handle *handle,
-		     int flag)
-{
-	struct ptlrpc_request *req;
-	struct mdt_body       *body;
-	int		    rc;
-
-	req = ptlrpc_request_alloc_pack(class_exp2cliimp(exp), &RQF_MDS_UNPIN,
-					LUSTRE_MDS_VERSION, MDS_UNPIN);
-	if (req == NULL)
-		return -ENOMEM;
-
-	body = req_capsule_client_get(&req->rq_pill, &RMF_MDT_BODY);
-	body->handle = handle->och_fh;
-	body->flags = flag;
-
-	ptlrpc_request_set_replen(req);
-
-	mdc_get_rpc_lock(exp->exp_obd->u.cli.cl_rpc_lock, NULL);
-	rc = ptlrpc_queue_wait(req);
-	mdc_put_rpc_lock(exp->exp_obd->u.cli.cl_rpc_lock, NULL);
-
-	if (rc != 0)
-		CERROR("Unpin failed: %d\n", rc);
-
-	ptlrpc_req_finished(req);
-	ptlrpc_req_finished(handle->och_mod->mod_open_req);
-
-	obd_mod_put(handle->och_mod);
-	return rc;
-}
-
 int mdc_sync(struct obd_export *exp, const struct lu_fid *fid,
 	     struct obd_capa *oc, struct ptlrpc_request **request)
 {
@@ -2756,8 +2668,6 @@ struct obd_ops mdc_obd_ops = {
 	.o_iocontrol	= mdc_iocontrol,
 	.o_set_info_async   = mdc_set_info_async,
 	.o_statfs	   = mdc_statfs,
-	.o_pin	      = mdc_pin,
-	.o_unpin	    = mdc_unpin,
 	.o_fid_init	    = client_fid_init,
 	.o_fid_fini	    = client_fid_fini,
 	.o_fid_alloc	= mdc_fid_alloc,
-- 
1.7.9.5

