Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965807AbaKLBzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:55:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966681AbaKLBzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:55:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.10 098/123] scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND
Date: Wed, 12 Nov 2014 10:17:44 +0900
Message-Id: <20141112011723.438471597@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 84ce0f0e94ac97217398b3b69c21c7a62ebeed05 upstream.

When sg_scsi_ioctl() fails to prepare request to submit in
blk_rq_map_kern() we jump to a label where we just end up copying
(luckily zeroed-out) kernel buffer to userspace instead of reporting
error. Fix the problem by jumping to the right label.

CC: Jens Axboe <axboe@kernel.dk>
CC: linux-scsi@vger.kernel.org
Coverity-id: 1226871
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Fixed up the, now unused, out label.

Signed-off-by: Jens Axboe <axboe@fb.com>

---
 block/scsi_ioctl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -506,7 +506,7 @@ int sg_scsi_ioctl(struct request_queue *
 
 	if (bytes && blk_rq_map_kern(q, rq, buffer, bytes, __GFP_WAIT)) {
 		err = DRIVER_ERROR << 24;
-		goto out;
+		goto error;
 	}
 
 	memset(sense, 0, sizeof(sense));
@@ -516,7 +516,6 @@ int sg_scsi_ioctl(struct request_queue *
 
 	blk_execute_rq(q, disk, rq, 0);
 
-out:
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
 		if (rq->sense_len && rq->sense) {


