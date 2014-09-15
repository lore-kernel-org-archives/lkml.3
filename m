Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbaIOVAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:00:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbaIOT1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tony Battersby <tonyb@cybernetics.com>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.16 059/158] fix regression in SCSI_IOCTL_SEND_COMMAND
Date: Mon, 15 Sep 2014 12:24:58 -0700
Message-Id: <20140915192544.664019543@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Battersby <tonyb@cybernetics.com>

commit 2ba136daa3ae1e881c9f586f283fcaa164767dce upstream.

blk_rq_set_block_pc() memsets rq->cmd to 0, so it should come
immediately after blk_get_request() to avoid overwriting the
user-supplied CDB.  Also check for failure to allocate rq.

Fixes: f27b087b81b7 ("block: add blk_rq_set_block_pc()")
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/scsi_ioctl.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -438,6 +438,11 @@ int sg_scsi_ioctl(struct request_queue *
 	}
 
 	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);
+	if (!rq) {
+		err = -ENOMEM;
+		goto error;
+	}
+	blk_rq_set_block_pc(rq);
 
 	cmdlen = COMMAND_SIZE(opcode);
 
@@ -491,7 +496,6 @@ int sg_scsi_ioctl(struct request_queue *
 	memset(sense, 0, sizeof(sense));
 	rq->sense = sense;
 	rq->sense_len = 0;
-	blk_rq_set_block_pc(rq);
 
 	blk_execute_rq(q, disk, rq, 0);
 
@@ -511,7 +515,8 @@ out:
 	
 error:
 	kfree(buffer);
-	blk_put_request(rq);
+	if (rq)
+		blk_put_request(rq);
 	return err;
 }
 EXPORT_SYMBOL_GPL(sg_scsi_ioctl);


