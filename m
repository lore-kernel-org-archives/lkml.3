Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab3GVQLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:11:35 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39358 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab3GVQLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:11:30 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, jcl <jacques-charles.lafoucriere@cea.fr>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 20/48] staging/lustre/llapi: add user space method for lov_user_md
Date: Tue, 23 Jul 2013 00:06:41 +0800
Message-Id: <1374509230-3324-21-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jcl <jacques-charles.lafoucriere@cea.fr>

move lov_mds_md_size from obd_lov.h to lustre_idl.h
to have it close to lov_mds_md definition.

add lov_user_md_size() to compute lum size so
llapi and user space utils do not use kernel internal
definitions/methods

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3345
Lustre-change: http://review.whamcloud.com/6345
Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      |   11 +++++++++++
 .../lustre/lustre/include/lustre/lustre_user.h     |   10 ++++++++++
 drivers/staging/lustre/lustre/include/obd_lov.h    |   10 ----------
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 30c0331..ace4e18 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -1670,6 +1670,17 @@ struct lov_mds_md_v3 {	    /* LOV EA mds/wire data (little-endian) */
 	struct lov_ost_data_v1 lmm_objects[0]; /* per-stripe data */
 };
 
+static inline __u32 lov_mds_md_size(__u16 stripes, __u32 lmm_magic)
+{
+	if (lmm_magic == LOV_MAGIC_V3)
+		return sizeof(struct lov_mds_md_v3) +
+				stripes * sizeof(struct lov_ost_data_v1);
+	else
+		return sizeof(struct lov_mds_md_v1) +
+				stripes * sizeof(struct lov_ost_data_v1);
+}
+
+
 #define OBD_MD_FLID	(0x00000001ULL) /* object ID */
 #define OBD_MD_FLATIME     (0x00000002ULL) /* access time */
 #define OBD_MD_FLMTIME     (0x00000004ULL) /* data modification time */
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index f72b2e4..c7bd447 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -347,6 +347,16 @@ struct lov_user_md_v3 {	   /* LOV EA user data (host-endian) */
 	struct lov_user_ost_data_v1 lmm_objects[0]; /* per-stripe data */
 } __attribute__((packed));
 
+static inline __u32 lov_user_md_size(__u16 stripes, __u32 lmm_magic)
+{
+	if (lmm_magic == LOV_USER_MAGIC_V3)
+		return sizeof(struct lov_user_md_v3) +
+				stripes * sizeof(struct lov_user_ost_data_v1);
+	else
+		return sizeof(struct lov_user_md_v1) +
+				stripes * sizeof(struct lov_user_ost_data_v1);
+}
+
 /* Compile with -D_LARGEFILE64_SOURCE or -D_GNU_SOURCE (or #define) to
  * use this.  It is unsafe to #define those values in this header as it
  * is possible the application has already #included <sys/stat.h>. */
diff --git a/drivers/staging/lustre/lustre/include/obd_lov.h b/drivers/staging/lustre/lustre/include/obd_lov.h
index d82f334..235718b 100644
--- a/drivers/staging/lustre/lustre/include/obd_lov.h
+++ b/drivers/staging/lustre/lustre/include/obd_lov.h
@@ -44,16 +44,6 @@ static inline int lov_stripe_md_size(__u16 stripes)
 	return sizeof(struct lov_stripe_md) + stripes*sizeof(struct lov_oinfo*);
 }
 
-static inline __u32 lov_mds_md_size(__u16 stripes, __u32 lmm_magic)
-{
-	if (lmm_magic == LOV_MAGIC_V3)
-		return sizeof(struct lov_mds_md_v3) +
-			stripes * sizeof(struct lov_ost_data_v1);
-	else
-		return sizeof(struct lov_mds_md_v1) +
-			stripes * sizeof(struct lov_ost_data_v1);
-}
-
 struct lov_version_size {
 	__u32   lvs_magic;
 	size_t  lvs_lmm_size;
-- 
1.7.9.5

