Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831Ab3LIPAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:00:33 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51222 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab3LIPA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:00:29 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 09/13] staging/lustre/idl: remove LASSERT/CLASSERT from lustre_idl.h
Date: Mon,  9 Dec 2013 22:57:01 +0800
Message-Id: <1386601025-422-10-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
References: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Dilger <adilger@whamcloud.com>

Remove the usage of LASSERT() and CLASSERT() from lustre_idl.h, so
that it is usable from userspace programs if needed.  These have
crept in over the years, but are not intended to be there.

The CLASSERT() checks for fid swabbing were largely redundant, and
have been moved to lustre/fid/fid_handler.c.

There are still a few LASSERTs that need to be removed when FID-on-OST
is landed, but I don't want to remove them before that code lands.

There are also uses of CERROR() that could be removed at that time.

Lustre-change: http://review.whamcloud.com/5682
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-1606
Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Christopher J. Morrone <chris.morrone.llnl@gmail.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      |   43 ++++----------------
 1 file changed, 8 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 5da31c5..ac7fb37 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -91,8 +91,8 @@
 #ifndef _LUSTRE_IDL_H_
 #define _LUSTRE_IDL_H_
 
-#if !defined(LASSERT) && !defined(LPU64)
-#include <linux/libcfs/libcfs.h> /* for LASSERT, LPUX64, etc */
+#if !defined(LPU64)
+#include <linux/libcfs/libcfs.h> /* for LPUX64, etc */
 #endif
 
 /* Defn's shared with user-space. */
@@ -232,7 +232,6 @@ static inline unsigned fld_range_is_any(const struct lu_seq_range *range)
 static inline void fld_range_set_type(struct lu_seq_range *range,
 				      unsigned flags)
 {
-	LASSERT(!(flags & ~LU_SEQ_RANGE_MASK));
 	range->lsr_flags |= flags;
 }
 
@@ -615,7 +614,6 @@ static inline obd_id fid_idif_id(obd_seq seq, __u32 oid, __u32 ver)
 /* extract ost index from IDIF FID */
 static inline __u32 fid_idif_ost_idx(const struct lu_fid *fid)
 {
-	LASSERT(fid_is_idif(fid));
 	return (fid_seq(fid) >> 16) & 0xffff;
 }
 
@@ -833,11 +831,6 @@ static inline void lu_igif_build(struct lu_fid *fid, __u32 ino, __u32 gen)
  */
 static inline void fid_cpu_to_le(struct lu_fid *dst, const struct lu_fid *src)
 {
-	/* check that all fields are converted */
-	CLASSERT(sizeof(*src) ==
-		 sizeof(fid_seq(src)) +
-		 sizeof(fid_oid(src)) +
-		 sizeof(fid_ver(src)));
 	dst->f_seq = cpu_to_le64(fid_seq(src));
 	dst->f_oid = cpu_to_le32(fid_oid(src));
 	dst->f_ver = cpu_to_le32(fid_ver(src));
@@ -845,11 +838,6 @@ static inline void fid_cpu_to_le(struct lu_fid *dst, const struct lu_fid *src)
 
 static inline void fid_le_to_cpu(struct lu_fid *dst, const struct lu_fid *src)
 {
-	/* check that all fields are converted */
-	CLASSERT(sizeof(*src) ==
-		 sizeof(fid_seq(src)) +
-		 sizeof(fid_oid(src)) +
-		 sizeof(fid_ver(src)));
 	dst->f_seq = le64_to_cpu(fid_seq(src));
 	dst->f_oid = le32_to_cpu(fid_oid(src));
 	dst->f_ver = le32_to_cpu(fid_ver(src));
@@ -857,11 +845,6 @@ static inline void fid_le_to_cpu(struct lu_fid *dst, const struct lu_fid *src)
 
 static inline void fid_cpu_to_be(struct lu_fid *dst, const struct lu_fid *src)
 {
-	/* check that all fields are converted */
-	CLASSERT(sizeof(*src) ==
-		 sizeof(fid_seq(src)) +
-		 sizeof(fid_oid(src)) +
-		 sizeof(fid_ver(src)));
 	dst->f_seq = cpu_to_be64(fid_seq(src));
 	dst->f_oid = cpu_to_be32(fid_oid(src));
 	dst->f_ver = cpu_to_be32(fid_ver(src));
@@ -869,11 +852,6 @@ static inline void fid_cpu_to_be(struct lu_fid *dst, const struct lu_fid *src)
 
 static inline void fid_be_to_cpu(struct lu_fid *dst, const struct lu_fid *src)
 {
-	/* check that all fields are converted */
-	CLASSERT(sizeof(*src) ==
-		 sizeof(fid_seq(src)) +
-		 sizeof(fid_oid(src)) +
-		 sizeof(fid_ver(src)));
 	dst->f_seq = be64_to_cpu(fid_seq(src));
 	dst->f_oid = be32_to_cpu(fid_oid(src));
 	dst->f_ver = be32_to_cpu(fid_ver(src));
@@ -897,11 +875,6 @@ extern void lustre_swab_lu_seq_range(struct lu_seq_range *range);
 
 static inline int lu_fid_eq(const struct lu_fid *f0, const struct lu_fid *f1)
 {
-	/* Check that there is no alignment padding. */
-	CLASSERT(sizeof(*f0) ==
-		 sizeof(f0->f_seq) +
-		 sizeof(f0->f_oid) +
-		 sizeof(f0->f_ver));
 	return memcmp(f0, f1, sizeof(*f0)) == 0;
 }
 
@@ -3328,9 +3301,10 @@ struct obdo {
 #define o_grant_used o_data_version
 
 static inline void lustre_set_wire_obdo(struct obd_connect_data *ocd,
-					struct obdo *wobdo, struct obdo *lobdo)
+					struct obdo *wobdo,
+					const struct obdo *lobdo)
 {
-	memcpy(wobdo, lobdo, sizeof(*lobdo));
+	*wobdo = *lobdo;
 	wobdo->o_flags &= ~OBD_FL_LOCAL_MASK;
 	if (ocd == NULL)
 		return;
@@ -3345,16 +3319,15 @@ static inline void lustre_set_wire_obdo(struct obd_connect_data *ocd,
 }
 
 static inline void lustre_get_wire_obdo(struct obd_connect_data *ocd,
-					struct obdo *lobdo, struct obdo *wobdo)
+					struct obdo *lobdo,
+					const struct obdo *wobdo)
 {
 	obd_flag local_flags = 0;
 
 	if (lobdo->o_valid & OBD_MD_FLFLAGS)
 		 local_flags = lobdo->o_flags & OBD_FL_LOCAL_MASK;
 
-	LASSERT(!(wobdo->o_flags & OBD_FL_LOCAL_MASK));
-
-	memcpy(lobdo, wobdo, sizeof(*lobdo));
+	*lobdo = *wobdo;
 	if (local_flags != 0) {
 		lobdo->o_valid |= OBD_MD_FLFLAGS;
 		lobdo->o_flags &= ~OBD_FL_LOCAL_MASK;
-- 
1.7.9.5

