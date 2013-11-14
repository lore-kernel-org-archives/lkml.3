Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab3KNQRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:17:22 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51742 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab3KNQQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:16:31 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 32/40] staging/lustre/api: HSM import uses new released pattern
Date: Fri, 15 Nov 2013 00:13:34 +0800
Message-Id: <1384445622-12346-33-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>

Import creates a released file using new RAID pattern flag
Import used a new ioctl() to implement the import in the
client kernel.
Add a -L|--layout option to lfs getstripe and lfs find

Lustre-change: http://review.whamcloud.com/6536
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3363
Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
[Fix up kuid_t/guid_t conversion in llite/file.c -- Peng Tao]
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_user.h     |   17 +-
 .../lustre/lustre/include/lustre/lustreapi.h       |  172 +++++++++++---------
 drivers/staging/lustre/lustre/llite/file.c         |  118 +++++++++++---
 .../staging/lustre/lustre/llite/llite_internal.h   |    2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   21 ++-
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |   40 +++++
 6 files changed, 261 insertions(+), 109 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index ec1bcf5..49ab5be 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -244,9 +244,9 @@ struct ost_id {
 #define LL_IOC_LMV_SETSTRIPE		_IOWR('f', 240, struct lmv_user_md)
 #define LL_IOC_LMV_GETSTRIPE		_IOWR('f', 241, struct lmv_user_md)
 #define LL_IOC_REMOVE_ENTRY		_IOWR('f', 242, __u64)
-
 #define LL_IOC_SET_LEASE		_IOWR('f', 243, long)
 #define LL_IOC_GET_LEASE		_IO('f', 244)
+#define LL_IOC_HSM_IMPORT		_IOWR('f', 245, struct hsm_user_import)
 
 #define LL_STATFS_LMV		1
 #define LL_STATFS_LOV		2
@@ -1130,6 +1130,21 @@ static inline int hal_size(struct hsm_action_list *hal)
 	return sz;
 }
 
+/* HSM file import
+ * describe the attributes to be set on imported file
+ */
+struct hsm_user_import {
+	__u64		hui_size;
+	__u64		hui_atime;
+	__u64		hui_mtime;
+	__u32		hui_atime_ns;
+	__u32		hui_mtime_ns;
+	__u32		hui_uid;
+	__u32		hui_gid;
+	__u32		hui_mode;
+	__u32		hui_archive_id;
+};
+
 /* Copytool progress reporting */
 #define HP_FLAG_COMPLETED 0x01
 #define HP_FLAG_RETRY     0x02
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustreapi.h b/drivers/staging/lustre/lustre/include/lustre/lustreapi.h
index 63da665..1748138 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustreapi.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustreapi.h
@@ -90,97 +90,110 @@ extern int llapi_file_get_stripe(const char *path, struct lov_user_md *lum);
 #define HAVE_LLAPI_FILE_LOOKUP
 extern int llapi_file_lookup(int dirfd, const char *name);
 
