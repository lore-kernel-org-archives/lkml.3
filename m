Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab3E1Wu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 18:50:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60231 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab3E1Wu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 18:50:27 -0400
From: Dave Chiluk <chiluk@canonical.com>
To: viro@zeniv.linux.org.uk, petr@vandrovec.name, linux-kernel@vger.kernel.org
Subject: [PATCH] ncpfs: fix rmdir returns Device or resource busy
Date: Tue, 28 May 2013 17:50:10 -0500
Message-Id: <1369781410-24473-1-git-send-email-chiluk@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1d2ef5901483004d74947bbf78d5146c24038fe7 caused a regression in ncpfs such that
directories could no longer be removed.  This was because ncp_rmdir checked
to see if a dentry could be unhashed before allowing it to be removed. Since
1d2ef5901483004d74947bbf78d5146c24038fe7 introduced a change that incremented
dentry->d_count causing it to always be greater than 1 unhash would always
fail.  Thus causing the error path in ncp_rmdir to always be taken.  Removing
this error path is safe as unhashing is still accomplished by calls to dput
from vfs_rmdir.
---
 fs/ncpfs/dir.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 8163260..6792ce1 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -1029,15 +1029,6 @@ static int ncp_rmdir(struct inode *dir, struct dentry *dentry)
 	DPRINTK("ncp_rmdir: removing %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 
-	/*
-	 * fail with EBUSY if there are still references to this
-	 * directory.
-	 */
-	dentry_unhash(dentry);
-	error = -EBUSY;
-	if (!d_unhashed(dentry))
-		goto out;
-
 	len = sizeof(__name);
 	error = ncp_io2vol(server, __name, &len, dentry->d_name.name,
 			   dentry->d_name.len, !ncp_preserve_case(dir));
-- 
1.7.9.5

