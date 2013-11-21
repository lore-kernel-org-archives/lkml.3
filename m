Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab3KUO12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:27:28 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:55122 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab3KUO1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:27:22 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v2 1/3] staging/lustre/llite: Access to released file triggers a restore
Date: Thu, 21 Nov 2013 22:24:48 +0800
Message-Id: <1385043890-3053-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385043890-3053-1-git-send-email-bergwolf@gmail.com>
References: <1385043890-3053-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>

When a client accesses data in a released file,
or truncate it, client must trig a restore request.
During this restore, the client must not glimpse and
must use size from MDT. To bring the "restore is running"
information on the client we add a new t_state bit field
to mdt_info which will be used to carry transient file state.
To memorise this information in the inode we add a new flag
LLIF_FILE_RESTORING.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3432
Lustre-change: http://review.whamcloud.com/6537
Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Tested-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/include/cl_object.h  |    6 ++-
 .../lustre/lustre/include/lustre/lustre_idl.h      |   14 +++--
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |    6 +++
 drivers/staging/lustre/lustre/llite/file.c         |   39 +++++++++++++-
 .../staging/lustre/lustre/llite/llite_internal.h   |    3 ++
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   36 +++++++++++++
 drivers/staging/lustre/lustre/llite/vvp_io.c       |   54 ++++++++++++++++++--
 drivers/staging/lustre/lustre/lov/lov_io.c         |   15 ++++--
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |   18 ++++---
 10 files changed, 169 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/cl_object.h b/drivers/staging/lustre/lustre/include/cl_object.h
index c485206..4d692dc 100644
--- a/drivers/staging/lustre/lustre/include/cl_object.h
+++ b/drivers/staging/lustre/lustre/include/cl_object.h
@@ -2388,7 +2388,11 @@ struct cl_io {
 	 * Right now, only two opertaions need to verify layout: glimpse
 	 * and setattr.
 	 */
-			     ci_verify_layout:1;
+			     ci_verify_layout:1,
+	/**
+	 * file is released, restore has to to be triggered by vvp layer
+	 */
+			     ci_restore_needed:1;
 	/**
 	 * Number of pages owned by this IO. For invariant checking.
 	 */
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index e592a0e..4d8d8c3 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -1725,10 +1725,7 @@ static inline __u32 lov_mds_md_size(__u16 stripes, __u32 lmm_magic)
 #define OBD_MD_MDS	 (0x0000000100000000ULL) /* where an inode lives on */
 #define OBD_MD_REINT       (0x0000000200000000ULL) /* reintegrate oa */
 #define OBD_MD_MEA	 (0x0000000400000000ULL) /* CMD split EA  */
-
-/* OBD_MD_MDTIDX is used to get MDT index, but it is never been used overwire,
- * and it is already obsolete since 2.3 */
-/* #define OBD_MD_MDTIDX      (0x0000000800000000ULL) */
+#define OBD_MD_TSTATE      (0x0000000800000000ULL) /* transient state field */
 
 #define OBD_MD_FLXATTR       (0x0000001000000000ULL) /* xattr */
 #define OBD_MD_FLXATTRLS     (0x0000002000000000ULL) /* xattr list */
@@ -2208,6 +2205,11 @@ static inline int ll_inode_to_ext_flags(int iflags)
 		((iflags & S_IMMUTABLE) ? LUSTRE_IMMUTABLE_FL : 0));
 }
 
