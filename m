Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaFWBgL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:36:11 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39749 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbaFWBcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:32:48 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 04/18] staging/lustre: fix frong ldlm flags type used
Date: Sun, 22 Jun 2014 21:32:08 -0400
Message-Id: <1403487142-4880-5-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

Fixed implicit conversion from 'unsigned long long' to 'int'.

Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-on: http://review.whamcloud.com/7799
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4023
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_dlm.h |  2 +-
 drivers/staging/lustre/lustre/include/obd_class.h  |  2 +-
 drivers/staging/lustre/lustre/include/obd_ost.h    |  4 ++++
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |  2 +-
 drivers/staging/lustre/lustre/llite/file.c         |  6 +++---
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |  2 +-
 drivers/staging/lustre/lustre/lov/lov_internal.h   |  2 +-
 drivers/staging/lustre/lustre/lov/lov_request.c    | 10 +++-------
 drivers/staging/lustre/lustre/osc/osc_internal.h   |  2 +-
 drivers/staging/lustre/lustre/osc/osc_page.c       |  2 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    | 10 +++++-----
 11 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_dlm.h b/drivers/staging/lustre/lustre/include/lustre_dlm.h
index 0c6b784..bf5b2cb 100644
--- a/drivers/staging/lustre/lustre/include/lustre_dlm.h
+++ b/drivers/staging/lustre/lustre/include/lustre_dlm.h
@@ -1390,7 +1390,7 @@ int ldlm_cli_cancel_req(struct obd_export *exp, struct list_head *head,
 int ldlm_cancel_resource_local(struct ldlm_resource *res,
 			       struct list_head *cancels,
 			       ldlm_policy_data_t *policy,
-			       ldlm_mode_t mode, int lock_flags,
+			       ldlm_mode_t mode, __u64 lock_flags,
 			       ldlm_cancel_flags_t cancel_flags, void *opaque);
 int ldlm_cli_cancel_list_local(struct list_head *cancels, int count,
 			       ldlm_cancel_flags_t flags);
diff --git a/drivers/staging/lustre/lustre/include/obd_class.h b/drivers/staging/lustre/lustre/include/obd_class.h
index e265820..f8a9d7c 100644
--- a/drivers/staging/lustre/lustre/include/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/obd_class.h
@@ -1818,7 +1818,7 @@ static inline int md_enqueue(struct obd_export *exp,
 			     struct lustre_handle *lockh,
 			     void *lmm, int lmmsize,
 			     struct ptlrpc_request **req,
-			     int extra_lock_flags)
+			     __u64 extra_lock_flags)
 {
 	int rc;
 
diff --git a/drivers/staging/lustre/lustre/include/obd_ost.h b/drivers/staging/lustre/lustre/include/obd_ost.h
index af89843..54ef540 100644
--- a/drivers/staging/lustre/lustre/include/obd_ost.h
+++ b/drivers/staging/lustre/lustre/include/obd_ost.h
@@ -87,6 +87,10 @@ struct osc_enqueue_args {
 	unsigned int	      oa_agl:1;
 };
 
+extern void osc_update_enqueue(struct lustre_handle *lov_lockhp,
+			       struct lov_oinfo *loi, __u64 flags,
+			       struct ost_lvb *lvb, __u32 mode, int rc);
+
 #if 0
 int osc_extent_blocking_cb(struct ldlm_lock *lock,
 			   struct ldlm_lock_desc *new, void *data,
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
index fcc7a99..3accbce 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
@@ -1768,7 +1768,7 @@ int ldlm_cancel_lru(struct ldlm_namespace *ns, int nr,
 int ldlm_cancel_resource_local(struct ldlm_resource *res,
 			       struct list_head *cancels,
 			       ldlm_policy_data_t *policy,
-			       ldlm_mode_t mode, int lock_flags,
+			       ldlm_mode_t mode, __u64 lock_flags,
 			       ldlm_cancel_flags_t cancel_flags, void *opaque)
 {
 	struct ldlm_lock *lock;
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 716e1ee..660fd4d 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -290,7 +290,7 @@ static int ll_md_close(struct obd_export *md_exp, struct inode *inode,
 	   we can skip talking to MDS */
 	if (file->f_dentry->d_inode) { /* Can this ever be false? */
 		int lockmode;
-		int flags = LDLM_FL_BLOCK_GRANTED | LDLM_FL_TEST_LOCK;
+		__u64 flags = LDLM_FL_BLOCK_GRANTED | LDLM_FL_TEST_LOCK;
 		struct lustre_handle lockh;
 		struct inode *inode = file->f_dentry->d_inode;
 		ldlm_policy_data_t policy = {.l_inodebits={MDS_INODELOCK_OPEN}};
@@ -2623,7 +2623,7 @@ ll_file_flock(struct file *file, int cmd, struct file_lock *file_lock)
 	struct md_op_data *op_data;
 	struct lustre_handle lockh = {0};
 	ldlm_policy_data_t flock = {{0}};
-	int flags = 0;
+	__u64 flags = 0;
 	int rc;
 	int rc2 = 0;
 
@@ -2708,7 +2708,7 @@ ll_file_flock(struct file *file, int cmd, struct file_lock *file_lock)
 	if (IS_ERR(op_data))
 		return PTR_ERR(op_data);
 
-	CDEBUG(D_DLMTRACE, "inode=%lu, pid=%u, flags=%#x, mode=%u, "
+	CDEBUG(D_DLMTRACE, "inode=%lu, pid=%u, flags=%#llx, mode=%u, "
 	       "start="LPU64", end="LPU64"\n", inode->i_ino, flock.l_flock.pid,
 	       flags, einfo.ei_mode, flock.l_flock.start, flock.l_flock.end);
 
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index 4edf8a3..c17a49e 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -1715,7 +1715,7 @@ static int
 lmv_enqueue_remote(struct obd_export *exp, struct ldlm_enqueue_info *einfo,
 		   struct lookup_intent *it, struct md_op_data *op_data,
 		   struct lustre_handle *lockh, void *lmm, int lmmsize,
-		   int extra_lock_flags)
+		   __u64 extra_lock_flags)
 {
 	struct ptlrpc_request      *req = it->d.lustre.it_data;
 	struct obd_device	  *obd = exp->exp_obd;
diff --git a/drivers/staging/lustre/lustre/lov/lov_internal.h b/drivers/staging/lustre/lustre/lov/lov_internal.h
index 38508a5..2232643 100644
--- a/drivers/staging/lustre/lustre/lov/lov_internal.h
+++ b/drivers/staging/lustre/lustre/lov/lov_internal.h
@@ -252,7 +252,7 @@ int lov_prep_match_set(struct obd_export *exp, struct obd_info *oinfo,
 		       ldlm_policy_data_t *policy, __u32 mode,
 		       struct lustre_handle *lockh,
 		       struct lov_request_set **reqset);
-int lov_fini_match_set(struct lov_request_set *set, __u32 mode, int flags);
+int lov_fini_match_set(struct lov_request_set *set, __u32 mode, __u64 flags);
 int lov_prep_cancel_set(struct obd_export *exp, struct obd_info *oinfo,
 			struct lov_stripe_md *lsm,
 			__u32 mode, struct lustre_handle *lockh,
diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
index bd6490d..984f4c3 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -39,8 +39,8 @@
 #include <linux/libcfs/libcfs.h>
 
 #include <obd_class.h>
+#include <obd_ost.h>
 #include <lustre/lustre_idl.h>
-
 #include "lov_internal.h"
 
 static void lov_init_set(struct lov_request_set *set)
@@ -194,13 +194,9 @@ out:
 	return rc;
 }
 
-extern void osc_update_enqueue(struct lustre_handle *lov_lockhp,
-			       struct lov_oinfo *loi, int flags,
-			       struct ost_lvb *lvb, __u32 mode, int rc);
-
 static int lov_update_enqueue_lov(struct obd_export *exp,
 				  struct lustre_handle *lov_lockhp,
-				  struct lov_oinfo *loi, int flags, int idx,
+				  struct lov_oinfo *loi, __u64 flags, int idx,
 				  struct ost_id *oi, int rc)
 {
 	struct lov_obd *lov = &exp->exp_obd->u.lov;
@@ -443,7 +439,7 @@ out_set:
 	return rc;
 }
 
-int lov_fini_match_set(struct lov_request_set *set, __u32 mode, int flags)
+int lov_fini_match_set(struct lov_request_set *set, __u32 mode, __u64 flags)
 {
 	int rc = 0;
 
diff --git a/drivers/staging/lustre/lustre/osc/osc_internal.h b/drivers/staging/lustre/lustre/osc/osc_internal.h
index efc5db4..9c4a189 100644
--- a/drivers/staging/lustre/lustre/osc/osc_internal.h
+++ b/drivers/staging/lustre/lustre/osc/osc_internal.h
@@ -112,7 +112,7 @@ int osc_cancel_base(struct lustre_handle *lockh, __u32 mode);
 
 int osc_match_base(struct obd_export *exp, struct ldlm_res_id *res_id,
 		   __u32 type, ldlm_policy_data_t *policy, __u32 mode,
-		   int *flags, void *data, struct lustre_handle *lockh,
+		   __u64 *flags, void *data, struct lustre_handle *lockh,
 		   int unref);
 
 int osc_setattr_async_base(struct obd_export *exp, struct obd_info *oinfo,
diff --git a/drivers/staging/lustre/lustre/osc/osc_page.c b/drivers/staging/lustre/lustre/osc/osc_page.c
index 96cb6e2..71a2447 100644
--- a/drivers/staging/lustre/lustre/osc/osc_page.c
+++ b/drivers/staging/lustre/lustre/osc/osc_page.c
@@ -70,7 +70,7 @@ static int osc_page_is_dlocked(const struct lu_env *env,
 	struct lustre_handle   *lockh;
 	ldlm_policy_data_t     *policy;
 	ldlm_mode_t	     dlmmode;
-	int		     flags;
+	__u64                   flags;
 
 	might_sleep();
 
diff --git a/drivers/staging/lustre/lustre/osc/osc_request.c b/drivers/staging/lustre/lustre/osc/osc_request.c
index 294db84..5804104 100644
--- a/drivers/staging/lustre/lustre/osc/osc_request.c
+++ b/drivers/staging/lustre/lustre/osc/osc_request.c
@@ -635,7 +635,7 @@ static int osc_sync(const struct lu_env *env, struct obd_export *exp,
  * locks added to @cancels list. */
 static int osc_resource_get_unused(struct obd_export *exp, struct obdo *oa,
 				   struct list_head *cancels,
-				   ldlm_mode_t mode, int lock_flags)
+				   ldlm_mode_t mode, __u64 lock_flags)
 {
 	struct ldlm_namespace *ns = exp->exp_obd->obd_namespace;
 	struct ldlm_res_id res_id;
@@ -2398,7 +2398,7 @@ static int osc_enqueue_interpret(const struct lu_env *env,
 }
 
 void osc_update_enqueue(struct lustre_handle *lov_lockhp,
-			struct lov_oinfo *loi, int flags,
+			struct lov_oinfo *loi, __u64 flags,
 			struct ost_lvb *lvb, __u32 mode, int rc)
 {
 	struct ldlm_lock *lock = ldlm_handle2lock(lov_lockhp);
@@ -2462,7 +2462,7 @@ int osc_enqueue_base(struct obd_export *exp, struct ldlm_res_id *res_id,
 	struct obd_device *obd = exp->exp_obd;
 	struct ptlrpc_request *req = NULL;
 	int intent = *flags & LDLM_FL_HAS_INTENT;
-	int match_lvb = (agl != 0 ? 0 : LDLM_FL_LVB_READY);
+	__u64 match_lvb = (agl != 0 ? 0 : LDLM_FL_LVB_READY);
 	ldlm_mode_t mode;
 	int rc;
 
@@ -2613,11 +2613,11 @@ static int osc_enqueue(struct obd_export *exp, struct obd_info *oinfo,
 
 int osc_match_base(struct obd_export *exp, struct ldlm_res_id *res_id,
 		   __u32 type, ldlm_policy_data_t *policy, __u32 mode,
-		   int *flags, void *data, struct lustre_handle *lockh,
+		   __u64 *flags, void *data, struct lustre_handle *lockh,
 		   int unref)
 {
 	struct obd_device *obd = exp->exp_obd;
-	int lflags = *flags;
+	__u64 lflags = *flags;
 	ldlm_mode_t rc;
 
 	if (OBD_FAIL_CHECK(OBD_FAIL_OSC_MATCH))
-- 
1.9.0

