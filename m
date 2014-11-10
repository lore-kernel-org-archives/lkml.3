Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaKJWjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:39:55 -0500
Received: from mail.cybernetics.com ([173.71.130.66]:61049 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaKJWjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:39:54 -0500
Message-ID: <54613EC2.8010304@cybernetics.com>
Date: Mon, 10 Nov 2014 17:40:02 -0500
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

Fixes: a492f075450f ("block,scsi: fixup blk_get_request dead queue scenarios")
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

(resending, since no one picked it up last time)

For inclusion in 3.18 only.  This fixes a problem
introduced in 3.18.

Note: this fixes a *different* problem from Jan Kara's
patch with a similar subject line, which has already
been applied to mainline.

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
 
@@ -531,9 +531,11 @@ out:
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

