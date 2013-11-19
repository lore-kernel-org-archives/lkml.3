Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3KSN0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:26:25 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41474 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3KSN0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:26:21 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jinshan Xiong <jinshan.xiong@intel.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 2/9] staging/lustre/hsm: Implementation of exclusive open
Date: Tue, 19 Nov 2013 21:23:41 +0800
Message-Id: <1384867428-8395-3-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
References: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jinshan Xiong <jinshan.xiong@intel.com>

Proposed way to do exclusive open:

0. First of all, we have to perform most of the work in kernel space;

1. Client exclusively opens the file with IT_RELEASE_OPEN.
1.1 exclusive open means the open will fail if the file is being opened by somebody else;

2. the MDT will handle IT_RELEASE as follows:
2.1 Revoke OPEN_LOCK on this file, just request EX mode of MDS_INODELOCK_OPEN lock and
release it;
2.2 Acquire a rwsem, say open_rwsem, with write mode before trying to the file; for the
normal open, it should acquire read mode of open_rwsem;
2.3 Check if the file is already being opened by others, if not return with -EBUSY;
2.4 Check if the file can be released;
2.5 Set a special flag in struct mdt_file_data to mark this open is exclusive;
2.5 Release open rwsem.

>From now on, if the file is opened by others, it will mark mdt_file_data that the
exclusive open is broken.

3. Client: if IT_RELEASE_OPEN is finished successfully, and do followings:
3.1 Acquire full PW or EX extent lock to flush dirty cache;
3.2 Pack the handle of layout lock, data version and other attars;
3.3 Close the file with IT_RELEASE_CLOSE.

4. Back to MDT to handle IT_RELEASE CLOSE:
4.1 Grab the open_rwsem
4.2 Check if the exclusive open has ever been broken, in that case, the RELEASE process
will fail;
4.3 Verify the data version matches archive;
4.4 Grab EX layout lock
4.5 Swap the layout
4.6 Release EX layout lock
4.7 Close the exclusive open

Basically we avoid granting EX layout lock back to client and introduce exclusive open so
that we know it if the file has ever being accessed. I hope this can simplify things
a little bit. Also, exclusive open can be used to implement file lease.

In this patch, a framework of lease is implemented. However,
only exclusive lease is supported right now.

To apply a lease, MDS_OPEN_LEASE must be set to open the file, EX
mode open lock is returned to the client side to hold a lease. From
that time on, if this file is opened again by other processes, the
open lock will be revoked so the client who holds the lease will
know the lease is already broken by checking that open lock.

To release a lease, normal close is used. The client will revoke the
open lock before sending CLOSE request.

Lease can be applied in two ways. ll_lease_open()/close() can be
called directly if the lease holder is in kernel space; or if the
lease holder lives in user space, it has to open the file first and
then use ioctl() with command LL_IOC_SET_LEASE to apply a lease. The
lease holder has to poll the lease status itself.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2919
Lustre-change: http://review.whamcloud.com/6730
Signed-off-by: Jinshan Xiong <jinshan.xiong@intel.com>
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/linux/lustre_intent.h    |    2 +-
 .../lustre/lustre/include/lustre/lustre_idl.h      |    5 +
 .../lustre/lustre/include/lustre/lustre_user.h     |    3 +
 .../lustre/lustre/include/lustre_dlm_flags.h       |   12 +-
 drivers/staging/lustre/lustre/include/lustre_lib.h |   11 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |    5 +
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |    4 +-
 drivers/staging/lustre/lustre/llite/file.c         |  297 +++++++++++++++++++-
 .../staging/lustre/lustre/llite/llite_internal.h   |   11 +-
 drivers/staging/lustre/lustre/mdc/mdc_internal.h   |    2 +-
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |    7 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |   40 ++-
 12 files changed, 370 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_intent.h b/drivers/staging/lustre/lustre/include/linux/lustre_intent.h
