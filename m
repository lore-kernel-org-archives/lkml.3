Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab3IKFeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:34:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab3IKE5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:19 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=9Yo9jUtMiWsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=RjQVcNDingMA:10 a=pGLkceISAAAA:8 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=MSl-tDqOz04A:10 a=hPjdaMEvmhQA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042916.484871625@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [145/251] zram: avoid invalid memory access in zram_exit()
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0145-zram-avoid-invalid-memory-access-in-zram_exit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jiang Liu <liuj97@gmail.com>

[ Upstream commit 6030ea9b35971a4200062f010341ab832e878ac9 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/staging/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 6edefde..38a1b44 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -771,9 +771,11 @@ static void __exit zram_exit(void)
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
1.7.10.4


