Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaLSG3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 01:29:35 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:33812 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaLSG3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 01:29:33 -0500
From: Omar Sandoval <osandov@osandov.com>
To: Trond Myklebust <trond.myklebust@primarydata.com>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] nfs: prevent truncate on active swapfile
Date: Thu, 18 Dec 2014 22:29:18 -0800
Message-Id: <13e8abe52a18c4e46ce497ff299774700cd7e1d0.1418970310.git.osandov@osandov.com>
X-Mailer: git-send-email 2.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most filesystems prevent truncation of an active swapfile by way of
inode_newsize_ok, called from inode_change_ok. NFS doesn't call either
from nfs_setattr, presumably because most of these checks are expected
to be done server-side. However, the IS_SWAPFILE check can only be done
client-side, and not doing so is dangerous.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/nfs/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 4bffe63..9205513 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -506,10 +506,15 @@ nfs_setattr(struct dentry *dentry, struct iattr *attr)
 		attr->ia_valid &= ~ATTR_MODE;
 
 	if (attr->ia_valid & ATTR_SIZE) {
+		loff_t i_size;
+
 		BUG_ON(!S_ISREG(inode->i_mode));
 
-		if (attr->ia_size == i_size_read(inode))
+		i_size = i_size_read(inode);
+		if (attr->ia_size == i_size)
 			attr->ia_valid &= ~ATTR_SIZE;
+		else if (attr->ia_size < i_size && IS_SWAPFILE(inode))
+			return -ETXTBSY;
 	}
 
 	/* Optimization: if the end result is no change, don't RPC */
-- 
2.2.0

