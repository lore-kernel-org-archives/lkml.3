Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaD0RIE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:08:04 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48012 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbaD0RH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:57 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: "John L. Hammond" <john.hammond@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 16/47] staging/lustre/obdclass: remove uses of lov_stripe_md
Date: Sun, 27 Apr 2014 13:06:40 -0400
Message-Id: <1398618431-29757-17-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Remove the unused function llog_obd_add(). Remove the unused count and
parameters from llog_cancel(). Move dump_lsm() from obdclass to
the only module that uses it (lov). Remove obd_lov.h.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-on: http://review.whamcloud.com/8545
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2675
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      |  26 +++++
 .../staging/lustre/lustre/include/lustre_debug.h   |   1 -
 drivers/staging/lustre/lustre/include/lustre_log.h |  10 --
 drivers/staging/lustre/lustre/include/obd.h        |   7 ++
 drivers/staging/lustre/lustre/include/obd_class.h  |   9 --
 drivers/staging/lustre/lustre/include/obd_lov.h    | 116 ---------------------
 drivers/staging/lustre/lustre/lov/lov_ea.c         |  12 ++-
 drivers/staging/lustre/lustre/lov/lov_internal.h   |  33 +++++-
 drivers/staging/lustre/lustre/lov/lov_merge.c      |   2 -
 drivers/staging/lustre/lustre/lov/lov_obd.c        |   9 +-
 drivers/staging/lustre/lustre/lov/lov_object.c     |   1 -
 drivers/staging/lustre/lustre/lov/lov_offset.c     |   1 -
 drivers/staging/lustre/lustre/lov/lov_pack.c       |  10 +-
 drivers/staging/lustre/lustre/lov/lov_request.c    |   1 -
 drivers/staging/lustre/lustre/obdclass/debug.c     |  12 ---
 drivers/staging/lustre/lustre/obdclass/llog_obd.c  |  29 +-----
 .../staging/lustre/lustre/obdecho/echo_client.c    |   1 -
 drivers/staging/lustre/lustre/osc/osc_request.c    |   1 -
 drivers/staging/lustre/lustre/ptlrpc/recover.c     |   1 -
 19 files changed, 85 insertions(+), 197 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/obd_lov.h

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 87905bb..abd29bf 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -1682,6 +1682,30 @@ static inline __u32 lov_mds_md_size(__u16 stripes, __u32 lmm_magic)
 				stripes * sizeof(struct lov_ost_data_v1);
 }
 
+static inline __u32
+lov_mds_md_max_stripe_count(size_t buf_size, __u32 lmm_magic)
+{
+	switch (lmm_magic) {
+	case LOV_MAGIC_V1: {
+		struct lov_mds_md_v1 lmm;
+
+		if (buf_size < sizeof(lmm))
+			return 0;
+
+		return (buf_size - sizeof(lmm)) / sizeof(lmm.lmm_objects[0]);
+	}
+	case LOV_MAGIC_V3: {
+		struct lov_mds_md_v3 lmm;
+
+		if (buf_size < sizeof(lmm))
+			return 0;
+
+		return (buf_size - sizeof(lmm)) / sizeof(lmm.lmm_objects[0]);
+	}
+	default:
+		return 0;
+	}
+}
 
 #define OBD_MD_FLID	(0x00000001ULL) /* object ID */
 #define OBD_MD_FLATIME     (0x00000002ULL) /* access time */
