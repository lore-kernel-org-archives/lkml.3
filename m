Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab3IBJAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:00:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37879 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758558Ab3IBIzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 53/58] jfs: fix readdir cookie incompatibility with NFSv4
Date: Mon,  2 Sep 2013 09:54:38 +0100
Message-Id: <1378112083-9475-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

commit 44512449c0ab368889dd13ae0031fba74ee7e1d2 upstream.

NFSv4 reserves readdir cookie values 0-2 for special entries (. and ..),
but jfs allows a value of 2 for a non-special entry. This incompatibility
can result in the nfs client reporting a readdir loop.

This patch doesn't change the value stored internally, but adds one to
the value exposed to the iterate method.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Tested-by: Christian Kujau <lists@nerdbynature.de>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
[ luis: backported to 3.5 (based on bwh's backport to 3.2):
  - adjusted context
  - replaced usage of ctx->pos by filp->f_pos ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/jfs/jfs_dtree.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 9197a1b..9f7c758 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -3047,6 +3047,14 @@ int jfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 
 		dir_index = (u32) filp->f_pos;
 
+		/*
+		 * NFSv4 reserves cookies 1 and 2 for . and .. so the value
+		 * we return to the vfs is one greater than the one we use
+		 * internally.
+		 */
+		if (dir_index)
+			dir_index--;
+
 		if (dir_index > 1) {
 			struct dir_table_slot dirtab_slot;
 
@@ -3086,7 +3094,7 @@ int jfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 			if (p->header.flag & BT_INTERNAL) {
 				jfs_err("jfs_readdir: bad index table");
 				DT_PUTPAGE(mp);
-				filp->f_pos = -1;
+				filp->f_pos = DIREND;
 				return 0;
 			}
 		} else {
@@ -3094,7 +3102,7 @@ int jfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 				/*
 				 * self "."
 				 */
-				filp->f_pos = 0;
+				filp->f_pos = 1;
 				if (filldir(dirent, ".", 1, 0, ip->i_ino,
 					    DT_DIR))
 					return 0;
@@ -3102,7 +3110,7 @@ int jfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 			/*
 			 * parent ".."
 			 */
-			filp->f_pos = 1;
+			filp->f_pos = 2;
 			if (filldir(dirent, "..", 2, 1, PARENT(ip), DT_DIR))
 				return 0;
 
@@ -3123,24 +3131,25 @@ int jfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 		/*
 		 * Legacy filesystem - OS/2 & Linux JFS < 0.3.6
 		 *
-		 * pn = index = 0:	First entry "."
-		 * pn = 0; index = 1:	Second entry ".."
+		 * pn = 0; index = 1:	First entry "."
+		 * pn = 0; index = 2:	Second entry ".."
 		 * pn > 0:		Real entries, pn=1 -> leftmost page
 		 * pn = index = -1:	No more entries
 		 */
 		dtpos = filp->f_pos;
-		if (dtpos == 0) {
+		if (dtpos < 2) {
 			/* build "." entry */
 
+			filp->f_pos = 1;
 			if (filldir(dirent, ".", 1, filp->f_pos, ip->i_ino,
 				    DT_DIR))
 				return 0;
-			dtoffset->index = 1;
+			dtoffset->index = 2;
 			filp->f_pos = dtpos;
 		}
 
 		if (dtoffset->pn == 0) {
-			if (dtoffset->index == 1) {
+			if (dtoffset->index == 2) {
 				/* build ".." entry */
 
 				if (filldir(dirent, "..", 2, filp->f_pos,
@@ -3233,6 +3242,12 @@ int jfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 					}
 					jfs_dirent->position = unique_pos++;
 				}
+				/*
+				 * We add 1 to the index because we may
+				 * use a value of 2 internally, and NFSv4
+				 * doesn't like that.
+				 */
+				jfs_dirent->position++;
 			} else {
 				jfs_dirent->position = dtpos;
 				len = min(d_namleft, DTLHDRDATALEN_LEGACY);
-- 
1.8.3.2

