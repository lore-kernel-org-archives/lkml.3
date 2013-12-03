Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab3LCOEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:04:34 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:60418 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab3LCOE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:04:28 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Fan Yong <fan.yong@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v3 05/15] staging/lustre/scrub: OI scrub on OST
Date: Tue,  3 Dec 2013 21:58:43 +0800
Message-Id: <1386079133-6459-6-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
References: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fan Yong <fan.yong@intel.com>

Main part of original patch in Lustre tree
(http://review.whamcloud.com/6669) changes server code and
is unneeded by client. The patch only picks up common
functions and data structures change.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3335
Lustre-change: http://review.whamcloud.com/6669
Signed-off-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      |    7 +++++--
 .../staging/lustre/lustre/include/obd_support.h    |    1 +
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |    4 ++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 7dfb925..08da4f3 100644
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
diff --git a/drivers/staging/lustre/lustre/ptlrpc/wiretest.c b/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
index e3f02c7..7160a23 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
@@ -433,6 +433,10 @@ void lustre_assert_wire_constants(void)
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

