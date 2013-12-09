Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948Ab3LIPDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:03:10 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64173 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab3LIPAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:00:00 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 03/13] staging/lustre/api: HSM import uses new released pattern
Date: Mon,  9 Dec 2013 22:56:55 +0800
Message-Id: <1386601025-422-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
References: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>

Import creates a released file using new RAID pattern flag
Import used a new ioctl() to implement the import in the
client kernel.

Lustre-change: http://review.whamcloud.com/6536
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3363
Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
[Fix up kuid_t/guid_t conversion in llite/file.c -- Peng Tao]
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_user.h     |   17 ++-
 drivers/staging/lustre/lustre/llite/file.c         |  118 ++++++++++++++++----
 .../staging/lustre/lustre/llite/llite_internal.h   |    2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   24 ++--
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |   58 ++++++++++
 5 files changed, 187 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index c7abb80..6b6c0240 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -244,9 +244,9 @@ struct ost_id {
 #define LL_IOC_LMV_SETSTRIPE	    _IOWR('f', 240, struct lmv_user_md)
 #define LL_IOC_LMV_GETSTRIPE	    _IOWR('f', 241, struct lmv_user_md)
 #define LL_IOC_REMOVE_ENTRY	    _IOWR('f', 242, __u64)
-
 #define LL_IOC_SET_LEASE		_IOWR('f', 243, long)
 #define LL_IOC_GET_LEASE		_IO('f', 244)
+#define LL_IOC_HSM_IMPORT		_IOWR('f', 245, struct hsm_user_import)
 
 #define LL_STATFS_LMV	   1
 #define LL_STATFS_LOV	   2
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
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 996c19d..c12821a 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -2085,6 +2085,86 @@ free:
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
@@ -2246,37 +2326,19 @@ long ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
@@ -2389,7 +2451,23 @@ long ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
index 61bb69a..7ee5c02 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -851,7 +851,7 @@ void ll_kill_super(struct super_block *sb);
 struct inode *ll_inode_from_resource_lock(struct ldlm_lock *lock);
 struct inode *ll_inode_from_lock(struct ldlm_lock *lock);
 void ll_clear_inode(struct inode *inode);
-int ll_setattr_raw(struct dentry *dentry, struct iattr *attr);
+int ll_setattr_raw(struct dentry *dentry, struct iattr *attr, bool hsm_import);
 int ll_setattr(struct dentry *de, struct iattr *attr);
 int ll_statfs(struct dentry *de, struct kstatfs *sfs);
 int ll_statfs_internal(struct super_block *sb, struct obd_statfs *osfs,
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 1a96786..6cfdb9e 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1364,8 +1364,10 @@ static int ll_setattr_ost(struct inode *inode, struct iattr *attr)
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
@@ -1374,10 +1376,12 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr)
 	bool file_is_released = false;
 	int rc = 0, rc1 = 0;
 
-	CDEBUG(D_VFSTRACE, "%s: setattr inode %p/fid:"DFID" from %llu to %llu, "
-		"valid %x\n", ll_get_fsname(inode->i_sb, NULL, 0), inode,
+	CDEBUG(D_VFSTRACE,
+		"%s: setattr inode %p/fid:"DFID
+		" from %llu to %llu, valid %x, hsm_import %d\n",
+		ll_get_fsname(inode->i_sb, NULL, 0), inode,
 		PFID(&lli->lli_fid), i_size_read(inode), attr->ia_size,
-		attr->ia_valid);
+		attr->ia_valid, hsm_import);
 
 	if (attr->ia_valid & ATTR_SIZE) {
 		/* Check new size against VFS/VM file size limit and rlimit */
@@ -1470,20 +1474,20 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr)
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
@@ -1522,7 +1526,7 @@ out:
 	if (!S_ISDIR(inode->i_mode)) {
 		up_write(&lli->lli_trunc_sem);
 		mutex_lock(&inode->i_mutex);
-		if (attr->ia_valid & ATTR_SIZE)
+		if ((attr->ia_valid & ATTR_SIZE) && !hsm_import)
 			inode_dio_wait(inode);
 	}
 
@@ -1557,7 +1561,7 @@ int ll_setattr(struct dentry *de, struct iattr *attr)
 	    !(attr->ia_valid & ATTR_KILL_SGID))
 		attr->ia_valid |= ATTR_KILL_SGID;
 
