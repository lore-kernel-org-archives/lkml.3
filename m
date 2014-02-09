Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaBIHxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 02:53:36 -0500
Received: from linuxhacker.ru ([217.76.32.60]:37351 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbaBIHwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 02:52:25 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Andrew Perepechko <andrew_perepechko@xyratex.com>,
        Nathaniel Clark <nathaniel.l.clark@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 4/5] lustre/xattr: separate ACL and XATTR caches
Date: Sun,  9 Feb 2014 02:51:48 -0500
Message-Id: <1391932309-6009-5-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391932309-6009-1-git-send-email-green@linuxhacker.ru>
References: <1391932309-6009-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Perepechko <andrew_perepechko@xyratex.com>

This patch separates ACL and XATTR caches, so that
when updating an ACL only LOOKUP lock is needed and
when updating another XATTR only XATTR lock is needed.

This patch also reverts XATTR cache support for setxattr
because client performing REINT under even PR lock
will deadlock if an active server operation (like unlink)
attempts to cancel all locks, and setxattr has to wait
for it (MDC max-in-flight is 1).

This patch disables the r/o cache if the data is
unreasonably large (larger than maximum single EA
size).

Signed-off-by: Andrew Perepechko <andrew_perepechko@xyratex.com>
Signed-off-by: Nathaniel Clark <nathaniel.l.clark@intel.com>
Reviewed-on: http://review.whamcloud.com/7208
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3669
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      |   1 -
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |   2 -
 .../staging/lustre/lustre/llite/llite_internal.h   |   7 --
 drivers/staging/lustre/lustre/llite/xattr.c        |  29 +++--
 drivers/staging/lustre/lustre/llite/xattr_cache.c  | 117 ++++-----------------
 drivers/staging/lustre/lustre/mdc/mdc_internal.h   |   2 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |   9 +-
 drivers/staging/lustre/lustre/mdc/mdc_reint.c      |   2 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |  30 +++++-
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |   3 +-
 10 files changed, 68 insertions(+), 134 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 05c77c0..4183a35 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -1747,7 +1747,6 @@ static inline __u32 lov_mds_md_size(__u16 stripes, __u32 lmm_magic)
 			  OBD_MD_FLGID   | OBD_MD_FLFLAGS | OBD_MD_FLNLINK | \
 			  OBD_MD_FLGENER | OBD_MD_FLRDEV  | OBD_MD_FLGROUP)
 
