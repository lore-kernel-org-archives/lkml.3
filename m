Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab3L2Ccv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:32:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55454 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897Ab3L2CKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:47 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Rashika Kheria" <rashika.kheria@gmail.com>,
        "Jerome Marchand" <jmarchan@redhat.com>,
        "Minchan Kim" <minchan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.310055095@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 094/185] Staging: zram: Fix access of NULL pointer
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Rashika Kheria <rashika.kheria@gmail.com>

commit 46a51c80216cb891f271ad021f59009f34677499 upstream.

This patch fixes the bug in reset_store caused by accessing NULL pointer.

The bdev gets its value from bdget_disk() which could fail when memory
pressure is severe and hence can return NULL because allocation of
inode in bdget could fail.

Hence, this patch introduces a check for bdev to prevent reference to a
NULL pointer in the later part of the code. It also removes unnecessary
check of bdev for fsync_bdev().

Acked-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/zram/zram_sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -95,6 +95,9 @@ static ssize_t reset_store(struct device
 	zram = dev_to_zram(dev);
 	bdev = bdget_disk(zram->disk, 0);
 
+	if (!bdev)
+		return -ENOMEM;
+
 	/* Do not reset an active device! */
 	if (bdev->bd_holders)
 		return -EBUSY;
@@ -107,8 +110,7 @@ static ssize_t reset_store(struct device
 		return -EINVAL;
 
 	/* Make sure all pending I/O is finished */
-	if (bdev)
-		fsync_bdev(bdev);
+	fsync_bdev(bdev);
 
 	down_write(&zram->init_lock);
 	if (zram->init_done)

