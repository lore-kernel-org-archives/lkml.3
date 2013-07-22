Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130Ab3GVQPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:15:31 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57695 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab3GVQNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:13:19 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Patrick Farrell <paf@cray.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 42/48] staging/lustre/llite: Anonymous dentry incorrectly identified as root
Date: Tue, 23 Jul 2013 00:07:03 +0800
Message-Id: <1374509230-3324-43-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Farrell <paf@cray.com>

When exporting Lustre via NFS on SLES11SP2, this check incorrectly identifies
anonymous dentries as root dentries.  This is due to a change in SLES11SP2
which makes the d_name.name for anonymous dentries the same as that for root
dentries.  (Details in LU-3484.)

This changes the check to directly compare the value of the dentry pointer
to the root dentry pointer found in the superblock, rather than using the name.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3484
Lustre-change: http://review.whamcloud.com/6726
Signed-off-by: Patrick Farrell <paf@cray.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Peng Tao <bergwolf@gmail.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Alexey Shvetsov <alexxy@gentoo.org>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/dcache.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/dcache.c b/drivers/staging/lustre/lustre/llite/dcache.c
index a160a84..0d49e1b 100644
--- a/drivers/staging/lustre/lustre/llite/dcache.c
+++ b/drivers/staging/lustre/lustre/llite/dcache.c
@@ -295,9 +295,10 @@ void ll_invalidate_aliases(struct inode *inode)
 		       dentry->d_name.name, dentry, dentry->d_parent,
 		       dentry->d_inode, dentry->d_flags);
 
-		if (dentry->d_name.len == 1 && dentry->d_name.name[0] == '/') {
-			CERROR("called on root (?) dentry=%p, inode=%p "
-			       "ino=%lu\n", dentry, inode, inode->i_ino);
+		if (unlikely(dentry == dentry->d_sb->s_root)) {
+			CERROR("%s: called on root dentry=%p, fid="DFID"\n",
+			       ll_get_fsname(dentry->d_sb, NULL, 0),
+			       dentry, PFID(ll_inode2fid(inode)));
 			lustre_dump_dentry(dentry, 1);
 			dump_stack();
 		}
-- 
1.7.9.5

