Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbaHYNZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:25:13 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:56667 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759AbaHYNZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:25:03 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 6/8] drbd: Get rid of the WORK_PENDING macro
Date: Mon, 25 Aug 2014 15:16:36 +0200
Message-Id: <1408972598-16650-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408972598-16650-1-git-send-email-philipp.reisner@linbit.com>
References: <1408972598-16650-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>

This macro doesn't add any value; just use test_bit() instead.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_worker.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index b20cd21..3b74f08 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1931,19 +1931,18 @@ void __update_timing_details(
 	++(*cb_nr);
 }
 
-#define WORK_PENDING(work_bit, todo)	(todo & (1UL << work_bit))
 static void do_device_work(struct drbd_device *device, const unsigned long todo)
 {
-	if (WORK_PENDING(MD_SYNC, todo))
+	if (test_bit(MD_SYNC, &todo))
 		do_md_sync(device);
-	if (WORK_PENDING(RS_DONE, todo) ||
-	    WORK_PENDING(RS_PROGRESS, todo))
-		update_on_disk_bitmap(device, WORK_PENDING(RS_DONE, todo));
-	if (WORK_PENDING(GO_DISKLESS, todo))
+	if (test_bit(RS_DONE, &todo) ||
+	    test_bit(RS_PROGRESS, &todo))
+		update_on_disk_bitmap(device, test_bit(RS_DONE, &todo));
+	if (test_bit(GO_DISKLESS, &todo))
 		go_diskless(device);
-	if (WORK_PENDING(DESTROY_DISK, todo))
+	if (test_bit(DESTROY_DISK, &todo))
 		drbd_ldev_destroy(device);
-	if (WORK_PENDING(RS_START, todo))
+	if (test_bit(RS_START, &todo))
 		do_start_resync(device);
 }
 
-- 
1.9.1

