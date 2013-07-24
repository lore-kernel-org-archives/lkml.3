Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab3GXOSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:18:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45788 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188Ab3GXOGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:46 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jens Axboe" <axboe@kernel.dk>, "Kees Cook" <keescook@chromium.org>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.798137674@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [67/85] block: do not pass disk names as format strings
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust device pointer name in nbd.c]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 block/genhd.c              | 2 +-
 drivers/block/nbd.c        | 3 ++-
 drivers/scsi/osd/osd_uld.c | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -519,7 +519,7 @@ void register_disk(struct gendisk *disk)
 
 	ddev->parent = disk->driverfs_dev;
 
-	dev_set_name(ddev, disk->disk_name);
+	dev_set_name(ddev, "%s", disk->disk_name);
 
 	/* delay uevents, until we scanned partition table */
 	dev_set_uevent_suppress(ddev, 1);
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -675,7 +675,8 @@ static int __nbd_ioctl(struct block_devi
 
 		mutex_unlock(&lo->tx_lock);
 
-		thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
+		thread = kthread_create(nbd_thread, lo, "%s",
+					lo->disk->disk_name);
 		if (IS_ERR(thread)) {
 			mutex_lock(&lo->tx_lock);
 			return PTR_ERR(thread);
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

