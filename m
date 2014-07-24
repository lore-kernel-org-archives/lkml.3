Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbaGXJqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:46:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54575 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069AbaGXJqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:46:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Karel Zak <kzak@redhat.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 004/128] btrfs: Add ctime/mtime update for btrfs device add/remove.
Date: Thu, 24 Jul 2014 10:44:13 +0100
Message-Id: <1406195177-8656-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

commit 5a1972bd9fd4b2fb1bac8b7a0b636d633d8717e3 upstream.

Btrfs will send uevent to udev inform the device change,
but ctime/mtime for the block device inode is not udpated, which cause
libblkid used by btrfs-progs unable to detect device change and use old
cache, causing 'btrfs dev scan; btrfs dev rmove; btrfs dev scan' give an
error message.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: Karel Zak <kzak@redhat.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/volumes.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index feb93fc9863d..cacdb3effa35 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1403,6 +1403,22 @@ out:
 	return ret;
 }
 
+/*
+ * Function to update ctime/mtime for a given device path.
+ * Mainly used for ctime/mtime based probe like libblkid.
+ */
+static void update_dev_time(char *path_name)
+{
+	struct file *filp;
+
+	filp = filp_open(path_name, O_RDWR, 0);
+	if (!filp)
+		return;
+	file_update_time(filp);
+	filp_close(filp, NULL);
+	return;
+}
+
 static int btrfs_rm_dev_item(struct btrfs_root *root,
 			     struct btrfs_device *device)
 {
@@ -1649,10 +1665,14 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 
 	ret = 0;
 
-	/* Notify udev that device has changed */
-	if (bdev)
+	if (bdev) {
+		/* Notify udev that device has changed */
 		btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
 
+		/* Update ctime/mtime for device path for libblkid */
+		update_dev_time(device_path);
+	}
+
 error_brelse:
 	brelse(bh);
 	if (bdev)
@@ -2096,6 +2116,8 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 		ret = btrfs_commit_transaction(trans, root);
 	}
 
+	/* Update ctime/mtime for libblkid */
+	update_dev_time(device_path);
 	return ret;
 
 error_trans:
-- 
1.9.1

