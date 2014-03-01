Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaCACRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:17:25 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42608 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbaCACRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:22 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Lai Siyao <lai.siyao@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 09/17] lustre/llite: simplify dentry revalidate
Date: Fri, 28 Feb 2014 21:16:38 -0500
Message-Id: <1393640206-20286-10-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Siyao <lai.siyao@intel.com>

Lustre client dentry validation is protected by LDLM lock, so
any time a dentry is found, it's valid and no need to revalidate
from MDS, and even it does, there is race that it may be
invalidated after revalidation is finished.

Signed-off-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-on: http://review.whamcloud.com/7475
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3544
Reviewed-by: Peng Tao <bergwolf@gmail.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      |   2 +-
 drivers/staging/lustre/lustre/llite/dcache.c       | 290 ++-------------------
 drivers/staging/lustre/lustre/llite/file.c         |   8 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |   4 +-
 drivers/staging/lustre/lustre/lmv/lmv_intent.c     |   1 -
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |   1 -
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |  52 ++--
 7 files changed, 45 insertions(+), 313 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index a55eebf..5f5b0ba 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -2112,7 +2112,7 @@ extern void lustre_swab_generic_32s (__u32 *val);
 #define DISP_LOOKUP_POS      0x00000008
 #define DISP_OPEN_CREATE     0x00000010
 #define DISP_OPEN_OPEN       0x00000020
-#define DISP_ENQ_COMPLETE    0x00400000
+#define DISP_ENQ_COMPLETE    0x00400000		/* obsolete and unused */
 #define DISP_ENQ_OPEN_REF    0x00800000
 #define DISP_ENQ_CREATE_REF  0x01000000
 #define DISP_OPEN_LOCK       0x02000000
diff --git a/drivers/staging/lustre/lustre/llite/dcache.c b/drivers/staging/lustre/lustre/llite/dcache.c
index 3907c87..f971a54 100644
--- a/drivers/staging/lustre/lustre/llite/dcache.c
+++ b/drivers/staging/lustre/lustre/llite/dcache.c
@@ -241,9 +241,6 @@ void ll_intent_release(struct lookup_intent *it)
 		 ptlrpc_req_finished(it->d.lustre.it_data); /* ll_file_open */
 	if (it_disposition(it, DISP_ENQ_CREATE_REF)) /* create rec */
 		ptlrpc_req_finished(it->d.lustre.it_data);
-	if (it_disposition(it, DISP_ENQ_COMPLETE)) /* saved req from revalidate
-						    * to lookup */
-		ptlrpc_req_finished(it->d.lustre.it_data);
 
 	it->d.lustre.it_disposition = 0;
 	it->d.lustre.it_data = NULL;
@@ -328,262 +325,32 @@ void ll_frob_intent(struct lookup_intent **itp, struct lookup_intent *deft)
 
 }
 
