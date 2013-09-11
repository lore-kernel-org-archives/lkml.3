Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab3IKE51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:57:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab3IKE4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:50 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=m30UeRl76NEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=cCY6eM4F4EIA:10 a=yPCof4ZbAAAA:8 a=ae4rsh5pGrf30fI6c7EA:9 a=7DSvI1NPTFQA:10 a=dvHDv6DFvjYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042931.794771408@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:31:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Christian Kujau <lists@nerdbynature.de>
Subject: [237/251] jfs: fix readdir cookie incompatibility with NFSv4
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0237-jfs-fix-readdir-cookie-incompatibility-with-NFSv4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

[ Upstream commit 44512449c0ab368889dd13ae0031fba74ee7e1d2 ]

NFSv4 reserves readdir cookie values 0-2 for special entries (. and ..),
but jfs allows a value of 2 for a non-special entry. This incompatibility
can result in the nfs client reporting a readdir loop.

This patch doesn't change the value stored internally, but adds one to
the value exposed to the iterate method.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Tested-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/jfs/jfs_dtree.c |   31 +++++++++++++++++++++++--------
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
1.7.10.4


