Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaCACRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:17:19 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42566 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbaCACRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:10 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: "John L. Hammond" <john.hammond@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 01/17] staging/lustre/llite: fix open lock matching in ll_md_blocking_ast()
Date: Fri, 28 Feb 2014 21:16:30 -0500
Message-Id: <1393640206-20286-2-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

In ll_md_blocking_ast() match open locks before all others, ensuring
that MDS_INODELOCK_OPEN is not cleared from bits by another open lock
with a different mode. Change the int flags parameter of
ll_md_real_close() to fmode_t fmode. Clean up verious style issues in
both functions.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-on: http://review.whamcloud.com/8718
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4429
Reviewed-by: Niu Yawei <yawei.niu@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c         | 19 +++---
 .../staging/lustre/lustre/llite/llite_internal.h   |  2 +-
 drivers/staging/lustre/lustre/llite/namei.c        | 78 ++++++++++++----------
 3 files changed, 54 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 4c28f39..c9ee574 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -205,7 +205,7 @@ out:
 	return rc;
 }
 
-int ll_md_real_close(struct inode *inode, int flags)
+int ll_md_real_close(struct inode *inode, fmode_t fmode)
 {
 	struct ll_inode_info *lli = ll_i2info(inode);
 	struct obd_client_handle **och_p;
@@ -213,30 +213,33 @@ int ll_md_real_close(struct inode *inode, int flags)
 	__u64 *och_usecount;
 	int rc = 0;
 
-	if (flags & FMODE_WRITE) {
+	if (fmode & FMODE_WRITE) {
 		och_p = &lli->lli_mds_write_och;
 		och_usecount = &lli->lli_open_fd_write_count;
-	} else if (flags & FMODE_EXEC) {
+	} else if (fmode & FMODE_EXEC) {
 		och_p = &lli->lli_mds_exec_och;
 		och_usecount = &lli->lli_open_fd_exec_count;
 	} else {
-		LASSERT(flags & FMODE_READ);
+		LASSERT(fmode & FMODE_READ);
 		och_p = &lli->lli_mds_read_och;
 		och_usecount = &lli->lli_open_fd_read_count;
 	}
 
 	mutex_lock(&lli->lli_och_mutex);
-	if (*och_usecount) { /* There are still users of this handle, so
-				skip freeing it. */
+	if (*och_usecount > 0) {
+		/* There are still users of this handle, so skip
+		 * freeing it. */
 		mutex_unlock(&lli->lli_och_mutex);
 		return 0;
 	}
+
 	och=*och_p;
 	*och_p = NULL;
 	mutex_unlock(&lli->lli_och_mutex);
 
-	if (och) { /* There might be a race and somebody have freed this och
-		      already */
+	if (och != NULL) {
+		/* There might be a race and this handle may already
+		   be closed. */
 		rc = ll_close_inode_openhandle(ll_i2sbi(inode)->ll_md_exp,
 					       inode, och, NULL);
 	}
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index e27efd1..47c5142 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -775,7 +775,7 @@ int ll_local_open(struct file *file,
 int ll_release_openhandle(struct dentry *, struct lookup_intent *);
 int ll_md_close(struct obd_export *md_exp, struct inode *inode,
 		struct file *file);
-int ll_md_real_close(struct inode *inode, int flags);
+int ll_md_real_close(struct inode *inode, fmode_t fmode);
 void ll_ioepoch_close(struct inode *inode, struct md_op_data *op_data,
 		      struct obd_client_handle **och, unsigned long flags);
 void ll_done_writing_attr(struct inode *inode, struct md_op_data *op_data);
diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index 93c3744..86ff708 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -195,101 +195,107 @@ static void ll_invalidate_negative_children(struct inode *dir)
 int ll_md_blocking_ast(struct ldlm_lock *lock, struct ldlm_lock_desc *desc,
 		       void *data, int flag)
 {
-	int rc;
 	struct lustre_handle lockh;
+	int rc;
 
 	switch (flag) {
 	case LDLM_CB_BLOCKING:
 		ldlm_lock2handle(lock, &lockh);
 		rc = ldlm_cli_cancel(&lockh, LCF_ASYNC);
 		if (rc < 0) {
-			CDEBUG(D_INODE, "ldlm_cli_cancel: %d\n", rc);
+			CDEBUG(D_INODE, "ldlm_cli_cancel: rc = %d\n", rc);
 			return rc;
 		}
 		break;
 	case LDLM_CB_CANCELING: {
 		struct inode *inode = ll_inode_from_resource_lock(lock);
-		struct ll_inode_info *lli;
 		__u64 bits = lock->l_policy_data.l_inodebits.bits;
-		struct lu_fid *fid;
-		ldlm_mode_t mode = lock->l_req_mode;
 
 		/* Inode is set to lock->l_resource->lr_lvb_inode
 		 * for mdc - bug 24555 */
 		LASSERT(lock->l_ast_data == NULL);
 
-		/* Invalidate all dentries associated with this inode */
 		if (inode == NULL)
 			break;
 
+		/* Invalidate all dentries associated with this inode */
 		LASSERT(lock->l_flags & LDLM_FL_CANCELING);
 
-		if (bits & MDS_INODELOCK_XATTR)
+		if (!fid_res_name_eq(ll_inode2fid(inode),
+				     &lock->l_resource->lr_name)) {
+			LDLM_ERROR(lock, "data mismatch with object "DFID"(%p)",
+				   PFID(ll_inode2fid(inode)), inode);
+			LBUG();
+		}
+
+		if (bits & MDS_INODELOCK_XATTR) {
 			ll_xattr_cache_destroy(inode);
+			bits &= ~MDS_INODELOCK_XATTR;
+		}
 
 		/* For OPEN locks we differentiate between lock modes
 		 * LCK_CR, LCK_CW, LCK_PR - bug 22891 */
-		if (bits & (MDS_INODELOCK_LOOKUP | MDS_INODELOCK_UPDATE |
-			    MDS_INODELOCK_LAYOUT | MDS_INODELOCK_PERM))
-			ll_have_md_lock(inode, &bits, LCK_MINMODE);
-
 		if (bits & MDS_INODELOCK_OPEN)
-			ll_have_md_lock(inode, &bits, mode);
-
-		fid = ll_inode2fid(inode);
-		if (!fid_res_name_eq(fid, &lock->l_resource->lr_name))
-			LDLM_ERROR(lock, "data mismatch with object "
-				   DFID" (%p)", PFID(fid), inode);
+			ll_have_md_lock(inode, &bits, lock->l_req_mode);
 
 		if (bits & MDS_INODELOCK_OPEN) {
-			int flags = 0;
+			fmode_t fmode;
+
 			switch (lock->l_req_mode) {
 			case LCK_CW:
-				flags = FMODE_WRITE;
+				fmode = FMODE_WRITE;
 				break;
 			case LCK_PR:
-				flags = FMODE_EXEC;
+				fmode = FMODE_EXEC;
 				break;
 			case LCK_CR:
-				flags = FMODE_READ;
+				fmode = FMODE_READ;
 				break;
 			default:
-				CERROR("Unexpected lock mode for OPEN lock "
-				       "%d, inode %ld\n", lock->l_req_mode,
-				       inode->i_ino);
+				LDLM_ERROR(lock, "bad lock mode for OPEN lock");
+				LBUG();
 			}
-			ll_md_real_close(inode, flags);
+
+			ll_md_real_close(inode, fmode);
 		}
 
-		lli = ll_i2info(inode);
+		if (bits & (MDS_INODELOCK_LOOKUP | MDS_INODELOCK_UPDATE |
+			    MDS_INODELOCK_LAYOUT | MDS_INODELOCK_PERM))
+			ll_have_md_lock(inode, &bits, LCK_MINMODE);
+
 		if (bits & MDS_INODELOCK_LAYOUT) {
-			struct cl_object_conf conf = { { 0 } };
+			struct cl_object_conf conf = {
+				.coc_opc = OBJECT_CONF_INVALIDATE,
+				.coc_inode = inode,
+			};
 
-			conf.coc_opc = OBJECT_CONF_INVALIDATE;
-			conf.coc_inode = inode;
 			rc = ll_layout_conf(inode, &conf);
-			if (rc)
-				CDEBUG(D_INODE, "invaliding layout %d.\n", rc);
+			if (rc < 0)
+				CDEBUG(D_INODE, "cannot invalidate layout of "
+				       DFID": rc = %d\n",
+				       PFID(ll_inode2fid(inode)), rc);
 		}
 
 		if (bits & MDS_INODELOCK_UPDATE) {
+			struct ll_inode_info *lli = ll_i2info(inode);
+
 			spin_lock(&lli->lli_lock);
 			lli->lli_flags &= ~LLIF_MDS_SIZE_LOCK;
 			spin_unlock(&lli->lli_lock);
 		}
 
-		if (S_ISDIR(inode->i_mode) &&
-		     (bits & MDS_INODELOCK_UPDATE)) {
+		if ((bits & MDS_INODELOCK_UPDATE) && S_ISDIR(inode->i_mode)) {
 			CDEBUG(D_INODE, "invalidating inode %lu\n",
 			       inode->i_ino);
 			truncate_inode_pages(inode->i_mapping, 0);
 			ll_invalidate_negative_children(inode);
 		}
 
-		if (inode->i_sb->s_root &&
-		    inode != inode->i_sb->s_root->d_inode &&
-		    (bits & (MDS_INODELOCK_LOOKUP | MDS_INODELOCK_PERM)))
+		if ((bits & (MDS_INODELOCK_LOOKUP | MDS_INODELOCK_PERM)) &&
+		    inode->i_sb->s_root != NULL &&
+		    inode != inode->i_sb->s_root->d_inode)
 			ll_invalidate_aliases(inode);
+
 		iput(inode);
 		break;
 	}
-- 
1.8.5.3

