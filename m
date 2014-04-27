Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbaD0RIL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:08:11 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48005 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbaD0RHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:55 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: "John L. Hammond" <john.hammond@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 15/47] staging/lustre/lov: remove unused lov llog code
Date: Sun, 27 Apr 2014 13:06:39 -0400
Message-Id: <1398618431-29757-16-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Remove the unused functions lov_llog_init(), lov_llog_finish(),
their supporting functions, and the file lov_log.c.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-on: http://review.whamcloud.com/8539
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2675
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/lov/Makefile       |   2 +-
 drivers/staging/lustre/lustre/lov/lov_internal.h |   4 -
 drivers/staging/lustre/lustre/lov/lov_log.c      | 272 -----------------------
 drivers/staging/lustre/lustre/lov/lov_obd.c      |   9 +-
 4 files changed, 3 insertions(+), 284 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/lov/lov_log.c

diff --git a/drivers/staging/lustre/lustre/lov/Makefile b/drivers/staging/lustre/lustre/lov/Makefile
index 9a5f26d..a908edb 100644
--- a/drivers/staging/lustre/lustre/lov/Makefile
+++ b/drivers/staging/lustre/lustre/lov/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_LUSTRE_FS) += lov.o
-lov-y := lov_log.o lov_obd.o lov_pack.o lov_offset.o lov_merge.o \
+lov-y := lov_obd.o lov_pack.o lov_offset.o lov_merge.o \
 	 lov_request.o lov_ea.o lov_dev.o lov_object.o lov_page.o  \
 	 lov_lock.o lov_io.o lovsub_dev.o lovsub_object.o lovsub_page.o      \
 	 lovsub_lock.o lovsub_io.o lov_pool.o
diff --git a/drivers/staging/lustre/lustre/lov/lov_internal.h b/drivers/staging/lustre/lustre/lov/lov_internal.h
index 2b22a03..10e18c2 100644
--- a/drivers/staging/lustre/lustre/lov/lov_internal.h
+++ b/drivers/staging/lustre/lustre/lov/lov_internal.h
@@ -251,10 +251,6 @@ int lov_process_config_base(struct obd_device *obd, struct lustre_cfg *lcfg,
 			    __u32 *indexp, int *genp);
 int lov_del_target(struct obd_device *obd, __u32 index,
 		   struct obd_uuid *uuidp, int gen);
