Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaIEUI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:08:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:23882 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbaIEUIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:08:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,474,1406617200"; 
   d="scan'208";a="598712397"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 01/12] staging/lustre/lov: remove unused OBD methods
Date: Fri, 5 Sep 2014 15:08:07 -0500
Message-ID: <1409947698-30781-2-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409947698-30781-1-git-send-email-john.hammond@intel.com>
References: <1409947698-30781-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.108]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Remove the unused OBD device methods:
    lov_brw()
    lov_cancel()
    lov_cancel_unused()
    lov_change_cbdata()
    lov_enqueue()
    lov_extent_calc()
    lov_getattr()
    lov_merge_lvb()
    lov_punch()
    lov_setattr()
    lov_sync()
and their supporting functions.

In lov_iocontrol() remove the unused cases LL_IOC_LOV_SETSTRIPE and
LL_IOC_LOV_SETEA and their supporting functions.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 drivers/staging/lustre/lustre/lov/lov_internal.h |   45 --
 drivers/staging/lustre/lustre/lov/lov_merge.c    |   27 -
 drivers/staging/lustre/lustre/lov/lov_obd.c      |  530 ---------------
 drivers/staging/lustre/lustre/lov/lov_pack.c     |  172 -----
 drivers/staging/lustre/lustre/lov/lov_request.c  |  783 ----------------------
 5 files changed, 1557 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lov/lov_internal.h b/drivers/staging/lustre/lustre/lov/lov_internal.h
index c61db3a..8c8508b 100644
--- a/drivers/staging/lustre/lustre/lov/lov_internal.h
+++ b/drivers/staging/lustre/lustre/lov/lov_internal.h
@@ -168,8 +168,6 @@ static inline void lov_llh_put(struct lov_lock_handles *llh)
 /* lov_merge.c */
 void lov_merge_attrs(struct obdo *tgt, struct obdo *src, u64 valid,
 		     struct lov_stripe_md *lsm, int stripeno, int *set);
