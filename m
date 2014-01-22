Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbaAVNho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:37:44 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39179 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708AbaAVNhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:37:40 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Artem Blagodarenko <artem_blagodarenko@xyratex.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v2 RESEND 5/8] staging/lustre/mgs: set_param -P option that sets value permanently
Date: Wed, 22 Jan 2014 21:36:16 +0800
Message-Id: <1390397779-30975-6-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390397779-30975-1-git-send-email-bergwolf@gmail.com>
References: <1390397779-30975-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Blagodarenko <artem_blagodarenko@xyratex.com>

set_param and conf_param have different syntaxes. Also conf_param
has unimplemented paths and no wildcarding support.

This patch adds set_param -P option, that replaces the whole
conf_param "direct" proc access with a simple upcall-type mechanism
from the MGC. Option conf_param is saved now for compatibility.

Part of the original Lustre commit changes server code.
The patch only picks up client side change.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3155
Lustre-change: http://review.whamcloud.com/6025
Signed-off-by: Artem Blagodarenko <artem_blagodarenko@xyratex.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Emoly Liu <emoly.liu@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_cfg.h |    2 +
 .../staging/lustre/lustre/include/lustre_disk.h    |    2 +
 drivers/staging/lustre/lustre/include/obd_class.h  |    9 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |    5 +-
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |   90 +++++++++++++++++---
 .../staging/lustre/lustre/obdclass/obd_config.c    |   47 +++++++++-
 6 files changed, 136 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_cfg.h b/drivers/staging/lustre/lustre/include/lustre_cfg.h