-#define VERBOSE_COUNT      0x1
-#define VERBOSE_SIZE       0x2
-#define VERBOSE_OFFSET     0x4
-#define VERBOSE_POOL       0x8
-#define VERBOSE_DETAIL     0x10
-#define VERBOSE_OBJID      0x20
-#define VERBOSE_GENERATION 0x40
-#define VERBOSE_MDTINDEX   0x80
-#define VERBOSE_ALL	(VERBOSE_COUNT | VERBOSE_SIZE | VERBOSE_OFFSET | \
-			    VERBOSE_POOL | VERBOSE_OBJID | VERBOSE_GENERATION)
+#define VERBOSE_COUNT		0x1
+#define VERBOSE_SIZE		0x2
+#define VERBOSE_OFFSET		0x4
+#define VERBOSE_POOL		0x8
+#define VERBOSE_DETAIL		0x10
+#define VERBOSE_OBJID		0x20
+#define VERBOSE_GENERATION	0x40
+#define VERBOSE_MDTINDEX	0x80
+#define VERBOSE_LAYOUT		0x100
+#define VERBOSE_ALL		(VERBOSE_COUNT | VERBOSE_SIZE | \
+				 VERBOSE_OFFSET | VERBOSE_POOL | \
+				 VERBOSE_OBJID | VERBOSE_GENERATION |\
+				 VERBOSE_LAYOUT)
 
 struct find_param {
-	unsigned int maxdepth;
-	time_t  atime;
-	time_t  mtime;
-	time_t  ctime;
-	int     asign;  /* cannot be bitfields due to using pointers to */
-	int     csign;  /* access them during argument parsing. */
-	int     msign;
-	int     type;
-	int	     size_sign:2,	/* these need to be signed values */
-			stripesize_sign:2,
-			stripecount_sign:2;
-	unsigned long long size;
-	unsigned long long size_units;
-	uid_t uid;
-	gid_t gid;
-
-	unsigned long   zeroend:1,
-			recursive:1,
-			exclude_pattern:1,
-			exclude_type:1,
-			exclude_obd:1,
-			exclude_mdt:1,
-			exclude_gid:1,
-			exclude_uid:1,
-			check_gid:1,	    /* group ID */
-			check_uid:1,	    /* user ID */
-			check_pool:1,	   /* LOV pool name */
-			check_size:1,	   /* file size */
-			exclude_pool:1,
-			exclude_size:1,
-			exclude_atime:1,
-			exclude_mtime:1,
-			exclude_ctime:1,
-			get_lmv:1,	      /* get MDT list from LMV */
-			raw:1,		  /* do not fill in defaults */
-			check_stripesize:1,     /* LOV stripe size */
-			exclude_stripesize:1,
-			check_stripecount:1,    /* LOV stripe count */
-			exclude_stripecount:1;
-
-	int     verbose;
-	int     quiet;
+	unsigned int		 maxdepth;
+	time_t			 atime;
+	time_t			 mtime;
+	time_t			 ctime;
+	/* cannot be bitfields due to using pointers to */
+	int			 asign;
+	/* access them during argument parsing. */
+	int			 csign;
+	int			 msign;
+	int			 type;
+	/* these need to be signed values */
+	int			 size_sign:2,
+				 stripesize_sign:2,
+				 stripecount_sign:2;
+	unsigned long long	 size;
+	unsigned long long	 size_units;
+	uid_t			 uid;
+	gid_t			 gid;
+
+	unsigned long		 zeroend:1,
+				 recursive:1,
+				 exclude_pattern:1,
+				 exclude_type:1,
+				 exclude_obd:1,
+				 exclude_mdt:1,
+				 exclude_gid:1,
+				 exclude_uid:1,
+				 check_gid:1,		/* group ID */
+				 check_uid:1,		/* user ID */
+				 check_pool:1,		/* LOV pool name */
+				 check_size:1,		/* file size */
+				 exclude_pool:1,
+				 exclude_size:1,
+				 exclude_atime:1,
+				 exclude_mtime:1,
+				 exclude_ctime:1,
+				 get_lmv:1,	/* get MDT list from LMV */
+				 raw:1,		/* do not fill in defaults */
+				 check_stripesize:1,	/* LOV stripe size */
+				 exclude_stripesize:1,
+				 check_stripecount:1,	/* LOV stripe count */
+				 exclude_stripecount:1,
+				 check_layout:1,
+				 exclude_layout:1;
+
+	int			 verbose;
+	int			 quiet;
 
 	/* regular expression */
-	char   *pattern;
+	char			*pattern;
 
-	char   *print_fmt;
+	char			*print_fmt;
 
-	struct  obd_uuid       *obduuid;
-	int		     num_obds;
-	int		     num_alloc_obds;
-	int		     obdindex;
-	int		    *obdindexes;
+	struct  obd_uuid	*obduuid;
+	int			 num_obds;
+	int			 num_alloc_obds;
+	int			 obdindex;
+	int			*obdindexes;
 
-	struct  obd_uuid       *mdtuuid;
-	int		     num_mdts;
-	int		     num_alloc_mdts;
-	int		     mdtindex;
-	int		    *mdtindexes;
-	int		     file_mdtindex;
+	struct  obd_uuid	*mdtuuid;
+	int			 num_mdts;
+	int			 num_alloc_mdts;
+	int			 mdtindex;
+	int			*mdtindexes;
+	int			 file_mdtindex;
 
-	int	lumlen;
-	struct  lov_user_mds_data *lmd;
+	int			 lumlen;
+	struct  lov_user_mds_data	*lmd;
 
-	char poolname[LOV_MAXPOOLNAME + 1];
+	char			poolname[LOV_MAXPOOLNAME + 1];
 
-	int			fp_lmv_count;
+	int			 fp_lmv_count;
 	struct lmv_user_md	*fp_lmv_md;
 
-	unsigned long long stripesize;
-	unsigned long long stripesize_units;
-	unsigned long long stripecount;
+	unsigned long long	 stripesize;
+	unsigned long long	 stripesize_units;
+	unsigned long long	 stripecount;
+	__u32			 layout;
 
 	/* In-process parameters. */
-	unsigned long   got_uuids:1,
-			obds_printed:1,
-			have_fileinfo:1;	/* file attrs and LOV xattr */
-	unsigned int    depth;
-	dev_t	   st_dev;
+	unsigned long		 got_uuids:1,
+				 obds_printed:1,
+				 have_fileinfo:1; /* file attrs and LOV xattr */
+	unsigned int		 depth;
+	dev_t			 st_dev;
+	__u64			 padding1;
+	__u64			 padding2;
+	__u64			 padding3;
+	__u64			 padding4;
 };
 
 extern int llapi_ostlist(char *path, struct find_param *param);
