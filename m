Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaCHBO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:14:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbaCHBHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Chiluk <chiluk@canonical.com>,
        Petr Vandrovec <petr@vandrovec.name>,
        Al Viro <viro@zeniv.linux.org.uk>, Ben Hutchings <ben@decadent.org.uk>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 59/99] ncpfs: fix rmdir returns Device or resource busy
Date: Fri,  7 Mar 2014 17:07:55 -0800
Message-Id: <20140308010613.489199402@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


