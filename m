Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab3FRTrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:47:17 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37967 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3FRTrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:47:16 -0400
Date: Tue, 18 Jun 2013 14:46:04 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 7/11] rsxx: Fixes DLPAR add kernel panic if partition still
 mounted.
Message-ID: <20130618194603.GH6492@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061819-2876-0000-0000-000009FCC781
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

A kernel panic would occur on a DLPAR add if there was a partition
still mounted during the DLPAR remove. This bug fix will allow the
user to unmount the partition and bring the driver back into a
good state after the DLPAR add.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------



diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dev.c linux-block/drivers/block/rsxx/dev.c
--- linux-block-vanilla/drivers/block/rsxx/dev.c	2013-06-18 09:27:54.997977479 -0500
+++ linux-block/drivers/block/rsxx/dev.c	2013-06-18 09:38:35.997839384 -0500
@@ -171,6 +171,9 @@ static void rsxx_make_request(struct req
 
 	might_sleep();
 
+	if (!card)
+		goto req_err;
+
 	if (unlikely(card->halt)) {
 		st = -EFAULT;
 		goto req_err;
@@ -331,6 +334,7 @@ void rsxx_destroy_dev(struct rsxx_cardin
 	card->gendisk = NULL;
 
 	blk_cleanup_queue(card->queue);
+	card->queue->queuedata = NULL;
 	unregister_blkdev(card->major, DRIVER_NAME);
 }
 