@@ -241,7 +254,10 @@ extern int llapi_fd2fid(const int fd, lustre_fid *fid);
 
 extern int llapi_get_version(char *buffer, int buffer_size, char **version);
 extern int llapi_get_data_version(int fd, __u64 *data_version, __u64 flags);
+extern int llapi_hsm_state_get_fd(int fd, struct hsm_user_state *hus);
 extern int llapi_hsm_state_get(const char *path, struct hsm_user_state *hus);
+extern int llapi_hsm_state_set_fd(int fd, __u64 setmask, __u64 clearmask,
+				  __u32 archive_id);
 extern int llapi_hsm_state_set(const char *path, __u64 setmask, __u64 clearmask,
 			       __u32 archive_id);
 
@@ -294,7 +310,7 @@ extern int llapi_hsm_copy_start(char *mnt, struct hsm_copy *copy,
 extern int llapi_hsm_copy_end(char *mnt, struct hsm_copy *copy,
 			      const struct hsm_progress *hp);
 extern int llapi_hsm_progress(char *mnt, struct hsm_progress *hp);
-extern int llapi_hsm_import(const char *dst, int archive, struct stat *st,
+extern int llapi_hsm_import(const char *dst, int archive, const struct stat *st,
 			    unsigned long long stripe_size, int stripe_offset,
 			    int stripe_count, int stripe_pattern,
 			    char *pool_name, lustre_fid *newfid);
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 94a46b5..02b297b 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -2116,6 +2116,86 @@ free:
 	return rc;
 }
 
+static int ll_hsm_state_set(struct inode *inode, struct hsm_state_set *hss)
+{
+	struct md_op_data	*op_data;
+	int			 rc;
+
+	/* Non-root users are forbidden to set or clear flags which are
+	 * NOT defined in HSM_USER_MASK. */
+	if (((hss->hss_setmask | hss->hss_clearmask) & ~HSM_USER_MASK) &&
+	    !cfs_capable(CFS_CAP_SYS_ADMIN))
+		return -EPERM;
+
+	op_data = ll_prep_md_op_data(NULL, inode, NULL, NULL, 0, 0,
+				     LUSTRE_OPC_ANY, hss);
+	if (IS_ERR(op_data))
+		return PTR_ERR(op_data);
+
+	rc = obd_iocontrol(LL_IOC_HSM_STATE_SET, ll_i2mdexp(inode),
+			   sizeof(*op_data), op_data, NULL);
+
+	ll_finish_md_op_data(op_data);
+
+	return rc;
+}
+
+static int ll_hsm_import(struct inode *inode, struct file *file,
+			 struct hsm_user_import *hui)
+{
+	struct hsm_state_set	*hss = NULL;
+	struct iattr		*attr = NULL;
+	int			 rc;
+
+
+	if (!S_ISREG(inode->i_mode))
+		return -EINVAL;
+
+	/* set HSM flags */
+	OBD_ALLOC_PTR(hss);
+	if (hss == NULL)
+		GOTO(out, rc = -ENOMEM);
+
+	hss->hss_valid = HSS_SETMASK | HSS_ARCHIVE_ID;
+	hss->hss_archive_id = hui->hui_archive_id;
+	hss->hss_setmask = HS_ARCHIVED | HS_EXISTS | HS_RELEASED;
+	rc = ll_hsm_state_set(inode, hss);
+	if (rc != 0)
+		GOTO(out, rc);
+
+	OBD_ALLOC_PTR(attr);
+	if (attr == NULL)
+		GOTO(out, rc = -ENOMEM);
+
+	attr->ia_mode = hui->hui_mode & (S_IRWXU | S_IRWXG | S_IRWXO);
+	attr->ia_mode |= S_IFREG;
+	attr->ia_uid = make_kuid(&init_user_ns, hui->hui_uid);
+	attr->ia_gid = make_kgid(&init_user_ns, hui->hui_gid);
+	attr->ia_size = hui->hui_size;
+	attr->ia_mtime.tv_sec = hui->hui_mtime;
+	attr->ia_mtime.tv_nsec = hui->hui_mtime_ns;
+	attr->ia_atime.tv_sec = hui->hui_atime;
+	attr->ia_atime.tv_nsec = hui->hui_atime_ns;
+
+	attr->ia_valid = ATTR_SIZE | ATTR_MODE | ATTR_FORCE |
+			 ATTR_UID | ATTR_GID |
+			 ATTR_MTIME | ATTR_MTIME_SET |
+			 ATTR_ATIME | ATTR_ATIME_SET;
+
+	rc = ll_setattr_raw(file->f_dentry, attr, true);
+	if (rc == -ENODATA)
+		rc = 0;
+
+out:
+	if (hss != NULL)
+		OBD_FREE_PTR(hss);
+
+	if (attr != NULL)
+		OBD_FREE_PTR(attr);
+
+	return rc;
+}
+
 long ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct inode		*inode = file->f_dentry->d_inode;
@@ -2277,37 +2357,19 @@ long ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return rc;
 	}
 	case LL_IOC_HSM_STATE_SET: {
-		struct md_op_data	*op_data;
 		struct hsm_state_set	*hss;
 		int			 rc;
 
 		OBD_ALLOC_PTR(hss);
 		if (hss == NULL)
 			return -ENOMEM;
+
 		if (copy_from_user(hss, (char *)arg, sizeof(*hss))) {
 			OBD_FREE_PTR(hss);
 			return -EFAULT;
 		}
 
-		/* Non-root users are forbidden to set or clear flags which are
-		 * NOT defined in HSM_USER_MASK. */
-		if (((hss->hss_setmask | hss->hss_clearmask) & ~HSM_USER_MASK)
-		    && !cfs_capable(CFS_CAP_SYS_ADMIN)) {
-			OBD_FREE_PTR(hss);
-			return -EPERM;
-		}
-
-		op_data = ll_prep_md_op_data(NULL, inode, NULL, NULL, 0, 0,
-					     LUSTRE_OPC_ANY, hss);
-		if (IS_ERR(op_data)) {
-			OBD_FREE_PTR(hss);
-			return PTR_ERR(op_data);
-		}
-
-		rc = obd_iocontrol(cmd, ll_i2mdexp(inode), sizeof(*op_data),
-				   op_data, NULL);
-
-		ll_finish_md_op_data(op_data);
+		rc = ll_hsm_state_set(inode, hss);
 
 		OBD_FREE_PTR(hss);
 		return rc;
@@ -2419,7 +2481,23 @@ long ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			}
 		}
 		mutex_unlock(&lli->lli_och_mutex);
