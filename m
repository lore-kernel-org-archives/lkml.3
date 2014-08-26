Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbaHZNcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:32:07 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:8240 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757781AbaHZNcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:32:04 -0400
Date: Tue, 26 Aug 2014 15:31:59 +0200
From: Sabrina Dubroca <sd@queasysnail.net>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: linux-next: hdparm -B <value> broken
Message-ID: <20140826133159.GA5515@kria>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

Since next-20140823:

# hdparm -B 200 /dev/sda

/dev/sda:
 setting Advanced Power Management level to 0xc8 (200)
 HDIO_DRIVE_CMD failed: Bad address
 APM_level      = 128


It looks like before commit 2cada584b200 ("block: cleanup error
handling in sg_io"), we had ret = 0 before entering the last big if
block of sg_io, and now ret = -EFAULT.

The following patch seems to fix the problem:


diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 5dd477bfb4bc..9b8eaeca6a79 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -330,6 +330,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	if (blk_fill_sghdr_rq(q, rq, hdr, mode))
 		goto out_free_cdb;
 
+	ret = 0;
 	if (hdr->iovec_count) {
 		size_t iov_data_len;
 		struct iovec *iov = NULL;



Thanks,

-- 
Sabrina
