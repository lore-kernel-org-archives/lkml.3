Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbaIIPvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:51:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37231 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753844AbaIIPu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:50:59 -0400
Date: Tue, 9 Sep 2014 11:50:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] Block: fix unbalanced bypass-disable in blk_register_queue
In-Reply-To: <20140909151726.GA8890@mtj.dyndns.org>
Message-ID: <Pine.LNX.4.44L0.1409091149360.968-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a queue is registered, the block layer turns off the bypass
setting (because bypass is enabled when the queue is created).  This
doesn't work well for queues that are unregistered and then registered
again; we get a WARNING because of the unbalanced calls to
blk_queue_bypass_end().

This patch fixes the problem by making blk_register_queue() call
blk_queue_bypass_end() only the first time the queue is registered.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Tejun Heo <tj@kernel.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Jens Axboe <axboe@kernel.dk>

---

[as1765]


 block/blk-sysfs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: usb-3.17/block/blk-sysfs.c
===================================================================
--- usb-3.17.orig/block/blk-sysfs.c
+++ usb-3.17/block/blk-sysfs.c
@@ -554,8 +554,10 @@ int blk_register_queue(struct gendisk *d
 	 * Initialization must be complete by now.  Finish the initial
 	 * bypass from queue allocation.
 	 */
-	queue_flag_set_unlocked(QUEUE_FLAG_INIT_DONE, q);
-	blk_queue_bypass_end(q);
+	if (!blk_queue_init_done(q)) {
+		queue_flag_set_unlocked(QUEUE_FLAG_INIT_DONE, q);
+		blk_queue_bypass_end(q);
+	}
 
 	ret = blk_trace_init_sysfs(dev);
 	if (ret)

