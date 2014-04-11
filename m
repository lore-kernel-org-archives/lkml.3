Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaDKEuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 00:50:52 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:54589 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753972AbaDKEuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 00:50:51 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYOAJZzR1NXQy1//2dsb2JhbABZgwaDTsF7AgKBHhd0glMTHCMYgQIkE4gAAc0TjmyEPwEDmF0BkkKDMjs
Date: Fri, 11 Apr 2014 06:52:42 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, jack <jack@suse.cz>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] FS: Add generic data flush to fsync
Message-Id: <20140411065242.42916952dd5d8e4e53848b3b@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there's no generic HW flush management support in kernel.
Only 7 filesystems have their own way to manage the barrier flag.

This patch adds MS_BARRIER in sb_flags and conditionnaly issues the flush
in generic_file_fsync.

That option would be enabled from userspace mount tool.

(-As discussed with Jan, we could add barrier/no barrier in older filesystems
 but this would mix both filesystem and vfs barrier terminology plus
 generic_file_fsync does not have access to FS sbi.
 -Some modern FS will be involved as well ; eg no journal ext4 partitions.
)

Cc: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/libfs.c              | 7 +++++++
 include/uapi/linux/fs.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/fs/libfs.c b/fs/libfs.c
index a184424..21983d9 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -3,6 +3,7 @@
  *	Library for filesystems writers.
  */
 
+#include <linux/blkdev.h>
 #include <linux/export.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
@@ -952,6 +953,12 @@ int generic_file_fsync(struct file *file, loff_t start, loff_t end,
 	err = sync_inode_metadata(inode, 1);
 	if (ret == 0)
 		ret = err;
+	if (inode->i_sb->s_flags & MS_BARRIER) {
+		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+		if (ret == 0)
+			ret = err;
+	}
+
 out:
 	mutex_unlock(&inode->i_mutex);
 	return ret;
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index ca1a11b..7c14ebd 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -89,6 +89,7 @@ struct inodes_stat_t {
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
+#define MS_BARRIER	(1<<25) /* Flush data during sync operations */
 
 /* These sb flags are internal to the kernel */
 #define MS_NOSEC	(1<<28)
-- 
1.8.4.5