-#define OBD_MD_FLXATTRLOCKED OBD_MD_FLGETATTRLOCK
 #define OBD_MD_FLXATTRALL (OBD_MD_FLXATTR | OBD_MD_FLXATTRLS)
 
 /* don't forget obdo_fid which is way down at the bottom so it can
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index 692623b..0548aca 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -145,8 +145,6 @@ char *ldlm_it2str(int it)
 		return "getxattr";
 	case IT_LAYOUT:
 		return "layout";
-	case IT_SETXATTR:
-		return "setxattr";
 	default:
 		CERROR("Unknown intent %d\n", it);
 		return "UNKNOWN";
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 28669ea..bc17c29 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -296,13 +296,6 @@ int ll_xattr_cache_get(struct inode *inode,
 			size_t size,
 			__u64 valid);
 
-int ll_xattr_cache_update(struct inode *inode,
-			const char *name,
-			const char *newval,
-			size_t size,
-			__u64 valid,
-			int flags);
-
 /*
  * Locking to guarantee consistency of non-atomic updates to long long i_size,
  * consistency between file size and KMS.
diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
index af83580..b1ed4d9 100644
--- a/drivers/staging/lustre/lustre/llite/xattr.c
+++ b/drivers/staging/lustre/lustre/llite/xattr.c
@@ -183,17 +183,11 @@ int ll_setxattr_common(struct inode *inode, const char *name,
 		valid |= rce_ops2valid(rce->rce_ops);
 	}
 #endif
-	if (sbi->ll_xattr_cache_enabled &&
-	    (rce == NULL || rce->rce_ops == RMT_LSETFACL)) {
-		rc = ll_xattr_cache_update(inode, name, pv, size, valid, flags);
-	} else {
 		oc = ll_mdscapa_get(inode);
 		rc = md_setxattr(sbi->ll_md_exp, ll_inode2fid(inode), oc,
 				valid, name, pv, size, 0, flags,
 				ll_i2suppgid(inode), &req);
 		capa_put(oc);
-	}
-
 #ifdef CONFIG_FS_POSIX_ACL
 	if (new_value != NULL)
 		lustre_posix_acl_xattr_free(new_value, size);
@@ -292,6 +286,7 @@ int ll_getxattr_common(struct inode *inode, const char *name,
 	void *xdata;
 	struct obd_capa *oc;
 	struct rmtacl_ctl_entry *rce = NULL;
+	struct ll_inode_info *lli = ll_i2info(inode);
 
 	CDEBUG(D_VFSTRACE, "VFS Op:inode=%lu/%u(%p)\n",
 	       inode->i_ino, inode->i_generation, inode);
@@ -339,7 +334,7 @@ int ll_getxattr_common(struct inode *inode, const char *name,
 	 */
 	if (xattr_type == XATTR_ACL_ACCESS_T &&
 	    !(sbi->ll_flags & LL_SBI_RMT_CLIENT)) {
-		struct ll_inode_info *lli = ll_i2info(inode);
+
 		struct posix_acl *acl;
 
 		spin_lock(&lli->lli_lock);
@@ -358,13 +353,27 @@ int ll_getxattr_common(struct inode *inode, const char *name,
 #endif
 
 do_getxattr:
-	if (sbi->ll_xattr_cache_enabled && (rce == NULL ||
-					    rce->rce_ops == RMT_LGETFACL ||
-					    rce->rce_ops == RMT_LSETFACL)) {
+	if (sbi->ll_xattr_cache_enabled && xattr_type != XATTR_ACL_ACCESS_T) {
 		rc = ll_xattr_cache_get(inode, name, buffer, size, valid);
+		if (rc == -EAGAIN)
+			goto getxattr_nocache;
 		if (rc < 0)
 			GOTO(out_xattr, rc);
+
+		/* Add "system.posix_acl_access" to the list */
+		if (lli->lli_posix_acl != NULL && valid & OBD_MD_FLXATTRLS) {
+			if (size == 0) {
+				rc += sizeof(XATTR_NAME_ACL_ACCESS);
+			} else if (size - rc >= sizeof(XATTR_NAME_ACL_ACCESS)) {
+				memcpy(buffer + rc, XATTR_NAME_ACL_ACCESS,
+				       sizeof(XATTR_NAME_ACL_ACCESS));
+				rc += sizeof(XATTR_NAME_ACL_ACCESS);
+			} else {
+				GOTO(out_xattr, rc = -ERANGE);
+			}
+		}
 	} else {
+getxattr_nocache:
 		oc = ll_mdscapa_get(inode);
 		rc = md_getxattr(sbi->ll_md_exp, ll_inode2fid(inode), oc,
 				valid | (rce ? rce_ops2valid(rce->rce_ops) : 0),
diff --git a/drivers/staging/lustre/lustre/llite/xattr_cache.c b/drivers/staging/lustre/lustre/llite/xattr_cache.c
index 3e3be1f..616d5bd 100644
--- a/drivers/staging/lustre/lustre/llite/xattr_cache.c
+++ b/drivers/staging/lustre/lustre/llite/xattr_cache.c
@@ -98,13 +98,13 @@ static int ll_xattr_cache_find(struct list_head *cache,
 }
 
 /**
- * This adds or updates an xattr.
+ * This adds an xattr.
  *
  * Add @xattr_name attr with @xattr_val value and @xattr_val_len length,
- * if the attribute already exists, then update its value.
  *
  * \retval 0       success
  * \retval -ENOMEM if no memory could be allocated for the cached attr
+ * \retval -EPROTO if duplicate xattr is being added
  */
 static int ll_xattr_cache_add(struct list_head *cache,
 			      const char *xattr_name,
@@ -116,27 +116,8 @@ static int ll_xattr_cache_add(struct list_head *cache,
 
 
 	if (ll_xattr_cache_find(cache, xattr_name, &xattr) == 0) {
-		/* Found a cached EA, update it */
-
-		if (xattr_val_len != xattr->xe_vallen) {
-			char *val;
-			OBD_ALLOC(val, xattr_val_len);
-			if (val == NULL) {
-				CDEBUG(D_CACHE,
-				       "failed to allocate %u bytes for xattr %s update\n",
-				       xattr_val_len, xattr_name);
-				return -ENOMEM;
-			}
-			OBD_FREE(xattr->xe_value, xattr->xe_vallen);
-			xattr->xe_value = val;
-			xattr->xe_vallen = xattr_val_len;
-		}
-		memcpy(xattr->xe_value, xattr_val, xattr_val_len);
-
-		CDEBUG(D_CACHE, "update: [%s]=%.*s\n", xattr_name,
-			xattr_val_len, xattr_val);
-
-		return 0;
+		CDEBUG(D_CACHE, "duplicate xattr: [%s]\n", xattr_name);
+		return -EPROTO;
 	}
 
 	OBD_SLAB_ALLOC_PTR_GFP(xattr, xattr_kmem, __GFP_IO);
@@ -292,7 +273,7 @@ int ll_xattr_cache_destroy(struct inode *inode)
 }
 
 /**
- * Match or enqueue a PR or PW LDLM lock.
+ * Match or enqueue a PR lock.
  *
  * Find or request an LDLM lock with xattr data.
  * Since LDLM does not provide API for atomic match_or_enqueue,
@@ -322,9 +303,7 @@ static int ll_xattr_find_get_lock(struct inode *inode,
 
 	mutex_lock(&lli->lli_xattrs_enq_lock);
 	/* Try matching first. */
-	mode = ll_take_md_lock(inode, MDS_INODELOCK_XATTR, &lockh, 0,
-			       oit->it_op == IT_SETXATTR ? LCK_PW :
-							   (LCK_PR | LCK_PW));
+	mode = ll_take_md_lock(inode, MDS_INODELOCK_XATTR, &lockh, 0, LCK_PR);
 	if (mode != 0) {
 		/* fake oit in mdc_revalidate_lock() manner */
 		oit->d.lustre.it_lock_handle = lockh.cookie;
@@ -340,13 +319,7 @@ static int ll_xattr_find_get_lock(struct inode *inode,
 		return PTR_ERR(op_data);
 	}
 
-	op_data->op_valid = OBD_MD_FLXATTR | OBD_MD_FLXATTRLS |
-			    OBD_MD_FLXATTRLOCKED;
-#ifdef CONFIG_FS_POSIX_ACL
-	/* If working with ACLs, we would like to cache local ACLs */
-	if (sbi->ll_flags & LL_SBI_RMT_CLIENT)
-		op_data->op_valid |= OBD_MD_FLRMTLGETFACL;
-#endif
+	op_data->op_valid = OBD_MD_FLXATTR | OBD_MD_FLXATTRLS;
 
 	rc = md_enqueue(exp, &einfo, oit, op_data, &lockh, NULL, 0, NULL, 0);
 	ll_finish_md_op_data(op_data);
@@ -409,7 +382,11 @@ static int ll_xattr_cache_refill(struct inode *inode, struct lookup_intent *oit)
 	if (oit->d.lustre.it_status < 0) {
 		CDEBUG(D_CACHE, "getxattr intent returned %d for fid "DFID"\n",
 		       oit->d.lustre.it_status, PFID(ll_inode2fid(inode)));
-		GOTO(out_destroy, rc = oit->d.lustre.it_status);
+		rc = oit->d.lustre.it_status;
+		/* xattr data is so large that we don't want to cache it */
+		if (rc == -ERANGE)
+			rc = -EAGAIN;
+		GOTO(out_destroy, rc);
 	}
 
 	body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
@@ -447,6 +424,11 @@ static int ll_xattr_cache_refill(struct inode *inode, struct lookup_intent *oit)
 			rc = -EPROTO;
 		} else if (OBD_FAIL_CHECK(OBD_FAIL_LLITE_XATTR_ENOMEM)) {
 			rc = -ENOMEM;
+		} else if (!strcmp(xdata, XATTR_NAME_ACL_ACCESS)) {
+			/* Filter out ACL ACCESS since it's cached separately */
+			CDEBUG(D_CACHE, "not caching %s\n",
+			       XATTR_NAME_ACL_ACCESS);
+			rc = 0;
 		} else {
 			rc = ll_xattr_cache_add(&lli->lli_xattrs, xdata, xval,
 						*xsizes);
@@ -467,8 +449,7 @@ static int ll_xattr_cache_refill(struct inode *inode, struct lookup_intent *oit)
 
 	GOTO(out_maybe_drop, rc);
 out_maybe_drop:
-	/* drop lock on error or getxattr */
-	if (rc != 0 || oit->it_op != IT_SETXATTR)
+
 		ll_intent_drop_lock(oit);
 
 	if (rc != 0)
@@ -553,65 +534,3 @@ out:
 
 	return rc;
 }
-
-
-/**
- * Set/update an xattr value or remove xattr using the write-through cache.
- *
- * Set/update the xattr value (if @valid has OBD_MD_FLXATTR) of @name to @newval
- * or
- * remove the xattr @name (@valid has OBD_MD_FLXATTRRM set) from @inode.
- * @flags is either XATTR_CREATE or XATTR_REPLACE as defined by setxattr(2)
- *
- * \retval 0        no error occured
- * \retval -EPROTO  network protocol error
- * \retval -ENOMEM  not enough memory for the cache
- * \retval -ERANGE  the buffer is not large enough
- * \retval -ENODATA no such attr (in the removal case)
- */
-int ll_xattr_cache_update(struct inode *inode,
-			const char *name,
-			const char *newval,
-			size_t size,
-			__u64 valid,
-			int flags)
-{
-	struct lookup_intent oit = { .it_op = IT_SETXATTR };
-	struct ll_sb_info *sbi = ll_i2sbi(inode);
-	struct ptlrpc_request *req = NULL;
-	struct ll_inode_info *lli = ll_i2info(inode);
-	struct obd_capa *oc;
-	int rc;
-
-
-
-	LASSERT(!!(valid & OBD_MD_FLXATTR) ^ !!(valid & OBD_MD_FLXATTRRM));
-
-	rc = ll_xattr_cache_refill(inode, &oit);
-	if (rc)
-		return rc;
-
-	oc = ll_mdscapa_get(inode);
-	rc = md_setxattr(sbi->ll_md_exp, ll_inode2fid(inode), oc,
-			valid | OBD_MD_FLXATTRLOCKED, name, newval,
-			size, 0, flags, ll_i2suppgid(inode), &req);
-	capa_put(oc);
-
-	if (rc) {
-		ll_intent_drop_lock(&oit);
-		GOTO(out, rc);
-	}
-
-	if (valid & OBD_MD_FLXATTR)
-		rc = ll_xattr_cache_add(&lli->lli_xattrs, name, newval, size);
-	else if (valid & OBD_MD_FLXATTRRM)
-		rc = ll_xattr_cache_del(&lli->lli_xattrs, name);
-
-	ll_intent_drop_lock(&oit);
-	GOTO(out, rc);
-out:
-	up_write(&lli->lli_xattrs_list_rwsem);
-	ptlrpc_req_finished(req);
-
-	return rc;
-}
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_internal.h b/drivers/staging/lustre/lustre/mdc/mdc_internal.h
index 5069829..fc21777 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_internal.h
+++ b/drivers/staging/lustre/lustre/mdc/mdc_internal.h
@@ -101,7 +101,7 @@ int mdc_enqueue(struct obd_export *exp, struct ldlm_enqueue_info *einfo,
 		struct lustre_handle *lockh, void *lmm, int lmmsize,
 		struct ptlrpc_request **req, __u64 extra_lock_flags);
 
-int mdc_resource_get_unused(struct obd_export *exp, struct lu_fid *fid,
+int mdc_resource_get_unused(struct obd_export *exp, const struct lu_fid *fid,
 			    struct list_head *cancels, ldlm_mode_t mode,
 			    __u64 bits);
 /* mdc/mdc_request.c */
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 8aa7c80..288a41e 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -378,13 +378,6 @@ mdc_intent_getxattr_pack(struct obd_export *exp,
 
 	mdc_set_capa_size(req, &RMF_CAPA1, op_data->op_capa1);
 
-	if (it->it_op == IT_SETXATTR)
-		/* If we want to upgrade to LCK_PW, let's cancel LCK_PR
-		 * locks now. This avoids unnecessary ASTs. */
-		count = mdc_resource_get_unused(exp, &op_data->op_fid1,
-						&cancels, LCK_PW,
-						MDS_INODELOCK_XATTR);
-
 	rc = ldlm_prep_enqueue_req(exp, req, &cancels, count);
 	if (rc) {
 		ptlrpc_request_free(req);
@@ -842,7 +835,7 @@ resend:
 			return -EOPNOTSUPP;
 		req = mdc_intent_layout_pack(exp, it, op_data);
 		lvb_type = LVB_T_LAYOUT;
-	} else if (it->it_op & (IT_GETXATTR | IT_SETXATTR)) {
+	} else if (it->it_op & IT_GETXATTR) {
 		req = mdc_intent_getxattr_pack(exp, it, op_data);
 	} else {
 		LBUG();
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_reint.c b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
index 9f3a345..1aea154 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_reint.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
@@ -66,7 +66,7 @@ static int mdc_reint(struct ptlrpc_request *request,
 /* Find and cancel locally locks matched by inode @bits & @mode in the resource
  * found by @fid. Found locks are added into @cancel list. Returns the amount of
  * locks added to @cancels list. */
-int mdc_resource_get_unused(struct obd_export *exp, struct lu_fid *fid,
+int mdc_resource_get_unused(struct obd_export *exp, const struct lu_fid *fid,
 			    struct list_head *cancels, ldlm_mode_t mode,
 			    __u64 bits)
 {
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 8301392..17c8e14 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -355,10 +355,32 @@ static int mdc_xattr_common(struct obd_export *exp,const struct req_format *fmt,
 				     input_size);
 	}
 
-	rc = ptlrpc_request_pack(req, LUSTRE_MDS_VERSION, opcode);
-	if (rc) {
-		ptlrpc_request_free(req);
-		return rc;
+	/* Flush local XATTR locks to get rid of a possible cancel RPC */
+	if (opcode == MDS_REINT && fid_is_sane(fid) &&
+	    exp->exp_connect_data.ocd_ibits_known & MDS_INODELOCK_XATTR) {
+		LIST_HEAD(cancels);
+		int count;
+
+		/* Without that packing would fail */
+		if (input_size == 0)
+			req_capsule_set_size(&req->rq_pill, &RMF_EADATA,
+					     RCL_CLIENT, 0);
+
+		count = mdc_resource_get_unused(exp, fid,
+						&cancels, LCK_EX,
+						MDS_INODELOCK_XATTR);
+
+		rc = mdc_prep_elc_req(exp, req, MDS_REINT, &cancels, count);
+		if (rc) {
+			ptlrpc_request_free(req);
+			return rc;
+		}
+	} else {
+		rc = ptlrpc_request_pack(req, LUSTRE_MDS_VERSION, opcode);
+		if (rc) {
+			ptlrpc_request_free(req);
+			return rc;
+		}
 	}
 
 	if (opcode == MDS_REINT) {
diff --git a/drivers/staging/lustre/lustre/ptlrpc/layout.c b/drivers/staging/lustre/lustre/ptlrpc/layout.c
index 9b8f691..41c12e0 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/layout.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/layout.c
@@ -295,7 +295,8 @@ static const struct req_msg_field *mds_reint_setxattr_client[] = {
 	&RMF_REC_REINT,
 	&RMF_CAPA1,
 	&RMF_NAME,
-	&RMF_EADATA
+	&RMF_EADATA,
+	&RMF_DLM_REQ
 };
 
 static const struct req_msg_field *mdt_swap_layouts[] = {
-- 
1.8.5.3