-int ll_revalidate_it(struct dentry *de, int lookup_flags,
-		     struct lookup_intent *it)
+static int ll_revalidate_dentry(struct dentry *dentry,
+				unsigned int lookup_flags)
 {
-	struct md_op_data *op_data;
-	struct ptlrpc_request *req = NULL;
-	struct lookup_intent lookup_it = { .it_op = IT_LOOKUP };
-	struct obd_export *exp;
-	struct inode *parent = de->d_parent->d_inode;
-	int rc;
-
-	CDEBUG(D_VFSTRACE, "VFS Op:name=%s,intent=%s\n", de->d_name.name,
-	       LL_IT2STR(it));
-
-	LASSERT(de != de->d_sb->s_root);
-
-	if (de->d_inode == NULL) {
-		__u64 ibits;
-
-		/* We can only use negative dentries if this is stat or lookup,
-		   for opens and stuff we do need to query server. */
-		/* If there is IT_CREAT in intent op set, then we must throw
-		   away this negative dentry and actually do the request to
-		   kernel to create whatever needs to be created (if possible)*/
-		if (it && (it->it_op & IT_CREAT))
-			return 0;
+	struct inode *dir = dentry->d_parent->d_inode;
 
-		if (d_lustre_invalid(de))
-			return 0;
-
-		ibits = MDS_INODELOCK_UPDATE;
-		rc = ll_have_md_lock(parent, &ibits, LCK_MINMODE);
-		GOTO(out_sa, rc);
-	}
-
-	/* Never execute intents for mount points.
-	 * Attributes will be fixed up in ll_inode_revalidate_it */
-	if (d_mountpoint(de))
-		GOTO(out_sa, rc = 1);
-
-	exp = ll_i2mdexp(de->d_inode);
-
-	OBD_FAIL_TIMEOUT(OBD_FAIL_MDC_REVALIDATE_PAUSE, 5);
-	ll_frob_intent(&it, &lookup_it);
-	LASSERT(it);
+	/*
+	 * if open&create is set, talk to MDS to make sure file is created if
+	 * necessary, because we can't do this in ->open() later since that's
+	 * called on an inode. return 0 here to let lookup to handle this.
+	 */
+	if ((lookup_flags & (LOOKUP_OPEN | LOOKUP_CREATE)) ==
+	    (LOOKUP_OPEN | LOOKUP_CREATE))
+		return 0;
 
-	if (it->it_op == IT_LOOKUP && !d_lustre_invalid(de))
+	if (lookup_flags & (LOOKUP_PARENT | LOOKUP_OPEN | LOOKUP_CREATE))
 		return 1;
 
-	if (it->it_op == IT_OPEN) {
-		struct inode *inode = de->d_inode;
-		struct ll_inode_info *lli = ll_i2info(inode);
-		struct obd_client_handle **och_p;
-		__u64 ibits;
-
-		/*
-		 * We used to check for MDS_INODELOCK_OPEN here, but in fact
-		 * just having LOOKUP lock is enough to justify inode is the
-		 * same. And if inode is the same and we have suitable
-		 * openhandle, then there is no point in doing another OPEN RPC
-		 * just to throw away newly received openhandle.  There are no
-		 * security implications too, if file owner or access mode is
-		 * change, LOOKUP lock is revoked.
-		 */
-
-
-		if (it->it_flags & FMODE_WRITE)
-			och_p = &lli->lli_mds_write_och;
-		else if (it->it_flags & FMODE_EXEC)
-			och_p = &lli->lli_mds_exec_och;
-		else
-			och_p = &lli->lli_mds_read_och;
-
-		/* Check for the proper lock. */
-		ibits = MDS_INODELOCK_LOOKUP;
-		if (!ll_have_md_lock(inode, &ibits, LCK_MINMODE))
-			goto do_lock;
-		mutex_lock(&lli->lli_och_mutex);
-		if (*och_p) { /* Everything is open already, do nothing */
-			/* Originally it was idea to do not let them steal our
-			 * open handle from under us by (*och_usecount)++ here.
-			 * But in case we have the handle, but we cannot use it
-			 * due to later checks (e.g. O_CREAT|O_EXCL flags set),
-			 * nobody would decrement counter increased here. So we
-			 * just hope the lock won't be invalidated in between.
-			 * But if it would be, we'll reopen the open request to
-			 * MDS later during file open path.
-			 */
-			mutex_unlock(&lli->lli_och_mutex);
-			return 1;
-		}
-		mutex_unlock(&lli->lli_och_mutex);
-	}
-
-	if (it->it_op == IT_GETATTR) {
-		rc = ll_statahead_enter(parent, &de, 0);
-		if (rc == 1)
-			goto mark;
-		else if (rc != -EAGAIN && rc != 0)
-			GOTO(out, rc = 0);
-	}
-
-do_lock:
-	op_data = ll_prep_md_op_data(NULL, parent, de->d_inode,
-				     de->d_name.name, de->d_name.len,
-				     0, LUSTRE_OPC_ANY, NULL);
-	if (IS_ERR(op_data))
-		return PTR_ERR(op_data);
-
-	if (!IS_POSIXACL(parent) || !exp_connect_umask(exp))
-		it->it_create_mode &= ~current_umask();
-	it->it_create_mode |= M_CHECK_STALE;
-	rc = md_intent_lock(exp, op_data, NULL, 0, it,
-			    lookup_flags,
-			    &req, ll_md_blocking_ast, 0);
-	it->it_create_mode &= ~M_CHECK_STALE;
-	ll_finish_md_op_data(op_data);
-
-	/* If req is NULL, then md_intent_lock only tried to do a lock match;
-	 * if all was well, it will return 1 if it found locks, 0 otherwise. */
-	if (req == NULL && rc >= 0) {
-		if (!rc)
-			goto do_lookup;
-		GOTO(out, rc);
-	}
-
-	if (rc < 0) {
-		if (rc != -ESTALE) {
-			CDEBUG(D_INFO, "ll_intent_lock: rc %d : it->it_status "
-			       "%d\n", rc, it->d.lustre.it_status);
-		}
-		GOTO(out, rc = 0);
-	}
-
-revalidate_finish:
-	rc = ll_revalidate_it_finish(req, it, de);
-	if (rc != 0) {
-		if (rc != -ESTALE && rc != -ENOENT)
-			ll_intent_release(it);
-		GOTO(out, rc = 0);
-	}
-
-	if ((it->it_op & IT_OPEN) && de->d_inode &&
-	    !S_ISREG(de->d_inode->i_mode) &&
-	    !S_ISDIR(de->d_inode->i_mode)) {
-		ll_release_openhandle(de, it);
-	}
-	rc = 1;
-
-out:
-	/* We do not free request as it may be reused during following lookup
-	 * (see comment in mdc/mdc_locks.c::mdc_intent_lock()), request will
-	 * be freed in ll_lookup_it or in ll_intent_release. But if
-	 * request was not completed, we need to free it. (bug 5154, 9903) */
-	if (req != NULL && !it_disposition(it, DISP_ENQ_COMPLETE))
-		ptlrpc_req_finished(req);
-	if (rc == 0) {
-		/* mdt may grant layout lock for the newly created file, so
-		 * release the lock to avoid leaking */
-		ll_intent_drop_lock(it);
-		ll_invalidate_aliases(de->d_inode);
-	} else {
-		__u64 bits = 0;
-		__u64 matched_bits = 0;
-
-		CDEBUG(D_DENTRY, "revalidated dentry %.*s (%p) parent %p "
-		       "inode %p refc %d\n", de->d_name.len,
-		       de->d_name.name, de, de->d_parent, de->d_inode,
-		       d_count(de));
-
-		ll_set_lock_data(exp, de->d_inode, it, &bits);
-
-		/* Note: We have to match both LOOKUP and PERM lock
-		 * here to make sure the dentry is valid and no one
-		 * changing the permission.
-		 * But if the client connects < 2.4 server, which will
-		 * only grant LOOKUP lock, so we can only Match LOOKUP
-		 * lock for old server */
-		if (exp_connect_flags(ll_i2mdexp(de->d_inode)) &&
-							OBD_CONNECT_LVB_TYPE)
-			matched_bits =
-				MDS_INODELOCK_LOOKUP | MDS_INODELOCK_PERM;
-		else
-			matched_bits = MDS_INODELOCK_LOOKUP;
-
-		if (((bits & matched_bits) == matched_bits) &&
-		    d_lustre_invalid(de))
-			d_lustre_revalidate(de);
-		ll_lookup_finish_locks(it, de);
-	}
-
-mark:
-	if (it != NULL && it->it_op == IT_GETATTR && rc > 0)
-		ll_statahead_mark(parent, de);
-	return rc;
+	if (d_need_statahead(dir, dentry) <= 0)
+		return 1;
 
-	/*
-	 * This part is here to combat evil-evil race in real_lookup on 2.6
-	 * kernels.  The race details are: We enter do_lookup() looking for some
-	 * name, there is nothing in dcache for this name yet and d_lookup()
-	 * returns NULL.  We proceed to real_lookup(), and while we do this,
-	 * another process does open on the same file we looking up (most simple
-	 * reproducer), open succeeds and the dentry is added. Now back to
-	 * us. In real_lookup() we do d_lookup() again and suddenly find the
-	 * dentry, so we call d_revalidate on it, but there is no lock, so
-	 * without this code we would return 0, but unpatched real_lookup just
-	 * returns -ENOENT in such a case instead of retrying the lookup. Once
-	 * this is dealt with in real_lookup(), all of this ugly mess can go and
-	 * we can just check locks in ->d_revalidate without doing any RPCs
-	 * ever.
-	 */
-do_lookup:
-	if (it != &lookup_it) {
-		/* MDS_INODELOCK_UPDATE needed for IT_GETATTR case. */
-		if (it->it_op == IT_GETATTR)
-			lookup_it.it_op = IT_GETATTR;
-		ll_lookup_finish_locks(it, de);
-		it = &lookup_it;
-	}
+	if (lookup_flags & LOOKUP_RCU)
+		return -ECHILD;
 
-	/* Do real lookup here. */
-	op_data = ll_prep_md_op_data(NULL, parent, NULL, de->d_name.name,
-				     de->d_name.len, 0, (it->it_op & IT_CREAT ?
-							 LUSTRE_OPC_CREATE :
-							 LUSTRE_OPC_ANY), NULL);
-	if (IS_ERR(op_data))
-		return PTR_ERR(op_data);
-
-	rc = md_intent_lock(exp, op_data, NULL, 0,  it, 0, &req,
-			    ll_md_blocking_ast, 0);
-	if (rc >= 0) {
-		struct mdt_body *mdt_body;
-		struct lu_fid fid = {.f_seq = 0, .f_oid = 0, .f_ver = 0};
-		mdt_body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
-
-		if (de->d_inode)
-			fid = *ll_inode2fid(de->d_inode);
-
-		/* see if we got same inode, if not - return error */
-		if (lu_fid_eq(&fid, &mdt_body->fid1)) {
-			ll_finish_md_op_data(op_data);
-			op_data = NULL;
-			goto revalidate_finish;
-		}
-		ll_intent_release(it);
-	}
-	ll_finish_md_op_data(op_data);
-	GOTO(out, rc = 0);
-
-out_sa:
-	/*
-	 * For rc == 1 case, should not return directly to prevent losing
-	 * statahead windows; for rc == 0 case, the "lookup" will be done later.
-	 */
-	if (it != NULL && it->it_op == IT_GETATTR && rc == 1)
-		ll_statahead_enter(parent, &de, 1);
-	goto mark;
+	do_statahead_enter(dir, &dentry, dentry->d_inode == NULL);
+	ll_statahead_mark(dir, dentry);
+	return 1;
 }
 
 /*
@@ -591,24 +358,13 @@ out_sa:
  */
 int ll_revalidate_nd(struct dentry *dentry, unsigned int flags)
 {
-	struct inode *parent = dentry->d_parent->d_inode;
-	int unplug = 0;
+	int rc;
 
-	CDEBUG(D_VFSTRACE, "VFS Op:name=%s,flags=%u\n",
+	CDEBUG(D_VFSTRACE, "VFS Op:name=%s, flags=%u\n",
 	       dentry->d_name.name, flags);
 
-	if (!(flags & (LOOKUP_PARENT|LOOKUP_OPEN|LOOKUP_CREATE)) &&
-	    ll_need_statahead(parent, dentry) > 0) {
-		if (flags & LOOKUP_RCU)
-			return -ECHILD;
-
-		if (dentry->d_inode == NULL)
-			unplug = 1;
-		do_statahead_enter(parent, &dentry, unplug);
-		ll_statahead_mark(parent, dentry);
-	}
-
-	return 1;
+	rc = ll_revalidate_dentry(dentry, flags);
+	return rc;
 }
 
 
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 7ceec74..70b48ab 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -446,8 +446,7 @@ static int ll_intent_file_open(struct file *file, void *lmm,
 				 itp, NULL);
 
 out:
-	ptlrpc_req_finished(itp->d.lustre.it_data);
-	it_clear_disposition(itp, DISP_ENQ_COMPLETE);
+	ptlrpc_req_finished(req);
 	ll_intent_drop_lock(itp);
 
 	return rc;
@@ -815,10 +814,7 @@ struct obd_client_handle *ll_lease_open(struct inode *inode, struct file *file,
 	 * doesn't deal with openhandle, so normal openhandle will be leaked. */
 				LDLM_FL_NO_LRU | LDLM_FL_EXCL);
 	ll_finish_md_op_data(op_data);
-	if (req != NULL) {
-		ptlrpc_req_finished(req);
-		it_clear_disposition(&it, DISP_ENQ_COMPLETE);
-	}
+	ptlrpc_req_finished(req);
 	if (rc < 0)
 		GOTO(out_release_it, rc);
 
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 47c5142..f67c508 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -1309,7 +1309,7 @@ ll_statahead_mark(struct inode *dir, struct dentry *dentry)
 }
 
 static inline int