+		return rc;
+	}
+	case LL_IOC_HSM_IMPORT: {
+		struct hsm_user_import *hui;
+
+		OBD_ALLOC_PTR(hui);
+		if (hui == NULL)
+			return -ENOMEM;
+
+		if (copy_from_user(hui, (void *)arg, sizeof(*hui))) {
+			OBD_FREE_PTR(hui);
+			return -EFAULT;
+		}
+
+		rc = ll_hsm_import(inode, file, hui);
 
+		OBD_FREE_PTR(hui);
 		return rc;
 	}
 	default: {
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 7f0197c..5028c3b 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -839,7 +839,7 @@ void ll_kill_super(struct super_block *sb);
 struct inode *ll_inode_from_resource_lock(struct ldlm_lock *lock);
 struct inode *ll_inode_from_lock(struct ldlm_lock *lock);
 void ll_clear_inode(struct inode *inode);
-int ll_setattr_raw(struct dentry *dentry, struct iattr *attr);
+int ll_setattr_raw(struct dentry *dentry, struct iattr *attr, bool hsm_import);
 int ll_setattr(struct dentry *de, struct iattr *attr);
 int ll_statfs(struct dentry *de, struct kstatfs *sfs);
 int ll_statfs_internal(struct super_block *sb, struct obd_statfs *osfs,
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 876083d..3b7e022 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1362,8 +1362,10 @@ static int ll_setattr_ost(struct inode *inode, struct iattr *attr)
  * to the OST with the punch RPC, otherwise we do an explicit setattr RPC.
  * I don't believe it is possible to get e.g. ATTR_MTIME_SET and ATTR_SIZE
  * at the same time.
+ *
+ * In case of HSMimport, we only set attr on MDS.
  */
-int ll_setattr_raw(struct dentry *dentry, struct iattr *attr)
+int ll_setattr_raw(struct dentry *dentry, struct iattr *attr, bool hsm_import)
 {
 	struct inode *inode = dentry->d_inode;
 	struct ll_inode_info *lli = ll_i2info(inode);
@@ -1373,9 +1375,10 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr)
 	int rc = 0, rc1 = 0;
 
 	CDEBUG(D_VFSTRACE, "%s: setattr inode %p/fid:"DFID" from %llu to %llu, "
-		"valid %x\n", ll_get_fsname(inode->i_sb, NULL, 0), inode,
+		"valid %x, hsm_import %d\n",
+		ll_get_fsname(inode->i_sb, NULL, 0), inode,
 		PFID(&lli->lli_fid), i_size_read(inode), attr->ia_size,
-		attr->ia_valid);
+		attr->ia_valid, hsm_import);
 
 	if (attr->ia_valid & ATTR_SIZE) {
 		/* Check new size against VFS/VM file size limit and rlimit */
@@ -1468,20 +1471,20 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr)
 		ccc_inode_lsm_put(inode, lsm);
 	}
 