index e14a5f6..3680668 100644
--- a/drivers/staging/lustre/lustre/include/lustre_cfg.h
+++ b/drivers/staging/lustre/lustre/include/lustre_cfg.h
@@ -88,6 +88,8 @@ enum lcfg_command_type {
 	LCFG_SET_LDLM_TIMEOUT   = 0x00ce030, /**< set ldlm_timeout */
 	LCFG_PRE_CLEANUP	= 0x00cf031, /**< call type-specific pre
 					      * cleanup cleanup */
+	LCFG_SET_PARAM		= 0x00ce032, /**< use set_param syntax to set
+					      *a proc parameters */
 };
 
 struct lustre_cfg_bufs {
diff --git a/drivers/staging/lustre/lustre/include/lustre_disk.h b/drivers/staging/lustre/lustre/include/lustre_disk.h
index 1de9a8b..ac08164 100644
--- a/drivers/staging/lustre/lustre/include/lustre_disk.h
+++ b/drivers/staging/lustre/lustre/include/lustre_disk.h
@@ -99,6 +99,8 @@
 #define LDD_F_IR_CAPABLE    0x2000
 /** the MGS refused to register the target. */
 #define LDD_F_ERROR	 0x4000
+/** process at lctl conf_param */
+#define LDD_F_PARAM2		0x8000
 
 /* opc for target register */
 #define LDD_F_OPC_REG   0x10000000
diff --git a/drivers/staging/lustre/lustre/include/obd_class.h b/drivers/staging/lustre/lustre/include/obd_class.h
index 983718f..1c2ba19 100644
--- a/drivers/staging/lustre/lustre/include/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/obd_class.h
@@ -175,9 +175,13 @@ enum {
 	CONFIG_T_CONFIG  = 0,
 	CONFIG_T_SPTLRPC = 1,
 	CONFIG_T_RECOVER = 2,
-	CONFIG_T_MAX     = 3
+	CONFIG_T_PARAMS  = 3,
+	CONFIG_T_MAX     = 4
 };
 
+#define PARAMS_FILENAME	"params"
+#define LCTL_UPCALL	"lctl"
+
 /* list of active configuration logs  */
 struct config_llog_data {
 	struct ldlm_res_id	  cld_resid;
@@ -185,7 +189,8 @@ struct config_llog_data {
 	struct list_head		  cld_list_chain;
 	atomic_t		cld_refcount;
 	struct config_llog_data    *cld_sptlrpc;/* depended sptlrpc log */
-	struct config_llog_data    *cld_recover;    /* imperative recover log */
+	struct config_llog_data	   *cld_params;	/* common parameters log */
+	struct config_llog_data    *cld_recover;/* imperative recover log */
 	struct obd_export	  *cld_mgcexp;
 	struct mutex		    cld_lock;
 	int			 cld_type;
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 70a6808..3e4c292 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1060,7 +1060,7 @@ out_free:
 
 void ll_put_super(struct super_block *sb)
 {
-	struct config_llog_instance cfg;
+	struct config_llog_instance cfg, params_cfg;
 	struct obd_device *obd;
 	struct lustre_sb_info *lsi = s2lsi(sb);
 	struct ll_sb_info *sbi = ll_s2sbi(sb);
@@ -1074,6 +1074,9 @@ void ll_put_super(struct super_block *sb)
 	cfg.cfg_instance = sb;
 	lustre_end_log(sb, profilenm, &cfg);
 
+	params_cfg.cfg_instance = sb;
+	lustre_end_log(sb, PARAMS_FILENAME, &params_cfg);
+
 	if (sbi->ll_md_exp) {
 		obd = class_exp2obd(sbi->ll_md_exp);
 		if (obd)
diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index b323820..4d2f6d2 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -56,7 +56,7 @@ static int mgc_name2resid(char *name, int len, struct ldlm_res_id *res_id,
 {
 	__u64 resname = 0;
 
-	if (len > 8) {
+	if (len > sizeof(resname)) {
 		CERROR("name too long: %s\n", name);
 		return -EINVAL;
 	}
@@ -76,6 +76,7 @@ static int mgc_name2resid(char *name, int len, struct ldlm_res_id *res_id,
 		resname = 0;
 		break;
 	case CONFIG_T_RECOVER:
+	case CONFIG_T_PARAMS:
 		resname = type;
 		break;
 	default:
@@ -101,10 +102,13 @@ int mgc_logname2resid(char *logname, struct ldlm_res_id *res_id, int type)
 	int len;
 
 	/* logname consists of "fsname-nodetype".
-	 * e.g. "lustre-MDT0001", "SUN-000-client" */
+	 * e.g. "lustre-MDT0001", "SUN-000-client"
+	 * there is an exception: llog "params" */
 	name_end = strrchr(logname, '-');
-	LASSERT(name_end);
-	len = name_end - logname;
+	if (!name_end)
+		len = strlen(logname);
+	else
+		len = name_end - logname;
 	return mgc_name2resid(logname, len, res_id, type);
 }
 
@@ -140,6 +144,8 @@ static void config_log_put(struct config_llog_data *cld)
 			config_log_put(cld->cld_recover);
 		if (cld->cld_sptlrpc)
 			config_log_put(cld->cld_sptlrpc);
+		if (cld->cld_params)
+			config_log_put(cld->cld_params);
 		if (cld_is_sptlrpc(cld))
 			sptlrpc_conf_log_stop(cld->cld_logname);
 
@@ -271,6 +277,19 @@ static struct config_llog_data *config_recover_log_add(struct obd_device *obd,
 	return cld;
 }
 
+static struct config_llog_data *config_params_log_add(struct obd_device *obd,
+	struct config_llog_instance *cfg, struct super_block *sb)
+{
+	struct config_llog_instance	lcfg = *cfg;
+	struct config_llog_data		*cld;
+
+	lcfg.cfg_instance = sb;
+
+	cld = do_config_log_add(obd, PARAMS_FILENAME, CONFIG_T_PARAMS,
+				&lcfg, sb);
+
+	return cld;
+}
 
 /** Add this log to the list of active logs watched by an MGC.
  * Active means we're watching for updates.
@@ -284,8 +303,10 @@ static int config_log_add(struct obd_device *obd, char *logname,
 	struct lustre_sb_info *lsi = s2lsi(sb);
 	struct config_llog_data *cld;
 	struct config_llog_data *sptlrpc_cld;
-	char		     seclogname[32];
-	char		    *ptr;
+	struct config_llog_data *params_cld;
+	char			seclogname[32];
+	char			*ptr;
+	int			rc;
 
 	CDEBUG(D_MGC, "adding config log %s:%p\n", logname, cfg->cfg_instance);
 
@@ -308,32 +329,49 @@ static int config_log_add(struct obd_device *obd, char *logname,
 						CONFIG_T_SPTLRPC, NULL, NULL);
 		if (IS_ERR(sptlrpc_cld)) {
 			CERROR("can't create sptlrpc log: %s\n", seclogname);
-			return PTR_ERR(sptlrpc_cld);
+			GOTO(out_err, rc = PTR_ERR(sptlrpc_cld));
 		}
 	}
+	params_cld = config_params_log_add(obd, cfg, sb);
+	if (IS_ERR(params_cld)) {
+		rc = PTR_ERR(params_cld);
+		CERROR("%s: can't create params log: rc = %d\n",
+		       obd->obd_name, rc);
+		GOTO(out_err1, rc);
+	}
 
 	cld = do_config_log_add(obd, logname, CONFIG_T_CONFIG, cfg, sb);
 	if (IS_ERR(cld)) {
 		CERROR("can't create log: %s\n", logname);
-		config_log_put(sptlrpc_cld);
-		return PTR_ERR(cld);
+		GOTO(out_err2, rc = PTR_ERR(cld));
 	}
 
 	cld->cld_sptlrpc = sptlrpc_cld;
+	cld->cld_params = params_cld;
 
 	LASSERT(lsi->lsi_lmd);
 	if (!(lsi->lsi_lmd->lmd_flags & LMD_FLG_NOIR)) {
 		struct config_llog_data *recover_cld;
 		*strrchr(seclogname, '-') = 0;
 		recover_cld = config_recover_log_add(obd, seclogname, cfg, sb);
-		if (IS_ERR(recover_cld)) {
-			config_log_put(cld);
-			return PTR_ERR(recover_cld);
-		}
+		if (IS_ERR(recover_cld))
+			GOTO(out_err3, rc = PTR_ERR(recover_cld));
 		cld->cld_recover = recover_cld;
 	}
 
 	return 0;
+
+out_err3:
+	config_log_put(cld);
+
+out_err2:
+	config_log_put(params_cld);
+
+out_err1:
+	config_log_put(sptlrpc_cld);
+
+out_err:
+	return rc;
 }
 
 DEFINE_MUTEX(llog_process_lock);
@@ -344,6 +382,7 @@ static int config_log_end(char *logname, struct config_llog_instance *cfg)
 {
 	struct config_llog_data *cld;
 	struct config_llog_data *cld_sptlrpc = NULL;
+	struct config_llog_data *cld_params = NULL;
 	struct config_llog_data *cld_recover = NULL;
 	int rc = 0;
 
@@ -382,11 +421,20 @@ static int config_log_end(char *logname, struct config_llog_instance *cfg)
 	spin_lock(&config_list_lock);
 	cld_sptlrpc = cld->cld_sptlrpc;
 	cld->cld_sptlrpc = NULL;
+	cld_params = cld->cld_params;
+	cld->cld_params = NULL;
 	spin_unlock(&config_list_lock);
 
 	if (cld_sptlrpc)
 		config_log_put(cld_sptlrpc);
 
+	if (cld_params) {
+		mutex_lock(&cld_params->cld_lock);
+		cld_params->cld_stopping = 1;
+		mutex_unlock(&cld_params->cld_lock);
+		config_log_put(cld_params);
+	}
+
 	/* drop the ref from the find */
 	config_log_put(cld);
 	/* drop the start ref */
@@ -1664,7 +1712,7 @@ static int mgc_process_cfg_log(struct obd_device *mgc,
 				LCONSOLE_ERROR_MSG(0x13a,
 						   "Failed to get MGS log %s and no local copy.\n",
 						   cld->cld_logname);
-				GOTO(out_pop, rc = -ENOTCONN);
+				GOTO(out_pop, rc = -ENOENT);
 			}
 			CDEBUG(D_MGC,
 			       "Failed to get MGS log %s, using local copy for now, will try to update later.\n",
@@ -1863,6 +1911,20 @@ static int mgc_process_config(struct obd_device *obd, obd_count len, void *buf)
 			if (rc)
 				CERROR("Cannot process recover llog %d\n", rc);
 		}
+
+		if (rc == 0 && cld->cld_params != NULL) {
+			rc = mgc_process_log(obd, cld->cld_params);
+			if (rc == -ENOENT) {
+				CDEBUG(D_MGC,
+				       "There is no params config file yet\n");
+				rc = 0;
+			}
+			/* params log is optional */
+			if (rc)
+				CERROR(
+				       "%s: can't process params llog: rc = %d\n",
+				       obd->obd_name, rc);
+		}
 		config_log_put(cld);
 
 		break;
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_config.c b/drivers/staging/lustre/lustre/obdclass/obd_config.c
index 362ae54..27f56c0 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_config.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_config.c
@@ -1027,6 +1027,46 @@ struct lustre_cfg *lustre_cfg_rename(struct lustre_cfg *cfg,
 }
 EXPORT_SYMBOL(lustre_cfg_rename);
 
+static int process_param2_config(struct lustre_cfg *lcfg)
+{
+	char *param = lustre_cfg_string(lcfg, 1);
+	char *upcall = lustre_cfg_string(lcfg, 2);
+	char *argv[] = {
+		[0] = "/usr/sbin/lctl",
+		[1] = "set_param",
+		[2] = param,
+		[3] = NULL
+	};
+	struct timeval	start;
+	struct timeval	end;
+	int		rc;
+
+
+	/* Add upcall processing here. Now only lctl is supported */
+	if (strcmp(upcall, LCTL_UPCALL) != 0) {
+		CERROR("Unsupported upcall %s\n", upcall);
+		return -EINVAL;
+	}
+
+	do_gettimeofday(&start);
+	rc = USERMODEHELPER(argv[0], argv, NULL);
+	do_gettimeofday(&end);
+
+	if (rc < 0) {
+		CERROR(
+		       "lctl: error invoking upcall %s %s %s: rc = %d; time %ldus\n",
+		       argv[0], argv[1], argv[2], rc,
+		       cfs_timeval_sub(&end, &start, NULL));
+	} else {
+		CDEBUG(D_HA, "lctl: invoked upcall %s %s %s, time %ldus\n",
+		       argv[0], argv[1], argv[2],
+		       cfs_timeval_sub(&end, &start, NULL));
+		       rc = 0;
+	}
+
+	return rc;
+}
+
 void lustre_register_quota_process_config(int (*qpc)(struct lustre_cfg *lcfg))
 {
 	quota_process_config = qpc;
@@ -1142,11 +1182,14 @@ int class_process_config(struct lustre_cfg *lcfg)
 			err = (*quota_process_config)(lcfg);
 			GOTO(out, err);
 		}
-		/* Fall through */
+
 		break;
 	}
+	case LCFG_SET_PARAM: {
+		err = process_param2_config(lcfg);
+		GOTO(out, 0);
+	}
 	}
-
 	/* Commands that require a device */
 	obd = class_name2obd(lustre_cfg_string(lcfg, 0));
 	if (obd == NULL) {
-- 
1.7.9.5

