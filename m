Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635Ab3LFOLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:11:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43757 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161282Ab3LFNAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 051/272] Staging: zram: Fix memory leak by refcount mismatch
Date: Fri,  6 Dec 2013 12:55:40 +0000
Message-Id: <1386334761-25517-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/zram/zram_drv.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index ee6b435..dda8771 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -651,21 +651,30 @@ static ssize_t reset_store(struct device *dev,
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
 
 	zram_reset_device(zram, true);
 	return len;
+
+out:
+	bdput(bdev);
+	return ret;
 }
 
 static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
-- 
1.8.3.2

