Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab3IPMwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:52:01 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:63674 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab3IPMvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:51:45 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Eric Van Hensbergen <ericvh@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 03/11] 9p: fix O_EXCL in v9fs_vfs_atomic_open()
Date: Mon, 16 Sep 2013 14:51:57 +0200
Message-Id: <1379335925-30858-4-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

If open flags has O_EXCL and dentry is positive after lookup then return
-EEXIST instead of "1".

This bug resulted in some O_EXCL opens succeeding (on a cache miss) despite
the file already existing.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: stable@vger.kernel.org
---
 fs/9p/vfs_inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 94de6d1..915cea5 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -863,8 +863,15 @@ v9fs_vfs_atomic_open(struct inode *dir, struct dentry *dentry,
 	}
 
 	/* Only creates */
-	if (!(flags & O_CREAT) || dentry->d_inode)
+	if (!(flags & O_CREAT)) {
 		return finish_no_open(file, res);
+	} else {
+		err = -EEXIST;
+		if (flags & O_EXCL)
+			goto out;
+
+		return finish_no_open(file, res);
+	}
 
 	err = 0;
 	fid = NULL;
-- 
1.8.1.4

