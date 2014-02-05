Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbaBEUS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:18:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:55541 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398AbaBEUHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:48 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Sandeen <sandeen@redhat.com>, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 184/213] btrfs: use rcu_barrier() to wait for bdev puts at unmount
Date: Wed, 5 Feb 2014 15:02:19 -0500
Message-ID: <1391630568-49251-185-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit bc178622d40d87e75abc131007342429c9b03351 upstream.

Doing this would reliably fail with -EBUSY for me:

# mount /dev/sdb2 /mnt/scratch; umount /mnt/scratch; mkfs.btrfs -f /dev/sdb2
...
unable to open /dev/sdb2: Device or resource busy

because mkfs.btrfs tries to open the device O_EXCL, and somebody still has it.

Using systemtap to track bdev gets & puts shows a kworker thread doing a
blkdev put after mkfs attempts a get; this is left over from the unmount
path:

btrfs_close_devices
	__btrfs_close_devices
		call_rcu(&device->rcu, free_device);
			free_device
				INIT_WORK(&device->rcu_work, __free_device);
				schedule_work(&device->rcu_work);

so unmount might complete before __free_device fires & does its blkdev_put.

Adding an rcu_barrier() to btrfs_close_devices() causes unmount to wait
until all blkdev_put()s are done, and the device is truly free once
unmount completes.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/btrfs/volumes.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c04ebb1e4c98..7f75546941ac 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -565,6 +565,12 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		__btrfs_close_devices(fs_devices);
 		free_fs_devices(fs_devices);
 	}
+	/*
+	 * Wait for rcu kworkers under __btrfs_close_devices
+	 * to finish all blkdev_puts so device is really
+	 * free when umount is done.
+	 */
+	rcu_barrier();
 	return ret;
 }
 
-- 
1.8.5.2

