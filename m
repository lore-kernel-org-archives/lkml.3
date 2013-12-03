Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3LCOFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:05:04 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:40890 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3LCOEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:04:55 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Andrew Perepechko <andrew_perepechko@xyratex.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v3 11/15] staging/lustre/llite: extended attribute cache
Date: Tue,  3 Dec 2013 21:58:49 +0800
Message-Id: <1386079133-6459-12-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
References: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Perepechko <andrew_perepechko@xyratex.com>

This patch implements an extended attribute cache for
a Lustre client. It is organized as a write-through
cache: reads are performed from cache, updates are sent
synchronously to the MDS. An additional inode bit
MDS_INODELOCK_XATTR is added to protect the cache.

Lustre-change: http://review.whamcloud.com/5537
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2869
Signed-off-by: Andrew Perepechko <andrew_perepechko@xyratex.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
[remove extra GPL notice in original patch as kernel already has one
and it causes checkpatch error. -- Peng Tao]
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/linux/lustre_lite.h      |    1 +
 .../lustre/lustre/include/lustre/lustre_idl.h      |   12 +-
 .../lustre/lustre/include/lustre_req_layout.h      |    3 +
 drivers/staging/lustre/lustre/include/md_object.h  |    4 +-
 drivers/staging/lustre/lustre/include/obd.h        |    5 +
 .../staging/lustre/lustre/include/obd_support.h    |    1 +
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |    2 +
 drivers/staging/lustre/lustre/llite/Makefile       |    2 +-
 drivers/staging/lustre/lustre/llite/file.c         |   13 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |   36 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   23 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |   37 ++
 drivers/staging/lustre/lustre/llite/namei.c        |    4 +
 drivers/staging/lustre/lustre/llite/super25.c      |    4 +
 drivers/staging/lustre/lustre/llite/xattr.c        |  102 ++--
 drivers/staging/lustre/lustre/llite/xattr_cache.c  |  617 ++++++++++++++++++++
 drivers/staging/lustre/lustre/mdc/mdc_internal.h   |    1 +
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |   63 +-
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |   34 ++
 19 files changed, 902 insertions(+), 62 deletions(-)
 create mode 100644 drivers/staging/lustre/lustre/llite/xattr_cache.c

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_lite.h b/drivers/staging/lustre/lustre/include/linux/lustre_lite.h
index 9e5df8d..df93912 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_lite.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_lite.h
@@ -88,6 +88,7 @@ enum {
 	 LPROC_LL_ALLOC_INODE,
 	 LPROC_LL_SETXATTR,
 	 LPROC_LL_GETXATTR,
+	 LPROC_LL_GETXATTR_HITS,
 	 LPROC_LL_LISTXATTR,
 	 LPROC_LL_REMOVEXATTR,
 	 LPROC_LL_INODE_PERM,
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 77edf7d..5da31c5 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -1368,7 +1368,7 @@ extern void lustre_swab_ptlrpc_body(struct ptlrpc_body *pb);
 				OBD_CONNECT_EINPROGRESS | \
 				OBD_CONNECT_LIGHTWEIGHT | OBD_CONNECT_UMASK | \
 				OBD_CONNECT_LVB_TYPE | OBD_CONNECT_LAYOUTLOCK |\
-				OBD_CONNECT_PINGLESS)
+				OBD_CONNECT_PINGLESS | OBD_CONNECT_MAX_EASIZE)
 #define OST_CONNECT_SUPPORTED  (OBD_CONNECT_SRVLOCK | OBD_CONNECT_GRANT | \
 				OBD_CONNECT_REQPORTAL | OBD_CONNECT_VERSION | \
 				OBD_CONNECT_TRUNCLOCK | OBD_CONNECT_INDEX | \
@@ -1752,7 +1752,9 @@ static inline __u32 lov_mds_md_size(__u16 stripes, __u32 lmm_magic)
 #define OBD_MD_FLCKSPLIT     (0x0000080000000000ULL) /* Check split on server */
 #define OBD_MD_FLCROSSREF    (0x0000100000000000ULL) /* Cross-ref case */
 #define OBD_MD_FLGETATTRLOCK (0x0000200000000000ULL) /* Get IOEpoch attributes
-						      * under lock */
+						      * under lock; for xattr
+						      * requests means the
+						      * client holds the lock */
 #define OBD_MD_FLOBJCOUNT    (0x0000400000000000ULL) /* for multiple destroy */
 
 #define OBD_MD_FLRMTLSETFACL (0x0001000000000000ULL) /* lfs lsetfacl case */
@@ -1769,6 +1771,9 @@ static inline __u32 lov_mds_md_size(__u16 stripes, __u32 lmm_magic)
 			  OBD_MD_FLGID   | OBD_MD_FLFLAGS | OBD_MD_FLNLINK | \
 			  OBD_MD_FLGENER | OBD_MD_FLRDEV  | OBD_MD_FLGROUP)
 
+#define OBD_MD_FLXATTRLOCKED OBD_MD_FLGETATTRLOCK
+#define OBD_MD_FLXATTRALL (OBD_MD_FLXATTR | OBD_MD_FLXATTRLS)
+
 /* don't forget obdo_fid which is way down at the bottom so it can
  * come after the definition of llog_cookie */
 
@@ -2141,8 +2146,9 @@ extern void lustre_swab_generic_32s (__u32 *val);
 #define MDS_INODELOCK_OPEN   0x000004       /* For opened files */
 #define MDS_INODELOCK_LAYOUT 0x000008       /* for layout */
 #define MDS_INODELOCK_PERM   0x000010       /* for permission */
+#define MDS_INODELOCK_XATTR  0x000020       /* extended attributes */
 
-#define MDS_INODELOCK_MAXSHIFT 4
+#define MDS_INODELOCK_MAXSHIFT 5
 /* This FULL lock is useful to take on unlink sort of operations */
 #define MDS_INODELOCK_FULL ((1<<(MDS_INODELOCK_MAXSHIFT+1))-1)
 
diff --git a/drivers/staging/lustre/lustre/include/lustre_req_layout.h b/drivers/staging/lustre/lustre/include/lustre_req_layout.h
index a75f4c6..a83db61 100644
--- a/drivers/staging/lustre/lustre/include/lustre_req_layout.h
+++ b/drivers/staging/lustre/lustre/include/lustre_req_layout.h
@@ -230,6 +230,7 @@ extern struct req_format RQF_LDLM_INTENT_GETATTR;
 extern struct req_format RQF_LDLM_INTENT_OPEN;
 extern struct req_format RQF_LDLM_INTENT_CREATE;
 extern struct req_format RQF_LDLM_INTENT_UNLINK;
+extern struct req_format RQF_LDLM_INTENT_GETXATTR;
 extern struct req_format RQF_LDLM_INTENT_QUOTA;
 extern struct req_format RQF_LDLM_CANCEL;
 extern struct req_format RQF_LDLM_CALLBACK;
@@ -279,6 +280,8 @@ extern struct req_msg_field RMF_LAYOUT_INTENT;
 extern struct req_msg_field RMF_MDT_MD;
 extern struct req_msg_field RMF_REC_REINT;
 extern struct req_msg_field RMF_EADATA;
+extern struct req_msg_field RMF_EAVALS;
+extern struct req_msg_field RMF_EAVALS_LENS;
 extern struct req_msg_field RMF_ACL;
 extern struct req_msg_field RMF_LOGCOOKIES;
 extern struct req_msg_field RMF_CAPA1;
