Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaASBI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 20:08:59 -0500
Received: from mout.gmx.net ([212.227.15.18]:53836 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbaASBIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 20:08:50 -0500
Date: Sun, 19 Jan 2014 02:08:49 +0100
From: Christian Engelmayer <cengelma@gmx.at>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: Fix memory leak in rw_copy_check_uvector() handling
Message-ID: <20140119020849.26de4fb0@spike>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:rs1pdF6TSc+9zdjMFChVVC9NOXKMzEQGkPk+xk4sNJRwdF1R6dQ
 26OfxiqwvYEMShlekhvDS4aJmp5W+7YyXoT1jeSpZ/7GtVmsthh7IQvPHdirFIe3uUZhfxC
 OWWq61JpTQuknjo409gZB67HqnAlZlMXD0YzYuLH4+eQjQ08vy5JxGWOxK+sgXKbEvGpC1V
 S/7cyXuG6bzV0eZUNFTcQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a memory leak in the error handling path of function sg_io()
that is used during the processing of scsi ioctl. Memory already
allocated by rw_copy_check_uvector() needs to be freed correctly.
Detected by Coverity: CID 1128953.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 block/scsi_ioctl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 625e3e4..2648797 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -323,12 +323,14 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 
 	if (hdr->iovec_count) {
 		size_t iov_data_len;
-		struct iovec *iov;
+		struct iovec *iov = NULL;
 
 		ret = rw_copy_check_uvector(-1, hdr->dxferp, hdr->iovec_count,
 					    0, NULL, &iov);
-		if (ret < 0)
+		if (ret < 0) {
+			kfree(iov);
 			goto out;
+		}
 
 		iov_data_len = ret;
 		ret = 0;
-- 
1.8.3.2
