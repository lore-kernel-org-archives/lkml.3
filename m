Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbaENVhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:37:41 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55978 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaENVfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:35:16 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 04/11] ramfs: Add sub-filesystem data pointer to ram_fs_info
Date: Wed, 14 May 2014 16:34:52 -0500
Message-Id: <1400103299-144589-5-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devtmpfs will use ramfs if tmpfs is not available, and it needs
to store some data of its own. Add a sub_fs_data pointer to
struct ram_fs_info and move the struct definition to the shared
header, and export the relevant structs to give devtmpfs access
to this pointer.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/ramfs/inode.c      | 8 --------
 include/linux/ramfs.h | 9 +++++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index d365b1c4eb3c..0f2fa4d7212c 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -163,10 +163,6 @@ static const struct super_operations ramfs_ops = {
 	.show_options	= generic_show_options,
 };
 
-struct ramfs_mount_opts {
-	umode_t mode;
-};
-
 enum {
 	Opt_mode,
 	Opt_err
@@ -177,10 +173,6 @@ static const match_table_t tokens = {
 	{Opt_err, NULL}
 };
 
-struct ramfs_fs_info {
-	struct ramfs_mount_opts mount_opts;
-};
-
 static int ramfs_parse_options(char *data, struct ramfs_mount_opts *opts)
 {
 	substring_t args[MAX_OPT_ARGS];
diff --git a/include/linux/ramfs.h b/include/linux/ramfs.h
index ecc730977a5a..cd00e86cc444 100644
--- a/include/linux/ramfs.h
+++ b/include/linux/ramfs.h
@@ -1,6 +1,15 @@
 #ifndef _LINUX_RAMFS_H
 #define _LINUX_RAMFS_H
 
+struct ramfs_mount_opts {
+	umode_t mode;
+};
+
+struct ramfs_fs_info {
+	struct ramfs_mount_opts mount_opts;
+	void *sub_fs_data;
+};
+
 struct inode *ramfs_get_inode(struct super_block *sb, const struct inode *dir,
 	 umode_t mode, dev_t dev);
 extern struct dentry *ramfs_mount(struct file_system_type *fs_type,
-- 
1.9.1

