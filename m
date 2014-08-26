Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbaHZOQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:16:30 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:60989 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231AbaHZOQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:16:27 -0400
From: Sabrina Dubroca <sd@queasysnail.net>
To: hch@lst.de
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH] block: fix error handling in sg_io
Date: Tue, 26 Aug 2014 16:14:02 +0200
Message-Id: <1409062442-32766-1-git-send-email-sd@queasysnail.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140826135143.GA30461@lst.de>
References: <20140826135143.GA30461@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before commit 2cada584b200 ("block: cleanup error handling in sg_io"),
we had ret = 0 before entering the last big if block of sg_io.

Since 2cada584b200, ret = -EFAULT, which breaks hdparm:

/dev/sda:
 setting Advanced Power Management level to 0xc8 (200)
 HDIO_DRIVE_CMD failed: Bad address
 APM_level      = 128

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Fixes: 2cada584b200 ("block: cleanup error handling in sg_io")
---
 block/scsi_ioctl.c | 1 +
 1 file changed, 1 insertion(+)

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
-- 
2.1.0

