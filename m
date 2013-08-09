Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967720Ab3HICJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:09:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967679Ab3HIB7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>, Minchan Kim <minchan@kernel.org>
Subject: [ 065/102] zram: protect sysfs handler from invalid memory access
Date: Thu,  8 Aug 2013 18:57:41 -0700
Message-Id: <20130809015025.463998309@linuxfoundation.org>
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

commit 5863e10b441e7ea4b492f930f1be180a97d026f3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zram/zram_sysfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -188,8 +188,10 @@ static ssize_t mem_used_total_show(struc
 	struct zram *zram = dev_to_zram(dev);
 	struct zram_meta *meta = zram->meta;
 
+	down_read(&zram->init_lock);
 	if (zram->init_done)
 		val = zs_get_total_size_bytes(meta->mem_pool);
+	up_read(&zram->init_lock);
 
 	return sprintf(buf, "%llu\n", val);
 }