@@ -2681,6 +2705,8 @@ enum seq_op {
  * protocol, this will limit the max number of OSTs per LOV */
 
 #define LOV_DESC_MAGIC 0xB0CCDE5C
+#define LOV_DESC_QOS_MAXAGE_DEFAULT 5  /* Seconds */
+#define LOV_DESC_STRIPE_SIZE_DEFAULT (1 << LNET_MTU_BITS)
 
 /* LOV settings descriptor (should only contain static info) */
 struct lov_desc {
diff --git a/drivers/staging/lustre/lustre/include/lustre_debug.h b/drivers/staging/lustre/lustre/include/lustre_debug.h
index 7ec91ed..6146ccb 100644
--- a/drivers/staging/lustre/lustre/include/lustre_debug.h
+++ b/drivers/staging/lustre/lustre/include/lustre_debug.h
@@ -48,7 +48,6 @@
 /* lib/debug.c */
 void dump_lniobuf(struct niobuf_local *lnb);
 int dump_req(struct ptlrpc_request *req);
-void dump_lsm(int level, struct lov_stripe_md *lsm);
 int block_debug_setup(void *addr, int len, __u64 off, __u64 id);
 int block_debug_check(char *who, void *addr, int len, __u64 off, __u64 id);
 
diff --git a/drivers/staging/lustre/lustre/include/lustre_log.h b/drivers/staging/lustre/lustre/include/lustre_log.h
index 896c757..1a9a922 100644
--- a/drivers/staging/lustre/lustre/include/lustre_log.h
+++ b/drivers/staging/lustre/lustre/include/lustre_log.h
@@ -206,11 +206,7 @@ int llog_setup(const struct lu_env *env, struct obd_device *obd,
 int __llog_ctxt_put(const struct lu_env *env, struct llog_ctxt *ctxt);
 int llog_cleanup(const struct lu_env *env, struct llog_ctxt *);
 int llog_sync(struct llog_ctxt *ctxt, struct obd_export *exp, int flags);
-int llog_obd_add(const struct lu_env *env, struct llog_ctxt *ctxt,
-		 struct llog_rec_hdr *rec, struct lov_stripe_md *lsm,
-		 struct llog_cookie *logcookies, int numcookies);
 int llog_cancel(const struct lu_env *env, struct llog_ctxt *ctxt,
-		struct lov_stripe_md *lsm, int count,
 		struct llog_cookie *cookies, int flags);
 
 int obd_llog_init(struct obd_device *obd, struct obd_llog_group *olg,
@@ -242,7 +238,6 @@ struct llog_operations {
 			int flags);
 	int (*lop_cleanup)(const struct lu_env *env, struct llog_ctxt *ctxt);
 	int (*lop_cancel)(const struct lu_env *env, struct llog_ctxt *ctxt,
-			  struct lov_stripe_md *lsm, int count,
 			  struct llog_cookie *cookies, int flags);
 	int (*lop_connect)(struct llog_ctxt *ctxt, struct llog_logid *logid,
 			   struct llog_gen *gen, struct obd_uuid *uuid);
@@ -296,11 +291,6 @@ struct llog_operations {
 	int (*lop_add)(const struct lu_env *env, struct llog_handle *lgh,
 		       struct llog_rec_hdr *rec, struct llog_cookie *cookie,
 		       void *buf, struct thandle *th);
-	/* Old llog_add version, used in MDS-LOV-OSC now and will gone with
-	 * LOD/OSP replacement */
-	int (*lop_obd_add)(const struct lu_env *env, struct llog_ctxt *ctxt,
-			   struct llog_rec_hdr *rec, struct lov_stripe_md *lsm,
-			   struct llog_cookie *logcookies, int numcookies);
 };
 
 /* In-memory descriptor for a log object or log catalog */
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index 72cf3fe..75fdf19 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -132,6 +132,13 @@ static inline bool lsm_has_objects(struct lov_stripe_md *lsm)
 	return true;
 }
 
+static inline int lov_stripe_md_size(unsigned int stripe_count)
+{
+	struct lov_stripe_md lsm;
+
+	return sizeof(lsm) + stripe_count * sizeof(lsm.lsm_oinfo[0]);
+}
+
 struct obd_info;
 
 typedef int (*obd_enqueue_update_f)(void *cookie, int rc);
diff --git a/drivers/staging/lustre/lustre/include/obd_class.h b/drivers/staging/lustre/lustre/include/obd_class.h
index 6c8e1ab..956abe7 100644
--- a/drivers/staging/lustre/lustre/include/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/obd_class.h
@@ -711,15 +711,6 @@ static inline int obd_size_diskmd(struct obd_export *exp,
 	return obd_packmd(exp, NULL, mem_src);
 }
 
-/* helper functions */
-static inline int obd_alloc_diskmd(struct obd_export *exp,
-				   struct lov_mds_md **disk_tgt)
-{
-	LASSERT(disk_tgt);
-	LASSERT(*disk_tgt == NULL);
-	return obd_packmd(exp, disk_tgt, NULL);
-}
-
 static inline int obd_free_diskmd(struct obd_export *exp,
 				  struct lov_mds_md **disk_tgt)
 {
diff --git a/drivers/staging/lustre/lustre/include/obd_lov.h b/drivers/staging/lustre/lustre/include/obd_lov.h
deleted file mode 100644
index 235718b..0000000
--- a/drivers/staging/lustre/lustre/include/obd_lov.h
+++ /dev/null
@@ -1,116 +0,0 @@
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
- * Copyright (c) 2002, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2011, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- */
-
-#ifndef _OBD_LOV_H__
-#define _OBD_LOV_H__
-
-#define LOV_DEFAULT_STRIPE_SIZE (1 << LNET_MTU_BITS)
-
-static inline int lov_stripe_md_size(__u16 stripes)
-{
-	return sizeof(struct lov_stripe_md) + stripes*sizeof(struct lov_oinfo*);
-}
-
-struct lov_version_size {
-	__u32   lvs_magic;
-	size_t  lvs_lmm_size;
-	size_t  lvs_lod_size;
-};
-
-static inline __u32 lov_mds_md_stripecnt(int ea_size, __u32 lmm_magic)
-{
-	static const struct lov_version_size lmm_ver_size[] = {
-			{ .lvs_magic = LOV_MAGIC_V3,
-			  .lvs_lmm_size = sizeof(struct lov_mds_md_v3),
-			  .lvs_lod_size = sizeof(struct lov_ost_data_v1) },
-			{ .lvs_magic = LOV_MAGIC_V1,
-			  .lvs_lmm_size = sizeof(struct lov_mds_md_v1),
-			  .lvs_lod_size = sizeof(struct lov_ost_data_v1)} };
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(lmm_ver_size); i++) {
-		if (lmm_magic == lmm_ver_size[i].lvs_magic) {
-			if (ea_size <= lmm_ver_size[i].lvs_lmm_size)
-				return 0;
-			return (ea_size - lmm_ver_size[i].lvs_lmm_size) /
-				lmm_ver_size[i].lvs_lod_size;
-		}
-	}
-
-	/* Invalid LOV magic, so no stripes could fit */
-	return 0;
-}
-
-/* lov_do_div64(a, b) returns a % b, and a = a / b.
- * The 32-bit code is LOV-specific due to knowing about stripe limits in
- * order to reduce the divisor to a 32-bit number.  If the divisor is
- * already a 32-bit value the compiler handles this directly. */
-#if BITS_PER_LONG > 32
-# define lov_do_div64(n,base) ({					\
-	uint64_t __base = (base);					\
-	uint64_t __rem;							\
-	__rem = ((uint64_t)(n)) % __base;				\
-	(n) = ((uint64_t)(n)) / __base;					\
-	__rem;								\
-  })
-#else
-# define lov_do_div64(n,base) ({					\
-	uint64_t __rem;							\
-	if ((sizeof(base) > 4) && (((base) & 0xffffffff00000000ULL) != 0)) {  \
-		int __remainder;					      \
-		LASSERTF(!((base) & (LOV_MIN_STRIPE_SIZE - 1)), "64 bit lov " \
-			 "division %llu / %llu\n", (n), (uint64_t)(base));    \
-		__remainder = (n) & (LOV_MIN_STRIPE_SIZE - 1);		\
-		(n) >>= LOV_MIN_STRIPE_BITS;				\
-		__rem = do_div(n, (base) >> LOV_MIN_STRIPE_BITS);	\
-		__rem <<= LOV_MIN_STRIPE_BITS;				\
-		__rem += __remainder;					\
-	} else {							\
-		__rem = do_div(n, base);				\
-	}								\
-	__rem;								\
-  })
-#endif
-
-#define IOC_LOV_TYPE		   'g'
-#define IOC_LOV_MIN_NR		 50
-#define IOC_LOV_SET_OSC_ACTIVE	 _IOWR('g', 50, long)
-#define IOC_LOV_MAX_NR		 50
-
-#define QOS_DEFAULT_THRESHOLD	   10 /* MB */
-#define QOS_DEFAULT_MAXAGE	      5  /* Seconds */
-
-#endif
diff --git a/drivers/staging/lustre/lustre/lov/lov_ea.c b/drivers/staging/lustre/lustre/lov/lov_ea.c
index b91cb2a..a0c148e 100644
--- a/drivers/staging/lustre/lustre/lov/lov_ea.c
+++ b/drivers/staging/lustre/lustre/lov/lov_ea.c
@@ -44,7 +44,6 @@
 #include <linux/libcfs/libcfs.h>
 
 #include <obd_class.h>
