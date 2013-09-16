Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab3IPMyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:54:21 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:34285 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab3IPMvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:51:51 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: [PATCH 11/11] vfs: don't set FILE_CREATED before calling ->atomic_open()
Date: Mon, 16 Sep 2013 14:52:05 +0200
Message-Id: <1379335925-30858-12-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

If O_CREAT|O_EXCL are passed to open, then we know that either

 - the file is successfully created, or
 - the operation fails in some way.

So previously we set FILE_CREATED before calling ->atomic_open() so the
filesystem doesn't have to.  This, however, led to bugs in the
implementation that went unnoticed when the filesystem didn't check for
existence, yet returned success.  To prevent this kind of bug, require
filesystems to always explicitly set FILE_CREATED on O_CREAT|O_EXCL and
verify this in the VFS.

Also added a couple more verifications for the result of atomic_open():

 - Warn if filesystem set FILE_CREATED despite the lack of O_CREAT.
 - Warn if filesystem set FILE_CREATED but gave a negative dentry.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 0dc4cbf..22eb548 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2656,6 +2656,7 @@ static int atomic_open(struct nameidata *nd, struct dentry *dentry,
 	int acc_mode;
 	int create_error = 0;
 	struct dentry *const DENTRY_NOT_SET = (void *) -1UL;
+	bool excl;
 
 	BUG_ON(dentry->d_inode);
 
@@ -2669,10 +2670,9 @@ static int atomic_open(struct nameidata *nd, struct dentry *dentry,
 	if ((open_flag & O_CREAT) && !IS_POSIXACL(dir))
 		mode &= ~current_umask();
 
-	if ((open_flag & (O_EXCL | O_CREAT)) == (O_EXCL | O_CREAT)) {
+	excl = (open_flag & (O_EXCL | O_CREAT)) == (O_EXCL | O_CREAT);
+	if (excl)
 		open_flag &= ~O_TRUNC;
-		*opened |= FILE_CREATED;
-	}
 
 	/*
 	 * Checking write permission is tricky, bacuse we don't know if we are
@@ -2726,7 +2726,11 @@ static int atomic_open(struct nameidata *nd, struct dentry *dentry,
 	}
 
 	acc_mode = op->acc_mode;
+	if (WARN_ON(excl && !(*opened & FILE_CREATED)))
+		*opened |= FILE_CREATED;
+
 	if (*opened & FILE_CREATED) {
+		WARN_ON(!(open_flag & O_CREAT));
 		fsnotify_create(dir, dentry);
 		acc_mode = MAY_OPEN;
 	}
@@ -2740,6 +2744,7 @@ static int atomic_open(struct nameidata *nd, struct dentry *dentry,
 			dput(dentry);
 			dentry = file->f_path.dentry;
 		}
+		WARN_ON(!dentry->d_inode && (*opened & FILE_CREATED));
 		if (create_error && dentry->d_inode == NULL) {
 			error = create_error;
 			goto out;
-- 
1.8.1.4

