Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbaDQDcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 23:32:00 -0400
Received: from mailout.micron.com ([137.201.242.129]:26680 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaDQDb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 23:31:59 -0400
Message-ID: <534F4B2D.3060302@micron.com>
Date: Wed, 16 Apr 2014 20:31:57 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:28.0) Gecko/20100101 Thunderbird/28.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: block: check for dying queue in generic_make_request()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20636.004
X-TM-AS-Result: No--6.408900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Check for dying queue is in request queue interface, but not for direct use
of make_request().

When a mounted device is surprise removed, block drivers delete gendisk and
cleanup request queue. As the reference count is non-zero, these structures
continue to exist and any further I/O request is passed on to block drivers.
With respect to the block driver, the device is removed and cleaned up the
data structures. This check will stop I/O to a non-existent device at the
block layer.

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 block/blk-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e45b321..cec6bf4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1713,7 +1713,7 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 
 	q = bdev_get_queue(bio->bi_bdev);
-	if (unlikely(!q)) {
+	if (unlikely(!q || blk_queue_dying(q))) {
 		printk(KERN_ERR
 		       "generic_make_request: Trying to access "
 			"nonexistent block-device %s (%Lu)\n",
-- 
1.7.1