-#include <obd_lov.h>
 #include <lustre/lustre_idl.h>
 
 #include "lov_internal.h"
@@ -346,3 +345,14 @@ const struct lsm_operations lsm_v3_ops = {
 	.lsm_lmm_verify	 = lsm_lmm_verify_v3,
 	.lsm_unpackmd	   = lsm_unpackmd_v3,
 };
+
+void dump_lsm(unsigned int level, const struct lov_stripe_md *lsm)
+{
+	CDEBUG(level, "lsm %p, objid "DOSTID", maxbytes "LPX64", magic 0x%08X,"
+	       " stripe_size %u, stripe_count %u, refc: %d,"
+	       " layout_gen %u, pool ["LOV_POOLNAMEF"]\n", lsm,
+	       POSTID(&lsm->lsm_oi), lsm->lsm_maxbytes, lsm->lsm_magic,
+	       lsm->lsm_stripe_size, lsm->lsm_stripe_count,
+	       atomic_read(&lsm->lsm_refc), lsm->lsm_layout_gen,
+	       lsm->lsm_pool_name);
+}
diff --git a/drivers/staging/lustre/lustre/lov/lov_internal.h b/drivers/staging/lustre/lustre/lov/lov_internal.h
index 10e18c2..38508a5 100644
--- a/drivers/staging/lustre/lustre/lov/lov_internal.h
+++ b/drivers/staging/lustre/lustre/lov/lov_internal.h
@@ -38,9 +38,39 @@
 #define LOV_INTERNAL_H
 
 #include <obd_class.h>
