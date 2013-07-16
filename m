Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028Ab3GPXp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:45:27 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:49195 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933873Ab3GPXpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:45:23 -0400
Date: Tue, 16 Jul 2013 16:45:22 -0700 (PDT)
From: Rob Landley <rob@landley.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1374018312.366617@landley.net>
Message-Id: <1374018312.366947@landley.net>
Subject: [PATCH 2/5] initmpfs v2: Move bdi setup from init_rootfs to init_ramfs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Even though ramfs hasn't got a backing device, commit e0bf68ddec4f added one
anyway, and put the initialization in init_rootfs() since that's the first
user, leaving it out of init_ramfs() to avoid duplication.

But initmpfs uses init_tmpfs() instead, so move the init into the filesystem's
init function, add a "once" guard to prevent duplicate initialization, and
call the filesystem init from rootfs init.

This goes part of the way to allowing ramfs to be built as a module.

Signed-off-by: Rob Landley <rob@landley.net>
---

 fs/ramfs/inode.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- initold/fs/ramfs/inode.c	2013-06-28 15:12:03.205879730 -0500
+++ initold2/fs/ramfs/inode.c	2013-06-28 15:12:12.425880115 -0500
@@ -275,21 +275,34 @@
 
 static int __init init_ramfs_fs(void)
 {
-	return register_filesystem(&ramfs_fs_type);
+	static unsigned long once;
+	int err;
+
+	if (test_and_set_bit(1, &once))
+		return 0;
+
+	err = bdi_init(&ramfs_backing_dev_info);
+	if (err)
+		return err;
+
+	err = register_filesystem(&ramfs_fs_type);
+	if (err)
+		bdi_destroy(&ramfs_backing_dev_info);
+
+	return err;
 }
 module_init(init_ramfs_fs)
 
 int __init init_rootfs(void)
 {
-	int err;
+	int err = register_filesystem(&rootfs_fs_type);
 
-	err = bdi_init(&ramfs_backing_dev_info);
 	if (err)
 		return err;
 
-	err = register_filesystem(&rootfs_fs_type);
+	err = init_ramfs_fs();
 	if (err)
-		bdi_destroy(&ramfs_backing_dev_info);
+		unregister_filesystem(&rootfs_fs_type);
 
 	return err;
 }
