Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3KUO10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:27:26 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:65299 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab3KUO1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:27:24 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>,
        Lai Siyao <lai.siyao@intel.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH-v2 2/3] staging/lustre/ldlm: fix resource/fid check, use DLDLMRES
Date: Thu, 21 Nov 2013 22:24:49 +0800
Message-Id: <1385043890-3053-3-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385043890-3053-1-git-send-email-bergwolf@gmail.com>
References: <1385043890-3053-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Dilger <andreas.dilger@intel.com>

In ll_md_blocking_ast() the FID/resource comparison is incorrectly
checking for fid_ver() stored in res_id.name[2] instead of name[1]
changed since http://review.whamcloud.com/2271 (commit 4f91d5161d00)
landed.  This does not impact current clients, since name[2] and
fid_ver() are always zero, but it could cause problems in the future.

In ldlm_cli_enqueue_fini() use ldlm_res_eq() instead of comparing
each of the resource fields separately.

Use DLDLMRES/PLDLMRES when printing resource names everywhere.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2901
Lustre-change: http://review.whamcloud.com/6592
Signed-off-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: Johann Lombardi <johann.lombardi@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |   32 +++++++-------------
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |   19 +++---------
 drivers/staging/lustre/lustre/llite/namei.c        |    5 +--
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |    9 ++----
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |    4 +--
 5 files changed, 21 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
index 1e2c0dd..1ddcca3 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
@@ -610,18 +610,12 @@ int ldlm_cli_enqueue_fini(struct obd_export *exp, struct ptlrpc_request *req,
 			lock->l_req_mode = newmode;
 		}
 
