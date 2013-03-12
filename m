Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab3CLPnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:43:40 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:52743 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933031Ab3CLPmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:42:44 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 12/13] ovl-switch-to-inode_permission
Date: Tue, 12 Mar 2013 16:41:47 +0100
Message-Id: <1363102908-28956-13-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

When checking permissions on an overlayfs inode we do not take into
account either device cgroup restrictions nor security permissions.
This allows a user to mount an overlayfs layer over a restricted device
directory and by pass those permissions to open otherwise restricted
files.

Switch over to __inode_permissions.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/inode.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 033de6f..3218a38 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -100,19 +100,9 @@ int ovl_permission(struct inode *inode, int mask)
 		if (is_upper && !IS_RDONLY(inode) && IS_RDONLY(realinode) &&
 		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
 			goto out_dput;
-
-		/*
-		 * Nobody gets write access to an immutable file.
-		 */
-		err = -EACCES;
-		if (IS_IMMUTABLE(realinode))
-			goto out_dput;
 	}
 
-	if (realinode->i_op->permission)
-		err = realinode->i_op->permission(realinode, mask);
-	else
-		err = generic_permission(realinode, mask);
+	err = __inode_permission(realinode, mask);
 out_dput:
 	dput(alias);
 	return err;
-- 
1.7.10.4