+/* 64 possible states */
+enum md_transient_state {
+	MS_RESTORE	= (1 << 0),	/* restore is running */
+};
+
 struct mdt_body {
 	struct lu_fid  fid1;
 	struct lu_fid  fid2;
@@ -2219,7 +2221,9 @@ struct mdt_body {
        obd_time	ctime;
 	__u64	  blocks; /* XID, in the case of MDS_READPAGE */
 	__u64	  ioepoch;
-	__u64	       unused1; /* was "ino" until 2.4.0 */
+	__u64	       t_state; /* transient file state defined in
+				 * enum md_transient_state
+				 * was "ino" until 2.4.0 */
 	__u32	  fsuid;
 	__u32	  fsgid;
 	__u32	  capability;
diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
index e60c04d..1c628e3 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -1006,6 +1006,12 @@ again:
 	cl_io_fini(env, io);
 	if (unlikely(io->ci_need_restart))
 		goto again;
+	/* HSM import case: file is released, cannot be restored
+	 * no need to fail except if restore registration failed
+	 * with -ENODATA */
+	if (result == -ENODATA && io->ci_restore_needed &&
+	    io->ci_result != -ENODATA)
+		result = 0;
 	cl_env_put(env, &refcheck);
 	return result;
 }
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 971409e..82248e9 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1107,7 +1107,7 @@ out:
 	cl_io_fini(env, io);
 	/* If any bit been read/written (result != 0), we just return
 	 * short read/write instead of restart io. */
-	if (result == 0 && io->ci_need_restart) {
+	if ((result == 0 || result == -ENODATA) && io->ci_need_restart) {
 		CDEBUG(D_VFSTRACE, "Restart %s on %s from %lld, count:%zd\n",
 		       iot == CIT_READ ? "read" : "write",
 		       file->f_dentry->d_name.name, *ppos, count);
@@ -2867,7 +2867,15 @@ int ll_inode_revalidate_it(struct dentry *dentry, struct lookup_intent *it,
 		LTIME_S(inode->i_mtime) = ll_i2info(inode)->lli_lvb.lvb_mtime;
 		LTIME_S(inode->i_ctime) = ll_i2info(inode)->lli_lvb.lvb_ctime;
 	} else {
-		rc = ll_glimpse_size(inode);
+		/* In case of restore, the MDT has the right size and has
+		 * already send it back without granting the layout lock,
+		 * inode is up-to-date so glimpse is useless.
+		 * Also to glimpse we need the layout, in case of a running
+		 * restore the MDT holds the layout lock so the glimpse will
+		 * block up to the end of restore (getattr will block)
+		 */
+		if (!(ll_i2info(inode)->lli_flags & LLIF_FILE_RESTORING))
+			rc = ll_glimpse_size(inode);
 	}
 	return rc;
 }
@@ -3464,3 +3472,30 @@ again:
 
 	return rc;
 }
+
+/**
+ *  This function send a restore request to the MDT
+ */
+int ll_layout_restore(struct inode *inode)
+{
+	struct hsm_user_request	*hur;
+	int			 len, rc;
+
+	len = sizeof(struct hsm_user_request) +
+	      sizeof(struct hsm_user_item);
+	OBD_ALLOC(hur, len);
+	if (hur == NULL)
+		return -ENOMEM;
+
+	hur->hur_request.hr_action = HUA_RESTORE;
+	hur->hur_request.hr_archive_id = 0;
+	hur->hur_request.hr_flags = 0;
+	memcpy(&hur->hur_user_item[0].hui_fid, &ll_i2info(inode)->lli_fid,
+	       sizeof(hur->hur_user_item[0].hui_fid));
+	hur->hur_user_item[0].hui_extent.length = -1;
+	hur->hur_request.hr_itemcount = 1;
+	rc = obd_iocontrol(LL_IOC_HSM_REQUEST, cl_i2sbi(inode)->ll_md_exp,
+			   len, hur, NULL);
+	OBD_FREE(hur, len);
+	return rc;
+}
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 1a13330..c326ff2 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -125,6 +125,8 @@ enum lli_flags {
 	LLIF_SRVLOCK	    = (1 << 5),
 	/* File data is modified. */
 	LLIF_DATA_MODIFIED      = (1 << 6),
+	/* File is being restored */
+	LLIF_FILE_RESTORING	= (1 << 7),
 };
 
 struct ll_inode_info {
@@ -1588,5 +1590,6 @@ enum {
 
 int ll_layout_conf(struct inode *inode, const struct cl_object_conf *conf);
 int ll_layout_refresh(struct inode *inode, __u32 *gen);
+int ll_layout_restore(struct inode *inode);
 
 #endif /* LLITE_INTERNAL_H */
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index fd584ff..facc391 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1353,6 +1353,7 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr)
 	struct ll_inode_info *lli = ll_i2info(inode);
 	struct md_op_data *op_data = NULL;
 	struct md_open_data *mod = NULL;
+	bool file_is_released = false;
 	int rc = 0, rc1 = 0;
 
 	CDEBUG(D_VFSTRACE, "%s: setattr inode %p/fid:"DFID" from %llu to %llu, "
@@ -1436,10 +1437,40 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr)
 	    (attr->ia_valid & (ATTR_SIZE | ATTR_MTIME | ATTR_MTIME_SET)))
 		op_data->op_flags = MF_EPOCH_OPEN;
 
+	/* truncate on a released file must failed with -ENODATA,
+	 * so size must not be set on MDS for released file
+	 * but other attributes must be set
+	 */
+	if (S_ISREG(inode->i_mode)) {
+		struct lov_stripe_md *lsm;
+		__u32 gen;
+
+		ll_layout_refresh(inode, &gen);
+		lsm = ccc_inode_lsm_get(inode);
+		if (lsm && lsm->lsm_pattern & LOV_PATTERN_F_RELEASED)
+			file_is_released = true;
+		ccc_inode_lsm_put(inode, lsm);
+	}
+
+	/* clear size attr for released file
+	 * we clear the attribute send to MDT in op_data, not the original
+	 * received from caller in attr which is used later to
+	 * decide return code */
+	if (file_is_released && (attr->ia_valid & ATTR_SIZE))
+		op_data->op_attr.ia_valid &= ~ATTR_SIZE;
+
 	rc = ll_md_setattr(dentry, op_data, &mod);
 	if (rc)
 		GOTO(out, rc);
 
+	/* truncate failed, others succeed */
+	if (file_is_released) {
+		if (attr->ia_valid & ATTR_SIZE)
+			GOTO(out, rc = -ENODATA);
+		else
+			GOTO(out, rc = 0);
+	}
+
 	/* RPC to MDT is sent, cancel data modification flag */
 	if (rc == 0 && (op_data->op_bias & MDS_DATA_MODIFIED)) {
 		spin_lock(&lli->lli_lock);
@@ -1761,6 +1792,11 @@ void ll_update_inode(struct inode *inode, struct lustre_md *md)
 		LASSERT(md->oss_capa);
 		ll_add_capa(inode, md->oss_capa);
 	}
+
+	if (body->valid & OBD_MD_TSTATE) {
+		if (body->t_state & MS_RESTORE)
+			lli->lli_flags |= LLIF_FILE_RESTORING;
+	}
 }
 
 void ll_read_inode2(struct inode *inode, void *opaque)
diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index 3ff664c..f69e3aa 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -121,8 +121,38 @@ static void vvp_io_fini(const struct lu_env *env, const struct cl_io_slice *ios)
 
 	CLOBINVRNT(env, obj, ccc_object_invariant(obj));
 
-	CDEBUG(D_VFSTRACE, "ignore/verify layout %d/%d, layout version %d.\n",
-		io->ci_ignore_layout, io->ci_verify_layout, cio->cui_layout_gen);
+	CDEBUG(D_VFSTRACE, DFID
+	       " ignore/verify layout %d/%d, layout version %d restore needed %d\n",
+	       PFID(lu_object_fid(&obj->co_lu)),
+	       io->ci_ignore_layout, io->ci_verify_layout,
+	       cio->cui_layout_gen, io->ci_restore_needed);
+
+	if (io->ci_restore_needed == 1) {
+		int	rc;
+
+		/* file was detected release, we need to restore it
+		 * before finishing the io
+		 */
+		rc = ll_layout_restore(ccc_object_inode(obj));
+		/* if restore registration failed, no restart,
+		 * we will return -ENODATA */
+		/* The layout will change after restore, so we need to
+		 * block on layout lock hold by the MDT
+		 * as MDT will not send new layout in lvb (see LU-3124)
+		 * we have to explicitly fetch it, all this will be done
+		 * by ll_layout_refresh()
+		 */
+		if (rc == 0) {
+			io->ci_restore_needed = 0;
+			io->ci_need_restart = 1;
+			io->ci_verify_layout = 1;
+		} else {
+			io->ci_restore_needed = 1;
+			io->ci_need_restart = 0;
+			io->ci_verify_layout = 0;
+			io->ci_result = rc;
+		}
+	}
 
 	if (!io->ci_ignore_layout && io->ci_verify_layout) {
 		__u32 gen = 0;
@@ -130,9 +160,17 @@ static void vvp_io_fini(const struct lu_env *env, const struct cl_io_slice *ios)
 		/* check layout version */
 		ll_layout_refresh(ccc_object_inode(obj), &gen);
 		io->ci_need_restart = cio->cui_layout_gen != gen;
-		if (io->ci_need_restart)
-			CDEBUG(D_VFSTRACE, "layout changed from %d to %d.\n",
-				cio->cui_layout_gen, gen);
+		if (io->ci_need_restart) {
+			CDEBUG(D_VFSTRACE,
+			       DFID" layout changed from %d to %d.\n",
+			       PFID(lu_object_fid(&obj->co_lu)),
+			       cio->cui_layout_gen, gen);
+			/* today successful restore is the only possible
+			 * case */
+			/* restore was done, clear restoring state */
+			ll_i2info(ccc_object_inode(obj))->lli_flags &=
+				~LLIF_FILE_RESTORING;
+		}
 	}
 }
 
