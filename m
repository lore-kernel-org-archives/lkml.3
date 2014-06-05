Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbaFEEwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:52:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaFEEVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jerome Marchand <jmarchan@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Minchan Kim <minchan@kernel.org>, Ben Hutchings <ben@decadent.org.uk>,
        Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 107/214] Staging: zram: Fix access of NULL pointer
Date: Wed,  4 Jun 2014 21:17:50 -0700
Message-Id: <20140605041654.064572655@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zram/zram_sysfs.c |    6 ++++--
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


