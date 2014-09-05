Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaIEUKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:10:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:1261 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaIEUKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:10:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,474,1406617200"; 
   d="scan'208";a="475552925"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 10/12] staging/lustre/ptlrpc: remove sptlrpc_conf_target_get_rules()
Date: Fri, 5 Sep 2014 15:08:16 -0500
Message-ID: <1409947698-30781-11-git-send-email-john.hammond@intel.com>
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

Remove the unused function sptlrpc_conf_target_get_rules() and its
supporting functions.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_sec.h |    3 -
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c  |  327 --------------------
 2 files changed, 330 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_sec.h b/drivers/staging/lustre/lustre/include/lustre_sec.h
index c4669e2..dff70a5 100644
--- a/drivers/staging/lustre/lustre/include/lustre_sec.h
+++ b/drivers/staging/lustre/lustre/include/lustre_sec.h
@@ -347,9 +347,6 @@ void sptlrpc_conf_log_stop(const char *logname);
 void sptlrpc_conf_log_update_begin(const char *logname);
 void sptlrpc_conf_log_update_end(const char *logname);
 void sptlrpc_conf_client_adapt(struct obd_device *obd);
-int  sptlrpc_conf_target_get_rules(struct obd_device *obd,
-				   struct sptlrpc_rule_set *rset,
-				   int initial);
 void sptlrpc_target_choose_flavor(struct sptlrpc_rule_set *rset,
 				  enum lustre_sec_part from,
 				  lnet_nid_t nid,
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
index c9e9da7..56ba9e4 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
@@ -41,13 +41,8 @@
 #include <linux/key.h>
 
 #include "../include/obd.h"
-#include "../include/obd_class.h"
 #include "../include/obd_support.h"
-#include "../include/lustre_net.h"
 #include "../include/lustre_import.h"
-#include "../include/lustre_log.h"
-#include "../include/lustre_disk.h"
-#include "../include/lustre_dlm.h"
 #include "../include/lustre_param.h"
 #include "../include/lustre_sec.h"
 
@@ -450,46 +445,6 @@ void sptlrpc_rule_set_dump(struct sptlrpc_rule_set *rset)
 }
 EXPORT_SYMBOL(sptlrpc_rule_set_dump);
 
-static int sptlrpc_rule_set_extract(struct sptlrpc_rule_set *gen,
-				    struct sptlrpc_rule_set *tgt,
-				    enum lustre_sec_part from,
-				    enum lustre_sec_part to,
-				    struct sptlrpc_rule_set *rset)
-{
-	struct sptlrpc_rule_set *src[2] = { gen, tgt };
-	struct sptlrpc_rule     *rule;
-	int		      i, n, rc;
-
-	might_sleep();
-
-	/* merge general rules firstly, then target-specific rules */
-	for (i = 0; i < 2; i++) {
-		if (src[i] == NULL)
-			continue;
-
-		for (n = 0; n < src[i]->srs_nrule; n++) {
-			rule = &src[i]->srs_rules[n];
-
-			if (from != LUSTRE_SP_ANY &&
-			    rule->sr_from != LUSTRE_SP_ANY &&
-			    rule->sr_from != from)
-				continue;
-			if (to != LUSTRE_SP_ANY &&
-			    rule->sr_to != LUSTRE_SP_ANY &&
-			    rule->sr_to != to)
-				continue;
-
-			rc = sptlrpc_rule_set_merge(rset, rule);
-			if (rc) {
-				CERROR("can't merge: %d\n", rc);
-				return rc;
-			}
-		}
-	}
-
-	return 0;
-}
-
 /**********************************
  * sptlrpc configuration support  *
  **********************************/
@@ -927,288 +882,6 @@ void sptlrpc_conf_client_adapt(struct obd_device *obd)
 }
 EXPORT_SYMBOL(sptlrpc_conf_client_adapt);
 
