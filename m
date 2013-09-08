Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab3IHDTw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55969 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005Ab3IHDSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:46 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Christian Kujau" <lists@nerdbynature.de>,
        "Dave Kleikamp" <dave.kleikamp@oracle.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.761931207@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [023/121] jfs: fix readdir cookie incompatibility with NFSv4
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - s/ctx->pos/filp->f_pos/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/jfs/jfs_dtree.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 8743ba9..0ec767e 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -3047,6 +3047,14 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 
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
 
@@ -3086,7 +3094,7 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 			if (p->header.flag & BT_INTERNAL) {
 				jfs_err("jfs_readdir: bad index table");
 				DT_PUTPAGE(mp);
-				filp->f_pos = -1;
+				filp->f_pos = DIREND;
 				return 0;
 			}
 		} else {
@@ -3094,15 +3102,15 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 				/*
 				 * self "."
 				 */
-				filp->f_pos = 0;
+				filp->f_pos = 1;
 				if (filldir(dirent, ".", 1, 0, ip->i_ino,
 					    DT_DIR))
 					return 0;
 			}
 			/*
 			 * parent ".."
 			 */
-			filp->f_pos = 1;
+			filp->f_pos = 2;
 			if (filldir(dirent, "..", 2, 1, PARENT(ip), DT_DIR))
 				return 0;
 
@@ -3123,24 +3131,25 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
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
@@ -3233,6 +3242,12 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
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

