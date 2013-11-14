Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab3KNQWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:22:52 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:55839 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3KNQPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:15:52 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Fan Yong <fan.yong@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 22/40] staging/lustre/scrub: OI scrub on OST
Date: Fri, 15 Nov 2013 00:13:24 +0800
Message-Id: <1384445622-12346-23-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fan Yong <fan.yong@intel.com>

OI scrub should has the ability to handle kinds of OI, including
both the OI files on MDT and the /O directory on OST.

We trust the FID in LMA for both MDT objects and OST objects. So
if some /O sub-item does not match related LMA, then the /O will
be updated, instead of the LMA.

To guarantee that the OI scrub can run without MDT0 involved for
FLDB, the OST object needs to store some flag in its LMA to tell
OI scrub that it is for an OST object, no need to query the MDT0.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3335
Lustre-change: http://review.whamcloud.com/6669
Signed-off-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      |   18 +++++++++++-------
 .../staging/lustre/lustre/include/obd_support.h    |    1 +
 drivers/staging/lustre/lustre/obdclass/md_attrs.c  |    4 ++--
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |    4 ++++
 4 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 4d8d8c3..05e583f 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -321,8 +321,11 @@ static inline int range_compare_loc(const struct lu_seq_range *r1,
  * xattr.
  */
 enum lma_compat {
-	LMAC_HSM = 0x00000001,
-	LMAC_SOM = 0x00000002,
+	LMAC_HSM	= 0x00000001,
+	LMAC_SOM	= 0x00000002,
+	LMAC_NOT_IN_OI	= 0x00000004, /* the object does NOT need OI mapping */
+	LMAC_FID_ON_OST = 0x00000008, /* For OST-object, its OI mapping is
+				       * under /O/<seq>/d<x>. */
 };
 
 /**
@@ -331,16 +334,17 @@ enum lma_compat {
  * This information is stored in lustre_mdt_attrs::lma_incompat.
  */
 enum lma_incompat {
-	LMAI_RELEASED = 0x0000001, /* file is released */
-	LMAI_AGENT = 0x00000002, /* agent inode */
-	LMAI_REMOTE_PARENT = 0x00000004, /* the parent of the object
-					    is on the remote MDT */
+	LMAI_RELEASED		= 0x00000001, /* file is released */
+	LMAI_AGENT		= 0x00000002, /* agent inode */
+	LMAI_REMOTE_PARENT	= 0x00000004, /* the parent of the object
+						 is on the remote MDT */
 };
 #define LMA_INCOMPAT_SUPP	(LMAI_AGENT | LMAI_REMOTE_PARENT)
 
 extern void lustre_lma_swab(struct lustre_mdt_attrs *lma);
 extern void lustre_lma_init(struct lustre_mdt_attrs *lma,
-			    const struct lu_fid *fid, __u32 incompat);
+			    const struct lu_fid *fid,
+			    __u32 compat, __u32 incompat);
 /**
  * SOM on-disk attributes stored in a separate xattr.
  */
diff --git a/drivers/staging/lustre/lustre/include/obd_support.h b/drivers/staging/lustre/lustre/include/obd_support.h
index 825a0c9..1748985 100644
--- a/drivers/staging/lustre/lustre/include/obd_support.h
+++ b/drivers/staging/lustre/lustre/include/obd_support.h
@@ -256,6 +256,7 @@ int obd_alloc_fail(const void *ptr, const char *name, const char *type,
 #define OBD_FAIL_OSD_SCRUB_FATAL			0x192
 #define OBD_FAIL_OSD_FID_MAPPING			0x193
 #define OBD_FAIL_OSD_LMA_INCOMPAT			0x194
+#define OBD_FAIL_OSD_COMPAT_INVALID_ENTRY		0x195
 
 #define OBD_FAIL_OST		     0x200
 #define OBD_FAIL_OST_CONNECT_NET	 0x201
diff --git a/drivers/staging/lustre/lustre/obdclass/md_attrs.c b/drivers/staging/lustre/lustre/obdclass/md_attrs.c
index f718782..91eb30b 100644
--- a/drivers/staging/lustre/lustre/obdclass/md_attrs.c
+++ b/drivers/staging/lustre/lustre/obdclass/md_attrs.c
@@ -39,9 +39,9 @@
  * \param incompat - features that MDS must understand to access object
  */
 void lustre_lma_init(struct lustre_mdt_attrs *lma, const struct lu_fid *fid,
-		     __u32 incompat)
+		     __u32 compat, __u32 incompat)
 {
-	lma->lma_compat   = 0;
+	lma->lma_compat   = compat;
 	lma->lma_incompat = incompat;
 	lma->lma_self_fid = *fid;
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/wiretest.c b/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
index 912f194..ca2ef59 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
@@ -432,6 +432,10 @@ void lustre_assert_wire_constants(void)
 		(unsigned)LMAC_HSM);
 	LASSERTF(LMAC_SOM == 0x00000002UL, "found 0x%.8xUL\n",
 		(unsigned)LMAC_SOM);
+	LASSERTF(LMAC_NOT_IN_OI == 0x00000004UL, "found 0x%.8xUL\n",
+		(unsigned)LMAC_NOT_IN_OI);
+	LASSERTF(LMAC_FID_ON_OST == 0x00000008UL, "found 0x%.8xUL\n",
+		(unsigned)LMAC_FID_ON_OST);
 	LASSERTF(OBJ_CREATE == 1, "found %lld\n",
 		 (long long)OBJ_CREATE);
 	LASSERTF(OBJ_DESTROY == 2, "found %lld\n",
-- 
1.7.9.5

