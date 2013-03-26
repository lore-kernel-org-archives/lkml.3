Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965113Ab3CZPxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:53:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53784 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965040Ab3CZPWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guo Chao <yan@linux.vnet.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "M. Hindess" <hindessm@uk.ibm.com>,
        Nikanth Karthikesan <knikanth@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 025/150] loopdev: fix a deadlock
Date: Tue, 26 Mar 2013 15:18:44 +0000
Message-Id: <1364311249-14454-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guo Chao <yan@linux.vnet.ibm.com>

commit 5370019dc2d2c2ff90e95d181468071362934f3a upstream.

bd_mutex and lo_ctl_mutex can be held in different order.

Path #1:

blkdev_open
 blkdev_get
  __blkdev_get (hold bd_mutex)
   lo_open (hold lo_ctl_mutex)

Path #2:

blkdev_ioctl
 lo_ioctl (hold lo_ctl_mutex)
  lo_set_capacity (hold bd_mutex)

Lockdep does not report it, because path #2 actually holds a subclass of
lo_ctl_mutex.  This subclass seems creep into the code by mistake.  The
patch author actually just mentioned it in the changelog, see commit
f028f3b2 ("loop: fix circular locking in loop_clr_fd()"), also see:

	http://marc.info/?l=linux-kernel&m=123806169129727&w=2

Path #2 hold bd_mutex to call bd_set_size(), I've protected it
with i_mutex in a previous patch, so drop bd_mutex at this site.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Guo Chao <yan@linux.vnet.ibm.com>
Cc: M. Hindess <hindessm@uk.ibm.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/loop.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 3bba655..11e702c 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1263,11 +1263,9 @@ static int loop_set_capacity(struct loop_device *lo, struct block_device *bdev)
 	/* the width of sector_t may be narrow for bit-shift */
 	sz = sec;
 	sz <<= 9;
-	mutex_lock(&bdev->bd_mutex);
 	bd_set_size(bdev, sz);
 	/* let user-space know about the new size */
 	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
-	mutex_unlock(&bdev->bd_mutex);
 
  out:
 	return err;
-- 
1.8.1.2