-#include <obd_lov.h>
 #include <lustre/lustre_user.h>
 
+/* lov_do_div64(a, b) returns a % b, and a = a / b.
+ * The 32-bit code is LOV-specific due to knowing about stripe limits in
+ * order to reduce the divisor to a 32-bit number.  If the divisor is
+ * already a 32-bit value the compiler handles this directly. */
+#if BITS_PER_LONG == 64
+# define lov_do_div64(n, base) ({					\
+	uint64_t __base = (base);					\
+	uint64_t __rem;							\
+	__rem = ((uint64_t)(n)) % __base;				\
+	(n) = ((uint64_t)(n)) / __base;					\
+	__rem;								\
+})
+#elif BITS_PER_LONG == 32
+# define lov_do_div64(n, base) ({					\
+	uint64_t __rem;							\
+	if ((sizeof(base) > 4) && (((base) & 0xffffffff00000000ULL) != 0)) {  \
+		int __remainder;					      \
+		LASSERTF(!((base) & (LOV_MIN_STRIPE_SIZE - 1)), "64 bit lov " \
+			 "division %llu / %llu\n", (n), (uint64_t)(base));    \
+		__remainder = (n) & (LOV_MIN_STRIPE_SIZE - 1);		\
+		(n) >>= LOV_MIN_STRIPE_BITS;				\
+		__rem = do_div(n, (base) >> LOV_MIN_STRIPE_BITS);	\
+		__rem <<= LOV_MIN_STRIPE_BITS;				\
+		__rem += __remainder;					\
+	} else {							\
+		__rem = do_div(n, base);				\
+	}								\
+	__rem;								\
+})
+#endif
+
 struct lov_lock_handles {
 	struct portals_handle   llh_handle;
 	atomic_t	    llh_refcount;
@@ -275,6 +305,7 @@ void lov_dump_lmm(int level, void *lmm);
 /* lov_ea.c */
 struct lov_stripe_md *lsm_alloc_plain(__u16 stripe_count, int *size);
 void lsm_free_plain(struct lov_stripe_md *lsm);
+void dump_lsm(unsigned int level, const struct lov_stripe_md *lsm);
 
 int lovea_destroy_object(struct lov_obd *lov, struct lov_stripe_md *lsm,
 			 struct obdo *oa, void *data);
diff --git a/drivers/staging/lustre/lustre/lov/lov_merge.c b/drivers/staging/lustre/lustre/lov/lov_merge.c
index 9defa55..0a14cee 100644
--- a/drivers/staging/lustre/lustre/lov/lov_merge.c
+++ b/drivers/staging/lustre/lustre/lov/lov_merge.c
@@ -39,8 +39,6 @@
 #include <linux/libcfs/libcfs.h>
 
 #include <obd_class.h>
-#include <obd_lov.h>
-
 #include "lov_internal.h"
 
 /** Merge the lock value block(&lvb) attributes and KMS from each of the
diff --git a/drivers/staging/lustre/lustre/lov/lov_obd.c b/drivers/staging/lustre/lustre/lov/lov_obd.c
index f66ba57..dbd971a 100644
--- a/drivers/staging/lustre/lustre/lov/lov_obd.c
+++ b/drivers/staging/lustre/lustre/lov/lov_obd.c
@@ -50,9 +50,7 @@
 #include <lustre/lustre_idl.h>
 #include <lustre_dlm.h>
 #include <lustre_mds.h>
-#include <lustre_debug.h>
 #include <obd_class.h>
-#include <obd_lov.h>
 #include <obd_ost.h>
 #include <lprocfs_status.h>
 #include <lustre_param.h>
@@ -725,8 +723,8 @@ void lov_fix_desc_stripe_size(__u64 *val)
 		if (*val != 0)
 			LCONSOLE_INFO("Increasing default stripe size to "
 				      "minimum %u\n",
-				      LOV_DEFAULT_STRIPE_SIZE);
-		*val = LOV_DEFAULT_STRIPE_SIZE;
+				      LOV_DESC_STRIPE_SIZE_DEFAULT);
+		*val = LOV_DESC_STRIPE_SIZE_DEFAULT;
 	} else if (*val & (LOV_MIN_STRIPE_SIZE - 1)) {
 		*val &= ~(LOV_MIN_STRIPE_SIZE - 1);
 		LCONSOLE_WARN("Changing default stripe size to "LPU64" (a "
@@ -752,9 +750,8 @@ void lov_fix_desc_pattern(__u32 *val)
 
 void lov_fix_desc_qos_maxage(__u32 *val)
 {
-	/* fix qos_maxage */
 	if (*val == 0)
-		*val = QOS_DEFAULT_MAXAGE;
+		*val = LOV_DESC_QOS_MAXAGE_DEFAULT;
 }
 
 void lov_fix_desc(struct lov_desc *desc)
