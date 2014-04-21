Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaDUQXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:23:22 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41115 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaDUQXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:23:07 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>,
        David Herrmann <dh.herrmann@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 2/2] fs,proc: Respect FMODE_WRITE when opening /proc/pid/fd/N
Date: Mon, 21 Apr 2014 09:22:48 -0700
Message-Id: <430cfc67aae9b9ad5eab4d293107285ad44c5fd9.1398097304.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1398097304.git.luto@amacapital.net>
References: <cover.1398097304.git.luto@amacapital.net>
In-Reply-To: <cover.1398097304.git.luto@amacapital.net>
References: <cover.1398097304.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does this:

    # (echo asdf >/proc/self/fd/3) 3</dev/null
    bash: /proc/self/fd/3: Permission denied

I'm not confident that my use of nd->flags is correct.  I'm also not
confident that this hooks in to path lookup in the right place.

It is not complete.  It doesn't handle FMODE_READ.  It also doesn't
handle FMODE_EXEC or FMODE_PATH, but the desired semantics there are
less clear.  For example, this should probably continue to work:

    (/proc/self/fd/3 Hello) 3</bin/echo

This patch does not do anything to /proc/self/exe.  It probably should.

Something like this can possibly fix the accidental flink-via-proc
thing, too.

This may break userspace.  If so, I would guess that anything broken
by it is either an actual exploit or is so broken that it doesn't
deserve to continue working.  If it breaks something important, then
maybe it will need a sysctl.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/namei.c            |  3 +++
 fs/proc/fd.c          | 19 ++++++++++++++++---
 include/linux/namei.h |  1 +
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c6157c8..3f01836 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2894,6 +2894,9 @@ static int do_last(struct nameidata *nd, struct path *path,
 		goto finish_open;
 	}
 
+	if (open_flag & (O_WRONLY | O_RDWR))
+		nd->flags |= LOOKUP_WRITE;
+
 	if (!(open_flag & O_CREAT)) {
 		if (nd->last.name[nd->last.len])
 			nd->flags |= LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index deca407..ab3373c 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -139,6 +139,17 @@ static const struct dentry_operations tid_fd_dentry_operations = {
 	.d_delete	= pid_delete_dentry,
 };
 
+static int proc_may_follow(struct nameidata *nd, struct file *f)
+{
+	if (!nd)
+		return 0;  /* This is readlink, */
+
+	if ((nd->flags & LOOKUP_WRITE) && !(f->f_mode & FMODE_WRITE))
+		return -EACCES;
+
+	return 0;
+}
+
 static int proc_fd_link(struct nameidata *nd,
 			struct dentry *dentry, struct path *path)
 {
@@ -159,9 +170,11 @@ static int proc_fd_link(struct nameidata *nd,
 		spin_lock(&files->file_lock);
 		fd_file = fcheck_files(files, fd);
 		if (fd_file) {
-			*path = fd_file->f_path;
-			path_get(&fd_file->f_path);
-			ret = 0;
+			ret = proc_may_follow(nd, fd_file);
+			if (ret == 0) {
+				*path = fd_file->f_path;
+				path_get(&fd_file->f_path);
+			}
 		}
 		spin_unlock(&files->file_lock);
 		put_files_struct(files);
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 492de72..5077201 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -51,6 +51,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_CREATE		0x0200
 #define LOOKUP_EXCL		0x0400
 #define LOOKUP_RENAME_TARGET	0x0800
+#define LOOKUP_WRITE		0x8000
 
 #define LOOKUP_JUMPED		0x1000
 #define LOOKUP_ROOT		0x2000
-- 
1.9.0

