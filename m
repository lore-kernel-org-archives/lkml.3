Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab3GVQKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:10:37 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:42769 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab3GVQKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:10:33 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>,
        Peng Tao <tao.peng@emc.com>
Subject: [PATCH 09/48] staging/lustre/ldlm: print FID in lvbo_init(), lvbo_update
Date: Tue, 23 Jul 2013 00:06:30 +0800
Message-Id: <1374509230-3324-10-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Dilger <andreas.dilger@intel.com>

Print the namespace and OBD device name, as well as the first two
lock resource fields (typically the FID) if there is an error with
loading the object from disk.  This will be more important with
FID-on-OST and also the MDS.  Using fid_extract_from_res_name() isn't
possible in the LDLM code, since the lock resource may not be a FID.

Make fid_extract_quota_resid() argument order and name consistent
with other fid_*_res() functions, with FID first and resource second.

Fix a bug in ofd_lvbo_init() where NULL lvb is accessed on error.

Print FID in ofd_lvbo_update() CDEBUG() and CERROR() messages.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2193
Lustre-change: http://review.whamcloud.com/4501
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      |    4 +-
 drivers/staging/lustre/lustre/include/lustre_fid.h |   89 ++++++++++----------
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |    5 +-
 3 files changed, 50 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 8825460..1cfebfe 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -911,7 +911,7 @@ static inline int lu_fid_cmp(const struct lu_fid *f0,
 		__diff_normalize(fid_ver(f0), fid_ver(f1));
 }
 