@@ -1111,6 +1149,12 @@ int vvp_io_init(const struct lu_env *env, struct cl_object *obj,
 
 	CLOBINVRNT(env, obj, ccc_object_invariant(obj));
 
+	CDEBUG(D_VFSTRACE, DFID
+	       " ignore/verify layout %d/%d, layout version %d restore needed %d\n",
+	       PFID(lu_object_fid(&obj->co_lu)),
+	       io->ci_ignore_layout, io->ci_verify_layout,
+	       cio->cui_layout_gen, io->ci_restore_needed);
+
 	CL_IO_SLICE_CLEAN(cio, cui_cl);
 	cl_io_slice_add(io, &cio->cui_cl, obj, &vvp_io_ops);
 	vio->cui_ra_window_set = 0;
diff --git a/drivers/staging/lustre/lustre/lov/lov_io.c b/drivers/staging/lustre/lustre/lov/lov_io.c
index 2792fa5..5a6ab70 100644
--- a/drivers/staging/lustre/lustre/lov/lov_io.c
+++ b/drivers/staging/lustre/lustre/lov/lov_io.c
@@ -947,14 +947,23 @@ int lov_io_init_released(const struct lu_env *env, struct cl_object *obj,
 		LASSERTF(0, "invalid type %d\n", io->ci_type);
 	case CIT_MISC:
 	case CIT_FSYNC:
-		result = +1;
+		result = 1;
 		break;
 	case CIT_SETATTR:
+		/* the truncate to 0 is managed by MDT:
+		 * - in open, for open O_TRUNC
+		 * - in setattr, for truncate
+		 */
+		/* the truncate is for size > 0 so triggers a restore */
+		if (cl_io_is_trunc(io))
+			io->ci_restore_needed = 1;
+		result = -ENODATA;
+		break;
 	case CIT_READ:
 	case CIT_WRITE:
 	case CIT_FAULT:
-		/* TODO: need to restore the file. */
-		result = -EBADF;
+		io->ci_restore_needed = 1;
+		result = -ENODATA;
 		break;
 	}
 	if (result == 0) {
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
index 4659314..d831bd7 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
@@ -1873,7 +1873,7 @@ void lustre_swab_mdt_body(struct mdt_body *b)
 	__swab64s(&b->ctime);
 	__swab64s(&b->blocks);
 	__swab64s(&b->ioepoch);
-	CLASSERT(offsetof(typeof(*b), unused1) != 0);
+	__swab64s(&b->t_state);
 	__swab32s(&b->fsuid);
 	__swab32s(&b->fsgid);
 	__swab32s(&b->capability);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/wiretest.c b/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
index 9890bd9..e3f02c7 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
@@ -49,9 +49,10 @@ void lustre_assert_wire_constants(void)
 {
 	 /* Wire protocol assertions generated by 'wirecheck'
 	  * (make -C lustre/utils newwiretest)
-	  * running on Linux deva 2.6.32.279.lustre #5 SMP Tue Apr 9 22:52:17 CST 2013 x86_64 x86_64 x
-	  * with gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC)  */
-
+	  * running on Linux centos6-bis 2.6.32-358.0.1.el6-head
+	  * #3 SMP Wed Apr 17 17:37:43 CEST 2013
+	  * with gcc version 4.4.6 20110731 (Red Hat 4.4.6-3) (GCC)
+	  */
 
 	/* Constants... */
 	LASSERTF(PTL_RPC_MSG_REQUEST == 4711, "found %lld\n",
@@ -1335,6 +1336,8 @@ void lustre_assert_wire_constants(void)
 		 OBD_MD_REINT);
 	LASSERTF(OBD_MD_MEA == (0x0000000400000000ULL), "found 0x%.16llxULL\n",
 		 OBD_MD_MEA);
+	LASSERTF(OBD_MD_TSTATE == (0x0000000800000000ULL),
+		 "found 0x%.16llxULL\n", OBD_MD_TSTATE);
 	LASSERTF(OBD_MD_FLXATTR == (0x0000001000000000ULL), "found 0x%.16llxULL\n",
 		 OBD_MD_FLXATTR);
 	LASSERTF(OBD_MD_FLXATTRLS == (0x0000002000000000ULL), "found 0x%.16llxULL\n",
@@ -1918,10 +1921,11 @@ void lustre_assert_wire_constants(void)
 		 (long long)(int)offsetof(struct mdt_body, blocks));
 	LASSERTF((int)sizeof(((struct mdt_body *)0)->blocks) == 8, "found %lld\n",
 		 (long long)(int)sizeof(((struct mdt_body *)0)->blocks));
-	LASSERTF((int)offsetof(struct mdt_body, unused1) == 96, "found %lld\n",
-		 (long long)(int)offsetof(struct mdt_body, unused1));
-	LASSERTF((int)sizeof(((struct mdt_body *)0)->unused1) == 8, "found %lld\n",
-		 (long long)(int)sizeof(((struct mdt_body *)0)->unused1));
+	LASSERTF((int)offsetof(struct mdt_body, t_state) == 96, "found %lld\n",
+		 (long long)(int)offsetof(struct mdt_body, t_state));
+	LASSERTF((int)sizeof(((struct mdt_body *)0)->t_state) == 8,
+		 "found %lld\n",
+		 (long long)(int)sizeof(((struct mdt_body *)0)->t_state));
 	LASSERTF((int)offsetof(struct mdt_body, fsuid) == 104, "found %lld\n",
 		 (long long)(int)offsetof(struct mdt_body, fsuid));
 	LASSERTF((int)sizeof(((struct mdt_body *)0)->fsuid) == 4, "found %lld\n",
-- 
1.7.9.5

