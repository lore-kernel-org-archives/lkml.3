Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab3CRVIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:08:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab3CRVIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:08:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guo Chao <yan@linux.vnet.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "M. Hindess" <hindessm@uk.ibm.com>,
        Nikanth Karthikesan <knikanth@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [ 35/48] loopdev: remove an user triggerable oops
Date: Mon, 18 Mar 2013 14:08:43 -0700
Message-Id: <20130318210812.727226489@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210810.247845918@linuxfoundation.org>
References: <20130318210810.247845918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/loop.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1835,11 +1835,15 @@ static int __init loop_init(void)
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
@@ -1857,8 +1861,10 @@ static int __init loop_init(void)
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
@@ -1871,6 +1877,10 @@ static int __init loop_init(void)
 
 	printk(KERN_INFO "loop: module loaded\n");
 	return 0;
+
+misc_out:
+	misc_deregister(&loop_misc);
+	return err;
 }
 
 static int loop_exit_cb(int id, void *ptr, void *data)


