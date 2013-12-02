Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab3LBU0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:26:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab3LBTQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:16:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 3.12 013/212] Staging: zram: Fix memory leak by refcount mismatch
Date: Mon,  2 Dec 2013 11:13:24 -0800
Message-Id: <20131202191250.122965760@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/zram/zram_drv.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -652,21 +652,30 @@ static ssize_t reset_store(struct device
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


