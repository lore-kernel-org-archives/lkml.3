Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaH1SHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:07:16 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:2156 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbaH1SHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:07:14 -0400
X-IronPort-AV: E=Sophos;i="5.04,418,1406584800"; 
   d="scan'208";a="91963681"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] staging: lustre: mgc: expand the GOTO macro
Date: Thu, 28 Aug 2014 20:03:37 +0200
Message-Id: <1409249017-31331-1-git-send-email-Julia.Lawall@lip6.fr>
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

 drivers/staging/lustre/lustre/mgc/mgc_request.c |  118 +++++++++++++++---------
 1 file changed, 74 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index aeaa2bf..b21a135 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -329,7 +329,8 @@ static int config_log_add(struct obd_device *obd, char *logname,
 						CONFIG_T_SPTLRPC, NULL, NULL);
 		if (IS_ERR(sptlrpc_cld)) {
 			CERROR("can't create sptlrpc log: %s\n", seclogname);
-			GOTO(out_err, rc = PTR_ERR(sptlrpc_cld));
+			rc = PTR_ERR(sptlrpc_cld);
+			goto out_err;
 		}
 	}
 	params_cld = config_params_log_add(obd, cfg, sb);
@@ -337,13 +338,14 @@ static int config_log_add(struct obd_device *obd, char *logname,
 		rc = PTR_ERR(params_cld);
 		CERROR("%s: can't create params log: rc = %d\n",
 		       obd->obd_name, rc);
-		GOTO(out_err1, rc);
+		goto out_err1;
 	}
 
 	cld = do_config_log_add(obd, logname, CONFIG_T_CONFIG, cfg, sb);
 	if (IS_ERR(cld)) {
 		CERROR("can't create log: %s\n", logname);
-		GOTO(out_err2, rc = PTR_ERR(cld));
+		rc = PTR_ERR(cld);
+		goto out_err2;
 	}
 
 	cld->cld_sptlrpc = sptlrpc_cld;
@@ -354,8 +356,10 @@ static int config_log_add(struct obd_device *obd, char *logname,
 		struct config_llog_data *recover_cld;
 		*strrchr(seclogname, '-') = 0;
 		recover_cld = config_recover_log_add(obd, seclogname, cfg, sb);
-		if (IS_ERR(recover_cld))
-			GOTO(out_err3, rc = PTR_ERR(recover_cld));
+		if (IS_ERR(recover_cld)) {
+			rc = PTR_ERR(recover_cld);
+			goto out_err3;
+		}
 		cld->cld_recover = recover_cld;
 	}
 
@@ -680,7 +684,7 @@ static int mgc_fs_setup(struct obd_device *obd, struct super_block *sb)
 	/* Setup the configs dir */
 	rc = lu_env_init(env, LCT_MG_THREAD);
 	if (rc)
-		GOTO(out_err, rc);
+		goto out_err;
 
 	fid.f_seq = FID_SEQ_LOCAL_NAME;
 	fid.f_oid = 1;
@@ -688,30 +692,34 @@ static int mgc_fs_setup(struct obd_device *obd, struct super_block *sb)
 	rc = local_oid_storage_init(env, lsi->lsi_dt_dev, &fid,
 				    &cli->cl_mgc_los);
 	if (rc)
-		GOTO(out_env, rc);
+		goto out_env;
 
 	rc = dt_root_get(env, lsi->lsi_dt_dev, &rfid);
 	if (rc)
-		GOTO(out_env, rc);
+		goto out_env;
 
 	root = dt_locate_at(env, lsi->lsi_dt_dev, &rfid,
 			    &cli->cl_mgc_los->los_dev->dd_lu_dev);
-	if (unlikely(IS_ERR(root)))
-		GOTO(out_los, rc = PTR_ERR(root));
+	if (unlikely(IS_ERR(root))) {
+		rc = PTR_ERR(root);
+		goto out_los;
+	}
 
 	dto = local_file_find_or_create(env, cli->cl_mgc_los, root,
 					MOUNT_CONFIGS_DIR,
 					S_IFDIR | S_IRUGO | S_IWUSR | S_IXUGO);
 	lu_object_put_nocache(env, &root->do_lu);