diff --git a/drivers/staging/lustre/lustre/lov/lov_object.c b/drivers/staging/lustre/lustre/lov/lov_object.c
index f20e497..992c80a 100644
--- a/drivers/staging/lustre/lustre/lov/lov_object.c
+++ b/drivers/staging/lustre/lustre/lov/lov_object.c
@@ -42,7 +42,6 @@
 #define DEBUG_SUBSYSTEM S_LOV
 
 #include "lov_cl_internal.h"
-#include <lustre_debug.h>
 
 /** \addtogroup lov
  *  @{
diff --git a/drivers/staging/lustre/lustre/lov/lov_offset.c b/drivers/staging/lustre/lustre/lov/lov_offset.c
index 04863a7..379568f 100644
--- a/drivers/staging/lustre/lustre/lov/lov_offset.c
+++ b/drivers/staging/lustre/lustre/lov/lov_offset.c
@@ -39,7 +39,6 @@
 #include <linux/libcfs/libcfs.h>
 
 #include <obd_class.h>
-#include <obd_lov.h>
 
 #include "lov_internal.h"
 
diff --git a/drivers/staging/lustre/lustre/lov/lov_pack.c b/drivers/staging/lustre/lustre/lov/lov_pack.c
index 74200cf..59ab7c3 100644
--- a/drivers/staging/lustre/lustre/lov/lov_pack.c
+++ b/drivers/staging/lustre/lustre/lov/lov_pack.c
@@ -44,7 +44,6 @@
 
 #include <lustre_net.h>
 #include <obd.h>
-#include <obd_lov.h>
 #include <obd_class.h>
 #include <obd_support.h>
 #include <lustre/lustre_user.h>
@@ -177,8 +176,9 @@ int lov_packmd(struct obd_export *exp, struct lov_mds_md **lmmp,
 		 * Anyway, this is pretty inaccurate since ld_tgt_count now
 		 * represents max index and we should rely on the actual number
 		 * of OSTs instead */
