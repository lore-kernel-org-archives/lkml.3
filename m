Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab3IKFgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:36:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3IKE5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:18 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=7LSKei67pZYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=dgW8Ds1fvp0A:10 a=pGLkceISAAAA:8 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=MSl-tDqOz04A:10 a=hPjdaMEvmhQA:10 a=LI9Vle30uBYA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042917.296227051@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiang Liu <jiang.liu@huawei.com>, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [150/251] zram: protect sysfs handler from invalid memory access
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0150-zram-protect-sysfs-handler-from-invalid-memory-acces.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jiang Liu <liuj97@gmail.com>

[ Upstream commit 5863e10b441e7ea4b492f930f1be180a97d026f3 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/staging/zram/zram_sysfs.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index edb0ed4..5e07628 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -186,8 +186,10 @@ static ssize_t mem_used_total_show(struct device *dev,
 	u64 val = 0;
 	struct zram *zram = dev_to_zram(dev);
 
+	down_read(&zram->init_lock);
 	if (zram->init_done)
 		val = zs_get_total_size_bytes(zram->mem_pool);
+	up_read(&zram->init_lock);
 
 	return sprintf(buf, "%llu\n", val);
 }
-- 
1.7.10.4


