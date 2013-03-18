Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab3CREbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:31:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33430 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563Ab3CREaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:18 -0400
Message-Id: <20130318042152.107067585@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:23:05 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Eric Sandeen <sandeen@redhat.com>,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [ 81/82] btrfs: use rcu_barrier() to wait for bdev puts at unmount
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/volumes.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -577,6 +577,12 @@ int btrfs_close_devices(struct btrfs_fs_
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
 


