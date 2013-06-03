Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab3FCPo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:44:57 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:34436 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3FCPov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:44:51 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 2/8] zram: avoid invalid memory access in zram_exit()
Date: Mon,  3 Jun 2013 23:42:14 +0800
Message-Id: <1370274140-26420-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
References: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory for zram->disk object may have already been freed after returning
from destroy_device(zram), then it's unsafe for zram_reset_device(zram)
to access zram->disk again.

Fix it by holding an extra reference to zram->disk before calling
destroy_device(zram).

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/staging/zram/zram_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index e34e3fe..ee6b67d 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -727,8 +727,10 @@ static void __exit zram_exit(void)
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

