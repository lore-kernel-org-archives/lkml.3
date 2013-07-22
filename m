Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab3GVQL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:11:29 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:38572 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab3GVQLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:11:21 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jinshan Xiong <jinshan.xiong@intel.com>,
        Johann Lombardi <johann.lombardi@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 18/48] staging/lustre/layout: introduce new layout for released files
Date: Tue, 23 Jul 2013 00:06:39 +0800
Message-Id: <1374509230-3324-19-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jinshan Xiong <jinshan.xiong@intel.com>

Released files now have a standard layout (with generation, pool, ...)
and a stripe count 0 and lmm_pattern flag LOV_PATTERN_F_RELEASED.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2482
Lustre-change: http://review.whamcloud.com/4816
Signed-off-by: Jinshan Xiong <jinshan.xiong@intel.com>
Signed-off-by: Johann Lombardi <johann.lombardi@intel.com>
Reviewed-by: Keith Mannthey <keith.mannthey@intel.com>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      |   14 ++--
 drivers/staging/lustre/lustre/include/obd.h        |   14 ++++
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |    2 +-
 drivers/staging/lustre/lustre/llite/file.c         |   27 +++++---
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   22 +++---
 drivers/staging/lustre/lustre/llite/vvp_io.c       |   10 +--
 .../staging/lustre/lustre/lov/lov_cl_internal.h    |   11 +--
 drivers/staging/lustre/lustre/lov/lov_ea.c         |   23 ++++--
 drivers/staging/lustre/lustre/lov/lov_io.c         |   34 +++++++++
 drivers/staging/lustre/lustre/lov/lov_obd.c        |    2 +-
 drivers/staging/lustre/lustre/lov/lov_object.c     |   73 +++++++++++++++++---
 drivers/staging/lustre/lustre/lov/lov_pack.c       |   19 +++--
 12 files changed, 197 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 4829419..30c0331 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -1546,10 +1546,16 @@ enum obdo_flags {
 #define LOV_MAGIC_V1_DEF  0x0CD10BD0
 #define LOV_MAGIC_V3_DEF  0x0CD30BD0
 
-#define LOV_PATTERN_RAID0 0x001   /* stripes are used round-robin */
-#define LOV_PATTERN_RAID1 0x002   /* stripes are mirrors of each other */
-#define LOV_PATTERN_FIRST 0x100   /* first stripe is not in round-robin */
-#define LOV_PATTERN_CMOBD 0x200
+#define LOV_PATTERN_RAID0	0x001   /* stripes are used round-robin */
+#define LOV_PATTERN_RAID1	0x002   /* stripes are mirrors of each other */
+#define LOV_PATTERN_FIRST	0x100   /* first stripe is not in round-robin */
+#define LOV_PATTERN_CMOBD	0x200
+
+#define LOV_PATTERN_F_MASK	0xffff0000
+#define LOV_PATTERN_F_RELEASED	0x80000000 /* HSM released file */
+
+#define lov_pattern(pattern)		(pattern & ~LOV_PATTERN_F_MASK)
+#define lov_pattern_flags(pattern)	(pattern & LOV_PATTERN_F_MASK)
 
 #define lov_ost_data lov_ost_data_v1
 struct lov_ost_data_v1 {	  /* per-stripe data structure (little-endian)*/
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index 0a251fd..11d10fe 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -119,6 +119,20 @@ struct lov_stripe_md {
 #define lsm_stripe_count lsm_wire.lw_stripe_count
 #define lsm_pool_name    lsm_wire.lw_pool_name
 
+static inline bool lsm_is_released(struct lov_stripe_md *lsm)
+{
+	return !!(lsm->lsm_pattern & LOV_PATTERN_F_RELEASED);
+}
+
+static inline bool lsm_has_objects(struct lov_stripe_md *lsm)
+{
+	if (lsm == NULL)
+		return false;
+	if (lsm_is_released(lsm))
+		return false;
+	return true;
+}
+
 struct obd_info;
 
 typedef int (*obd_enqueue_update_f)(void *cookie, int rc);
diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
index 4a01666..c8690cb 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -1166,7 +1166,7 @@ int cl_file_inode_init(struct inode *inode, struct lustre_md *md)
 			 * locked by I_NEW bit.
 			 */
 			lli->lli_clob = clob;
-			lli->lli_has_smd = md->lsm != NULL;
+			lli->lli_has_smd = lsm_has_objects(md->lsm);
 			lu_object_ref_add(&clob->co_lu, "inode", inode);
 		} else
 			result = PTR_ERR(clob);
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index d51f1ee..5493845 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1143,7 +1143,7 @@ static int ll_lov_recreate(struct inode *inode, struct ost_id *oi,
 		RETURN(-ENOMEM);
 
 	lsm = ccc_inode_lsm_get(inode);
-	if (lsm == NULL)
+	if (!lsm_has_objects(lsm))
 		GOTO(out, rc = -ENOENT);
 
 	lsm_size = sizeof(*lsm) + (sizeof(struct lov_oinfo) *
@@ -1299,6 +1299,12 @@ int ll_lov_getstripe_ea_info(struct inode *inode, const char *filename,
 	 * passing it to userspace.
 	 */
 	if (LOV_MAGIC != cpu_to_le32(LOV_MAGIC)) {
+		int stripe_count;
+
+		stripe_count = le16_to_cpu(lmm->lmm_stripe_count);
+		if (le32_to_cpu(lmm->lmm_pattern) & LOV_PATTERN_F_RELEASED)
+			stripe_count = 0;
+
 		/* if function called for directory - we should
 		 * avoid swab not existent lsm objects */
 		if (lmm->lmm_magic == cpu_to_le32(LOV_MAGIC_V1)) {
@@ -1306,13 +1312,13 @@ int ll_lov_getstripe_ea_info(struct inode *inode, const char *filename,
 			if (S_ISREG(body->mode))
 				lustre_swab_lov_user_md_objects(
 				 ((struct lov_user_md_v1 *)lmm)->lmm_objects,
-				 ((struct lov_user_md_v1 *)lmm)->lmm_stripe_count);
+				 stripe_count);
 		} else if (lmm->lmm_magic == cpu_to_le32(LOV_MAGIC_V3)) {
 			lustre_swab_lov_user_md_v3((struct lov_user_md_v3 *)lmm);
 			if (S_ISREG(body->mode))
 				lustre_swab_lov_user_md_objects(
 				 ((struct lov_user_md_v3 *)lmm)->lmm_objects,
-				 ((struct lov_user_md_v3 *)lmm)->lmm_stripe_count);
+				 stripe_count);
 		}
 	}
 
@@ -1698,20 +1704,18 @@ int ll_data_version(struct inode *inode, __u64 *data_version,
 
 	/* If no stripe, we consider version is 0. */
 	lsm = ccc_inode_lsm_get(inode);
-	if (lsm == NULL) {
+	if (!lsm_has_objects(lsm)) {
 		*data_version = 0;
 		CDEBUG(D_INODE, "No object for inode\n");
-		RETURN(0);
+		GOTO(out, rc = 0);
 	}
 
 	OBD_ALLOC_PTR(obdo);
-	if (obdo == NULL) {
-		ccc_inode_lsm_put(inode, lsm);
-		RETURN(-ENOMEM);
-	}
+	if (obdo == NULL)
+		GOTO(out, rc = -ENOMEM);
 
 	rc = ll_lsm_getattr(lsm, sbi->ll_dt_exp, NULL, obdo, 0, extent_lock);
-	if (!rc) {
+	if (rc == 0) {
 		if (!(obdo->o_valid & OBD_MD_FLDATAVERSION))
 			rc = -EOPNOTSUPP;
 		else
@@ -1719,8 +1723,9 @@ int ll_data_version(struct inode *inode, __u64 *data_version,
 	}
 
 	OBD_FREE_PTR(obdo);
+	EXIT;
+out:
 	ccc_inode_lsm_put(inode, lsm);
-
 	RETURN(rc);
 }
 
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 1eb5779..b9cbe95 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1282,13 +1282,6 @@ int ll_md_setattr(struct dentry *dentry, struct md_op_data *op_data,
 		RETURN(rc);
 	}
 
-	ia_valid = op_data->op_attr.ia_valid;
-	/* inode size will be in ll_setattr_ost, can't do it now since dirty
-	 * cache is not cleared yet. */
-	op_data->op_attr.ia_valid &= ~(TIMES_SET_FLAGS | ATTR_SIZE);
-	rc = simple_setattr(dentry, &op_data->op_attr);
-	op_data->op_attr.ia_valid = ia_valid;
-
 	/* Extract epoch data if obtained. */
 	op_data->op_handle = md.body->handle;
 	op_data->op_ioepoch = md.body->ioepoch;
@@ -1371,6 +1364,7 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr)
 	struct ll_inode_info *lli = ll_i2info(inode);
 	struct md_op_data *op_data = NULL;
 	struct md_open_data *mod = NULL;
+	unsigned int valid = attr->ia_valid;
 	int rc = 0, rc1 = 0;
 	ENTRY;
 
@@ -1482,6 +1476,13 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr)
 		rc = ll_setattr_ost(inode, attr);
 	EXIT;
 out:
+	if (rc == 0) {
+		/* Update inode attribute after dirty cache is cleaned
+		 * by truncating OST objects. */
+		attr->ia_valid |= ATTR_FORCE;
+		rc = simple_setattr(dentry, attr);
+		LASSERT(rc == 0);
+	}
 	if (op_data) {
 		if (op_data->op_ioepoch) {
 			rc1 = ll_setattr_done_writing(inode, op_data, mod);
@@ -1500,7 +1501,8 @@ out:
 	ll_stats_ops_tally(ll_i2sbi(inode), (attr->ia_valid & ATTR_SIZE) ?
 			LPROC_LL_TRUNC : LPROC_LL_SETATTR, 1);
 
-	return rc;
+	attr->ia_valid = valid;
+	RETURN(rc);
 }
 
 int ll_setattr(struct dentry *de, struct iattr *attr)
@@ -1923,8 +1925,10 @@ int ll_iocontrol(struct inode *inode, struct file *file,
 		inode->i_flags = ll_ext_to_inode_flags(flags);
 
 		lsm = ccc_inode_lsm_get(inode);
-		if (lsm == NULL)
+		if (!lsm_has_objects(lsm)) {
+			ccc_inode_lsm_put(inode, lsm);
 			RETURN(0);
+		}
 
 		OBDO_ALLOC(oinfo.oi_oa);
 		if (!oinfo.oi_oa) {
diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index c24dc268..158b27e 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -407,13 +407,15 @@ static int vvp_io_setattr_start(const struct lu_env *env,
 {
 	struct cl_io	*io    = ios->cis_io;
 	struct inode	*inode = ccc_object_inode(io->ci_obj);
+	int result = 0;
 
 	mutex_lock(&inode->i_mutex);
 	if (cl_io_is_trunc(io))
-		return vvp_io_setattr_trunc(env, ios, inode,
-					    io->u.ci_setattr.sa_attr.lvb_size);
-	else
-		return vvp_io_setattr_time(env, ios);
+		result = vvp_io_setattr_trunc(env, ios, inode,
+					io->u.ci_setattr.sa_attr.lvb_size);
+	if (result == 0)
+		result = vvp_io_setattr_time(env, ios);
+	return result;
 }
 
 static void vvp_io_setattr_end(const struct lu_env *env,
diff --git a/drivers/staging/lustre/lustre/lov/lov_cl_internal.h b/drivers/staging/lustre/lustre/lov/lov_cl_internal.h
index 28801b8..a82dfea 100644
--- a/drivers/staging/lustre/lustre/lov/lov_cl_internal.h
+++ b/drivers/staging/lustre/lustre/lov/lov_cl_internal.h
@@ -162,10 +162,9 @@ struct lov_device {
  * Layout type.
  */
 enum lov_layout_type {
-	/** empty file without body */
-	LLT_EMPTY,
-	/** striped file */
-	LLT_RAID0,
+	LLT_EMPTY,	/** empty file without body (mknod + truncate) */
+	LLT_RAID0,	/** striped file */
+	LLT_RELEASED,	/** file with no objects (data in HSM) */
 	LLT_NR
 };
 
@@ -255,6 +254,8 @@ struct lov_object {
 		} raid0;
 		struct lov_layout_state_empty {
 		} empty;
+		struct lov_layout_state_released {
+		} released;
 	} u;
 	/**
 	 * Thread that acquired lov_object::lo_type_guard in an exclusive
@@ -582,6 +583,8 @@ int   lov_io_init_raid0   (const struct lu_env *env, struct cl_object *obj,
 			   struct cl_io *io);
 int   lov_io_init_empty   (const struct lu_env *env, struct cl_object *obj,
 			   struct cl_io *io);
+int   lov_io_init_released(const struct lu_env *env, struct cl_object *obj,
+			   struct cl_io *io);
 void  lov_lock_unlink     (const struct lu_env *env, struct lov_lock_link *link,
 			   struct lovsub_lock *sub);
 
diff --git a/drivers/staging/lustre/lustre/lov/lov_ea.c b/drivers/staging/lustre/lustre/lov/lov_ea.c
index 340dbcf..e6c6015 100644
--- a/drivers/staging/lustre/lustre/lov/lov_ea.c
+++ b/drivers/staging/lustre/lustre/lov/lov_ea.c
@@ -57,7 +57,7 @@ struct lovea_unpack_args {
 static int lsm_lmm_verify_common(struct lov_mds_md *lmm, int lmm_bytes,
 				 __u16 stripe_count)
 {
-	if (stripe_count == 0 || stripe_count > LOV_V1_INSANE_STRIPE_COUNT) {
+	if (stripe_count > LOV_V1_INSANE_STRIPE_COUNT) {
 		CERROR("bad stripe count %d\n", stripe_count);
 		lov_dump_lmm_common(D_WARNING, lmm);
 		return -EINVAL;
@@ -69,7 +69,7 @@ static int lsm_lmm_verify_common(struct lov_mds_md *lmm, int lmm_bytes,
 		return -EINVAL;
 	}
 
-	if (lmm->lmm_pattern != cpu_to_le32(LOV_PATTERN_RAID0)) {
+	if (lov_pattern(le32_to_cpu(lmm->lmm_pattern)) != LOV_PATTERN_RAID0) {
 		CERROR("bad striping pattern\n");
 		lov_dump_lmm_common(D_WARNING, lmm);
 		return -EINVAL;
@@ -197,6 +197,8 @@ static int lsm_lmm_verify_v1(struct lov_mds_md_v1 *lmm, int lmm_bytes,
 	}
 
 	*stripe_count = le16_to_cpu(lmm->lmm_stripe_count);
+	if (le32_to_cpu(lmm->lmm_pattern) & LOV_PATTERN_F_RELEASED)
+		*stripe_count = 0;
 
 	if (lmm_bytes < lov_mds_md_size(*stripe_count, LOV_MAGIC_V1)) {
 		CERROR("LOV EA V1 too small: %d, need %d\n",
@@ -213,11 +215,14 @@ int lsm_unpackmd_v1(struct lov_obd *lov, struct lov_stripe_md *lsm,
 {
 	struct lov_oinfo *loi;
 	int i;
+	int stripe_count;
 	__u64 stripe_maxbytes = OBD_OBJECT_EOF;
 
 	lsm_unpackmd_common(lsm, lmm);
 
-	for (i = 0; i < lsm->lsm_stripe_count; i++) {
+	stripe_count = lsm_is_released(lsm) ? 0 : lsm->lsm_stripe_count;
+
+	for (i = 0; i < stripe_count; i++) {
 		/* XXX LOV STACKING call down to osc_unpackmd() */
 		loi = lsm->lsm_oinfo[i];
 		ostid_le_to_cpu(&lmm->lmm_objects[i].l_ost_oi, &loi->loi_oi);
@@ -240,6 +245,8 @@ int lsm_unpackmd_v1(struct lov_obd *lov, struct lov_stripe_md *lsm,
 	}
 
 	lsm->lsm_maxbytes = stripe_maxbytes * lsm->lsm_stripe_count;
+	if (lsm->lsm_stripe_count == 0)
+		lsm->lsm_maxbytes = stripe_maxbytes * lov->desc.ld_tgt_count;
 
 	return 0;
 }
@@ -267,6 +274,8 @@ static int lsm_lmm_verify_v3(struct lov_mds_md *lmmv1, int lmm_bytes,
 	}
 
 	*stripe_count = le16_to_cpu(lmm->lmm_stripe_count);
+	if (le32_to_cpu(lmm->lmm_pattern) & LOV_PATTERN_F_RELEASED)
+		*stripe_count = 0;
 
 	if (lmm_bytes < lov_mds_md_size(*stripe_count, LOV_MAGIC_V3)) {
 		CERROR("LOV EA V3 too small: %d, need %d\n",
@@ -285,18 +294,22 @@ int lsm_unpackmd_v3(struct lov_obd *lov, struct lov_stripe_md *lsm,
 	struct lov_mds_md_v3 *lmm;
 	struct lov_oinfo *loi;
 	int i;
+	int stripe_count;
 	__u64 stripe_maxbytes = OBD_OBJECT_EOF;
 	int cplen = 0;
 
 	lmm = (struct lov_mds_md_v3 *)lmmv1;
 
 	lsm_unpackmd_common(lsm, (struct lov_mds_md_v1 *)lmm);
+
+	stripe_count = lsm_is_released(lsm) ? 0 : lsm->lsm_stripe_count;
+
 	cplen = strlcpy(lsm->lsm_pool_name, lmm->lmm_pool_name,
 			sizeof(lsm->lsm_pool_name));
 	if (cplen >= sizeof(lsm->lsm_pool_name))
 		return -E2BIG;
 
-	for (i = 0; i < lsm->lsm_stripe_count; i++) {
+	for (i = 0; i < stripe_count; i++) {
 		/* XXX LOV STACKING call down to osc_unpackmd() */
 		loi = lsm->lsm_oinfo[i];
 		ostid_le_to_cpu(&lmm->lmm_objects[i].l_ost_oi, &loi->loi_oi);
@@ -319,6 +332,8 @@ int lsm_unpackmd_v3(struct lov_obd *lov, struct lov_stripe_md *lsm,
 	}
 
 	lsm->lsm_maxbytes = stripe_maxbytes * lsm->lsm_stripe_count;
+	if (lsm->lsm_stripe_count == 0)
+		lsm->lsm_maxbytes = stripe_maxbytes * lov->desc.ld_tgt_count;
 
 	return 0;
 }
diff --git a/drivers/staging/lustre/lustre/lov/lov_io.c b/drivers/staging/lustre/lustre/lov/lov_io.c
index 022e0f4..e78cdb7 100644
--- a/drivers/staging/lustre/lustre/lov/lov_io.c
+++ b/drivers/staging/lustre/lustre/lov/lov_io.c
@@ -964,4 +964,38 @@ int lov_io_init_empty(const struct lu_env *env, struct cl_object *obj,
 	RETURN(result != 0);
 }
 
+int lov_io_init_released(const struct lu_env *env, struct cl_object *obj,
+			struct cl_io *io)
+{
+	struct lov_object *lov = cl2lov(obj);
+	struct lov_io *lio = lov_env_io(env);
+	int result;
+	ENTRY;
+
+	LASSERT(lov->lo_lsm != NULL);
+	lio->lis_object = lov;
+
+	switch (io->ci_type) {
+	default:
+		LASSERTF(0, "invalid type %d\n", io->ci_type);
+	case CIT_MISC:
+	case CIT_FSYNC:
+	case CIT_SETATTR:
+		result = +1;
+		break;
+	case CIT_READ:
+	case CIT_WRITE:
+	case CIT_FAULT:
+		/* TODO: need to restore the file. */
+		result = -EBADF;
+		break;
+	}
+	if (result == 0) {
+		cl_io_slice_add(io, &lio->lis_cl, obj, &lov_empty_io_ops);
+		atomic_inc(&lov->lo_active_ios);
+	}
+
+	io->ci_result = result < 0 ? result : 0;
+	RETURN(result != 0);
+}
 /** @} lov */
diff --git a/drivers/staging/lustre/lustre/lov/lov_obd.c b/drivers/staging/lustre/lustre/lov/lov_obd.c
index ef7ff09..0a9e40d 100644
--- a/drivers/staging/lustre/lustre/lov/lov_obd.c
+++ b/drivers/staging/lustre/lustre/lov/lov_obd.c
@@ -2259,7 +2259,7 @@ static int lov_fiemap(struct lov_obd *lov, __u32 keylen, void *key,
 	int cur_stripe = 0, cur_stripe_wrap = 0, stripe_count;
 	unsigned int buffer_size = FIEMAP_BUFFER_SIZE;
 
-	if (lsm == NULL)
+	if (!lsm_has_objects(lsm))
 		GOTO(out, rc = 0);
 
 	if (fiemap_count_to_size(fm_key->fiemap.fm_extent_count) < buffer_size)
diff --git a/drivers/staging/lustre/lustre/lov/lov_object.c b/drivers/staging/lustre/lustre/lov/lov_object.c
index aa8ae80..e7cc650 100644
--- a/drivers/staging/lustre/lustre/lov/lov_object.c
+++ b/drivers/staging/lustre/lustre/lov/lov_object.c
@@ -258,10 +258,25 @@ out:
 	RETURN(result);
 }
 
+static int lov_init_released(const struct lu_env *env,
+			struct lov_device *dev, struct lov_object *lov,
+			const struct cl_object_conf *conf,
+			union  lov_layout_state *state)
+{
+	struct lov_stripe_md *lsm = conf->u.coc_md->lsm;
+
+	LASSERT(lsm != NULL);
+	LASSERT(lsm_is_released(lsm));
+	LASSERT(lov->lo_lsm == NULL);
+
+	lov->lo_lsm = lsm_addref(lsm);
+	return 0;
+}
+
 static int lov_delete_empty(const struct lu_env *env, struct lov_object *lov,
 			    union lov_layout_state *state)
 {
-	LASSERT(lov->lo_type == LLT_EMPTY);
+	LASSERT(lov->lo_type == LLT_EMPTY || lov->lo_type == LLT_RELEASED);
 
 	lov_layout_wait(env, lov);
 
@@ -349,7 +364,7 @@ static int lov_delete_raid0(const struct lu_env *env, struct lov_object *lov,
 static void lov_fini_empty(const struct lu_env *env, struct lov_object *lov,
 			   union lov_layout_state *state)
 {
-	LASSERT(lov->lo_type == LLT_EMPTY);
+	LASSERT(lov->lo_type == LLT_EMPTY || lov->lo_type == LLT_RELEASED);
 }
 
 static void lov_fini_raid0(const struct lu_env *env, struct lov_object *lov,
@@ -369,6 +384,15 @@ static void lov_fini_raid0(const struct lu_env *env, struct lov_object *lov,
 	EXIT;
 }
 
+static void lov_fini_released(const struct lu_env *env, struct lov_object *lov,
+				union lov_layout_state *state)
+{
+	ENTRY;
+	dump_lsm(D_INODE, lov->lo_lsm);
+	lov_free_memmd(&lov->lo_lsm);
+	EXIT;
+}
+
 static int lov_print_empty(const struct lu_env *env, void *cookie,
 			   lu_printer_t p, const struct lu_object *o)
 {
@@ -400,6 +424,13 @@ static int lov_print_raid0(const struct lu_env *env, void *cookie,
 	return 0;
 }
 
+static int lov_print_released(const struct lu_env *env, void *cookie,
+				lu_printer_t p, const struct lu_object *o)
+{
+	(*p)(env, cookie, "released\n");
+	return 0;
+}
+
 /**
  * Implements cl_object_operations::coo_attr_get() method for an object
  * without stripes (LLT_EMPTY layout type).
@@ -503,10 +534,20 @@ const static struct lov_layout_operations lov_dispatch[] = {
 		.llo_lock_init = lov_lock_init_raid0,
 		.llo_io_init   = lov_io_init_raid0,
 		.llo_getattr   = lov_attr_get_raid0
+	},
+	[LLT_RELEASED] = {
+		.llo_init      = lov_init_released,
+		.llo_delete    = lov_delete_empty,
+		.llo_fini      = lov_fini_released,
+		.llo_install   = lov_install_empty,
+		.llo_print     = lov_print_released,
+		.llo_page_init = lov_page_init_empty,
+		.llo_lock_init = lov_lock_init_empty,
+		.llo_io_init   = lov_io_init_released,
+		.llo_getattr   = lov_attr_get_empty
 	}
 };
 
-
 /**
  * Performs a double-dispatch based on the layout type of an object.
  */
@@ -520,6 +561,18 @@ const static struct lov_layout_operations lov_dispatch[] = {
 	lov_dispatch[__llt].op(__VA_ARGS__);			    \
 })
 
+/**
+ * Return lov_layout_type associated with a given lsm
+ */
+enum lov_layout_type lov_type(struct lov_stripe_md *lsm)
+{
+	if (lsm == NULL)
+		return LLT_EMPTY;
+	if (lsm_is_released(lsm))
+		return LLT_RELEASED;
+	return LLT_RAID0;
+}
+
 static inline void lov_conf_freeze(struct lov_object *lov)
 {
 	if (lov->lo_owner != current)
@@ -612,8 +665,8 @@ static int lov_layout_change(const struct lu_env *unused,
 
 	LASSERT(0 <= lov->lo_type && lov->lo_type < ARRAY_SIZE(lov_dispatch));
 
-	if (conf->u.coc_md != NULL && conf->u.coc_md->lsm != NULL)
-		llt = LLT_RAID0; /* only raid0 is supported. */
+	if (conf->u.coc_md != NULL)
+		llt = lov_type(conf->u.coc_md->lsm);
 	LASSERT(0 <= llt && llt < ARRAY_SIZE(lov_dispatch));
 
 	cookie = cl_env_reenter();
@@ -658,7 +711,6 @@ static int lov_layout_change(const struct lu_env *unused,
  * Lov object operations.
  *
  */
-
 int lov_object_init(const struct lu_env *env, struct lu_object *obj,
 		    const struct lu_object_conf *conf)
 {
@@ -677,7 +729,7 @@ int lov_object_init(const struct lu_env *env, struct lu_object *obj,
 	cl_object_page_init(lu2cl(obj), sizeof(struct lov_page));
 
 	/* no locking is necessary, as object is being created */
-	lov->lo_type = cconf->u.coc_md->lsm != NULL ? LLT_RAID0 : LLT_EMPTY;
+	lov->lo_type = lov_type(cconf->u.coc_md->lsm);
 	ops = &lov_dispatch[lov->lo_type];
 	result = ops->llo_init(env, dev, lov, cconf, set);
 	if (result == 0)
@@ -688,9 +740,9 @@ int lov_object_init(const struct lu_env *env, struct lu_object *obj,
 static int lov_conf_set(const struct lu_env *env, struct cl_object *obj,
 			const struct cl_object_conf *conf)
 {
-	struct lov_stripe_md *lsm = NULL;
-	struct lov_object *lov = cl2lov(obj);
-	int result = 0;
+	struct lov_stripe_md	*lsm = NULL;
+	struct lov_object	*lov = cl2lov(obj);
+	int			 result = 0;
 	ENTRY;
 
 	lov_conf_lock(lov);
@@ -928,6 +980,7 @@ int lov_read_and_clear_async_rc(struct cl_object *clob)
 				loi->loi_ar.ar_rc = 0;
 			}
 		}
+		case LLT_RELEASED:
 		case LLT_EMPTY:
 			break;
 		default:
diff --git a/drivers/staging/lustre/lustre/lov/lov_pack.c b/drivers/staging/lustre/lustre/lov/lov_pack.c
index 492948a..9c99e4a 100644
--- a/drivers/staging/lustre/lustre/lov/lov_pack.c
+++ b/drivers/staging/lustre/lustre/lov/lov_pack.c
@@ -168,10 +168,12 @@ int lov_packmd(struct obd_export *exp, struct lov_mds_md **lmmp,
 		 * to the actual number of OSTs in this filesystem. */
 		if (!lmmp) {
 			stripe_count = lov_get_stripecnt(lov, lmm_magic,
-							 lsm->lsm_stripe_count);
+							lsm->lsm_stripe_count);
 			lsm->lsm_stripe_count = stripe_count;
-		} else {
+		} else if (!lsm_is_released(lsm)) {
 			stripe_count = lsm->lsm_stripe_count;
+		} else {
+			stripe_count = 0;
 		}
 	} else {
 		/* No need to allocate more than maximum supported stripes.
@@ -325,7 +327,8 @@ int lov_alloc_memmd(struct lov_stripe_md **lsmp, __u16 stripe_count,
 	(*lsmp)->lsm_pattern = pattern;
 	(*lsmp)->lsm_pool_name[0] = '\0';
 	(*lsmp)->lsm_layout_gen = 0;
-	(*lsmp)->lsm_oinfo[0]->loi_ost_idx = ~0;
+	if (stripe_count > 0)
+		(*lsmp)->lsm_oinfo[0]->loi_ost_idx = ~0;
 
 	for (i = 0; i < stripe_count; i++)
 		loi_init((*lsmp)->lsm_oinfo[i]);
@@ -359,6 +362,7 @@ int lov_unpackmd(struct obd_export *exp,  struct lov_stripe_md **lsmp,
 	int rc = 0, lsm_size;
 	__u16 stripe_count;
 	__u32 magic;
+	__u32 pattern;
 	ENTRY;
 
 	/* If passed an MDS struct use values from there, otherwise defaults */
@@ -384,8 +388,8 @@ int lov_unpackmd(struct obd_export *exp,  struct lov_stripe_md **lsmp,
 		RETURN(0);
 	}
 
-	lsm_size = lov_alloc_memmd(lsmp, stripe_count, LOV_PATTERN_RAID0,
-				   magic);
+	pattern = le32_to_cpu(lmm->lmm_pattern);
+	lsm_size = lov_alloc_memmd(lsmp, stripe_count, pattern, magic);
 	if (lsm_size < 0)
 		RETURN(lsm_size);
 
@@ -430,7 +434,7 @@ static int __lov_setstripe(struct obd_export *exp, int max_lmm_size,
 			lov->desc.ld_pattern : LOV_PATTERN_RAID0;
 	}
 
-	if (lumv1->lmm_pattern != LOV_PATTERN_RAID0) {
+	if (lov_pattern(lumv1->lmm_pattern) != LOV_PATTERN_RAID0) {
 		CDEBUG(D_IOCTL, "bad userland stripe pattern: %#x\n",
 		       lumv1->lmm_pattern);
 		RETURN(-EINVAL);
@@ -490,6 +494,9 @@ static int __lov_setstripe(struct obd_export *exp, int max_lmm_size,
 		}
 	}
 
+	if (lumv1->lmm_pattern & LOV_PATTERN_F_RELEASED)
+		stripe_count = 0;
+
 	rc = lov_alloc_memmd(lsmp, stripe_count, lumv1->lmm_pattern, lmm_magic);
 
 	if (rc >= 0) {
-- 
1.7.9.5

