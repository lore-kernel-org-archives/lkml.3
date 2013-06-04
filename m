Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab3FDQJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:09:01 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:59930 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab3FDQI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:08:58 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/10] zram: protect sysfs handler from invalid memory access
Date: Wed,  5 Jun 2013 00:06:06 +0800
Message-Id: <1370361968-8764-8-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
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
Cc: stable@vger.kernel.org
---
 drivers/staging/zram/zram_sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index 8cb7822..e239d94 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -179,8 +179,10 @@ static ssize_t mem_used_total_show(struct device *dev,
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

