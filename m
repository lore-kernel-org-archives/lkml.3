Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108Ab3GPXpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:45:45 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:65416 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934047Ab3GPXpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:45:32 -0400
Date: Tue, 16 Jul 2013 16:45:31 -0700 (PDT)
From: Rob Landley <rob@landley.net>
Cc: linux-mm@kvack.org, Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Stephen Warren <swarren@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1374018312.366617@landley.net>
Message-Id: <1374018312.367470@landley.net>
Subject: [PATCH 4/5] initmpfs v2: Make rootfs use tmpfs when CONFIG_TMPFS enabled.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Conditionally call the appropriate fs_init function and fill_super functions.
Add a use once guard to shmem_init() to simply succeed on a second call.

(Note that IS_ENABLED() is a compile time constant so dead code elimination
removes unused function calls when CONFIG_TMPFS is disabled.)

Signed-off-by: Rob Landley <rob@landley.net>
---

 init/do_mounts.c |   10 ++++++++--
 mm/shmem.c       |    4 ++++
 2 files changed, 12 insertions(+), 2 deletions(-)

--- initold/init/do_mounts.c	2013-06-27 00:02:26.283442977 -0500
+++ initwork/init/do_mounts.c	2013-06-27 00:45:21.599550312 -0500
@@ -27,6 +27,7 @@
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
 #include <linux/ramfs.h>
+#include <linux/shmem_fs.h>
 
 #include <linux/nfs_fs.h>
 #include <linux/nfs_fs_sb.h>
@@ -598,7 +597,8 @@
 	if (test_and_set_bit(1, &once))
 		return ERR_PTR(-ENODEV);
 
-	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
+	return mount_nodev(fs_type, flags, data,
+		IS_ENABLED(CONFIG_TMPFS) ? shmem_fill_super : ramfs_fill_super);
 }
 
 static struct file_system_type rootfs_fs_type = {
@@ -614,7 +614,11 @@
 	if (err)
 		return err;
 
-	err = init_ramfs_fs();
+	if (IS_ENABLED(CONFIG_TMPFS))
+		err = shmem_init();
+	else
+		err = init_ramfs_fs();
+
 	if (err)
 		unregister_filesystem(&rootfs_fs_type);
 
--- initold/mm/shmem.c	2013-06-25 13:09:22.215743137 -0500
+++ initwork/mm/shmem.c	2013-06-27 00:16:58.195479317 -0500
@@ -2816,6 +2816,10 @@
 {
 	int error;
 
+	/* If rootfs called this, don't re-init */
+	if (shmem_inode_cachep)
+		return 0;
+
 	error = bdi_init(&shmem_backing_dev_info);
 	if (error)
 		goto out4;
