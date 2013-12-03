Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3LCOEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:04:21 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:59076 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab3LCOEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:04:15 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Mikhail Pershin <mike.pershin@intel.com>,
        Levente Kurusa <levex@linux.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v3 02/15] staging/lustre/llog: MGC to use OSD API for backup logs
Date: Tue,  3 Dec 2013 21:58:40 +0800
Message-Id: <1386079133-6459-3-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
References: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikhail Pershin <mike.pershin@intel.com>

MGC uses lvfs API to access local llogs blocking removal of old code

- llog_is_empty() and llog_backup() are introduced

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2059
Lustre-change: http://review.whamcloud.com/5049
Cc: Levente Kurusa <levex@linux.com>
Signed-off-by: Mikhail Pershin <mike.pershin@intel.com>
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
[pick client side change only -- Peng Tao]
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/include/dt_object.h  |    2 +-
 drivers/staging/lustre/lustre/include/lustre_log.h |   13 +-
 drivers/staging/lustre/lustre/include/obd.h        |    4 +-
 drivers/staging/lustre/lustre/mgc/libmgc.c         |    3 -
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |  394 ++++++++++++--------
 drivers/staging/lustre/lustre/obdclass/llog.c      |  212 +++++++----
 .../staging/lustre/lustre/obdclass/local_storage.c |    9 +-
 .../staging/lustre/lustre/obdclass/local_storage.h |    3 +
 drivers/staging/lustre/lustre/obdclass/lu_object.c |    2 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |    3 +
 10 files changed, 407 insertions(+), 238 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/dt_object.h b/drivers/staging/lustre/lustre/include/dt_object.h
index e116bb2..9304c26 100644
--- a/drivers/staging/lustre/lustre/include/dt_object.h
+++ b/drivers/staging/lustre/lustre/include/dt_object.h
@@ -692,7 +692,7 @@ struct local_oid_storage {
 	struct dt_object *los_obj;
 
 	/* data used to generate new fids */
-	struct mutex	 los_id_lock;
+	struct mutex	  los_id_lock;
 	__u64		  los_seq;
 	__u32		  los_last_oid;
 };
diff --git a/drivers/staging/lustre/lustre/include/lustre_log.h b/drivers/staging/lustre/lustre/include/lustre_log.h
index 721aa05..896c757 100644
--- a/drivers/staging/lustre/lustre/include/lustre_log.h
+++ b/drivers/staging/lustre/lustre/include/lustre_log.h
@@ -136,7 +136,11 @@ int llog_open(const struct lu_env *env, struct llog_ctxt *ctxt,
 	      struct llog_handle **lgh, struct llog_logid *logid,
 	      char *name, enum llog_open_param open_param);
 int llog_close(const struct lu_env *env, struct llog_handle *cathandle);
-int llog_get_size(struct llog_handle *loghandle);
+int llog_is_empty(const struct lu_env *env, struct llog_ctxt *ctxt,
+		  char *name);
+int llog_backup(const struct lu_env *env, struct obd_device *obd,
+		struct llog_ctxt *ctxt, struct llog_ctxt *bak_ctxt,
+		char *name, char *backup);
 
 /* llog_process flags */
 #define LLOG_FLAG_NODEAMON 0x0001
@@ -382,6 +386,13 @@ static inline int llog_data_len(int len)
 	return cfs_size_round(len);
 }
 
