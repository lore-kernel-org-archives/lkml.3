Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaAMO1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:27:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbaAMOZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:25:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 19/96] Staging: zram: Fix memory leak by refcount mismatch
Date: Mon, 13 Jan 2014 14:23:42 +0000
Message-Id: <1389623099-18783-20-git-send-email-luis.henriques@canonical.com>
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

commit 1b672224d128ec2570eb37572ff803cfe452b4f7 upstream.

As suggested by Minchan Kim and Jerome Marchand "The code in reset_store
get the block device (bdget_disk()) but it does not put it (bdput()) when
it's done using it. The usage count is therefore incremented but never
decremented."

This patch also puts bdput() for all error cases.

Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5:
  - adjusted filename: zram_drv.c -> zram_sysfs.c
  - adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/zram/zram_sysfs.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index 01f9a79..aafcf03 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -99,18 +99,23 @@ static ssize_t reset_store(struct device *dev,
 		return -ENOMEM;
 
 	/* Do not reset an active device! */
-	if (bdev->bd_holders)
-		return -EBUSY;
+	if (bdev->bd_holders) {
+		ret = -EBUSY;
+		goto out;
+	}
 
 	ret = kstrtou16(buf, 10, &do_reset);
 	if (ret)
-		return ret;
+		goto out;
 
-	if (!do_reset)
-		return -EINVAL;
+	if (!do_reset) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	/* Make sure all pending I/O is finished */
 	fsync_bdev(bdev);
+	bdput(bdev);
 
 	down_write(&zram->init_lock);
 	if (zram->init_done)
@@ -118,6 +123,10 @@ static ssize_t reset_store(struct device *dev,
 	up_write(&zram->init_lock);
 
 	return len;
+
+out:
+	bdput(bdev);
+	return ret;
 }
 
 static ssize_t num_reads_show(struct device *dev,
-- 
1.8.3.2