-	if (IS_ERR(dto))
-		GOTO(out_los, rc = PTR_ERR(dto));
+	if (IS_ERR(dto)) {
+		rc = PTR_ERR(dto);
+		goto out_los;
+	}
 
 	cli->cl_mgc_configs_dir = dto;
 
 	LASSERT(lsi->lsi_osd_exp->exp_obd->obd_lvfs_ctxt.dt);
 	rc = mgc_local_llog_init(env, obd, lsi->lsi_osd_exp->exp_obd);
 	if (rc)
-		GOTO(out_llog, rc);
+		goto out_llog;
 
 	/* We take an obd ref to insure that we can't get to mgc_cleanup
 	 * without calling mgc_fs_cleanup first. */
@@ -746,7 +754,7 @@ static int mgc_fs_cleanup(struct obd_device *obd)
 
 	rc = lu_env_init(&env, LCT_MG_THREAD);
 	if (rc)
-		GOTO(unlock, rc);
+		goto unlock;
 
 	mgc_local_llog_fini(&env, obd);
 
@@ -853,12 +861,12 @@ static int mgc_setup(struct obd_device *obd, struct lustre_cfg *lcfg)
 
 	rc = client_obd_setup(obd, lcfg);
 	if (rc)
-		GOTO(err_decref, rc);
+		goto err_decref;
 
 	rc = mgc_llog_init(NULL, obd);
 	if (rc) {
 		CERROR("failed to setup llogging subsystems\n");
-		GOTO(err_cleanup, rc);
+		goto err_cleanup;
 	}
 
 	lprocfs_mgc_init_vars(&lvars);
@@ -876,7 +884,7 @@ static int mgc_setup(struct obd_device *obd, struct lustre_cfg *lcfg)
 			CERROR("%s: Cannot start requeue thread (%d),"
 			       "no more log updates!\n",
 			       obd->obd_name, rc);
-			GOTO(err_cleanup, rc);
+			goto err_cleanup;
 		}
 		/* rc is the task_struct pointer of mgc_requeue_thread. */
 		rc = 0;
