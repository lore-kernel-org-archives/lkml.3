Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaIEUJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:09:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:63519 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaIEUJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:09:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,474,1406617200"; 
   d="scan'208";a="569066331"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 04/12] staging/lustre: remove obd_ost.h
Date: Fri, 5 Sep 2014 15:08:10 -0500
Message-ID: <1409947698-30781-5-git-send-email-john.hammond@intel.com>
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

Move the structures defined in lustre/include/obd_ost.h to the one
file that uses them (lustre/osc/osc_request.c). Remove the unused
function osc_update_enqueue(). Remove the then empty header
lustre/include/obd_ost.h.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 .../staging/lustre/lustre/include/lustre_lite.h    |    1 -
 drivers/staging/lustre/lustre/include/lustre_log.h |    1 -
 drivers/staging/lustre/lustre/include/obd_ost.h    |  100 --------------------
 drivers/staging/lustre/lustre/lov/lov_obd.c        |    1 -
 drivers/staging/lustre/lustre/lov/lov_request.c    |    1 -
 drivers/staging/lustre/lustre/obdclass/debug.c     |    1 -
 drivers/staging/lustre/lustre/obdclass/genops.c    |    1 -
 .../staging/lustre/lustre/osc/osc_cl_internal.h    |    1 -
 drivers/staging/lustre/lustre/osc/osc_quota.c      |    2 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    |   90 +++++++++---------
 drivers/staging/lustre/lustre/ptlrpc/recover.c     |    1 -
 11 files changed, 44 insertions(+), 156 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/obd_ost.h

diff --git a/drivers/staging/lustre/lustre/include/lustre_lite.h b/drivers/staging/lustre/lustre/include/lustre_lite.h
index c10c0d3..df557c2 100644
--- a/drivers/staging/lustre/lustre/include/lustre_lite.h
+++ b/drivers/staging/lustre/lustre/include/lustre_lite.h
@@ -45,7 +45,6 @@
 #include "linux/lustre_lite.h"
 
 #include "obd_class.h"
-#include "obd_ost.h"
 #include "lustre_net.h"
 #include "lustre_mds.h"
 #include "lustre_ha.h"
diff --git a/drivers/staging/lustre/lustre/include/lustre_log.h b/drivers/staging/lustre/lustre/include/lustre_log.h
index 2f50b81..36a2ffb 100644
--- a/drivers/staging/lustre/lustre/include/lustre_log.h
+++ b/drivers/staging/lustre/lustre/include/lustre_log.h
@@ -57,7 +57,6 @@
  */
 
 #include "obd_class.h"
-#include "obd_ost.h"
 #include "lustre/lustre_idl.h"
 #include "dt_object.h"
 
diff --git a/drivers/staging/lustre/lustre/include/obd_ost.h b/drivers/staging/lustre/lustre/include/obd_ost.h
deleted file mode 100644
index a679bb1..0000000
--- a/drivers/staging/lustre/lustre/include/obd_ost.h
+++ /dev/null
@@ -1,100 +0,0 @@
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
- * Copyright (c) 2007, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2012, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * lustre/include/obd_ost.h
- *
- * Data structures for object storage targets and client: OST & OSC's
- *
- * See also lustre_idl.h for wire formats of requests.
- */
-
-#ifndef _LUSTRE_OST_H
-#define _LUSTRE_OST_H
-
-#include "obd_class.h"
-
-struct osc_brw_async_args {
-	struct obdo       *aa_oa;
-	int		aa_requested_nob;
-	int		aa_nio_count;
-	u32		aa_page_count;
-	int		aa_resends;
-	struct brw_page  **aa_ppga;
-	struct client_obd *aa_cli;
-	struct list_head	 aa_oaps;
-	struct list_head	 aa_exts;
-	struct obd_capa   *aa_ocapa;
-	struct cl_req     *aa_clerq;
-};
-
-#define osc_grant_args osc_brw_async_args
-struct osc_async_args {
-	struct obd_info   *aa_oi;
-};
-
-struct osc_setattr_args {
-	struct obdo	 *sa_oa;
-	obd_enqueue_update_f sa_upcall;
-	void		*sa_cookie;
-};
-
-struct osc_fsync_args {
-	struct obd_info     *fa_oi;
-	obd_enqueue_update_f fa_upcall;
-	void		*fa_cookie;
-};
-
-struct osc_enqueue_args {
-	struct obd_export	*oa_exp;
-	__u64		    *oa_flags;
-	obd_enqueue_update_f      oa_upcall;
-	void		     *oa_cookie;
-	struct ost_lvb	   *oa_lvb;
-	struct lustre_handle     *oa_lockh;
-	struct ldlm_enqueue_info *oa_ei;
-	unsigned int	      oa_agl:1;
-};
-
-extern void osc_update_enqueue(struct lustre_handle *lov_lockhp,
-			       struct lov_oinfo *loi, __u64 flags,
-			       struct ost_lvb *lvb, __u32 mode, int rc);
-
-#if 0
-int osc_extent_blocking_cb(struct ldlm_lock *lock,
-			   struct ldlm_lock_desc *new, void *data,
-			   int flag);
-#endif
-
-#endif
diff --git a/drivers/staging/lustre/lustre/lov/lov_obd.c b/drivers/staging/lustre/lustre/lov/lov_obd.c
index a1f8c7e..d1eb6df 100644
--- a/drivers/staging/lustre/lustre/lov/lov_obd.c
+++ b/drivers/staging/lustre/lustre/lov/lov_obd.c
@@ -51,7 +51,6 @@
 #include "../include/lustre_dlm.h"
 #include "../include/lustre_mds.h"
 #include "../include/obd_class.h"
