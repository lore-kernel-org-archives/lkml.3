Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab3FDQIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:08:42 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:36734 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab3FDQIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:08:36 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/10] zram: avoid invalid memory access in zram_exit()
Date: Wed,  5 Jun 2013 00:06:00 +0800
Message-Id: <1370361968-8764-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory for zram->disk object may have already been freed after returning
from destroy_device(zram), then it's unsafe for zram_reset_device(zram)
to access zram->disk again.

We can't solve this bug by flipping the order of destroy_device(zram)
and zram_reset_device(zram), that will cause deadlock issues to the
zram sysfs handler.

So fix it by holding an extra reference to zram->disk before calling
destroy_device(zram).

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: stable@vger.kernel.org
---
 drivers/staging/zram/zram_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 0a07de4..5a2f20b 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -722,8 +722,10 @@ static void __exit zram_exit(void)
 	for (i = 0; i < num_devices; i++) {
 		zram = &zram_devices[i];
 
+		get_disk(zram->disk);
 		destroy_device(zram);
 		zram_reset_device(zram);
+		put_disk(zram->disk);
 	}
 
 	unregister_blkdev(zram_major, "zram");
-- 
1.8.1.2