-ll_need_statahead(struct inode *dir, struct dentry *dentryp)
+d_need_statahead(struct inode *dir, struct dentry *dentryp)
 {
 	struct ll_inode_info  *lli;
 	struct ll_dentry_data *ldd;
@@ -1354,7 +1354,7 @@ ll_statahead_enter(struct inode *dir, struct dentry **dentryp, int only_unplug)
 {
 	int ret;
 
-	ret = ll_need_statahead(dir, *dentryp);
+	ret = d_need_statahead(dir, *dentryp);
 	if (ret <= 0)
 		return ret;
 
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_intent.c b/drivers/staging/lustre/lustre/lmv/lmv_intent.c
index 56dedce..9ba5a0a 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_intent.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_intent.c
@@ -119,7 +119,6 @@ static int lmv_intent_remote(struct obd_export *exp, void *lmm,
 	CDEBUG(D_INODE, "REMOTE_INTENT with fid="DFID" -> mds #%d\n",
 	       PFID(&body->fid1), tgt->ltd_idx);
 
-	it->d.lustre.it_disposition &= ~DISP_ENQ_COMPLETE;
 	rc = md_intent_lock(tgt->ltd_exp, op_data, lmm, lmmsize, it,
 			    flags, &req, cb_blocking, extra_lock_flags);
 	if (rc)
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index 40fbd44..3ba0a0a 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -1744,7 +1744,6 @@ lmv_enqueue_remote(struct obd_export *exp, struct ldlm_enqueue_info *einfo,
 	it->d.lustre.it_data = NULL;
 	fid1 = body->fid1;
 
-	it->d.lustre.it_disposition &= ~DISP_ENQ_COMPLETE;
 	ptlrpc_req_finished(req);
 
 	tgt = lmv_find_target(lmv, &fid1);
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 20706e7..81adc2b 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -968,7 +968,6 @@ static int mdc_finish_intent_lock(struct obd_export *exp,
 	if (fid_is_sane(&op_data->op_fid2) &&
 	    it->it_create_mode & M_CHECK_STALE &&
 	    it->it_op != IT_GETATTR) {
-		it_set_disposition(it, DISP_ENQ_COMPLETE);
 
 		/* Also: did we find the same inode? */
 		/* sever can return one of two fids:
@@ -1139,6 +1138,12 @@ int mdc_intent_lock(struct obd_export *exp, struct md_op_data *op_data,
 		    ldlm_blocking_callback cb_blocking,
 		    __u64 extra_lock_flags)
 {
+	struct ldlm_enqueue_info einfo = {
+		.ei_type	= LDLM_IBITS,
+		.ei_mode	= it_to_lock_mode(it),
+		.ei_cb_bl	= cb_blocking,
+		.ei_cb_cp	= ldlm_completion_ast,
+	};
 	struct lustre_handle lockh;
 	int rc = 0;
 
@@ -1164,42 +1169,19 @@ int mdc_intent_lock(struct obd_export *exp, struct md_op_data *op_data,
 			return rc;
 	}
 
-	/* lookup_it may be called only after revalidate_it has run, because
-	 * revalidate_it cannot return errors, only zero.  Returning zero causes
-	 * this call to lookup, which *can* return an error.
-	 *
-	 * We only want to execute the request associated with the intent one
-	 * time, however, so don't send the request again.  Instead, skip past
-	 * this and use the request from revalidate.  In this case, revalidate
-	 * never dropped its reference, so the refcounts are all OK */
-	if (!it_disposition(it, DISP_ENQ_COMPLETE)) {
-		struct ldlm_enqueue_info einfo = {
-			.ei_type	= LDLM_IBITS,
-			.ei_mode	= it_to_lock_mode(it),
-			.ei_cb_bl	= cb_blocking,
-			.ei_cb_cp	= ldlm_completion_ast,
-		};
-
-		/* For case if upper layer did not alloc fid, do it now. */
-		if (!fid_is_sane(&op_data->op_fid2) && it->it_op & IT_CREAT) {
-			rc = mdc_fid_alloc(exp, &op_data->op_fid2, op_data);
-			if (rc < 0) {
-				CERROR("Can't alloc new fid, rc %d\n", rc);
-				return rc;
-			}
-		}
-		rc = mdc_enqueue(exp, &einfo, it, op_data, &lockh,
-				 lmm, lmmsize, NULL, extra_lock_flags);
-		if (rc < 0)
+	/* For case if upper layer did not alloc fid, do it now. */
+	if (!fid_is_sane(&op_data->op_fid2) && it->it_op & IT_CREAT) {
+		rc = mdc_fid_alloc(exp, &op_data->op_fid2, op_data);
+		if (rc < 0) {
+			CERROR("Can't alloc new fid, rc %d\n", rc);
 			return rc;
-	} else if (!fid_is_sane(&op_data->op_fid2) ||
-		   !(it->it_create_mode & M_CHECK_STALE)) {
-		/* DISP_ENQ_COMPLETE set means there is extra reference on
-		 * request referenced from this intent, saved for subsequent
-		 * lookup.  This path is executed when we proceed to this
-		 * lookup, so we clear DISP_ENQ_COMPLETE */
-		it_clear_disposition(it, DISP_ENQ_COMPLETE);
+		}
 	}
+	rc = mdc_enqueue(exp, &einfo, it, op_data, &lockh, lmm, lmmsize, NULL,
+			 extra_lock_flags);
+	if (rc < 0)
+		return rc;
+
 	*reqp = it->d.lustre.it_data;
 	rc = mdc_finish_intent_lock(exp, *reqp, op_data, it, &lockh);
 	return rc;
-- 
1.8.5.3

