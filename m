Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbaF1Sba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:31:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbaF1Rut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:50:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tsutomu Itoh <t-itoh@jp.fujitsu.com>, Karel Zak <kzak@redhat.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.14 092/110] btrfs: Add ctime/mtime update for btrfs device add/remove.
Date: Sat, 28 Jun 2014 10:47:29 -0700
Message-Id: <20140628174550.962976077@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

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
@@ -1690,10 +1706,14 @@ int btrfs_rm_device(struct btrfs_root *r
 
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
@@ -2132,6 +2152,8 @@ int btrfs_init_new_device(struct btrfs_r
 		ret = btrfs_commit_transaction(trans, root);
 	}
 
+	/* Update ctime/mtime for libblkid */
+	update_dev_time(device_path);
 	return ret;
 
 error_trans:


