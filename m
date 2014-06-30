Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbaF3Mvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:51:48 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131AbaF3Ma0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Karel Zak <kzak@redhat.com>, Chris Mason <clm@fb.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 164/181] btrfs: Add ctime/mtime update for btrfs device add/remove.
Date: Mon, 30 Jun 2014 13:53:05 +0200
Message-Id: <b6ae1a6f7b75df4e8304d3e7185d131cee680394.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/volumes.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b691f375d837..258cd6ec3bd2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1438,6 +1438,22 @@ out:
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
@@ -1690,10 +1706,14 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 
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
@@ -2131,6 +2151,8 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 		ret = btrfs_commit_transaction(trans, root);
 	}
 
+	/* Update ctime/mtime for libblkid */
+	update_dev_time(device_path);
 	return ret;
 
 error_trans:
-- 
2.0.0

