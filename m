Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaKFXLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:11:25 -0500
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:17046 "EHLO
	blau.mirbsd.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753157AbaKFXLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 18:11:20 -0500
Message-Id: <201411062246.sA6Mkggp010153@blau.mirbsd.org>
From: Thorsten Glaser <tg@mirbsd.org>
To: linux-kernel@vger.kernel.org
Date: Sun, 4 May 2014 01:37:54 +0200
Subject: [PATCH] mount tmpfs-as-rootfs (initramfs) with -o
 nr_blocks=0,nr_inodes=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would have preferred to write this patch to be able to pass
rootflags=nr_blocks=0,nr_inodes=0 on the kernel command line,
and then hand these rootflags over to the initramfs (tmpfs)
mount in the same way the kernel hands them over to the block
device rootfs mount. But at least the Debian/m68k initrd also
parses $rootflags from the environment and adds it to the call
to the user-space mount for the eventual root device, which
would make the kernel command line rootflags option be used in
both places (tmpfs and e.g. ext4) which is guaranteed to error
out in at least one of them.

This change is intended to aid people in a setup where the
initrd is the final root filesystem, i.e. not mounted over.
This is especially useful in automated tests running on qemu
for boards with constrained memory (e.g. 64 MiB on sh4).

Considering that the initramfs is normally emptied out then
overmounted, this change is probably safe for setups where
initramfs just hosts early userspace, too, since the tmpfs
backing it is not accessible any more later on, AFAICT.

Signed-off-by: Thorsten Glaser <tg@mirbsd.org>
---
 init/do_mounts.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 82f2288..55a4cfe 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -594,6 +594,7 @@ out:
 }
 
 static bool is_tmpfs;
+static char tmpfs_rootflags[] = "nr_blocks=0,nr_inodes=0";
 static struct dentry *rootfs_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
@@ -606,6 +607,9 @@ static struct dentry *rootfs_mount(struct file_system_type *fs_type,
 	if (IS_ENABLED(CONFIG_TMPFS) && is_tmpfs)
 		fill = shmem_fill_super;
 
+	if (is_tmpfs)
+		data = tmpfs_rootflags;
+
 	return mount_nodev(fs_type, flags, data, fill);
 }
 
-- 
2.0.0.rc0

