Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3F2UMR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 16:12:17 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:57766 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab3F2UMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 16:12:15 -0400
Date: Sat, 29 Jun 2013 13:12:14 -0700 (PDT)
From: Rob Landley <rob@landley.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1372536729.850447@landley.net>
Message-Id: <1372536729.850656@landley.net>
Subject: [PATCH 1/5] initmpfs: replace MS_NOUSER in initramfs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Mounting MS_NOUSER prevents --bind mounts from rootfs. Prevent new rootfs
mounts with a different mechanism that doesn't affect bind mounts.

Signed-off-by: Rob Landley <rob@landley.net>
---

 fs/ramfs/inode.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index c24f1e1..14b9c35 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -247,7 +247,14 @@ struct dentry *ramfs_mount(struct file_system_type *fs_type,
 static struct dentry *rootfs_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
-	return mount_nodev(fs_type, flags|MS_NOUSER, data, ramfs_fill_super);
+	static int once;
+
+	if (once)
+		return ERR_PTR(-ENODEV);
+	else
+		once++;
+
+	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
 }
 
 static void ramfs_kill_sb(struct super_block *sb)
