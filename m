Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab3FCPFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:05:19 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:50751 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758608Ab3FCPEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:04:21 -0400
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Stefan Weinhuber <wein@de.ibm.com>
Subject: [PATCH 6/9] block,dasd: detailed I/O errors
Date: Mon,  3 Jun 2013 17:03:19 +0200
Message-Id: <1370271802-30019-7-git-send-email-schwidefsky@de.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370271802-30019-1-git-send-email-schwidefsky@de.ibm.com>
References: <1370271802-30019-1-git-send-email-schwidefsky@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060314-6892-0000-0000-0000055289CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

The DASD driver is using FASTFAIL as an equivalent to the
transport errors in SCSI. And the 'steal lock' function maps
roughly to a reservation error. So we should be returning the
appropriate error codes when completing a request.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Stefan Weinhuber <wein@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 block/blk-core.c          |    3 +++
 drivers/s390/block/dasd.c |   16 +++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 33c33bc..ef19bf2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2315,6 +2315,9 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
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
index 87478be..b97624b 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2183,7 +2183,7 @@ static int _dasd_sleep_on(struct dasd_ccw_req *maincqr, int interruptible)
 		    test_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags) &&
 		    (!dasd_eer_enabled(device))) {
 			cqr->status = DASD_CQR_FAILED;
-			cqr->intrc = -EAGAIN;
+			cqr->intrc = -ENOLINK;
 			continue;
 		}
 		/* Don't try to start requests if device is stopped */
@@ -2590,8 +2590,17 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
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
 
@@ -2692,6 +2701,7 @@ static void __dasd_block_start_head(struct dasd_block *block)
 		    test_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags) &&
 		    (!dasd_eer_enabled(block->base))) {
 			cqr->status = DASD_CQR_FAILED;
+			cqr->intrc = -ENOLINK;
 			dasd_schedule_block_bh(block);
 			continue;
 		}
-- 
1.7.9.5

