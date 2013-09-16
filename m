Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3IPMv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:51:56 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:53974 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab3IPMvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:51:46 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, stable@vger.kernel.org
Subject: [PATCH 04/11] fuse: fix O_EXCL in fuse_atomic_open()
Date: Mon, 16 Sep 2013 14:51:58 +0200
Message-Id: <1379335925-30858-5-git-send-email-miklos@szeredi.hu>
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
Cc: stable@vger.kernel.org
---
 fs/fuse/dir.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 62b43b5..694ec6b 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -523,9 +523,17 @@ static int fuse_atomic_open(struct inode *dir, struct dentry *entry,
 			entry = res;
 	}
 
-	if (!(flags & O_CREAT) || entry->d_inode)
+	if (!(flags & O_CREAT))
 		goto no_open;
 
+	if (entry->d_inode) {
+		err = -EEXIST;
+		if (flags & O_EXCL)
+			goto out_dput;
+
+		goto no_open;
+	}
+
 	/* Only creates */
 	*opened |= FILE_CREATED;
 
-- 
1.8.1.4

