Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab3FGXvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:51:45 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47095 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756681Ab3FGXvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:51:43 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Karsten Keil <isdn@linux-pingi.de>, Kees Cook <keescook@chromium.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/6] block: do not pass disk names as format strings
Date: Fri,  7 Jun 2013 16:50:50 -0700
Message-Id: <1370649055-12830-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370649055-12830-1-git-send-email-keescook@chromium.org>
References: <1370649055-12830-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disk names may contain arbitrary strings, so they must not be interpreted
as format strings. It seems that only md allows arbitrary strings to be
used for disk names, but this could allow for a local memory corruption
from uid 0 into ring 0.

CVE-2013-2851

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/genhd.c              |    2 +-
 drivers/block/nbd.c        |    3 ++-
 drivers/scsi/osd/osd_uld.c |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 20625ee..cdeb527 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -512,7 +512,7 @@ static void register_disk(struct gendisk *disk)
 
 	ddev->parent = disk->driverfs_dev;
 
-	dev_set_name(ddev, disk->disk_name);
+	dev_set_name(ddev, "%s", disk->disk_name);
 
 	/* delay uevents, until we scanned partition table */
 	dev_set_uevent_suppress(ddev, 1);
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 037288e..46b35f7 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -714,7 +714,8 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		else
 			blk_queue_flush(nbd->disk->queue, 0);
 
-		thread = kthread_create(nbd_thread, nbd, nbd->disk->disk_name);
+		thread = kthread_create(nbd_thread, nbd, "%s",
+					nbd->disk->disk_name);
 		if (IS_ERR(thread)) {
 			mutex_lock(&nbd->tx_lock);
 			return PTR_ERR(thread);
diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 0fab6b5..9d86947 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -485,7 +485,7 @@ static int osd_probe(struct device *dev)
 	oud->class_dev.class = &osd_uld_class;
 	oud->class_dev.parent = dev;
 	oud->class_dev.release = __remove;
-	error = dev_set_name(&oud->class_dev, disk->disk_name);
+	error = dev_set_name(&oud->class_dev, "%s", disk->disk_name);
 	if (error) {
 		OSD_ERR("dev_set_name failed => %d\n", error);
 		goto err_put_cdev;
-- 
1.7.9.5

