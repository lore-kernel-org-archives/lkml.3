Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab3GQWss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:48:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56191 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757469Ab3GQWso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:48:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 009/145] zram: avoid invalid memory access in zram_exit()
Date: Wed, 17 Jul 2013 15:45:41 -0700
Message-Id: <1374101277-7915-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <liuj97@gmail.com>

commit 6030ea9b35971a4200062f010341ab832e878ac9 upstream.

Memory for zram->disk object may have already been freed after returning
from destroy_device(zram), then it's unsafe for zram_reset_device(zram)
to access zram->disk again.

We can't solve this bug by flipping the order of destroy_device(zram)
and zram_reset_device(zram), that will cause deadlock issues to the
zram sysfs handler.

So fix it by holding an extra reference to zram->disk before calling
destroy_device(zram).

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.8: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/zram/zram_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 071e058..c9c1e0e 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -764,9 +764,11 @@ static void __exit zram_exit(void)
 	for (i = 0; i < num_devices; i++) {
 		zram = &zram_devices[i];
 
+		get_disk(zram->disk);
 		destroy_device(zram);
 		if (zram->init_done)
 			zram_reset_device(zram);
+		put_disk(zram->disk);
 	}
 
 	unregister_blkdev(zram_major, "zram");
-- 
1.8.1.2

