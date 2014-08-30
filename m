Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaH3OpI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 10:45:08 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:18707 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565AbaH3OpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 10:45:05 -0400
X-IronPort-AV: E=Sophos;i="5.04,431,1406584800"; 
   d="scan'208";a="92247408"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] staging: lustre: fid,fld: expand the GOTO macro
Date: Sat, 30 Aug 2014 16:41:23 +0200
Message-Id: <1409409683-5288-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier lbl;
identifier rc;
constant c;
@@

- GOTO(lbl,\(rc\|c\));
+ goto lbl;

@@
identifier lbl;
expression rc;
@@

- GOTO(lbl,rc);
+ rc;
+ goto lbl;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/lustre/lustre/fid/fid_request.c |   18 +++++++++++-------
 drivers/staging/lustre/lustre/fld/fld_request.c |   14 ++++++++------
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/lustre/lustre/fid/fid_request.c b/drivers/staging/lustre/lustre/fid/fid_request.c
index 46c11ca..64b1d80 100644
--- a/drivers/staging/lustre/lustre/fid/fid_request.c
+++ b/drivers/staging/lustre/lustre/fid/fid_request.c
@@ -113,7 +113,7 @@ static int seq_client_rpc(struct lu_client_seq *seq,
 	if (seq->lcs_type == LUSTRE_SEQ_METADATA)
 		mdc_put_rpc_lock(exp->exp_obd->u.cli.cl_rpc_lock, NULL);
 	if (rc)
-		GOTO(out_req, rc);
+		goto out_req;
 
 	out = req_capsule_server_get(&req->rq_pill, &RMF_SEQ_RANGE);
 	*output = *out;
@@ -121,13 +121,15 @@ static int seq_client_rpc(struct lu_client_seq *seq,
 	if (!range_is_sane(output)) {
 		CERROR("%s: Invalid range received from server: "
 		       DRANGE"\n", seq->lcs_name, PRANGE(output));
-		GOTO(out_req, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out_req;
 	}
 
 	if (range_is_exhausted(output)) {
 		CERROR("%s: Range received from server is exhausted: "
 		       DRANGE"]\n", seq->lcs_name, PRANGE(output));
-		GOTO(out_req, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out_req;
 	}
 
 	CDEBUG_LIMIT(debug_mask, "%s: Allocated %s-sequence "DRANGE"]\n",
@@ -430,7 +432,7 @@ static int seq_client_proc_init(struct lu_client_seq *seq)
 	if (rc) {
 		CERROR("%s: Can't init sequence manager proc, rc %d\n",
 		       seq->lcs_name, rc);
-		GOTO(out_cleanup, rc);
+		goto out_cleanup;
 	}
 
 	return 0;
@@ -508,8 +510,10 @@ int client_fid_init(struct obd_device *obd,
 		return -ENOMEM;
 
 	OBD_ALLOC(prefix, MAX_OBD_NAME + 5);
-	if (prefix == NULL)
-		GOTO(out_free_seq, rc = -ENOMEM);
+	if (prefix == NULL) {
+		rc = -ENOMEM;
+		goto out_free_seq;
+	}
 
 	snprintf(prefix, MAX_OBD_NAME + 5, "cli-%s", obd->obd_name);
 
@@ -517,7 +521,7 @@ int client_fid_init(struct obd_device *obd,
 	rc = seq_client_init(cli->cl_seq, exp, type, prefix, NULL);
 	OBD_FREE(prefix, MAX_OBD_NAME + 5);
 	if (rc)
-		GOTO(out_free_seq, rc);
+		goto out_free_seq;
 
 	return rc;
 out_free_seq:
diff --git a/drivers/staging/lustre/lustre/fld/fld_request.c b/drivers/staging/lustre/lustre/fld/fld_request.c
index 4539a02..f63c669 100644
--- a/drivers/staging/lustre/lustre/fld/fld_request.c
+++ b/drivers/staging/lustre/lustre/fld/fld_request.c
@@ -293,7 +293,7 @@ static int fld_client_proc_init(struct lu_client_fld *fld)
 	if (rc) {
 		CERROR("%s: Can't init FLD proc, rc %d\n",
 		       fld->lcf_name, rc);
-		GOTO(out_cleanup, rc);
+		goto out_cleanup;
 	}
 
 	return 0;
@@ -363,12 +363,12 @@ int fld_client_init(struct lu_client_fld *fld,
 	if (IS_ERR(fld->lcf_cache)) {
 		rc = PTR_ERR(fld->lcf_cache);
 		fld->lcf_cache = NULL;
-		GOTO(out, rc);
+		goto out;
 	}
 
 	rc = fld_client_proc_init(fld);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 out:
 	if (rc)
 		fld_client_fini(fld);
@@ -441,11 +441,13 @@ int fld_client_rpc(struct obd_export *exp,
 	if (fld_op != FLD_LOOKUP)
 		mdc_put_rpc_lock(exp->exp_obd->u.cli.cl_rpc_lock, NULL);
 	if (rc)
-		GOTO(out_req, rc);
+		goto out_req;
 
 	prange = req_capsule_server_get(&req->rq_pill, &RMF_FLD_MDFLD);
-	if (prange == NULL)
-		GOTO(out_req, rc = -EFAULT);
+	if (prange == NULL) {
+		rc = -EFAULT;
+		goto out_req;
+	}
 	*range = *prange;
 out_req:
 	ptlrpc_req_finished(req);

