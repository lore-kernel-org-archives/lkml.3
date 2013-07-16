Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934005Ab3GPXpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:45:23 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:41986 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933873Ab3GPXpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:45:20 -0400
Date: Tue, 16 Jul 2013 16:45:19 -0700 (PDT)
From: Rob Landley <rob@landley.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1374018312.366617@landley.net>
Message-Id: <1374018312.366798@landley.net>
Subject: [PATCH 1/5] initmpfs v2: replace MS_NOUSER in initramfs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Mounting MS_NOUSER prevents --bind mounts from rootfs. Prevent new rootfs
mounts with a different mechanism that doesn't affect bind mounts.

Signed-off-by: Rob Landley <rob@landley.net>
---

 fs/ramfs/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index c24f1e1..14b9c35 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -247,7 +247,12 @@ struct dentry *ramfs_mount(struct file_system_type *fs_type,
 static struct dentry *rootfs_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
-	return mount_nodev(fs_type, flags|MS_NOUSER, data, ramfs_fill_super);
+	static unsigned long once;
+
+	if (test_and_set_bit(1, &once))
+		return ERR_PTR(-ENODEV);
+
+	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
 }
 
 static void ramfs_kill_sb(struct super_block *sb)
