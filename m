Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaH3VNo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:13:44 -0400
Received: from linuxhacker.ru ([217.76.32.60]:51545 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbaH3VN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:13:29 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: "John L. Hammond" <john.hammond@intel.com>,
        Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 08/12] staging/lustre/mgc: remove server specific handlers
Date: Sat, 30 Aug 2014 17:12:47 -0400
Message-Id: <1409433171-23572-9-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409433171-23572-1-git-send-email-green@linuxhacker.ru>
References: <1409433171-23572-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Remove the server specific set_info handlers (KEY_REGISTER_TARGET,
KEY_SET_FS, KEY_CLEAR_FS) and supporting functions.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
---
 drivers/staging/lustre/lustre/mgc/mgc_request.c | 177 ------------------------
 1 file changed, 177 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index b21a135..970e91c 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -47,7 +47,6 @@
 #include "../include/lprocfs_status.h"
 #include "../include/lustre_log.h"
 #include "../include/lustre_disk.h"
-#include "../include/dt_object.h"
 
 #include "mgc_internal.h"
 
@@ -628,150 +627,6 @@ static void mgc_requeue_add(struct config_llog_data *cld)
 	}
 }
 
-/********************** class fns **********************/
-static int mgc_local_llog_init(const struct lu_env *env,
-			       struct obd_device *obd,
-			       struct obd_device *disk)
-{
-	struct llog_ctxt	*ctxt;
-	int			 rc;
-
-	rc = llog_setup(env, obd, &obd->obd_olg, LLOG_CONFIG_ORIG_CTXT, disk,
-			&llog_osd_ops);
-	if (rc)
-		return rc;
-
-	ctxt = llog_get_context(obd, LLOG_CONFIG_ORIG_CTXT);
-	LASSERT(ctxt);
-	ctxt->loc_dir = obd->u.cli.cl_mgc_configs_dir;
-	llog_ctxt_put(ctxt);
-
-	return 0;
-}
-
-static int mgc_local_llog_fini(const struct lu_env *env,
-			       struct obd_device *obd)
-{
-	struct llog_ctxt *ctxt;
-
-	ctxt = llog_get_context(obd, LLOG_CONFIG_ORIG_CTXT);
-	llog_cleanup(env, ctxt);
-
-	return 0;
-}
-
-static int mgc_fs_setup(struct obd_device *obd, struct super_block *sb)
-{
-	struct lustre_sb_info	*lsi = s2lsi(sb);
-	struct client_obd	*cli = &obd->u.cli;
-	struct lu_fid		 rfid, fid;
-	struct dt_object	*root, *dto;
-	struct lu_env		*env;
-	int			 rc = 0;
-
-	LASSERT(lsi);
-	LASSERT(lsi->lsi_dt_dev);
-
-	OBD_ALLOC_PTR(env);
-	if (env == NULL)
-		return -ENOMEM;
-
-	/* The mgc fs exclusion mutex. Only one fs can be setup at a time. */
-	mutex_lock(&cli->cl_mgc_mutex);
-
-	cfs_cleanup_group_info();
-
-	/* Setup the configs dir */
-	rc = lu_env_init(env, LCT_MG_THREAD);
-	if (rc)
-		goto out_err;
-
-	fid.f_seq = FID_SEQ_LOCAL_NAME;
-	fid.f_oid = 1;
-	fid.f_ver = 0;
-	rc = local_oid_storage_init(env, lsi->lsi_dt_dev, &fid,
-				    &cli->cl_mgc_los);
-	if (rc)
-		goto out_env;
-
-	rc = dt_root_get(env, lsi->lsi_dt_dev, &rfid);
-	if (rc)
-		goto out_env;
-
-	root = dt_locate_at(env, lsi->lsi_dt_dev, &rfid,
-			    &cli->cl_mgc_los->los_dev->dd_lu_dev);
-	if (unlikely(IS_ERR(root))) {
-		rc = PTR_ERR(root);
-		goto out_los;
-	}
-
-	dto = local_file_find_or_create(env, cli->cl_mgc_los, root,
-					MOUNT_CONFIGS_DIR,
-					S_IFDIR | S_IRUGO | S_IWUSR | S_IXUGO);
-	lu_object_put_nocache(env, &root->do_lu);
-	if (IS_ERR(dto)) {
-		rc = PTR_ERR(dto);
-		goto out_los;
-	}
-
-	cli->cl_mgc_configs_dir = dto;
-
-	LASSERT(lsi->lsi_osd_exp->exp_obd->obd_lvfs_ctxt.dt);
-	rc = mgc_local_llog_init(env, obd, lsi->lsi_osd_exp->exp_obd);
-	if (rc)
-		goto out_llog;
-
-	/* We take an obd ref to insure that we can't get to mgc_cleanup
-	 * without calling mgc_fs_cleanup first. */
-	class_incref(obd, "mgc_fs", obd);
-
-	/* We keep the cl_mgc_sem until mgc_fs_cleanup */
-out_llog:
-	if (rc) {
-		lu_object_put(env, &cli->cl_mgc_configs_dir->do_lu);
-		cli->cl_mgc_configs_dir = NULL;
-	}
-out_los:
-	if (rc < 0) {
-		local_oid_storage_fini(env, cli->cl_mgc_los);
-		cli->cl_mgc_los = NULL;
-		mutex_unlock(&cli->cl_mgc_mutex);
-	}
-out_env:
-	lu_env_fini(env);
-out_err:
-	OBD_FREE_PTR(env);
-	return rc;
-}
-
-static int mgc_fs_cleanup(struct obd_device *obd)
-{
-	struct lu_env		 env;
-	struct client_obd	*cli = &obd->u.cli;
-	int			 rc;
-
-	LASSERT(cli->cl_mgc_los != NULL);
-
-	rc = lu_env_init(&env, LCT_MG_THREAD);
-	if (rc)
-		goto unlock;
-
-	mgc_local_llog_fini(&env, obd);
-
-	lu_object_put_nocache(&env, &cli->cl_mgc_configs_dir->do_lu);
-	cli->cl_mgc_configs_dir = NULL;
-
-	local_oid_storage_fini(&env, cli->cl_mgc_los);
-	cli->cl_mgc_los = NULL;
-	lu_env_fini(&env);
-
-unlock:
-	class_decref(obd, "mgc_fs", obd);
-	mutex_unlock(&cli->cl_mgc_mutex);
-
-	return 0;
-}
-
 static int mgc_llog_init(const struct lu_env *env, struct obd_device *obd)
 {
 	struct llog_ctxt	*ctxt;
@@ -1131,38 +986,6 @@ int mgc_set_info_async(const struct lu_env *env, struct obd_export *exp,
 			ptlrpc_reconnect_import(imp);
 		return 0;
 	}
-	/* FIXME move this to mgc_process_config */
-	if (KEY_IS(KEY_REGISTER_TARGET)) {
-		struct mgs_target_info *mti;
-		if (vallen != sizeof(struct mgs_target_info))
-			return -EINVAL;
-		mti = (struct mgs_target_info *)val;
-		CDEBUG(D_MGC, "register_target %s %#x\n",
-		       mti->mti_svname, mti->mti_flags);
-		rc =  mgc_target_register(exp, mti);
-		return rc;
-	}
-	if (KEY_IS(KEY_SET_FS)) {
-		struct super_block *sb = (struct super_block *)val;
-
-		if (vallen != sizeof(struct super_block))
-			return -EINVAL;
-
-		rc = mgc_fs_setup(exp->exp_obd, sb);
-		if (rc)
-			CERROR("set_fs got %d\n", rc);
-
-		return rc;
-	}
-	if (KEY_IS(KEY_CLEAR_FS)) {
-		if (vallen != 0)
-			return -EINVAL;
-		rc = mgc_fs_cleanup(exp->exp_obd);
-		if (rc)
-			CERROR("clear_fs got %d\n", rc);
-
-		return rc;
-	}
 	if (KEY_IS(KEY_SET_INFO)) {
 		struct mgs_send_param *msp;
 
-- 
1.9.3