index b10ddfa..c491d52 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_intent.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_intent.h
@@ -52,8 +52,8 @@ struct lustre_intent_data {
 
 struct lookup_intent {
 	int     it_op;
-	int     it_flags;
 	int     it_create_mode;
+	__u64   it_flags;
 	union {
 		struct lustre_intent_data lustre;
 	} d;
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 7d60896..4d8d8c3 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -2117,6 +2117,7 @@ extern void lustre_swab_generic_32s (__u32 *val);
 #define DISP_ENQ_OPEN_REF    0x00800000
 #define DISP_ENQ_CREATE_REF  0x01000000
 #define DISP_OPEN_LOCK       0x02000000
+#define DISP_OPEN_LEASE      0x04000000
 
 /* INODE LOCK PARTS */
 #define MDS_INODELOCK_LOOKUP 0x000001       /* dentry, mode, owner, group */
@@ -2377,6 +2378,10 @@ extern void lustre_swab_mdt_rec_setattr (struct mdt_rec_setattr *sa);
 					      * hsm restore) */
 #define MDS_OPEN_VOLATILE   0400000000000ULL /* File is volatile = created
 						unlinked */
+#define MDS_OPEN_LEASE	   01000000000000ULL /* Open the file and grant lease
+					      * delegation, succeed if it's not
+					      * being opened with conflict mode.
+					      */
 
 /* permission for create non-directory file */
 #define MAY_CREATE      (1 << 7)
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index c7bd447..9fd1d3b 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -245,6 +245,9 @@ struct ost_id {
 #define LL_IOC_LMV_GETSTRIPE	    _IOWR('f', 241, struct lmv_user_md)
 #define LL_IOC_REMOVE_ENTRY	    _IOWR('f', 242, __u64)
 
+#define LL_IOC_SET_LEASE		_IOWR('f', 243, long)
+#define LL_IOC_GET_LEASE		_IO('f', 244)
+
 #define LL_STATFS_LMV	   1
 #define LL_STATFS_LOV	   2
 #define LL_STATFS_NODELAY	4
diff --git a/drivers/staging/lustre/lustre/include/lustre_dlm_flags.h b/drivers/staging/lustre/lustre/include/lustre_dlm_flags.h
index 8c34d9d..f8b4ba7 100644
--- a/drivers/staging/lustre/lustre/include/lustre_dlm_flags.h
+++ b/drivers/staging/lustre/lustre/include/lustre_dlm_flags.h
@@ -35,7 +35,7 @@
 #ifndef LDLM_ALL_FLAGS_MASK
 
 /** l_flags bits marked as "all_flags" bits */
-#define LDLM_FL_ALL_FLAGS_MASK          0x007FFFFFC08F132FULL
+#define LDLM_FL_ALL_FLAGS_MASK          0x00FFFFFFC08F132FULL
 
 /** l_flags bits marked as "ast" bits */
 #define LDLM_FL_AST_MASK                0x0000000080000000ULL
@@ -53,7 +53,7 @@
 #define LDLM_FL_INHERIT_MASK            0x0000000000800000ULL
 
 /** l_flags bits marked as "local_only" bits */
-#define LDLM_FL_LOCAL_ONLY_MASK         0x007FFFFF00000000ULL
+#define LDLM_FL_LOCAL_ONLY_MASK         0x00FFFFFF00000000ULL
 
 /** l_flags bits marked as "on_wire" bits */
 #define LDLM_FL_ON_WIRE_MASK            0x00000000C08F132FULL
@@ -358,6 +358,12 @@
 #define ldlm_set_ns_srv(_l)             LDLM_SET_FLAG((  _l), 1ULL << 54)
 #define ldlm_clear_ns_srv(_l)           LDLM_CLEAR_FLAG((_l), 1ULL << 54)
 
+/** Flag whether this lock can be reused. Used by exclusive open. */
+#define LDLM_FL_EXCL                    0x0080000000000000ULL /* bit  55 */
+#define ldlm_is_excl(_l)                LDLM_TEST_FLAG((_l), 1ULL << 55)
+#define ldlm_set_excl(_l)               LDLM_SET_FLAG((_l), 1ULL << 55)
+#define ldlm_clear_excl(_l)             LDLM_CLEAR_FLAG((_l), 1ULL << 55)
+
 /** test for ldlm_lock flag bit set */
 #define LDLM_TEST_FLAG(_l, _b)        (((_l)->l_flags & (_b)) != 0)
 
@@ -414,6 +420,7 @@ static int hf_lustre_ldlm_fl_server_lock         = -1;
 static int hf_lustre_ldlm_fl_res_locked          = -1;
 static int hf_lustre_ldlm_fl_waited              = -1;
 static int hf_lustre_ldlm_fl_ns_srv              = -1;
+static int hf_lustre_ldlm_fl_excl                = -1;
 
 const value_string lustre_ldlm_flags_vals[] = {
   {LDLM_FL_LOCK_CHANGED,        "LDLM_FL_LOCK_CHANGED"},
@@ -454,6 +461,7 @@ const value_string lustre_ldlm_flags_vals[] = {
   {LDLM_FL_RES_LOCKED,          "LDLM_FL_RES_LOCKED"},
   {LDLM_FL_WAITED,              "LDLM_FL_WAITED"},
   {LDLM_FL_NS_SRV,              "LDLM_FL_NS_SRV"},
+  {LDLM_FL_EXCL,                "LDLM_FL_EXCL"},
   { 0, NULL }
 };
 #endif /*  WIRESHARK_COMPILE */
diff --git a/drivers/staging/lustre/lustre/include/lustre_lib.h b/drivers/staging/lustre/lustre/include/lustre_lib.h
index b6fd03e..609a090 100644
--- a/drivers/staging/lustre/lustre/include/lustre_lib.h
+++ b/drivers/staging/lustre/lustre/include/lustre_lib.h
@@ -81,11 +81,12 @@ struct client_obd *client_conn2cli(struct lustre_handle *conn);
 
 struct md_open_data;
 struct obd_client_handle {
-	struct lustre_handle  och_fh;
-	struct lu_fid	 och_fid;
-	struct md_open_data  *och_mod;
-	__u32 och_magic;
-	fmode_t och_flags;
+	struct lustre_handle	 och_fh;
+	struct lu_fid		 och_fid;
+	struct md_open_data	*och_mod;
+	struct lustre_handle	 och_lease_handle; /* open lock for lease */
+	__u32			 och_magic;
+	fmode_t			 och_flags;
 };
 #define OBD_CLIENT_HANDLE_MAGIC 0xd15ea5ed
 
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index 3900a69..ef826e9 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -1129,6 +1129,11 @@ static struct ldlm_lock *search_queue(struct list_head *queue,
 		if (lock == old_lock)
 			break;
 
+		/* Check if this lock can be matched.
+		 * Used by LU-2919(exclusive open) for open lease lock */
+		if (ldlm_is_excl(lock))
+			continue;
+
 		/* llite sometimes wants to match locks that will be
 		 * canceled when their users drop, but we allow it to match
 		 * if it passes in CBPENDING and the lock still has users.
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
index dcc2784..1e2c0dd 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
@@ -910,7 +910,7 @@ int ldlm_cli_enqueue(struct obd_export *exp, struct ptlrpc_request **reqp,
 	lock->l_conn_export = exp;
 	lock->l_export = NULL;
 	lock->l_blocking_ast = einfo->ei_cb_bl;
-	lock->l_flags |= (*flags & LDLM_FL_NO_LRU);
+	lock->l_flags |= (*flags & (LDLM_FL_NO_LRU | LDLM_FL_EXCL));
 
 	/* lock not sent to server yet */
 
@@ -1333,7 +1333,7 @@ int ldlm_cli_cancel(struct lustre_handle *lockh,
 	}
 
 	rc = ldlm_cli_cancel_local(lock);
-	if (rc == LDLM_FL_LOCAL_ONLY) {
+	if (rc == LDLM_FL_LOCAL_ONLY || cancel_flags & LCF_LOCAL) {
 		LDLM_LOCK_RELEASE(lock);
 		return 0;
 	}
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 22f2e73..82248e9 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -241,6 +241,24 @@ int ll_md_close(struct obd_export *md_exp, struct inode *inode,
 	if (unlikely(fd->fd_flags & LL_FILE_GROUP_LOCKED))
 		ll_put_grouplock(inode, file, fd->fd_grouplock.cg_gid);
 
+	if (fd->fd_lease_och != NULL) {
+		bool lease_broken;
+
+		/* Usually the lease is not released when the
+		 * application crashed, we need to release here. */
+		rc = ll_lease_close(fd->fd_lease_och, inode, &lease_broken);
+		CDEBUG(rc ? D_ERROR : D_INODE, "Clean up lease "DFID" %d/%d\n",
+			PFID(&lli->lli_fid), rc, lease_broken);
+
+		fd->fd_lease_och = NULL;
+	}
+
+	if (fd->fd_och != NULL) {
+		rc = ll_close_inode_openhandle(md_exp, inode, fd->fd_och);
+		fd->fd_och = NULL;
+		GOTO(out, rc);
+	}
+
 	/* Let's see if we have good enough OPEN lock on the file and if
 	   we can skip talking to MDS */
 	if (file->f_dentry->d_inode) { /* Can this ever be false? */
@@ -277,6 +295,7 @@ int ll_md_close(struct obd_export *md_exp, struct inode *inode,
 		       file, file->f_dentry, file->f_dentry->d_name.name);
 	}
 
+out:
 	LUSTRE_FPRIVATE(file) = NULL;
 	ll_file_data_put(fd);
 	ll_capa_close(inode);
@@ -440,6 +459,7 @@ static int ll_och_fill(struct obd_export *md_exp, struct lookup_intent *it,
 	body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
 	och->och_fh = body->handle;
 	och->och_fid = body->fid1;
+	och->och_lease_handle.cookie = it->d.lustre.it_lock_handle;
 	och->och_magic = OBD_CLIENT_HANDLE_MAGIC;
 	och->och_flags = it->it_flags;
 
@@ -471,7 +491,7 @@ int ll_local_open(struct file *file, struct lookup_intent *it,
 
 	LUSTRE_FPRIVATE(file) = fd;
 	ll_readahead_init(inode, &fd->fd_ras);
-	fd->fd_omode = it->it_flags;
+	fd->fd_omode = it->it_flags & (FMODE_READ | FMODE_WRITE | FMODE_EXEC);
 	return 0;
 }
 
@@ -673,6 +693,196 @@ out_openerr:
 	return rc;
 }
 
+static int ll_md_blocking_lease_ast(struct ldlm_lock *lock,
+			struct ldlm_lock_desc *desc, void *data, int flag)
+{
+	int rc;
+	struct lustre_handle lockh;
+
+	switch (flag) {
+	case LDLM_CB_BLOCKING:
+		ldlm_lock2handle(lock, &lockh);
+		rc = ldlm_cli_cancel(&lockh, LCF_ASYNC);
+		if (rc < 0) {
+			CDEBUG(D_INODE, "ldlm_cli_cancel: %d\n", rc);
+			return rc;
+		}
+		break;
+	case LDLM_CB_CANCELING:
+		/* do nothing */
+		break;
+	}
+	return 0;
+}
+
+/**
+ * Acquire a lease and open the file.
+ */
+struct obd_client_handle *ll_lease_open(struct inode *inode, struct file *file,
+					fmode_t fmode)
+{
+	struct lookup_intent it = { .it_op = IT_OPEN };
+	struct ll_sb_info *sbi = ll_i2sbi(inode);
+	struct md_op_data *op_data;
+	struct ptlrpc_request *req;
+	struct lustre_handle old_handle = { 0 };
+	struct obd_client_handle *och = NULL;
+	int rc;
+	int rc2;
+
+	if (fmode != FMODE_WRITE && fmode != FMODE_READ)
+		return ERR_PTR(-EINVAL);
+
+	if (file != NULL) {
+		struct ll_inode_info *lli = ll_i2info(inode);
+		struct ll_file_data *fd = LUSTRE_FPRIVATE(file);
+		struct obd_client_handle **och_p;
+		__u64 *och_usecount;
+
+		if (!(fmode & file->f_mode) || (file->f_mode & FMODE_EXEC))
+			return ERR_PTR(-EPERM);
+
+		/* Get the openhandle of the file */
+		rc = -EBUSY;
+		mutex_lock(&lli->lli_och_mutex);
+		if (fd->fd_lease_och != NULL) {
+			mutex_unlock(&lli->lli_och_mutex);
+			return ERR_PTR(rc);
+		}
+
+		if (fd->fd_och == NULL) {
+			if (file->f_mode & FMODE_WRITE) {
+				LASSERT(lli->lli_mds_write_och != NULL);
+				och_p = &lli->lli_mds_write_och;
+				och_usecount = &lli->lli_open_fd_write_count;
+			} else {
+				LASSERT(lli->lli_mds_read_och != NULL);
+				och_p = &lli->lli_mds_read_och;
+				och_usecount = &lli->lli_open_fd_read_count;
+			}
+			if (*och_usecount == 1) {
+				fd->fd_och = *och_p;
+				*och_p = NULL;
+				*och_usecount = 0;
+				rc = 0;
+			}
+		}
+		mutex_unlock(&lli->lli_och_mutex);
+		if (rc < 0) /* more than 1 opener */
+			return ERR_PTR(rc);
+
+		LASSERT(fd->fd_och != NULL);
+		old_handle = fd->fd_och->och_fh;
+	}
+
+	OBD_ALLOC_PTR(och);
+	if (och == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	op_data = ll_prep_md_op_data(NULL, inode, inode, NULL, 0, 0,
+					LUSTRE_OPC_ANY, NULL);
+	if (IS_ERR(op_data))
+		GOTO(out, rc = PTR_ERR(op_data));
+
+	/* To tell the MDT this openhandle is from the same owner */
+	op_data->op_handle = old_handle;
+
+	it.it_flags = fmode | MDS_OPEN_LOCK | MDS_OPEN_BY_FID | MDS_OPEN_LEASE;
+	rc = md_intent_lock(sbi->ll_md_exp, op_data, NULL, 0, &it, 0, &req,
+				ll_md_blocking_lease_ast,
+	/* LDLM_FL_NO_LRU: To not put the lease lock into LRU list, otherwise
+	 * it can be cancelled which may mislead applications that the lease is
+	 * broken;
+	 * LDLM_FL_EXCL: Set this flag so that it won't be matched by normal
+	 * open in ll_md_blocking_ast(). Otherwise as ll_md_blocking_lease_ast
+	 * doesn't deal with openhandle, so normal openhandle will be leaked. */
+				LDLM_FL_NO_LRU | LDLM_FL_EXCL);
+	ll_finish_md_op_data(op_data);
+	if (req != NULL) {
+		ptlrpc_req_finished(req);
+		it_clear_disposition(&it, DISP_ENQ_COMPLETE);
+	}
+	if (rc < 0)
+		GOTO(out_release_it, rc);
+
+	if (it_disposition(&it, DISP_LOOKUP_NEG))
+		GOTO(out_release_it, rc = -ENOENT);
+
+	rc = it_open_error(DISP_OPEN_OPEN, &it);
+	if (rc)
+		GOTO(out_release_it, rc);
+
+	LASSERT(it_disposition(&it, DISP_ENQ_OPEN_REF));
+	ll_och_fill(sbi->ll_md_exp, &it, och);
+
+	if (!it_disposition(&it, DISP_OPEN_LEASE)) /* old server? */
+		GOTO(out_close, rc = -EOPNOTSUPP);
+
+	/* already get lease, handle lease lock */
+	ll_set_lock_data(sbi->ll_md_exp, inode, &it, NULL);
+	if (it.d.lustre.it_lock_mode == 0 ||
+	    it.d.lustre.it_lock_bits != MDS_INODELOCK_OPEN) {
+		/* open lock must return for lease */
+		CERROR(DFID "lease granted but no open lock, %d/%llu.\n",
+			PFID(ll_inode2fid(inode)), it.d.lustre.it_lock_mode,
+			it.d.lustre.it_lock_bits);
+		GOTO(out_close, rc = -EPROTO);
+	}
+
+	ll_intent_release(&it);
+	return och;
+
+out_close:
+	rc2 = ll_close_inode_openhandle(sbi->ll_md_exp, inode, och);
+	if (rc2)
+		CERROR("Close openhandle returned %d\n", rc2);
+
+	/* cancel open lock */
+	if (it.d.lustre.it_lock_mode != 0) {
+		ldlm_lock_decref_and_cancel(&och->och_lease_handle,
+						it.d.lustre.it_lock_mode);
+		it.d.lustre.it_lock_mode = 0;
+	}
+out_release_it:
+	ll_intent_release(&it);
+out:
+	OBD_FREE_PTR(och);
+	return ERR_PTR(rc);
+}
+EXPORT_SYMBOL(ll_lease_open);
+
+/**
+ * Release lease and close the file.
+ * It will check if the lease has ever broken.
+ */
+int ll_lease_close(struct obd_client_handle *och, struct inode *inode,
+			bool *lease_broken)
+{
+	struct ldlm_lock *lock;
+	bool cancelled = true;
+	int rc;
+
+	lock = ldlm_handle2lock(&och->och_lease_handle);
+	if (lock != NULL) {
+		lock_res_and_lock(lock);
+		cancelled = ldlm_is_cancel(lock);
+		unlock_res_and_lock(lock);
+		ldlm_lock_put(lock);
+	}
+
+	CDEBUG(D_INODE, "lease for "DFID" broken? %d\n",
+		PFID(&ll_i2info(inode)->lli_fid), cancelled);
+
+	if (!cancelled)
+		ldlm_cli_cancel(&och->och_lease_handle, 0);
+	if (lease_broken != NULL)
+		*lease_broken = cancelled;
+
+	rc = ll_close_inode_openhandle(ll_i2sbi(inode)->ll_md_exp, inode, och);
+	return rc;
+}
+EXPORT_SYMBOL(ll_lease_close);
+
 /* Fills the obdo with the attributes for the lsm */
 static int ll_lsm_getattr(struct lov_stripe_md *lsm, struct obd_export *exp,
 			  struct obd_capa *capa, struct obdo *obdo,
@@ -2066,6 +2276,91 @@ long ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		OBD_FREE_PTR(hca);
 		return rc;
 	}
+	case LL_IOC_SET_LEASE: {
+		struct ll_inode_info *lli = ll_i2info(inode);
+		struct obd_client_handle *och = NULL;
+		bool lease_broken;
+		fmode_t mode = 0;
+
+		switch (arg) {
+		case F_WRLCK:
+			if (!(file->f_mode & FMODE_WRITE))
+				return -EPERM;
+			mode = FMODE_WRITE;
+			break;
+		case F_RDLCK:
+			if (!(file->f_mode & FMODE_READ))
+				return -EPERM;
+			mode = FMODE_READ;
+			break;
+		case F_UNLCK:
+			mutex_lock(&lli->lli_och_mutex);
+			if (fd->fd_lease_och != NULL) {
+				och = fd->fd_lease_och;
+				fd->fd_lease_och = NULL;
+			}
+			mutex_unlock(&lli->lli_och_mutex);
+
+			if (och != NULL) {
+				mode = och->och_flags &
+				       (FMODE_READ|FMODE_WRITE);
+				rc = ll_lease_close(och, inode, &lease_broken);
+				if (rc == 0 && lease_broken)
+					mode = 0;
+			} else {
+				rc = -ENOLCK;
+			}
+
+			/* return the type of lease or error */
+			return rc < 0 ? rc : (int)mode;
+		default:
+			return -EINVAL;
+		}
+
+		CDEBUG(D_INODE, "Set lease with mode %d\n", mode);
+
+		/* apply for lease */
+		och = ll_lease_open(inode, file, mode);
+		if (IS_ERR(och))
+			return PTR_ERR(och);
+
+		rc = 0;
+		mutex_lock(&lli->lli_och_mutex);
+		if (fd->fd_lease_och == NULL) {
+			fd->fd_lease_och = och;
+			och = NULL;
+		}
+		mutex_unlock(&lli->lli_och_mutex);
+		if (och != NULL) {
+			/* impossible now that only excl is supported for now */
+			ll_lease_close(och, inode, &lease_broken);
+			rc = -EBUSY;
+		}
+		return rc;
+	}
+	case LL_IOC_GET_LEASE: {
+		struct ll_inode_info *lli = ll_i2info(inode);
+		struct ldlm_lock *lock = NULL;
+
+		rc = 0;
+		mutex_lock(&lli->lli_och_mutex);
+		if (fd->fd_lease_och != NULL) {
+			struct obd_client_handle *och = fd->fd_lease_och;
+
+			lock = ldlm_handle2lock(&och->och_lease_handle);
+			if (lock != NULL) {
+				lock_res_and_lock(lock);
+				if (!ldlm_is_cancel(lock))
+					rc = och->och_flags &
+						(FMODE_READ | FMODE_WRITE);
+				unlock_res_and_lock(lock);
+				ldlm_lock_put(lock);
+			}
+		}
+		mutex_unlock(&lli->lli_och_mutex);
+
+		return rc;
+	}
 	default: {
 		int err;
 
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 22fb6ba..c326ff2 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -610,10 +610,14 @@ extern struct kmem_cache *ll_file_data_slab;
 struct lustre_handle;
 struct ll_file_data {
 	struct ll_readahead_state fd_ras;
-	int fd_omode;
 	struct ccc_grouplock fd_grouplock;
 	__u64 lfd_pos;
 	__u32 fd_flags;
+	fmode_t fd_omode;
+	/* openhandle if lease exists for this file.
+	 * Borrow lli->lli_och_mutex to protect assignment */
+	struct obd_client_handle *fd_lease_och;
+	struct obd_client_handle *fd_och;
 	struct file *fd_file;
 	/* Indicate whether need to report failure when close.
 	 * true: failure is known, not report again.
@@ -779,6 +783,11 @@ int ll_put_grouplock(struct inode *inode, struct file *file, unsigned long arg);
 int ll_fid2path(struct inode *inode, void *arg);
 int ll_data_version(struct inode *inode, __u64 *data_version, int extent_lock);
 
+struct obd_client_handle *ll_lease_open(struct inode *inode, struct file *file,
+					fmode_t mode);
+int ll_lease_close(struct obd_client_handle *och, struct inode *inode,
+		   bool *lease_broken);
+
 /* llite/dcache.c */
 
 int ll_dops_init(struct dentry *de, int block, int init_sa);
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_internal.h b/drivers/staging/lustre/lustre/mdc/mdc_internal.h
index 2aeff0e..b995af6 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_internal.h
+++ b/drivers/staging/lustre/lustre/mdc/mdc_internal.h
@@ -69,7 +69,7 @@ void mdc_create_pack(struct ptlrpc_request *req, struct md_op_data *op_data,
 		     const void *data, int datalen, __u32 mode, __u32 uid,
 		     __u32 gid, cfs_cap_t capability, __u64 rdev);
 void mdc_open_pack(struct ptlrpc_request *req, struct md_op_data *op_data,
-		   __u32 mode, __u64 rdev, __u32 flags, const void *data,
+		   __u32 mode, __u64 rdev, __u64 flags, const void *data,
 		   int datalen);
 void mdc_unlink_pack(struct ptlrpc_request *req, struct md_op_data *op_data);
 void mdc_link_pack(struct ptlrpc_request *req, struct md_op_data *op_data);
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_lib.c b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
index b2de478..3e77020 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_lib.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
@@ -174,12 +174,12 @@ void mdc_create_pack(struct ptlrpc_request *req, struct md_op_data *op_data,
 	}
 }
 
-static __u64 mds_pack_open_flags(__u32 flags, __u32 mode)
+static __u64 mds_pack_open_flags(__u64 flags, __u32 mode)
 {
 	__u64 cr_flags = (flags & (FMODE_READ | FMODE_WRITE |
 				   MDS_OPEN_HAS_EA | MDS_OPEN_HAS_OBJS |
 				   MDS_OPEN_OWNEROVERRIDE | MDS_OPEN_LOCK |
-				   MDS_OPEN_BY_FID));
+				   MDS_OPEN_BY_FID | MDS_OPEN_LEASE));
 	if (flags & O_CREAT)
 		cr_flags |= MDS_OPEN_CREAT;
 	if (flags & O_EXCL)
@@ -207,7 +207,7 @@ static __u64 mds_pack_open_flags(__u32 flags, __u32 mode)
 
 /* packing of MDS records */
 void mdc_open_pack(struct ptlrpc_request *req, struct md_op_data *op_data,
-		   __u32 mode, __u64 rdev, __u32 flags, const void *lmm,
+		   __u32 mode, __u64 rdev, __u64 flags, const void *lmm,
 		   int lmmlen)
 {
 	struct mdt_rec_create *rec;
@@ -234,6 +234,7 @@ void mdc_open_pack(struct ptlrpc_request *req, struct md_op_data *op_data,
 	rec->cr_suppgid2 = op_data->op_suppgids[1];
 	rec->cr_bias     = op_data->op_bias;
 	rec->cr_umask    = current_umask();
+	rec->cr_old_handle = op_data->op_handle;
 
 	mdc_pack_capa(req, &RMF_CAPA1, op_data->op_capa1);
 	/* the next buffer is child capa, which is used for replay,
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index fb5a995..eccbab7 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -75,6 +75,12 @@ EXPORT_SYMBOL(it_clear_disposition);
 
 int it_open_error(int phase, struct lookup_intent *it)
 {
+	if (it_disposition(it, DISP_OPEN_LEASE)) {
+		if (phase >= DISP_OPEN_LEASE)
+			return it->d.lustre.it_status;
+		else
+			return 0;
+	}
 	if (it_disposition(it, DISP_OPEN_OPEN)) {
 		if (phase >= DISP_OPEN_OPEN)
 			return it->d.lustre.it_status;
@@ -281,14 +287,21 @@ static struct ptlrpc_request *mdc_intent_open_pack(struct obd_export *exp,
 	/* XXX: openlock is not cancelled for cross-refs. */
 	/* If inode is known, cancel conflicting OPEN locks. */
 	if (fid_is_sane(&op_data->op_fid2)) {
-		if (it->it_flags & (FMODE_WRITE|MDS_OPEN_TRUNC))
-			mode = LCK_CW;
+		if (it->it_flags & MDS_OPEN_LEASE) { /* try to get lease */
+			if (it->it_flags & FMODE_WRITE)
+				mode = LCK_EX;
+			else
+				mode = LCK_PR;
+		} else {
+			if (it->it_flags & (FMODE_WRITE|MDS_OPEN_TRUNC))
+				mode = LCK_CW;
 #ifdef FMODE_EXEC
-		else if (it->it_flags & FMODE_EXEC)
-			mode = LCK_PR;
+			else if (it->it_flags & FMODE_EXEC)
+				mode = LCK_PR;
 #endif
-		else
-			mode = LCK_CR;
+			else
+				mode = LCK_CR;
+		}
 		count = mdc_resource_get_unused(exp, &op_data->op_fid2,
 						&cancels, mode,
 						MDS_INODELOCK_OPEN);
@@ -1065,10 +1078,10 @@ int mdc_intent_lock(struct obd_export *exp, struct md_op_data *op_data,
 	LASSERT(it);
 
 	CDEBUG(D_DLMTRACE, "(name: %.*s,"DFID") in obj "DFID
-	       ", intent: %s flags %#o\n", op_data->op_namelen,
-	       op_data->op_name, PFID(&op_data->op_fid2),
-	       PFID(&op_data->op_fid1), ldlm_it2str(it->it_op),
-	       it->it_flags);
+		", intent: %s flags %#Lo\n", op_data->op_namelen,
+		op_data->op_name, PFID(&op_data->op_fid2),
+		PFID(&op_data->op_fid1), ldlm_it2str(it->it_op),
+		it->it_flags);
 
 	lockh.cookie = 0;
 	if (fid_is_sane(&op_data->op_fid2) &&
@@ -1194,9 +1207,10 @@ int mdc_intent_getattr_async(struct obd_export *exp,
 	int		      rc = 0;
 	__u64		    flags = LDLM_FL_HAS_INTENT;
 
-	CDEBUG(D_DLMTRACE,"name: %.*s in inode "DFID", intent: %s flags %#o\n",
-	       op_data->op_namelen, op_data->op_name, PFID(&op_data->op_fid1),
-	       ldlm_it2str(it->it_op), it->it_flags);
+	CDEBUG(D_DLMTRACE,
+		"name: %.*s in inode "DFID", intent: %s flags %#Lo\n",
+		op_data->op_namelen, op_data->op_name, PFID(&op_data->op_fid1),
+		ldlm_it2str(it->it_op), it->it_flags);
 
 	fid_build_reg_res_name(&op_data->op_fid1, &res_id);
 	req = mdc_intent_getattr_pack(exp, it, op_data);
-- 
1.7.9.5

