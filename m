Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaHVUTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:19:42 -0400
Received: from mail.cybernetics.com ([173.71.130.66]:61899 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaHVUTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:19:39 -0400
X-Greylist: delayed 1563 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Aug 2014 16:19:39 EDT
Message-ID: <53F79FBF.4090000@cybernetics.com>
Date: Fri, 22 Aug 2014 15:53:35 -0400
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@fb.com>
CC: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [PATCH][SCSI] fix regression in SCSI_IOCTL_SEND_COMMAND
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_rq_set_block_pc() memsets rq->cmd to 0, so it should come
immediately after blk_get_request() to avoid overwriting the
user-supplied CDB.  Also check for failure to allocate rq.

Fixes: f27b087b81b7 ("block: add blk_rq_set_block_pc()")
Cc: <stable@vger.kernel.org> # 3.16.x
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>

---

For inclusion in 3.17 and 3.16.x.

Note: I don't have any programs that use this ioctl, so this patch is
compile-tested only.

--- linux-3.17.0-rc1-a/block/scsi_ioctl.c	2014-08-16 12:40:26.000000000 -0400
+++ linux-3.17.0-rc1-b/block/scsi_ioctl.c	2014-08-22 14:15:34.000000000 -0400
@@ -448,6 +448,11 @@ int sg_scsi_ioctl(struct request_queue *
 	}
 
 	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);
+	if (!rq) {
+		err = -ENOMEM;
+		goto error;
+	}
+	blk_rq_set_block_pc(rq);
 
 	cmdlen = COMMAND_SIZE(opcode);
 
@@ -501,7 +506,6 @@ int sg_scsi_ioctl(struct request_queue *
 	memset(sense, 0, sizeof(sense));
 	rq->sense = sense;
 	rq->sense_len = 0;
-	blk_rq_set_block_pc(rq);
 
 	blk_execute_rq(q, disk, rq, 0);
 
@@ -521,7 +525,8 @@ out:
 	
 error:
 	kfree(buffer);
-	blk_put_request(rq);
+	if (rq)
+		blk_put_request(rq);
 	return err;
 }
 EXPORT_SYMBOL_GPL(sg_scsi_ioctl);

