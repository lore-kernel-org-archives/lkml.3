Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbbAMRTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:19:31 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50198 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbbAMRTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:19:30 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Paul Clements <Paul.Clements@steeleye.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        nbd-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] nbd: fix possible memory leak
Date: Tue, 13 Jan 2015 22:49:17 +0530
Message-Id: <1421169557-18549-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we have already allocated memory for nbd_dev, but we were not
releasing that memory and just returning the error value.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

Hi Paul,
after seeing your mail about maintainers, just started to see the code.
this patch is one way, another way can be to bring the kcalloc part below these checks. 

 drivers/block/nbd.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 4bc2a5c..13ea239 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -822,11 +822,15 @@ static int __init nbd_init(void)
 		max_part = (1UL << part_shift) - 1;
 	}
 
-	if ((1UL << part_shift) > DISK_MAX_PARTS)
-		return -EINVAL;
+	if ((1UL << part_shift) > DISK_MAX_PARTS) {
+		err = -EINVAL;
+		goto out_free;
+	}
 
-	if (nbds_max > 1UL << (MINORBITS - part_shift))
-		return -EINVAL;
+	if (nbds_max > 1UL << (MINORBITS - part_shift)) {
+		err = -EINVAL;
+		goto out_free;
+	}
 
 	for (i = 0; i < nbds_max; i++) {
 		struct gendisk *disk = alloc_disk(1 << part_shift);
@@ -889,6 +893,7 @@ out:
 		blk_cleanup_queue(nbd_dev[i].disk->queue);
 		put_disk(nbd_dev[i].disk);
 	}
+out_free:
 	kfree(nbd_dev);
 	return err;
 }
-- 
1.8.1.2

