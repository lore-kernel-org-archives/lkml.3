Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab3KNQYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:24:16 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:39874 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab3KNQPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:15:33 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 17/40] staging/lustre/ptlrpc: Fix race during exp_flock_hash creation
Date: Fri, 15 Nov 2013 00:13:19 +0800
Message-Id: <1384445622-12346-18-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andriy Skulysh <Andriy_Skulysh@xyratex.com>

During race exp_flock_hash can be created 2 times.
It is created & assigned without any lock.

Move hash initialization from ldlm_flock_blocking_link()
to ldlm_init_export()

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2835
Lustre-change: http://review.whamcloud.com/5471
Signed-off-by: Andriy Skulysh <Andriy_Skulysh@xyratex.com>
Reviewed-by: Alexander Boyko <Alexander_Boyko@xyratex.com>
Reviewed-by: Vitaly Fertman <Vitaly_Fertman@xyratex.com>
Tested-by: Kyrylo Shatskyy <kyrylo_shatskyy@xyratex.com>
Reviewed-by: Keith Mannthey <keith.mannthey@intel.com>
Reviewed-by: Prakash Surya <surya1@llnl.gov>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c |   28 +++++++----------------
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c |    8 +++++++
 2 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
index 39fcdac..182773b 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
@@ -95,20 +95,12 @@ ldlm_flocks_overlap(struct ldlm_lock *lock, struct ldlm_lock *new)
 		lock->l_policy_data.l_flock.start));
 }
 
-static inline int ldlm_flock_blocking_link(struct ldlm_lock *req,
-					   struct ldlm_lock *lock)
+static inline void ldlm_flock_blocking_link(struct ldlm_lock *req,
+					    struct ldlm_lock *lock)
 {
-	int rc = 0;
-
 	/* For server only */
 	if (req->l_export == NULL)
-		return 0;
-
-	if (unlikely(req->l_export->exp_flock_hash == NULL)) {
-		rc = ldlm_init_flock_export(req->l_export);
-		if (rc)
-			goto error;
-	}
+		return;
 
 	LASSERT(hlist_unhashed(&req->l_exp_flock_hash));
 
@@ -121,8 +113,6 @@ static inline int ldlm_flock_blocking_link(struct ldlm_lock *req,
 	cfs_hash_add(req->l_export->exp_flock_hash,
 		     &req->l_policy_data.l_flock.owner,
 		     &req->l_exp_flock_hash);
-error:
-	return rc;
 }
 
 static inline void ldlm_flock_blocking_unlink(struct ldlm_lock *req)
@@ -250,7 +240,6 @@ ldlm_process_flock_lock(struct ldlm_lock *req, __u64 *flags, int first_enq,
 	int overlaps = 0;
 	int splitted = 0;
 	const struct ldlm_callback_suite null_cbs = { NULL };
-	int rc;
 
 	CDEBUG(D_DLMTRACE, "flags %#llx owner "LPU64" pid %u mode %u start "
 	       LPU64" end "LPU64"\n", *flags,
@@ -328,12 +317,8 @@ reprocess:
 
 			/* add lock to blocking list before deadlock
 			 * check to prevent race */
-			rc = ldlm_flock_blocking_link(req, lock);
-			if (rc) {
-				ldlm_flock_destroy(req, mode, *flags);
-				*err = rc;
-				return LDLM_ITER_STOP;
-			}
+			ldlm_flock_blocking_link(req, lock);
+
 			if (ldlm_flock_deadlock(req, lock)) {
 				ldlm_flock_blocking_unlink(req);
 				ldlm_flock_destroy(req, mode, *flags);
@@ -816,6 +801,9 @@ static cfs_hash_ops_t ldlm_export_flock_ops = {
 
 int ldlm_init_flock_export(struct obd_export *exp)
 {
+	if( strcmp(exp->exp_obd->obd_type->typ_name, LUSTRE_MDT_NAME) != 0)
+		return 0;
+
 	exp->exp_flock_hash =
 		cfs_hash_create(obd_uuid2str(&exp->exp_client_uuid),
 				HASH_EXP_LOCK_CUR_BITS,
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
index 40c58b7..ae08483 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
@@ -964,6 +964,7 @@ static cfs_hash_ops_t ldlm_export_lock_ops = {
 
 int ldlm_init_export(struct obd_export *exp)
 {
+	int rc;
 	exp->exp_lock_hash =
 		cfs_hash_create(obd_uuid2str(&exp->exp_client_uuid),
 				HASH_EXP_LOCK_CUR_BITS,
@@ -977,7 +978,14 @@ int ldlm_init_export(struct obd_export *exp)
 	if (!exp->exp_lock_hash)
 		return -ENOMEM;
 
+	rc = ldlm_init_flock_export(exp);
+	if (rc)
+		GOTO(err, rc);
+
 	return 0;
+err:
+	ldlm_destroy_export(exp);
+	return rc;
 }
 EXPORT_SYMBOL(ldlm_init_export);
 
-- 
1.7.9.5

