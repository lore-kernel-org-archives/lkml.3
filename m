Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab3GKO0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:26:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42980 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab3GKO0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 35/98] block: do not pass disk names as format strings
Date: Thu, 11 Jul 2013 15:24:05 +0100
Message-Id: <1373552708-15235-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit ffc8b30866879ed9ba62bd0a86fecdbd51cd3d19 upstream.

Disk names may contain arbitrary strings, so they must not be
interpreted as format strings.  It seems that only md allows arbitrary
strings to be used for disk names, but this could allow for a local
memory corruption from uid 0 into ring 0.

CVE-2013-2851

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 block/genhd.c              | 2 +-
 drivers/block/nbd.c        | 3 ++-
 drivers/scsi/osd/osd_uld.c | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 60108d9..d815a0f 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -518,7 +518,7 @@ static void register_disk(struct gendisk *disk)
 
 	ddev->parent = disk->driverfs_dev;
 
-	dev_set_name(ddev, disk->disk_name);
+	dev_set_name(ddev, "%s", disk->disk_name);
 
 	/* delay uevents, until we scanned partition table */
 	dev_set_uevent_suppress(ddev, 1);
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 7f25e24..e1d49fc 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -675,7 +675,8 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 
 		mutex_unlock(&nbd->tx_lock);
 
-		thread = kthread_create(nbd_thread, nbd, nbd->disk->disk_name);
+		thread = kthread_create(nbd_thread, nbd, "%s",
+					nbd->disk->disk_name);
 		if (IS_ERR(thread)) {
 			mutex_lock(&nbd->tx_lock);
 			return PTR_ERR(thread);
diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index d4ed9eb..caac1b2 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -465,7 +465,7 @@ static int osd_probe(struct device *dev)
 	oud->class_dev.class = &osd_uld_class;
 	oud->class_dev.parent = dev;
 	oud->class_dev.release = __remove;
-	error = dev_set_name(&oud->class_dev, disk->disk_name);
+	error = dev_set_name(&oud->class_dev, "%s", disk->disk_name);
 	if (error) {
 		OSD_ERR("dev_set_name failed => %d\n", error);
 		goto err_put_cdev;
-- 
1.8.1.2

