Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3KNQll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:41:41 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:34388 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab3KNQko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:40:44 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jinshan Xiong <jinshan.xiong@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 35/39] staging/lustre/hsm: Add support to drop all pages for ll_data_version
Date: Fri, 15 Nov 2013 00:32:58 +0800
Message-Id: <1384446782-13741-36-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jinshan Xiong <jinshan.xiong@intel.com>

This will be used by HSM release to get data version and drop all
caching pages from all clients, before sending IT_RELEASE close
REQ to MDT.

Lustre-change: http://review.whamcloud.com/6794
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3647
Signed-off-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Aurelien Degremont <aurelien.degremont@cea.fr>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      |    1 +
 .../lustre/lustre/include/lustre/lustre_user.h     |    4 +--
 drivers/staging/lustre/lustre/llite/dir.c          |    5 ++-
 drivers/staging/lustre/lustre/llite/file.c         |   36 ++++++++++++--------
 .../staging/lustre/lustre/llite/llite_internal.h   |    2 +-
 drivers/staging/lustre/lustre/lov/lov_merge.c      |   13 ++++++-
 6 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 15f70dc..15ae8e8 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -1506,6 +1506,7 @@ enum obdo_flags {
 					   * clients prior than 2.2 */
 	OBD_FL_RECOV_RESEND = 0x00080000, /* recoverable resent */
 	OBD_FL_NOSPC_BLK    = 0x00100000, /* no more block space on OST */
+	OBD_FL_FLUSH	    = 0x00200000, /* flush pages on the OST */
 
 	/* Note that while these checksum values are currently separate bits,
 	 * in 2.x we can actually allow all values from 1-31 if we wanted. */
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index ffb56d7..e982dbc 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -849,8 +849,8 @@ struct ioc_data_version {
 	__u64 idv_version;
 	__u64 idv_flags;     /* See LL_DV_xxx */
 };
-#define LL_DV_NOFLUSH 0x01   /* Do not take READ EXTENT LOCK before sampling
-				version. Dirty caches are left unchanged. */
+#define LL_DV_RD_FLUSH (1 << 0) /* Flush dirty pages from clients */
+#define LL_DV_WR_FLUSH (1 << 1) /* Flush all caching pages from clients */
 
 #ifndef offsetof
 # define offsetof(typ,memb)     ((unsigned long)((char *)&(((typ *)0)->memb)))
diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index 1856701..00a782d 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -929,7 +929,7 @@ static int ll_ioc_copy_start(struct super_block *sb, struct hsm_copy *copy)
 		}
 
 		/* Read current file data version */
