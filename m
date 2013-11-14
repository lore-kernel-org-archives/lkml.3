Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab3KNQsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:48:39 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:44401 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220Ab3KNQo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:44:28 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jinshan Xiong <jinshan.xiong@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 15/26] staging/lustre/llite: Truncate to restore file
Date: Fri, 15 Nov 2013 00:43:02 +0800
Message-Id: <1384447393-13838-16-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jinshan Xiong <jinshan.xiong@intel.com>

Truncate up is safe so it won't trigger restore.

Copy optimization for truncate down - only copy the part under
truncate length. If a file is truncated to zero usually it'll be
followed by write so I choose to restore the file and set correct
stripe information.

Lustre-change: http://review.whamcloud.com/7505
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3817
Signed-off-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: jacques-Charles Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Henri Doreau <henri.doreau@cea.fr>
Reviewed-by: Aurelien Degremont <aurelien.degremont@cea.fr>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c         |    5 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |    2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   57 ++++++++++----------
 drivers/staging/lustre/lustre/llite/vvp_io.c       |    5 +-
 4 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 60b3197..7d2c363 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -3661,7 +3661,7 @@ again:
 /**
  *  This function send a restore request to the MDT
  */
-int ll_layout_restore(struct inode *inode)
+int ll_layout_restore(struct inode *inode, loff_t offset, __u64 length)
 {
 	struct hsm_user_request	*hur;
 	int			 len, rc;
@@ -3677,7 +3677,8 @@ int ll_layout_restore(struct inode *inode)
 	hur->hur_request.hr_flags = 0;
 	memcpy(&hur->hur_user_item[0].hui_fid, &ll_i2info(inode)->lli_fid,
 	       sizeof(hur->hur_user_item[0].hui_fid));
-	hur->hur_user_item[0].hui_extent.length = -1;
+	hur->hur_user_item[0].hui_extent.offset = offset;
+	hur->hur_user_item[0].hui_extent.length = length;
 	hur->hur_request.hr_itemcount = 1;
 	rc = obd_iocontrol(LL_IOC_HSM_REQUEST, cl_i2sbi(inode)->ll_md_exp,
 			   len, hur, NULL);
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 942601b..2a8fc10 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -1615,7 +1615,7 @@ enum {
 
 int ll_layout_conf(struct inode *inode, const struct cl_object_conf *conf);
 int ll_layout_refresh(struct inode *inode, __u32 *gen);
-int ll_layout_restore(struct inode *inode);
+int ll_layout_restore(struct inode *inode, loff_t start, __u64 length);
 
 int ll_xattr_init(void);
 void ll_xattr_fini(void);
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index a6e95bc..b616b87 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1423,14 +1423,6 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr, bool hsm_import)
 		       LTIME_S(attr->ia_mtime), LTIME_S(attr->ia_ctime),
 		       cfs_time_current_sec());
 
-	/* If we are changing file size, file content is modified, flag it. */
-	if (attr->ia_valid & ATTR_SIZE) {
-		attr->ia_valid |= MDS_OPEN_OWNEROVERRIDE;
-		spin_lock(&lli->lli_lock);
-		lli->lli_flags |= LLIF_DATA_MODIFIED;
-		spin_unlock(&lli->lli_lock);
-	}
-
 	/* We always do an MDS RPC, even if we're only changing the size;
 	 * only the MDS knows whether truncate() should fail with -ETXTBUSY */
 
@@ -1445,13 +1437,6 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr, bool hsm_import)
 		down_write(&lli->lli_trunc_sem);
 	}
 
-	memcpy(&op_data->op_attr, attr, sizeof(*attr));
-
-	/* Open epoch for truncate. */
-	if (exp_connect_som(ll_i2mdexp(inode)) &&
-	    (attr->ia_valid & (ATTR_SIZE | ATTR_MTIME | ATTR_MTIME_SET)))
-		op_data->op_flags = MF_EPOCH_OPEN;
-
 	/* truncate on a released file must failed with -ENODATA,
 	 * so size must not be set on MDS for released file
 	 * but other attributes must be set
@@ -1465,27 +1450,38 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr, bool hsm_import)
 		if (lsm && lsm->lsm_pattern & LOV_PATTERN_F_RELEASED)
 			file_is_released = true;
 		ccc_inode_lsm_put(inode, lsm);
+
+		if (!hsm_import && attr->ia_valid & ATTR_SIZE) {
+			if (file_is_released) {
+				rc = ll_layout_restore(inode, 0, attr->ia_size);
+				if (rc < 0)
+					GOTO(out, rc);
+
+				file_is_released = false;
+				ll_layout_refresh(inode, &gen);
+			}
+
+			/* If we are changing file size, file content is
+			 * modified, flag it. */
+			attr->ia_valid |= MDS_OPEN_OWNEROVERRIDE;
+			spin_lock(&lli->lli_lock);
+			lli->lli_flags |= LLIF_DATA_MODIFIED;
+			spin_unlock(&lli->lli_lock);
+			op_data->op_bias |= MDS_DATA_MODIFIED;
+		}
 	}
 