diff --git a/drivers/staging/lustre/lustre/include/md_object.h b/drivers/staging/lustre/lustre/include/md_object.h
index daf93af..7b45b47 100644
--- a/drivers/staging/lustre/lustre/include/md_object.h
+++ b/drivers/staging/lustre/lustre/include/md_object.h
@@ -352,8 +352,8 @@ struct md_device_operations {
 	int (*mdo_root_get)(const struct lu_env *env, struct md_device *m,
 			    struct lu_fid *f);
 
-	int (*mdo_maxsize_get)(const struct lu_env *env, struct md_device *m,
-			       int *md_size, int *cookie_size);
+	int (*mdo_maxeasize_get)(const struct lu_env *env, struct md_device *m,
+				int *easize);
 
 	int (*mdo_statfs)(const struct lu_env *env, struct md_device *m,
 			  struct obd_statfs *sfs);
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index 3247d1d..c3470ce 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -1022,6 +1022,7 @@ struct lu_context;
 #define IT_LAYOUT   (1 << 10)
 #define IT_QUOTA_DQACQ (1 << 11)
 #define IT_QUOTA_CONN  (1 << 12)
+#define IT_SETXATTR (1 << 13)
 
 static inline int it_to_lock_mode(struct lookup_intent *it)
 {
@@ -1031,6 +1032,10 @@ static inline int it_to_lock_mode(struct lookup_intent *it)
 	else if (it->it_op & (IT_READDIR | IT_GETATTR | IT_OPEN | IT_LOOKUP |
 			      IT_LAYOUT))
 		return LCK_CR;
+	else if (it->it_op &  IT_GETXATTR)
+		return LCK_PR;
+	else if (it->it_op &  IT_SETXATTR)
+		return LCK_PW;
 
 	LASSERTF(0, "Invalid it_op: %d\n", it->it_op);
 	return -EINVAL;
diff --git a/drivers/staging/lustre/lustre/include/obd_support.h b/drivers/staging/lustre/lustre/include/obd_support.h
index 1748985..2dc95de 100644
--- a/drivers/staging/lustre/lustre/include/obd_support.h
+++ b/drivers/staging/lustre/lustre/include/obd_support.h
@@ -465,6 +465,7 @@ int obd_alloc_fail(const void *ptr, const char *name, const char *type,
 #define OBD_FAIL_LOCK_STATE_WAIT_INTR	       0x1402
 #define OBD_FAIL_LOV_INIT			    0x1403
 #define OBD_FAIL_GLIMPSE_DELAY			    0x1404
+#define OBD_FAIL_LLITE_XATTR_ENOMEM		    0x1405
 
 #define OBD_FAIL_FID_INDIR	0x1501
 #define OBD_FAIL_FID_INLMA	0x1502
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index ef826e9..95eff79 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -145,6 +145,8 @@ char *ldlm_it2str(int it)
 		return "getxattr";
 	case IT_LAYOUT:
 		return "layout";
+	case IT_SETXATTR:
+		return "setxattr";
 	default:
 		CERROR("Unknown intent %d\n", it);
 		return "UNKNOWN";
diff --git a/drivers/staging/lustre/lustre/llite/Makefile b/drivers/staging/lustre/lustre/llite/Makefile
index f493e07..bb34b8b 100644
--- a/drivers/staging/lustre/lustre/llite/Makefile
+++ b/drivers/staging/lustre/lustre/llite/Makefile
@@ -2,7 +2,7 @@ obj-$(CONFIG_LUSTRE_FS) += lustre.o
 obj-$(CONFIG_LUSTRE_LLITE_LLOOP) += llite_lloop.o
 lustre-y := dcache.o dir.o file.o llite_close.o llite_lib.o llite_nfs.o \
 	    rw.o lproc_llite.o namei.o symlink.o llite_mmap.o \
-	    xattr.o remote_perm.o llite_rmtacl.o llite_capa.o \
+	    xattr.o xattr_cache.o remote_perm.o llite_rmtacl.o llite_capa.o \
 	    rw26.o super25.o statahead.o \
 	    ../lclient/glimpse.o ../lclient/lcommon_cl.o ../lclient/lcommon_misc.o \
 	    vvp_dev.o vvp_page.o vvp_lock.o vvp_io.o vvp_object.o
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 95d7364..c126135 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -2784,7 +2784,8 @@ int ll_have_md_lock(struct inode *inode, __u64 *bits,  ldlm_mode_t l_req_mode)
 }
 
 ldlm_mode_t ll_take_md_lock(struct inode *inode, __u64 bits,
-			    struct lustre_handle *lockh, __u64 flags)
+			    struct lustre_handle *lockh, __u64 flags,
+			    ldlm_mode_t mode)
 {
 	ldlm_policy_data_t policy = { .l_inodebits = {bits}};
 	struct lu_fid *fid;
@@ -2794,8 +2795,8 @@ ldlm_mode_t ll_take_md_lock(struct inode *inode, __u64 bits,
 	CDEBUG(D_INFO, "trying to match res "DFID"\n", PFID(fid));
 
 	rc = md_lock_match(ll_i2mdexp(inode), LDLM_FL_BLOCK_GRANTED|flags,
-			   fid, LDLM_IBITS, &policy,
-			   LCK_CR|LCK_CW|LCK_PR|LCK_PW, lockh);
+			   fid, LDLM_IBITS, &policy, mode, lockh);
+
 	return rc;
 }
 
@@ -3471,7 +3472,8 @@ int ll_layout_refresh(struct inode *inode, __u32 *gen)
 
 	/* mostly layout lock is caching on the local side, so try to match
 	 * it before grabbing layout lock mutex. */
-	mode = ll_take_md_lock(inode, MDS_INODELOCK_LAYOUT, &lockh, 0);
+	mode = ll_take_md_lock(inode, MDS_INODELOCK_LAYOUT, &lockh, 0,
+			       LCK_CR | LCK_CW | LCK_PR | LCK_PW);
 	if (mode != 0) { /* hit cached lock */
 		rc = ll_layout_lock_set(&lockh, mode, inode, gen, false);
 		if (rc == 0)
@@ -3486,7 +3488,8 @@ int ll_layout_refresh(struct inode *inode, __u32 *gen)
 
 again:
 	/* try again. Maybe somebody else has done this. */
-	mode = ll_take_md_lock(inode, MDS_INODELOCK_LAYOUT, &lockh, 0);
+	mode = ll_take_md_lock(inode, MDS_INODELOCK_LAYOUT, &lockh, 0,
+			       LCK_CR | LCK_CW | LCK_PR | LCK_PW);
 	if (mode != 0) { /* hit cached lock */
 		rc = ll_layout_lock_set(&lockh, mode, inode, gen, true);
 		if (rc == -EAGAIN)
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index e479a69..1355de4 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -127,6 +127,8 @@ enum lli_flags {
 	LLIF_DATA_MODIFIED      = (1 << 6),
 	/* File is being restored */
 	LLIF_FILE_RESTORING	= (1 << 7),
+	/* Xattr cache is attached to the file */
+	LLIF_XATTR_CACHE	= (1 << 8),
 };
 
 struct ll_inode_info {
@@ -279,8 +281,27 @@ struct ll_inode_info {
 	struct mutex			lli_layout_mutex;
 	/* valid only inside LAYOUT ibits lock, protected by lli_layout_mutex */
 	__u32				lli_layout_gen;
+
+	struct rw_semaphore		lli_xattrs_list_rwsem;
+	struct mutex			lli_xattrs_enq_lock;
+	struct list_head		lli_xattrs;/* ll_xattr_entry->xe_list */
 };
 
+int ll_xattr_cache_destroy(struct inode *inode);
+
+int ll_xattr_cache_get(struct inode *inode,
+			const char *name,
+			char *buffer,
+			size_t size,
+			__u64 valid);
+
+int ll_xattr_cache_update(struct inode *inode,
+			const char *name,
+			const char *newval,
+			size_t size,
+			__u64 valid,
+			int flags);
+
 /*
  * Locking to guarantee consistency of non-atomic updates to long long i_size,
  * consistency between file size and KMS.
@@ -402,6 +423,7 @@ enum stats_track_type {
 #define LL_SBI_VERBOSE	0x10000 /* verbose mount/umount */
 #define LL_SBI_LAYOUT_LOCK    0x20000 /* layout lock support */
 #define LL_SBI_USER_FID2PATH  0x40000 /* allow fid2path by unprivileged users */
+#define LL_SBI_XATTR_CACHE    0x80000 /* support for xattr cache */
 
 #define LL_SBI_FLAGS {	\
 	"nolck",	\
@@ -409,6 +431,7 @@ enum stats_track_type {
 	"flock",	\
 	"xattr",	\
 	"acl",		\
+	"???",		\
 	"rmt_client",	\
 	"mds_capa",	\
 	"oss_capa",	\
@@ -421,7 +444,9 @@ enum stats_track_type {
 	"agl",		\
 	"verbose",	\
 	"layout",	\
-	"user_fid2path" }
+	"user_fid2path",\
+	"xattr",	\
+}
 
 /* default value for ll_sb_info->contention_time */
 #define SBI_DEFAULT_CONTENTION_SECONDS     60
@@ -461,7 +486,8 @@ struct ll_sb_info {
 	struct lu_fid	     ll_root_fid; /* root object fid */
 
 	int		       ll_flags;
-	unsigned int			  ll_umounting:1;
+	unsigned int		  ll_umounting:1,
+				  ll_xattr_cache_enabled:1;
 	struct list_head		ll_conn_chain; /* per-conn chain of SBs */
 	struct lustre_client_ocd  ll_lco;
 
@@ -732,7 +758,8 @@ extern int ll_inode_revalidate_it(struct dentry *, struct lookup_intent *,
 extern int ll_have_md_lock(struct inode *inode, __u64 *bits,
 			   ldlm_mode_t l_req_mode);
 extern ldlm_mode_t ll_take_md_lock(struct inode *inode, __u64 bits,
-				   struct lustre_handle *lockh, __u64 flags);
+				   struct lustre_handle *lockh, __u64 flags,
+				   ldlm_mode_t mode);
 int __ll_inode_revalidate_it(struct dentry *, struct lookup_intent *,
 			     __u64 bits);
 int ll_revalidate_nd(struct dentry *dentry, unsigned int flags);
@@ -1598,4 +1625,7 @@ int ll_layout_conf(struct inode *inode, const struct cl_object_conf *conf);
 int ll_layout_refresh(struct inode *inode, __u32 *gen);
 int ll_layout_restore(struct inode *inode);
 
+int ll_xattr_init(void);
+void ll_xattr_fini(void);
+
 #endif /* LLITE_INTERNAL_H */
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index facc391..154bdb2 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -209,7 +209,8 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 				  OBD_CONNECT_FULL20   | OBD_CONNECT_64BITHASH|
 				  OBD_CONNECT_EINPROGRESS |
 				  OBD_CONNECT_JOBSTATS | OBD_CONNECT_LVB_TYPE |
-				  OBD_CONNECT_LAYOUTLOCK | OBD_CONNECT_PINGLESS;
+				  OBD_CONNECT_LAYOUTLOCK |
+				  OBD_CONNECT_PINGLESS | OBD_CONNECT_MAX_EASIZE;
 
 	if (sbi->ll_flags & LL_SBI_SOM_PREVIEW)
 		data->ocd_connect_flags |= OBD_CONNECT_SOM;
@@ -383,6 +384,17 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 		sbi->ll_flags |= LL_SBI_LAYOUT_LOCK;
 	}
 
+	if (data->ocd_ibits_known & MDS_INODELOCK_XATTR) {
+		if (!(data->ocd_connect_flags & OBD_CONNECT_MAX_EASIZE)) {
+			LCONSOLE_INFO(
+				"%s: disabling xattr cache due to unknown maximum xattr size.\n",
+				dt);
+		} else {
+			sbi->ll_flags |= LL_SBI_XATTR_CACHE;
+			sbi->ll_xattr_cache_enabled = 1;
+		}
+	}
+
 	obd = class_name2obd(dt);
 	if (!obd) {
 		CERROR("DT %s: not setup or attached\n", dt);
@@ -922,6 +934,9 @@ void ll_lli_init(struct ll_inode_info *lli)
 	lli->lli_layout_gen = LL_LAYOUT_GEN_NONE;
 	lli->lli_clob = NULL;
 
+	init_rwsem(&lli->lli_xattrs_list_rwsem);
+	mutex_init(&lli->lli_xattrs_enq_lock);
+
 	LASSERT(lli->lli_vfs_inode.i_mode != 0);
 	if (S_ISDIR(lli->lli_vfs_inode.i_mode)) {
 		mutex_init(&lli->lli_readdir_mutex);
@@ -1194,6 +1209,8 @@ void ll_clear_inode(struct inode *inode)
 		lli->lli_symlink_name = NULL;
 	}
 
+	ll_xattr_cache_destroy(inode);
+
 	if (sbi->ll_flags & LL_SBI_RMT_CLIENT) {
 		LASSERT(lli->lli_posix_acl == NULL);
 		if (lli->lli_remote_perms) {
@@ -1752,7 +1769,9 @@ void ll_update_inode(struct inode *inode, struct lustre_md *md)
 			 * lock on the client and set LLIF_MDS_SIZE_LOCK holding
 			 * it. */
 			mode = ll_take_md_lock(inode, MDS_INODELOCK_UPDATE,
-					       &lockh, LDLM_FL_CBPENDING);
+					       &lockh, LDLM_FL_CBPENDING,
+					       LCK_CR | LCK_CW |
+					       LCK_PR | LCK_PW);
 			if (mode) {
 				if (lli->lli_flags & (LLIF_DONE_WRITING |
 						      LLIF_EPOCH_PENDING |
diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index 4bf09c4..1ded16a 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -723,6 +723,41 @@ static int ll_sbi_flags_seq_show(struct seq_file *m, void *v)
 }
 LPROC_SEQ_FOPS_RO(ll_sbi_flags);
 
+static int ll_xattr_cache_seq_show(struct seq_file *m, void *v)
+{
+	struct super_block *sb = m->private;
+	struct ll_sb_info *sbi = ll_s2sbi(sb);
+	int rc;
+
+	rc = seq_printf(m, "%u\n", sbi->ll_xattr_cache_enabled);
+
+	return rc;
+}
+
+static ssize_t ll_xattr_cache_seq_write(struct file *file, const char *buffer,
+					size_t count, loff_t *off)
+{
+	struct seq_file *seq = file->private_data;
+	struct super_block *sb = seq->private;
+	struct ll_sb_info *sbi = ll_s2sbi(sb);
+	int val, rc;
+
+	rc = lprocfs_write_helper(buffer, count, &val);
+	if (rc)
+		return rc;
+
+	if (val != 0 && val != 1)
+		return -ERANGE;
+
+	if (val == 1 && !(sbi->ll_flags & LL_SBI_XATTR_CACHE))
+		return -ENOTSUPP;
+
+	sbi->ll_xattr_cache_enabled = val;
+
+	return count;
+}
+LPROC_SEQ_FOPS(ll_xattr_cache);
+
 static struct lprocfs_vars lprocfs_llite_obd_vars[] = {
 	{ "uuid",	  &ll_sb_uuid_fops,	  0, 0 },
 	//{ "mntpt_path",   ll_rd_path,	     0, 0 },
@@ -751,6 +786,7 @@ static struct lprocfs_vars lprocfs_llite_obd_vars[] = {
 	{ "lazystatfs",       &ll_lazystatfs_fops, 0 },
 	{ "max_easize",       &ll_maxea_size_fops, 0, 0 },
 	{ "sbi_flags",	      &ll_sbi_flags_fops, 0, 0 },
+	{ "xattr_cache",      &ll_xattr_cache_fops, 0, 0 },
 	{ 0 }
 };
 
@@ -802,6 +838,7 @@ struct llite_file_opcode {
 	{ LPROC_LL_ALLOC_INODE,    LPROCFS_TYPE_REGS, "alloc_inode" },
 	{ LPROC_LL_SETXATTR,       LPROCFS_TYPE_REGS, "setxattr" },
 	{ LPROC_LL_GETXATTR,       LPROCFS_TYPE_REGS, "getxattr" },
+	{ LPROC_LL_GETXATTR_HITS,  LPROCFS_TYPE_REGS, "getxattr_hits" },
 	{ LPROC_LL_LISTXATTR,      LPROCFS_TYPE_REGS, "listxattr" },
 	{ LPROC_LL_REMOVEXATTR,    LPROCFS_TYPE_REGS, "removexattr" },
 	{ LPROC_LL_INODE_PERM,     LPROCFS_TYPE_REGS, "inode_permission" },
diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index 5242233..fc8d264 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -223,6 +223,10 @@ int ll_md_blocking_ast(struct ldlm_lock *lock, struct ldlm_lock_desc *desc,
 			break;
 
 		LASSERT(lock->l_flags & LDLM_FL_CANCELING);
+
+		if (bits & MDS_INODELOCK_XATTR)
+			ll_xattr_cache_destroy(inode);
+
 		/* For OPEN locks we differentiate between lock modes
 		 * LCK_CR, LCK_CW, LCK_PR - bug 22891 */
 		if (bits & (MDS_INODELOCK_LOOKUP | MDS_INODELOCK_UPDATE |
diff --git a/drivers/staging/lustre/lustre/llite/super25.c b/drivers/staging/lustre/lustre/llite/super25.c
index 0beaf4e..e21e1c7 100644
--- a/drivers/staging/lustre/lustre/llite/super25.c
+++ b/drivers/staging/lustre/lustre/llite/super25.c
@@ -187,11 +187,15 @@ static int __init init_lustre_lite(void)
 	if (rc == 0)
 		rc = vvp_global_init();
 
+	if (rc == 0)
+		rc = ll_xattr_init();
+
 	return rc;
 }
 
 static void __exit exit_lustre_lite(void)
 {
+	ll_xattr_fini();
 	vvp_global_fini();
 	del_timer(&ll_capa_timer);
 	ll_capa_thread_stop();
diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
index bcf86ba..ee95855 100644
--- a/drivers/staging/lustre/lustre/llite/xattr.c
+++ b/drivers/staging/lustre/lustre/llite/xattr.c
@@ -109,7 +109,7 @@ int ll_setxattr_common(struct inode *inode, const char *name,
 		       int flags, __u64 valid)
 {
 	struct ll_sb_info *sbi = ll_i2sbi(inode);
-	struct ptlrpc_request *req;
+	struct ptlrpc_request *req = NULL;
 	int xattr_type, rc;
 	struct obd_capa *oc;
 #ifdef CONFIG_FS_POSIX_ACL
@@ -183,11 +183,17 @@ int ll_setxattr_common(struct inode *inode, const char *name,
 		valid |= rce_ops2valid(rce->rce_ops);
 	}
 #endif
-	oc = ll_mdscapa_get(inode);
-	rc = md_setxattr(sbi->ll_md_exp, ll_inode2fid(inode), oc,
-			 valid, name, pv, size, 0, flags, ll_i2suppgid(inode),
-			 &req);
-	capa_put(oc);
+	if (sbi->ll_xattr_cache_enabled &&
+	    (rce == NULL || rce->rce_ops == RMT_LSETFACL)) {
+		rc = ll_xattr_cache_update(inode, name, pv, size, valid, flags);
+	} else {
+		oc = ll_mdscapa_get(inode);
+		rc = md_setxattr(sbi->ll_md_exp, ll_inode2fid(inode), oc,
+				valid, name, pv, size, 0, flags,
+				ll_i2suppgid(inode), &req);
+		capa_put(oc);
+	}
+
 #ifdef CONFIG_FS_POSIX_ACL
 	if (new_value != NULL)
 		lustre_posix_acl_xattr_free(new_value, size);
@@ -352,48 +358,54 @@ int ll_getxattr_common(struct inode *inode, const char *name,
 #endif
 
 do_getxattr:
-	oc = ll_mdscapa_get(inode);
-	rc = md_getxattr(sbi->ll_md_exp, ll_inode2fid(inode), oc,
-			 valid | (rce ? rce_ops2valid(rce->rce_ops) : 0),
-			 name, NULL, 0, size, 0, &req);
-	capa_put(oc);
-	if (rc) {
-		if (rc == -EOPNOTSUPP && xattr_type == XATTR_USER_T) {
-			LCONSOLE_INFO("Disabling user_xattr feature because "
-				      "it is not supported on the server\n");
-			sbi->ll_flags &= ~LL_SBI_USER_XATTR;
-		}
-		return rc;
-	}
+	if (sbi->ll_xattr_cache_enabled && (rce == NULL ||
+					    rce->rce_ops == RMT_LGETFACL ||
+					    rce->rce_ops == RMT_LSETFACL)) {
+		rc = ll_xattr_cache_get(inode, name, buffer, size, valid);
+		if (rc < 0)
+			GOTO(out_xattr, rc);
+	} else {
+		oc = ll_mdscapa_get(inode);
+		rc = md_getxattr(sbi->ll_md_exp, ll_inode2fid(inode), oc,
+				valid | (rce ? rce_ops2valid(rce->rce_ops) : 0),
+				name, NULL, 0, size, 0, &req);
+		capa_put(oc);
 
-	body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
-	LASSERT(body);
+		if (rc < 0)
+			GOTO(out_xattr, rc);
 
-	/* only detect the xattr size */
-	if (size == 0)
-		GOTO(out, rc = body->eadatasize);
+		body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
+		LASSERT(body);
 
-	if (size < body->eadatasize) {
-		CERROR("server bug: replied size %u > %u\n",
-		       body->eadatasize, (int)size);
-		GOTO(out, rc = -ERANGE);
-	}
+		/* only detect the xattr size */
+		if (size == 0)
+			GOTO(out, rc = body->eadatasize);
 
-	if (body->eadatasize == 0)
-		GOTO(out, rc = -ENODATA);
+		if (size < body->eadatasize) {
+			CERROR("server bug: replied size %u > %u\n",
+				body->eadatasize, (int)size);
+			GOTO(out, rc = -ERANGE);
+		}
+
+		if (body->eadatasize == 0)
+			GOTO(out, rc = -ENODATA);
 
-	/* do not need swab xattr data */
-	xdata = req_capsule_server_sized_get(&req->rq_pill, &RMF_EADATA,
-					     body->eadatasize);
-	if (!xdata)
-		GOTO(out, rc = -EFAULT);
+		/* do not need swab xattr data */
+		xdata = req_capsule_server_sized_get(&req->rq_pill, &RMF_EADATA,
+							body->eadatasize);
+		if (!xdata)
+			GOTO(out, rc = -EFAULT);
+
+		memcpy(buffer, xdata, body->eadatasize);
+		rc = body->eadatasize;
+	}
 
 #ifdef CONFIG_FS_POSIX_ACL
-	if (body->eadatasize >= 0 && rce && rce->rce_ops == RMT_LSETFACL) {
+	if (rce && rce->rce_ops == RMT_LSETFACL) {
 		ext_acl_xattr_header *acl;
 
-		acl = lustre_posix_acl_xattr_2ext((posix_acl_xattr_header *)xdata,
-						  body->eadatasize);
+		acl = lustre_posix_acl_xattr_2ext(
+					(posix_acl_xattr_header *)buffer, rc);
 		if (IS_ERR(acl))
 			GOTO(out, rc = PTR_ERR(acl));
 
@@ -406,12 +418,12 @@ do_getxattr:
 	}
 #endif
 
-	if (body->eadatasize == 0) {
-		rc = -ENODATA;
-	} else {
-		LASSERT(buffer);
-		memcpy(buffer, xdata, body->eadatasize);
-		rc = body->eadatasize;
+out_xattr:
+	if (rc == -EOPNOTSUPP && xattr_type == XATTR_USER_T) {
+		LCONSOLE_INFO(
+			"%s: disabling user_xattr feature because it is not supported on the server: rc = %d\n",
+			ll_get_fsname(inode->i_sb, NULL, 0), rc);
+		sbi->ll_flags &= ~LL_SBI_USER_XATTR;
 	}
 out:
 	ptlrpc_req_finished(req);
diff --git a/drivers/staging/lustre/lustre/llite/xattr_cache.c b/drivers/staging/lustre/lustre/llite/xattr_cache.c
new file mode 100644
index 0000000..3e3be1f
--- /dev/null
+++ b/drivers/staging/lustre/lustre/llite/xattr_cache.c
@@ -0,0 +1,617 @@
+/*
+ * Copyright 2012 Xyratex Technology Limited
+ *
+ * Author: Andrew Perepechko <Andrew_Perepechko@xyratex.com>
+ *
+ */
+
+#define DEBUG_SUBSYSTEM S_LLITE
+
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <obd_support.h>
+#include <lustre_lite.h>
+#include <lustre_dlm.h>
+#include <lustre_ver.h>
+#include "llite_internal.h"
+
+/* If we ever have hundreds of extended attributes, we might want to consider
+ * using a hash or a tree structure instead of list for faster lookups.
+ */
+struct ll_xattr_entry {
+	struct list_head	xe_list;    /* protected with
+					     * lli_xattrs_list_rwsem */
+	char			*xe_name;   /* xattr name, \0-terminated */
+	char			*xe_value;  /* xattr value */
+	unsigned		xe_namelen; /* strlen(xe_name) + 1 */
+	unsigned		xe_vallen;  /* xattr value length */
+};
+
+static struct kmem_cache *xattr_kmem;
+static struct lu_kmem_descr xattr_caches[] = {
+	{
+		.ckd_cache = &xattr_kmem,
+		.ckd_name  = "xattr_kmem",
+		.ckd_size  = sizeof(struct ll_xattr_entry)
+	},
+	{
+		.ckd_cache = NULL
+	}
+};
+
+int ll_xattr_init(void)
+{
+	return lu_kmem_init(xattr_caches);
+}
+
+void ll_xattr_fini(void)
+{
+	lu_kmem_fini(xattr_caches);
+}
+
+/**
+ * Initializes xattr cache for an inode.
+ *
+ * This initializes the xattr list and marks cache presence.
+ */
+static void ll_xattr_cache_init(struct ll_inode_info *lli)
+{
+
+
+	LASSERT(lli != NULL);
+
+	INIT_LIST_HEAD(&lli->lli_xattrs);
+	lli->lli_flags |= LLIF_XATTR_CACHE;
+}
+
+/**
+ *  This looks for a specific extended attribute.
+ *
+ *  Find in @cache and return @xattr_name attribute in @xattr,
+ *  for the NULL @xattr_name return the first cached @xattr.
+ *
+ *  \retval 0        success
+ *  \retval -ENODATA if not found
+ */
+static int ll_xattr_cache_find(struct list_head *cache,
+			       const char *xattr_name,
+			       struct ll_xattr_entry **xattr)
+{
+	struct ll_xattr_entry *entry;
+
+
+
+	list_for_each_entry(entry, cache, xe_list) {
+		/* xattr_name == NULL means look for any entry */
+		if (xattr_name == NULL ||
+		    strcmp(xattr_name, entry->xe_name) == 0) {
+			*xattr = entry;
+			CDEBUG(D_CACHE, "find: [%s]=%.*s\n",
+			       entry->xe_name, entry->xe_vallen,
+			       entry->xe_value);
+			return 0;
+		}
+	}
+
+	return -ENODATA;
+}
+
+/**
+ * This adds or updates an xattr.
+ *
+ * Add @xattr_name attr with @xattr_val value and @xattr_val_len length,
+ * if the attribute already exists, then update its value.
+ *
+ * \retval 0       success
+ * \retval -ENOMEM if no memory could be allocated for the cached attr
+ */
+static int ll_xattr_cache_add(struct list_head *cache,
+			      const char *xattr_name,
+			      const char *xattr_val,
+			      unsigned xattr_val_len)
+{
+	struct ll_xattr_entry *xattr;
+
+
+
+	if (ll_xattr_cache_find(cache, xattr_name, &xattr) == 0) {
+		/* Found a cached EA, update it */
+
+		if (xattr_val_len != xattr->xe_vallen) {
+			char *val;
+			OBD_ALLOC(val, xattr_val_len);
+			if (val == NULL) {
+				CDEBUG(D_CACHE,
+				       "failed to allocate %u bytes for xattr %s update\n",
+				       xattr_val_len, xattr_name);
+				return -ENOMEM;
+			}
+			OBD_FREE(xattr->xe_value, xattr->xe_vallen);
+			xattr->xe_value = val;
+			xattr->xe_vallen = xattr_val_len;
+		}
+		memcpy(xattr->xe_value, xattr_val, xattr_val_len);
+
+		CDEBUG(D_CACHE, "update: [%s]=%.*s\n", xattr_name,
+			xattr_val_len, xattr_val);
+
+		return 0;
+	}
+
+	OBD_SLAB_ALLOC_PTR_GFP(xattr, xattr_kmem, __GFP_IO);
+	if (xattr == NULL) {
+		CDEBUG(D_CACHE, "failed to allocate xattr\n");
+		return -ENOMEM;
+	}
+
+	xattr->xe_namelen = strlen(xattr_name) + 1;
+
+	OBD_ALLOC(xattr->xe_name, xattr->xe_namelen);
+	if (!xattr->xe_name) {
+		CDEBUG(D_CACHE, "failed to alloc xattr name %u\n",
+		       xattr->xe_namelen);
+		goto err_name;
+	}
+	OBD_ALLOC(xattr->xe_value, xattr_val_len);
+	if (!xattr->xe_value) {
+		CDEBUG(D_CACHE, "failed to alloc xattr value %d\n",
+		       xattr_val_len);
+		goto err_value;
+	}
+
+	memcpy(xattr->xe_name, xattr_name, xattr->xe_namelen);
+	memcpy(xattr->xe_value, xattr_val, xattr_val_len);
+	xattr->xe_vallen = xattr_val_len;
+	list_add(&xattr->xe_list, cache);
+
+	CDEBUG(D_CACHE, "set: [%s]=%.*s\n", xattr_name,
+		xattr_val_len, xattr_val);
+
+	return 0;
+err_value:
+	OBD_FREE(xattr->xe_name, xattr->xe_namelen);
+err_name:
+	OBD_SLAB_FREE_PTR(xattr, xattr_kmem);
+
+	return -ENOMEM;
+}
+
+/**
+ * This removes an extended attribute from cache.
+ *
+ * Remove @xattr_name attribute from @cache.
+ *
+ * \retval 0        success
+ * \retval -ENODATA if @xattr_name is not cached
+ */
+static int ll_xattr_cache_del(struct list_head *cache,
+			      const char *xattr_name)
+{
+	struct ll_xattr_entry *xattr;
+
+
+
+	CDEBUG(D_CACHE, "del xattr: %s\n", xattr_name);
+
+	if (ll_xattr_cache_find(cache, xattr_name, &xattr) == 0) {
+		list_del(&xattr->xe_list);
+		OBD_FREE(xattr->xe_name, xattr->xe_namelen);
+		OBD_FREE(xattr->xe_value, xattr->xe_vallen);
+		OBD_SLAB_FREE_PTR(xattr, xattr_kmem);
+
+		return 0;
+	}
+
+	return -ENODATA;
+}
+
+/**
+ * This iterates cached extended attributes.
+ *
+ * Walk over cached attributes in @cache and
+ * fill in @xld_buffer or only calculate buffer
+ * size if @xld_buffer is NULL.
+ *
+ * \retval >= 0     buffer list size
+ * \retval -ENODATA if the list cannot fit @xld_size buffer
+ */
+static int ll_xattr_cache_list(struct list_head *cache,
+			       char *xld_buffer,
+			       int xld_size)
+{
+	struct ll_xattr_entry *xattr, *tmp;
+	int xld_tail = 0;
+
+
+
+	list_for_each_entry_safe(xattr, tmp, cache, xe_list) {
+		CDEBUG(D_CACHE, "list: buffer=%p[%d] name=%s\n",
+			xld_buffer, xld_tail, xattr->xe_name);
+
+		if (xld_buffer) {
+			xld_size -= xattr->xe_namelen;
+			if (xld_size < 0)
+				break;
+			memcpy(&xld_buffer[xld_tail],
+			       xattr->xe_name, xattr->xe_namelen);
+		}
+		xld_tail += xattr->xe_namelen;
+	}
+
+	if (xld_size < 0)
+		return -ERANGE;
+
+	return xld_tail;
+}
+
+/**
+ * Check if the xattr cache is initialized (filled).
+ *
+ * \retval 0 @cache is not initialized
+ * \retval 1 @cache is initialized
+ */
+int ll_xattr_cache_valid(struct ll_inode_info *lli)
+{
+	return !!(lli->lli_flags & LLIF_XATTR_CACHE);
+}
+
+/**
+ * This finalizes the xattr cache.
+ *
+ * Free all xattr memory. @lli is the inode info pointer.
+ *
+ * \retval 0 no error occured
+ */
+static int ll_xattr_cache_destroy_locked(struct ll_inode_info *lli)
+{
+
+
+	if (!ll_xattr_cache_valid(lli))
+		return 0;
+
+	while (ll_xattr_cache_del(&lli->lli_xattrs, NULL) == 0)
+		; /* empty loop */
+	lli->lli_flags &= ~LLIF_XATTR_CACHE;
+
+	return 0;
+}
+
+int ll_xattr_cache_destroy(struct inode *inode)
+{
+	struct ll_inode_info *lli = ll_i2info(inode);
+	int rc;
+
+
+
+	down_write(&lli->lli_xattrs_list_rwsem);
+	rc = ll_xattr_cache_destroy_locked(lli);
+	up_write(&lli->lli_xattrs_list_rwsem);
+
+	return rc;
+}
+
+/**
+ * Match or enqueue a PR or PW LDLM lock.
+ *
+ * Find or request an LDLM lock with xattr data.
+ * Since LDLM does not provide API for atomic match_or_enqueue,
+ * the function handles it with a separate enq lock.
+ * If successful, the function exits with the list lock held.
+ *
+ * \retval 0       no error occured
+ * \retval -ENOMEM not enough memory
+ */
+static int ll_xattr_find_get_lock(struct inode *inode,
+				  struct lookup_intent *oit,
+				  struct ptlrpc_request **req)
+{
+	ldlm_mode_t mode;
+	struct lustre_handle lockh = { 0 };
+	struct md_op_data *op_data;
+	struct ll_inode_info *lli = ll_i2info(inode);
+	struct ldlm_enqueue_info einfo = { .ei_type = LDLM_IBITS,
+					   .ei_mode = it_to_lock_mode(oit),
+					   .ei_cb_bl = ll_md_blocking_ast,
+					   .ei_cb_cp = ldlm_completion_ast };
+	struct ll_sb_info *sbi = ll_i2sbi(inode);
+	struct obd_export *exp = sbi->ll_md_exp;
+	int rc;
+
+
+
+	mutex_lock(&lli->lli_xattrs_enq_lock);
+	/* Try matching first. */
+	mode = ll_take_md_lock(inode, MDS_INODELOCK_XATTR, &lockh, 0,
+			       oit->it_op == IT_SETXATTR ? LCK_PW :
+							   (LCK_PR | LCK_PW));
+	if (mode != 0) {
+		/* fake oit in mdc_revalidate_lock() manner */
+		oit->d.lustre.it_lock_handle = lockh.cookie;
+		oit->d.lustre.it_lock_mode = mode;
+		goto out;
+	}
+
+	/* Enqueue if the lock isn't cached locally. */
+	op_data = ll_prep_md_op_data(NULL, inode, NULL, NULL, 0, 0,
+				     LUSTRE_OPC_ANY, NULL);
+	if (IS_ERR(op_data)) {
+		mutex_unlock(&lli->lli_xattrs_enq_lock);
+		return PTR_ERR(op_data);
+	}
+
+	op_data->op_valid = OBD_MD_FLXATTR | OBD_MD_FLXATTRLS |
+			    OBD_MD_FLXATTRLOCKED;
+#ifdef CONFIG_FS_POSIX_ACL
+	/* If working with ACLs, we would like to cache local ACLs */
+	if (sbi->ll_flags & LL_SBI_RMT_CLIENT)
+		op_data->op_valid |= OBD_MD_FLRMTLGETFACL;
+#endif
+
+	rc = md_enqueue(exp, &einfo, oit, op_data, &lockh, NULL, 0, NULL, 0);
+	ll_finish_md_op_data(op_data);
+
+	if (rc < 0) {
+		CDEBUG(D_CACHE,
+		       "md_intent_lock failed with %d for fid "DFID"\n",
+		       rc, PFID(ll_inode2fid(inode)));
+		mutex_unlock(&lli->lli_xattrs_enq_lock);
+		return rc;
+	}
+
+	*req = (struct ptlrpc_request *)oit->d.lustre.it_data;
+out:
+	down_write(&lli->lli_xattrs_list_rwsem);
+	mutex_unlock(&lli->lli_xattrs_enq_lock);
+
+	return 0;
+}
+
+/**
+ * Refill the xattr cache.
+ *
+ * Fetch and cache the whole of xattrs for @inode, acquiring
+ * a read or a write xattr lock depending on operation in @oit.
+ * Intent is dropped on exit unless the operation is setxattr.
+ *
+ * \retval 0       no error occured
+ * \retval -EPROTO network protocol error
+ * \retval -ENOMEM not enough memory for the cache
+ */
+static int ll_xattr_cache_refill(struct inode *inode, struct lookup_intent *oit)
+{
+	struct ll_sb_info *sbi = ll_i2sbi(inode);
+	struct ptlrpc_request *req = NULL;
+	const char *xdata, *xval, *xtail, *xvtail;
+	struct ll_inode_info *lli = ll_i2info(inode);
+	struct mdt_body *body;
+	__u32 *xsizes;
+	int rc = 0, i;
+
+
+
+	rc = ll_xattr_find_get_lock(inode, oit, &req);
+	if (rc)
+		GOTO(out_no_unlock, rc);
+
+	/* Do we have the data at this point? */
+	if (ll_xattr_cache_valid(lli)) {
+		ll_stats_ops_tally(sbi, LPROC_LL_GETXATTR_HITS, 1);
+		GOTO(out_maybe_drop, rc = 0);
+	}
+
+	/* Matched but no cache? Cancelled on error by a parallel refill. */
+	if (unlikely(req == NULL)) {
+		CDEBUG(D_CACHE, "cancelled by a parallel getxattr\n");
+		GOTO(out_maybe_drop, rc = -EIO);
+	}
+
+	if (oit->d.lustre.it_status < 0) {
+		CDEBUG(D_CACHE, "getxattr intent returned %d for fid "DFID"\n",
+		       oit->d.lustre.it_status, PFID(ll_inode2fid(inode)));
+		GOTO(out_destroy, rc = oit->d.lustre.it_status);
+	}
+
+	body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
+	if (body == NULL) {
+		CERROR("no MDT BODY in the refill xattr reply\n");
+		GOTO(out_destroy, rc = -EPROTO);
+	}
+	/* do not need swab xattr data */
+	xdata = req_capsule_server_sized_get(&req->rq_pill, &RMF_EADATA,
+						body->eadatasize);
+	xval = req_capsule_server_sized_get(&req->rq_pill, &RMF_EAVALS,
+						body->aclsize);
+	xsizes = req_capsule_server_sized_get(&req->rq_pill, &RMF_EAVALS_LENS,
+					      body->max_mdsize * sizeof(__u32));
+	if (xdata == NULL || xval == NULL || xsizes == NULL) {
+		CERROR("wrong setxattr reply\n");
+		GOTO(out_destroy, rc = -EPROTO);
+	}
+
+	xtail = xdata + body->eadatasize;
+	xvtail = xval + body->aclsize;
+
+	CDEBUG(D_CACHE, "caching: xdata=%p xtail=%p\n", xdata, xtail);
+
+	ll_xattr_cache_init(lli);
+
+	for (i = 0; i < body->max_mdsize; i++) {
+		CDEBUG(D_CACHE, "caching [%s]=%.*s\n", xdata, *xsizes, xval);
+		/* Perform consistency checks: attr names and vals in pill */
+		if (memchr(xdata, 0, xtail - xdata) == NULL) {
+			CERROR("xattr protocol violation (names are broken)\n");
+			rc = -EPROTO;
+		} else if (xval + *xsizes > xvtail) {
+			CERROR("xattr protocol violation (vals are broken)\n");
+			rc = -EPROTO;
+		} else if (OBD_FAIL_CHECK(OBD_FAIL_LLITE_XATTR_ENOMEM)) {
+			rc = -ENOMEM;
+		} else {
+			rc = ll_xattr_cache_add(&lli->lli_xattrs, xdata, xval,
+						*xsizes);
+		}
+		if (rc < 0) {
+			ll_xattr_cache_destroy_locked(lli);
+			GOTO(out_destroy, rc);
+		}
+		xdata += strlen(xdata) + 1;
+		xval  += *xsizes;
+		xsizes++;
+	}
+
+	if (xdata != xtail || xval != xvtail)
+		CERROR("a hole in xattr data\n");
+
+	ll_set_lock_data(sbi->ll_md_exp, inode, oit, NULL);
+
+	GOTO(out_maybe_drop, rc);
+out_maybe_drop:
+	/* drop lock on error or getxattr */
+	if (rc != 0 || oit->it_op != IT_SETXATTR)
+		ll_intent_drop_lock(oit);
+
+	if (rc != 0)
+		up_write(&lli->lli_xattrs_list_rwsem);
+out_no_unlock:
+	ptlrpc_req_finished(req);
+
+	return rc;
+
+out_destroy:
+	up_write(&lli->lli_xattrs_list_rwsem);
+
+	ldlm_lock_decref_and_cancel((struct lustre_handle *)
+					&oit->d.lustre.it_lock_handle,
+					oit->d.lustre.it_lock_mode);
+
+	goto out_no_unlock;
+}
+
+/**
+ * Get an xattr value or list xattrs using the write-through cache.
+ *
+ * Get the xattr value (@valid has OBD_MD_FLXATTR set) of @name or
+ * list xattr names (@valid has OBD_MD_FLXATTRLS set) for @inode.
+ * The resulting value/list is stored in @buffer if the former
+ * is not larger than @size.
+ *
+ * \retval 0        no error occured
+ * \retval -EPROTO  network protocol error
+ * \retval -ENOMEM  not enough memory for the cache
+ * \retval -ERANGE  the buffer is not large enough
+ * \retval -ENODATA no such attr or the list is empty
+ */
+int ll_xattr_cache_get(struct inode *inode,
+			const char *name,
+			char *buffer,
+			size_t size,
+			__u64 valid)
+{
+	struct lookup_intent oit = { .it_op = IT_GETXATTR };
+	struct ll_inode_info *lli = ll_i2info(inode);
+	int rc = 0;
+
+
+
+	LASSERT(!!(valid & OBD_MD_FLXATTR) ^ !!(valid & OBD_MD_FLXATTRLS));
+
+	down_read(&lli->lli_xattrs_list_rwsem);
+	if (!ll_xattr_cache_valid(lli)) {
+		up_read(&lli->lli_xattrs_list_rwsem);
+		rc = ll_xattr_cache_refill(inode, &oit);
+		if (rc)
+			return rc;
+		downgrade_write(&lli->lli_xattrs_list_rwsem);
+	} else {
+		ll_stats_ops_tally(ll_i2sbi(inode), LPROC_LL_GETXATTR_HITS, 1);
+	}
+
+	if (valid & OBD_MD_FLXATTR) {
+		struct ll_xattr_entry *xattr;
+
+		rc = ll_xattr_cache_find(&lli->lli_xattrs, name, &xattr);
+		if (rc == 0) {
+			rc = xattr->xe_vallen;
+			/* zero size means we are only requested size in rc */
+			if (size != 0) {
+				if (size >= xattr->xe_vallen)
+					memcpy(buffer, xattr->xe_value,
+						xattr->xe_vallen);
+				else
+					rc = -ERANGE;
+			}
+		}
+	} else if (valid & OBD_MD_FLXATTRLS) {
+		rc = ll_xattr_cache_list(&lli->lli_xattrs,
+					 size ? buffer : NULL, size);
+	}
+
+	GOTO(out, rc);
+out:
+	up_read(&lli->lli_xattrs_list_rwsem);
+
+	return rc;
+}
+
+
+/**
+ * Set/update an xattr value or remove xattr using the write-through cache.
+ *
+ * Set/update the xattr value (if @valid has OBD_MD_FLXATTR) of @name to @newval
+ * or
+ * remove the xattr @name (@valid has OBD_MD_FLXATTRRM set) from @inode.
+ * @flags is either XATTR_CREATE or XATTR_REPLACE as defined by setxattr(2)
+ *
+ * \retval 0        no error occured
+ * \retval -EPROTO  network protocol error
+ * \retval -ENOMEM  not enough memory for the cache
+ * \retval -ERANGE  the buffer is not large enough
+ * \retval -ENODATA no such attr (in the removal case)
+ */
+int ll_xattr_cache_update(struct inode *inode,
+			const char *name,
+			const char *newval,
+			size_t size,
+			__u64 valid,
+			int flags)
+{
+	struct lookup_intent oit = { .it_op = IT_SETXATTR };
+	struct ll_sb_info *sbi = ll_i2sbi(inode);
+	struct ptlrpc_request *req = NULL;
+	struct ll_inode_info *lli = ll_i2info(inode);
+	struct obd_capa *oc;
+	int rc;
+
+
+
+	LASSERT(!!(valid & OBD_MD_FLXATTR) ^ !!(valid & OBD_MD_FLXATTRRM));
+
+	rc = ll_xattr_cache_refill(inode, &oit);
+	if (rc)
+		return rc;
+
+	oc = ll_mdscapa_get(inode);
+	rc = md_setxattr(sbi->ll_md_exp, ll_inode2fid(inode), oc,
+			valid | OBD_MD_FLXATTRLOCKED, name, newval,
+			size, 0, flags, ll_i2suppgid(inode), &req);
+	capa_put(oc);
+
+	if (rc) {
+		ll_intent_drop_lock(&oit);
+		GOTO(out, rc);
+	}
+
+	if (valid & OBD_MD_FLXATTR)
+		rc = ll_xattr_cache_add(&lli->lli_xattrs, name, newval, size);
+	else if (valid & OBD_MD_FLXATTRRM)
+		rc = ll_xattr_cache_del(&lli->lli_xattrs, name);
+
+	ll_intent_drop_lock(&oit);
+	GOTO(out, rc);
+out:
+	up_write(&lli->lli_xattrs_list_rwsem);
+	ptlrpc_req_finished(req);
+
+	return rc;
+}
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_internal.h b/drivers/staging/lustre/lustre/mdc/mdc_internal.h
index b995af6..5069829 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_internal.h
+++ b/drivers/staging/lustre/lustre/mdc/mdc_internal.h
@@ -72,6 +72,7 @@ void mdc_open_pack(struct ptlrpc_request *req, struct md_op_data *op_data,
 		   __u32 mode, __u64 rdev, __u64 flags, const void *data,
 		   int datalen);
 void mdc_unlink_pack(struct ptlrpc_request *req, struct md_op_data *op_data);
+void mdc_getxattr_pack(struct ptlrpc_request *req, struct md_op_data *op_data);
 void mdc_link_pack(struct ptlrpc_request *req, struct md_op_data *op_data);
 void mdc_rename_pack(struct ptlrpc_request *req, struct md_op_data *op_data,
 		     const char *old, int oldlen, const char *new, int newlen);
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 09dee11..cc5490c 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -360,6 +360,62 @@ static struct ptlrpc_request *mdc_intent_open_pack(struct obd_export *exp,
 	return req;
 }
 
+static struct ptlrpc_request *
+mdc_intent_getxattr_pack(struct obd_export *exp,
+			 struct lookup_intent *it,
+			 struct md_op_data *op_data)
+{
+	struct ptlrpc_request	*req;
+	struct ldlm_intent	*lit;
+	int			rc, count = 0, maxdata;
+	LIST_HEAD(cancels);
+
+
+
+	req = ptlrpc_request_alloc(class_exp2cliimp(exp),
+					&RQF_LDLM_INTENT_GETXATTR);
+	if (req == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	mdc_set_capa_size(req, &RMF_CAPA1, op_data->op_capa1);
+
+	if (it->it_op == IT_SETXATTR)
+		/* If we want to upgrade to LCK_PW, let's cancel LCK_PR
+		 * locks now. This avoids unnecessary ASTs. */
+		count = mdc_resource_get_unused(exp, &op_data->op_fid1,
+						&cancels, LCK_PW,
+						MDS_INODELOCK_XATTR);
+
+	rc = ldlm_prep_enqueue_req(exp, req, &cancels, count);
+	if (rc) {
+		ptlrpc_request_free(req);
+		return ERR_PTR(rc);
+	}
+
+	/* pack the intent */
+	lit = req_capsule_client_get(&req->rq_pill, &RMF_LDLM_INTENT);
+	lit->opc = IT_GETXATTR;
+
+	maxdata = class_exp2cliimp(exp)->imp_connect_data.ocd_max_easize;
+
+	/* pack the intended request */
+	mdc_pack_body(req, &op_data->op_fid1, op_data->op_capa1,
+			op_data->op_valid, maxdata, -1, 0);
+
+	req_capsule_set_size(&req->rq_pill, &RMF_EADATA,
+				RCL_SERVER, maxdata);
+
+	req_capsule_set_size(&req->rq_pill, &RMF_EAVALS,
+				RCL_SERVER, maxdata);
+
+	req_capsule_set_size(&req->rq_pill, &RMF_EAVALS_LENS,
+				RCL_SERVER, maxdata);
+
+	ptlrpc_request_set_replen(req);
+
+	return req;
+}
+
 static struct ptlrpc_request *mdc_intent_unlink_pack(struct obd_export *exp,
 						     struct lookup_intent *it,
 						     struct md_op_data *op_data)
@@ -735,6 +791,8 @@ int mdc_enqueue(struct obd_export *exp, struct ldlm_enqueue_info *einfo,
 			    { .l_inodebits = { MDS_INODELOCK_UPDATE } };
 	static const ldlm_policy_data_t layout_policy =
 			    { .l_inodebits = { MDS_INODELOCK_LAYOUT } };
+	static const ldlm_policy_data_t getxattr_policy = {
+			      .l_inodebits = { MDS_INODELOCK_XATTR } };
 	ldlm_policy_data_t const *policy = &lookup_policy;
 	int		    generation, resends = 0;
 	struct ldlm_reply     *lockrep;
@@ -751,6 +809,8 @@ int mdc_enqueue(struct obd_export *exp, struct ldlm_enqueue_info *einfo,
 			policy = &update_policy;
 		else if (it->it_op & IT_LAYOUT)
 			policy = &layout_policy;
+		else if (it->it_op & (IT_GETXATTR | IT_SETXATTR))
+			policy = &getxattr_policy;
 	}
 
 	LASSERT(reqp == NULL);
@@ -781,9 +841,10 @@ resend:
 	} else if (it->it_op & IT_LAYOUT) {
 		if (!imp_connect_lvb_type(class_exp2cliimp(exp)))
 			return -EOPNOTSUPP;
-
 		req = mdc_intent_layout_pack(exp, it, op_data);
 		lvb_type = LVB_T_LAYOUT;
+	} else if (it->it_op & (IT_GETXATTR | IT_SETXATTR)) {
+		req = mdc_intent_getxattr_pack(exp, it, op_data);
 	} else {
 		LBUG();
 		return -EINVAL;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/layout.c b/drivers/staging/lustre/lustre/ptlrpc/layout.c
index c4381eb..eee8874 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/layout.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/layout.c
@@ -462,6 +462,25 @@ static const struct req_msg_field *ldlm_intent_unlink_client[] = {
 	&RMF_NAME
 };
 
+static const struct req_msg_field *ldlm_intent_getxattr_client[] = {
+	&RMF_PTLRPC_BODY,
+	&RMF_DLM_REQ,
+	&RMF_LDLM_INTENT,
+	&RMF_MDT_BODY,
+	&RMF_CAPA1,
+};
+
+static const struct req_msg_field *ldlm_intent_getxattr_server[] = {
+	&RMF_PTLRPC_BODY,
+	&RMF_DLM_REP,
+	&RMF_MDT_BODY,
+	&RMF_MDT_MD,
+	&RMF_ACL, /* for req_capsule_extend/mdt_intent_policy */
+	&RMF_EADATA,
+	&RMF_EAVALS,
+	&RMF_EAVALS_LENS
+};
+
 static const struct req_msg_field *mds_getxattr_client[] = {
 	&RMF_PTLRPC_BODY,
 	&RMF_MDT_BODY,
@@ -739,6 +758,7 @@ static struct req_format *req_formats[] = {
 	&RQF_LDLM_INTENT_OPEN,
 	&RQF_LDLM_INTENT_CREATE,
 	&RQF_LDLM_INTENT_UNLINK,
+	&RQF_LDLM_INTENT_GETXATTR,
 	&RQF_LDLM_INTENT_QUOTA,
 	&RQF_QUOTA_DQACQ,
 	&RQF_LOG_CANCEL,
@@ -1013,6 +1033,9 @@ struct req_msg_field RMF_EADATA = DEFINE_MSGF("eadata", 0, -1,
 						    NULL, NULL);
 EXPORT_SYMBOL(RMF_EADATA);
 
+struct req_msg_field RMF_EAVALS = DEFINE_MSGF("eavals", 0, -1, NULL, NULL);
+EXPORT_SYMBOL(RMF_EAVALS);
+
 struct req_msg_field RMF_ACL =
 	DEFINE_MSGF("acl", RMF_F_NO_SIZE_CHECK,
 		    LUSTRE_POSIX_ACL_MAX_SIZE, NULL, NULL);
@@ -1064,6 +1087,11 @@ struct req_msg_field RMF_RCS =
 		    lustre_swab_generic_32s, dump_rcs);
 EXPORT_SYMBOL(RMF_RCS);
 
+struct req_msg_field RMF_EAVALS_LENS =
+	DEFINE_MSGF("eavals_lens", RMF_F_STRUCT_ARRAY, sizeof(__u32),
+		lustre_swab_generic_32s, NULL);
+EXPORT_SYMBOL(RMF_EAVALS_LENS);
+
 struct req_msg_field RMF_OBD_ID =
 	DEFINE_MSGF("obd_id", 0,
 		    sizeof(obd_id), lustre_swab_ost_last_id, NULL);
@@ -1421,6 +1449,12 @@ struct req_format RQF_LDLM_INTENT_UNLINK =
 			ldlm_intent_unlink_client, ldlm_intent_server);
 EXPORT_SYMBOL(RQF_LDLM_INTENT_UNLINK);
 
+struct req_format RQF_LDLM_INTENT_GETXATTR =
+	DEFINE_REQ_FMT0("LDLM_INTENT_GETXATTR",
+			ldlm_intent_getxattr_client,
+			ldlm_intent_getxattr_server);
+EXPORT_SYMBOL(RQF_LDLM_INTENT_GETXATTR);
+
 struct req_format RQF_MDS_CLOSE =
 	DEFINE_REQ_FMT0("MDS_CLOSE",
 			mdt_close_client, mds_last_unlink_server);
-- 
1.7.9.5