-/* lov_log.c */
-int lov_llog_init(struct obd_device *obd, struct obd_llog_group *olg,
-		  struct obd_device *tgt, int *idx);
-int lov_llog_finish(struct obd_device *obd, int count);
 
 /* lov_pack.c */
 int lov_packmd(struct obd_export *exp, struct lov_mds_md **lmm,
diff --git a/drivers/staging/lustre/lustre/lov/lov_log.c b/drivers/staging/lustre/lustre/lov/lov_log.c
deleted file mode 100644
index 3eedd93..0000000
--- a/drivers/staging/lustre/lustre/lov/lov_log.c
+++ /dev/null
@@ -1,272 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2003, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2012, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * lustre/lov/lov_log.c
- *
- * Author: Phil Schwan <phil@clusterfs.com>
- * Author: Peter Braam <braam@clusterfs.com>
- * Author: Mike Shaver <shaver@clusterfs.com>
- */
-
-#define DEBUG_SUBSYSTEM S_LOV
-#include <linux/libcfs/libcfs.h>
-
-#include <obd_support.h>
-#include <lustre_lib.h>
-#include <lustre_net.h>
-#include <lustre/lustre_idl.h>
-#include <lustre_dlm.h>
-#include <lustre_mds.h>
-#include <obd_class.h>
-#include <obd_lov.h>
-#include <obd_ost.h>
-#include <lprocfs_status.h>
-#include <lustre_log.h>
-
-#include "lov_internal.h"
-
-/* Add log records for each OSC that this object is striped over, and return
- * cookies for each one.  We _would_ have nice abstraction here, except that
- * we need to keep cookies in stripe order, even if some are NULL, so that
- * the right cookies are passed back to the right OSTs at the client side.
- * Unset cookies should be all-zero (which will never occur naturally). */
-static int lov_llog_origin_add(const struct lu_env *env,
-			       struct llog_ctxt *ctxt,
-			       struct llog_rec_hdr *rec,
-			       struct lov_stripe_md *lsm,
-			       struct llog_cookie *logcookies, int numcookies)
-{
-	struct obd_device *obd = ctxt->loc_obd;
-	struct lov_obd *lov = &obd->u.lov;
-	int i, rc = 0, cookies = 0;
-
-	LASSERTF(logcookies && numcookies >= lsm->lsm_stripe_count,
-		 "logcookies %p, numcookies %d lsm->lsm_stripe_count %d \n",
-		 logcookies, numcookies, lsm->lsm_stripe_count);
-
-	for (i = 0; i < lsm->lsm_stripe_count; i++) {
-		struct lov_oinfo *loi = lsm->lsm_oinfo[i];
-		struct obd_device *child =
-			lov->lov_tgts[loi->loi_ost_idx]->ltd_exp->exp_obd;
-		struct llog_ctxt *cctxt = llog_get_context(child, ctxt->loc_idx);
-
-		/* fill mds unlink/setattr log record */
-		switch (rec->lrh_type) {
-		case MDS_UNLINK_REC: {
-			struct llog_unlink_rec *lur = (struct llog_unlink_rec *)rec;
-			lur->lur_oid = ostid_id(&loi->loi_oi);
-			lur->lur_oseq = (__u32)ostid_seq(&loi->loi_oi);
-			break;
-		}
-		case MDS_SETATTR64_REC: {
-			struct llog_setattr64_rec *lsr = (struct llog_setattr64_rec *)rec;
-			lsr->lsr_oi = loi->loi_oi;
-			break;
-		}
-		default:
-			break;
-		}
-
-		/* inject error in llog_obd_add() below */
-		if (OBD_FAIL_CHECK(OBD_FAIL_MDS_FAIL_LOV_LOG_ADD)) {
-			llog_ctxt_put(cctxt);
-			cctxt = NULL;
-		}
-		rc = llog_obd_add(env, cctxt, rec, NULL, logcookies + cookies,
-				  numcookies - cookies);
-		llog_ctxt_put(cctxt);
-		if (rc < 0) {
-			CERROR("Can't add llog (rc = %d) for stripe %d\n",
-			       rc, cookies);
-			memset(logcookies + cookies, 0,
-			       sizeof(struct llog_cookie));
-			rc = 1; /* skip this cookie */
-		}
-		/* Note that rc is always 1 if llog_obd_add was successful */
-		cookies += rc;
-	}
-	return cookies;
-}
-
-static int lov_llog_origin_connect(struct llog_ctxt *ctxt,
-				   struct llog_logid *logid,
-				   struct llog_gen *gen,
-				   struct obd_uuid *uuid)
-{
-	struct obd_device *obd = ctxt->loc_obd;
-	struct lov_obd *lov = &obd->u.lov;
-	int i, rc = 0, err = 0;
-
-	obd_getref(obd);
-	for (i = 0; i < lov->desc.ld_tgt_count; i++) {
-		struct obd_device *child;
-		struct llog_ctxt *cctxt;
-
-		if (!lov->lov_tgts[i] || !lov->lov_tgts[i]->ltd_active)
-			continue;
-		if (uuid && !obd_uuid_equals(uuid, &lov->lov_tgts[i]->ltd_uuid))
-			continue;
-		CDEBUG(D_CONFIG, "connect %d/%d\n", i, lov->desc.ld_tgt_count);
-		child = lov->lov_tgts[i]->ltd_exp->exp_obd;
-		cctxt = llog_get_context(child, ctxt->loc_idx);
-		rc = llog_connect(cctxt, logid, gen, uuid);
-		llog_ctxt_put(cctxt);
-
-		if (rc) {
-			CERROR("error osc_llog_connect tgt %d (%d)\n", i, rc);
-			if (!err)
-				err = rc;
-		}
-	}
-	obd_putref(obd);
-
-	return err;
-}
-
-/* the replicators commit callback */
-static int lov_llog_repl_cancel(const struct lu_env *env,
-				struct llog_ctxt *ctxt,
-				struct lov_stripe_md *lsm,
-				int count, struct llog_cookie *cookies,
-				int flags)
-{
-	struct lov_obd *lov;
-	struct obd_device *obd = ctxt->loc_obd;
-	int rc = 0, i;
-
-	LASSERT(lsm != NULL);
-	LASSERT(count == lsm->lsm_stripe_count);
-
-	lov = &obd->u.lov;
-	obd_getref(obd);
-	for (i = 0; i < count; i++, cookies++) {
-		struct lov_oinfo *loi = lsm->lsm_oinfo[i];
-		struct obd_device *child =
-			lov->lov_tgts[loi->loi_ost_idx]->ltd_exp->exp_obd;
-		struct llog_ctxt *cctxt =
-			llog_get_context(child, ctxt->loc_idx);
-		int err;
-
-		err = llog_cancel(env, cctxt, NULL, 1, cookies, flags);
-		llog_ctxt_put(cctxt);
-		if (err && lov->lov_tgts[loi->loi_ost_idx]->ltd_active) {
-			CERROR("%s: objid "DOSTID" subobj "DOSTID
-			       " on OST idx %d: rc = %d\n",
-			       obd->obd_name, POSTID(&lsm->lsm_oi),
-			       POSTID(&loi->loi_oi), loi->loi_ost_idx, err);
-			if (!rc)
-				rc = err;
-		}
-	}
-	obd_putref(obd);
-	return rc;
-}
-
-static struct llog_operations lov_mds_ost_orig_logops = {
-	.lop_obd_add	= lov_llog_origin_add,
-	.lop_connect	= lov_llog_origin_connect,
-};
-
-static struct llog_operations lov_size_repl_logops = {
-	.lop_cancel	= lov_llog_repl_cancel,
-};
-
-int lov_llog_init(struct obd_device *obd, struct obd_llog_group *olg,
-		  struct obd_device *disk_obd, int *index)
-{
-	struct lov_obd *lov = &obd->u.lov;
-	struct obd_device *child;
-	int i, rc = 0;
-
-	LASSERT(olg == &obd->obd_olg);
-	rc = llog_setup(NULL, obd, olg, LLOG_MDS_OST_ORIG_CTXT, disk_obd,
-			&lov_mds_ost_orig_logops);
-	if (rc)
-		return rc;
-
-	rc = llog_setup(NULL, obd, olg, LLOG_SIZE_REPL_CTXT, disk_obd,
-			&lov_size_repl_logops);
-	if (rc)
-		GOTO(err_cleanup, rc);
-
-	obd_getref(obd);
-	/* count may not match lov->desc.ld_tgt_count during dynamic ost add */
-	for (i = 0; i < lov->desc.ld_tgt_count; i++) {
-		if (!lov->lov_tgts[i])
-			continue;
-
-		if (index && i != *index)
-			continue;
-
-		child = lov->lov_tgts[i]->ltd_obd;
-		rc = obd_llog_init(child, &child->obd_olg, disk_obd, &i);
-		if (rc)
-			CERROR("error osc_llog_init idx %d osc '%s' tgt '%s' "
-			       "(rc=%d)\n", i, child->obd_name,
-			       disk_obd->obd_name, rc);
-		rc = 0;
-	}
-	obd_putref(obd);
-	GOTO(err_cleanup, rc);
-err_cleanup:
-	if (rc) {
-		struct llog_ctxt *ctxt =
-			llog_get_context(obd, LLOG_SIZE_REPL_CTXT);
-		if (ctxt)
-			llog_cleanup(NULL, ctxt);
-		ctxt = llog_get_context(obd, LLOG_MDS_OST_ORIG_CTXT);
-		if (ctxt)
-			llog_cleanup(NULL, ctxt);
-	}
-	return rc;
-}
-
-int lov_llog_finish(struct obd_device *obd, int count)
-{
-	struct llog_ctxt *ctxt;
-
-	/* cleanup our llogs only if the ctxts have been setup
-	 * (client lov doesn't setup, mds lov does). */
-	ctxt = llog_get_context(obd, LLOG_MDS_OST_ORIG_CTXT);
-	if (ctxt)
-		llog_cleanup(NULL, ctxt);
-
-	ctxt = llog_get_context(obd, LLOG_SIZE_REPL_CTXT);
-	if (ctxt)
-		llog_cleanup(NULL, ctxt);
-
-	/* lov->tgt llogs are cleaned during osc_cleanup. */
-	return 0;
-}
diff --git a/drivers/staging/lustre/lustre/lov/lov_obd.c b/drivers/staging/lustre/lustre/lov/lov_obd.c
index 02509d0..f66ba57 100644
--- a/drivers/staging/lustre/lustre/lov/lov_obd.c
+++ b/drivers/staging/lustre/lustre/lov/lov_obd.c
@@ -59,7 +59,6 @@
 #include <cl_object.h>
 #include <lclient.h> /* for cl_client_lru */
 #include <lustre/ll_fiemap.h>
-#include <lustre_log.h>
 #include <lustre_fid.h>
 
 #include "lov_internal.h"
@@ -861,12 +860,10 @@ static int lov_precleanup(struct obd_device *obd, enum obd_cleanup_stage stage)
 		}
 		break;
 	}
-	case OBD_CLEANUP_EXPORTS:
-		rc = obd_llog_finish(obd, 0);
-		if (rc != 0)
-			CERROR("failed to cleanup llogging subsystems\n");
+	default:
 		break;
 	}
+
 	return rc;
 }
 
@@ -2808,8 +2805,6 @@ struct obd_ops lov_obd_ops = {
 	.o_get_info	    = lov_get_info,
 	.o_set_info_async      = lov_set_info_async,
 	.o_extent_calc	 = lov_extent_calc,
-	.o_llog_init	   = lov_llog_init,
-	.o_llog_finish	 = lov_llog_finish,
 	.o_notify	      = lov_notify,
 	.o_pool_new	    = lov_pool_new,
 	.o_pool_rem	    = lov_pool_remove,
-- 
1.8.5.3

