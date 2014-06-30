Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbaF3MP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:15:58 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51987 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753351AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 023/181] Btrfs: fix sync fs to actually wait for all data to be persisted
Date: Mon, 30 Jun 2014 13:50:44 +0200
Message-Id: <a2ea3d786a7e8f8ca08b10795a15178b3ba90b04.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Filipe David Borba Manana <fdmanana@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9b1998598625fb5b798e8291cafda1a8ec17c1bd upstream.

Currently the fs sync function (super.c:btrfs_sync_fs()) doesn't
wait for delayed work to finish before returning success to the
caller. This change fixes this, ensuring that there's no data loss
if a power failure happens right after fs sync returns success to
the caller and before the next commit happens.

Steps to reproduce the data loss issue:

$ mkfs.btrfs -f /dev/sdb3
$ mount /dev/sdb3 /mnt/btrfs
$ perl -e '$d = ("\x41" x 6001); open($f,">","/mnt/btrfs/foobar"); print $f $d; close($f);' && btrfs fi sync /mnt/btrfs

Right after the btrfs fi sync command (a second or 2 for example), power
off the machine and reboot it. The file will be empty, as it can be verified
after mounting the filesystem and through btrfs-debug-tree:

$ btrfs-debug-tree /dev/sdb3 | egrep '\(257 INODE_ITEM 0\) itemoff' -B 3 -A 8
        item 3 key (256 DIR_INDEX 2) itemoff 3751 itemsize 36
                location key (257 INODE_ITEM 0) type FILE
                namelen 6 datalen 0 name: foobar
        item 4 key (257 INODE_ITEM 0) itemoff 3591 itemsize 160
                inode generation 7 transid 7 size 0 block group 0 mode 100644 links 1
        item 5 key (257 INODE_REF 256) itemoff 3575 itemsize 16
                inode ref index 2 namelen 6 name: foobar
checksum tree key (CSUM_TREE ROOT_ITEM 0)
leaf 29429760 items 0 free space 3995 generation 7 owner 7
fs uuid 6192815c-af2a-4b75-b3db-a959ffb6166e
chunk uuid b529c44b-938c-4d3d-910a-013b4700bcae
uuid tree key (UUID_TREE ROOT_ITEM 0)

After this patch, the data loss no longer happens after a power failure and
btrfs-debug-tree shows:

$ btrfs-debug-tree /dev/sdb3 | egrep '\(257 INODE_ITEM 0\) itemoff' -B 3 -A 8
	item 3 key (256 DIR_INDEX 2) itemoff 3751 itemsize 36
		location key (257 INODE_ITEM 0) type FILE
		namelen 6 datalen 0 name: foobar
	item 4 key (257 INODE_ITEM 0) itemoff 3591 itemsize 160
		inode generation 6 transid 6 size 6001 block group 0 mode 100644 links 1
	item 5 key (257 INODE_REF 256) itemoff 3575 itemsize 16
		inode ref index 2 namelen 6 name: foobar
	item 6 key (257 EXTENT_DATA 0) itemoff 3522 itemsize 53
		extent data disk byte 12845056 nr 8192
		extent data offset 0 nr 8192 ram 8192
		extent compression 0
checksum tree key (CSUM_TREE ROOT_ITEM 0)

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/ioctl.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 45301541349e..ad6a08c5801e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4564,9 +4564,15 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_logical_to_ino(root, argp);
 	case BTRFS_IOC_SPACE_INFO:
 		return btrfs_ioctl_space_info(root, argp);
-	case BTRFS_IOC_SYNC:
-		btrfs_sync_fs(file->f_dentry->d_sb, 1);
-		return 0;
+	case BTRFS_IOC_SYNC: {
+		int ret;
+
+		ret = btrfs_start_all_delalloc_inodes(root->fs_info, 0);
+		if (ret)
+			return ret;
+		ret = btrfs_sync_fs(file->f_dentry->d_sb, 1);
+		return ret;
+	}
 	case BTRFS_IOC_START_SYNC:
 		return btrfs_ioctl_start_sync(root, argp);
 	case BTRFS_IOC_WAIT_SYNC:
-- 
2.0.0