-
-static void rule2string(struct sptlrpc_rule *r, char *buf, int buflen)
-{
-	char    dirbuf[8];
-	char   *net;
-	char   *ptr = buf;
-
-	if (r->sr_netid == LNET_NIDNET(LNET_NID_ANY))
-		net = "default";
-	else
-		net = libcfs_net2str(r->sr_netid);
-
-	if (r->sr_from == LUSTRE_SP_ANY && r->sr_to == LUSTRE_SP_ANY)
-		dirbuf[0] = '\0';
-	else
-		snprintf(dirbuf, sizeof(dirbuf), ".%s2%s",
-			 sptlrpc_part2name(r->sr_from),
-			 sptlrpc_part2name(r->sr_to));
-
-	ptr += snprintf(buf, buflen, "srpc.flavor.%s%s=", net, dirbuf);
-
-	sptlrpc_flavor2name(&r->sr_flvr, ptr, buflen - (ptr - buf));
-	buf[buflen - 1] = '\0';
-}
-
-static int sptlrpc_record_rule_set(struct llog_handle *llh,
-				   char *target,
-				   struct sptlrpc_rule_set *rset)
-{
-	struct lustre_cfg_bufs  bufs;
-	struct lustre_cfg      *lcfg;
-	struct llog_rec_hdr     rec;
-	int		     buflen;
-	char		    param[48];
-	int		     i, rc;
-
-	for (i = 0; i < rset->srs_nrule; i++) {
-		rule2string(&rset->srs_rules[i], param, sizeof(param));
-
-		lustre_cfg_bufs_reset(&bufs, NULL);
-		lustre_cfg_bufs_set_string(&bufs, 1, target);
-		lustre_cfg_bufs_set_string(&bufs, 2, param);
-		lcfg = lustre_cfg_new(LCFG_SPTLRPC_CONF, &bufs);
-		LASSERT(lcfg);
-
-		buflen = lustre_cfg_len(lcfg->lcfg_bufcount,
-					lcfg->lcfg_buflens);
-		rec.lrh_len = llog_data_len(buflen);
-		rec.lrh_type = OBD_CFG_REC;
-		rc = llog_write(NULL, llh, &rec, NULL, 0, (void *)lcfg, -1);
-		if (rc)
-			CERROR("failed to write a rec: rc = %d\n", rc);
-		lustre_cfg_free(lcfg);
-	}
-	return 0;
-}
-
-static int sptlrpc_record_rules(struct llog_handle *llh,
-				struct sptlrpc_conf *conf)
-{
-	struct sptlrpc_conf_tgt *conf_tgt;
-
-	sptlrpc_record_rule_set(llh, conf->sc_fsname, &conf->sc_rset);
-
-	list_for_each_entry(conf_tgt, &conf->sc_tgts, sct_list) {
-		sptlrpc_record_rule_set(llh, conf_tgt->sct_name,
-					&conf_tgt->sct_rset);
-	}
-	return 0;
-}
-
-#define LOG_SPTLRPC_TMP "sptlrpc.tmp"
-#define LOG_SPTLRPC     "sptlrpc"
-
-static
-int sptlrpc_target_local_copy_conf(struct obd_device *obd,
-				   struct sptlrpc_conf *conf)
-{
-	struct llog_handle   *llh = NULL;
-	struct llog_ctxt     *ctxt;
-	struct lvfs_run_ctxt  saved;
-	struct dentry	*dentry;
-	int		   rc;
-
-	ctxt = llog_get_context(obd, LLOG_CONFIG_ORIG_CTXT);
-	if (ctxt == NULL)
-		return -EINVAL;
-
-	push_ctxt(&saved, &obd->obd_lvfs_ctxt, NULL);
-
-	dentry = ll_lookup_one_len(MOUNT_CONFIGS_DIR, cfs_fs_pwd(current->fs),
-				   strlen(MOUNT_CONFIGS_DIR));
-	if (IS_ERR(dentry)) {
-		rc = PTR_ERR(dentry);
-		CERROR("cannot lookup %s directory: rc = %d\n",
-		       MOUNT_CONFIGS_DIR, rc);
-		GOTO(out_ctx, rc);
-	}
-
-	/* erase the old tmp log */
-	rc = llog_erase(NULL, ctxt, NULL, LOG_SPTLRPC_TMP);
-	if (rc < 0 && rc != -ENOENT) {
-		CERROR("%s: cannot erase temporary sptlrpc log: rc = %d\n",
-		       obd->obd_name, rc);
-		GOTO(out_dput, rc);
-	}
-
-	/* write temporary log */
-	rc = llog_open_create(NULL, ctxt, &llh, NULL, LOG_SPTLRPC_TMP);
-	if (rc)
-		GOTO(out_dput, rc);
-	rc = llog_init_handle(NULL, llh, LLOG_F_IS_PLAIN, NULL);
-	if (rc)
-		GOTO(out_close, rc);
-
-	rc = sptlrpc_record_rules(llh, conf);
-
-out_close:
-	llog_close(NULL, llh);
-	if (rc == 0)
-		rc = lustre_rename(dentry, obd->obd_lvfs_ctxt.pwdmnt,
-				   LOG_SPTLRPC_TMP, LOG_SPTLRPC);
-out_dput:
-	l_dput(dentry);
-out_ctx:
-	pop_ctxt(&saved, &obd->obd_lvfs_ctxt, NULL);
-	llog_ctxt_put(ctxt);
-	CDEBUG(D_SEC, "target %s: write local sptlrpc conf: rc = %d\n",
-	       obd->obd_name, rc);
-	return rc;
-}
-
-static int local_read_handler(const struct lu_env *env,
-			      struct llog_handle *llh,
-			      struct llog_rec_hdr *rec, void *data)
-{
-	struct sptlrpc_conf  *conf = (struct sptlrpc_conf *) data;
-	struct lustre_cfg    *lcfg = (struct lustre_cfg *)(rec + 1);
-	int		   cfg_len, rc;
-
-	if (rec->lrh_type != OBD_CFG_REC) {
-		CERROR("unhandled lrh_type: %#x\n", rec->lrh_type);
-		return -EINVAL;
-	}
-
-	cfg_len = rec->lrh_len - sizeof(struct llog_rec_hdr) -
-		  sizeof(struct llog_rec_tail);
-
-	rc = lustre_cfg_sanity_check(lcfg, cfg_len);
-	if (rc) {
-		CERROR("Insane cfg\n");
-		return rc;
-	}
-
-	if (lcfg->lcfg_command != LCFG_SPTLRPC_CONF) {
-		CERROR("invalid command (%x)\n", lcfg->lcfg_command);
-		return -EINVAL;
-	}
-
-	return __sptlrpc_process_config(lcfg, conf);
-}
-
-static
-int sptlrpc_target_local_read_conf(struct obd_device *obd,
-				   struct sptlrpc_conf *conf)
-{
-	struct llog_handle    *llh = NULL;
-	struct llog_ctxt      *ctxt;
-	struct lvfs_run_ctxt   saved;
-	int		    rc;
-
-	LASSERT(conf->sc_updated == 0 && conf->sc_local == 0);
-
-	ctxt = llog_get_context(obd, LLOG_CONFIG_ORIG_CTXT);
-	if (ctxt == NULL) {
-		CERROR("missing llog context\n");
-		return -EINVAL;
-	}
-
-	push_ctxt(&saved, &obd->obd_lvfs_ctxt, NULL);
-
-	rc = llog_open(NULL, ctxt, &llh, NULL, LOG_SPTLRPC, LLOG_OPEN_EXISTS);
-	if (rc < 0) {
-		if (rc == -ENOENT)
-			rc = 0;
-		GOTO(out_pop, rc);
-	}
-
-	rc = llog_init_handle(NULL, llh, LLOG_F_IS_PLAIN, NULL);
-	if (rc)
-		GOTO(out_close, rc);
-
-	if (llog_get_size(llh) <= 1) {
-		CDEBUG(D_SEC, "no local sptlrpc copy found\n");
-		GOTO(out_close, rc = 0);
-	}
-
-	rc = llog_process(NULL, llh, local_read_handler, (void *)conf, NULL);
-
-	if (rc == 0) {
-		conf->sc_local = 1;
-	} else {
-		sptlrpc_conf_free_rsets(conf);
-	}
-
-out_close:
-	llog_close(NULL, llh);
-out_pop:
-	pop_ctxt(&saved, &obd->obd_lvfs_ctxt, NULL);
-	llog_ctxt_put(ctxt);
-	CDEBUG(D_SEC, "target %s: read local sptlrpc conf: rc = %d\n",
-	       obd->obd_name, rc);
-	return rc;
-}
-
-
-/**
- * called by target devices, extract sptlrpc rules which applies to
- * this target, to be used for future rpc flavor checking.
- */
-int sptlrpc_conf_target_get_rules(struct obd_device *obd,
-				  struct sptlrpc_rule_set *rset,
-				  int initial)
-{
-	struct sptlrpc_conf      *conf;
-	struct sptlrpc_conf_tgt  *conf_tgt;
-	enum lustre_sec_part      sp_dst;
-	char		      fsname[MTI_NAME_MAXLEN];
-	int		       rc = 0;
-
-	if (strcmp(obd->obd_type->typ_name, LUSTRE_MDT_NAME) == 0) {
-		sp_dst = LUSTRE_SP_MDT;
-	} else if (strcmp(obd->obd_type->typ_name, LUSTRE_OST_NAME) == 0) {
-		sp_dst = LUSTRE_SP_OST;
-	} else {
-		CERROR("unexpected obd type %s\n", obd->obd_type->typ_name);
-		return -EINVAL;
-	}
-	CDEBUG(D_SEC, "get rules for target %s\n", obd->obd_uuid.uuid);
-
-	target2fsname(obd->obd_uuid.uuid, fsname, sizeof(fsname));
-
-	mutex_lock(&sptlrpc_conf_lock);
-
-	conf = sptlrpc_conf_get(fsname, 0);
-	if (conf == NULL) {
-		CERROR("missing sptlrpc config log\n");
-		GOTO(out, rc);
-	}
-
-	if (conf->sc_updated  == 0) {
-		/*
-		 * always read from local copy. here another option is
-		 * if we already have a local copy (read from another
-		 * target device hosted on the same node) we simply use that.
-		 */
-		if (conf->sc_local)
-			sptlrpc_conf_free_rsets(conf);
-
-		sptlrpc_target_local_read_conf(obd, conf);
-	} else {
-		LASSERT(conf->sc_local == 0);
-
-		/* write a local copy */
-		if (initial || conf->sc_modified)
-			sptlrpc_target_local_copy_conf(obd, conf);
-		else
-			CDEBUG(D_SEC, "unchanged, skip updating local copy\n");
-	}
-
-	/* extract rule set for this target */
-	conf_tgt = sptlrpc_conf_get_tgt(conf, obd->obd_name, 0);
-
-	rc = sptlrpc_rule_set_extract(&conf->sc_rset,
-				      conf_tgt ? &conf_tgt->sct_rset : NULL,
-				      LUSTRE_SP_ANY, sp_dst, rset);
-out:
-	mutex_unlock(&sptlrpc_conf_lock);
-	return rc;
-}
-EXPORT_SYMBOL(sptlrpc_conf_target_get_rules);
-
 int  sptlrpc_conf_init(void)
 {
 	mutex_init(&sptlrpc_conf_lock);
-- 
1.7.9.5

