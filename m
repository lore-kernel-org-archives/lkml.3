Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaAMO0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:26:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51227 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaAMOZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:25:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 17/96] Staging: zram: Fix access of NULL pointer
Date: Mon, 13 Jan 2014 14:23:40 +0000
Message-Id: <1389623099-18783-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5:
  - adjusted filename: zram_drv.c -> zram_sysfs.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/zram/zram_sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index dbe8907..01f9a79 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -95,6 +95,9 @@ static ssize_t reset_store(struct device *dev,
 	zram = dev_to_zram(dev);
 	bdev = bdget_disk(zram->disk, 0);
 
+	if (!bdev)
+		return -ENOMEM;
+
 	/* Do not reset an active device! */
 	if (bdev->bd_holders)
 		return -EBUSY;
@@ -107,8 +110,7 @@ static ssize_t reset_store(struct device *dev,
 		return -EINVAL;
 
 	/* Make sure all pending I/O is finished */
-	if (bdev)
-		fsync_bdev(bdev);
+	fsync_bdev(bdev);
 
 	down_write(&zram->init_lock);
 	if (zram->init_done)
-- 
1.8.3.2