-#include "../include/obd_ost.h"
 #include "../include/lprocfs_status.h"
 #include "../include/lustre_param.h"
 #include "../include/cl_object.h"
diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
index 19d4d70..f576750 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -39,7 +39,6 @@
 #include "../../include/linux/libcfs/libcfs.h"
 
 #include "../include/obd_class.h"
-#include "../include/obd_ost.h"
 #include "../include/lustre/lustre_idl.h"
 #include "lov_internal.h"
 
diff --git a/drivers/staging/lustre/lustre/obdclass/debug.c b/drivers/staging/lustre/lustre/obdclass/debug.c
index e8aa42b..d0f8f87 100644
--- a/drivers/staging/lustre/lustre/obdclass/debug.c
+++ b/drivers/staging/lustre/lustre/obdclass/debug.c
@@ -41,7 +41,6 @@
 #define DEBUG_SUBSYSTEM D_OTHER
 
 
-#include "../include/obd_ost.h"
 #include "../include/obd_support.h"
 #include "../include/lustre_debug.h"
 #include "../include/lustre_net.h"
diff --git a/drivers/staging/lustre/lustre/obdclass/genops.c b/drivers/staging/lustre/lustre/obdclass/genops.c
index c2e561d..d5bfbb8 100644
--- a/drivers/staging/lustre/lustre/obdclass/genops.c
+++ b/drivers/staging/lustre/lustre/obdclass/genops.c
@@ -40,7 +40,6 @@
  */
 
 #define DEBUG_SUBSYSTEM S_CLASS
-#include "../include/obd_ost.h"
 #include "../include/obd_class.h"
 #include "../include/lprocfs_status.h"
 
diff --git a/drivers/staging/lustre/lustre/osc/osc_cl_internal.h b/drivers/staging/lustre/lustre/osc/osc_cl_internal.h
index 3aa80d9..ebbd95c 100644
--- a/drivers/staging/lustre/lustre/osc/osc_cl_internal.h
+++ b/drivers/staging/lustre/lustre/osc/osc_cl_internal.h
@@ -50,7 +50,6 @@
 
 #include "../include/obd.h"
 /* osc_build_res_name() */
-#include "../include/obd_ost.h"
 #include "../include/cl_object.h"
 #include "../include/lclient.h"
 #include "osc_internal.h"
diff --git a/drivers/staging/lustre/lustre/osc/osc_quota.c b/drivers/staging/lustre/lustre/osc/osc_quota.c
index 6987261..6690f14 100644
--- a/drivers/staging/lustre/lustre/osc/osc_quota.c
+++ b/drivers/staging/lustre/lustre/osc/osc_quota.c
@@ -28,7 +28,7 @@
  * Code originally extracted from quota directory
  */
 
-#include "../include/obd_ost.h"
+#include "../include/obd_class.h"
 #include "osc_internal.h"
 
 static inline struct osc_quota_info *osc_oqi_alloc(u32 id)
diff --git a/drivers/staging/lustre/lustre/osc/osc_request.c b/drivers/staging/lustre/lustre/osc/osc_request.c
index ecca3eb..e10bacb 100644
--- a/drivers/staging/lustre/lustre/osc/osc_request.c
+++ b/drivers/staging/lustre/lustre/osc/osc_request.c
@@ -43,7 +43,6 @@
 #include "../include/lustre_net.h"
 #include "../include/lustre/lustre_user.h"
 #include "../include/obd_cksum.h"
-#include "../include/obd_ost.h"
 
 #include "../include/lustre_ha.h"
 #include "../include/lprocfs_status.h"
@@ -54,6 +53,47 @@
 #include "osc_internal.h"
 #include "osc_cl_internal.h"
 
