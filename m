Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744Ab3GOO2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:28:19 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:57417 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab3GOO2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:28:16 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v3 11/17] staging/lustre: fix build when CONFIG_UIDGID_STRICT_TYPE_CHECKS is on
Date: Mon, 15 Jul 2013 22:27:14 +0800
Message-Id: <1373898440-14208-12-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kuid_t/kgid_t are wrappered when CONFIG_UIDGID_STRICT_TYPE_CHECKS is on.
Lustre build is broken because we always treat them as plain __u32.
The patch fixes it. Internally, Lustre always use __u32 uid/gid, and
convert to kuid_t/kgid_t when necessary.

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/include/linux/libcfs/curproc.h  |    2 --
 drivers/staging/lustre/lustre/include/linux/lvfs.h |    8 +++----
 drivers/staging/lustre/lustre/include/lustre_cfg.h |    4 ----
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |   16 -------------
 .../lustre/lustre/libcfs/linux/linux-module.c      |    2 +-
 drivers/staging/lustre/lustre/llite/dir.c          |    9 ++++---
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   13 +++++-----
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |    3 ++-
 drivers/staging/lustre/lustre/llite/namei.c        |    7 +++---
 drivers/staging/lustre/lustre/llite/remote_perm.c  |   11 +++++----
 drivers/staging/lustre/lustre/llite/vvp_object.c   |    8 +++----
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |   12 +++++-----
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |   25 ++++++++++----------
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |    8 ++-----
 drivers/staging/lustre/lustre/obdclass/class_obd.c |    3 ++-
 drivers/staging/lustre/lustre/obdclass/idmap.c     |   12 ++++++----
 .../lustre/lustre/obdclass/linux/linux-obdo.c      |    4 ++--
 drivers/staging/lustre/lustre/obdclass/obdo.c      |   16 ++++++-------
 .../staging/lustre/lustre/obdecho/echo_client.c    |   12 ++++++----
 drivers/staging/lustre/lustre/ptlrpc/sec.c         |   19 ++++++++-------
 20 files changed, 93 insertions(+), 101 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/curproc.h b/drivers/staging/lustre/include/linux/libcfs/curproc.h
index 90d7ce6..de8e35b 100644
--- a/drivers/staging/lustre/include/linux/libcfs/curproc.h
+++ b/drivers/staging/lustre/include/linux/libcfs/curproc.h
@@ -49,8 +49,6 @@
  * Implemented in portals/include/libcfs/<os>/
  */
 int    cfs_curproc_groups_nr(void);
-int    current_is_in_group(gid_t group);
-void   cfs_curproc_groups_dump(gid_t *array, int size);
 
 /*
  * Plus, platform-specific constant
diff --git a/drivers/staging/lustre/lustre/include/linux/lvfs.h b/drivers/staging/lustre/lustre/include/linux/lvfs.h
index eb59ac7..e61f1b8 100644
--- a/drivers/staging/lustre/lustre/include/linux/lvfs.h
+++ b/drivers/staging/lustre/lustre/include/linux/lvfs.h
@@ -54,10 +54,10 @@
 /* simple.c */
 
 struct lvfs_ucred {
-	__u32		   luc_uid;
-	__u32		   luc_gid;
-	__u32		   luc_fsuid;
-	__u32		   luc_fsgid;
+	kuid_t		luc_uid;
+	kgid_t		luc_gid;
+	kuid_t		luc_fsuid;
+	kgid_t		luc_fsgid;
 	kernel_cap_t	luc_cap;
 	__u32		   luc_umask;
 	struct group_info      *luc_ginfo;
diff --git a/drivers/staging/lustre/lustre/include/lustre_cfg.h b/drivers/staging/lustre/lustre/include/lustre_cfg.h
index f12429f..fbf94a0 100644
--- a/drivers/staging/lustre/lustre/include/lustre_cfg.h
+++ b/drivers/staging/lustre/lustre/include/lustre_cfg.h
@@ -290,10 +290,6 @@ static inline int lustre_cfg_sanity_check(void *buf, int len)
 
 #include <lustre/lustre_user.h>
 
-#ifndef INVALID_UID
-#define INVALID_UID     (-1)
-#endif
-
 /** @} cfg */
 
 #endif // _LUSTRE_CFG_H
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
index f236510..706dfb3 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
@@ -65,20 +65,6 @@ int    cfs_curproc_groups_nr(void)
 	return nr;
 }
 
