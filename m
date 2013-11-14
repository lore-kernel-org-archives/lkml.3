Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab3KNQsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:48:15 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62202 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab3KNQoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:44:32 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Bobi Jam <bobijam.xu@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 16/26] staging/lustre/lov: avoid subobj's coh_parent race
Date: Fri, 15 Nov 2013 00:43:03 +0800
Message-Id: <1384447393-13838-17-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bobi Jam <bobijam.xu@intel.com>

* during a file lov object initialization, we need protect the access
  and change of its subobj->coh_parent, since it could be another
  layout change race there, which makes an unreferenced lovsub obj in
  the site object hash table.

* dump lovsub objects in the site if the lovsub device reference > 0
  during its finalization phase.

Lustre-change: http://review.whamcloud.com/6105
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-1480
Signed-off-by: Bobi Jam <bobijam.xu@intel.com>
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/lov/lov_object.c |   12 ++++++++----
 drivers/staging/lustre/lustre/lov/lovsub_dev.c |    4 ++++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lov/lov_object.c b/drivers/staging/lustre/lustre/lov/lov_object.c
index df8b5b5..368014a 100644
--- a/drivers/staging/lustre/lustre/lov/lov_object.c
+++ b/drivers/staging/lustre/lustre/lov/lov_object.c
@@ -122,13 +122,13 @@ static struct cl_object *lov_sub_find(const struct lu_env *env,
 }
 
 static int lov_init_sub(const struct lu_env *env, struct lov_object *lov,
-			struct cl_object *stripe,
-			struct lov_layout_raid0 *r0, int idx)
+			struct cl_object *stripe, struct lov_layout_raid0 *r0,
+			int idx)
 {
 	struct cl_object_header *hdr;
 	struct cl_object_header *subhdr;
 	struct cl_object_header *parent;
-	struct lov_oinfo	*oinfo;
+	struct lov_oinfo        *oinfo;
 	int result;
 
 	if (OBD_FAIL_CHECK(OBD_FAIL_LOV_INIT)) {
@@ -144,7 +144,6 @@ static int lov_init_sub(const struct lu_env *env, struct lov_object *lov,
 
 	hdr    = cl_object_header(lov2cl(lov));
 	subhdr = cl_object_header(stripe);
-	parent = subhdr->coh_parent;
 
 	oinfo = lov->lo_lsm->lsm_oinfo[idx];
 	CDEBUG(D_INODE, DFID"@%p[%d] -> "DFID"@%p: ostid: "DOSTID
@@ -153,8 +152,12 @@ static int lov_init_sub(const struct lu_env *env, struct lov_object *lov,
 	       PFID(&hdr->coh_lu.loh_fid), hdr, POSTID(&oinfo->loi_oi),
 	       oinfo->loi_ost_idx, oinfo->loi_ost_gen);
 
+	/* reuse ->coh_attr_guard to protect coh_parent change */
+	spin_lock(&subhdr->coh_attr_guard);
+	parent = subhdr->coh_parent;
 	if (parent == NULL) {
 		subhdr->coh_parent = hdr;
+		spin_unlock(&subhdr->coh_attr_guard);
 		subhdr->coh_nesting = hdr->coh_nesting + 1;
 		lu_object_ref_add(&stripe->co_lu, "lov-parent", lov);
 		r0->lo_sub[idx] = cl2lovsub(stripe);
@@ -166,6 +169,7 @@ static int lov_init_sub(const struct lu_env *env, struct lov_object *lov,
 		struct lov_object *old_lov;
 		unsigned int mask = D_INODE;
 
+		spin_unlock(&subhdr->coh_attr_guard);
 		old_obj = lu_object_locate(&parent->coh_lu, &lov_device_type);
 		LASSERT(old_obj != NULL);
 		old_lov = cl2lov(lu2cl(old_obj));
diff --git a/drivers/staging/lustre/lustre/lov/lovsub_dev.c b/drivers/staging/lustre/lustre/lov/lovsub_dev.c
index 998ea1c..926c35a 100644
--- a/drivers/staging/lustre/lustre/lov/lovsub_dev.c
+++ b/drivers/staging/lustre/lustre/lov/lovsub_dev.c
@@ -131,6 +131,10 @@ static struct lu_device *lovsub_device_free(const struct lu_env *env,
 	struct lovsub_device *lsd  = lu2lovsub_dev(d);
 	struct lu_device     *next = cl2lu_dev(lsd->acid_next);
 
+	if (atomic_read(&d->ld_ref) && d->ld_site) {
+		LIBCFS_DEBUG_MSG_DATA_DECL(msgdata, D_ERROR, NULL);
+		lu_site_print(env, d->ld_site, &msgdata, lu_cdebug_printer);
+	}
 	cl_device_fini(lu2cl_dev(d));
 	OBD_FREE_PTR(lsd);
 	return next;
-- 
1.7.9.5