-	/* if not in HSM import mode, clear size attr for released file
-	 * we clear the attribute send to MDT in op_data, not the original
-	 * received from caller in attr which is used later to
-	 * decide return code */
-	if (file_is_released && (attr->ia_valid & ATTR_SIZE) && !hsm_import)
-		op_data->op_attr.ia_valid &= ~ATTR_SIZE;
+	memcpy(&op_data->op_attr, attr, sizeof(*attr));
+
+	/* Open epoch for truncate. */
+	if (exp_connect_som(ll_i2mdexp(inode)) && !hsm_import &&
+	    (attr->ia_valid & (ATTR_SIZE | ATTR_MTIME | ATTR_MTIME_SET)))
+		op_data->op_flags = MF_EPOCH_OPEN;
 
 	rc = ll_md_setattr(dentry, op_data, &mod);
 	if (rc)
 		GOTO(out, rc);
 
-	/* truncate failed (only when non HSM import), others succeed */
-	if (file_is_released) {
-		if ((attr->ia_valid & ATTR_SIZE) && !hsm_import)
-			GOTO(out, rc = -ENODATA);
-		else
-			GOTO(out, rc = 0);
-	}
-
 	/* RPC to MDT is sent, cancel data modification flag */
 	if (rc == 0 && (op_data->op_bias & MDS_DATA_MODIFIED)) {
 		spin_lock(&lli->lli_lock);
@@ -1494,7 +1490,7 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr, bool hsm_import)
 	}
 
 	ll_ioepoch_open(lli, op_data->op_ioepoch);
-	if (!S_ISREG(inode->i_mode))
+	if (!S_ISREG(inode->i_mode) || file_is_released)
 		GOTO(out, rc = 0);
 
 	if (attr->ia_valid & (ATTR_SIZE |
@@ -1508,6 +1504,7 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr, bool hsm_import)
 		 * time de-synchronization between MDT inode and OST objects */
 		rc = ll_setattr_ost(inode, attr);
 	}
+
 out:
 	if (op_data) {
 		if (op_data->op_ioepoch) {
diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index 7053cc8..ca08e4f 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -118,6 +118,7 @@ static void vvp_io_fini(const struct lu_env *env, const struct cl_io_slice *ios)
 	struct cl_io     *io  = ios->cis_io;
 	struct cl_object *obj = io->ci_obj;
 	struct ccc_io    *cio = cl2ccc_io(env, ios);
+	struct inode     *inode = ccc_object_inode(obj);
 
 	CLOBINVRNT(env, obj, ccc_object_invariant(obj));
 
@@ -133,7 +134,7 @@ static void vvp_io_fini(const struct lu_env *env, const struct cl_io_slice *ios)
 		/* file was detected release, we need to restore it
 		 * before finishing the io
 		 */
-		rc = ll_layout_restore(ccc_object_inode(obj));
+		rc = ll_layout_restore(inode, 0, OBD_OBJECT_EOF);
 		/* if restore registration failed, no restart,
 		 * we will return -ENODATA */
 		/* The layout will change after restore, so we need to
@@ -158,7 +159,7 @@ static void vvp_io_fini(const struct lu_env *env, const struct cl_io_slice *ios)
 		__u32 gen = 0;
 
 		/* check layout version */
-		ll_layout_refresh(ccc_object_inode(obj), &gen);
+		ll_layout_refresh(inode, &gen);
 		io->ci_need_restart = cio->cui_layout_gen != gen;
 		if (io->ci_need_restart) {
 			CDEBUG(D_VFSTRACE,
-- 
1.7.9.5