-int lov_merge_lvb(struct obd_export *exp, struct lov_stripe_md *lsm,
-		  struct ost_lvb *lvb, int kms_only);
 int lov_adjust_kms(struct obd_export *exp, struct lov_stripe_md *lsm,
 		   u64 size, int shrink);
 int lov_merge_lvb_kms(struct lov_stripe_md *lsm,
@@ -207,17 +205,6 @@ void lov_update_set(struct lov_request_set *set,
 int lov_update_common_set(struct lov_request_set *set,
 			  struct lov_request *req, int rc);
 int lov_check_and_wait_active(struct lov_obd *lov, int ost_idx);
-int lov_prep_create_set(struct obd_export *exp, struct obd_info *oifo,
-			struct lov_stripe_md **ea, struct obdo *src_oa,
-			struct obd_trans_info *oti,
-			struct lov_request_set **reqset);
-int cb_create_update(void *cookie, int rc);
-int lov_fini_create_set(struct lov_request_set *set, struct lov_stripe_md **ea);
-int lov_prep_brw_set(struct obd_export *exp, struct obd_info *oinfo,
-		     u32 oa_bufs, struct brw_page *pga,
-		     struct obd_trans_info *oti,
-		     struct lov_request_set **reqset);
-int lov_fini_brw_set(struct lov_request_set *set);
 int lov_prep_getattr_set(struct obd_export *exp, struct obd_info *oinfo,
 			 struct lov_request_set **reqset);
 int lov_fini_getattr_set(struct lov_request_set *set);
@@ -225,8 +212,6 @@ int lov_prep_destroy_set(struct obd_export *exp, struct obd_info *oinfo,
 			 struct obdo *src_oa, struct lov_stripe_md *lsm,
 			 struct obd_trans_info *oti,
 			 struct lov_request_set **reqset);
-int lov_update_destroy_set(struct lov_request_set *set,
-			   struct lov_request *req, int rc);
 int lov_fini_destroy_set(struct lov_request_set *set);
 int lov_prep_setattr_set(struct obd_export *exp, struct obd_info *oinfo,
 			 struct obd_trans_info *oti,
@@ -234,30 +219,6 @@ int lov_prep_setattr_set(struct obd_export *exp, struct obd_info *oinfo,
 int lov_update_setattr_set(struct lov_request_set *set,
 			   struct lov_request *req, int rc);
 int lov_fini_setattr_set(struct lov_request_set *set);
-int lov_prep_punch_set(struct obd_export *exp, struct obd_info *oinfo,
-		       struct obd_trans_info *oti,
-		       struct lov_request_set **reqset);
-int lov_fini_punch_set(struct lov_request_set *set);
-int lov_prep_sync_set(struct obd_export *exp, struct obd_info *obd_info,
-		      u64 start, u64 end,
-		      struct lov_request_set **reqset);
-int lov_fini_sync_set(struct lov_request_set *set);
-int lov_prep_enqueue_set(struct obd_export *exp, struct obd_info *oinfo,
-			 struct ldlm_enqueue_info *einfo,
-			 struct lov_request_set **reqset);
-int lov_fini_enqueue_set(struct lov_request_set *set, __u32 mode, int rc,
-			 struct ptlrpc_request_set *rqset);
-int lov_prep_match_set(struct obd_export *exp, struct obd_info *oinfo,
-		       struct lov_stripe_md *lsm,
-		       ldlm_policy_data_t *policy, __u32 mode,
-		       struct lustre_handle *lockh,
-		       struct lov_request_set **reqset);
-int lov_fini_match_set(struct lov_request_set *set, __u32 mode, __u64 flags);
-int lov_prep_cancel_set(struct obd_export *exp, struct obd_info *oinfo,
-			struct lov_stripe_md *lsm,
-			__u32 mode, struct lustre_handle *lockh,
-			struct lov_request_set **reqset);
-int lov_fini_cancel_set(struct lov_request_set *set);
 int lov_prep_statfs_set(struct obd_device *obd, struct obd_info *oinfo,
 			struct lov_request_set **reqset);
 void lov_update_statfs(struct obd_statfs *osfs, struct obd_statfs *lov_sfs,
@@ -287,10 +248,6 @@ int lov_packmd(struct obd_export *exp, struct lov_mds_md **lmm,
 	       struct lov_stripe_md *lsm);
 int lov_unpackmd(struct obd_export *exp, struct lov_stripe_md **lsmp,
 		 struct lov_mds_md *lmm, int lmm_bytes);
-int lov_setstripe(struct obd_export *exp, int max_lmm_size,
-		  struct lov_stripe_md **lsmp, struct lov_user_md *lump);
-int lov_setea(struct obd_export *exp, struct lov_stripe_md **lsmp,
-	      struct lov_user_md *lump);
 int lov_getstripe(struct obd_export *exp,
 		  struct lov_stripe_md *lsm, struct lov_user_md *lump);
 int lov_alloc_memmd(struct lov_stripe_md **lsmp, __u16 stripe_count,
@@ -307,8 +264,6 @@ struct lov_stripe_md *lsm_alloc_plain(__u16 stripe_count, int *size);
 void lsm_free_plain(struct lov_stripe_md *lsm);
 void dump_lsm(unsigned int level, const struct lov_stripe_md *lsm);
 
-int lovea_destroy_object(struct lov_obd *lov, struct lov_stripe_md *lsm,
-			 struct obdo *oa, void *data);
 /* lproc_lov.c */
 #if defined (CONFIG_PROC_FS)
 extern const struct file_operations lov_proc_target_fops;
diff --git a/drivers/staging/lustre/lustre/lov/lov_merge.c b/drivers/staging/lustre/lustre/lov/lov_merge.c
index 15ebb5d..b7e7bfa 100644
--- a/drivers/staging/lustre/lustre/lov/lov_merge.c
+++ b/drivers/staging/lustre/lustre/lov/lov_merge.c
@@ -109,33 +109,6 @@ int lov_merge_lvb_kms(struct lov_stripe_md *lsm,
 	return rc;
 }
 
-/** Merge the lock value block(&lvb) attributes from each of the stripes in a
- * file into a single lvb. It is expected that the caller initializes the
- * current atime, mtime, ctime to avoid regressing a more uptodate time on
- * the local client.
- *
- * If \a kms_only is set then we do not consider the recently seen size (rss)
- * when updating the known minimum size (kms).  Even when merging RSS, we will
- * take the KMS value if it's larger.  This prevents getattr from stomping on
- * dirty cached pages which extend the file size. */
-int lov_merge_lvb(struct obd_export *exp,
-		  struct lov_stripe_md *lsm, struct ost_lvb *lvb, int kms_only)
-{
-	int   rc;
-	__u64 kms;
-
-	lov_stripe_lock(lsm);
-	rc = lov_merge_lvb_kms(lsm, lvb, &kms);
-	lov_stripe_unlock(lsm);
-	if (kms_only)
-		lvb->lvb_size = kms;
-
-	CDEBUG(D_INODE, "merged for ID "DOSTID" s=%llu m=%llu a=%llu c=%llu b=%llu\n",
-	       POSTID(&lsm->lsm_oi), lvb->lvb_size, lvb->lvb_mtime,
-	       lvb->lvb_atime, lvb->lvb_ctime, lvb->lvb_blocks);
-	return rc;
-}
-
 /* Must be called under the lov_stripe_lock() */
 int lov_adjust_kms(struct obd_export *exp, struct lov_stripe_md *lsm,
 		   u64 size, int shrink)
diff --git a/drivers/staging/lustre/lustre/lov/lov_obd.c b/drivers/staging/lustre/lustre/lov/lov_obd.c
index cb778df..a1f8c7e 100644
--- a/drivers/staging/lustre/lustre/lov/lov_obd.c
+++ b/drivers/staging/lustre/lustre/lov/lov_obd.c
@@ -1113,54 +1113,6 @@ out:
 	return rc ? rc : err;
 }
 
-static int lov_getattr(const struct lu_env *env, struct obd_export *exp,
-		       struct obd_info *oinfo)
-{
-	struct lov_request_set *set;
-	struct lov_request *req;
-	struct list_head *pos;
-	struct lov_obd *lov;
-	int err = 0, rc = 0;
-
-	LASSERT(oinfo);
-	ASSERT_LSM_MAGIC(oinfo->oi_md);
-
-	if (!exp || !exp->exp_obd)
-		return -ENODEV;
-
-	lov = &exp->exp_obd->u.lov;
-
-	rc = lov_prep_getattr_set(exp, oinfo, &set);
-	if (rc)
-		return rc;
-
-	list_for_each(pos, &set->set_list) {
-		req = list_entry(pos, struct lov_request, rq_link);
-
-		CDEBUG(D_INFO, "objid "DOSTID"[%d] has subobj "DOSTID" at idx"
-		       " %u\n", POSTID(&oinfo->oi_oa->o_oi), req->rq_stripe,
-		       POSTID(&req->rq_oi.oi_oa->o_oi), req->rq_idx);
-
-		rc = obd_getattr(env, lov->lov_tgts[req->rq_idx]->ltd_exp,
-				 &req->rq_oi);
-		err = lov_update_common_set(set, req, rc);
-		if (err) {
-			CERROR("%s: getattr objid "DOSTID" subobj "
-			       DOSTID" on OST idx %d: rc = %d\n",
-			       exp->exp_obd->obd_name,
-			       POSTID(&oinfo->oi_oa->o_oi),
-			       POSTID(&req->rq_oi.oi_oa->o_oi),
-			       req->rq_idx, err);
-			break;
-		}
-	}
-
-	rc = lov_fini_getattr_set(set);
-	if (err)
-		rc = err;
-	return rc;
-}
-
 static int lov_getattr_interpret(struct ptlrpc_request_set *rqset,
 				 void *data, int rc)
 {
@@ -1232,57 +1184,6 @@ out:
 	return rc ? rc : err;
 }
 
-static int lov_setattr(const struct lu_env *env, struct obd_export *exp,
-		       struct obd_info *oinfo, struct obd_trans_info *oti)
-{
-	struct lov_request_set *set;
-	struct lov_obd *lov;
-	struct list_head *pos;
-	struct lov_request *req;
-	int err = 0, rc = 0;
-
-	LASSERT(oinfo);
-	ASSERT_LSM_MAGIC(oinfo->oi_md);
-
-	if (!exp || !exp->exp_obd)
-		return -ENODEV;
-
-	/* for now, we only expect the following updates here */
-	LASSERT(!(oinfo->oi_oa->o_valid & ~(OBD_MD_FLID | OBD_MD_FLTYPE |
-					    OBD_MD_FLMODE | OBD_MD_FLATIME |
-					    OBD_MD_FLMTIME | OBD_MD_FLCTIME |
-					    OBD_MD_FLFLAGS | OBD_MD_FLSIZE |
-					    OBD_MD_FLGROUP | OBD_MD_FLUID |
-					    OBD_MD_FLGID | OBD_MD_FLFID |
-					    OBD_MD_FLGENER)));
-	lov = &exp->exp_obd->u.lov;
-	rc = lov_prep_setattr_set(exp, oinfo, oti, &set);
-	if (rc)
-		return rc;
-
-	list_for_each(pos, &set->set_list) {
-		req = list_entry(pos, struct lov_request, rq_link);
-
-		rc = obd_setattr(env, lov->lov_tgts[req->rq_idx]->ltd_exp,
-				 &req->rq_oi, NULL);
-		err = lov_update_setattr_set(set, req, rc);
-		if (err) {
-			CERROR("%s: setattr objid "DOSTID" subobj "
-			       DOSTID" on OST idx %d: rc = %d\n",
-			       exp->exp_obd->obd_name,
-			       POSTID(&set->set_oi->oi_oa->o_oi),
-			       POSTID(&req->rq_oi.oi_oa->o_oi), req->rq_idx,
-			       err);
-			if (!rc)
-				rc = err;
-		}
-	}
-	err = lov_fini_setattr_set(set);
-	if (!rc)
-		rc = err;
-	return rc;
-}
-
 static int lov_setattr_interpret(struct ptlrpc_request_set *rqset,
 				 void *data, int rc)
 {
@@ -1365,297 +1266,6 @@ static int lov_setattr_async(struct obd_export *exp, struct obd_info *oinfo,
 	return 0;
 }
 
-static int lov_punch_interpret(struct ptlrpc_request_set *rqset,
-			       void *data, int rc)
-{
-	struct lov_request_set *lovset = (struct lov_request_set *)data;
-	int err;
-
-	if (rc)
-		atomic_set(&lovset->set_completes, 0);
-	err = lov_fini_punch_set(lovset);
-	return rc ? rc : err;
-}
-
-/* FIXME: maybe we'll just make one node the authoritative attribute node, then
- * we can send this 'punch' to just the authoritative node and the nodes
- * that the punch will affect. */
-static int lov_punch(const struct lu_env *env, struct obd_export *exp,
-		     struct obd_info *oinfo, struct obd_trans_info *oti,
-		     struct ptlrpc_request_set *rqset)
-{
-	struct lov_request_set *set;
-	struct lov_obd *lov;
-	struct list_head *pos;
-	struct lov_request *req;
-	int rc = 0;
-
-	LASSERT(oinfo);
-	ASSERT_LSM_MAGIC(oinfo->oi_md);
-
-	if (!exp || !exp->exp_obd)
-		return -ENODEV;
-
-	lov = &exp->exp_obd->u.lov;
-	rc = lov_prep_punch_set(exp, oinfo, oti, &set);
-	if (rc)
-		return rc;
-
-	list_for_each(pos, &set->set_list) {
-		req = list_entry(pos, struct lov_request, rq_link);
-
-		rc = obd_punch(env, lov->lov_tgts[req->rq_idx]->ltd_exp,
-			       &req->rq_oi, NULL, rqset);
-		if (rc) {
-			CERROR("%s: punch objid "DOSTID" subobj "DOSTID
-			       " on OST idx %d: rc = %d\n",
-			       exp->exp_obd->obd_name,
-			       POSTID(&set->set_oi->oi_oa->o_oi),
-			       POSTID(&req->rq_oi.oi_oa->o_oi), req->rq_idx, rc);
-			break;
-		}
-	}
-
-	if (rc || list_empty(&rqset->set_requests)) {
-		int err;
-		err = lov_fini_punch_set(set);
-		return rc ? rc : err;
-	}
-
-	LASSERT(rqset->set_interpret == NULL);
-	rqset->set_interpret = lov_punch_interpret;
-	rqset->set_arg = (void *)set;
-
-	return 0;
-}
-
-static int lov_sync_interpret(struct ptlrpc_request_set *rqset,
-			      void *data, int rc)
-{
-	struct lov_request_set *lovset = data;
-	int err;
-
-	if (rc)
-		atomic_set(&lovset->set_completes, 0);
-	err = lov_fini_sync_set(lovset);
-	return rc ?: err;
-}
-
-static int lov_sync(const struct lu_env *env, struct obd_export *exp,
-		    struct obd_info *oinfo, u64 start, u64 end,
-		    struct ptlrpc_request_set *rqset)
-{
-	struct lov_request_set *set = NULL;
-	struct lov_obd *lov;
-	struct list_head *pos;
-	struct lov_request *req;
-	int rc = 0;
-
-	ASSERT_LSM_MAGIC(oinfo->oi_md);
-	LASSERT(rqset != NULL);
-
-	if (!exp->exp_obd)
-		return -ENODEV;
-
-	lov = &exp->exp_obd->u.lov;
-	rc = lov_prep_sync_set(exp, oinfo, start, end, &set);
-	if (rc)
-		return rc;
-
-	CDEBUG(D_INFO, "fsync objid "DOSTID" [%#llx, %#llx]\n",
-	       POSTID(&set->set_oi->oi_oa->o_oi), start, end);
-
-	list_for_each(pos, &set->set_list) {
-		req = list_entry(pos, struct lov_request, rq_link);
-
-		rc = obd_sync(env, lov->lov_tgts[req->rq_idx]->ltd_exp,
-			      &req->rq_oi, req->rq_oi.oi_policy.l_extent.start,
-			      req->rq_oi.oi_policy.l_extent.end, rqset);
-		if (rc) {
-			CERROR("%s: fsync objid "DOSTID" subobj "DOSTID
-			       " on OST idx %d: rc = %d\n",
-			       exp->exp_obd->obd_name,
-			       POSTID(&set->set_oi->oi_oa->o_oi),
-			       POSTID(&req->rq_oi.oi_oa->o_oi), req->rq_idx,
-			       rc);
-			break;
-		}
-	}
-
-	/* If we are not waiting for responses on async requests, return. */
-	if (rc || list_empty(&rqset->set_requests)) {
-		int err = lov_fini_sync_set(set);
-
-		return rc ?: err;
-	}
-
-	LASSERT(rqset->set_interpret == NULL);
-	rqset->set_interpret = lov_sync_interpret;
-	rqset->set_arg = (void *)set;
-
-	return 0;
-}
-
-static int lov_brw_check(struct lov_obd *lov, struct obd_info *lov_oinfo,
-			 u32 oa_bufs, struct brw_page *pga)
-{
-	struct obd_info oinfo = { { { 0 } } };
-	int i, rc = 0;
-
-	oinfo.oi_oa = lov_oinfo->oi_oa;
-
-	/* The caller just wants to know if there's a chance that this
-	 * I/O can succeed */
-	for (i = 0; i < oa_bufs; i++) {
-		int stripe = lov_stripe_number(lov_oinfo->oi_md, pga[i].off);
-		int ost = lov_oinfo->oi_md->lsm_oinfo[stripe]->loi_ost_idx;
-		u64 start, end;
-
-		if (!lov_stripe_intersects(lov_oinfo->oi_md, i, pga[i].off,
-					   pga[i].off + pga[i].count - 1,
-					   &start, &end))
-			continue;
-
-		if (!lov->lov_tgts[ost] || !lov->lov_tgts[ost]->ltd_active) {
-			CDEBUG(D_HA, "lov idx %d inactive\n", ost);
-			return -EIO;
-		}
-
-		rc = obd_brw(OBD_BRW_CHECK, lov->lov_tgts[ost]->ltd_exp, &oinfo,
-			     1, &pga[i], NULL);
-		if (rc)
-			break;
-	}
-	return rc;
-}
-
-static int lov_brw(int cmd, struct obd_export *exp, struct obd_info *oinfo,
-		   u32 oa_bufs, struct brw_page *pga,
-		   struct obd_trans_info *oti)
-{
-	struct lov_request_set *set;
-	struct lov_request *req;
-	struct list_head *pos;
-	struct lov_obd *lov = &exp->exp_obd->u.lov;
-	int err, rc = 0;
-
-	ASSERT_LSM_MAGIC(oinfo->oi_md);
-
-	if (cmd == OBD_BRW_CHECK) {
-		rc = lov_brw_check(lov, oinfo, oa_bufs, pga);
-		return rc;
-	}
-
-	rc = lov_prep_brw_set(exp, oinfo, oa_bufs, pga, oti, &set);
-	if (rc)
-		return rc;
-
-	list_for_each(pos, &set->set_list) {
-		struct obd_export *sub_exp;
-		struct brw_page *sub_pga;
-		req = list_entry(pos, struct lov_request, rq_link);
-
-		sub_exp = lov->lov_tgts[req->rq_idx]->ltd_exp;
-		sub_pga = set->set_pga + req->rq_pgaidx;
-		rc = obd_brw(cmd, sub_exp, &req->rq_oi, req->rq_oabufs,
-			     sub_pga, oti);
-		if (rc)
-			break;
-		lov_update_common_set(set, req, rc);
-	}
-
-	err = lov_fini_brw_set(set);
-	if (!rc)
-		rc = err;
-	return rc;
-}
-
-static int lov_enqueue_interpret(struct ptlrpc_request_set *rqset,
-				 void *data, int rc)
-{
-	struct lov_request_set *lovset = (struct lov_request_set *)data;
-
-	rc = lov_fini_enqueue_set(lovset, lovset->set_ei->ei_mode, rc, rqset);
-	return rc;
-}
-
-static int lov_enqueue(struct obd_export *exp, struct obd_info *oinfo,
-		       struct ldlm_enqueue_info *einfo,
-		       struct ptlrpc_request_set *rqset)
-{
-	ldlm_mode_t mode = einfo->ei_mode;
-	struct lov_request_set *set;
-	struct lov_request *req;
-	struct list_head *pos;
-	struct lov_obd *lov;
-	ldlm_error_t rc;
-
-	LASSERT(oinfo);
-	ASSERT_LSM_MAGIC(oinfo->oi_md);
-	LASSERT(mode == (mode & -mode));
-
-	/* we should never be asked to replay a lock this way. */
-	LASSERT((oinfo->oi_flags & LDLM_FL_REPLAY) == 0);
-
-	if (!exp || !exp->exp_obd)
-		return -ENODEV;
-
-	lov = &exp->exp_obd->u.lov;
-	rc = lov_prep_enqueue_set(exp, oinfo, einfo, &set);
-	if (rc)
-		return rc;
-
-	list_for_each(pos, &set->set_list) {
-		req = list_entry(pos, struct lov_request, rq_link);
-
-		rc = obd_enqueue(lov->lov_tgts[req->rq_idx]->ltd_exp,
-				 &req->rq_oi, einfo, rqset);
-		if (rc != ELDLM_OK)
-			GOTO(out, rc);
-	}
-
-	if (rqset && !list_empty(&rqset->set_requests)) {
-		LASSERT(rc == 0);
-		LASSERT(rqset->set_interpret == NULL);
-		rqset->set_interpret = lov_enqueue_interpret;
-		rqset->set_arg = (void *)set;
-		return rc;
-	}
-out:
-	rc = lov_fini_enqueue_set(set, mode, rc, rqset);
-	return rc;
-}
-
-static int lov_change_cbdata(struct obd_export *exp,
-			     struct lov_stripe_md *lsm, ldlm_iterator_t it,
-			     void *data)
-{
-	struct lov_obd *lov;
-	int rc = 0, i;
-
-	ASSERT_LSM_MAGIC(lsm);
-
-	if (!exp || !exp->exp_obd)
-		return -ENODEV;
-
-	lov = &exp->exp_obd->u.lov;
-	for (i = 0; i < lsm->lsm_stripe_count; i++) {
-		struct lov_stripe_md submd;
-		struct lov_oinfo *loi = lsm->lsm_oinfo[i];
-
-		if (!lov->lov_tgts[loi->loi_ost_idx]) {
-			CDEBUG(D_HA, "lov idx %d NULL \n", loi->loi_ost_idx);
-			continue;
-		}
-
-		submd.lsm_oi = loi->loi_oi;
-		submd.lsm_stripe_count = 0;
-		rc = obd_change_cbdata(lov->lov_tgts[loi->loi_ost_idx]->ltd_exp,
-				       &submd, it, data);
-	}
-	return rc;
-}
-
 /* find any ldlm lock of the inode in lov
  * return 0    not find
  *	1    find one
@@ -1691,106 +1301,6 @@ static int lov_find_cbdata(struct obd_export *exp,
 	return rc;
 }
 
-static int lov_cancel(struct obd_export *exp, struct lov_stripe_md *lsm,
-		      __u32 mode, struct lustre_handle *lockh)
-{
-	struct lov_request_set *set;
-	struct obd_info oinfo;
-	struct lov_request *req;
-	struct list_head *pos;
-	struct lov_obd *lov;
-	struct lustre_handle *lov_lockhp;
-	int err = 0, rc = 0;
-
-	ASSERT_LSM_MAGIC(lsm);
-
-	if (!exp || !exp->exp_obd)
-		return -ENODEV;
-
-	LASSERT(lockh);
-	lov = &exp->exp_obd->u.lov;
-	rc = lov_prep_cancel_set(exp, &oinfo, lsm, mode, lockh, &set);
-	if (rc)
-		return rc;
-
-	list_for_each(pos, &set->set_list) {
-		req = list_entry(pos, struct lov_request, rq_link);
-		lov_lockhp = set->set_lockh->llh_handles + req->rq_stripe;
-
-		rc = obd_cancel(lov->lov_tgts[req->rq_idx]->ltd_exp,
-				req->rq_oi.oi_md, mode, lov_lockhp);
-		rc = lov_update_common_set(set, req, rc);
-		if (rc) {
-			CERROR("%s: cancel objid "DOSTID" subobj "
-			       DOSTID" on OST idx %d: rc = %d\n",
-			       exp->exp_obd->obd_name, POSTID(&lsm->lsm_oi),
-			       POSTID(&req->rq_oi.oi_md->lsm_oi),
-			       req->rq_idx, rc);
-			err = rc;
-		}
-
-	}
-	lov_fini_cancel_set(set);
-	return err;
-}
-
-static int lov_cancel_unused(struct obd_export *exp,
-			     struct lov_stripe_md *lsm,
-			     ldlm_cancel_flags_t flags, void *opaque)
-{
-	struct lov_obd *lov;
-	int rc = 0, i;
-
-	if (!exp || !exp->exp_obd)
-		return -ENODEV;
-
-	lov = &exp->exp_obd->u.lov;
-	if (lsm == NULL) {
-		for (i = 0; i < lov->desc.ld_tgt_count; i++) {
-			int err;
-			if (!lov->lov_tgts[i] || !lov->lov_tgts[i]->ltd_exp)
-				continue;
-
-			err = obd_cancel_unused(lov->lov_tgts[i]->ltd_exp, NULL,
-						flags, opaque);
-			if (!rc)
-				rc = err;
-		}
-		return rc;
-	}
-
-	ASSERT_LSM_MAGIC(lsm);
-
-	for (i = 0; i < lsm->lsm_stripe_count; i++) {
-		struct lov_stripe_md submd;
-		struct lov_oinfo *loi = lsm->lsm_oinfo[i];
-		int idx = loi->loi_ost_idx;
-		int err;
-
-		if (!lov->lov_tgts[idx]) {
-			CDEBUG(D_HA, "lov idx %d NULL\n", idx);
-			continue;
-		}
-
-		if (!lov->lov_tgts[idx]->ltd_active)
-			CDEBUG(D_HA, "lov idx %d inactive\n", idx);
-
-		submd.lsm_oi = loi->loi_oi;
-		submd.lsm_stripe_count = 0;
-		err = obd_cancel_unused(lov->lov_tgts[idx]->ltd_exp,
-					&submd, flags, opaque);
-		if (err && lov->lov_tgts[idx]->ltd_active) {
-			CERROR("%s: cancel unused objid "DOSTID
-			       " subobj "DOSTID" on OST idx %d: rc = %d\n",
-			       exp->exp_obd->obd_name, POSTID(&lsm->lsm_oi),
-			       POSTID(&loi->loi_oi), idx, err);
-			if (!rc)
-				rc = err;
-		}
-	}
-	return rc;
-}
-
 int lov_statfs_interpret(struct ptlrpc_request_set *rqset, void *data, int rc)
 {
 	struct lov_request_set *lovset = (struct lov_request_set *)data;
@@ -1960,15 +1470,9 @@ static int lov_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 		obd_ioctl_freedata(buf, len);
 		break;
 	}
-	case LL_IOC_LOV_SETSTRIPE:
-		rc = lov_setstripe(exp, len, karg, uarg);
-		break;
 	case LL_IOC_LOV_GETSTRIPE:
 		rc = lov_getstripe(exp, karg, uarg);
 		break;
-	case LL_IOC_LOV_SETEA:
-		rc = lov_setea(exp, karg, uarg);
-		break;
 	case OBD_IOC_QUOTACTL: {
 		struct if_quotactl *qctl = karg;
 		struct lov_tgt_desc *tgt = NULL;
@@ -2625,29 +2129,6 @@ static int lov_set_info_async(const struct lu_env *env, struct obd_export *exp,
 	return rc;
 }
 
-static int lov_extent_calc(struct obd_export *exp, struct lov_stripe_md *lsm,
-			   int cmd, __u64 *offset)
-{
-	__u32 ssize = lsm->lsm_stripe_size;
-	__u64 start;
-
-	start = *offset;
-	lov_do_div64(start, ssize);
-	start = start * ssize;
-
-	CDEBUG(D_DLMTRACE, "offset %llu, stripe %u, start %llu, end %llu\n",
-	       *offset, ssize, start, start + ssize - 1);
-	if (cmd == OBD_CALC_STRIPE_END) {
-		*offset = start + ssize - 1;
-	} else if (cmd == OBD_CALC_STRIPE_START) {
-		*offset = start;
-	} else {
-		LBUG();
-	}
-
-	return 0;
-}
-
 void lov_stripe_lock(struct lov_stripe_md *md)
 {
 	LASSERT(md->lsm_lock_owner != current_pid());
@@ -2783,24 +2264,13 @@ struct obd_ops lov_obd_ops = {
 	.o_unpackmd	    = lov_unpackmd,
 	.o_create	      = lov_create,
 	.o_destroy	     = lov_destroy,
-	.o_getattr	     = lov_getattr,
 	.o_getattr_async       = lov_getattr_async,
-	.o_setattr	     = lov_setattr,
 	.o_setattr_async       = lov_setattr_async,
-	.o_brw		 = lov_brw,
-	.o_merge_lvb	   = lov_merge_lvb,
 	.o_adjust_kms	  = lov_adjust_kms,
-	.o_punch	       = lov_punch,
-	.o_sync		= lov_sync,
-	.o_enqueue	     = lov_enqueue,
-	.o_change_cbdata       = lov_change_cbdata,
 	.o_find_cbdata	 = lov_find_cbdata,
-	.o_cancel	      = lov_cancel,
-	.o_cancel_unused       = lov_cancel_unused,
 	.o_iocontrol	   = lov_iocontrol,
 	.o_get_info	    = lov_get_info,
 	.o_set_info_async      = lov_set_info_async,
-	.o_extent_calc	 = lov_extent_calc,
 	.o_notify	      = lov_notify,
 	.o_pool_new	    = lov_pool_new,
 	.o_pool_rem	    = lov_pool_remove,
diff --git a/drivers/staging/lustre/lustre/lov/lov_pack.c b/drivers/staging/lustre/lustre/lov/lov_pack.c
index 62ea223..db5ce8b 100644
--- a/drivers/staging/lustre/lustre/lov/lov_pack.c
+++ b/drivers/staging/lustre/lustre/lov/lov_pack.c
@@ -403,178 +403,6 @@ int lov_unpackmd(struct obd_export *exp,  struct lov_stripe_md **lsmp,
 	return lsm_size;
 }
 
-static int __lov_setstripe(struct obd_export *exp, int max_lmm_size,
-			   struct lov_stripe_md **lsmp,
-			   struct lov_user_md *lump)
-{
-	struct obd_device *obd = class_exp2obd(exp);
-	struct lov_obd *lov = &obd->u.lov;
-	char buffer[sizeof(struct lov_user_md_v3)];
-	struct lov_user_md_v3 *lumv3 = (struct lov_user_md_v3 *)&buffer[0];
-	struct lov_user_md_v1 *lumv1 = (struct lov_user_md_v1 *)&buffer[0];
-	int lmm_magic;
-	__u16 stripe_count;
-	int rc;
-	int cplen = 0;
-
-	rc = lov_lum_swab_if_needed(lumv3, &lmm_magic, lump);
-	if (rc)
-		return rc;
-
-	/* in the rest of the tests, as *lumv1 and lumv3 have the same
-	 * fields, we use lumv1 to avoid code duplication */
-
-	if (lumv1->lmm_pattern == 0) {
-		lumv1->lmm_pattern = lov->desc.ld_pattern ?
-			lov->desc.ld_pattern : LOV_PATTERN_RAID0;
-	}
-
-	if (lov_pattern(lumv1->lmm_pattern) != LOV_PATTERN_RAID0) {
-		CDEBUG(D_IOCTL, "bad userland stripe pattern: %#x\n",
-		       lumv1->lmm_pattern);
-		return -EINVAL;
-	}
-
-	/* 64kB is the largest common page size we see (ia64), and matches the
-	 * check in lfs */
-	if (lumv1->lmm_stripe_size & (LOV_MIN_STRIPE_SIZE - 1)) {
-		CDEBUG(D_IOCTL, "stripe size %u not multiple of %u, fixing\n",
-		       lumv1->lmm_stripe_size, LOV_MIN_STRIPE_SIZE);
-		lumv1->lmm_stripe_size = LOV_MIN_STRIPE_SIZE;
-	}
-
-	if ((lumv1->lmm_stripe_offset >= lov->desc.ld_tgt_count) &&
-	    (lumv1->lmm_stripe_offset !=
-	     (typeof(lumv1->lmm_stripe_offset))(-1))) {
-		CDEBUG(D_IOCTL, "stripe offset %u > number of OSTs %u\n",
-		       lumv1->lmm_stripe_offset, lov->desc.ld_tgt_count);
-		return -EINVAL;
-	}
-	stripe_count = lov_get_stripecnt(lov, lmm_magic,
-					 lumv1->lmm_stripe_count);
-
-	if (max_lmm_size) {
-		int max_stripes = (max_lmm_size -
-				   lov_mds_md_size(0, lmm_magic)) /
-				   sizeof(struct lov_ost_data_v1);
-		if (unlikely(max_stripes < stripe_count)) {
-			CDEBUG(D_IOCTL, "stripe count reset from %d to %d\n",
-			       stripe_count, max_stripes);
-			stripe_count = max_stripes;
-		}
-	}
-
-	if (lmm_magic == LOV_USER_MAGIC_V3) {
-		struct pool_desc *pool;
-
-		/* In the function below, .hs_keycmp resolves to
-		 * pool_hashkey_keycmp() */
-		/* coverity[overrun-buffer-val] */
-		pool = lov_find_pool(lov, lumv3->lmm_pool_name);
-		if (pool != NULL) {
-			if (lumv3->lmm_stripe_offset !=
-			    (typeof(lumv3->lmm_stripe_offset))(-1)) {
-				rc = lov_check_index_in_pool(
-					lumv3->lmm_stripe_offset, pool);
-				if (rc < 0) {
-					lov_pool_putref(pool);
-					return -EINVAL;
-				}
-			}
-
-			if (stripe_count > pool_tgt_count(pool))
-				stripe_count = pool_tgt_count(pool);
-
-			lov_pool_putref(pool);
-		}
-	}
-
-	if (lumv1->lmm_pattern & LOV_PATTERN_F_RELEASED)
-		stripe_count = 0;
-
-	rc = lov_alloc_memmd(lsmp, stripe_count, lumv1->lmm_pattern, lmm_magic);
-
-	if (rc >= 0) {
-		(*lsmp)->lsm_oinfo[0]->loi_ost_idx = lumv1->lmm_stripe_offset;
-		(*lsmp)->lsm_stripe_size = lumv1->lmm_stripe_size;
-		if (lmm_magic == LOV_USER_MAGIC_V3) {
-			cplen = strlcpy((*lsmp)->lsm_pool_name,
-					lumv3->lmm_pool_name,
-					sizeof((*lsmp)->lsm_pool_name));
-			if (cplen >= sizeof((*lsmp)->lsm_pool_name))
-				rc = -E2BIG;
-		}
-		rc = 0;
-	}
-
-	return rc;
-}
-
-/* Configure object striping information on a new file.
- *
- * @lmmu is a pointer to a user struct with one or more of the fields set to
- * indicate the application preference: lmm_stripe_count, lmm_stripe_size,
- * lmm_stripe_offset, and lmm_stripe_pattern.  lmm_magic must be LOV_MAGIC.
- * @lsmp is a pointer to an in-core stripe MD that needs to be filled in.
- */
-int lov_setstripe(struct obd_export *exp, int max_lmm_size,
-		  struct lov_stripe_md **lsmp, struct lov_user_md *lump)
-{
-	int rc;
-	mm_segment_t seg;
-
-	seg = get_fs();
-	set_fs(KERNEL_DS);
-
-	rc = __lov_setstripe(exp, max_lmm_size, lsmp, lump);
-	set_fs(seg);
-	return rc;
-}
-
-int lov_setea(struct obd_export *exp, struct lov_stripe_md **lsmp,
-	      struct lov_user_md *lump)
-{
-	int i;
-	int rc;
-	struct obd_export *oexp;
-	struct lov_obd *lov = &exp->exp_obd->u.lov;
-	u64 last_id = 0;
-	struct lov_user_ost_data_v1 *lmm_objects;
-
-	if (lump->lmm_magic == LOV_USER_MAGIC_V3)
-		lmm_objects = ((struct lov_user_md_v3 *)lump)->lmm_objects;
-	else
-		lmm_objects = lump->lmm_objects;
-
-	for (i = 0; i < lump->lmm_stripe_count; i++) {
-		__u32 len = sizeof(last_id);
-		oexp = lov->lov_tgts[lmm_objects[i].l_ost_idx]->ltd_exp;
-		rc = obd_get_info(NULL, oexp, sizeof(KEY_LAST_ID), KEY_LAST_ID,
-				  &len, &last_id, NULL);
-		if (rc)
-			return rc;
-		if (ostid_id(&lmm_objects[i].l_ost_oi) > last_id) {
-			CERROR("Setting EA for object > than last id on"
-			       " ost idx %d "DOSTID" > %lld \n",
-			       lmm_objects[i].l_ost_idx,
-			       POSTID(&lmm_objects[i].l_ost_oi), last_id);
-			return -EINVAL;
-		}
-	}
-
-	rc = lov_setstripe(exp, 0, lsmp, lump);
-	if (rc)
-		return rc;
-
-	for (i = 0; i < lump->lmm_stripe_count; i++) {
-		(*lsmp)->lsm_oinfo[i]->loi_ost_idx =
-			lmm_objects[i].l_ost_idx;
-		(*lsmp)->lsm_oinfo[i]->loi_oi = lmm_objects[i].l_ost_oi;
-	}
-	return 0;
-}
-
-
 /* Retrieve object striping information.
  *
  * @lump is a pointer to an in-core struct with lmm_ost_count indicating
diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
index d00ab79..19d4d70 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -194,418 +194,6 @@ out:
 	return rc;
 }
 
-static int lov_update_enqueue_lov(struct obd_export *exp,
-				  struct lustre_handle *lov_lockhp,
-				  struct lov_oinfo *loi, __u64 flags, int idx,
-				  struct ost_id *oi, int rc)
-{
-	struct lov_obd *lov = &exp->exp_obd->u.lov;
-
-	if (rc != ELDLM_OK &&
-	    !(rc == ELDLM_LOCK_ABORTED && (flags & LDLM_FL_HAS_INTENT))) {
-		memset(lov_lockhp, 0, sizeof(*lov_lockhp));
-		if (lov->lov_tgts[idx] && lov->lov_tgts[idx]->ltd_active) {
-			/* -EUSERS used by OST to report file contention */
-			if (rc != -EINTR && rc != -EUSERS)
-				CERROR("%s: enqueue objid "DOSTID" subobj"
-				       DOSTID" on OST idx %d: rc %d\n",
-				       exp->exp_obd->obd_name,
-				       POSTID(oi), POSTID(&loi->loi_oi),
-				       loi->loi_ost_idx, rc);
-		} else
-			rc = ELDLM_OK;
-	}
-	return rc;
-}
-
-int lov_update_enqueue_set(struct lov_request *req, __u32 mode, int rc)
-{
-	struct lov_request_set *set = req->rq_rqset;
-	struct lustre_handle *lov_lockhp;
-	struct obd_info *oi = set->set_oi;
-	struct lov_oinfo *loi;
-
-	LASSERT(oi != NULL);
-
-	lov_lockhp = set->set_lockh->llh_handles + req->rq_stripe;
-	loi = oi->oi_md->lsm_oinfo[req->rq_stripe];
-
-	/* XXX LOV STACKING: OSC gets a copy, created in lov_prep_enqueue_set
-	 * and that copy can be arbitrarily out of date.
-	 *
-	 * The LOV API is due for a serious rewriting anyways, and this
-	 * can be addressed then. */
-
-	lov_stripe_lock(oi->oi_md);
-	osc_update_enqueue(lov_lockhp, loi, oi->oi_flags,
-			   &req->rq_oi.oi_md->lsm_oinfo[0]->loi_lvb, mode, rc);
-	if (rc == ELDLM_LOCK_ABORTED && (oi->oi_flags & LDLM_FL_HAS_INTENT))
-		memset(lov_lockhp, 0, sizeof(*lov_lockhp));
-	rc = lov_update_enqueue_lov(set->set_exp, lov_lockhp, loi, oi->oi_flags,
-				    req->rq_idx, &oi->oi_md->lsm_oi, rc);
-	lov_stripe_unlock(oi->oi_md);
-	lov_update_set(set, req, rc);
-	return rc;
-}
-
-/* The callback for osc_enqueue that updates lov info for every OSC request. */
-static int cb_update_enqueue(void *cookie, int rc)
-{
-	struct obd_info *oinfo = cookie;
-	struct ldlm_enqueue_info *einfo;
-	struct lov_request *lovreq;
-
-	lovreq = container_of(oinfo, struct lov_request, rq_oi);
-	einfo = lovreq->rq_rqset->set_ei;
-	return lov_update_enqueue_set(lovreq, einfo->ei_mode, rc);
-}
-
-static int enqueue_done(struct lov_request_set *set, __u32 mode)
-{
-	struct lov_request *req;
-	struct lov_obd *lov = &set->set_exp->exp_obd->u.lov;
-	int completes = atomic_read(&set->set_completes);
-	int rc = 0;
-
-	/* enqueue/match success, just return */
-	if (completes && completes == atomic_read(&set->set_success))
-		return 0;
-
-	/* cancel enqueued/matched locks */
-	list_for_each_entry(req, &set->set_list, rq_link) {
-		struct lustre_handle *lov_lockhp;
-
-		if (!req->rq_complete || req->rq_rc)
-			continue;
-
-		lov_lockhp = set->set_lockh->llh_handles + req->rq_stripe;
-		LASSERT(lov_lockhp);
-		if (!lustre_handle_is_used(lov_lockhp))
-			continue;
-
-		rc = obd_cancel(lov->lov_tgts[req->rq_idx]->ltd_exp,
-				req->rq_oi.oi_md, mode, lov_lockhp);
-		if (rc && lov->lov_tgts[req->rq_idx] &&
-		    lov->lov_tgts[req->rq_idx]->ltd_active)
-			CERROR("%s: cancelling obdjid "DOSTID" on OST"
-			       "idx %d error: rc = %d\n",
-			       set->set_exp->exp_obd->obd_name,
-			       POSTID(&req->rq_oi.oi_md->lsm_oi),
-			       req->rq_idx, rc);
-	}
-	if (set->set_lockh)
-		lov_llh_put(set->set_lockh);
-	return rc;
-}
-
-int lov_fini_enqueue_set(struct lov_request_set *set, __u32 mode, int rc,
-			 struct ptlrpc_request_set *rqset)
-{
-	int ret = 0;
-
-	if (set == NULL)
-		return 0;
-	LASSERT(set->set_exp);
-	/* Do enqueue_done only for sync requests and if any request
-	 * succeeded. */
-	if (!rqset) {
-		if (rc)
-			atomic_set(&set->set_completes, 0);
-		ret = enqueue_done(set, mode);
-	} else if (set->set_lockh)
-		lov_llh_put(set->set_lockh);
-
-	lov_put_reqset(set);
-
-	return rc ? rc : ret;
-}
-
-static void lov_llh_addref(void *llhp)
-{
-	struct lov_lock_handles *llh = llhp;
-
-	atomic_inc(&llh->llh_refcount);
-	CDEBUG(D_INFO, "GETting llh %p : new refcount %d\n", llh,
-	       atomic_read(&llh->llh_refcount));
-}
-
-static struct portals_handle_ops lov_handle_ops = {
-	.hop_addref = lov_llh_addref,
-	.hop_free   = NULL,
-};
-
-static struct lov_lock_handles *lov_llh_new(struct lov_stripe_md *lsm)
-{
-	struct lov_lock_handles *llh;
-
-	OBD_ALLOC(llh, sizeof(*llh) +
-		  sizeof(*llh->llh_handles) * lsm->lsm_stripe_count);
-	if (llh == NULL)
-		return NULL;
-
-	atomic_set(&llh->llh_refcount, 2);
-	llh->llh_stripe_count = lsm->lsm_stripe_count;
-	INIT_LIST_HEAD(&llh->llh_handle.h_link);
-	class_handle_hash(&llh->llh_handle, &lov_handle_ops);
-
-	return llh;
-}
-
-int lov_prep_enqueue_set(struct obd_export *exp, struct obd_info *oinfo,
-			 struct ldlm_enqueue_info *einfo,
-			 struct lov_request_set **reqset)
-{
-	struct lov_obd *lov = &exp->exp_obd->u.lov;
-	struct lov_request_set *set;
-	int i, rc = 0;
-
-	OBD_ALLOC(set, sizeof(*set));
-	if (set == NULL)
-		return -ENOMEM;
-	lov_init_set(set);
-
-	set->set_exp = exp;
-	set->set_oi = oinfo;
-	set->set_ei = einfo;
-	set->set_lockh = lov_llh_new(oinfo->oi_md);
-	if (set->set_lockh == NULL)
-		GOTO(out_set, rc = -ENOMEM);
-	oinfo->oi_lockh->cookie = set->set_lockh->llh_handle.h_cookie;
-
-	for (i = 0; i < oinfo->oi_md->lsm_stripe_count; i++) {
-		struct lov_oinfo *loi;
-		struct lov_request *req;
-		u64 start, end;
-
-		loi = oinfo->oi_md->lsm_oinfo[i];
-		if (!lov_stripe_intersects(oinfo->oi_md, i,
-					   oinfo->oi_policy.l_extent.start,
-					   oinfo->oi_policy.l_extent.end,
-					   &start, &end))
-			continue;
-
-		if (!lov_check_and_wait_active(lov, loi->loi_ost_idx)) {
-			CDEBUG(D_HA, "lov idx %d inactive\n", loi->loi_ost_idx);
-			continue;
-		}
-
-		OBD_ALLOC(req, sizeof(*req));
-		if (req == NULL)
-			GOTO(out_set, rc = -ENOMEM);
-
-		req->rq_buflen = sizeof(*req->rq_oi.oi_md) +
-			sizeof(struct lov_oinfo *) +
-			sizeof(struct lov_oinfo);
-		OBD_ALLOC_LARGE(req->rq_oi.oi_md, req->rq_buflen);
-		if (req->rq_oi.oi_md == NULL) {
-			OBD_FREE(req, sizeof(*req));
-			GOTO(out_set, rc = -ENOMEM);
-		}
-		req->rq_oi.oi_md->lsm_oinfo[0] =
-			((void *)req->rq_oi.oi_md) + sizeof(*req->rq_oi.oi_md) +
-			sizeof(struct lov_oinfo *);
-
-		/* Set lov request specific parameters. */
-		req->rq_oi.oi_lockh = set->set_lockh->llh_handles + i;
-		req->rq_oi.oi_cb_up = cb_update_enqueue;
-		req->rq_oi.oi_flags = oinfo->oi_flags;
-
-		LASSERT(req->rq_oi.oi_lockh);
-
-		req->rq_oi.oi_policy.l_extent.gid =
-			oinfo->oi_policy.l_extent.gid;
-		req->rq_oi.oi_policy.l_extent.start = start;
-		req->rq_oi.oi_policy.l_extent.end = end;
-
-		req->rq_idx = loi->loi_ost_idx;
-		req->rq_stripe = i;
-
-		/* XXX LOV STACKING: submd should be from the subobj */
-		req->rq_oi.oi_md->lsm_oi = loi->loi_oi;
-		req->rq_oi.oi_md->lsm_stripe_count = 0;
-		req->rq_oi.oi_md->lsm_oinfo[0]->loi_kms_valid =
-			loi->loi_kms_valid;
-		req->rq_oi.oi_md->lsm_oinfo[0]->loi_kms = loi->loi_kms;
-		req->rq_oi.oi_md->lsm_oinfo[0]->loi_lvb = loi->loi_lvb;
-
-		lov_set_add_req(req, set);
-	}
-	if (!set->set_count)
-		GOTO(out_set, rc = -EIO);
-	*reqset = set;
-	return 0;
-out_set:
-	lov_fini_enqueue_set(set, einfo->ei_mode, rc, NULL);
-	return rc;
-}
-
-int lov_fini_match_set(struct lov_request_set *set, __u32 mode, __u64 flags)
-{
-	int rc = 0;
-
-	if (set == NULL)
-		return 0;
-	LASSERT(set->set_exp);
-	rc = enqueue_done(set, mode);
-	if ((set->set_count == atomic_read(&set->set_success)) &&
-	    (flags & LDLM_FL_TEST_LOCK))
-		lov_llh_put(set->set_lockh);
-
-	lov_put_reqset(set);
-
-	return rc;
-}
-
-int lov_prep_match_set(struct obd_export *exp, struct obd_info *oinfo,
-		       struct lov_stripe_md *lsm, ldlm_policy_data_t *policy,
-		       __u32 mode, struct lustre_handle *lockh,
-		       struct lov_request_set **reqset)
-{
-	struct lov_obd *lov = &exp->exp_obd->u.lov;
-	struct lov_request_set *set;
-	int i, rc = 0;
-
-	OBD_ALLOC(set, sizeof(*set));
-	if (set == NULL)
-		return -ENOMEM;
-	lov_init_set(set);
-
-	set->set_exp = exp;
-	set->set_oi = oinfo;
-	set->set_oi->oi_md = lsm;
-	set->set_lockh = lov_llh_new(lsm);
-	if (set->set_lockh == NULL)
-		GOTO(out_set, rc = -ENOMEM);
-	lockh->cookie = set->set_lockh->llh_handle.h_cookie;
-
-	for (i = 0; i < lsm->lsm_stripe_count; i++) {
-		struct lov_oinfo *loi;
-		struct lov_request *req;
-		u64 start, end;
-
-		loi = lsm->lsm_oinfo[i];
-		if (!lov_stripe_intersects(lsm, i, policy->l_extent.start,
-					   policy->l_extent.end, &start, &end))
-			continue;
-
-		/* FIXME raid1 should grace this error */
-		if (!lov_check_and_wait_active(lov, loi->loi_ost_idx)) {
-			CDEBUG(D_HA, "lov idx %d inactive\n", loi->loi_ost_idx);
-			GOTO(out_set, rc = -EIO);
-		}
-
-		OBD_ALLOC(req, sizeof(*req));
-		if (req == NULL)
-			GOTO(out_set, rc = -ENOMEM);
-
-		req->rq_buflen = sizeof(*req->rq_oi.oi_md);
-		OBD_ALLOC_LARGE(req->rq_oi.oi_md, req->rq_buflen);
-		if (req->rq_oi.oi_md == NULL) {
-			OBD_FREE(req, sizeof(*req));
-			GOTO(out_set, rc = -ENOMEM);
-		}
-
-		req->rq_oi.oi_policy.l_extent.start = start;
-		req->rq_oi.oi_policy.l_extent.end = end;
-		req->rq_oi.oi_policy.l_extent.gid = policy->l_extent.gid;
-
-		req->rq_idx = loi->loi_ost_idx;
-		req->rq_stripe = i;
-
-		/* XXX LOV STACKING: submd should be from the subobj */
-		req->rq_oi.oi_md->lsm_oi = loi->loi_oi;
-		req->rq_oi.oi_md->lsm_stripe_count = 0;
-
-		lov_set_add_req(req, set);
-	}
-	if (!set->set_count)
-		GOTO(out_set, rc = -EIO);
-	*reqset = set;
-	return rc;
-out_set:
-	lov_fini_match_set(set, mode, 0);
-	return rc;
-}
-
-int lov_fini_cancel_set(struct lov_request_set *set)
-{
-	int rc = 0;
-
-	if (set == NULL)
-		return 0;
-
-	LASSERT(set->set_exp);
-	if (set->set_lockh)
-		lov_llh_put(set->set_lockh);
-
-	lov_put_reqset(set);
-
-	return rc;
-}
-
-int lov_prep_cancel_set(struct obd_export *exp, struct obd_info *oinfo,
-			struct lov_stripe_md *lsm, __u32 mode,
-			struct lustre_handle *lockh,
-			struct lov_request_set **reqset)
-{
-	struct lov_request_set *set;
-	int i, rc = 0;
-
-	OBD_ALLOC(set, sizeof(*set));
-	if (set == NULL)
-		return -ENOMEM;
-	lov_init_set(set);
-
-	set->set_exp = exp;
-	set->set_oi = oinfo;
-	set->set_oi->oi_md = lsm;
-	set->set_lockh = lov_handle2llh(lockh);
-	if (set->set_lockh == NULL) {
-		CERROR("LOV: invalid lov lock handle %p\n", lockh);
-		GOTO(out_set, rc = -EINVAL);
-	}
-	lockh->cookie = set->set_lockh->llh_handle.h_cookie;
-
-	for (i = 0; i < lsm->lsm_stripe_count; i++) {
-		struct lov_request *req;
-		struct lustre_handle *lov_lockhp;
-		struct lov_oinfo *loi = lsm->lsm_oinfo[i];
-
-		lov_lockhp = set->set_lockh->llh_handles + i;
-		if (!lustre_handle_is_used(lov_lockhp)) {
-			CDEBUG(D_INFO, "lov idx %d subobj "DOSTID" no lock\n",
-			       loi->loi_ost_idx, POSTID(&loi->loi_oi));
-			continue;
-		}
-
-		OBD_ALLOC(req, sizeof(*req));
-		if (req == NULL)
-			GOTO(out_set, rc = -ENOMEM);
-
-		req->rq_buflen = sizeof(*req->rq_oi.oi_md);
-		OBD_ALLOC_LARGE(req->rq_oi.oi_md, req->rq_buflen);
-		if (req->rq_oi.oi_md == NULL) {
-			OBD_FREE(req, sizeof(*req));
-			GOTO(out_set, rc = -ENOMEM);
-		}
-
-		req->rq_idx = loi->loi_ost_idx;
-		req->rq_stripe = i;
-
-		/* XXX LOV STACKING: submd should be from the subobj */
-		req->rq_oi.oi_md->lsm_oi = loi->loi_oi;
-		req->rq_oi.oi_md->lsm_stripe_count = 0;
-
-		lov_set_add_req(req, set);
-	}
-	if (!set->set_count)
-		GOTO(out_set, rc = -EIO);
-	*reqset = set;
-	return rc;
-out_set:
-	lov_fini_cancel_set(set);
-	return rc;
-}
 static int common_attr_done(struct lov_request_set *set)
 {
 	struct list_head *pos;
@@ -657,164 +245,6 @@ out:
 
 }
 
-static int brw_done(struct lov_request_set *set)
-{
-	struct lov_stripe_md *lsm = set->set_oi->oi_md;
-	struct lov_oinfo     *loi = NULL;
-	struct list_head *pos;
-	struct lov_request *req;
-
-	list_for_each(pos, &set->set_list) {
-		req = list_entry(pos, struct lov_request, rq_link);
-
-		if (!req->rq_complete || req->rq_rc)
-			continue;
-
-		loi = lsm->lsm_oinfo[req->rq_stripe];
-
-		if (req->rq_oi.oi_oa->o_valid & OBD_MD_FLBLOCKS)
-			loi->loi_lvb.lvb_blocks = req->rq_oi.oi_oa->o_blocks;
-	}
-
-	return 0;
-}
-
-int lov_fini_brw_set(struct lov_request_set *set)
-{
-	int rc = 0;
-
-	if (set == NULL)
-		return 0;
-	LASSERT(set->set_exp);
-	if (atomic_read(&set->set_completes)) {
-		rc = brw_done(set);
-		/* FIXME update qos data here */
-	}
-	lov_put_reqset(set);
-
-	return rc;
-}
-
-int lov_prep_brw_set(struct obd_export *exp, struct obd_info *oinfo,
-		     u32 oa_bufs, struct brw_page *pga,
-		     struct obd_trans_info *oti,
-		     struct lov_request_set **reqset)
-{
-	struct {
-		u32       index;
-		u32       count;
-		u32       off;
-	} *info = NULL;
-	struct lov_request_set *set;
-	struct lov_obd *lov = &exp->exp_obd->u.lov;
-	int rc = 0, i, shift;
-
-	OBD_ALLOC(set, sizeof(*set));
-	if (set == NULL)
-		return -ENOMEM;
-	lov_init_set(set);
-
-	set->set_exp = exp;
-	set->set_oti = oti;
-	set->set_oi = oinfo;
-	set->set_oabufs = oa_bufs;
-	OBD_ALLOC_LARGE(set->set_pga, oa_bufs * sizeof(*set->set_pga));
-	if (!set->set_pga)
-		GOTO(out, rc = -ENOMEM);
-
-	OBD_ALLOC_LARGE(info, sizeof(*info) * oinfo->oi_md->lsm_stripe_count);
-	if (!info)
-		GOTO(out, rc = -ENOMEM);
-
-	/* calculate the page count for each stripe */
-	for (i = 0; i < oa_bufs; i++) {
-		int stripe = lov_stripe_number(oinfo->oi_md, pga[i].off);
-		info[stripe].count++;
-	}
-
-	/* alloc and initialize lov request */
-	shift = 0;
-	for (i = 0; i < oinfo->oi_md->lsm_stripe_count; i++) {
-		struct lov_oinfo *loi = NULL;
-		struct lov_request *req;
-
-		if (info[i].count == 0)
-			continue;
-
-		loi = oinfo->oi_md->lsm_oinfo[i];
-		if (!lov_check_and_wait_active(lov, loi->loi_ost_idx)) {
-			CDEBUG(D_HA, "lov idx %d inactive\n", loi->loi_ost_idx);
-			GOTO(out, rc = -EIO);
-		}
-
-		OBD_ALLOC(req, sizeof(*req));
-		if (req == NULL)
-			GOTO(out, rc = -ENOMEM);
-
-		OBDO_ALLOC(req->rq_oi.oi_oa);
-		if (req->rq_oi.oi_oa == NULL) {
-			OBD_FREE(req, sizeof(*req));
-			GOTO(out, rc = -ENOMEM);
-		}
-
-		if (oinfo->oi_oa) {
-			memcpy(req->rq_oi.oi_oa, oinfo->oi_oa,
-			       sizeof(*req->rq_oi.oi_oa));
-		}
-		req->rq_oi.oi_oa->o_oi = loi->loi_oi;
-		req->rq_oi.oi_oa->o_stripe_idx = i;
-
-		req->rq_buflen = sizeof(*req->rq_oi.oi_md);
-		OBD_ALLOC_LARGE(req->rq_oi.oi_md, req->rq_buflen);
-		if (req->rq_oi.oi_md == NULL) {
-			OBDO_FREE(req->rq_oi.oi_oa);
-			OBD_FREE(req, sizeof(*req));
-			GOTO(out, rc = -ENOMEM);
-		}
-
-		req->rq_idx = loi->loi_ost_idx;
-		req->rq_stripe = i;
-
-		/* XXX LOV STACKING */
-		req->rq_oi.oi_md->lsm_oi = loi->loi_oi;
-		req->rq_oabufs = info[i].count;
-		req->rq_pgaidx = shift;
-		shift += req->rq_oabufs;
-
-		/* remember the index for sort brw_page array */
-		info[i].index = req->rq_pgaidx;
-
-		req->rq_oi.oi_capa = oinfo->oi_capa;
-
-		lov_set_add_req(req, set);
-	}
-	if (!set->set_count)
-		GOTO(out, rc = -EIO);
-
-	/* rotate & sort the brw_page array */
-	for (i = 0; i < oa_bufs; i++) {
-		int stripe = lov_stripe_number(oinfo->oi_md, pga[i].off);
-
-		shift = info[stripe].index + info[stripe].off;
-		LASSERT(shift < oa_bufs);
-		set->set_pga[shift] = pga[i];
-		lov_stripe_offset(oinfo->oi_md, pga[i].off, stripe,
-				  &set->set_pga[shift].off);
-		info[stripe].off++;
-	}
-out:
-	if (info)
-		OBD_FREE_LARGE(info,
-			       sizeof(*info) * oinfo->oi_md->lsm_stripe_count);
-
-	if (rc == 0)
-		*reqset = set;
-	else
-		lov_fini_brw_set(set);
-
-	return rc;
-}
-
 int lov_fini_getattr_set(struct lov_request_set *set)
 {
 	int rc = 0;
@@ -1093,219 +523,6 @@ out_set:
 	return rc;
 }
 
-int lov_fini_punch_set(struct lov_request_set *set)
-{
-	int rc = 0;
-
-	if (set == NULL)
-		return 0;
-	LASSERT(set->set_exp);
-	if (atomic_read(&set->set_completes)) {
-		rc = -EIO;
-		/* FIXME update qos data here */
-		if (atomic_read(&set->set_success))
-			rc = common_attr_done(set);
-	}
-
-	lov_put_reqset(set);
-
-	return rc;
-}
-
-int lov_update_punch_set(struct lov_request_set *set,
-			 struct lov_request *req, int rc)
-{
-	struct lov_obd *lov = &req->rq_rqset->set_exp->exp_obd->u.lov;
-	struct lov_stripe_md *lsm = req->rq_rqset->set_oi->oi_md;
-
-	lov_update_set(set, req, rc);
-
-	/* grace error on inactive ost */
-	if (rc && !lov->lov_tgts[req->rq_idx]->ltd_active)
-		rc = 0;
-
-	if (rc == 0) {
-		lov_stripe_lock(lsm);
-		if (req->rq_oi.oi_oa->o_valid & OBD_MD_FLBLOCKS) {
-			lsm->lsm_oinfo[req->rq_stripe]->loi_lvb.lvb_blocks =
-				req->rq_oi.oi_oa->o_blocks;
-		}
-
-		lov_stripe_unlock(lsm);
-	}
-
-	return rc;
-}
-
-/* The callback for osc_punch that finalizes a request info when a response
- * is received. */
-static int cb_update_punch(void *cookie, int rc)
-{
-	struct obd_info *oinfo = cookie;
-	struct lov_request *lovreq;
-
-	lovreq = container_of(oinfo, struct lov_request, rq_oi);
-	return lov_update_punch_set(lovreq->rq_rqset, lovreq, rc);
-}
-
-int lov_prep_punch_set(struct obd_export *exp, struct obd_info *oinfo,
-		       struct obd_trans_info *oti,
-		       struct lov_request_set **reqset)
-{
-	struct lov_request_set *set;
-	struct lov_obd *lov = &exp->exp_obd->u.lov;
-	int rc = 0, i;
-
-	OBD_ALLOC(set, sizeof(*set));
-	if (set == NULL)
-		return -ENOMEM;
-	lov_init_set(set);
-
-	set->set_oi = oinfo;
-	set->set_exp = exp;
-
-	for (i = 0; i < oinfo->oi_md->lsm_stripe_count; i++) {
-		struct lov_oinfo *loi = oinfo->oi_md->lsm_oinfo[i];
-		struct lov_request *req;
-		u64 rs, re;
-
-		if (!lov_stripe_intersects(oinfo->oi_md, i,
-					   oinfo->oi_policy.l_extent.start,
-					   oinfo->oi_policy.l_extent.end,
-					   &rs, &re))
-			continue;
-
-		if (!lov_check_and_wait_active(lov, loi->loi_ost_idx)) {
-			CDEBUG(D_HA, "lov idx %d inactive\n", loi->loi_ost_idx);
-			GOTO(out_set, rc = -EIO);
-		}
-
-		OBD_ALLOC(req, sizeof(*req));
-		if (req == NULL)
-			GOTO(out_set, rc = -ENOMEM);
-		req->rq_stripe = i;
-		req->rq_idx = loi->loi_ost_idx;
-
-		OBDO_ALLOC(req->rq_oi.oi_oa);
-		if (req->rq_oi.oi_oa == NULL) {
-			OBD_FREE(req, sizeof(*req));
-			GOTO(out_set, rc = -ENOMEM);
-		}
-		memcpy(req->rq_oi.oi_oa, oinfo->oi_oa,
-		       sizeof(*req->rq_oi.oi_oa));
-		req->rq_oi.oi_oa->o_oi = loi->loi_oi;
-		req->rq_oi.oi_oa->o_valid |= OBD_MD_FLGROUP;
-
-		req->rq_oi.oi_oa->o_stripe_idx = i;
-		req->rq_oi.oi_cb_up = cb_update_punch;
-
-		req->rq_oi.oi_policy.l_extent.start = rs;
-		req->rq_oi.oi_policy.l_extent.end = re;
-		req->rq_oi.oi_policy.l_extent.gid = -1;
-
-		req->rq_oi.oi_capa = oinfo->oi_capa;
-
-		lov_set_add_req(req, set);
-	}
-	if (!set->set_count)
-		GOTO(out_set, rc = -EIO);
-	*reqset = set;
-	return rc;
-out_set:
-	lov_fini_punch_set(set);
-	return rc;
-}
-
-int lov_fini_sync_set(struct lov_request_set *set)
-{
-	int rc = 0;
-
-	if (set == NULL)
-		return 0;
-	LASSERT(set->set_exp);
-	if (atomic_read(&set->set_completes)) {
-		if (!atomic_read(&set->set_success))
-			rc = -EIO;
-		/* FIXME update qos data here */
-	}
-
-	lov_put_reqset(set);
-
-	return rc;
-}
-
-/* The callback for osc_sync that finalizes a request info when a
- * response is received. */
-static int cb_sync_update(void *cookie, int rc)
-{
-	struct obd_info *oinfo = cookie;
-	struct lov_request *lovreq;
-
-	lovreq = container_of(oinfo, struct lov_request, rq_oi);
-	return lov_update_common_set(lovreq->rq_rqset, lovreq, rc);
-}
-
-int lov_prep_sync_set(struct obd_export *exp, struct obd_info *oinfo,
-		      u64 start, u64 end,
-		      struct lov_request_set **reqset)
-{
-	struct lov_request_set *set;
-	struct lov_obd *lov = &exp->exp_obd->u.lov;
-	int rc = 0, i;
-
-	OBD_ALLOC_PTR(set);
-	if (set == NULL)
-		return -ENOMEM;
-	lov_init_set(set);
-
-	set->set_exp = exp;
-	set->set_oi = oinfo;
-
-	for (i = 0; i < oinfo->oi_md->lsm_stripe_count; i++) {
-		struct lov_oinfo *loi = oinfo->oi_md->lsm_oinfo[i];
-		struct lov_request *req;
-		u64 rs, re;
-
-		if (!lov_check_and_wait_active(lov, loi->loi_ost_idx)) {
-			CDEBUG(D_HA, "lov idx %d inactive\n", loi->loi_ost_idx);
-			continue;
-		}
-
-		if (!lov_stripe_intersects(oinfo->oi_md, i, start, end, &rs,
-					   &re))
-			continue;
-
-		OBD_ALLOC_PTR(req);
-		if (req == NULL)
-			GOTO(out_set, rc = -ENOMEM);
-		req->rq_stripe = i;
-		req->rq_idx = loi->loi_ost_idx;
-
-		OBDO_ALLOC(req->rq_oi.oi_oa);
-		if (req->rq_oi.oi_oa == NULL) {
-			OBD_FREE(req, sizeof(*req));
-			GOTO(out_set, rc = -ENOMEM);
-		}
-		*req->rq_oi.oi_oa = *oinfo->oi_oa;
-		req->rq_oi.oi_oa->o_oi = loi->loi_oi;
-		req->rq_oi.oi_oa->o_stripe_idx = i;
-
-		req->rq_oi.oi_policy.l_extent.start = rs;
-		req->rq_oi.oi_policy.l_extent.end = re;
-		req->rq_oi.oi_policy.l_extent.gid = -1;
-		req->rq_oi.oi_cb_up = cb_sync_update;
-
-		lov_set_add_req(req, set);
-	}
-	if (!set->set_count)
-		GOTO(out_set, rc = -EIO);
-	*reqset = set;
-	return rc;
-out_set:
-	lov_fini_sync_set(set);
-	return rc;
-}
-
 #define LOV_U64_MAX ((__u64)~0ULL)
 #define LOV_SUM_MAX(tot, add)					   \
 	do {							    \
-- 
1.7.9.5

