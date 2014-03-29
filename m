Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaC2O3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 10:29:23 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35611 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaC2O2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 10:28:53 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] block: fix SG_[GS]ET_RESERVED_SIZE ioctl when max_sectors is huge
Date: Sat, 29 Mar 2014 23:28:42 +0900
Message-Id: <1396103322-3519-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396103322-3519-1-git-send-email-akinobu.mita@gmail.com>
References: <1396103322-3519-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SG_GET_RESERVED_SIZE and SG_SET_RESERVED_SIZE ioctls access a reserved
buffer in bytes as int type.  The value needs to be capped at the request
queue's max_sectors.  But integer overflow is not correctly handled in
the calculation when converting max_sectors from sectors to bytes.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/scsi_ioctl.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 2648797..6174bba 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -82,9 +82,18 @@ static int sg_set_timeout(struct request_queue *q, int __user *p)
 	return err;
 }
 
+static int max_sectors_bytes(struct request_queue *q)
+{
+	unsigned int max_sectors = queue_max_sectors(q);
+
+	max_sectors = min_t(unsigned int, max_sectors, INT_MAX >> 9);
+
+	return max_sectors << 9;
+}
+
 static int sg_get_reserved_size(struct request_queue *q, int __user *p)
 {
-	unsigned val = min(q->sg_reserved_size, queue_max_sectors(q) << 9);
+	int val = min_t(int, q->sg_reserved_size, max_sectors_bytes(q));
 
 	return put_user(val, p);
 }
@@ -98,10 +107,8 @@ static int sg_set_reserved_size(struct request_queue *q, int __user *p)
 
 	if (size < 0)
 		return -EINVAL;
-	if (size > (queue_max_sectors(q) << 9))
-		size = queue_max_sectors(q) << 9;
 
-	q->sg_reserved_size = size;
+	q->sg_reserved_size = min(size, max_sectors_bytes(q));
 	return 0;
 }
 
-- 
1.8.3.2

