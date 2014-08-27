Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935968AbaH0VFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:05:14 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:32241
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935822AbaH0VFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:05:11 -0400
X-IronPort-AV: E=Sophos;i="5.04,413,1406584800"; 
   d="scan'208";a="76873674"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] staging: lustre: lmv: expand the GOTO macro
Date: Wed, 27 Aug 2014 23:01:34 +0200
Message-Id: <1409173294-7664-1-git-send-email-Julia.Lawall@lip6.fr>
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
This should be applied after the return-parenthesis patch.

 drivers/staging/lustre/lustre/lmv/lmv_intent.c |   14 ++-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c    |   88 +++++++++++++++----------
 2 files changed, 65 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lmv/lmv_intent.c b/drivers/staging/lustre/lustre/lmv/lmv_intent.c
index aba698f..de7f96a 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_intent.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_intent.c
@@ -94,12 +94,16 @@ static int lmv_intent_remote(struct obd_export *exp, void *lmm,
 	LASSERT(fid_is_sane(&body->fid1));
 
 	tgt = lmv_find_target(lmv, &body->fid1);
-	if (IS_ERR(tgt))
-		GOTO(out, rc = PTR_ERR(tgt));
+	if (IS_ERR(tgt)) {
+		rc = PTR_ERR(tgt);
+		goto out;
+	}
 
 	OBD_ALLOC_PTR(op_data);
-	if (op_data == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (op_data == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	op_data->op_fid1 = body->fid1;
 	/* Sent the parent FID to the remote MDT */
@@ -121,7 +125,7 @@ static int lmv_intent_remote(struct obd_export *exp, void *lmm,
 	rc = md_intent_lock(tgt->ltd_exp, op_data, lmm, lmmsize, it,
 			    flags, &req, cb_blocking, extra_lock_flags);
 	if (rc)
-		GOTO(out_free_op_data, rc);
+		goto out_free_op_data;
 
 	/*
 	 * LLite needs LOOKUP lock to track dentry revocation in order to
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index a48818a..196e12a 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -97,12 +97,16 @@ static int lmv_set_mdc_active(struct lmv_obd *lmv, struct obd_uuid *uuid,
 			break;
 	}
 
-	if (i == lmv->desc.ld_tgt_count)
-		GOTO(out_lmv_lock, rc = -EINVAL);
+	if (i == lmv->desc.ld_tgt_count) {
+		rc = -EINVAL;
+		goto out_lmv_lock;
+	}
 
 	obd = class_exp2obd(tgt->ltd_exp);
-	if (obd == NULL)
-		GOTO(out_lmv_lock, rc = -ENOTCONN);
+	if (obd == NULL) {
+		rc = -ENOTCONN;
+		goto out_lmv_lock;
+	}
 
 	CDEBUG(D_INFO, "Found OBD %s=%s device %d (%p) type %s at LMV idx %d\n",
 	       obd->obd_name, obd->obd_uuid.uuid, obd->obd_minor, obd,
@@ -112,7 +116,7 @@ static int lmv_set_mdc_active(struct lmv_obd *lmv, struct obd_uuid *uuid,
 	if (tgt->ltd_active == activate) {
 		CDEBUG(D_INFO, "OBD %p already %sactive!\n", obd,
 		       activate ? "" : "in");
-		GOTO(out_lmv_lock, rc);
+		goto out_lmv_lock;
 	}
 
 	CDEBUG(D_INFO, "Marking OBD %p %sactive\n", obd,
@@ -574,7 +578,7 @@ int lmv_check_connect(struct obd_device *obd)
 			continue;
 		rc = lmv_connect_mdc(obd, tgt);
 		if (rc)
-			GOTO(out_disc, rc);
+			goto out_disc;
 	}
 
 	lmv_set_timeouts(obd);
@@ -712,7 +716,7 @@ static int lmv_fid2path(struct obd_export *exp, int len, void *karg, void *uarg)
 repeat_fid2path:
 	rc = obd_iocontrol(OBD_IOC_FID2PATH, tgt->ltd_exp, len, gf, uarg);
 	if (rc != 0 && rc != -EREMOTE)
-		GOTO(out_fid2path, rc);
+		goto out_fid2path;
 
 	/* If remote_gf != NULL, it means just building the
 	 * path on the remote MDT, copy this path segment to gf */
@@ -722,8 +726,10 @@ repeat_fid2path:
 
 		ori_gf = (struct getinfo_fid2path *)karg;
 		if (strlen(ori_gf->gf_path) +
-		    strlen(gf->gf_path) > ori_gf->gf_pathlen)
-			GOTO(out_fid2path, rc = -EOVERFLOW);
+		    strlen(gf->gf_path) > ori_gf->gf_pathlen) {
+			rc = -EOVERFLOW;
+			goto out_fid2path;
+		}
 
 		ptr = ori_gf->gf_path;
 
@@ -741,14 +747,16 @@ repeat_fid2path:
 	       gf->gf_linkno);
 
 	if (rc == 0)
-		GOTO(out_fid2path, rc);
+		goto out_fid2path;
 
 	/* sigh, has to go to another MDT to do path building further */
 	if (remote_gf == NULL) {
 		remote_gf_size = sizeof(*remote_gf) + PATH_MAX;
 		OBD_ALLOC(remote_gf, remote_gf_size);
-		if (remote_gf == NULL)
-			GOTO(out_fid2path, rc = -ENOMEM);
+		if (remote_gf == NULL) {
+			rc = -ENOMEM;
+			goto out_fid2path;
+		}
 		remote_gf->gf_pathlen = PATH_MAX;
 	}
 
@@ -756,12 +764,15 @@ repeat_fid2path:
 		CERROR("%s: invalid FID "DFID": rc = %d\n",
 		       tgt->ltd_exp->exp_obd->obd_name,
 		       PFID(&gf->gf_fid), -EINVAL);
-		GOTO(out_fid2path, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out_fid2path;
 	}
 
 	tgt = lmv_find_target(lmv, &gf->gf_fid);
-	if (IS_ERR(tgt))
-		GOTO(out_fid2path, rc = -EINVAL);
+	if (IS_ERR(tgt)) {
+		rc = -EINVAL;
+		goto out_fid2path;
+	}
 
 	remote_gf->gf_fid = gf->gf_fid;
 	remote_gf->gf_recno = -1;
@@ -1255,8 +1266,10 @@ int __lmv_fid_alloc(struct lmv_obd *lmv, struct lu_fid *fid, u32 mds)
 	 */
 	mutex_lock(&tgt->ltd_fid_mutex);
 
-	if (tgt->ltd_active == 0 || tgt->ltd_exp == NULL)
-		GOTO(out, rc = -ENODEV);
+	if (tgt->ltd_active == 0 || tgt->ltd_exp == NULL) {
+		rc = -ENODEV;
+		goto out;
+	}
 
 	/*
 	 * Asking underlaying tgt layer to allocate new fid.
@@ -1350,7 +1363,7 @@ static int lmv_setup(struct obd_device *obd, struct lustre_cfg *lcfg)
 			     LUSTRE_CLI_FLD_HASH_DHT);
 	if (rc) {
 		CERROR("Can't init FLD, err %d\n", rc);
-		GOTO(out, rc);
+		goto out;
 	}
 
 	return 0;
@@ -1389,20 +1402,27 @@ static int lmv_process_config(struct obd_device *obd, u32 len, void *buf)
 	case LCFG_ADD_MDC:
 		/* modify_mdc_tgts add 0:lustre-clilmv  1:lustre-MDT0000_UUID
 		 * 2:0  3:1  4:lustre-MDT0000-mdc_UUID */
-		if (LUSTRE_CFG_BUFLEN(lcfg, 1) > sizeof(obd_uuid.uuid))
-			GOTO(out, rc = -EINVAL);
+		if (LUSTRE_CFG_BUFLEN(lcfg, 1) > sizeof(obd_uuid.uuid)) {
+			rc = -EINVAL;
+			goto out;
+		}
 
 		obd_str2uuid(&obd_uuid,  lustre_cfg_buf(lcfg, 1));
 
-		if (sscanf(lustre_cfg_buf(lcfg, 2), "%d", &index) != 1)
-			GOTO(out, rc = -EINVAL);
-		if (sscanf(lustre_cfg_buf(lcfg, 3), "%d", &gen) != 1)
-			GOTO(out, rc = -EINVAL);
+		if (sscanf(lustre_cfg_buf(lcfg, 2), "%d", &index) != 1) {
+			rc = -EINVAL;
+			goto out;
+		}
+		if (sscanf(lustre_cfg_buf(lcfg, 3), "%d", &gen) != 1) {
+			rc = -EINVAL;
+			goto out;
+		}
 		rc = lmv_add_target(obd, &obd_uuid, index, gen);
-		GOTO(out, rc);
+		goto out;
 	default:
 		CERROR("Unknown command: %d\n", lcfg->lcfg_command);
-		GOTO(out, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out;
 	}
 out:
 	return rc;
@@ -1435,7 +1455,7 @@ static int lmv_statfs(const struct lu_env *env, struct obd_export *exp,
 			CERROR("can't stat MDS #%d (%s), error %d\n", i,
 			       lmv->tgts[i]->ltd_exp->exp_obd->obd_name,
 			       rc);
-			GOTO(out_free_temp, rc);
+			goto out_free_temp;
 		}
 
 		if (i == 0) {
@@ -1447,7 +1467,7 @@ static int lmv_statfs(const struct lu_env *env, struct obd_export *exp,
 			 * And also clients can be mounted as long as
 			 * MDT0 is in service*/
 			if (flags & OBD_STATFS_FOR_MDT0)
-				GOTO(out_free_temp, rc);
+				goto out_free_temp;
 		} else {
 			osfs->os_bavail += temp->os_bavail;
 			osfs->os_blocks += temp->os_blocks;
@@ -1748,12 +1768,16 @@ lmv_enqueue_remote(struct obd_export *exp, struct ldlm_enqueue_info *einfo,
 	ptlrpc_req_finished(req);
 
 	tgt = lmv_find_target(lmv, &fid1);
-	if (IS_ERR(tgt))
-		GOTO(out, rc = PTR_ERR(tgt));
+	if (IS_ERR(tgt)) {
+		rc = PTR_ERR(tgt);
+		goto out;
+	}
 
 	OBD_ALLOC_PTR(rdata);
-	if (rdata == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (rdata == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	rdata->op_fid1 = fid1;
 	rdata->op_bias = MDS_CROSS_REF;

