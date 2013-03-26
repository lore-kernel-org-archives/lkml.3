Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864Ab3CZPVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:21:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53552 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934757Ab3CZPVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:21:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Sandeen <sandeen@redhat.com>, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 019/150] btrfs: use rcu_barrier() to wait for bdev puts at unmount
Date: Tue, 26 Mar 2013 15:18:38 +0000
Message-Id: <1364311249-14454-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit bc178622d40d87e75abc131007342429c9b03351 upstream.

Doing this would reliably fail with -EBUSY for me:

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/volumes.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2208f0f..446896d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -609,6 +609,12 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
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
1.8.1.2

