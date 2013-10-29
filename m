Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab3J2XNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 19:13:07 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:55716 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3J2XNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 19:13:05 -0400
From: Rashika Kheria <rashika.kheria@gmail.com>
To: opw-kernel@googlegroups.com, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v7 2/3] Staging: zram: Fix decrement of variable by calling bdput()
Date: Wed, 30 Oct 2013 04:42:56 +0530
Message-Id: <c7dc0036457aa94707bdc17b1f475c88f35cdb07.1383087326.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20131019110539.GA25167@gmail.com>
References: <20131019110539.GA25167@gmail.com>
In-Reply-To: <cc16130b4e23207971139eff313a4ec71f51c187.1383087326.git.rashika.kheria@gmail.com>
References: <cc16130b4e23207971139eff313a4ec71f51c187.1383087326.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Jerome Marchand "The code in reset_store get the block device
(bdget_disk()) but it does not put it (bdput()) when it's done using it.
The usage count is therefor incremented but never decremented."

Hence, this patch introduces a call to bdput() to decrement the variable after usage.

Cc: stable@vger.kernel.org
Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---

This revision fixes the following issues of the previous revision-
Handle more error cases

 drivers/staging/zram/zram_drv.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index d640a8f..592e760 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -664,6 +664,9 @@ static ssize_t reset_store(struct device *dev,
 
 	/* Make sure all pending I/O is finished */
 	fsync_bdev(bdev);
+	bdput(bdev);
+	bdput(bdev->bd_holders);
+	bdput(do_reset);
 
 	zram_reset_device(zram, true);
 	return len;
-- 
1.7.9.5

