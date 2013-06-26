Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3FZCsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:48:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54139 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028Ab3FZCpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:45:25 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dave Chiluk" <chiluk@canonical.com>,
        "Petr Vandrovec" <petr@vandrovec.name>,
        "Al Viro" <viro@zeniv.linux.org.uk>
Date: Wed, 26 Jun 2013 03:35:59 +0100
Message-ID: <lsq.1372214159.879690280@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [26/26] ncpfs: fix rmdir returns Device or resource busy
In-Reply-To: <lsq.1372214158.425780530@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.48-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ncpfs/dir.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -1033,15 +1033,6 @@ static int ncp_rmdir(struct inode *dir,
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

