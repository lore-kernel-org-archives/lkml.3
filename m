Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3CREqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:46:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33481 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721Ab3CREaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:23 -0400
Message-Id: <20130318042152.013140222@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:23:04 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Guo Chao <yan@linux.vnet.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "M. Hindess" <hindessm@uk.ibm.com>,
        Nikanth Karthikesan <knikanth@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: [ 80/82] loopdev: remove an user triggerable oops
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

commit b1a6650406875b9097a032eed89af50682fe1160 upstream.

When loopdev is built as module and we pass an invalid parameter,
loop_init() will return directly without deregister misc device, which
will cause an oops when insert loop module next time because we left some
garbage in the misc device list.

Test case:
sudo modprobe loop max_part=1024
(failed due to invalid parameter)
sudo modprobe loop
(oops)

Clean up nicely to avoid such oops.

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
 drivers/block/loop.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1834,11 +1834,15 @@ static int __init loop_init(void)
 		max_part = (1UL << part_shift) - 1;
 	}
 
-	if ((1UL << part_shift) > DISK_MAX_PARTS)
-		return -EINVAL;
+	if ((1UL << part_shift) > DISK_MAX_PARTS) {
+		err = -EINVAL;
+		goto misc_out;
+	}
 
-	if (max_loop > 1UL << (MINORBITS - part_shift))
-		return -EINVAL;
+	if (max_loop > 1UL << (MINORBITS - part_shift)) {
+		err = -EINVAL;
+		goto misc_out;
+	}
 
 	/*
 	 * If max_loop is specified, create that many devices upfront.
@@ -1856,8 +1860,10 @@ static int __init loop_init(void)
 		range = 1UL << MINORBITS;
 	}
 
-	if (register_blkdev(LOOP_MAJOR, "loop"))
-		return -EIO;
+	if (register_blkdev(LOOP_MAJOR, "loop")) {
+		err = -EIO;
+		goto misc_out;
+	}
 
 	blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
 				  THIS_MODULE, loop_probe, NULL, NULL);
@@ -1870,6 +1876,10 @@ static int __init loop_init(void)
 
 	printk(KERN_INFO "loop: module loaded\n");
 	return 0;
+
+misc_out:
+	misc_deregister(&loop_misc);
+	return err;
 }
 
 static int loop_exit_cb(int id, void *ptr, void *data)


