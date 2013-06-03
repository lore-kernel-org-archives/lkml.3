Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996Ab3FCPpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:45:19 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:40086 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758899Ab3FCPpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:45:15 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 8/8] zram: protect sysfs handler from invalid memory access
Date: Mon,  3 Jun 2013 23:42:20 +0800
Message-Id: <1370274140-26420-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
References: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use zram->init_lock to protect access to zram->meta, otherwise it
may cause invalid memory access if zram->meta has been freed by
__zram_reset_device().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
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

