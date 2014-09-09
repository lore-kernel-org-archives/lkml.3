Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaIISkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:40:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:15612 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbaIISkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:40:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,492,1406617200"; 
   d="scan'208";a="570725118"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 2/7] staging/lustre: remove linux/lustre_common.h
Date: Tue, 9 Sep 2014 13:39:03 -0500
Message-ID: <1410287948-13168-3-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410287948-13168-1-git-send-email-john.hammond@intel.com>
References: <1410287948-13168-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.107]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Expand the two uses of ll_inode_blksize() and remove the then
unnecessary header lustre/include/linux/lustre_common.h.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-on: http://review.whamcloud.com/11495
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
---
 .../lustre/lustre/include/linux/lustre_common.h    |   22 --------------------
 .../lustre/lustre/include/linux/lustre_lite.h      |    1 -
 drivers/staging/lustre/lustre/include/linux/lvfs.h |    1 -
 drivers/staging/lustre/lustre/llite/file.c         |    2 +-
 drivers/staging/lustre/lustre/obdclass/obdo.c      |    2 +-
 5 files changed, 2 insertions(+), 26 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_common.h

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_common.h b/drivers/staging/lustre/lustre/include/linux/lustre_common.h
deleted file mode 100644
index d1783a3..0000000
--- a/drivers/staging/lustre/lustre/include/linux/lustre_common.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef LUSTRE_COMMON_H
-#define LUSTRE_COMMON_H
-
-#include <linux/sched.h>
-
-static inline int cfs_cleanup_group_info(void)
-{
-	struct group_info *ginfo;
-
-	ginfo = groups_alloc(0);
-	if (!ginfo)
-		return -ENOMEM;
-
-	set_current_groups(ginfo);
-	put_group_info(ginfo);
-
-	return 0;
-}
-
-#define ll_inode_blksize(a)		(1<<(a)->i_blkbits)
-
-#endif
diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_lite.h b/drivers/staging/lustre/lustre/include/linux/lustre_lite.h
index 99eed49..a7658a9 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_lite.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_lite.h
@@ -52,7 +52,6 @@
 
 #include <linux/rbtree.h>
 #include "../../include/linux/lustre_compat25.h"
-#include "../../include/linux/lustre_common.h"
 #include <linux/pagemap.h>
 
 /* lprocfs.c */
diff --git a/drivers/staging/lustre/lustre/include/linux/lvfs.h b/drivers/staging/lustre/lustre/include/linux/lvfs.h
index c446375..e4cdb45 100644
--- a/drivers/staging/lustre/lustre/include/linux/lvfs.h
+++ b/drivers/staging/lustre/lustre/include/linux/lvfs.h
@@ -46,7 +46,6 @@
 #endif
 
 #include "lustre_compat25.h"
-#include "lustre_common.h"
 #include "lvfs_linux.h"
 
 #define LLOG_LVFS
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 10a1475..3a57be4 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -991,7 +991,7 @@ int ll_inode_getattr(struct inode *inode, struct obdo *obdo,
 		CDEBUG(D_INODE, "objid "DOSTID" size %llu, blocks %llu,"
 		       " blksize %lu\n", POSTID(oi), i_size_read(inode),
 		       (unsigned long long)inode->i_blocks,
-		       (unsigned long)ll_inode_blksize(inode));
+		       1UL << inode->i_blkbits);
 	}
 	ccc_inode_lsm_put(inode, lsm);
 	return rc;
diff --git a/drivers/staging/lustre/lustre/obdclass/obdo.c b/drivers/staging/lustre/lustre/obdclass/obdo.c
index bdc00ea..8b4b8ae 100644
--- a/drivers/staging/lustre/lustre/obdclass/obdo.c
+++ b/drivers/staging/lustre/lustre/obdclass/obdo.c
@@ -86,7 +86,7 @@ void obdo_from_inode(struct obdo *dst, struct inode *src, u32 valid)
 		newvalid |= OBD_MD_FLBLOCKS;
 	}
 	if (valid & OBD_MD_FLBLKSZ) {   /* optimal block size */
-		dst->o_blksize = ll_inode_blksize(src);
+		dst->o_blksize = 1 << src->i_blkbits;
 		newvalid |= OBD_MD_FLBLKSZ;
 	}
 	if (valid & OBD_MD_FLTYPE) {
-- 
1.7.9.5

