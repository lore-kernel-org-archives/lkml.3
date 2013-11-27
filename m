Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab3K0Bc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:32:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547Ab3K0A6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jerome Marchand <jmarchan@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 3.12 025/116] Staging: zram: Fix access of NULL pointer
Date: Tue, 26 Nov 2013 16:56:38 -0800
Message-Id: <20131127005738.685642840@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/zram/zram_drv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -648,6 +648,9 @@ static ssize_t reset_store(struct device
 	zram = dev_to_zram(dev);
 	bdev = bdget_disk(zram->disk, 0);
 
+	if (!bdev)
+		return -ENOMEM;
+
 	/* Do not reset an active device! */
 	if (bdev->bd_holders)
 		return -EBUSY;
@@ -660,8 +663,7 @@ static ssize_t reset_store(struct device
 		return -EINVAL;
 
 	/* Make sure all pending I/O is finished */
-	if (bdev)
-		fsync_bdev(bdev);
+	fsync_bdev(bdev);
 
 	zram_reset_device(zram, true);
 	return len;