+struct osc_brw_async_args {
+	struct obdo       *aa_oa;
+	int		aa_requested_nob;
+	int		aa_nio_count;
+	u32		aa_page_count;
+	int		aa_resends;
+	struct brw_page  **aa_ppga;
+	struct client_obd *aa_cli;
+	struct list_head	 aa_oaps;
+	struct list_head	 aa_exts;
+	struct obd_capa   *aa_ocapa;
+	struct cl_req     *aa_clerq;
+};
+
+struct osc_async_args {
+	struct obd_info   *aa_oi;
+};
+
+struct osc_setattr_args {
+	struct obdo	 *sa_oa;
+	obd_enqueue_update_f sa_upcall;
+	void		*sa_cookie;
+};
+
+struct osc_fsync_args {
+	struct obd_info     *fa_oi;
+	obd_enqueue_update_f fa_upcall;
+	void		*fa_cookie;
+};
+
+struct osc_enqueue_args {
+	struct obd_export	*oa_exp;
+	__u64		    *oa_flags;
+	obd_enqueue_update_f      oa_upcall;
+	void		     *oa_cookie;
+	struct ost_lvb	   *oa_lvb;
+	struct lustre_handle     *oa_lockh;
+	struct ldlm_enqueue_info *oa_ei;
+	unsigned int	      oa_agl:1;
+};
+
 static void osc_release_ppga(struct brw_page **ppga, u32 count);
 static int brw_interpret(const struct lu_env *env,
 			 struct ptlrpc_request *req, void *data, int rc);
@@ -846,7 +886,7 @@ static int osc_shrink_grant_interpret(const struct lu_env *env,
 				      void *aa, int rc)
 {
 	struct client_obd *cli = &req->rq_import->imp_obd->u.cli;
-	struct obdo *oa = ((struct osc_grant_args *)aa)->aa_oa;
+	struct obdo *oa = ((struct osc_brw_async_args *)aa)->aa_oa;
 	struct ost_body *body;
 
 	if (rc != 0) {
@@ -2174,50 +2214,6 @@ static int osc_enqueue_interpret(const struct lu_env *env,
 	return rc;
 }
 
-void osc_update_enqueue(struct lustre_handle *lov_lockhp,
-			struct lov_oinfo *loi, __u64 flags,
-			struct ost_lvb *lvb, __u32 mode, int rc)
-{
-	struct ldlm_lock *lock = ldlm_handle2lock(lov_lockhp);
-
-	if (rc == ELDLM_OK) {
-		__u64 tmp;
-
-		LASSERT(lock != NULL);
-		loi->loi_lvb = *lvb;
-		tmp = loi->loi_lvb.lvb_size;
-		/* Extend KMS up to the end of this lock and no further
-		 * A lock on [x,y] means a KMS of up to y + 1 bytes! */
-		if (tmp > lock->l_policy_data.l_extent.end)
-			tmp = lock->l_policy_data.l_extent.end + 1;
-		if (tmp >= loi->loi_kms) {
-			LDLM_DEBUG(lock, "lock acquired, setting rss=%llu, kms=%llu",
-				   loi->loi_lvb.lvb_size, tmp);
-			loi_kms_set(loi, tmp);
-		} else {
-			LDLM_DEBUG(lock, "lock acquired, setting rss=%llu; leaving kms=%llu, end=%llu",
-				   loi->loi_lvb.lvb_size, loi->loi_kms,
-				   lock->l_policy_data.l_extent.end);
-		}
-		ldlm_lock_allow_match(lock);
-	} else if (rc == ELDLM_LOCK_ABORTED && (flags & LDLM_FL_HAS_INTENT)) {
-		LASSERT(lock != NULL);
-		loi->loi_lvb = *lvb;
-		ldlm_lock_allow_match(lock);
-		CDEBUG(D_INODE, "glimpsed, setting rss=%llu; leaving kms=%llu\n",
-		       loi->loi_lvb.lvb_size, loi->loi_kms);
-		rc = ELDLM_OK;
-	}
-
-	if (lock != NULL) {
-		if (rc != ELDLM_OK)
-			ldlm_lock_fail_match(lock);
-
-		LDLM_LOCK_PUT(lock);
-	}
-}
-EXPORT_SYMBOL(osc_update_enqueue);
-
 struct ptlrpc_request_set *PTLRPCD_SET = (void *)1;
 
 /* When enqueuing asynchronously, locks are not ordered, we can obtain a lock
@@ -2935,7 +2931,7 @@ static int osc_set_info_async(const struct lu_env *env, struct obd_export *exp,
 	memcpy(tmp, val, vallen);
 
 	if (KEY_IS(KEY_GRANT_SHRINK)) {
-		struct osc_grant_args *aa;
+		struct osc_brw_async_args *aa;
 		struct obdo *oa;
 
 		CLASSERT(sizeof(*aa) <= sizeof(req->rq_async_args));
diff --git a/drivers/staging/lustre/lustre/ptlrpc/recover.c b/drivers/staging/lustre/lustre/ptlrpc/recover.c
index 5e4a1a5..e26e5b8 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/recover.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/recover.c
@@ -47,7 +47,6 @@
 #include "../include/lustre_import.h"
 #include "../include/lustre_export.h"
 #include "../include/obd.h"
-#include "../include/obd_ost.h"
 #include "../include/obd_class.h"
 #include <linux/list.h>
 
-- 
1.7.9.5

