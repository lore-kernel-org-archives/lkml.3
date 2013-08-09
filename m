Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967747Ab3HICLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:11:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967654Ab3HIB7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>
Subject: [ 060/102] zram: avoid invalid memory access in zram_exit()
Date: Thu,  8 Aug 2013 18:57:36 -0700
Message-Id: <20130809015024.373031068@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

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


