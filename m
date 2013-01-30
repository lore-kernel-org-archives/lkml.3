Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3A3J1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:27:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37748 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab3A3J0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:26:25 -0500
From: Hannes Reinecke <hare@suse.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Stefan Weinhuber <wein@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/9] dasd: detailed I/O errors
Date: Wed, 30 Jan 2013 10:26:16 +0100
Message-Id: <1359537979-39483-7-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1359537979-39483-1-git-send-email-hare@suse.de>
References: <1359537979-39483-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DASD driver is using FASTFAIL as an equivalent to the
transport errors in SCSI. And the 'steal lock' function maps
roughly to a reservation error. So we should be returning the
appropriate error codes when completing a request.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c          |    3 +++
 drivers/s390/block/dasd.c |   16 +++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c973249..d5579c2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2291,6 +2291,9 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		case -EBADE:
 			error_type = "critical nexus";
 			break;
+		case -ETIMEDOUT:
+			error_type = "timeout";
+			break;
 		case -EIO:
 		default:
 			error_type = "I/O";
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 98f62e9..bab870b 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2174,7 +2174,7 @@ static int _dasd_sleep_on(struct dasd_ccw_req *maincqr, int interruptible)
 		    test_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags) &&
 		    (!dasd_eer_enabled(device))) {
 			cqr->status = DASD_CQR_FAILED;
-			cqr->intrc = -EAGAIN;
+			cqr->intrc = -ENOLINK;
 			continue;
 		}
 		/* Don't try to start requests if device is stopped */
@@ -2501,8 +2501,17 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
 	req = (struct request *) cqr->callback_data;
 	dasd_profile_end(cqr->block, cqr, req);
 	status = cqr->block->base->discipline->free_cp(cqr, req);
-	if (status <= 0)
-		error = status ? status : -EIO;
+	if (status < 0)
+		error = status;
+	else if (status == 0) {
+		if (cqr->intrc == -EPERM)
+			error = -EBADE;
+		else if (cqr->intrc == -ENOLINK ||
+			 cqr->intrc == -ETIMEDOUT)
+			error = cqr->intrc;
+		else
+			error = -EIO;
+	}
 	__blk_end_request_all(req, error);
 }
 
@@ -2603,6 +2612,7 @@ static void __dasd_block_start_head(struct dasd_block *block)
 		    test_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags) &&
 		    (!dasd_eer_enabled(block->base))) {
 			cqr->status = DASD_CQR_FAILED;
+			cqr->intrc = -ENOLINK;
 			dasd_schedule_block_bh(block);
 			continue;
 		}
-- 
1.7.4.2

