Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab3DZJAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:00:40 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:34295 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab3DZJAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:00:38 -0400
Message-ID: <517A4087.9090704@gmail.com>
Date: Fri, 26 Apr 2013 10:53:27 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] fsfreeze: return EINTR from mnt_want_write and mnt_want_write_file
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced sb_start_write with sb_start_write_killable inside
mnt_want_write and mnt_want_write_file.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/namei.c     |    6 ++++++
 fs/namespace.c |    8 ++++++--
 ipc/mqueue.c   |    6 +++++-
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 57ae9c8..5f239fd 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2750,6 +2750,8 @@ static int do_last(struct nameidata *nd, struct path *path,
 retry_lookup:
 	if (op->open_flag & (O_CREAT | O_TRUNC | O_WRONLY | O_RDWR)) {
 		error = mnt_want_write(nd->path.mnt);
+		if (error == -EINTR)
+			goto out;
 		if (!error)
 			got_write = true;
 		/*
@@ -3053,6 +3055,10 @@ struct dentry *kern_path_create(int dfd, const char *pathname,
 
 	/* don't fail immediately if it's r/o, at least try to report other errors */
 	err2 = mnt_want_write(nd.path.mnt);
+	if (err2 == -EINTR) {
+		dentry = ERR_PTR(-EINTR);
+		goto out;
+	}
 	/*
 	 * Do the final lookup.
 	 */
diff --git a/fs/namespace.c b/fs/namespace.c
index af73554..db09ecb 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -344,7 +344,9 @@ int mnt_want_write(struct vfsmount *m)
 {
 	int ret;
 
-	sb_start_write(m->mnt_sb);
+	ret = sb_start_write_killable(m->mnt_sb);
+	if (ret < 0)
+		return ret;
 	ret = __mnt_want_write(m);
 	if (ret)
 		sb_end_write(m->mnt_sb);
@@ -404,7 +406,9 @@ int mnt_want_write_file(struct file *file)
 {
 	int ret;
 
-	sb_start_write(file->f_path.mnt->mnt_sb);
+	ret = sb_start_write_killable(file->f_path.mnt->mnt_sb);
+	if (ret < 0)
+		return ret;
 	ret = __mnt_want_write_file(file);
 	if (ret)
 		sb_end_write(file->f_path.mnt->mnt_sb);
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index e4e47f6..e8fdc03 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -800,7 +800,11 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, umode_t, mode,
 	if (fd < 0)
 		goto out_putname;
 
-	ro = mnt_want_write(mnt);	/* we'll drop it in any case */
+	ro = mnt_want_write(mnt);
+	if (ro == -EINTR) {
+		fd = ro;
+		goto out_putname;
+	}
 	error = 0;
 	mutex_lock(&root->d_inode->i_mutex);
 	path.dentry = lookup_one_len(name->name, root, strlen(name->name));
-- 
1.7.3.4