-		stripe_count = lov_mds_md_stripecnt(lov->lov_ocd.ocd_max_easize,
-						    lmm_magic);
+		stripe_count = lov_mds_md_max_stripe_count(
+			lov->lov_ocd.ocd_max_easize, lmm_magic);
+
 		if (stripe_count > lov->desc.ld_tgt_count)
 			stripe_count = lov->desc.ld_tgt_count;
 	}
@@ -264,8 +264,8 @@ __u16 lov_get_stripecnt(struct lov_obd *lov, __u32 magic, __u16 stripe_count)
 	 * larger EA sizes */
 	if (lov->lov_ocd.ocd_connect_flags & OBD_CONNECT_MAX_EASIZE &&
 	    lov->lov_ocd.ocd_max_easize)
-		max_stripes = lov_mds_md_stripecnt(lov->lov_ocd.ocd_max_easize,
-						   magic);
+		max_stripes = lov_mds_md_max_stripe_count(
+			lov->lov_ocd.ocd_max_easize, magic);
 
 	if (stripe_count > max_stripes)
 		stripe_count = max_stripes;
diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
index a5481d7..bd6490d 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -39,7 +39,6 @@
 #include <linux/libcfs/libcfs.h>
 
 #include <obd_class.h>
-#include <obd_lov.h>
 #include <lustre/lustre_idl.h>
 
 #include "lov_internal.h"
diff --git a/drivers/staging/lustre/lustre/obdclass/debug.c b/drivers/staging/lustre/lustre/obdclass/debug.c
index 15f71bb..a4e7e75 100644
--- a/drivers/staging/lustre/lustre/obdclass/debug.c
+++ b/drivers/staging/lustre/lustre/obdclass/debug.c
@@ -56,18 +56,6 @@ void dump_lniobuf(struct niobuf_local *nb)
 }
 EXPORT_SYMBOL(dump_lniobuf);
 