-void   cfs_curproc_groups_dump(gid_t *array, int size)
-{
-	task_lock(current);
-	size = min_t(int, size, current_cred()->group_info->ngroups);
-	memcpy(array, current_cred()->group_info->blocks[0], size * sizeof(__u32));
-	task_unlock(current);
-}
-
-
-int    current_is_in_group(gid_t gid)
-{
-	return in_group_p(gid);
-}
-
 /* Currently all the CFS_CAP_* defines match CAP_* ones. */
 #define cfs_cap_pack(cap) (cap)
 #define cfs_cap_unpack(cap) (cap)
@@ -318,8 +304,6 @@ out:
 EXPORT_SYMBOL(cfs_get_environ);
 
 EXPORT_SYMBOL(cfs_curproc_groups_nr);
-EXPORT_SYMBOL(cfs_curproc_groups_dump);
-EXPORT_SYMBOL(current_is_in_group);
 EXPORT_SYMBOL(cfs_cap_raise);
 EXPORT_SYMBOL(cfs_cap_lower);
 EXPORT_SYMBOL(cfs_cap_raised);
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
index 2c7d4a3..6b0054f 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
@@ -137,7 +137,7 @@ static long libcfs_ioctl(struct file *file,
 	struct cfs_psdev_file	 pfile;
 	int    rc = 0;
 
-	if (current_fsuid() != 0)
+	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
 	if ( _IOC_TYPE(cmd) != IOC_LIBCFS_TYPE ||
diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index 13a6426..e2afb97 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -685,7 +685,8 @@ int ll_dir_setdirstripe(struct inode *dir, struct lmv_user_md *lump,
 
 	op_data->op_cli_flags |= CLI_SET_MEA;
 	err = md_create(sbi->ll_md_exp, op_data, lump, sizeof(*lump), mode,
-			current_fsuid(), current_fsgid(),
+			from_kuid(&init_user_ns, current_fsuid()),
+			from_kgid(&init_user_ns, current_fsgid()),
 			cfs_curproc_cap_pack(), 0, &request);
 	ll_finish_md_op_data(op_data);
 	if (err)
@@ -1105,8 +1106,10 @@ static int quotactl_ioctl(struct ll_sb_info *sbi, struct if_quotactl *qctl)
 			RETURN(-EPERM);
 		break;
 	case Q_GETQUOTA:
-		if (((type == USRQUOTA && current_euid() != id) ||
-		     (type == GRPQUOTA && !in_egroup_p(id))) &&
+		if (((type == USRQUOTA &&
+		      uid_eq(current_euid(), make_kuid(&init_user_ns, id))) ||
+		     (type == GRPQUOTA &&
+		      !in_egroup_p(make_kgid(&init_user_ns, id)))) &&
 		    (!cfs_capable(CFS_CAP_SYS_ADMIN) ||
 		     sbi->ll_flags & LL_SBI_RMT_CLIENT))
 			RETURN(-EPERM);
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index afae801..1eb5779 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1400,7 +1400,7 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr)
 
 	/* POSIX: check before ATTR_*TIME_SET set (from inode_change_ok) */
 	if (attr->ia_valid & TIMES_SET_FLAGS) {
-		if (current_fsuid() != inode->i_uid &&
+		if ((!uid_eq(current_fsuid(), inode->i_uid)) &&
 		    !cfs_capable(CFS_CAP_FOWNER))
 			RETURN(-EPERM);
 	}
@@ -1707,9 +1707,9 @@ void ll_update_inode(struct inode *inode, struct lustre_md *md)
 		inode->i_blkbits = inode->i_sb->s_blocksize_bits;
 	}
 	if (body->valid & OBD_MD_FLUID)
-		inode->i_uid = body->uid;
+		inode->i_uid = make_kuid(&init_user_ns, body->uid);
 	if (body->valid & OBD_MD_FLGID)
-		inode->i_gid = body->gid;
+		inode->i_gid = make_kgid(&init_user_ns, body->gid);
 	if (body->valid & OBD_MD_FLFLAGS)
 		inode->i_flags = ll_ext_to_inode_flags(body->flags);
 	if (body->valid & OBD_MD_FLNLINK)
@@ -1959,7 +1959,8 @@ int ll_flush_ctx(struct inode *inode)
 {
 	struct ll_sb_info  *sbi = ll_i2sbi(inode);
 
-	CDEBUG(D_SEC, "flush context for user %d\n", current_uid());
+	CDEBUG(D_SEC, "flush context for user %d\n",
+		      from_kuid(&init_user_ns, current_uid()));
 
 	obd_set_info_async(NULL, sbi->ll_md_exp,
 			   sizeof(KEY_FLUSH_CTX), KEY_FLUSH_CTX,
@@ -2238,8 +2239,8 @@ struct md_op_data * ll_prep_md_op_data(struct md_op_data *op_data,
 	op_data->op_namelen = namelen;
 	op_data->op_mode = mode;
 	op_data->op_mod_time = cfs_time_current_sec();
-	op_data->op_fsuid = current_fsuid();
-	op_data->op_fsgid = current_fsgid();
+	op_data->op_fsuid = from_kuid(&init_user_ns, current_fsuid());
+	op_data->op_fsgid = from_kgid(&init_user_ns, current_fsgid());
 	op_data->op_cap = cfs_curproc_cap_pack();
 	op_data->op_bias = 0;
 	op_data->op_cli_flags = 0;
diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index a30c411..5c7368c 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -822,7 +822,8 @@ void ll_stats_ops_tally(struct ll_sb_info *sbi, int op, int count)
 		 sbi->ll_stats_track_id == current->parent->pid)
 		lprocfs_counter_add(sbi->ll_stats, op, count);
 	else if (sbi->ll_stats_track_type == STATS_TRACK_GID &&
-		 sbi->ll_stats_track_id == current_gid())
+		 sbi->ll_stats_track_id ==
+			from_kgid(&init_user_ns, current_gid()))
 		lprocfs_counter_add(sbi->ll_stats, op, count);
 }
 EXPORT_SYMBOL(ll_stats_ops_tally);
diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index ff8f63d..8e948a7 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -302,8 +302,8 @@ int ll_md_blocking_ast(struct ldlm_lock *lock, struct ldlm_lock_desc *desc,
 
 __u32 ll_i2suppgid(struct inode *i)
 {
-	if (current_is_in_group(i->i_gid))
-		return (__u32)i->i_gid;
+	if (in_group_p(i->i_gid))
+		return (__u32)from_kgid(&init_user_ns, i->i_gid);
 	else
 		return (__u32)(-1);
 }
@@ -805,7 +805,8 @@ static int ll_new_node(struct inode *dir, struct qstr *name,
 		GOTO(err_exit, err = PTR_ERR(op_data));
 
 	err = md_create(sbi->ll_md_exp, op_data, tgt, tgt_len, mode,
-			current_fsuid(), current_fsgid(),
+			from_kuid(&init_user_ns, current_fsuid()),
+			from_kgid(&init_user_ns, current_fsgid()),
 			cfs_curproc_cap_pack(), rdev, &request);
 	ll_finish_md_op_data(op_data);
 	if (err)
diff --git a/drivers/staging/lustre/lustre/llite/remote_perm.c b/drivers/staging/lustre/lustre/llite/remote_perm.c
index 68b2dc4..4f176e1 100644
--- a/drivers/staging/lustre/lustre/llite/remote_perm.c
+++ b/drivers/staging/lustre/lustre/llite/remote_perm.c
@@ -129,17 +129,18 @@ static int do_check_remote_perm(struct ll_inode_info *lli, int mask)
 	if (!lli->lli_remote_perms)
 		RETURN(-ENOENT);
 
-	head = lli->lli_remote_perms + remote_perm_hashfunc(current_uid());
+	head = lli->lli_remote_perms +
+		remote_perm_hashfunc(from_kuid(&init_user_ns, current_uid()));
 
 	spin_lock(&lli->lli_lock);
 	hlist_for_each_entry(lrp, head, lrp_list) {
-		if (lrp->lrp_uid != current_uid())
+		if (lrp->lrp_uid != from_kuid(&init_user_ns, current_uid()))
 			continue;
-		if (lrp->lrp_gid != current_gid())
+		if (lrp->lrp_gid != from_kgid(&init_user_ns, current_gid()))
 			continue;
-		if (lrp->lrp_fsuid != current_fsuid())
+		if (lrp->lrp_fsuid != from_kuid(&init_user_ns, current_fsuid()))
 			continue;
-		if (lrp->lrp_fsgid != current_fsgid())
+		if (lrp->lrp_fsgid != from_kgid(&init_user_ns, current_fsgid()))
 			continue;
 		found = 1;
 		break;
diff --git a/drivers/staging/lustre/lustre/llite/vvp_object.c b/drivers/staging/lustre/lustre/llite/vvp_object.c
index 01edc5b..33173fc 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_object.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_object.c
@@ -91,8 +91,8 @@ static int vvp_attr_get(const struct lu_env *env, struct cl_object *obj,
 	attr->cat_atime = LTIME_S(inode->i_atime);
 	attr->cat_ctime = LTIME_S(inode->i_ctime);
 	attr->cat_blocks = inode->i_blocks;
-	attr->cat_uid = inode->i_uid;
-	attr->cat_gid = inode->i_gid;
+	attr->cat_uid = from_kuid(&init_user_ns, inode->i_uid);
+	attr->cat_gid = from_kgid(&init_user_ns, inode->i_gid);
 	/* KMS is not known by this layer */
 	return 0; /* layers below have to fill in the rest */
 }
@@ -103,9 +103,9 @@ static int vvp_attr_set(const struct lu_env *env, struct cl_object *obj,
 	struct inode *inode = ccc_object_inode(obj);
 
 	if (valid & CAT_UID)
-		inode->i_uid = attr->cat_uid;
+		inode->i_uid = make_kuid(&init_user_ns, attr->cat_uid);
 	if (valid & CAT_GID)
-		inode->i_gid = attr->cat_gid;
+		inode->i_gid = make_kgid(&init_user_ns, attr->cat_gid);
 	if (valid & CAT_ATIME)
 		LTIME_S(inode->i_atime) = attr->cat_atime;
 	if (valid & CAT_MTIME)
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index 1eebfbf..d10f7fc 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -1757,8 +1757,8 @@ static int lmv_link(struct obd_export *exp, struct md_op_data *op_data,
 	       PFID(&op_data->op_fid2), op_data->op_namelen,
 	       op_data->op_name, PFID(&op_data->op_fid1));
 
-	op_data->op_fsuid = current_fsuid();
-	op_data->op_fsgid = current_fsgid();
+	op_data->op_fsuid = from_kuid(&init_user_ns, current_fsuid());
+	op_data->op_fsgid = from_kgid(&init_user_ns, current_fsgid());
 	op_data->op_cap = cfs_curproc_cap_pack();
 	tgt = lmv_locate_mds(lmv, op_data, &op_data->op_fid2);
 	if (IS_ERR(tgt))
@@ -1799,8 +1799,8 @@ static int lmv_rename(struct obd_export *exp, struct md_op_data *op_data,
 	if (rc)
 		RETURN(rc);
 
-	op_data->op_fsuid = current_fsuid();
-	op_data->op_fsgid = current_fsgid();
+	op_data->op_fsuid = from_kuid(&init_user_ns, current_fsuid());
+	op_data->op_fsgid = from_kgid(&init_user_ns, current_fsgid());
 	op_data->op_cap = cfs_curproc_cap_pack();
 	src_tgt = lmv_locate_mds(lmv, op_data, &op_data->op_fid1);
 	if (IS_ERR(src_tgt))
@@ -2061,8 +2061,8 @@ retry:
 	if (IS_ERR(tgt))
 		RETURN(PTR_ERR(tgt));
 
-	op_data->op_fsuid = current_fsuid();
-	op_data->op_fsgid = current_fsgid();
+	op_data->op_fsuid = from_kuid(&init_user_ns, current_fsuid());
+	op_data->op_fsgid = from_kgid(&init_user_ns, current_fsgid());
 	op_data->op_cap = cfs_curproc_cap_pack();
 
 	/*
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_lib.c b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
index e789aed..2e5c7ce 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_lib.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
@@ -45,10 +45,10 @@ static void __mdc_pack_body(struct mdt_body *b, __u32 suppgid)
 	LASSERT (b != NULL);
 
 	b->suppgid = suppgid;
-	b->uid = current_uid();
-	b->gid = current_gid();
-	b->fsuid = current_fsuid();
-	b->fsgid = current_fsgid();
+	b->uid = from_kuid(&init_user_ns, current_uid());
+	b->gid = from_kgid(&init_user_ns, current_gid());
+	b->fsuid = from_kuid(&init_user_ns, current_fsuid());
+	b->fsgid = from_kgid(&init_user_ns, current_fsgid());
 	b->capability = cfs_curproc_cap_pack();
 }
 
@@ -219,8 +219,8 @@ void mdc_open_pack(struct ptlrpc_request *req, struct md_op_data *op_data,
 
 	/* XXX do something about time, uid, gid */
 	rec->cr_opcode   = REINT_OPEN;
-	rec->cr_fsuid   = current_fsuid();
-	rec->cr_fsgid   = current_fsgid();
+	rec->cr_fsuid    = from_kuid(&init_user_ns, current_fsuid());
+	rec->cr_fsgid    = from_kgid(&init_user_ns, current_fsgid());
 	rec->cr_cap      = cfs_curproc_cap_pack();
 	if (op_data != NULL) {
 		rec->cr_fid1 = op_data->op_fid1;
@@ -299,16 +299,16 @@ static void mdc_setattr_pack_rec(struct mdt_rec_setattr *rec,
 				 struct md_op_data *op_data)
 {
 	rec->sa_opcode  = REINT_SETATTR;
-	rec->sa_fsuid   = current_fsuid();
-	rec->sa_fsgid   = current_fsgid();
+	rec->sa_fsuid   = from_kuid(&init_user_ns, current_fsuid());
+	rec->sa_fsgid   = from_kgid(&init_user_ns, current_fsgid());
 	rec->sa_cap     = cfs_curproc_cap_pack();
 	rec->sa_suppgid = -1;
 
 	rec->sa_fid    = op_data->op_fid1;
 	rec->sa_valid  = attr_pack(op_data->op_attr.ia_valid);
 	rec->sa_mode   = op_data->op_attr.ia_mode;
-	rec->sa_uid    = op_data->op_attr.ia_uid;
-	rec->sa_gid    = op_data->op_attr.ia_gid;
+	rec->sa_uid    = from_kuid(&init_user_ns, op_data->op_attr.ia_uid);
+	rec->sa_gid    = from_kgid(&init_user_ns, op_data->op_attr.ia_gid);
 	rec->sa_size   = op_data->op_attr.ia_size;
 	rec->sa_blocks = op_data->op_attr_blocks;
 	rec->sa_atime  = LTIME_S(op_data->op_attr.ia_atime);
@@ -316,8 +316,9 @@ static void mdc_setattr_pack_rec(struct mdt_rec_setattr *rec,
 	rec->sa_ctime  = LTIME_S(op_data->op_attr.ia_ctime);
 	rec->sa_attr_flags = ((struct ll_iattr *)&op_data->op_attr)->ia_attr_flags;
 	if ((op_data->op_attr.ia_valid & ATTR_GID) &&
-	    current_is_in_group(op_data->op_attr.ia_gid))
-		rec->sa_suppgid = op_data->op_attr.ia_gid;
+	    in_group_p(op_data->op_attr.ia_gid))
+		rec->sa_suppgid =
+			from_kgid(&init_user_ns, op_data->op_attr.ia_gid);
 	else
 		rec->sa_suppgid = op_data->op_suppgids[0];
 
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 3cf9d8d..21e8a9d 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -377,12 +377,8 @@ static int mdc_xattr_common(struct obd_export *exp,const struct req_format *fmt,
 			 sizeof(struct mdt_rec_reint));
 		rec = req_capsule_client_get(&req->rq_pill, &RMF_REC_REINT);
 		rec->sx_opcode = REINT_SETXATTR;
-		/* TODO:
-		 *  cfs_curproc_fs{u,g}id() should replace
-		 *  current->fs{u,g}id for portability.
-		 */
-		rec->sx_fsuid  = current_fsuid();
-		rec->sx_fsgid  = current_fsgid();
+		rec->sx_fsuid  = from_kuid(&init_user_ns, current_fsuid());
+		rec->sx_fsgid  = from_kgid(&init_user_ns, current_fsgid());
 		rec->sx_cap    = cfs_curproc_cap_pack();
 		rec->sx_suppgid1 = suppgid;
 		rec->sx_suppgid2 = -1;
diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index 0715cf2..799a1ed 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -122,7 +122,8 @@ int lustre_get_jobid(char *jobid)
 	/* Use process name + fsuid as jobid */
 	if (strcmp(obd_jobid_var, JOBSTATS_PROCNAME_UID) == 0) {
 		snprintf(jobid, JOBSTATS_JOBID_SIZE, "%s.%u",
-			 current_comm(), current_fsuid());
+			 current_comm(),
+			 from_kuid(&init_user_ns, current_fsuid()));
 		RETURN(0);
 	}
 
diff --git a/drivers/staging/lustre/lustre/obdclass/idmap.c b/drivers/staging/lustre/lustre/obdclass/idmap.c
index 622f8d1..afb66a4 100644
--- a/drivers/staging/lustre/lustre/obdclass/idmap.c
+++ b/drivers/staging/lustre/lustre/obdclass/idmap.c
@@ -71,7 +71,8 @@ static int lustre_groups_search(group_info_t *group_info,
 	right = group_info->ngroups;
 	while (left < right) {
 		int mid = (left + right) / 2;
-		int cmp = grp - CFS_GROUP_AT(group_info, mid);
+		int cmp = grp -
+			from_kgid(&init_user_ns, CFS_GROUP_AT(group_info, mid));
 
 		if (cmp > 0)
 			left = mid + 1;
@@ -116,16 +117,19 @@ void lustre_groups_sort(group_info_t *group_info)
 		for (base = 0; base < max; base++) {
 			int left = base;
 			int right = left + stride;
-			gid_t tmp = CFS_GROUP_AT(group_info, right);
+			gid_t tmp = from_kgid(&init_user_ns,
+					      CFS_GROUP_AT(group_info, right));
 
 			while (left >= 0 &&
-			       CFS_GROUP_AT(group_info, left) > tmp) {
+			       tmp < from_kgid(&init_user_ns,
+					       CFS_GROUP_AT(group_info, left))) {
 				CFS_GROUP_AT(group_info, right) =
 				    CFS_GROUP_AT(group_info, left);
 				right = left;
 				left -= stride;
 			}
-			CFS_GROUP_AT(group_info, right) = tmp;
+			CFS_GROUP_AT(group_info, right) =
+						make_kgid(&init_user_ns, tmp);
 		}
 		stride /= 3;
 	}
diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-obdo.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-obdo.c
index 6ee3471..d3bb5ff 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-obdo.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-obdo.c
@@ -213,9 +213,9 @@ void obdo_to_inode(struct inode *dst, struct obdo *src, obd_flag valid)
 	if (valid & OBD_MD_FLMODE)
 		dst->i_mode = (dst->i_mode & S_IFMT) | (src->o_mode & ~S_IFMT);
 	if (valid & OBD_MD_FLUID)
-		dst->i_uid = src->o_uid;
+		dst->i_uid = make_kuid(&init_user_ns, src->o_uid);
 	if (valid & OBD_MD_FLGID)
-		dst->i_gid = src->o_gid;
+		dst->i_gid = make_kgid(&init_user_ns, src->o_gid);
 	if (valid & OBD_MD_FLFLAGS)
 		dst->i_flags = src->o_flags;
 }
diff --git a/drivers/staging/lustre/lustre/obdclass/obdo.c b/drivers/staging/lustre/lustre/obdclass/obdo.c
index 01a0e1f..7099764 100644
--- a/drivers/staging/lustre/lustre/obdclass/obdo.c
+++ b/drivers/staging/lustre/lustre/obdclass/obdo.c
@@ -100,11 +100,11 @@ void obdo_from_inode(struct obdo *dst, struct inode *src, obd_flag valid)
 		newvalid |= OBD_MD_FLMODE;
 	}
 	if (valid & OBD_MD_FLUID) {
-		dst->o_uid = src->i_uid;
+		dst->o_uid = from_kuid(&init_user_ns, src->i_uid);
 		newvalid |= OBD_MD_FLUID;
 	}
 	if (valid & OBD_MD_FLGID) {
-		dst->o_gid = src->i_gid;
+		dst->o_gid = from_kgid(&init_user_ns, src->i_gid);
 		newvalid |= OBD_MD_FLGID;
 	}
 	if (valid & OBD_MD_FLFLAGS) {
@@ -232,16 +232,16 @@ void obdo_from_iattr(struct obdo *oa, struct iattr *attr, unsigned int ia_valid)
 	if (ia_valid & ATTR_MODE) {
 		oa->o_mode = attr->ia_mode;
 		oa->o_valid |= OBD_MD_FLTYPE | OBD_MD_FLMODE;
-		if (!current_is_in_group(oa->o_gid) &&
+		if (!in_group_p(make_kgid(&init_user_ns, oa->o_gid)) &&
 		    !cfs_capable(CFS_CAP_FSETID))
 			oa->o_mode &= ~S_ISGID;
 	}
 	if (ia_valid & ATTR_UID) {
-		oa->o_uid = attr->ia_uid;
+		oa->o_uid = from_kuid(&init_user_ns, attr->ia_uid);
 		oa->o_valid |= OBD_MD_FLUID;
 	}
 	if (ia_valid & ATTR_GID) {
-		oa->o_gid = attr->ia_gid;
+		oa->o_gid = from_kgid(&init_user_ns, attr->ia_gid);
 		oa->o_valid |= OBD_MD_FLGID;
 	}
 }
@@ -281,16 +281,16 @@ void iattr_from_obdo(struct iattr *attr, struct obdo *oa, obd_flag valid)
 	if (valid & OBD_MD_FLMODE) {
 		attr->ia_mode = (attr->ia_mode & S_IFMT)|(oa->o_mode & ~S_IFMT);
 		attr->ia_valid |= ATTR_MODE;
-		if (!current_is_in_group(oa->o_gid) &&
+		if (!in_group_p(make_kgid(&init_user_ns, oa->o_gid)) &&
 		    !cfs_capable(CFS_CAP_FSETID))
 			attr->ia_mode &= ~S_ISGID;
 	}
 	if (valid & OBD_MD_FLUID) {
-		attr->ia_uid = oa->o_uid;
+		attr->ia_uid = make_kuid(&init_user_ns, oa->o_uid);
 		attr->ia_valid |= ATTR_UID;
 	}
 	if (valid & OBD_MD_FLGID) {
-		attr->ia_gid = oa->o_gid;
+		attr->ia_gid = make_kgid(&init_user_ns, oa->o_gid);
 		attr->ia_valid |= ATTR_GID;
 	}
 }
diff --git a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
index 184195f..ae89ea6f 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -2097,10 +2097,14 @@ static void echo_ucred_init(struct lu_env *env)
 	ucred->uc_suppgids[0] = -1;
 	ucred->uc_suppgids[1] = -1;
 
-	ucred->uc_uid   = ucred->uc_o_uid   = current_uid();
-	ucred->uc_gid   = ucred->uc_o_gid   = current_gid();
-	ucred->uc_fsuid = ucred->uc_o_fsuid = current_fsuid();
-	ucred->uc_fsgid = ucred->uc_o_fsgid = current_fsgid();
+	ucred->uc_uid   = ucred->uc_o_uid   =
+				from_kuid(&init_user_ns, current_uid());
+	ucred->uc_gid   = ucred->uc_o_gid   =
+				from_kgid(&init_user_ns, current_gid());
+	ucred->uc_fsuid = ucred->uc_o_fsuid =
+				from_kuid(&init_user_ns, current_fsuid());
+	ucred->uc_fsgid = ucred->uc_o_fsgid =
+				from_kgid(&init_user_ns, current_fsgid());
 	ucred->uc_cap   = cfs_curproc_cap_pack();
 
 	/* remove fs privilege for non-root user. */
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec.c b/drivers/staging/lustre/lustre/ptlrpc/sec.c
index 36e8bed..349c57b 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec.c
@@ -269,8 +269,8 @@ struct ptlrpc_cli_ctx *get_my_ctx(struct ptlrpc_sec *sec)
 			remove_dead = 0;
 		}
 	} else {
-		vcred.vc_uid = current_uid();
-		vcred.vc_gid = current_gid();
+		vcred.vc_uid = from_kuid(&init_user_ns, current_uid());
+		vcred.vc_gid = from_kgid(&init_user_ns, current_gid());
 	}
 
 	return sec->ps_policy->sp_cops->lookup_ctx(sec, &vcred,
@@ -1523,7 +1523,8 @@ void sptlrpc_import_flush_root_ctx(struct obd_import *imp)
 
 void sptlrpc_import_flush_my_ctx(struct obd_import *imp)
 {
-	import_flush_ctx_common(imp, current_uid(), 1, 1);
+	import_flush_ctx_common(imp, from_kuid(&init_user_ns, current_uid()),
+				1, 1);
 }
 EXPORT_SYMBOL(sptlrpc_import_flush_my_ctx);
 
@@ -2055,8 +2056,8 @@ int sptlrpc_svc_unwrap_request(struct ptlrpc_request *req)
 
 	req->rq_flvr.sf_rpc = WIRE_FLVR(msg->lm_secflvr);
 	req->rq_sp_from = LUSTRE_SP_ANY;
-	req->rq_auth_uid = INVALID_UID;
-	req->rq_auth_mapped_uid = INVALID_UID;
+	req->rq_auth_uid = -1;
+	req->rq_auth_mapped_uid = -1;
 
 	policy = sptlrpc_wireflavor2policy(req->rq_flvr.sf_rpc);
 	if (!policy) {
@@ -2314,10 +2315,10 @@ int sptlrpc_pack_user_desc(struct lustre_msg *msg, int offset)
 
 	pud = lustre_msg_buf(msg, offset, 0);
 
-	pud->pud_uid = current_uid();
-	pud->pud_gid = current_gid();
-	pud->pud_fsuid = current_fsuid();
-	pud->pud_fsgid = current_fsgid();
+	pud->pud_uid = from_kuid(&init_user_ns, current_uid());
+	pud->pud_gid = from_kgid(&init_user_ns, current_gid());
+	pud->pud_fsuid = from_kuid(&init_user_ns, current_fsuid());
+	pud->pud_fsgid = from_kgid(&init_user_ns, current_fsgid());
 	pud->pud_cap = cfs_curproc_cap_pack();
 	pud->pud_ngroups = (msg->lm_buflens[offset] - sizeof(*pud)) / 4;
 
-- 
1.7.9.5