+static inline int llog_get_size(struct llog_handle *loghandle)
+{
+	if (loghandle && loghandle->lgh_hdr)
+		return loghandle->lgh_hdr->llh_count;
+	return 0;
+}
+
 static inline struct llog_ctxt *llog_ctxt_get(struct llog_ctxt *ctxt)
 {
 	atomic_inc(&ctxt->loc_refcount);
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index d0aea15..f0c1773 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -399,8 +399,8 @@ struct client_obd {
 
 	/* mgc datastruct */
 	struct semaphore	 cl_mgc_sem;
-	struct vfsmount	 *cl_mgc_vfsmnt;
-	struct dentry	   *cl_mgc_configs_dir;
+	struct local_oid_storage *cl_mgc_los;
+	struct dt_object	*cl_mgc_configs_dir;
 	atomic_t	     cl_mgc_refcount;
 	struct obd_export       *cl_mgc_mgsexp;
 
diff --git a/drivers/staging/lustre/lustre/mgc/libmgc.c b/drivers/staging/lustre/lustre/mgc/libmgc.c
index 7b4947c..9b40c57 100644
--- a/drivers/staging/lustre/lustre/mgc/libmgc.c
+++ b/drivers/staging/lustre/lustre/mgc/libmgc.c
@@ -99,11 +99,8 @@ static int mgc_precleanup(struct obd_device *obd, enum obd_cleanup_stage stage)
 
 static int mgc_cleanup(struct obd_device *obd)
 {
-	struct client_obd *cli = &obd->u.cli;
 	int rc;
 
-	LASSERT(cli->cl_mgc_vfsmnt == NULL);
-
 	ptlrpcd_decref();
 
 	rc = client_obd_cleanup(obd);
diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index 93b601d..f6e4bac 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -41,17 +41,14 @@
 #define DEBUG_SUBSYSTEM S_MGC
 #define D_MGC D_CONFIG /*|D_WARNING*/
 
-# include <linux/module.h>
-# include <linux/pagemap.h>
-# include <linux/miscdevice.h>
-# include <linux/init.h>
-
+#include <linux/module.h>
 #include <obd_class.h>
 #include <lustre_dlm.h>
 #include <lprocfs_status.h>
 #include <lustre_log.h>
-#include <lustre_fsfilt.h>
 #include <lustre_disk.h>
+#include <dt_object.h>
+
 #include "mgc_internal.h"
 
 static int mgc_name2resid(char *name, int len, struct ldlm_res_id *res_id,
@@ -578,97 +575,175 @@ static void mgc_requeue_add(struct config_llog_data *cld)
 }
 
 /********************** class fns **********************/
+static int mgc_local_llog_init(const struct lu_env *env,
+			       struct obd_device *obd,
+			       struct obd_device *disk)
+{
+	struct llog_ctxt	*ctxt;
+	int			 rc;
+
+	rc = llog_setup(env, obd, &obd->obd_olg, LLOG_CONFIG_ORIG_CTXT, disk,
+			&llog_osd_ops);
+	if (rc)
+		return rc;
+
+	ctxt = llog_get_context(obd, LLOG_CONFIG_ORIG_CTXT);
+	LASSERT(ctxt);
+	ctxt->loc_dir = obd->u.cli.cl_mgc_configs_dir;
+	llog_ctxt_put(ctxt);
 
-static int mgc_fs_setup(struct obd_device *obd, struct super_block *sb,
-			struct vfsmount *mnt)
+	return 0;
+}
+
+static int mgc_local_llog_fini(const struct lu_env *env,
+			       struct obd_device *obd)
 {
-	struct lvfs_run_ctxt saved;
-	struct lustre_sb_info *lsi = s2lsi(sb);
-	struct client_obd *cli = &obd->u.cli;
-	struct dentry *dentry;
-	char *label;
-	int err = 0;
+	struct llog_ctxt *ctxt;
+
+	ctxt = llog_get_context(obd, LLOG_CONFIG_ORIG_CTXT);
+	llog_cleanup(env, ctxt);
+
+	return 0;
+}
+
+static int mgc_fs_setup(struct obd_device *obd, struct super_block *sb)
+{
+	struct lustre_sb_info	*lsi = s2lsi(sb);
+	struct client_obd	*cli = &obd->u.cli;
+	struct lu_fid		 rfid, fid;
+	struct dt_object	*root, *dto;
+	struct lu_env		*env;
+	int			 rc = 0;
 
 	LASSERT(lsi);
-	LASSERT(lsi->lsi_srv_mnt == mnt);
+	LASSERT(lsi->lsi_dt_dev);
+
+	OBD_ALLOC_PTR(env);
+	if (env == NULL)
+		return -ENOMEM;
 
 	/* The mgc fs exclusion sem. Only one fs can be setup at a time. */
 	down(&cli->cl_mgc_sem);
 
 	cfs_cleanup_group_info();
 
-	obd->obd_fsops = fsfilt_get_ops(lsi->lsi_fstype);
-	if (IS_ERR(obd->obd_fsops)) {
-		up(&cli->cl_mgc_sem);
-		CERROR("%s: No fstype %s: rc = %ld\n", lsi->lsi_fstype,
-		       obd->obd_name, PTR_ERR(obd->obd_fsops));
-		return PTR_ERR(obd->obd_fsops);
-	}
+	/* Setup the configs dir */
+	rc = lu_env_init(env, LCT_MG_THREAD);
+	if (rc)
+		GOTO(out_err, rc);
 
-	cli->cl_mgc_vfsmnt = mnt;
-	err = fsfilt_setup(obd, mnt->mnt_sb);
-	if (err)
-		GOTO(err_ops, err);
-
-	OBD_SET_CTXT_MAGIC(&obd->obd_lvfs_ctxt);
-	obd->obd_lvfs_ctxt.pwdmnt = mnt;
-	obd->obd_lvfs_ctxt.pwd = mnt->mnt_root;
-	obd->obd_lvfs_ctxt.fs = get_ds();
-
-	push_ctxt(&saved, &obd->obd_lvfs_ctxt, NULL);
-	dentry = ll_lookup_one_len(MOUNT_CONFIGS_DIR, cfs_fs_pwd(current->fs),
-				   strlen(MOUNT_CONFIGS_DIR));
-	pop_ctxt(&saved, &obd->obd_lvfs_ctxt, NULL);
-	if (IS_ERR(dentry)) {
-		err = PTR_ERR(dentry);
-		CERROR("cannot lookup %s directory: rc = %d\n",
-		       MOUNT_CONFIGS_DIR, err);
-		GOTO(err_ops, err);
-	}
-	cli->cl_mgc_configs_dir = dentry;
+	fid.f_seq = FID_SEQ_LOCAL_NAME;
+	fid.f_oid = 1;
+	fid.f_ver = 0;
+	rc = local_oid_storage_init(env, lsi->lsi_dt_dev, &fid,
+				    &cli->cl_mgc_los);
+	if (rc)
+		GOTO(out_env, rc);
+
+	rc = dt_root_get(env, lsi->lsi_dt_dev, &rfid);
+	if (rc)
+		GOTO(out_env, rc);
+
+	root = dt_locate_at(env, lsi->lsi_dt_dev, &rfid,
+			    &cli->cl_mgc_los->los_dev->dd_lu_dev);
+	if (unlikely(IS_ERR(root)))
+		GOTO(out_los, rc = PTR_ERR(root));
+
+	dto = local_file_find_or_create(env, cli->cl_mgc_los, root,
+					MOUNT_CONFIGS_DIR,
+					S_IFDIR | S_IRUGO | S_IWUSR | S_IXUGO);
+	lu_object_put_nocache(env, &root->do_lu);
+	if (IS_ERR(dto))
+		GOTO(out_los, rc = PTR_ERR(dto));
+
+	cli->cl_mgc_configs_dir = dto;
+
+	LASSERT(lsi->lsi_osd_exp->exp_obd->obd_lvfs_ctxt.dt);
+	rc = mgc_local_llog_init(env, obd, lsi->lsi_osd_exp->exp_obd);
+	if (rc)
+		GOTO(out_llog, rc);
 
 	/* We take an obd ref to insure that we can't get to mgc_cleanup
-	   without calling mgc_fs_cleanup first. */
+	 * without calling mgc_fs_cleanup first. */
 	class_incref(obd, "mgc_fs", obd);
 
-	label = fsfilt_get_label(obd, mnt->mnt_sb);
-	if (label)
-		CDEBUG(D_MGC, "MGC using disk labelled=%s\n", label);
-
 	/* We keep the cl_mgc_sem until mgc_fs_cleanup */
-	return 0;
-
-err_ops:
-	fsfilt_put_ops(obd->obd_fsops);
-	obd->obd_fsops = NULL;
-	cli->cl_mgc_vfsmnt = NULL;
-	up(&cli->cl_mgc_sem);
-	return err;
+out_llog:
+	if (rc) {
+		lu_object_put(env, &cli->cl_mgc_configs_dir->do_lu);
+		cli->cl_mgc_configs_dir = NULL;
+	}
+out_los:
+	if (rc < 0) {
+		local_oid_storage_fini(env, cli->cl_mgc_los);
+		cli->cl_mgc_los = NULL;
+		up(&cli->cl_mgc_sem);
+	}
+out_env:
+	lu_env_fini(env);
+out_err:
+	OBD_FREE_PTR(env);
+	return rc;
 }
 
 static int mgc_fs_cleanup(struct obd_device *obd)
 {
-	struct client_obd *cli = &obd->u.cli;
-	int rc = 0;
+	struct lu_env		 env;
+	struct client_obd	*cli = &obd->u.cli;
+	int			 rc;
 
-	LASSERT(cli->cl_mgc_vfsmnt != NULL);
+	LASSERT(cli->cl_mgc_los != NULL);
 
-	if (cli->cl_mgc_configs_dir != NULL) {
-		struct lvfs_run_ctxt saved;
-		push_ctxt(&saved, &obd->obd_lvfs_ctxt, NULL);
-		l_dput(cli->cl_mgc_configs_dir);
-		cli->cl_mgc_configs_dir = NULL;
-		pop_ctxt(&saved, &obd->obd_lvfs_ctxt, NULL);
-		class_decref(obd, "mgc_fs", obd);
-	}
+	rc = lu_env_init(&env, LCT_MG_THREAD);
+	if (rc)
+		GOTO(unlock, rc);
+
+	mgc_local_llog_fini(&env, obd);
 
-	cli->cl_mgc_vfsmnt = NULL;
-	if (obd->obd_fsops)
-		fsfilt_put_ops(obd->obd_fsops);
+	lu_object_put_nocache(&env, &cli->cl_mgc_configs_dir->do_lu);
+	cli->cl_mgc_configs_dir = NULL;
 
+	local_oid_storage_fini(&env, cli->cl_mgc_los);
+	cli->cl_mgc_los = NULL;
+	lu_env_fini(&env);
+
+unlock:
+	class_decref(obd, "mgc_fs", obd);
 	up(&cli->cl_mgc_sem);
 
-	return rc;
+	return 0;
+}
+
+static int mgc_llog_init(const struct lu_env *env, struct obd_device *obd)
+{
+	struct llog_ctxt	*ctxt;
+	int			 rc;
+
+	/* setup only remote ctxt, the local disk context is switched per each
+	 * filesystem during mgc_fs_setup() */
+	rc = llog_setup(env, obd, &obd->obd_olg, LLOG_CONFIG_REPL_CTXT, obd,
+			&llog_client_ops);
+	if (rc)
+		return rc;
+
+	ctxt = llog_get_context(obd, LLOG_CONFIG_REPL_CTXT);
+	LASSERT(ctxt);
+
+	llog_initiator_connect(ctxt);
+	llog_ctxt_put(ctxt);
+
+	return 0;
+}
+
+static int mgc_llog_fini(const struct lu_env *env, struct obd_device *obd)
+{
+	struct llog_ctxt *ctxt;
+
+	ctxt = llog_get_context(obd, LLOG_CONFIG_REPL_CTXT);
+	if (ctxt)
+		llog_cleanup(env, ctxt);
+
+	return 0;
 }
 
 static atomic_t mgc_count = ATOMIC_INIT(0);
@@ -694,7 +769,7 @@ static int mgc_precleanup(struct obd_device *obd, enum obd_cleanup_stage stage)
 			}
 		}
 		obd_cleanup_client_import(obd);
-		rc = obd_llog_finish(obd, 0);
+		rc = mgc_llog_fini(NULL, obd);
 		if (rc != 0)
 			CERROR("failed to cleanup llogging subsystems\n");
 		break;
@@ -704,11 +779,8 @@ static int mgc_precleanup(struct obd_device *obd, enum obd_cleanup_stage stage)
 
 static int mgc_cleanup(struct obd_device *obd)
 {
-	struct client_obd *cli = &obd->u.cli;
 	int rc;
 
-	LASSERT(cli->cl_mgc_vfsmnt == NULL);
-
 	/* COMPAT_146 - old config logs may have added profiles we don't
 	   know about */
 	if (obd->obd_type->typ_refcnt <= 1)
@@ -733,7 +805,7 @@ static int mgc_setup(struct obd_device *obd, struct lustre_cfg *lcfg)
 	if (rc)
 		GOTO(err_decref, rc);
 
-	rc = obd_llog_init(obd, &obd->obd_olg, obd, NULL);
+	rc = mgc_llog_init(NULL, obd);
 	if (rc) {
 		CERROR("failed to setup llogging subsystems\n");
 		GOTO(err_cleanup, rc);
@@ -1011,11 +1083,11 @@ int mgc_set_info_async(const struct lu_env *env, struct obd_export *exp,
 	}
 	if (KEY_IS(KEY_SET_FS)) {
 		struct super_block *sb = (struct super_block *)val;
-		struct lustre_sb_info *lsi;
+
 		if (vallen != sizeof(struct super_block))
 			return -EINVAL;
-		lsi = s2lsi(sb);
-		rc = mgc_fs_setup(exp->exp_obd, sb, lsi->lsi_srv_mnt);
+
+		rc = mgc_fs_setup(exp->exp_obd, sb);
 		if (rc) {
 			CERROR("set_fs got %d\n", rc);
 		}
@@ -1145,49 +1217,6 @@ static int mgc_import_event(struct obd_device *obd,
 	return rc;
 }
 
-static int mgc_llog_init(struct obd_device *obd, struct obd_llog_group *olg,
-			 struct obd_device *tgt, int *index)
-{
-	struct llog_ctxt *ctxt;
-	int rc;
-
-	LASSERT(olg == &obd->obd_olg);
-
-
-	rc = llog_setup(NULL, obd, olg, LLOG_CONFIG_REPL_CTXT, tgt,
-			&llog_client_ops);
-	if (rc)
-		GOTO(out, rc);
-
-	ctxt = llog_group_get_ctxt(olg, LLOG_CONFIG_REPL_CTXT);
-	if (!ctxt)
-		GOTO(out, rc = -ENODEV);
-
-	llog_initiator_connect(ctxt);
-	llog_ctxt_put(ctxt);
-
-	return 0;
-out:
-	ctxt = llog_get_context(obd, LLOG_CONFIG_ORIG_CTXT);
-	if (ctxt)
-		llog_cleanup(NULL, ctxt);
-	return rc;
-}
-
-static int mgc_llog_finish(struct obd_device *obd, int count)
-{
-	struct llog_ctxt *ctxt;
-
-	ctxt = llog_get_context(obd, LLOG_CONFIG_REPL_CTXT);
-	if (ctxt)
-		llog_cleanup(NULL, ctxt);
-
-	ctxt = llog_get_context(obd, LLOG_CONFIG_ORIG_CTXT);
-	if (ctxt)
-		llog_cleanup(NULL, ctxt);
-	return 0;
-}
-
 enum {
 	CONFIG_READ_NRPAGES_INIT = 1 << (20 - PAGE_CACHE_SHIFT),
 	CONFIG_READ_NRPAGES      = 4
@@ -1540,17 +1569,58 @@ out:
 	return rc;
 }
 
+static int mgc_llog_local_copy(const struct lu_env *env,
+			       struct obd_device *obd,
+			       struct llog_ctxt *rctxt,
+			       struct llog_ctxt *lctxt, char *logname)
+{
+	char	*temp_log;
+	int	 rc;
+
+
+
+	/*
+	 * - copy it to backup using llog_backup()
+	 * - copy remote llog to logname using llog_backup()
+	 * - if failed then move bakup to logname again
+	 */
+
+	OBD_ALLOC(temp_log, strlen(logname) + 1);
+	if (!temp_log)
+		return -ENOMEM;
+	sprintf(temp_log, "%sT", logname);
+
+	/* make a copy of local llog at first */
+	rc = llog_backup(env, obd, lctxt, lctxt, logname, temp_log);
+	if (rc < 0 && rc != -ENOENT)
+		GOTO(out, rc);
+	/* copy remote llog to the local copy */
+	rc = llog_backup(env, obd, rctxt, lctxt, logname, logname);
+	if (rc == -ENOENT) {
+		/* no remote llog, delete local one too */
+		llog_erase(env, lctxt, NULL, logname);
+	} else if (rc < 0) {
+		/* error during backup, get local one back from the copy */
+		llog_backup(env, obd, lctxt, lctxt, temp_log, logname);
+out:
+		CERROR("%s: failed to copy remote log %s: rc = %d\n",
+		       obd->obd_name, logname, rc);
+	}
+	llog_erase(env, lctxt, NULL, temp_log);
+	OBD_FREE(temp_log, strlen(logname) + 1);
+	return rc;
+}
 
 /* local_only means it cannot get remote llogs */
 static int mgc_process_cfg_log(struct obd_device *mgc,
-			       struct config_llog_data *cld,
-			       int local_only)
+			       struct config_llog_data *cld, int local_only)
 {
-	struct llog_ctxt *ctxt, *lctxt = NULL;
-	struct lvfs_run_ctxt *saved_ctxt;
-	struct lustre_sb_info *lsi = NULL;
-	int rc = 0, must_pop = 0;
-	bool sptlrpc_started = false;
+	struct llog_ctxt	*ctxt, *lctxt = NULL;
+	struct dt_object        *cl_mgc_dir = mgc->u.cli.cl_mgc_configs_dir;
+	struct lustre_sb_info	*lsi = NULL;
+	int			 rc = 0;
+	bool			 sptlrpc_started = false;
+	struct lu_env		*env;
 
 	LASSERT(cld);
 	LASSERT(mutex_is_locked(&cld->cld_lock));
@@ -1565,20 +1635,48 @@ static int mgc_process_cfg_log(struct obd_device *mgc,
 	if (cld->cld_cfg.cfg_sb)
 		lsi = s2lsi(cld->cld_cfg.cfg_sb);
 
-	ctxt = llog_get_context(mgc, LLOG_CONFIG_REPL_CTXT);
-	if (!ctxt) {
-		CERROR("missing llog context\n");
-		return -EINVAL;
-	}
-
-	OBD_ALLOC_PTR(saved_ctxt);
-	if (saved_ctxt == NULL)
+	OBD_ALLOC_PTR(env);
+	if (env == NULL)
 		return -ENOMEM;
 
+	rc = lu_env_init(env, LCT_MG_THREAD);
+	if (rc)
+		GOTO(out_free, rc);
+
+	ctxt = llog_get_context(mgc, LLOG_CONFIG_REPL_CTXT);
+	LASSERT(ctxt);
+
 	lctxt = llog_get_context(mgc, LLOG_CONFIG_ORIG_CTXT);
 
-		if (local_only) { /* no local log at client side */
-		GOTO(out_pop, rc = -EIO);
+	/* Copy the setup log locally if we can. Don't mess around if we're
+	 * running an MGS though (logs are already local). */
+	if (lctxt && lsi && IS_SERVER(lsi) && !IS_MGS(lsi) &&
+	    cl_mgc_dir != NULL &&
+	    lu2dt_dev(cl_mgc_dir->do_lu.lo_dev) == lsi->lsi_dt_dev) {
+		if (!local_only)
+			/* Only try to copy log if we have the lock. */
+			rc = mgc_llog_local_copy(env, mgc, ctxt, lctxt,
+						 cld->cld_logname);
+		if (local_only || rc) {
+			if (llog_is_empty(env, lctxt, cld->cld_logname)) {
+				LCONSOLE_ERROR_MSG(0x13a,
+						   "Failed to get MGS log %s and no local copy.\n",
+						   cld->cld_logname);
+				GOTO(out_pop, rc = -ENOTCONN);
+			}
+			CDEBUG(D_MGC,
+			       "Failed to get MGS log %s, using local copy for now, will try to update later.\n",
+			       cld->cld_logname);
+		}
+		/* Now, whether we copied or not, start using the local llog.
+		 * If we failed to copy, we'll start using whatever the old
+		 * log has. */
+		llog_ctxt_put(ctxt);
+		ctxt = lctxt;
+		lctxt = NULL;
+	} else {
+		if (local_only) /* no local log at client side */
+			GOTO(out_pop, rc = -EIO);
 	}
 
 	if (cld_is_sptlrpc(cld)) {
@@ -1587,19 +1685,16 @@ static int mgc_process_cfg_log(struct obd_device *mgc,
 	}
 
 	/* logname and instance info should be the same, so use our
-	   copy of the instance for the update.  The cfg_last_idx will
-	   be updated here. */
-	rc = class_config_parse_llog(NULL, ctxt, cld->cld_logname,
+	 * copy of the instance for the update.  The cfg_last_idx will
+	 * be updated here. */
+	rc = class_config_parse_llog(env, ctxt, cld->cld_logname,
 				     &cld->cld_cfg);
 
 out_pop:
-	llog_ctxt_put(ctxt);
+	__llog_ctxt_put(env, ctxt);
 	if (lctxt)
-		llog_ctxt_put(lctxt);
-	if (must_pop)
-		pop_ctxt(saved_ctxt, &mgc->obd_lvfs_ctxt, NULL);
+		__llog_ctxt_put(env, lctxt);
 
-	OBD_FREE_PTR(saved_ctxt);
 	/*
 	 * update settings on existing OBDs. doing it inside
 	 * of llog_process_lock so no device is attaching/detaching
@@ -1614,6 +1709,9 @@ out_pop:
 					  strlen("-sptlrpc"));
 	}
 
+	lu_env_fini(env);
+out_free:
+	OBD_FREE_PTR(env);
 	return rc;
 }
 
@@ -1801,8 +1899,6 @@ struct obd_ops mgc_obd_ops = {
 	.o_set_info_async = mgc_set_info_async,
 	.o_get_info       = mgc_get_info,
 	.o_import_event = mgc_import_event,
-	.o_llog_init    = mgc_llog_init,
-	.o_llog_finish  = mgc_llog_finish,
 	.o_process_config = mgc_process_config,
 };
 
diff --git a/drivers/staging/lustre/lustre/obdclass/llog.c b/drivers/staging/lustre/lustre/obdclass/llog.c
index b4dad34..e0dfb08 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog.c
@@ -265,31 +265,6 @@ out:
 }
 EXPORT_SYMBOL(llog_init_handle);
 
-int llog_copy_handler(const struct lu_env *env,
-		      struct llog_handle *llh,
-		      struct llog_rec_hdr *rec,
-		      void *data)
-{
-	struct llog_rec_hdr local_rec = *rec;
-	struct llog_handle *local_llh = (struct llog_handle *)data;
-	char *cfg_buf = (char*) (rec + 1);
-	struct lustre_cfg *lcfg;
-	int rc = 0;
-
-	/* Append all records */
-	local_rec.lrh_len -= sizeof(*rec) + sizeof(struct llog_rec_tail);
-	rc = llog_write(env, local_llh, &local_rec, NULL, 0,
-			(void *)cfg_buf, -1);
-
-	lcfg = (struct lustre_cfg *)cfg_buf;
-	CDEBUG(D_INFO, "idx=%d, rc=%d, len=%d, cmd %x %s %s\n",
-	       rec->lrh_index, rc, rec->lrh_len, lcfg->lcfg_command,
-	       lustre_cfg_string(lcfg, 0), lustre_cfg_string(lcfg, 1));
-
-	return rc;
-}
-EXPORT_SYMBOL(llog_copy_handler);
-
 static int llog_process_thread(void *arg)
 {
 	struct llog_process_info	*lpi = arg;
@@ -493,14 +468,6 @@ int llog_process(const struct lu_env *env, struct llog_handle *loghandle,
 }
 EXPORT_SYMBOL(llog_process);
 
-inline int llog_get_size(struct llog_handle *loghandle)
-{
-	if (loghandle && loghandle->lgh_hdr)
-		return loghandle->lgh_hdr->llh_count;
-	return 0;
-}
-EXPORT_SYMBOL(llog_get_size);
-
 int llog_reverse_process(const struct lu_env *env,
 			 struct llog_handle *loghandle, llog_cb_t cb,
 			 void *data, void *catdata)
@@ -767,8 +734,9 @@ int llog_open_create(const struct lu_env *env, struct llog_ctxt *ctxt,
 		     struct llog_handle **res, struct llog_logid *logid,
 		     char *name)
 {
-	struct thandle	*th;
-	int		 rc;
+	struct dt_device	*d;
+	struct thandle		*th;
+	int			 rc;
 
 	rc = llog_open(env, ctxt, res, logid, name, LLOG_OPEN_NEW);
 	if (rc)
@@ -777,27 +745,21 @@ int llog_open_create(const struct lu_env *env, struct llog_ctxt *ctxt,
 	if (llog_exist(*res))
 		return 0;
 
-	if ((*res)->lgh_obj != NULL) {
-		struct dt_device *d;
+	LASSERT((*res)->lgh_obj != NULL);
 
-		d = lu2dt_dev((*res)->lgh_obj->do_lu.lo_dev);
+	d = lu2dt_dev((*res)->lgh_obj->do_lu.lo_dev);
 
-		th = dt_trans_create(env, d);
-		if (IS_ERR(th))
-			GOTO(out, rc = PTR_ERR(th));
+	th = dt_trans_create(env, d);
+	if (IS_ERR(th))
+		GOTO(out, rc = PTR_ERR(th));
 
-		rc = llog_declare_create(env, *res, th);
-		if (rc == 0) {
-			rc = dt_trans_start_local(env, d, th);
-			if (rc == 0)
-				rc = llog_create(env, *res, th);
-		}
-		dt_trans_stop(env, d, th);
-	} else {
-		/* lvfs compat code */
-		LASSERT((*res)->lgh_file == NULL);
-		rc = llog_create(env, *res, NULL);
+	rc = llog_declare_create(env, *res, th);
+	if (rc == 0) {
+		rc = dt_trans_start_local(env, d, th);
+		if (rc == 0)
+			rc = llog_create(env, *res, th);
 	}
+	dt_trans_stop(env, d, th);
 out:
 	if (rc)
 		llog_close(env, *res);
@@ -842,41 +804,34 @@ int llog_write(const struct lu_env *env, struct llog_handle *loghandle,
 	       struct llog_rec_hdr *rec, struct llog_cookie *reccookie,
 	       int cookiecount, void *buf, int idx)
 {
-	int rc;
+	struct dt_device	*dt;
+	struct thandle		*th;
+	int			 rc;
 
 	LASSERT(loghandle);
 	LASSERT(loghandle->lgh_ctxt);
+	LASSERT(loghandle->lgh_obj != NULL);
 
-	if (loghandle->lgh_obj != NULL) {
-		struct dt_device	*dt;
-		struct thandle		*th;
-
-		dt = lu2dt_dev(loghandle->lgh_obj->do_lu.lo_dev);
+	dt = lu2dt_dev(loghandle->lgh_obj->do_lu.lo_dev);
 
-		th = dt_trans_create(env, dt);
-		if (IS_ERR(th))
-			return PTR_ERR(th);
+	th = dt_trans_create(env, dt);
+	if (IS_ERR(th))
+		return PTR_ERR(th);
 
-		rc = llog_declare_write_rec(env, loghandle, rec, idx, th);
-		if (rc)
-			GOTO(out_trans, rc);
+	rc = llog_declare_write_rec(env, loghandle, rec, idx, th);
+	if (rc)
+		GOTO(out_trans, rc);
 
-		rc = dt_trans_start_local(env, dt, th);
-		if (rc)
-			GOTO(out_trans, rc);
+	rc = dt_trans_start_local(env, dt, th);
+	if (rc)
+		GOTO(out_trans, rc);
 
-		down_write(&loghandle->lgh_lock);
-		rc = llog_write_rec(env, loghandle, rec, reccookie,
-				    cookiecount, buf, idx, th);
-		up_write(&loghandle->lgh_lock);
+	down_write(&loghandle->lgh_lock);
+	rc = llog_write_rec(env, loghandle, rec, reccookie,
+			    cookiecount, buf, idx, th);
+	up_write(&loghandle->lgh_lock);
 out_trans:
-		dt_trans_stop(env, dt, th);
-	} else { /* lvfs compatibility */
-		down_write(&loghandle->lgh_lock);
-		rc = llog_write_rec(env, loghandle, rec, reccookie,
-				    cookiecount, buf, idx, NULL);
-		up_write(&loghandle->lgh_lock);
-	}
+	dt_trans_stop(env, dt, th);
 	return rc;
 }
 EXPORT_SYMBOL(llog_write);
@@ -932,3 +887,104 @@ out:
 	return rc;
 }
 EXPORT_SYMBOL(llog_close);
+
+int llog_is_empty(const struct lu_env *env, struct llog_ctxt *ctxt,
+		  char *name)
+{
+	struct llog_handle	*llh;
+	int			 rc = 0;
+
+	rc = llog_open(env, ctxt, &llh, NULL, name, LLOG_OPEN_EXISTS);
+	if (rc < 0) {
+		if (likely(rc == -ENOENT))
+			rc = 0;
+		GOTO(out, rc);
+	}
+
+	rc = llog_init_handle(env, llh, LLOG_F_IS_PLAIN, NULL);
+	if (rc)
+		GOTO(out_close, rc);
+	rc = llog_get_size(llh);
+
+out_close:
+	llog_close(env, llh);
+out:
+	/* header is record 1 */
+	return rc <= 1;
+}
+EXPORT_SYMBOL(llog_is_empty);
+
+int llog_copy_handler(const struct lu_env *env, struct llog_handle *llh,
+		      struct llog_rec_hdr *rec, void *data)
+{
+	struct llog_handle	*copy_llh = data;
+
+	/* Append all records */
+	return llog_write(env, copy_llh, rec, NULL, 0, NULL, -1);
+}
+EXPORT_SYMBOL(llog_copy_handler);
+
+/* backup plain llog */
+int llog_backup(const struct lu_env *env, struct obd_device *obd,
+		struct llog_ctxt *ctxt, struct llog_ctxt *bctxt,
+		char *name, char *backup)
+{
+	struct llog_handle	*llh, *bllh;
+	int			 rc;
+
+
+
+	/* open original log */
+	rc = llog_open(env, ctxt, &llh, NULL, name, LLOG_OPEN_EXISTS);
+	if (rc < 0) {
+		/* the -ENOENT case is also reported to the caller
+		 * but silently so it should handle that if needed.
+		 */
+		if (rc != -ENOENT)
+			CERROR("%s: failed to open log %s: rc = %d\n",
+			       obd->obd_name, name, rc);
+		return rc;
+	}
+
+	rc = llog_init_handle(env, llh, LLOG_F_IS_PLAIN, NULL);
+	if (rc)
+		GOTO(out_close, rc);
+
+	/* Make sure there's no old backup log */
+	rc = llog_erase(env, bctxt, NULL, backup);
+	if (rc < 0 && rc != -ENOENT)
+		GOTO(out_close, rc);
+
+	/* open backup log */
+	rc = llog_open_create(env, bctxt, &bllh, NULL, backup);
+	if (rc) {
+		CERROR("%s: failed to open backup logfile %s: rc = %d\n",
+		       obd->obd_name, backup, rc);
+		GOTO(out_close, rc);
+	}
+
+	/* check that backup llog is not the same object as original one */
+	if (llh->lgh_obj == bllh->lgh_obj) {
+		CERROR("%s: backup llog %s to itself (%s), objects %p/%p\n",
+		       obd->obd_name, name, backup, llh->lgh_obj,
+		       bllh->lgh_obj);
+		GOTO(out_backup, rc = -EEXIST);
+	}
+
+	rc = llog_init_handle(env, bllh, LLOG_F_IS_PLAIN, NULL);
+	if (rc)
+		GOTO(out_backup, rc);
+
+	/* Copy log record by record */
+	rc = llog_process_or_fork(env, llh, llog_copy_handler, (void *)bllh,
+				  NULL, false);
+	if (rc)
+		CERROR("%s: failed to backup log %s: rc = %d\n",
+		       obd->obd_name, name, rc);
+out_backup:
+	llog_close(env, bllh);
+out_close:
+	llog_close(env, llh);
+	return rc;
+}
+EXPORT_SYMBOL(llog_backup);
diff --git a/drivers/staging/lustre/lustre/obdclass/local_storage.c b/drivers/staging/lustre/lustre/obdclass/local_storage.c
index 51ab7f4..e79e4be 100644
--- a/drivers/staging/lustre/lustre/obdclass/local_storage.c
+++ b/drivers/staging/lustre/lustre/obdclass/local_storage.c
@@ -855,9 +855,12 @@ out_los:
 		(*los)->los_seq = fid_seq(first_fid);
 		(*los)->los_last_oid = le64_to_cpu(lastid);
 		(*los)->los_obj = o;
-		/* read value should not be less than initial one */
-		LASSERTF((*los)->los_last_oid >= first_oid, "%u < %u\n",
-			 (*los)->los_last_oid, first_oid);
+		/* Read value should not be less than initial one
+		 * but possible after upgrade from older fs.
+		 * In this case just switch to the first_oid in memory and
+		 * it will be updated on disk with first object generated */
+		if ((*los)->los_last_oid < first_oid)
+			(*los)->los_last_oid = first_oid;
 	}
 out:
 	mutex_unlock(&ls->ls_los_mutex);
diff --git a/drivers/staging/lustre/lustre/obdclass/local_storage.h b/drivers/staging/lustre/lustre/obdclass/local_storage.h
index d553c37..0f63b8c 100644
--- a/drivers/staging/lustre/lustre/obdclass/local_storage.h
+++ b/drivers/staging/lustre/lustre/obdclass/local_storage.h
@@ -29,6 +29,8 @@
  *
  * Author: Mikhail Pershin <mike.pershin@intel.com>
  */
+#ifndef __LOCAL_STORAGE_H
+#define __LOCAL_STORAGE_H
 
 #include <dt_object.h>
 #include <obd.h>
@@ -86,3 +88,4 @@ struct los_ondisk {
 };
 
 #define LOS_MAGIC	0xdecafbee
+#endif
diff --git a/drivers/staging/lustre/lustre/obdclass/lu_object.c b/drivers/staging/lustre/lustre/obdclass/lu_object.c
index 1d6754b..9887d8f 100644
--- a/drivers/staging/lustre/lustre/obdclass/lu_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/lu_object.c
@@ -429,7 +429,7 @@ LU_KEY_INIT_FINI(lu_global, struct lu_cdebug_data);
  */
 struct lu_context_key lu_global_key = {
 	.lct_tags = LCT_MD_THREAD | LCT_DT_THREAD |
-		    LCT_MG_THREAD | LCT_CL_THREAD,
+		    LCT_MG_THREAD | LCT_CL_THREAD | LCT_LOCAL,
 	.lct_init = lu_global_key_init,
 	.lct_fini = lu_global_key_fini
 };
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_mount.c b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
index 68a4d6a..a69a630 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_mount.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
@@ -631,6 +631,9 @@ int lustre_put_lsi(struct super_block *sb)
 	CDEBUG(D_MOUNT, "put %p %d\n", sb, atomic_read(&lsi->lsi_mounts));
 	if (atomic_dec_and_test(&lsi->lsi_mounts)) {
 		if (IS_SERVER(lsi) && lsi->lsi_osd_exp) {
+			lu_device_put(&lsi->lsi_dt_dev->dd_lu_dev);
+			lsi->lsi_osd_exp->exp_obd->obd_lvfs_ctxt.dt = NULL;
+			lsi->lsi_dt_dev = NULL;
 			obd_disconnect(lsi->lsi_osd_exp);
 			/* wait till OSD is gone */
 			obd_zombie_barrier();
-- 
1.7.9.5

