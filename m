Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086Ab3GPXpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:45:43 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:37065 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032Ab3GPXpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:45:41 -0400
Date: Tue, 16 Jul 2013 16:45:39 -0700 (PDT)
From: Rob Landley <rob@landley.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Stephen Warren <swarren@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1374018312.366617@landley.net>
Message-Id: <1374018312.367663@landley.net>
Subject: [PATCH 5/5] initmpfs v2: Use initramfs if rootfstype= or root= specified.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Command line option rootfstype=ramfs to obtain old initramfs behavior,
and use ramfs instead of tmpfs for stub when root= defined (for cosmetic
reasons).

Signed-off-by: Rob Landley <rob@landley.net>
---

 init/do_mounts.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- initold/init/do_mounts.c	2013-06-29 13:27:00.485256840 -0500
+++ initwork/init/do_mounts.c	2013-06-29 13:34:17.925275072 -0500
@@ -591,16 +591,20 @@
 	sys_chroot(".");
 }
 
+static bool is_tmpfs;
 static struct dentry *rootfs_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
 	static unsigned long once;
+	void *fill = ramfs_fill_super;
 
 	if (test_and_set_bit(1, &once))
 		return ERR_PTR(-ENODEV);
 
-	return mount_nodev(fs_type, flags, data,
-		IS_ENABLED(CONFIG_TMPFS) ? shmem_fill_super : ramfs_fill_super);
+	if (IS_ENABLED(CONFIG_TMPFS) && is_tmpfs)
+		fill = shmem_fill_super;
+
+	return mount_nodev(fs_type, flags, data, fill);
 }
 
 static struct file_system_type rootfs_fs_type = {
@@ -616,9 +620,12 @@
 	if (err)
 		return err;
 
-	if (IS_ENABLED(CONFIG_TMPFS))
+	if (IS_ENABLED(CONFIG_TMPFS) && !saved_root_name[0] &&
+		(!root_fs_names || strstr(root_fs_names, "tmpfs")))
+	{
 		err = shmem_init();
-	else
+		is_tmpfs = true;
+	} else
 		err = init_ramfs_fs();
 
 	if (err)
