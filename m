Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab3LCOEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:04:55 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:41345 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3LCOEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:04:50 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jinshan Xiong <jinshan.xiong@intel.com>,
        Aurelien Degremont <aurelien.degremont@cea.fr>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v3 10/15] staging/lustre/hsm: Add hsm_release feature.
Date: Tue,  3 Dec 2013 21:58:48 +0800
Message-Id: <1386079133-6459-11-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
References: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jinshan Xiong <jinshan.xiong@intel.com>

HSM Release is one of the key feature of HSM. To perform HSM
release, clients need to acquire the file lease exclusivelt and
flush dirty cache from clients. A special close REQ will be sent
to the MDT to release the lease and get rid of OST objects.

Lustre-change: http://review.whamcloud.com/7028
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-1333
Signed-off-by: Aurelien Degremont <aurelien.degremont@cea.fr>
Signed-off-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      |   14 +++-
 .../lustre/lustre/include/lustre/lustre_user.h     |   11 ++-
 .../lustre/lustre/include/lustre_req_layout.h      |    2 +
 drivers/staging/lustre/lustre/include/obd.h        |    6 +-
 .../staging/lustre/lustre/lclient/lcommon_misc.c   |    4 +-
 drivers/staging/lustre/lustre/llite/dir.c          |   24 +++++-
 drivers/staging/lustre/lustre/llite/file.c         |   87 +++++++++++++++++---
 .../staging/lustre/lustre/llite/llite_internal.h   |    3 +-
 drivers/staging/lustre/lustre/llite/vvp_object.c   |    2 +-
 .../staging/lustre/lustre/lov/lov_cl_internal.h    |   16 ++++
 drivers/staging/lustre/lustre/lov/lov_object.c     |   35 +++++---
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |   26 +++++-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |   23 +++++-
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |   19 +++++
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |    7 ++
 15 files changed, 242 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index dd94dc8..77edf7d 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -1761,6 +1761,7 @@ static inline __u32 lov_mds_md_size(__u16 stripes, __u32 lmm_magic)
 #define OBD_MD_FLRMTRGETFACL (0x0008000000000000ULL) /* lfs rgetfacl case */
 
 #define OBD_MD_FLDATAVERSION (0x0010000000000000ULL) /* iversion sum */
+#define OBD_MD_FLRELEASED    (0x0020000000000000ULL) /* file released */
 
 #define OBD_MD_FLGETATTR (OBD_MD_FLID    | OBD_MD_FLATIME | OBD_MD_FLMTIME | \
 			  OBD_MD_FLCTIME | OBD_MD_FLSIZE  | OBD_MD_FLBLKSZ | \
@@ -2397,6 +2398,7 @@ extern void lustre_swab_mdt_rec_setattr (struct mdt_rec_setattr *sa);
 					      * delegation, succeed if it's not
 					      * being opened with conflict mode.
 					      */
+#define MDS_OPEN_RELEASE   02000000000000ULL /* Open the file for HSM release */
 
 /* permission for create non-directory file */
 #define MAY_CREATE      (1 << 7)
@@ -2415,7 +2417,7 @@ extern void lustre_swab_mdt_rec_setattr (struct mdt_rec_setattr *sa);
 /* lfs rgetfacl permission check */
 #define MAY_RGETFACL    (1 << 14)
 
