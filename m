Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab3GXOGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:06:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45698 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189Ab3GXOGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:32 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Minchan Kim" <minchan@kernel.org>, "Jiang Liu" <jiang.liu@huawei.com>,
        "Jiang Liu" <liuj97@gmail.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.249269575@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [12/85] zram: protect sysfs handler from invalid memory access
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/zram/zram_sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -186,10 +186,12 @@ static ssize_t mem_used_total_show(struc
 	u64 val = 0;
 	struct zram *zram = dev_to_zram(dev);
 
+	down_read(&zram->init_lock);
 	if (zram->init_done) {
 		val = xv_get_total_size_bytes(zram->mem_pool) +
 			((u64)(zram->stats.pages_expand) << PAGE_SHIFT);
 	}
+	up_read(&zram->init_lock);
 
 	return sprintf(buf, "%llu\n", val);
 }

