Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3FFQLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:11:19 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:64619 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab3FFQLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:11:15 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v3 06/10] zram: protect sysfs handler from invalid memory access
Date: Fri,  7 Jun 2013 00:07:27 +0800
Message-Id: <1370534851-26056-7-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370534851-26056-1-git-send-email-jiang.liu@huawei.com>
References: <1370534851-26056-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use zram->init_lock to protect access to zram->meta, otherwise it
may cause invalid memory access if zram->meta has been freed by
zram_reset_device().

This issue may be triggered by:
Thread 1:
while true; do cat mem_used_total; done
Thread 2:
while true; do echo 8M > disksize; echo 1 > reset; done

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/staging/zram/zram_sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index e6a929d..dc76a3d 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -188,8 +188,10 @@ static ssize_t mem_used_total_show(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 	struct zram_meta *meta = zram->meta;
 
+	down_read(&zram->init_lock);
 	if (zram->init_done)
 		val = zs_get_total_size_bytes(meta->mem_pool);
+	up_read(&zram->init_lock);
 
 	return sprintf(buf, "%llu\n", val);
 }
-- 
1.8.1.2

