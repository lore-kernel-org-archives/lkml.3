Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbaJWT36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:29:58 -0400
Received: from mail.cybernetics.com ([173.71.130.66]:56520 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaJWT34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:29:56 -0400
Message-ID: <544952B2.8030200@cybernetics.com>
Date: Thu, 23 Oct 2014 15:10:42 -0400
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: Fix more error handling in SCSI_IOCTL_SEND_COMMAND
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an error path in SCSI_IOCTL_SEND_COMMAND that calls
blk_put_request(rq) on an invalid IS_ERR(rq) pointer.

Fixes: a492f075450f ("block,scsi: fixup blk_get_request dead queue
scenarios")
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

For inclusion in 3.18 only.

This does not conflict with the other recent fix to sg_scsi_ioctl() from
Jan Kara.

--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -458,7 +458,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);
 	if (IS_ERR(rq)) {
 		err = PTR_ERR(rq);
-		goto error;
+		goto error_free_buffer;
 	}
 	blk_rq_set_block_pc(rq);
 
@@ -532,9 +532,11 @@ out:
 	}
 	
 error:
+	blk_put_request(rq);
+
+error_free_buffer:
 	kfree(buffer);
-	if (rq)
-		blk_put_request(rq);
+
 	return err;
 }
 EXPORT_SYMBOL_GPL(sg_scsi_ioctl);

