Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaCACRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:17:14 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42578 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbaCACRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:12 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: wang di <di.wang@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 04/17] lustre/mdc: comments on LOOKUP and PERM lock
Date: Fri, 28 Feb 2014 21:16:33 -0500
Message-Id: <1393640206-20286-5-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wang di <di.wang@intel.com>

Add more comments for MDS_INODELOCK_PERM and
MDS_INODELOCK_LOOKUP

Signed-off-by: wang di <di.wang@intel.com>
Reviewed-on: http://review.whamcloud.com/7937
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3240
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      | 24 ++++++++++++++++------
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |  3 +++
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 4183a35..4c70c06 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -2116,12 +2116,24 @@ extern void lustre_swab_generic_32s (__u32 *val);
 #define DISP_OPEN_LEASE      0x04000000
 
 /* INODE LOCK PARTS */
-#define MDS_INODELOCK_LOOKUP 0x000001       /* dentry, mode, owner, group */
-#define MDS_INODELOCK_UPDATE 0x000002       /* size, links, timestamps */
-#define MDS_INODELOCK_OPEN   0x000004       /* For opened files */
-#define MDS_INODELOCK_LAYOUT 0x000008       /* for layout */
-#define MDS_INODELOCK_PERM   0x000010       /* for permission */
-#define MDS_INODELOCK_XATTR  0x000020       /* extended attributes */
+#define MDS_INODELOCK_LOOKUP 0x000001	/* For namespace, dentry etc, and also
+					 * was used to protect permission (mode,
+					 * owner, group etc) before 2.4. */
+#define MDS_INODELOCK_UPDATE 0x000002	/* size, links, timestamps */
+#define MDS_INODELOCK_OPEN   0x000004	/* For opened files */
+#define MDS_INODELOCK_LAYOUT 0x000008	/* for layout */
+
+/* The PERM bit is added int 2.4, and it is used to protect permission(mode,
+ * owner, group, acl etc), so to separate the permission from LOOKUP lock.
+ * Because for remote directories(in DNE), these locks will be granted by
+ * different MDTs(different ldlm namespace).
+ *
+ * For local directory, MDT will always grant UPDATE_LOCK|PERM_LOCK together.
+ * For Remote directory, the master MDT, where the remote directory is, will
+ * grant UPDATE_LOCK|PERM_LOCK, and the remote MDT, where the name entry is,
+ * will grant LOOKUP_LOCK. */
+#define MDS_INODELOCK_PERM   0x000010
+#define MDS_INODELOCK_XATTR  0x000020	/* extended attributes */
 
 #define MDS_INODELOCK_MAXSHIFT 5
 /* This FULL lock is useful to take on unlink sort of operations */
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 1336d47..d9017a5 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -1072,6 +1072,9 @@ int mdc_revalidate_lock(struct obd_export *exp, struct lookup_intent *it,
 			 * locks, there's no easy way to match all of them here,
 			 * so an extra RPC would be performed to fetch all
 			 * of those bits at once for now. */
+			/* For new MDTs(> 2.4), UPDATE|PERM should be enough,
+			 * but for old MDTs (< 2.4), permission is covered
+			 * by LOOKUP lock, so it needs to match all bits here.*/
 			policy.l_inodebits.bits = MDS_INODELOCK_UPDATE |
 						  MDS_INODELOCK_LOOKUP |
 						  MDS_INODELOCK_PERM;
-- 
1.8.5.3