-	/* clear size attr for released file
+	/* if not in HSM import mode, clear size attr for released file
 	 * we clear the attribute send to MDT in op_data, not the original
 	 * received from caller in attr which is used later to
 	 * decide return code */
-	if (file_is_released && (attr->ia_valid & ATTR_SIZE))
+	if (file_is_released && (attr->ia_valid & ATTR_SIZE) && !hsm_import)
 		op_data->op_attr.ia_valid &= ~ATTR_SIZE;
 
 	rc = ll_md_setattr(dentry, op_data, &mod);
 	if (rc)
 		GOTO(out, rc);
 
-	/* truncate failed, others succeed */
+	/* truncate failed (only when non HSM import), others succeed */
 	if (file_is_released) {
-		if (attr->ia_valid & ATTR_SIZE)
+		if ((attr->ia_valid & ATTR_SIZE) && !hsm_import)
 			GOTO(out, rc = -ENODATA);
 		else
 			GOTO(out, rc = 0);
@@ -1521,7 +1524,7 @@ out:
 	if (!S_ISDIR(inode->i_mode)) {
 		up_write(&lli->lli_trunc_sem);
 		mutex_lock(&inode->i_mutex);
-		if (attr->ia_valid & ATTR_SIZE)
+		if ((attr->ia_valid & ATTR_SIZE) && !hsm_import)
 			inode_dio_wait(inode);
 	}
 
@@ -1556,7 +1559,7 @@ int ll_setattr(struct dentry *de, struct iattr *attr)
 	    !(attr->ia_valid & ATTR_KILL_SGID))
 		attr->ia_valid |= ATTR_KILL_SGID;
 
