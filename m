Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab3AaWwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:52:47 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:51498 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab3AaWwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:52:43 -0500
From: William Hubbs <w.d.hubbs@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mpagano@gentoo.org, William Hubbs <w.d.hubbs@gmail.com>
Subject: [PATCH] init: fix name of root device in /proc/mounts
Date: Thu, 31 Jan 2013 16:51:39 -0600
Message-Id: <1359672699-23540-1-git-send-email-w.d.hubbs@gmail.com>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a system that does not use an initramfs, /dev/root was always
listed in /proc/mounts. This breaks software which scans /proc/mounts to
determine which file systems are mounted since /dev/root is not a valid
device name.

This changes that processing so that "/dev/root" is only added to
/proc/mounts if a root device is not specified with the root= option on
the kernel command line.

Signed-off-by: William Hubbs <w.d.hubbs@gmail.com>
---
 init/do_mounts.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 1d1b634..efc37d2 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -480,7 +480,10 @@ void __init change_floppy(char *fmt, ...)
 	va_start(args, fmt);
 	vsprintf(buf, fmt, args);
 	va_end(args);
-	fd = sys_open("/dev/root", O_RDWR | O_NDELAY, 0);
+	if (saved_root_name[0])
+		fd = sys_open(saved_root_name, O_RDWR | O_NDELAY, 0);
+	else
+		fd = sys_open("/dev/root", O_RDWR | O_NDELAY, 0);
 	if (fd >= 0) {
 		sys_ioctl(fd, FDEJECT, 0);
 		sys_close(fd);
@@ -523,8 +526,13 @@ void __init mount_root(void)
 	}
 #endif
 #ifdef CONFIG_BLOCK
-	create_dev("/dev/root", ROOT_DEV);
-	mount_block_root("/dev/root", root_mountflags);
+	if (saved_root_name[0]) {
+		create_dev(saved_root_name, ROOT_DEV);
+		mount_block_root(saved_root_name, root_mountflags);
+	} else {
+		create_dev("/dev/root", ROOT_DEV);
+		mount_block_root("/dev/root", root_mountflags);
+	}
 #endif
 }
 
-- 
1.7.12.4