-enum {
+enum mds_op_bias {
 	MDS_CHECK_SPLIT		= 1 << 0,
 	MDS_CROSS_REF		= 1 << 1,
 	MDS_VTX_BYPASS		= 1 << 2,
@@ -2428,6 +2430,7 @@ enum {
 	MDS_DATA_MODIFIED	= 1 << 9,
 	MDS_CREATE_VOLATILE	= 1 << 10,
 	MDS_OWNEROVERRIDE	= 1 << 11,
+	MDS_HSM_RELEASE		= 1 << 12,
 };
 
 /* instance of mdt_reint_rec */
@@ -3751,5 +3754,14 @@ struct mdc_swap_layouts {
 
 void lustre_swab_swap_layouts(struct mdc_swap_layouts *msl);
 
+struct close_data {
+	struct lustre_handle	cd_handle;
+	struct lu_fid		cd_fid;
+	__u64			cd_data_version;
+	__u64			cd_reserved[8];
+};
+
+void lustre_swab_close_data(struct close_data *data);
+
 #endif
 /** @} lustreidl */
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index 631f026..c7abb80 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -623,10 +623,13 @@ struct if_quotactl {
 };
 
 /* swap layout flags */
-#define	SWAP_LAYOUTS_CHECK_DV1		(1 << 0)
-#define	SWAP_LAYOUTS_CHECK_DV2		(1 << 1)
-#define	SWAP_LAYOUTS_KEEP_MTIME		(1 << 2)
-#define	SWAP_LAYOUTS_KEEP_ATIME		(1 << 3)
+#define SWAP_LAYOUTS_CHECK_DV1		(1 << 0)
+#define SWAP_LAYOUTS_CHECK_DV2		(1 << 1)
+#define SWAP_LAYOUTS_KEEP_MTIME		(1 << 2)
+#define SWAP_LAYOUTS_KEEP_ATIME		(1 << 3)
+
+/* Swap XATTR_NAME_HSM as well, only on the MDT so far */
+#define SWAP_LAYOUTS_MDS_HSM		(1 << 31)
 struct lustre_swap_layouts {
 	__u64	sl_flags;
 	__u32	sl_fd;
diff --git a/drivers/staging/lustre/lustre/include/lustre_req_layout.h b/drivers/staging/lustre/lustre/include/lustre_req_layout.h
index 2832569..a75f4c6 100644
--- a/drivers/staging/lustre/lustre/include/lustre_req_layout.h
+++ b/drivers/staging/lustre/lustre/include/lustre_req_layout.h
@@ -164,6 +164,7 @@ extern struct req_format RQF_UPDATE_OBJ;
  */
 extern struct req_format RQF_MDS_GETATTR_NAME;
 extern struct req_format RQF_MDS_CLOSE;
+extern struct req_format RQF_MDS_RELEASE_CLOSE;
 extern struct req_format RQF_MDS_PIN;
 extern struct req_format RQF_MDS_UNPIN;
 extern struct req_format RQF_MDS_CONNECT;
@@ -262,6 +263,7 @@ extern struct req_msg_field RMF_GETINFO_VAL;
 extern struct req_msg_field RMF_GETINFO_VALLEN;
 extern struct req_msg_field RMF_GETINFO_KEY;
 extern struct req_msg_field RMF_IDX_INFO;
+extern struct req_msg_field RMF_CLOSE_DATA;
 
 /*
  * connection handle received in MDS_CONNECT request.
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index f0c1773..3247d1d 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -1070,7 +1070,7 @@ struct md_op_data {
 	struct obd_capa	*op_capa2;
 
 	/* Various operation flags. */
-	__u32		   op_bias;
+	enum mds_op_bias        op_bias;
 
 	/* Operation type */
 	__u32		   op_opc;
@@ -1084,6 +1084,10 @@ struct md_op_data {
 	/* used to transfer info between the stacks of MD client
 	 * see enum op_cli_flags */
 	__u32			op_cli_flags;
+
+	/* File object data version for HSM release, on client */
+	__u64			op_data_version;
+	struct lustre_handle	op_lease_handle;
 };
 
 enum op_cli_flags {
diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_misc.c b/drivers/staging/lustre/lustre/lclient/lcommon_misc.c
index 2b4dbee..e04c2d3 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_misc.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_misc.c
@@ -140,7 +140,9 @@ int cl_get_grouplock(struct cl_object *obj, unsigned long gid, int nonblock,
 
 	rc = cl_io_init(env, io, CIT_MISC, io->ci_obj);
 	if (rc) {
-		LASSERT(rc < 0);
+		/* Does not make sense to take GL for released layout */
+		if (rc > 0)
+			rc = -ENOTSUPP;
 		cl_env_put(env, &refcheck);
 		return rc;
 	}
diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index 1f07903..22d0acc9 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -1809,8 +1809,28 @@ out_rmdir:
 			return -EFAULT;
 		}
 
-		rc = obd_iocontrol(cmd, ll_i2mdexp(inode), totalsize,
-				   hur, NULL);
+		if (hur->hur_request.hr_action == HUA_RELEASE) {
+			const struct lu_fid *fid;
+			struct inode *f;
+			int i;
+
+			for (i = 0; i < hur->hur_request.hr_itemcount; i++) {
+				fid = &hur->hur_user_item[i].hui_fid;
+				f = search_inode_for_lustre(inode->i_sb, fid);
+				if (IS_ERR(f)) {
+					rc = PTR_ERR(f);
+					break;
+				}
+
+				rc = ll_hsm_release(f);
+				iput(f);
+				if (rc != 0)
+					break;
+			}
+		} else {
+			rc = obd_iocontrol(cmd, ll_i2mdexp(inode), totalsize,
+					   hur, NULL);
+		}
 
 		OBD_FREE_LARGE(hur, totalsize);
 
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 82248e9..95d7364 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -115,7 +115,8 @@ out:
 
 static int ll_close_inode_openhandle(struct obd_export *md_exp,
 				     struct inode *inode,
-				     struct obd_client_handle *och)
+				     struct obd_client_handle *och,
+				     const __u64 *data_version)
 {
 	struct obd_export *exp = ll_i2mdexp(inode);
 	struct md_op_data *op_data;
@@ -139,6 +140,13 @@ static int ll_close_inode_openhandle(struct obd_export *md_exp,
 		GOTO(out, rc = -ENOMEM); // XXX We leak openhandle and request here.
 
 	ll_prepare_close(inode, op_data, och);
+	if (data_version != NULL) {
+		/* Pass in data_version implies release. */
+		op_data->op_bias |= MDS_HSM_RELEASE;
+		op_data->op_data_version = *data_version;
+		op_data->op_lease_handle = och->och_lease_handle;
+		op_data->op_attr.ia_valid |= ATTR_SIZE | ATTR_BLOCKS;
+	}
 	epoch_close = (op_data->op_flags & MF_EPOCH_CLOSE);
 	rc = md_close(md_exp, op_data, och->och_mod, &req);
 	if (rc == -EAGAIN) {
@@ -167,14 +175,20 @@ static int ll_close_inode_openhandle(struct obd_export *md_exp,
 		spin_unlock(&lli->lli_lock);
 	}
 
-	ll_finish_md_op_data(op_data);
-
 	if (rc == 0) {
 		rc = ll_objects_destroy(req, inode);
 		if (rc)
 			CERROR("inode %lu ll_objects destroy: rc = %d\n",
 			       inode->i_ino, rc);
 	}
+	if (rc == 0 && op_data->op_bias & MDS_HSM_RELEASE) {
+		struct mdt_body *body;
+		body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
+		if (!(body->valid & OBD_MD_FLRELEASED))
+			rc = -EBUSY;
+	}
+
+	ll_finish_md_op_data(op_data);
 
 out:
 	if (exp_connect_som(exp) && !epoch_close &&
@@ -224,7 +238,7 @@ int ll_md_real_close(struct inode *inode, int flags)
 	if (och) { /* There might be a race and somebody have freed this och
 		      already */
 		rc = ll_close_inode_openhandle(ll_i2sbi(inode)->ll_md_exp,
-					       inode, och);
+					       inode, och, NULL);
 	}
 
 	return rc;
@@ -254,7 +268,7 @@ int ll_md_close(struct obd_export *md_exp, struct inode *inode,
 	}
 
 	if (fd->fd_och != NULL) {
-		rc = ll_close_inode_openhandle(md_exp, inode, fd->fd_och);
+		rc = ll_close_inode_openhandle(md_exp, inode, fd->fd_och, NULL);
 		fd->fd_och = NULL;
 		GOTO(out, rc);
 	}
@@ -719,7 +733,7 @@ static int ll_md_blocking_lease_ast(struct ldlm_lock *lock,
  * Acquire a lease and open the file.
  */
 struct obd_client_handle *ll_lease_open(struct inode *inode, struct file *file,
-					fmode_t fmode)
+					fmode_t fmode, __u64 open_flags)
 {
 	struct lookup_intent it = { .it_op = IT_OPEN };
 	struct ll_sb_info *sbi = ll_i2sbi(inode);
@@ -787,7 +801,8 @@ struct obd_client_handle *ll_lease_open(struct inode *inode, struct file *file,
 	/* To tell the MDT this openhandle is from the same owner */
 	op_data->op_handle = old_handle;
 
-	it.it_flags = fmode | MDS_OPEN_LOCK | MDS_OPEN_BY_FID | MDS_OPEN_LEASE;
+	it.it_flags = fmode | open_flags;
+	it.it_flags |= MDS_OPEN_LOCK | MDS_OPEN_BY_FID | MDS_OPEN_LEASE;
 	rc = md_intent_lock(sbi->ll_md_exp, op_data, NULL, 0, &it, 0, &req,
 				ll_md_blocking_lease_ast,
 	/* LDLM_FL_NO_LRU: To not put the lease lock into LRU list, otherwise
@@ -833,7 +848,7 @@ struct obd_client_handle *ll_lease_open(struct inode *inode, struct file *file,
 	return och;
 
 out_close:
-	rc2 = ll_close_inode_openhandle(sbi->ll_md_exp, inode, och);
+	rc2 = ll_close_inode_openhandle(sbi->ll_md_exp, inode, och, NULL);
 	if (rc2)
 		CERROR("Close openhandle returned %d\n", rc2);
 
@@ -878,7 +893,8 @@ int ll_lease_close(struct obd_client_handle *och, struct inode *inode,
 	if (lease_broken != NULL)
 		*lease_broken = cancelled;
 
-	rc = ll_close_inode_openhandle(ll_i2sbi(inode)->ll_md_exp, inode, och);
+	rc = ll_close_inode_openhandle(ll_i2sbi(inode)->ll_md_exp, inode, och,
+				       NULL);
 	return rc;
 }
 EXPORT_SYMBOL(ll_lease_close);
@@ -1687,8 +1703,8 @@ int ll_release_openhandle(struct dentry *dentry, struct lookup_intent *it)
 	ll_och_fill(ll_i2sbi(inode)->ll_md_exp, it, och);
 
 	rc = ll_close_inode_openhandle(ll_i2sbi(inode)->ll_md_exp,
-				       inode, och);
- out:
+				       inode, och, NULL);
+out:
 	/* this one is in place of ll_file_open */
 	if (it_disposition(it, DISP_ENQ_OPEN_REF)) {
 		ptlrpc_req_finished(it->d.lustre.it_data);
@@ -1893,6 +1909,53 @@ out:
 	return rc;
 }
 
+/*
+ * Trigger a HSM release request for the provided inode.
+ */
+int ll_hsm_release(struct inode *inode)
+{
+	struct cl_env_nest nest;
+	struct lu_env *env;
+	struct obd_client_handle *och = NULL;
+	__u64 data_version = 0;
+	int rc;
+
+
+	CDEBUG(D_INODE, "%s: Releasing file "DFID".\n",
+	       ll_get_fsname(inode->i_sb, NULL, 0),
+	       PFID(&ll_i2info(inode)->lli_fid));
+
+	och = ll_lease_open(inode, NULL, FMODE_WRITE, MDS_OPEN_RELEASE);
+	if (IS_ERR(och))
+		GOTO(out, rc = PTR_ERR(och));
+
+	/* Grab latest data_version and [am]time values */
+	rc = ll_data_version(inode, &data_version, 1);
+	if (rc != 0)
+		GOTO(out, rc);
+
+	env = cl_env_nested_get(&nest);
+	if (IS_ERR(env))
+		GOTO(out, rc = PTR_ERR(env));
+
+	ll_merge_lvb(env, inode);
+	cl_env_nested_put(&nest, env);
+
+	/* Release the file.
+	 * NB: lease lock handle is released in mdc_hsm_release_pack() because
+	 * we still need it to pack l_remote_handle to MDT. */
+	rc = ll_close_inode_openhandle(ll_i2sbi(inode)->ll_md_exp, inode, och,
+				       &data_version);
+	och = NULL;
+
+
+out:
+	if (och != NULL && !IS_ERR(och)) /* close the file */
+		ll_lease_close(och, inode, NULL);
+
+	return rc;
+}
+
 struct ll_swap_stack {
 	struct iattr		 ia1, ia2;
 	__u64			 dv1, dv2;
@@ -2320,7 +2383,7 @@ long ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		CDEBUG(D_INODE, "Set lease with mode %d\n", mode);
 
 		/* apply for lease */
-		och = ll_lease_open(inode, file, mode);
+		och = ll_lease_open(inode, file, mode, 0);
 		if (IS_ERR(och))
 			return PTR_ERR(och);
 
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index b6a22b6..e479a69 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -787,9 +787,10 @@ int ll_get_grouplock(struct inode *inode, struct file *file, unsigned long arg);
 int ll_put_grouplock(struct inode *inode, struct file *file, unsigned long arg);
 int ll_fid2path(struct inode *inode, void *arg);
 int ll_data_version(struct inode *inode, __u64 *data_version, int extent_lock);
+int ll_hsm_release(struct inode *inode);
 
 struct obd_client_handle *ll_lease_open(struct inode *inode, struct file *file,
-					fmode_t mode);
+					fmode_t mode, __u64 flags);
 int ll_lease_close(struct obd_client_handle *och, struct inode *inode,
 		   bool *lease_broken);
 
diff --git a/drivers/staging/lustre/lustre/llite/vvp_object.c b/drivers/staging/lustre/lustre/llite/vvp_object.c
index 33173fc..25973de 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_object.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_object.c
@@ -138,7 +138,7 @@ int vvp_conf_set(const struct lu_env *env, struct cl_object *obj,
 			lli->lli_layout_gen,
 			conf->u.coc_md->lsm->lsm_layout_gen);
 
-		lli->lli_has_smd = true;
+		lli->lli_has_smd = lsm_has_objects(conf->u.coc_md->lsm);
 		lli->lli_layout_gen = conf->u.coc_md->lsm->lsm_layout_gen;
 	} else {
 		CDEBUG(D_VFSTRACE, "layout lock destroyed: %u.\n",
diff --git a/drivers/staging/lustre/lustre/lov/lov_cl_internal.h b/drivers/staging/lustre/lustre/lov/lov_cl_internal.h
index 4276124..3965d5e 100644
--- a/drivers/staging/lustre/lustre/lov/lov_cl_internal.h
+++ b/drivers/staging/lustre/lustre/lov/lov_cl_internal.h
@@ -168,6 +168,22 @@ enum lov_layout_type {
 	LLT_NR
 };
 
+static inline char *llt2str(enum lov_layout_type llt)
+{
+	switch (llt) {
+	case LLT_EMPTY:
+		return "EMPTY";
+	case LLT_RAID0:
+		return "RAID0";
+	case LLT_RELEASED:
+		return "RELEASED";
+	case LLT_NR:
+		LBUG();
+	}
+	LBUG();
+	return "";
+}
+
 /**
  * lov-specific file state.
  *
diff --git a/drivers/staging/lustre/lustre/lov/lov_object.c b/drivers/staging/lustre/lustre/lov/lov_object.c
index cf2fa8a..df8b5b5 100644
--- a/drivers/staging/lustre/lustre/lov/lov_object.c
+++ b/drivers/staging/lustre/lustre/lov/lov_object.c
@@ -393,13 +393,13 @@ static int lov_print_empty(const struct lu_env *env, void *cookie,
 static int lov_print_raid0(const struct lu_env *env, void *cookie,
 			   lu_printer_t p, const struct lu_object *o)
 {
-	struct lov_object       *lov = lu2lov(o);
-	struct lov_layout_raid0 *r0  = lov_r0(lov);
-	struct lov_stripe_md    *lsm = lov->lo_lsm;
-	int i;
+	struct lov_object	*lov = lu2lov(o);
+	struct lov_layout_raid0	*r0  = lov_r0(lov);
+	struct lov_stripe_md	*lsm = lov->lo_lsm;
+	int			 i;
 
-	(*p)(env, cookie, "stripes: %d, %svalid, lsm{%p 0x%08X %d %u %u}: \n",
-		r0->lo_nr, lov->lo_layout_invalid ? "in" : "", lsm,
+	(*p)(env, cookie, "stripes: %d, %s, lsm{%p 0x%08X %d %u %u}:\n",
+		r0->lo_nr, lov->lo_layout_invalid ? "invalid" : "valid", lsm,
 		lsm->lsm_magic, atomic_read(&lsm->lsm_refc),
 		lsm->lsm_stripe_count, lsm->lsm_layout_gen);
 	for (i = 0; i < r0->lo_nr; ++i) {
@@ -408,8 +408,9 @@ static int lov_print_raid0(const struct lu_env *env, void *cookie,
 		if (r0->lo_sub[i] != NULL) {
 			sub = lovsub2lu(r0->lo_sub[i]);
 			lu_object_print(env, cookie, p, sub);
-		} else
+		} else {
 			(*p)(env, cookie, "sub %d absent\n", i);
+		}
 	}
 	return 0;
 }
@@ -417,7 +418,14 @@ static int lov_print_raid0(const struct lu_env *env, void *cookie,
 static int lov_print_released(const struct lu_env *env, void *cookie,
 				lu_printer_t p, const struct lu_object *o)
 {
-	(*p)(env, cookie, "released\n");
+	struct lov_object	*lov = lu2lov(o);
+	struct lov_stripe_md	*lsm = lov->lo_lsm;
+
+	(*p)(env, cookie,
+		"released: %s, lsm{%p 0x%08X %d %u %u}:\n",
+		lov->lo_layout_invalid ? "invalid" : "valid", lsm,
+		lsm->lsm_magic, atomic_read(&lsm->lsm_refc),
+		lsm->lsm_stripe_count, lsm->lsm_layout_gen);
 	return 0;
 }
 
@@ -662,6 +670,10 @@ static int lov_layout_change(const struct lu_env *unused,
 		return PTR_ERR(env);
 	}
 
+	CDEBUG(D_INODE, DFID" from %s to %s\n",
+	       PFID(lu_object_fid(lov2lu(lov))),
+	       llt2str(lov->lo_type), llt2str(llt));
+
 	old_ops = &lov_dispatch[lov->lo_type];
 	new_ops = &lov_dispatch[llt];
 
@@ -750,8 +762,9 @@ static int lov_conf_set(const struct lu_env *env, struct cl_object *obj,
 	if (conf->u.coc_md != NULL)
 		lsm = conf->u.coc_md->lsm;
 	if ((lsm == NULL && lov->lo_lsm == NULL) ||
-	    (lsm != NULL && lov->lo_lsm != NULL &&
-	     lov->lo_lsm->lsm_layout_gen == lsm->lsm_layout_gen)) {
+	    ((lsm != NULL && lov->lo_lsm != NULL) &&
+	     (lov->lo_lsm->lsm_layout_gen == lsm->lsm_layout_gen) &&
+	     (lov->lo_lsm->lsm_pattern == lsm->lsm_pattern))) {
 		/* same version of layout */
 		lov->lo_layout_invalid = false;
 		GOTO(out, result = 0);
@@ -767,6 +780,8 @@ static int lov_conf_set(const struct lu_env *env, struct cl_object *obj,
 
 out:
 	lov_conf_unlock(lov);
+	CDEBUG(D_INODE, DFID" lo_layout_invalid=%d\n",
+	       PFID(lu_object_fid(lov2lu(lov))), lov->lo_layout_invalid);
 	return result;
 }
 
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_lib.c b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
index 3e77020..91f6876 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_lib.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
@@ -179,7 +179,8 @@ static __u64 mds_pack_open_flags(__u64 flags, __u32 mode)
 	__u64 cr_flags = (flags & (FMODE_READ | FMODE_WRITE |
 				   MDS_OPEN_HAS_EA | MDS_OPEN_HAS_OBJS |
 				   MDS_OPEN_OWNEROVERRIDE | MDS_OPEN_LOCK |
-				   MDS_OPEN_BY_FID | MDS_OPEN_LEASE));
+				   MDS_OPEN_BY_FID | MDS_OPEN_LEASE |
+				   MDS_OPEN_RELEASE));
 	if (flags & O_CREAT)
 		cr_flags |= MDS_OPEN_CREAT;
 	if (flags & O_EXCL)
@@ -490,6 +491,28 @@ void mdc_getattr_pack(struct ptlrpc_request *req, __u64 valid, int flags,
 	}
 }
 
+static void mdc_hsm_release_pack(struct ptlrpc_request *req,
+				 struct md_op_data *op_data)
+{
+	if (op_data->op_bias & MDS_HSM_RELEASE) {
+		struct close_data *data;
+		struct ldlm_lock *lock;
+
+		data = req_capsule_client_get(&req->rq_pill, &RMF_CLOSE_DATA);
+		LASSERT(data != NULL);
+
+		lock = ldlm_handle2lock(&op_data->op_lease_handle);
+		if (lock != NULL) {
+			data->cd_handle = lock->l_remote_handle;
+			ldlm_lock_put(lock);
+		}
+		ldlm_cli_cancel(&op_data->op_lease_handle, LCF_LOCAL);
+
+		data->cd_data_version = op_data->op_data_version;
+		data->cd_fid = op_data->op_fid2;
+	}
+}
+
 void mdc_close_pack(struct ptlrpc_request *req, struct md_op_data *op_data)
 {
 	struct mdt_ioepoch *epoch;
@@ -501,6 +524,7 @@ void mdc_close_pack(struct ptlrpc_request *req, struct md_op_data *op_data)
 	mdc_setattr_pack_rec(rec, op_data);
 	mdc_pack_capa(req, &RMF_CAPA1, op_data->op_capa1);
 	mdc_ioepoch_pack(epoch, op_data);
+	mdc_hsm_release_pack(req, op_data);
 }
 
 static int mdc_req_avail(struct client_obd *cli, struct mdc_cache_waiter *mcw)
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 8373778..0b43251 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -800,10 +800,27 @@ int mdc_close(struct obd_export *exp, struct md_op_data *op_data,
 {
 	struct obd_device     *obd = class_exp2obd(exp);
 	struct ptlrpc_request *req;
-	int		    rc;
+	struct req_format     *req_fmt;
+	int                    rc;
+	int		       saved_rc = 0;
+
+
+	req_fmt = &RQF_MDS_CLOSE;
+	if (op_data->op_bias & MDS_HSM_RELEASE) {
+		req_fmt = &RQF_MDS_RELEASE_CLOSE;
+
+		/* allocate a FID for volatile file */
+		rc = mdc_fid_alloc(exp, &op_data->op_fid2, op_data);
+		if (rc < 0) {
+			CERROR("%s: "DFID" failed to allocate FID: %d\n",
+			       obd->obd_name, PFID(&op_data->op_fid1), rc);
+			/* save the errcode and proceed to close */
+			saved_rc = rc;
+		}
+	}
 
 	*request = NULL;
-	req = ptlrpc_request_alloc(class_exp2cliimp(exp), &RQF_MDS_CLOSE);
+	req = ptlrpc_request_alloc(class_exp2cliimp(exp), req_fmt);
 	if (req == NULL)
 		return -ENOMEM;
 
@@ -893,7 +910,7 @@ int mdc_close(struct obd_export *exp, struct md_op_data *op_data,
 	}
 	*request = req;
 	mdc_close_handle_reply(req, op_data, rc);
-	return rc;
+	return rc < 0 ? rc : saved_rc;
 }
 
 int mdc_done_writing(struct obd_export *exp, struct md_op_data *op_data,
diff --git a/drivers/staging/lustre/lustre/ptlrpc/layout.c b/drivers/staging/lustre/lustre/ptlrpc/layout.c
index 4d6ac686..c4381eb 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/layout.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/layout.c
@@ -145,6 +145,14 @@ static const struct req_msg_field *mdt_close_client[] = {
 	&RMF_CAPA1
 };
 
+static const struct req_msg_field *mdt_release_close_client[] = {
+	&RMF_PTLRPC_BODY,
+	&RMF_MDT_EPOCH,
+	&RMF_REC_REINT,
+	&RMF_CAPA1,
+	&RMF_CLOSE_DATA
+};
+
 static const struct req_msg_field *obd_statfs_server[] = {
 	&RMF_PTLRPC_BODY,
 	&RMF_OBD_STATFS
@@ -666,6 +674,7 @@ static struct req_format *req_formats[] = {
 	&RQF_MDS_GETXATTR,
 	&RQF_MDS_SYNC,
 	&RQF_MDS_CLOSE,
+	&RQF_MDS_RELEASE_CLOSE,
 	&RQF_MDS_PIN,
 	&RQF_MDS_UNPIN,
 	&RQF_MDS_READPAGE,
@@ -885,6 +894,11 @@ struct req_msg_field RMF_PTLRPC_BODY =
 		    sizeof(struct ptlrpc_body), lustre_swab_ptlrpc_body, NULL);
 EXPORT_SYMBOL(RMF_PTLRPC_BODY);
 
+struct req_msg_field RMF_CLOSE_DATA =
+	DEFINE_MSGF("data_version", 0,
+		    sizeof(struct close_data), lustre_swab_close_data, NULL);
+EXPORT_SYMBOL(RMF_CLOSE_DATA);
+
 struct req_msg_field RMF_OBD_STATFS =
 	DEFINE_MSGF("obd_statfs", 0,
 		    sizeof(struct obd_statfs), lustre_swab_obd_statfs, NULL);
@@ -1412,6 +1426,11 @@ struct req_format RQF_MDS_CLOSE =
 			mdt_close_client, mds_last_unlink_server);
 EXPORT_SYMBOL(RQF_MDS_CLOSE);
 
+struct req_format RQF_MDS_RELEASE_CLOSE =
+	DEFINE_REQ_FMT0("MDS_CLOSE",
+			mdt_release_close_client, mds_last_unlink_server);
+EXPORT_SYMBOL(RQF_MDS_RELEASE_CLOSE);
+
 struct req_format RQF_MDS_PIN =
 	DEFINE_REQ_FMT0("MDS_PIN",
 			mdt_body_capa, mdt_body_only);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
index d831bd7..464479c 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
@@ -2565,3 +2565,10 @@ void lustre_swab_swap_layouts(struct mdc_swap_layouts *msl)
 	__swab64s(&msl->msl_flags);
 }
 EXPORT_SYMBOL(lustre_swab_swap_layouts);
+
+void lustre_swab_close_data(struct close_data *cd)
+{
+	lustre_swab_lu_fid(&cd->cd_fid);
+	__swab64s(&cd->cd_data_version);
+}
+EXPORT_SYMBOL(lustre_swab_close_data);
-- 
1.7.9.5

