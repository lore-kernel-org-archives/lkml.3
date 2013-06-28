Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3F1Syd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:54:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41654 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab3F1Sya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:54:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Chiluk <chiluk@canonical.com>, Petr Vandrovec <petr@vandrovec.name>,
        Al Viro <viro@zeniv.linux.org.uk>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 064/105] ncpfs: fix rmdir returns Device or resource busy
Date: Fri, 28 Jun 2013 11:51:26 -0700
Message-Id: <1372445527-24414-65-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chiluk <chiluk@canonical.com>

commit 698b8223631472bf982ed570b0812faa61955683 upstream.

1d2ef5901483004d74947bbf78d5146c24038fe7 caused a regression in ncpfs such that
directories could no longer be removed.  This was because ncp_rmdir checked
to see if a dentry could be unhashed before allowing it to be removed. Since
1d2ef5901483004d74947bbf78d5146c24038fe7 introduced a change that incremented
dentry->d_count causing it to always be greater than 1 unhash would always
fail.  Thus causing the error path in ncp_rmdir to always be taken.  Removing
this error path is safe as unhashing is still accomplished by calls to dput
from vfs_rmdir.

Signed-off-by: Dave Chiluk <chiluk@canonical.com>
Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ncpfs/dir.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 4117e7b..1355295 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -1033,15 +1033,6 @@ static int ncp_rmdir(struct inode *dir, struct dentry *dentry)
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
1.8.1.2

