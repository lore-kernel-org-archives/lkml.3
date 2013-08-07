Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807Ab3HGWDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 18:03:05 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:43604 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206Ab3HGVy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:54:56 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 01/22] block: Use rw_copy_check_uvector()
Date: Wed,  7 Aug 2013 14:54:10 -0700
Message-Id: <1375912471-5106-2-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc1
In-Reply-To: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need for silly open coding - and struct sg_iovec has exactly the same
layout as struct iovec...

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/scsi_ioctl.c | 39 ++++++++++-----------------------------
 1 file changed, 10 insertions(+), 29 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index a5ffcc9..625e3e4 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -286,7 +286,8 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 		struct sg_io_hdr *hdr, fmode_t mode)
 {
 	unsigned long start_time;
-	int writing = 0, ret = 0;
+	ssize_t ret = 0;
+	int writing = 0;
 	struct request *rq;
 	char sense[SCSI_SENSE_BUFFERSIZE];
 	struct bio *bio;
@@ -321,37 +322,16 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	}
 
 	if (hdr->iovec_count) {
-		const int size = sizeof(struct sg_iovec) * hdr->iovec_count;
 		size_t iov_data_len;
-		struct sg_iovec *sg_iov;
 		struct iovec *iov;
-		int i;
 
-		sg_iov = kmalloc(size, GFP_KERNEL);
-		if (!sg_iov) {
-			ret = -ENOMEM;
+		ret = rw_copy_check_uvector(-1, hdr->dxferp, hdr->iovec_count,
+					    0, NULL, &iov);
+		if (ret < 0)
 			goto out;
-		}
-
-		if (copy_from_user(sg_iov, hdr->dxferp, size)) {
-			kfree(sg_iov);
-			ret = -EFAULT;
-			goto out;
-		}
 
-		/*
-		 * Sum up the vecs, making sure they don't overflow
-		 */
-		iov = (struct iovec *) sg_iov;
-		iov_data_len = 0;
-		for (i = 0; i < hdr->iovec_count; i++) {
-			if (iov_data_len + iov[i].iov_len < iov_data_len) {
-				kfree(sg_iov);
-				ret = -EINVAL;
-				goto out;
-			}
-			iov_data_len += iov[i].iov_len;
-		}
+		iov_data_len = ret;
+		ret = 0;
 
 		/* SG_IO howto says that the shorter of the two wins */
 		if (hdr->dxfer_len < iov_data_len) {
@@ -361,9 +341,10 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 			iov_data_len = hdr->dxfer_len;
 		}
 
-		ret = blk_rq_map_user_iov(q, rq, NULL, sg_iov, hdr->iovec_count,
+		ret = blk_rq_map_user_iov(q, rq, NULL, (struct sg_iovec *) iov,
+					  hdr->iovec_count,
 					  iov_data_len, GFP_KERNEL);
-		kfree(sg_iov);
+		kfree(iov);
 	} else if (hdr->dxfer_len)
 		ret = blk_rq_map_user(q, rq, NULL, hdr->dxferp, hdr->dxfer_len,
 				      GFP_KERNEL);
-- 
1.8.4.rc1

