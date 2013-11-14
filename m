Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab3KNQy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:54:26 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:54671 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab3KNQjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:39:39 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Gaurav Mahajan <gmahajan@ddn.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 18/39] staging/lustre/llite: Delaying creation of client side proc entries.
Date: Fri, 15 Nov 2013 00:32:41 +0800
Message-Id: <1384446782-13741-19-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gaurav Mahajan <gmahajan@ddn.com>

In client_common_fill_super() proc entries are created before
before cl_sb_init() and therefore lu_site is not allocated resulting
in client crash when tried reading lu_site stats.
Delaying creation of proc entries after creation of all required data
structures fixed the problem.

Lustre-change: http://review.whamcloud.com/6852
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2941
Signed-off-by: Gaurav Mahajan <gmahajan@ddn.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Emoly Liu <emoly.liu@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/llite_lib.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 18e3db2..a64808c 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -186,13 +186,6 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 		return -ENOMEM;
 	}
 
-	if (proc_lustre_fs_root) {
-		err = lprocfs_register_mountpoint(proc_lustre_fs_root, sb,
-						  dt, md);
-		if (err < 0)
-			CERROR("could not register mount in /proc/fs/lustre\n");
-	}
-
 	/* indicate the features supported by this client */
 	data->ocd_connect_flags = OBD_CONNECT_IBITS    | OBD_CONNECT_NODEVOH  |
 				  OBD_CONNECT_ATTRFID  |
@@ -590,6 +583,15 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 		OBD_FREE_PTR(data);
 	if (osfs != NULL)
 		OBD_FREE_PTR(osfs);
+	if (proc_lustre_fs_root != NULL) {
+		err = lprocfs_register_mountpoint(proc_lustre_fs_root, sb,
+						  dt, md);
+		if (err < 0) {
+			CERROR("%s: could not register mount in lprocfs: "
+			       "rc = %d\n", ll_get_fsname(sb, NULL, 0), err);
+			err = 0;
+		}
+	}
 
 	return err;
 out_root:
@@ -612,7 +614,6 @@ out:
 		OBD_FREE_PTR(data);
 	if (osfs != NULL)
 		OBD_FREE_PTR(osfs);
-	lprocfs_unregister_mountpoint(sbi);
 	return err;
 }
 
-- 
1.7.9.5