-	return ll_setattr_raw(de, attr);
+	return ll_setattr_raw(de, attr, false);
 }
 
 int ll_statfs_internal(struct super_block *sb, struct obd_statfs *osfs,
diff --git a/drivers/staging/lustre/lustre/ptlrpc/wiretest.c b/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
index ca2ef59..6c31947 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
@@ -4422,6 +4422,46 @@ void lustre_assert_wire_constants(void)
 	LASSERTF((int)sizeof(((struct hsm_user_request *)0)->hur_user_item) == 0, "found %lld\n",
 		 (long long)(int)sizeof(((struct hsm_user_request *)0)->hur_user_item));
 
+	/* Checks for struct hsm_user_import */
+	LASSERTF((int)sizeof(struct hsm_user_import) == 48, "found %lld\n",
+		 (long long)(int)sizeof(struct hsm_user_import));
+	LASSERTF((int)offsetof(struct hsm_user_import, hui_size) == 0, "found %lld\n",
+		 (long long)(int)offsetof(struct hsm_user_import, hui_size));
+	LASSERTF((int)sizeof(((struct hsm_user_import *)0)->hui_size) == 8, "found %lld\n",
+		 (long long)(int)sizeof(((struct hsm_user_import *)0)->hui_size));
+	LASSERTF((int)offsetof(struct hsm_user_import, hui_uid) == 32, "found %lld\n",
+		 (long long)(int)offsetof(struct hsm_user_import, hui_uid));
+	LASSERTF((int)sizeof(((struct hsm_user_import *)0)->hui_uid) == 4, "found %lld\n",
+		 (long long)(int)sizeof(((struct hsm_user_import *)0)->hui_uid));
+	LASSERTF((int)offsetof(struct hsm_user_import, hui_gid) == 36, "found %lld\n",
+		 (long long)(int)offsetof(struct hsm_user_import, hui_gid));
+	LASSERTF((int)sizeof(((struct hsm_user_import *)0)->hui_gid) == 4, "found %lld\n",
+		 (long long)(int)sizeof(((struct hsm_user_import *)0)->hui_gid));
+	LASSERTF((int)offsetof(struct hsm_user_import, hui_mode) == 40, "found %lld\n",
+		 (long long)(int)offsetof(struct hsm_user_import, hui_mode));
+	LASSERTF((int)sizeof(((struct hsm_user_import *)0)->hui_mode) == 4, "found %lld\n",
+		 (long long)(int)sizeof(((struct hsm_user_import *)0)->hui_mode));
+	LASSERTF((int)offsetof(struct hsm_user_import, hui_atime) == 8, "found %lld\n",
+		 (long long)(int)offsetof(struct hsm_user_import, hui_atime));
+	LASSERTF((int)sizeof(((struct hsm_user_import *)0)->hui_atime) == 8, "found %lld\n",
+		 (long long)(int)sizeof(((struct hsm_user_import *)0)->hui_atime));
+	LASSERTF((int)offsetof(struct hsm_user_import, hui_atime_ns) == 24, "found %lld\n",
+		 (long long)(int)offsetof(struct hsm_user_import, hui_atime_ns));
+	LASSERTF((int)sizeof(((struct hsm_user_import *)0)->hui_atime_ns) == 4, "found %lld\n",
+		 (long long)(int)sizeof(((struct hsm_user_import *)0)->hui_atime_ns));
+	LASSERTF((int)offsetof(struct hsm_user_import, hui_mtime) == 16, "found %lld\n",
+		 (long long)(int)offsetof(struct hsm_user_import, hui_mtime));
+	LASSERTF((int)sizeof(((struct hsm_user_import *)0)->hui_mtime) == 8, "found %lld\n",
+		 (long long)(int)sizeof(((struct hsm_user_import *)0)->hui_mtime));
+	LASSERTF((int)offsetof(struct hsm_user_import, hui_mtime_ns) == 28, "found %lld\n",
+		 (long long)(int)offsetof(struct hsm_user_import, hui_mtime_ns));
+	LASSERTF((int)sizeof(((struct hsm_user_import *)0)->hui_mtime_ns) == 4, "found %lld\n",
+		 (long long)(int)sizeof(((struct hsm_user_import *)0)->hui_mtime_ns));
+	LASSERTF((int)offsetof(struct hsm_user_import, hui_archive_id) == 44, "found %lld\n",
+		 (long long)(int)offsetof(struct hsm_user_import, hui_archive_id));
+	LASSERTF((int)sizeof(((struct hsm_user_import *)0)->hui_archive_id) == 4, "found %lld\n",
+		 (long long)(int)sizeof(((struct hsm_user_import *)0)->hui_archive_id));
+
 	/* Checks for struct update_buf */
 	LASSERTF((int)sizeof(struct update_buf) == 8, "found %lld\n",
 		 (long long)(int)sizeof(struct update_buf));
-- 
1.7.9.5