-		if (memcmp(reply->lock_desc.l_resource.lr_name.name,
-			  lock->l_resource->lr_name.name,
-			  sizeof(struct ldlm_res_id))) {
-			CDEBUG(D_INFO, "remote intent success, locking "
-					"(%ld,%ld,%ld) instead of "
-					"(%ld,%ld,%ld)\n",
-			      (long)reply->lock_desc.l_resource.lr_name.name[0],
-			      (long)reply->lock_desc.l_resource.lr_name.name[1],
-			      (long)reply->lock_desc.l_resource.lr_name.name[2],
-			      (long)lock->l_resource->lr_name.name[0],
-			      (long)lock->l_resource->lr_name.name[1],
-			      (long)lock->l_resource->lr_name.name[2]);
+		if (!ldlm_res_eq(&reply->lock_desc.l_resource.lr_name,
+				 &lock->l_resource->lr_name)) {
+			CDEBUG(D_INFO, "remote intent success, locking "DLDLMRES
+				       " instead of "DLDLMRES"\n",
+			       PLDLMRES(&reply->lock_desc.l_resource),
+			       PLDLMRES(lock->l_resource));
 
 			rc = ldlm_lock_change_resource(ns, lock,
 					&reply->lock_desc.l_resource.lr_name);
@@ -1912,7 +1906,8 @@ int ldlm_cli_cancel_unused_resource(struct ldlm_namespace *ns,
 					   0, flags | LCF_BL_AST, opaque);
 	rc = ldlm_cli_cancel_list(&cancels, count, NULL, flags);
 	if (rc != ELDLM_OK)
-		CERROR("ldlm_cli_cancel_unused_resource: %d\n", rc);
+		CERROR("canceling unused lock "DLDLMRES": rc = %d\n",
+		       PLDLMRES(res), rc);
 
 	LDLM_RESOURCE_DELREF(res);
 	ldlm_resource_putref(res);
@@ -1930,15 +1925,10 @@ static int ldlm_cli_hash_cancel_unused(struct cfs_hash *hs, struct cfs_hash_bd *
 {
 	struct ldlm_resource	   *res = cfs_hash_object(hs, hnode);
 	struct ldlm_cli_cancel_arg     *lc = arg;
-	int			     rc;
 
-	rc = ldlm_cli_cancel_unused_resource(ldlm_res_to_ns(res), &res->lr_name,
-					     NULL, LCK_MINMODE,
-					     lc->lc_flags, lc->lc_opaque);
-	if (rc != 0) {
-		CERROR("ldlm_cli_cancel_unused ("LPU64"): %d\n",
-		       res->lr_name.name[0], rc);
-	}
+	ldlm_cli_cancel_unused_resource(ldlm_res_to_ns(res), &res->lr_name,
+					NULL, LCK_MINMODE,
+					lc->lc_flags, lc->lc_opaque);
 	/* must return 0 for hash iteration */
 	return 0;
 }
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
index 77e022b..25e14e1 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
@@ -762,16 +762,9 @@ static int ldlm_resource_complain(struct cfs_hash *hs, struct cfs_hash_bd *bd,
 	struct ldlm_resource  *res = cfs_hash_object(hs, hnode);
 
 	lock_res(res);
-	CERROR("Namespace %s resource refcount nonzero "
-	       "(%d) after lock cleanup; forcing "
-	       "cleanup.\n",
-	       ldlm_ns_name(ldlm_res_to_ns(res)),
-	       atomic_read(&res->lr_refcount) - 1);
-
-	CERROR("Resource: %p ("LPU64"/"LPU64"/"LPU64"/"
-	       LPU64") (rc: %d)\n", res,
-	       res->lr_name.name[0], res->lr_name.name[1],
-	       res->lr_name.name[2], res->lr_name.name[3],
+	CERROR("%s: namespace resource "DLDLMRES
+	       " (%p) refcount nonzero (%d) after lock cleanup; forcing cleanup.\n",
+	       ldlm_ns_name(ldlm_res_to_ns(res)), PLDLMRES(res), res,
 	       atomic_read(&res->lr_refcount) - 1);
 
 	ldlm_resource_dump(D_ERROR, res);
@@ -1403,10 +1396,8 @@ void ldlm_resource_dump(int level, struct ldlm_resource *res)
 	if (!((libcfs_debug | D_ERROR) & level))
 		return;
 
-	CDEBUG(level, "--- Resource: %p ("LPU64"/"LPU64"/"LPU64"/"LPU64
-	       ") (rc: %d)\n", res, res->lr_name.name[0], res->lr_name.name[1],
-	       res->lr_name.name[2], res->lr_name.name[3],
-	       atomic_read(&res->lr_refcount));
+	CDEBUG(level, "--- Resource: "DLDLMRES" (%p) refcount = %d\n",
+	       PLDLMRES(res), res, atomic_read(&res->lr_refcount));
 
 	if (!list_empty(&res->lr_granted)) {
 		CDEBUG(level, "Granted locks (in reverse order):\n");
diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index 34815b5..8377468 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -233,12 +233,9 @@ int ll_md_blocking_ast(struct ldlm_lock *lock, struct ldlm_lock_desc *desc,
 			ll_have_md_lock(inode, &bits, mode);
 
 		fid = ll_inode2fid(inode);
-		if (lock->l_resource->lr_name.name[0] != fid_seq(fid) ||
-		    lock->l_resource->lr_name.name[1] != fid_oid(fid) ||
-		    lock->l_resource->lr_name.name[2] != fid_ver(fid)) {
+		if (!fid_res_name_eq(fid, &lock->l_resource->lr_name))
 			LDLM_ERROR(lock, "data mismatch with object "
 				   DFID" (%p)", PFID(fid), inode);
-		}
 
 		if (bits & MDS_INODELOCK_OPEN) {
 			int flags = 0;
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index eccbab7..09dee11 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -971,13 +971,8 @@ static int mdc_finish_intent_lock(struct obd_export *exp,
 
 		LASSERTF(fid_res_name_eq(&mdt_body->fid1,
 					 &lock->l_resource->lr_name),
-			 "Lock res_id: %lu/%lu/%lu, fid: %lu/%lu/%lu.\n",
-			 (unsigned long)lock->l_resource->lr_name.name[0],
-			 (unsigned long)lock->l_resource->lr_name.name[1],
-			 (unsigned long)lock->l_resource->lr_name.name[2],
-			 (unsigned long)fid_seq(&mdt_body->fid1),
-			 (unsigned long)fid_oid(&mdt_body->fid1),
-			 (unsigned long)fid_ver(&mdt_body->fid1));
+			 "Lock res_id: "DLDLMRES", fid: "DFID"\n",
+			 PLDLMRES(lock->l_resource), PFID(&mdt_body->fid1));
 		LDLM_LOCK_PUT(lock);
 
 		memcpy(&old_lock, lockh, sizeof(*lockh));
diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index 12a9ede..93b601d 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -788,8 +788,8 @@ static int mgc_blocking_ast(struct ldlm_lock *lock, struct ldlm_lock_desc *desc,
 		/* We've given up the lock, prepare ourselves to update. */
 		LDLM_DEBUG(lock, "MGC cancel CB");
 
-		CDEBUG(D_MGC, "Lock res "LPX64" (%.8s)\n",
-		       lock->l_resource->lr_name.name[0],
+		CDEBUG(D_MGC, "Lock res "DLDLMRES" (%.8s)\n",
+		       PLDLMRES(lock->l_resource),
 		       (char *)&lock->l_resource->lr_name.name[0]);
 
 		if (!cld) {
-- 
1.7.9.5