@@ -1504,13 +1512,17 @@ static int mgc_process_recover_log(struct obd_device *obd,
 		nrpages = CONFIG_READ_NRPAGES_INIT;
 
 	OBD_ALLOC(pages, sizeof(*pages) * nrpages);
-	if (pages == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (pages == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	for (i = 0; i < nrpages; i++) {
 		pages[i] = alloc_page(GFP_IOFS);
-		if (pages[i] == NULL)
-			GOTO(out, rc = -ENOMEM);
+		if (pages[i] == NULL) {
+			rc = -ENOMEM;
+			goto out;
+		}
 	}
 
 again:
@@ -1518,20 +1530,24 @@ again:
 	LASSERT(mutex_is_locked(&cld->cld_lock));
 	req = ptlrpc_request_alloc(class_exp2cliimp(cld->cld_mgcexp),
 				   &RQF_MGS_CONFIG_READ);
-	if (req == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (req == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	rc = ptlrpc_request_pack(req, LUSTRE_MGS_VERSION, MGS_CONFIG_READ);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	/* pack request */
 	body = req_capsule_client_get(&req->rq_pill, &RMF_MGS_CONFIG_BODY);
 	LASSERT(body != NULL);
 	LASSERT(sizeof(body->mcb_name) > strlen(cld->cld_logname));
 	if (strlcpy(body->mcb_name, cld->cld_logname, sizeof(body->mcb_name))
-	    >= sizeof(body->mcb_name))
-		GOTO(out, rc = -E2BIG);
+	    >= sizeof(body->mcb_name)) {
+		rc = -E2BIG;
+		goto out;
+	}
 	body->mcb_offset = cfg->cfg_last_idx + 1;
 	body->mcb_type   = cld->cld_type;
 	body->mcb_bits   = PAGE_CACHE_SHIFT;
@@ -1540,8 +1556,10 @@ again:
 	/* allocate bulk transfer descriptor */
 	desc = ptlrpc_prep_bulk_imp(req, nrpages, 1, BULK_PUT_SINK,
 				    MGS_BULK_PORTAL);
-	if (desc == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (desc == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	for (i = 0; i < nrpages; i++)
 		ptlrpc_prep_bulk_page_pin(desc, pages[i], 0, PAGE_CACHE_SIZE);
@@ -1549,11 +1567,13 @@ again:
 	ptlrpc_request_set_replen(req);
 	rc = ptlrpc_queue_wait(req);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	res = req_capsule_server_get(&req->rq_pill, &RMF_MGS_CONFIG_RES);
-	if (res->mcr_size < res->mcr_offset)
-		GOTO(out, rc = -EINVAL);
+	if (res->mcr_size < res->mcr_offset) {
+		rc = -EINVAL;
+		goto out;
+	}
 
 	/* always update the index even though it might have errors with
 	 * handling the recover logs */
@@ -1564,16 +1584,20 @@ again:
 	       res->mcr_offset, eof == false);
 
 	ealen = sptlrpc_cli_unwrap_bulk_read(req, req->rq_bulk, 0);
-	if (ealen < 0)
-		GOTO(out, rc = ealen);
+	if (ealen < 0) {
+		rc = ealen;
+		goto out;
+	}
 
-	if (ealen > nrpages << PAGE_CACHE_SHIFT)
-		GOTO(out, rc = -EINVAL);
+	if (ealen > nrpages << PAGE_CACHE_SHIFT) {
+		rc = -EINVAL;
+		goto out;
+	}
 
 	if (ealen == 0) { /* no logs transferred */
 		if (!eof)
 			rc = -EINVAL;
-		GOTO(out, rc);
+		goto out;
 	}
 
 	mne_swab = !!ptlrpc_rep_need_swab(req);
@@ -1646,7 +1670,7 @@ static int mgc_llog_local_copy(const struct lu_env *env,
 	/* make a copy of local llog at first */
 	rc = llog_backup(env, obd, lctxt, lctxt, logname, temp_log);
 	if (rc < 0 && rc != -ENOENT)
-		GOTO(out, rc);
+		goto out;
 	/* copy remote llog to the local copy */
 	rc = llog_backup(env, obd, rctxt, lctxt, logname, logname);
 	if (rc == -ENOENT) {
@@ -1694,7 +1718,7 @@ static int mgc_process_cfg_log(struct obd_device *mgc,
 
 	rc = lu_env_init(env, LCT_MG_THREAD);
 	if (rc)
-		GOTO(out_free, rc);
+		goto out_free;
 
 	ctxt = llog_get_context(mgc, LLOG_CONFIG_REPL_CTXT);
 	LASSERT(ctxt);
@@ -1715,7 +1739,8 @@ static int mgc_process_cfg_log(struct obd_device *mgc,
 				LCONSOLE_ERROR_MSG(0x13a,
 						   "Failed to get MGS log %s and no local copy.\n",
 						   cld->cld_logname);
-				GOTO(out_pop, rc = -ENOENT);
+				rc = -ENOENT;
+				goto out_pop;
 			}
 			CDEBUG(D_MGC,
 			       "Failed to get MGS log %s, using local copy for now, will try to update later.\n",
@@ -1728,8 +1753,10 @@ static int mgc_process_cfg_log(struct obd_device *mgc,
 		ctxt = lctxt;
 		lctxt = NULL;
 	} else {
-		if (local_only) /* no local log at client side */
-			GOTO(out_pop, rc = -EIO);
+		if (local_only) /* no local log at client side */ {
+			rc = -EIO;
+			goto out_pop;
+		}
 	}
 
 	if (cld_is_sptlrpc(cld)) {
@@ -1857,8 +1884,10 @@ static int mgc_process_config(struct obd_device *obd, u32 len, void *buf)
 		struct mgs_target_info *mti;
 
 		if (LUSTRE_CFG_BUFLEN(lcfg, 1) !=
-		    sizeof(struct mgs_target_info))
-			GOTO(out, rc = -EINVAL);
+		    sizeof(struct mgs_target_info)) {
+			rc = -EINVAL;
+			goto out;
+		}
 
 		mti = (struct mgs_target_info *)lustre_cfg_buf(lcfg, 1);
 		CDEBUG(D_MGC, "add_target %s %#x\n",
@@ -1943,7 +1972,8 @@ static int mgc_process_config(struct obd_device *obd, u32 len, void *buf)
 	}
 	default: {
 		CERROR("Unknown command: %d\n", lcfg->lcfg_command);
-		GOTO(out, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out;
 
 	}
 	}