-	return ll_setattr_raw(de, attr);
+	return ll_setattr_raw(de, attr, false);
 }
 
 int ll_statfs_internal(struct super_block *sb, struct obd_statfs *osfs,
diff --git a/drivers/staging/lustre/lustre/ptlrpc/wiretest.c b/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
index c2efd11..3aa4459 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
@@ -4422,6 +4422,64 @@ void lustre_assert_wire_constants(void)
 	LASSERTF((int)sizeof(((struct hsm_user_request *)0)->hur_user_item) == 0, "found %lld\n",
 		 (long long)(int)sizeof(((struct hsm_user_request *)0)->hur_user_item));
 
+	/* Checks for struct hsm_user_import */
+	LASSERTF(sizeof(struct hsm_user_import) == 48, "found %lld\n",
+		 (long long)sizeof(struct hsm_user_import));
+	LASSERTF(offsetof(struct hsm_user_import, hui_size) == 0,
+		 "found %lld\n",
+		 (long long)offsetof(struct hsm_user_import, hui_size));
+	LASSERTF(sizeof(((struct hsm_user_import *)0)->hui_size) == 8,
+		 "found %lld\n",
+		 (long long)sizeof(((struct hsm_user_import *)0)->hui_size));
+	LASSERTF(offsetof(struct hsm_user_import, hui_uid) == 32,
+		 "found %lld\n",
+		 (long long)offsetof(struct hsm_user_import, hui_uid));
+	LASSERTF(sizeof(((struct hsm_user_import *)0)->hui_uid) == 4,
+		 "found %lld\n",
+		 (long long)sizeof(((struct hsm_user_import *)0)->hui_uid));
+	LASSERTF(offsetof(struct hsm_user_import, hui_gid) == 36,
+		 "found %lld\n",
+		 (long long)offsetof(struct hsm_user_import, hui_gid));
+	LASSERTF(sizeof(((struct hsm_user_import *)0)->hui_gid) == 4,
+		 "found %lld\n",
+		 (long long)sizeof(((struct hsm_user_import *)0)->hui_gid));
+	LASSERTF(offsetof(struct hsm_user_import, hui_mode) == 40,
+		 "found %lld\n",
+		 (long long)offsetof(struct hsm_user_import, hui_mode));
+	LASSERTF(sizeof(((struct hsm_user_import *)0)->hui_mode) == 4,
+		 "found %lld\n",
+		 (long long)sizeof(((struct hsm_user_import *)0)->hui_mode));
+	LASSERTF(offsetof(struct hsm_user_import, hui_atime) == 8,
+		 "found %lld\n",
+		 (long long)offsetof(struct hsm_user_import, hui_atime));
+	LASSERTF(sizeof(((struct hsm_user_import *)0)->hui_atime) == 8,
+		 "found %lld\n",
+		 (long long)sizeof(((struct hsm_user_import *)0)->hui_atime));
+	LASSERTF(offsetof(struct hsm_user_import, hui_atime_ns) == 24,
+		 "found %lld\n",
+		(long long)(int)offsetof(struct hsm_user_import, hui_atime_ns));
+	LASSERTF(sizeof(((struct hsm_user_import *)0)->hui_atime_ns) == 4,
+		 "found %lld\n",
+		(long long)sizeof(((struct hsm_user_import *)0)->hui_atime_ns));
+	LASSERTF(offsetof(struct hsm_user_import, hui_mtime) == 16,
+		 "found %lld\n",
+		 (long long)offsetof(struct hsm_user_import, hui_mtime));
+	LASSERTF(sizeof(((struct hsm_user_import *)0)->hui_mtime) == 8,
+		 "found %lld\n",
+		 (long long)sizeof(((struct hsm_user_import *)0)->hui_mtime));
+	LASSERTF(offsetof(struct hsm_user_import, hui_mtime_ns) == 28,
+		 "found %lld\n",
+		(long long)offsetof(struct hsm_user_import, hui_mtime_ns));
+	LASSERTF(sizeof(((struct hsm_user_import *)0)->hui_mtime_ns) == 4,
+		 "found %lld\n",
+		(long long)sizeof(((struct hsm_user_import *)0)->hui_mtime_ns));
+	LASSERTF(offsetof(struct hsm_user_import, hui_archive_id) == 44,
+		 "found %lld\n",
+		 (long long)offsetof(struct hsm_user_import, hui_archive_id));
+	LASSERTF(sizeof(((struct hsm_user_import *)0)->hui_archive_id) == 4,
+		 "found %lld\n",
+	      (long long)sizeof(((struct hsm_user_import *)0)->hui_archive_id));
+
 	/* Checks for struct update_buf */
 	LASSERTF((int)sizeof(struct update_buf) == 8, "found %lld\n",
 		 (long long)(int)sizeof(struct update_buf));
-- 
1.7.9.5