-static inline void ostid_cpu_to_le(struct ost_id *src_oi,
+static inline void ostid_cpu_to_le(const struct ost_id *src_oi,
 				   struct ost_id *dst_oi)
 {
 	if (fid_seq_is_mdt0(ostid_seq(src_oi))) {
@@ -922,7 +922,7 @@ static inline void ostid_cpu_to_le(struct ost_id *src_oi,
 	}
 }
 
-static inline void ostid_le_to_cpu(struct ost_id *src_oi,
+static inline void ostid_le_to_cpu(const struct ost_id *src_oi,
 				   struct ost_id *dst_oi)
 {
 	if (fid_seq_is_mdt0(ostid_seq(src_oi))) {
diff --git a/drivers/staging/lustre/lustre/include/lustre_fid.h b/drivers/staging/lustre/lustre/include/lustre_fid.h
index 7d20cba..7523b40 100644
--- a/drivers/staging/lustre/lustre/include/lustre_fid.h
+++ b/drivers/staging/lustre/lustre/include/lustre_fid.h
@@ -488,74 +488,75 @@ struct ldlm_namespace;
  * renaming name[2,3] fields that need to be used for the quota identifier.
  */
 static inline struct ldlm_res_id *
-fid_build_reg_res_name(const struct lu_fid *f,
-		       struct ldlm_res_id *name)
+fid_build_reg_res_name(const struct lu_fid *fid, struct ldlm_res_id *res)
 {
-	memset(name, 0, sizeof *name);
-	name->name[LUSTRE_RES_ID_SEQ_OFF] = fid_seq(f);
-	name->name[LUSTRE_RES_ID_VER_OID_OFF] = fid_ver_oid(f);
-	return name;
+	memset(res, 0, sizeof(*res));
+	res->name[LUSTRE_RES_ID_SEQ_OFF] = fid_seq(fid);
+	res->name[LUSTRE_RES_ID_VER_OID_OFF] = fid_ver_oid(fid);
+
+	return res;
+}
+
+/*
+ * Return true if resource is for object identified by FID.
+ */
+static inline int fid_res_name_eq(const struct lu_fid *fid,
+				  const struct ldlm_res_id *res)
+{
+	return res->name[LUSTRE_RES_ID_SEQ_OFF] == fid_seq(fid) &&
+	       res->name[LUSTRE_RES_ID_VER_OID_OFF] == fid_ver_oid(fid);
+}
+
+/*
+ * Extract FID from LDLM resource. Reverse of fid_build_reg_res_name().
+ */
+static inline struct lu_fid *
+fid_extract_from_res_name(struct lu_fid *fid, const struct ldlm_res_id *res)
+{
+	fid->f_seq = res->name[LUSTRE_RES_ID_SEQ_OFF];
+	fid->f_oid = (__u32)(res->name[LUSTRE_RES_ID_VER_OID_OFF]);
+	fid->f_ver = (__u32)(res->name[LUSTRE_RES_ID_VER_OID_OFF] >> 32);
+	LASSERT(fid_res_name_eq(fid, res));
+
+	return fid;
 }
 
 /*
  * Build (DLM) resource identifier from global quota FID and quota ID.
  */
 static inline struct ldlm_res_id *
-fid_build_quota_resid(const struct lu_fid *glb_fid, union lquota_id *qid,
+fid_build_quota_res_name(const struct lu_fid *glb_fid, union lquota_id *qid,
 		      struct ldlm_res_id *res)
 {
 	fid_build_reg_res_name(glb_fid, res);
 	res->name[LUSTRE_RES_ID_QUOTA_SEQ_OFF] = fid_seq(&qid->qid_fid);
 	res->name[LUSTRE_RES_ID_QUOTA_VER_OID_OFF] = fid_ver_oid(&qid->qid_fid);
+
 	return res;
 }
 
 /*
  * Extract global FID and quota ID from resource name
  */
-static inline void fid_extract_quota_resid(struct ldlm_res_id *res,
-					   struct lu_fid *glb_fid,
-					   union lquota_id *qid)
+static inline void fid_extract_from_quota_res(struct lu_fid *glb_fid,
+					      union lquota_id *qid,
+					      const struct ldlm_res_id *res)
 {
-	glb_fid->f_seq = res->name[LUSTRE_RES_ID_SEQ_OFF];
-	glb_fid->f_oid = (__u32)res->name[LUSTRE_RES_ID_VER_OID_OFF];
-	glb_fid->f_ver = (__u32)(res->name[LUSTRE_RES_ID_VER_OID_OFF] >> 32);
-
+	fid_extract_from_res_name(glb_fid, res);
 	qid->qid_fid.f_seq = res->name[LUSTRE_RES_ID_QUOTA_SEQ_OFF];
 	qid->qid_fid.f_oid = (__u32)res->name[LUSTRE_RES_ID_QUOTA_VER_OID_OFF];
 	qid->qid_fid.f_ver =
 		(__u32)(res->name[LUSTRE_RES_ID_QUOTA_VER_OID_OFF] >> 32);
 }
 
-/*
- * Return true if resource is for object identified by fid.
- */
-static inline int fid_res_name_eq(const struct lu_fid *f,
-				  const struct ldlm_res_id *name)
-{
-	return name->name[LUSTRE_RES_ID_SEQ_OFF] == fid_seq(f) &&
-	       name->name[LUSTRE_RES_ID_VER_OID_OFF] == fid_ver_oid(f);
-}
-
-/* reverse function of fid_build_reg_res_name() */
-static inline void fid_build_from_res_name(struct lu_fid *f,
-					   const struct ldlm_res_id *name)
-{
-	fid_zero(f);
-	f->f_seq = name->name[LUSTRE_RES_ID_SEQ_OFF];
-	f->f_oid = name->name[LUSTRE_RES_ID_VER_OID_OFF] & 0xffffffff;
-	f->f_ver = name->name[LUSTRE_RES_ID_VER_OID_OFF] >> 32;
-	LASSERT(fid_res_name_eq(f, name));
-}
-
 static inline struct ldlm_res_id *
-fid_build_pdo_res_name(const struct lu_fid *f,
-		       unsigned int hash,
-		       struct ldlm_res_id *name)
+fid_build_pdo_res_name(const struct lu_fid *fid, unsigned int hash,
+		       struct ldlm_res_id *res)
 {
-	fid_build_reg_res_name(f, name);
-	name->name[LUSTRE_RES_ID_HSH_OFF] = hash;
-	return name;
+	fid_build_reg_res_name(fid, res);
+	res->name[LUSTRE_RES_ID_HSH_OFF] = hash;
+
+	return res;
 }
 
 /**
@@ -584,7 +585,7 @@ static inline void ostid_build_res_name(struct ost_id *oi,
 		name->name[LUSTRE_RES_ID_SEQ_OFF] = ostid_id(oi);
 		name->name[LUSTRE_RES_ID_VER_OID_OFF] = ostid_seq(oi);
 	} else {
-		fid_build_reg_res_name((struct lu_fid *)oi, name);
+		fid_build_reg_res_name(&oi->oi_fid, name);
 	}
 }
 
@@ -597,7 +598,7 @@ static inline void ostid_res_name_to_id(struct ost_id *oi,
 		ostid_set_id(oi, name->name[LUSTRE_RES_ID_SEQ_OFF]);
 	} else {
 		/* new resid */
-		fid_build_from_res_name((struct lu_fid *)oi, name);
+		fid_extract_from_res_name(&oi->oi_fid, name);
 	}
 }
 
@@ -644,7 +645,7 @@ static inline void ost_fid_from_resid(struct lu_fid *fid,
 		ostid_to_fid(fid, &oi, 0);
 	} else {
 		/* new resid */
-		fid_build_from_res_name(fid, name);
+		fid_extract_from_res_name(fid, name);
 	}
 }
 
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
index 9052dc5..cb8659f 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
@@ -1128,8 +1128,9 @@ ldlm_resource_get(struct ldlm_namespace *ns, struct ldlm_resource *parent,
 		OBD_FAIL_TIMEOUT(OBD_FAIL_LDLM_CREATE_RESOURCE, 2);
 		rc = ns->ns_lvbo->lvbo_init(res);
 		if (rc < 0) {
-			CERROR("lvbo_init failed for resource "
-			       LPU64": rc %d\n", name->name[0], rc);
+			CERROR("%s: lvbo_init failed for resource "LPX64":"
+			       LPX64": rc = %d\n", ns->ns_obd->obd_name,
+			       name->name[0], name->name[1], rc);
 			if (res->lr_lvb_data) {
 				OBD_FREE(res->lr_lvb_data, res->lr_lvb_len);
 				res->lr_lvb_data = NULL;
-- 
1.7.9.5

