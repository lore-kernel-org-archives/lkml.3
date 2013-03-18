Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab3CREbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:31:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33484 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731Ab3CREa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:26 -0400
Message-Id: <20130318042151.896476449@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:23:03 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Guo Chao <yan@linux.vnet.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "M. Hindess" <hindessm@uk.ibm.com>,
        Nikanth Karthikesan <knikanth@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: [ 79/82] loopdev: fix a deadlock
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/loop.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1262,11 +1262,9 @@ static int loop_set_capacity(struct loop
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


