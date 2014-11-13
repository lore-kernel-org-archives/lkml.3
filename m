Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbaKMOPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:15:10 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64306 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933151AbaKMOPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:15:07 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH] fs: load FS modules before pinning the mountpoint
Date: Thu, 13 Nov 2014 15:14:33 +0100
Message-Id: <1415888073-1827-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several pseudo file-systems create default mountpoints in /sys/fs/ or
/sys/kernel/, including:
    /sys/kernel/debug
    /sys/fs/mqueue
    /sys/fs/cgroup
    /sys/fs/pstore

If the given pseudo file-system is available as a module, user-space can
rely on mount(2) to load the module on-demand (assuming MODULE_ALIAS_FS).
However, in case the default mount-point is created by the file-system
itself, mount(2) will fail as it cannot pin the mountpoint.

This patch makes mount(2) load any requested file-systems before pinning
the target mount-point. This way, a file-system module can create default
mount-points in the module instead of creating them statically in the
core kernel.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 fs/namespace.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 5b66b2b..b1dc9f8 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2565,6 +2565,7 @@ char *copy_mount_string(const void __user *data)
 long do_mount(const char *dev_name, const char __user *dir_name,
 		const char *type_page, unsigned long flags, void *data_page)
 {
+	struct file_system_type *fstype = NULL;
 	struct path path;
 	int retval = 0;
 	int mnt_flags = 0;
@@ -2577,10 +2578,15 @@ long do_mount(const char *dev_name, const char __user *dir_name,
 	if (data_page)
 		((char *)data_page)[PAGE_SIZE - 1] = 0;
 
+	/* load fs-modules before pinning the mountpoint */
+	if (type_page && !(flags & (MS_REMOUNT|MS_BIND|MS_MOVE|MS_SHARED|
+				    MS_PRIVATE|MS_SLAVE|MS_UNBINDABLE)))
+		fstype = get_fs_type(type_page);
+
 	/* ... and get the mountpoint */
 	retval = user_path(dir_name, &path);
 	if (retval)
-		return retval;
+		goto putfs_out;
 
 	retval = security_sb_mount(dev_name, &path,
 				   type_page, flags, data_page);
@@ -2635,6 +2641,9 @@ long do_mount(const char *dev_name, const char __user *dir_name,
 				      dev_name, data_page);
 dput_out:
 	path_put(&path);
+putfs_out:
+	if (fstype)
+		put_filesystem(fstype);
 	return retval;
 }
 
-- 
2.1.3