-void dump_lsm(int level, struct lov_stripe_md *lsm)
-{
-	CDEBUG(level, "lsm %p, objid "DOSTID", maxbytes "LPX64", magic 0x%08X,"
-	       " stripe_size %u, stripe_count %u, refc: %d,"
-	       " layout_gen %u, pool ["LOV_POOLNAMEF"]\n", lsm,
-	       POSTID(&lsm->lsm_oi), lsm->lsm_maxbytes, lsm->lsm_magic,
-	       lsm->lsm_stripe_size, lsm->lsm_stripe_count,
-	       atomic_read(&lsm->lsm_refc), lsm->lsm_layout_gen,
-	       lsm->lsm_pool_name);
-}
-EXPORT_SYMBOL(dump_lsm);
-
 #define LPDS sizeof(__u64)
 int block_debug_setup(void *addr, int len, __u64 off, __u64 id)
 {
diff --git a/drivers/staging/lustre/lustre/obdclass/llog_obd.c b/drivers/staging/lustre/lustre/obdclass/llog_obd.c
index 71817af..2c6d81e 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_obd.c
@@ -226,34 +226,7 @@ int llog_sync(struct llog_ctxt *ctxt, struct obd_export *exp, int flags)
 }
 EXPORT_SYMBOL(llog_sync);
 
-int llog_obd_add(const struct lu_env *env, struct llog_ctxt *ctxt,
-		 struct llog_rec_hdr *rec, struct lov_stripe_md *lsm,
-		 struct llog_cookie *logcookies, int numcookies)
-{
-	int raised, rc;
-
-	if (!ctxt) {
-		CERROR("No ctxt\n");
-		return -ENODEV;
-	}
-
-	if (ctxt->loc_flags & LLOG_CTXT_FLAG_UNINITIALIZED)
-		return -ENXIO;
-
-	CTXT_CHECK_OP(ctxt, obd_add, -EOPNOTSUPP);
-	raised = cfs_cap_raised(CFS_CAP_SYS_RESOURCE);
-	if (!raised)
-		cfs_cap_raise(CFS_CAP_SYS_RESOURCE);
-	rc = CTXTP(ctxt, obd_add)(env, ctxt, rec, lsm, logcookies,
-				  numcookies);
-	if (!raised)
-		cfs_cap_lower(CFS_CAP_SYS_RESOURCE);
-	return rc;
-}
-EXPORT_SYMBOL(llog_obd_add);
-
 int llog_cancel(const struct lu_env *env, struct llog_ctxt *ctxt,
-		struct lov_stripe_md *lsm, int count,
 		struct llog_cookie *cookies, int flags)
 {
 	int rc;
@@ -264,7 +237,7 @@ int llog_cancel(const struct lu_env *env, struct llog_ctxt *ctxt,
 	}
 
 	CTXT_CHECK_OP(ctxt, cancel, -EOPNOTSUPP);
-	rc = CTXTP(ctxt, cancel)(env, ctxt, lsm, count, cookies, flags);
+	rc = CTXTP(ctxt, cancel)(env, ctxt, cookies, flags);
 	return rc;
 }
 EXPORT_SYMBOL(llog_cancel);
diff --git a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
index 0eb39f2..cdc4671 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -47,7 +47,6 @@
 #include <lustre_fid.h>
 #include <lustre_acl.h>
 #include <lustre_net.h>
-#include <obd_lov.h>
 
 #include "echo_internal.h"
 
diff --git a/drivers/staging/lustre/lustre/osc/osc_request.c b/drivers/staging/lustre/lustre/osc/osc_request.c
index ee6953a..294db84 100644
--- a/drivers/staging/lustre/lustre/osc/osc_request.c
+++ b/drivers/staging/lustre/lustre/osc/osc_request.c
@@ -44,7 +44,6 @@
 #include <lustre/lustre_user.h>
 #include <obd_cksum.h>
 #include <obd_ost.h>
-#include <obd_lov.h>
 
 #include <lustre_ha.h>
 #include <lprocfs_status.h>
diff --git a/drivers/staging/lustre/lustre/ptlrpc/recover.c b/drivers/staging/lustre/lustre/ptlrpc/recover.c
index 4cff2f7..9cec8a6 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/recover.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/recover.c
@@ -49,7 +49,6 @@
 #include <obd.h>
 #include <obd_ost.h>
 #include <obd_class.h>
-#include <obd_lov.h> /* for IOC_LOV_SET_OSC_ACTIVE */
 #include <linux/list.h>
 
 #include "ptlrpc_internal.h"
-- 
1.8.5.3

