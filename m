Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbaFLXTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:19:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaFLXTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:19:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 5/8] Staging: zram: Fix memory leak by refcount mismatch
Date: Thu, 12 Jun 2014 16:22:52 -0700
Message-Id: <20140612232238.863387039@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140612232238.396722659@linuxfoundation.org>
References: <20140612232238.396722659@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[wyj: Backported to 3.4: adjust context]
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/zram/zram_sysfs.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -99,18 +99,23 @@ static ssize_t reset_store(struct device
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
@@ -118,6 +123,10 @@ static ssize_t reset_store(struct device
 	up_write(&zram->init_lock);
 
 	return len;
+
+out:
+	bdput(bdev);
+	return ret;
 }
 
 static ssize_t num_reads_show(struct device *dev,


