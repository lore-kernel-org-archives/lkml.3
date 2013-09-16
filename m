Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab3IPMyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:54:24 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:56793 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3IPMvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:51:44 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Eric Van Hensbergen <ericvh@gmail.com>,
        "M. Mohan Kumar" <mohan@in.ibm.com>, stable@vger.kernel.org
Subject: [PATCH 02/11] 9p: fix dentry leak in v9fs_vfs_atomic_open_dotl()
Date: Mon, 16 Sep 2013 14:51:56 +0200
Message-Id: <1379335925-30858-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

commit b6f4bee02f "fs/9p: Fix atomic_open" fixed the O_EXCL behavior, but
results in a dentry leak if v9fs_vfs_lookup() returns non-NULL.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: M. Mohan Kumar <mohan@in.ibm.com>
Cc: stable@vger.kernel.org
---
 fs/9p/vfs_inode_dotl.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 53687bb..055c159 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -270,10 +270,11 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	if (!(flags & O_CREAT))
 		return	finish_no_open(file, res);
 	else if (dentry->d_inode) {
-		if ((flags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
-			return -EEXIST;
-		else
-			return finish_no_open(file, res);
+		err = -EEXIST;
+		if (flags & O_EXCL)
+			goto out;
+
+		return finish_no_open(file, res);
 	}
 
 	v9ses = v9fs_inode2v9ses(dir);
-- 
1.8.1.4

