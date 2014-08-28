Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936519AbaH1KOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:14:14 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:24537 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932445AbaH1KOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:14:12 -0400
X-IronPort-AV: E=Sophos;i="5.04,417,1406584800"; 
   d="scan'208";a="91881357"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] staging: lustre: mdc: expand the GOTO macro
Date: Thu, 28 Aug 2014 12:10:35 +0200
Message-Id: <1409220635-13453-1-git-send-email-Julia.Lawall@lip6.fr>
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

 drivers/staging/lustre/lustre/mdc/mdc_locks.c   |    4 
 drivers/staging/lustre/lustre/mdc/mdc_request.c |  311 ++++++++++++++----------
 2 files changed, 196 insertions(+), 119 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 9c3e533..3c0f49e 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -1236,7 +1236,7 @@ static int mdc_intent_getattr_async_interpret(const struct lu_env *env,
 	if (rc < 0) {
 		CERROR("ldlm_cli_enqueue_fini: %d\n", rc);
 		mdc_clear_replay_flag(req, rc);
-		GOTO(out, rc);
+		goto out;
 	}
 
 	lockrep = req_capsule_server_get(&req->rq_pill, &RMF_DLM_REP);
@@ -1247,7 +1247,7 @@ static int mdc_intent_getattr_async_interpret(const struct lu_env *env,
 
 	rc = mdc_finish_enqueue(exp, req, einfo, it, lockh, rc);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	rc = mdc_finish_intent_lock(exp, req, &minfo->mi_data, it, lockh);
 
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index fce8567..a2a6334 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -122,16 +122,18 @@ static int send_getstatus(struct obd_import *imp, struct lu_fid *rootfid,
 
 	rc = ptlrpc_queue_wait(req);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
-	if (body == NULL)
-		GOTO(out, rc = -EPROTO);
+	if (body == NULL) {
+		rc = -EPROTO;
+		goto out;
+	}
 
 	if (body->valid & OBD_MD_FLMDSCAPA) {
 		rc = mdc_unpack_capa(NULL, req, &RMF_CAPA1, pc);
 		if (rc)
-			GOTO(out, rc);
+			goto out;
 	}
 
 	*rootfid = body->fid1;
@@ -519,28 +521,33 @@ int mdc_get_lustre_md(struct obd_export *exp, struct ptlrpc_request *req,
 		if (!S_ISREG(md->body->mode)) {
 			CDEBUG(D_INFO,
 			       "OBD_MD_FLEASIZE set, should be a regular file, but is not\n");
-			GOTO(out, rc = -EPROTO);
+			rc = -EPROTO;
+			goto out;
 		}
 
 		if (md->body->eadatasize == 0) {
 			CDEBUG(D_INFO,
 			       "OBD_MD_FLEASIZE set, but eadatasize 0\n");
-			GOTO(out, rc = -EPROTO);
+			rc = -EPROTO;
+			goto out;
 		}
 		lmmsize = md->body->eadatasize;
 		lmm = req_capsule_server_sized_get(pill, &RMF_MDT_MD, lmmsize);
-		if (!lmm)
-			GOTO(out, rc = -EPROTO);
+		if (!lmm) {
+			rc = -EPROTO;
+			goto out;
+		}
 
 		rc = obd_unpackmd(dt_exp, &md->lsm, lmm, lmmsize);
 		if (rc < 0)
-			GOTO(out, rc);
+			goto out;
 
 		if (rc < sizeof(*md->lsm)) {
 			CDEBUG(D_INFO,
 			       "lsm size too small: rc < sizeof (*md->lsm) (%d < %d)\n",
 			       rc, (int)sizeof(*md->lsm));
-			GOTO(out, rc = -EPROTO);
+			rc = -EPROTO;
+			goto out;
 		}
 
 	} else if (md->body->valid & OBD_MD_FLDIREA) {
@@ -550,7 +557,8 @@ int mdc_get_lustre_md(struct obd_export *exp, struct ptlrpc_request *req,
 		if (!S_ISDIR(md->body->mode)) {
 			CDEBUG(D_INFO,
 			       "OBD_MD_FLDIREA set, should be a directory, but is not\n");
-			GOTO(out, rc = -EPROTO);
+			rc = -EPROTO;
+			goto out;
 		}
 
 		if (md->body->eadatasize == 0) {
@@ -562,19 +570,22 @@ int mdc_get_lustre_md(struct obd_export *exp, struct ptlrpc_request *req,
 			lmvsize = md->body->eadatasize;
 			lmv = req_capsule_server_sized_get(pill, &RMF_MDT_MD,
 							   lmvsize);
-			if (!lmv)
-				GOTO(out, rc = -EPROTO);
+			if (!lmv) {
+				rc = -EPROTO;
+				goto out;
+			}
 
 			rc = obd_unpackmd(md_exp, (void *)&md->mea, lmv,
 					  lmvsize);
 			if (rc < 0)
-				GOTO(out, rc);
+				goto out;
 
 			if (rc < sizeof(*md->mea)) {
 				CDEBUG(D_INFO,
 				       "size too small: rc < sizeof(*md->mea) (%d < %d)\n",
 					rc, (int)sizeof(*md->mea));
-				GOTO(out, rc = -EPROTO);
+				rc = -EPROTO;
+				goto out;
 			}
 		}
 	}
@@ -585,8 +596,10 @@ int mdc_get_lustre_md(struct obd_export *exp, struct ptlrpc_request *req,
 		LASSERT(client_is_remote(exp));
 		md->remote_perm = req_capsule_server_swab_get(pill, &RMF_ACL,
 						lustre_swab_mdt_remote_perm);
-		if (!md->remote_perm)
-			GOTO(out, rc = -EPROTO);
+		if (!md->remote_perm) {
+			rc = -EPROTO;
+			goto out;
+		}
 	} else if (md->body->valid & OBD_MD_FLACL) {
 		/* for ACL, it's possible that FLACL is set but aclsize is zero.
 		 * only when aclsize != 0 there's an actual segment for ACL
@@ -595,7 +608,7 @@ int mdc_get_lustre_md(struct obd_export *exp, struct ptlrpc_request *req,
 		if (md->body->aclsize) {
 			rc = mdc_unpack_acl(req, md);
 			if (rc)
-				GOTO(out, rc);
+				goto out;
 #ifdef CONFIG_FS_POSIX_ACL
 		} else {
 			md->posix_acl = NULL;
@@ -607,7 +620,7 @@ int mdc_get_lustre_md(struct obd_export *exp, struct ptlrpc_request *req,
 
 		rc = mdc_unpack_capa(NULL, req, &RMF_CAPA1, &oc);
 		if (rc)
-			GOTO(out, rc);
+			goto out;
 		md->mds_capa = oc;
 	}
 
@@ -616,7 +629,7 @@ int mdc_get_lustre_md(struct obd_export *exp, struct ptlrpc_request *req,
 
 		rc = mdc_unpack_capa(NULL, req, &RMF_CAPA2, &oc);
 		if (rc)
-			GOTO(out, rc);
+			goto out;
 		md->oss_capa = oc;
 	}
 
@@ -1137,8 +1150,10 @@ static int mdc_statfs(const struct lu_env *env,
 
 	req = ptlrpc_request_alloc_pack(imp, &RQF_MDS_STATFS,
 					LUSTRE_MDS_VERSION, MDS_STATFS);
-	if (req == NULL)
-		GOTO(output, rc = -ENOMEM);
+	if (req == NULL) {
+		rc = -ENOMEM;
+		goto output;
+	}
 
 	ptlrpc_request_set_replen(req);
 
@@ -1153,12 +1168,14 @@ static int mdc_statfs(const struct lu_env *env,
 		/* check connection error first */
 		if (imp->imp_connect_error)
 			rc = imp->imp_connect_error;
-		GOTO(out, rc);
+		goto out;
 	}
 
 	msfs = req_capsule_server_get(&req->rq_pill, &RMF_OBD_STATFS);
-	if (msfs == NULL)
-		GOTO(out, rc = -EPROTO);
+	if (msfs == NULL) {
+		rc = -EPROTO;
+		goto out;
+	}
 
 	*osfs = *msfs;
 out:
@@ -1190,20 +1207,25 @@ static int mdc_ioc_fid2path(struct obd_export *exp, struct getinfo_fid2path *gf)
 	CDEBUG(D_IOCTL, "path get "DFID" from %llu #%d\n",
 	       PFID(&gf->gf_fid), gf->gf_recno, gf->gf_linkno);
 
-	if (!fid_is_sane(&gf->gf_fid))
-		GOTO(out, rc = -EINVAL);
+	if (!fid_is_sane(&gf->gf_fid)) {
+		rc = -EINVAL;
+		goto out;
+	}
 
 	/* Val is struct getinfo_fid2path result plus path */
 	vallen = sizeof(*gf) + gf->gf_pathlen;
 
 	rc = obd_get_info(NULL, exp, keylen, key, &vallen, gf, NULL);
 	if (rc != 0 && rc != -EREMOTE)
-		GOTO(out, rc);
+		goto out;
 
-	if (vallen <= sizeof(*gf))
-		GOTO(out, rc = -EPROTO);
-	else if (vallen > sizeof(*gf) + gf->gf_pathlen)
-		GOTO(out, rc = -EOVERFLOW);
+	if (vallen <= sizeof(*gf)) {
+		rc = -EPROTO;
+		goto out;
+	} else if (vallen > sizeof(*gf) + gf->gf_pathlen) {
+		rc = -EOVERFLOW;
+		goto out;
+	}
 
 	CDEBUG(D_IOCTL, "path get "DFID" from %llu #%d\n%s\n",
 	       PFID(&gf->gf_fid), gf->gf_recno, gf->gf_linkno, gf->gf_path);
@@ -1223,15 +1245,19 @@ static int mdc_ioc_hsm_progress(struct obd_export *exp,
 
 	req = ptlrpc_request_alloc_pack(imp, &RQF_MDS_HSM_PROGRESS,
 					LUSTRE_MDS_VERSION, MDS_HSM_PROGRESS);
-	if (req == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (req == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	mdc_pack_body(req, NULL, NULL, OBD_MD_FLRMTPERM, 0, 0, 0);
 
 	/* Copy hsm_progress struct */
 	req_hpk = req_capsule_client_get(&req->rq_pill, &RMF_MDS_HSM_PROGRESS);
-	if (req_hpk == NULL)
-		GOTO(out, rc = -EPROTO);
+	if (req_hpk == NULL) {
+		rc = -EPROTO;
+		goto out;
+	}
 
 	*req_hpk = *hpk;
 	req_hpk->hpk_errval = lustre_errno_hton(hpk->hpk_errval);
@@ -1239,7 +1265,7 @@ static int mdc_ioc_hsm_progress(struct obd_export *exp,
 	ptlrpc_request_set_replen(req);
 
 	rc = mdc_queue_wait(req);
-	GOTO(out, rc);
+	goto out;
 out:
 	ptlrpc_req_finished(req);
 	return rc;
@@ -1254,23 +1280,27 @@ static int mdc_ioc_hsm_ct_register(struct obd_import *imp, __u32 archives)
 	req = ptlrpc_request_alloc_pack(imp, &RQF_MDS_HSM_CT_REGISTER,
 					LUSTRE_MDS_VERSION,
 					MDS_HSM_CT_REGISTER);
-	if (req == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (req == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	mdc_pack_body(req, NULL, NULL, OBD_MD_FLRMTPERM, 0, 0, 0);
 
 	/* Copy hsm_progress struct */
 	archive_mask = req_capsule_client_get(&req->rq_pill,
 					      &RMF_MDS_HSM_ARCHIVE);
-	if (archive_mask == NULL)
-		GOTO(out, rc = -EPROTO);
+	if (archive_mask == NULL) {
+		rc = -EPROTO;
+		goto out;
+	}
 
 	*archive_mask = archives;
 
 	ptlrpc_request_set_replen(req);
 
 	rc = mdc_queue_wait(req);
-	GOTO(out, rc);
+	goto out;
 out:
 	ptlrpc_req_finished(req);
 	return rc;
@@ -1304,12 +1334,14 @@ static int mdc_ioc_hsm_current_action(struct obd_export *exp,
 
 	rc = mdc_queue_wait(req);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	req_hca = req_capsule_server_get(&req->rq_pill,
 					 &RMF_MDS_HSM_CURRENT_ACTION);
-	if (req_hca == NULL)
-		GOTO(out, rc = -EPROTO);
+	if (req_hca == NULL) {
+		rc = -EPROTO;
+		goto out;
+	}
 
 	*hca = *req_hca;
 
@@ -1326,15 +1358,17 @@ static int mdc_ioc_hsm_ct_unregister(struct obd_import *imp)
 	req = ptlrpc_request_alloc_pack(imp, &RQF_MDS_HSM_CT_UNREGISTER,
 					LUSTRE_MDS_VERSION,
 					MDS_HSM_CT_UNREGISTER);
-	if (req == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (req == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	mdc_pack_body(req, NULL, NULL, OBD_MD_FLRMTPERM, 0, 0, 0);
 
 	ptlrpc_request_set_replen(req);
 
 	rc = mdc_queue_wait(req);
-	GOTO(out, rc);
+	goto out;
 out:
 	ptlrpc_req_finished(req);
 	return rc;
@@ -1368,11 +1402,13 @@ static int mdc_ioc_hsm_state_get(struct obd_export *exp,
 
 	rc = mdc_queue_wait(req);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	req_hus = req_capsule_server_get(&req->rq_pill, &RMF_HSM_USER_STATE);
-	if (req_hus == NULL)
-		GOTO(out, rc = -EPROTO);
+	if (req_hus == NULL) {
+		rc = -EPROTO;
+		goto out;
+	}
 
 	*hus = *req_hus;
 
@@ -1407,14 +1443,16 @@ static int mdc_ioc_hsm_state_set(struct obd_export *exp,
 
 	/* Copy states */
 	req_hss = req_capsule_client_get(&req->rq_pill, &RMF_HSM_STATE_SET);
-	if (req_hss == NULL)
-		GOTO(out, rc = -EPROTO);
+	if (req_hss == NULL) {
+		rc = -EPROTO;
+		goto out;
+	}
 	*req_hss = *hss;
 
 	ptlrpc_request_set_replen(req);
 
 	rc = mdc_queue_wait(req);
-	GOTO(out, rc);
+	goto out;
 
 out:
 	ptlrpc_req_finished(req);
@@ -1432,8 +1470,10 @@ static int mdc_ioc_hsm_request(struct obd_export *exp,
 	int			 rc;
 
 	req = ptlrpc_request_alloc(imp, &RQF_MDS_HSM_REQUEST);
-	if (req == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (req == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	req_capsule_set_size(&req->rq_pill, &RMF_MDS_HSM_USER_ITEM, RCL_CLIENT,
 			     hur->hur_request.hr_itemcount
@@ -1451,27 +1491,33 @@ static int mdc_ioc_hsm_request(struct obd_export *exp,
 
 	/* Copy hsm_request struct */
 	req_hr = req_capsule_client_get(&req->rq_pill, &RMF_MDS_HSM_REQUEST);
-	if (req_hr == NULL)
-		GOTO(out, rc = -EPROTO);
+	if (req_hr == NULL) {
+		rc = -EPROTO;
+		goto out;
+	}
 	*req_hr = hur->hur_request;
 
 	/* Copy hsm_user_item structs */
 	req_hui = req_capsule_client_get(&req->rq_pill, &RMF_MDS_HSM_USER_ITEM);
-	if (req_hui == NULL)
-		GOTO(out, rc = -EPROTO);
+	if (req_hui == NULL) {
+		rc = -EPROTO;
+		goto out;
+	}
 	memcpy(req_hui, hur->hur_user_item,
 	       hur->hur_request.hr_itemcount * sizeof(struct hsm_user_item));
 
 	/* Copy opaque field */
 	req_opaque = req_capsule_client_get(&req->rq_pill, &RMF_GENERIC_DATA);
-	if (req_opaque == NULL)
-		GOTO(out, rc = -EPROTO);
+	if (req_opaque == NULL) {
+		rc = -EPROTO;
+		goto out;
+	}
 	memcpy(req_opaque, hur_data(hur), hur->hur_request.hr_data_len);
 
 	ptlrpc_request_set_replen(req);
 
 	rc = mdc_queue_wait(req);
-	GOTO(out, rc);
+	goto out;
 
 out:
 	ptlrpc_req_finished(req);
@@ -1556,24 +1602,28 @@ static int mdc_changelog_send_thread(void *csdata)
 	       cs->cs_fp, cs->cs_startrec);
 
 	OBD_ALLOC(cs->cs_buf, KUC_CHANGELOG_MSG_MAXSIZE);
-	if (cs->cs_buf == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (cs->cs_buf == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	/* Set up the remote catalog handle */
 	ctxt = llog_get_context(cs->cs_obd, LLOG_CHANGELOG_REPL_CTXT);
-	if (ctxt == NULL)
-		GOTO(out, rc = -ENOENT);
+	if (ctxt == NULL) {
+		rc = -ENOENT;
+		goto out;
+	}
 	rc = llog_open(NULL, ctxt, &llh, NULL, CHANGELOG_CATALOG,
 		       LLOG_OPEN_EXISTS);
 	if (rc) {
 		CERROR("%s: fail to open changelog catalog: rc = %d\n",
 		       cs->cs_obd->obd_name, rc);
-		GOTO(out, rc);
+		goto out;
 	}
 	rc = llog_init_handle(NULL, llh, LLOG_F_IS_CAT, NULL);
 	if (rc) {
 		CERROR("llog_init_handle failed %d\n", rc);
-		GOTO(out, rc);
+		goto out;
 	}
 
 	rc = llog_cat_process(NULL, llh, changelog_kkuc_cb, cs, 0, 0);
@@ -1767,7 +1817,7 @@ static int mdc_ioc_swap_layouts(struct obd_export *exp,
 
 	rc = ptlrpc_queue_wait(req);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 out:
 	ptlrpc_req_finished(req);
@@ -1790,7 +1840,7 @@ static int mdc_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 	switch (cmd) {
 	case OBD_IOC_CHANGELOG_SEND:
 		rc = mdc_ioc_changelog_send(obd, karg);
-		GOTO(out, rc);
+		goto out;
 	case OBD_IOC_CHANGELOG_CLEAR: {
 		struct ioc_changelog *icc = karg;
 		struct changelog_setinfo cs = {
@@ -1801,60 +1851,61 @@ static int mdc_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 		rc = obd_set_info_async(NULL, exp, strlen(KEY_CHANGELOG_CLEAR),
 					KEY_CHANGELOG_CLEAR, sizeof(cs), &cs,
 					NULL);
-		GOTO(out, rc);
+		goto out;
 	}
 	case OBD_IOC_FID2PATH:
 		rc = mdc_ioc_fid2path(exp, karg);
-		GOTO(out, rc);
+		goto out;
 	case LL_IOC_HSM_CT_START:
 		rc = mdc_ioc_hsm_ct_start(exp, karg);
 		/* ignore if it was already registered on this MDS. */
 		if (rc == -EEXIST)
 			rc = 0;
-		GOTO(out, rc);
+		goto out;
 	case LL_IOC_HSM_PROGRESS:
 		rc = mdc_ioc_hsm_progress(exp, karg);
-		GOTO(out, rc);
+		goto out;
 	case LL_IOC_HSM_STATE_GET:
 		rc = mdc_ioc_hsm_state_get(exp, karg);
-		GOTO(out, rc);
+		goto out;
 	case LL_IOC_HSM_STATE_SET:
 		rc = mdc_ioc_hsm_state_set(exp, karg);
-		GOTO(out, rc);
+		goto out;
 	case LL_IOC_HSM_ACTION:
 		rc = mdc_ioc_hsm_current_action(exp, karg);
-		GOTO(out, rc);
+		goto out;
 	case LL_IOC_HSM_REQUEST:
 		rc = mdc_ioc_hsm_request(exp, karg);
-		GOTO(out, rc);
+		goto out;
 	case OBD_IOC_CLIENT_RECOVER:
 		rc = ptlrpc_recover_import(imp, data->ioc_inlbuf1, 0);
 		if (rc < 0)
-			GOTO(out, rc);
-		GOTO(out, rc = 0);
+			goto out;
+		rc = 0;
+		goto out;
 	case IOC_OSC_SET_ACTIVE:
 		rc = ptlrpc_set_import_active(imp, data->ioc_offset);
-		GOTO(out, rc);
+		goto out;
 	case OBD_IOC_PARSE: {
 		ctxt = llog_get_context(exp->exp_obd, LLOG_CONFIG_REPL_CTXT);
 		rc = class_config_parse_llog(NULL, ctxt, data->ioc_inlbuf1,
 					     NULL);
 		llog_ctxt_put(ctxt);
-		GOTO(out, rc);
+		goto out;
 	}
 	case OBD_IOC_LLOG_INFO:
 	case OBD_IOC_LLOG_PRINT: {
 		ctxt = llog_get_context(obd, LLOG_CONFIG_REPL_CTXT);
 		rc = llog_ioctl(NULL, ctxt, cmd, data);
 		llog_ctxt_put(ctxt);
-		GOTO(out, rc);
+		goto out;
 	}
 	case OBD_IOC_POLL_QUOTACHECK:
 		rc = mdc_quota_poll_check(exp, (struct if_quotacheck *)karg);
-		GOTO(out, rc);
+		goto out;
 	case OBD_IOC_PING_TARGET:
 		rc = ptlrpc_obd_ping(obd);
-		GOTO(out, rc);
+		goto out;
 	/*
 	 * Normally IOC_OBD_STATFS, OBD_IOC_QUOTACTL iocontrol are handled by
 	 * LMV instead of MDC. But when the cluster is upgraded from 1.8,
@@ -1865,35 +1916,44 @@ static int mdc_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 	case IOC_OBD_STATFS: {
 		struct obd_statfs stat_buf = {0};
 
-		if (*((__u32 *) data->ioc_inlbuf2) != 0)
-			GOTO(out, rc = -ENODEV);
+		if (*((__u32 *) data->ioc_inlbuf2) != 0) {
+			rc = -ENODEV;
+			goto out;
+		}
 
 		/* copy UUID */
 		if (copy_to_user(data->ioc_pbuf2, obd2cli_tgt(obd),
 				     min((int) data->ioc_plen2,
-					 (int) sizeof(struct obd_uuid))))
-			GOTO(out, rc = -EFAULT);
+					 (int) sizeof(struct obd_uuid)))) {
+			rc = -EFAULT;
+			goto out;
+		}
 
 		rc = mdc_statfs(NULL, obd->obd_self_export, &stat_buf,
 				cfs_time_shift_64(-OBD_STATFS_CACHE_SECONDS),
 				0);
 		if (rc != 0)
-			GOTO(out, rc);
+			goto out;
 
 		if (copy_to_user(data->ioc_pbuf1, &stat_buf,
 				     min((int) data->ioc_plen1,
-					 (int) sizeof(stat_buf))))
-			GOTO(out, rc = -EFAULT);
+					 (int) sizeof(stat_buf)))) {
+			rc = -EFAULT;
+			goto out;
+		}
 
-		GOTO(out, rc = 0);
+		rc = 0;
+		goto out;
 	}
 	case OBD_IOC_QUOTACTL: {
 		struct if_quotactl *qctl = karg;
 		struct obd_quotactl *oqctl;
 
 		OBD_ALLOC_PTR(oqctl);
-		if (oqctl == NULL)
-			GOTO(out, rc = -ENOMEM);
+		if (oqctl == NULL) {
+			rc = -ENOMEM;
+			goto out;
+		}
 
 		QCTL_COPY(oqctl, qctl);
 		rc = obd_quotactl(exp, oqctl);
@@ -1904,20 +1964,24 @@ static int mdc_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 		}
 
 		OBD_FREE_PTR(oqctl);
-		GOTO(out, rc);
+		goto out;
 	}
 	case LL_IOC_GET_CONNECT_FLAGS:
 		if (copy_to_user(uarg, exp_connect_flags_ptr(exp),
-				 sizeof(*exp_connect_flags_ptr(exp))))
-			GOTO(out, rc = -EFAULT);
+				 sizeof(*exp_connect_flags_ptr(exp)))) {
+			rc = -EFAULT;
+			goto out;
+		}
 
-		GOTO(out, rc = 0);
+		rc = 0;
+		goto out;
 	case LL_IOC_LOV_SWAP_LAYOUTS:
 		rc = mdc_ioc_swap_layouts(exp, karg);
-		GOTO(out, rc);
+		goto out;
 	default:
 		CERROR("unrecognised ioctl: cmd = %#x\n", cmd);
-		GOTO(out, rc = -ENOTTY);
+		rc = -ENOTTY;
+		goto out;
 	}
 out:
 	module_put(THIS_MODULE);
@@ -2243,12 +2307,14 @@ static int mdc_pin(struct obd_export *exp, const struct lu_fid *fid,
 	mdc_put_rpc_lock(exp->exp_obd->u.cli.cl_rpc_lock, NULL);
 	if (rc) {
 		CERROR("Pin failed: %d\n", rc);
-		GOTO(err_out, rc);
+		goto err_out;
 	}
 
 	body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
-	if (body == NULL)
-		GOTO(err_out, rc = -EPROTO);
+	if (body == NULL) {
+		rc = -EPROTO;
+		goto err_out;
+	}
 
 	handle->och_fh = body->handle;
 	handle->och_magic = OBD_CLIENT_HANDLE_MAGIC;
@@ -2256,7 +2322,8 @@ static int mdc_pin(struct obd_export *exp, const struct lu_fid *fid,
 	handle->och_mod = obd_mod_alloc();
 	if (handle->och_mod == NULL) {
 		DEBUG_REQ(D_ERROR, req, "can't allocate md_open_data");
-		GOTO(err_out, rc = -ENOMEM);
+		rc = -ENOMEM;
+		goto err_out;
 	}
 	handle->och_mod->mod_open_req = req; /* will be dropped by unpin */
 
@@ -2444,13 +2511,15 @@ static int mdc_setup(struct obd_device *obd, struct lustre_cfg *cfg)
 	ptlrpcd_addref();
 
 	OBD_ALLOC(cli->cl_close_lock, sizeof(*cli->cl_close_lock));
-	if (!cli->cl_close_lock)
-		GOTO(err_rpc_lock, rc = -ENOMEM);
+	if (!cli->cl_close_lock) {
+		rc = -ENOMEM;
+		goto err_rpc_lock;
+	}
 	mdc_init_rpc_lock(cli->cl_close_lock);
 
 	rc = client_obd_setup(obd, cfg);
 	if (rc)
-		GOTO(err_close_lock, rc);
+		goto err_close_lock;
 	lprocfs_mdc_init_vars(&lvars);
 	lprocfs_obd_setup(obd, lvars.obd_vars);
 	sptlrpc_lprocfs_cliobd_attach(obd);
@@ -2638,19 +2707,27 @@ static int mdc_interpret_renew_capa(const struct lu_env *env,
 	struct mdt_body *body = NULL;
 	struct lustre_capa *capa;
 
-	if (status)
-		GOTO(out, capa = ERR_PTR(status));
+	if (status) {
+		capa = ERR_PTR(status);
+		goto out;
+	}
 
 	body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
-	if (body == NULL)
-		GOTO(out, capa = ERR_PTR(-EFAULT));
+	if (body == NULL) {
+		capa = ERR_PTR(-EFAULT);
+		goto out;
+	}
 
-	if ((body->valid & OBD_MD_FLOSSCAPA) == 0)
-		GOTO(out, capa = ERR_PTR(-ENOENT));
+	if ((body->valid & OBD_MD_FLOSSCAPA) == 0) {
+		capa = ERR_PTR(-ENOENT);
+		goto out;
+	}
 
 	capa = req_capsule_server_get(&req->rq_pill, &RMF_CAPA2);
-	if (!capa)
-		GOTO(out, capa = ERR_PTR(-EFAULT));
+	if (!capa) {
+		capa = ERR_PTR(-EFAULT);
+		goto out;
+	}
 out:
 	ra->ra_cb(ra->ra_oc, capa);
 	return 0;