-		rc = ll_data_version(inode, &data_version, 1);
+		rc = ll_data_version(inode, &data_version, LL_DV_RD_FLUSH);
 		iput(inode);
 		if (rc != 0) {
 			CDEBUG(D_HSM, "Could not read file data version of "
@@ -1012,8 +1012,7 @@ static int ll_ioc_copy_end(struct super_block *sb, struct hsm_copy *copy)
 			GOTO(progress, rc = PTR_ERR(inode));
 		}
 
-		rc = ll_data_version(inode, &data_version,
-				     copy->hc_hai.hai_action == HSMA_ARCHIVE);
+		rc = ll_data_version(inode, &data_version, LL_DV_RD_FLUSH);
 		iput(inode);
 		if (rc) {
 			CDEBUG(D_HSM, "Could not read file data version. "
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index a2a9844..9fa2cd6 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -905,7 +905,7 @@ EXPORT_SYMBOL(ll_lease_close);
 /* Fills the obdo with the attributes for the lsm */
 static int ll_lsm_getattr(struct lov_stripe_md *lsm, struct obd_export *exp,
 			  struct obd_capa *capa, struct obdo *obdo,
-			  __u64 ioepoch, int sync)
+			  __u64 ioepoch, int dv_flags)
 {
 	struct ptlrpc_request_set *set;
 	struct obd_info	    oinfo = { { { 0 } } };
@@ -925,9 +925,11 @@ static int ll_lsm_getattr(struct lov_stripe_md *lsm, struct obd_export *exp,
 			       OBD_MD_FLGROUP | OBD_MD_FLEPOCH |
 			       OBD_MD_FLDATAVERSION;
 	oinfo.oi_capa = capa;
-	if (sync) {
+	if (dv_flags & (LL_DV_WR_FLUSH | LL_DV_RD_FLUSH)) {
 		oinfo.oi_oa->o_valid |= OBD_MD_FLFLAGS;
 		oinfo.oi_oa->o_flags |= OBD_FL_SRVLOCK;
+		if (dv_flags & LL_DV_WR_FLUSH)
+			oinfo.oi_oa->o_flags |= OBD_FL_FLUSH;
 	}
 
 	set = ptlrpc_prep_set();
@@ -940,11 +942,16 @@ static int ll_lsm_getattr(struct lov_stripe_md *lsm, struct obd_export *exp,
 			rc = ptlrpc_set_wait(set);
 		ptlrpc_set_destroy(set);
 	}
-	if (rc == 0)
+	if (rc == 0) {
 		oinfo.oi_oa->o_valid &= (OBD_MD_FLBLOCKS | OBD_MD_FLBLKSZ |
 					 OBD_MD_FLATIME | OBD_MD_FLMTIME |
 					 OBD_MD_FLCTIME | OBD_MD_FLSIZE |
-					 OBD_MD_FLDATAVERSION);
+					 OBD_MD_FLDATAVERSION | OBD_MD_FLFLAGS);
+		if (dv_flags & LL_DV_WR_FLUSH &&
+		    !(oinfo.oi_oa->o_valid & OBD_MD_FLFLAGS &&
+		      oinfo.oi_oa->o_flags & OBD_FL_FLUSH))
+			return -ENOTSUPP;
+	}
 	return rc;
 }
 
@@ -961,7 +968,7 @@ int ll_inode_getattr(struct inode *inode, struct obdo *obdo,
 
 	lsm = ccc_inode_lsm_get(inode);
 	rc = ll_lsm_getattr(lsm, ll_i2dtexp(inode),
-			    capa, obdo, ioepoch, sync);
+				capa, obdo, ioepoch, sync ? LL_DV_RD_FLUSH : 0);
 	capa_put(capa);
 	if (rc == 0) {
 		struct ost_id *oi = lsm ? &lsm->lsm_oi : &obdo->o_oi;
@@ -1905,11 +1912,12 @@ error:
  * This value is computed using stripe object version on OST.
  * Version is computed using server side locking.
  *
- * @param extent_lock  Take extent lock. Not needed if a process is already
- *		       holding the OST object group locks.
+ * @param sync if do sync on the OST side;
+ *		0: no sync
+ *		LL_DV_RD_FLUSH: flush dirty pages, LCK_PR on OSTs
+ *		LL_DV_WR_FLUSH: drop all caching pages, LCK_PW on OSTs
  */
-int ll_data_version(struct inode *inode, __u64 *data_version,
-		    int extent_lock)
+int ll_data_version(struct inode *inode, __u64 *data_version, int flags)
 {
 	struct lov_stripe_md	*lsm = NULL;
 	struct ll_sb_info	*sbi = ll_i2sbi(inode);
@@ -1928,7 +1936,7 @@ int ll_data_version(struct inode *inode, __u64 *data_version,
 	if (obdo == NULL)
 		GOTO(out, rc = -ENOMEM);
 
-	rc = ll_lsm_getattr(lsm, sbi->ll_dt_exp, NULL, obdo, 0, extent_lock);
+	rc = ll_lsm_getattr(lsm, sbi->ll_dt_exp, NULL, obdo, 0, flags);
 	if (rc == 0) {
 		if (!(obdo->o_valid & OBD_MD_FLDATAVERSION))
 			rc = -EOPNOTSUPP;
@@ -1963,7 +1971,7 @@ int ll_hsm_release(struct inode *inode)
 		GOTO(out, rc = PTR_ERR(och));
 
 	/* Grab latest data_version and [am]time values */
-	rc = ll_data_version(inode, &data_version, 1);
+	rc = ll_data_version(inode, &data_version, LL_DV_WR_FLUSH);
 	if (rc != 0)
 		GOTO(out, rc);
 
@@ -2335,13 +2343,13 @@ long ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return ll_fid2path(inode, (void *)arg);
 	case LL_IOC_DATA_VERSION: {
 		struct ioc_data_version	idv;
-		int			rc;
+		int rc;
 
 		if (copy_from_user(&idv, (char *)arg, sizeof(idv)))
 			return -EFAULT;
 
-		rc = ll_data_version(inode, &idv.idv_version,
-				!(idv.idv_flags & LL_DV_NOFLUSH));
+		idv.idv_flags &= LL_DV_RD_FLUSH | LL_DV_WR_FLUSH;
+		rc = ll_data_version(inode, &idv.idv_version, idv.idv_flags);
 
 		if (rc == 0 && copy_to_user((char *) arg, &idv, sizeof(idv)))
 			return -EFAULT;
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 6148ec4..942601b 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -805,7 +805,7 @@ int ll_merge_lvb(const struct lu_env *env, struct inode *inode);
 int ll_get_grouplock(struct inode *inode, struct file *file, unsigned long arg);
 int ll_put_grouplock(struct inode *inode, struct file *file, unsigned long arg);
 int ll_fid2path(struct inode *inode, void *arg);
-int ll_data_version(struct inode *inode, __u64 *data_version, int extent_lock);
+int ll_data_version(struct inode *inode, __u64 *data_version, int flags);
 int ll_hsm_release(struct inode *inode);
 
 struct obd_client_handle *ll_lease_open(struct inode *inode, struct file *file,
diff --git a/drivers/staging/lustre/lustre/lov/lov_merge.c b/drivers/staging/lustre/lustre/lov/lov_merge.c
index d204fed..fcfb1e5 100644
--- a/drivers/staging/lustre/lustre/lov/lov_merge.c
+++ b/drivers/staging/lustre/lustre/lov/lov_merge.c
@@ -181,7 +181,8 @@ void lov_merge_attrs(struct obdo *tgt, struct obdo *src, obd_valid valid,
 {
 	valid &= src->o_valid;
 
-	if (*set) {
+	if (*set != 0) {
+		tgt->o_valid &= valid;
 		if (valid & OBD_MD_FLSIZE) {
 			/* this handles sparse files properly */
 			obd_size lov_size;
@@ -200,12 +201,22 @@ void lov_merge_attrs(struct obdo *tgt, struct obdo *src, obd_valid valid,
 			tgt->o_mtime = src->o_mtime;
 		if (valid & OBD_MD_FLDATAVERSION)
 			tgt->o_data_version += src->o_data_version;
+
+		/* handle flags */
+		if (valid & OBD_MD_FLFLAGS)
+			tgt->o_flags &= src->o_flags;
+		else
+			tgt->o_flags = 0;
 	} else {
 		memcpy(tgt, src, sizeof(*tgt));
 		tgt->o_oi = lsm->lsm_oi;
+		tgt->o_valid = valid;
 		if (valid & OBD_MD_FLSIZE)
 			tgt->o_size = lov_stripe_size(lsm, src->o_size,
 						      stripeno);
+		tgt->o_flags = 0;
+		if (valid & OBD_MD_FLFLAGS)
+			tgt->o_flags = src->o_flags;
 	}
 
 	/* data_version needs to be valid on all stripes to be correct! */
-- 
1.7.9.5

