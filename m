Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaJYTgk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:36:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54636 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaJYTgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:36:38 -0400
X-AuditID: cbfee61a-f79c06d000004e71-0c-544b6cc3d38a
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Minchan Kim'" <minchan@kernel.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Dan Streetman'" <ddstreet@ieee.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Nitin Gupta'" <ngupta@vflare.org>, "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: [PATCH 1/2] zram: make max_used_pages reset work correctly
Date: Sat, 25 Oct 2014 17:25:11 +0800
Message-id: <000001cff035$c060dc60$41229520$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/wNZMUsP+XGtD6TjOTXCDsoEKUzw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t9jAd3DOd4hBvsf81jMWb+GzeJC224W
	i8u75rBZ3Fvzn9Vi2df37BYbWmaxW6z9/Jjd4smJ/ywOHB47Z91l93g64SCTx6ZVnWwemz5N
	Yvc4MeM3i8fOT5tZPT5vkgtgj+KySUnNySxLLdK3S+DKeL/7J0vBIs6KrS+3szQwXmPvYuTk
	kBAwkfjy/wsjhC0mceHeerYuRi4OIYFFjBL7v+4FKxIS+MMoMWVKIojNJqAtcbd/IyuILSKg
	JrHu4AsWkAZmgQ1MEs8fHmACSQgLOEu03DgI1swioCpx7PQWZhCbV8BOYve5VkYIW1Dix+R7
	QM0cQM3qQPNzQcLMAvISm9e8ZQYJSwCFH/3VhVilJzGj9SUbRIm4xMYjt1gmMArMQjJoFsKg
	WUgGzULSsYCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcFw8k9rBuLLB4hCjAAejEg+v
	Aot3iBBrYllxZe4hRgkOZiUR3vlhQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qtA4UE0hNL
	UrNTUwtSi2CyTBycUg2MyyWV94k22u1aXnuJ+Un3oTvzewIPRLHteFd1ctvqs0VB7/bPz83h
	ZS0rv+LtukG6luPlz73mu5Idi6bzCm4K5vx6vat+eayWer/O0vCOwGLlyWsaytlStzCExsk/
	E1usLtxVcrogPO+52fWsZf9seW7fbq2YEbvwXMf8kAhRIZuU5uutwdeVWIozEg21mIuKEwHV
	yMxYhwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 461a8eee6a ("zram: report maximum used memory") introduces a new
knob "mem_used_max" in zram.stats sysfs, and wants to reset it via write 0
to the sysfs interface.

However, the current code cann't reset it correctly, so let's fix it.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 drivers/block/zram/zram_drv.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 0e63e8a..64dd79a 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -173,7 +173,6 @@ static ssize_t mem_used_max_store(struct device *dev,
 	int err;
 	unsigned long val;
 	struct zram *zram = dev_to_zram(dev);
-	struct zram_meta *meta = zram->meta;
 
 	err = kstrtoul(buf, 10, &val);
 	if (err || val != 0)
@@ -181,8 +180,7 @@ static ssize_t mem_used_max_store(struct device *dev,
 
 	down_read(&zram->init_lock);
 	if (init_done(zram))
-		atomic_long_set(&zram->stats.max_used_pages,
-				zs_get_total_pages(meta->mem_pool));
+		atomic_long_set(&zram->stats.max_used_pages, 0);
 	up_read(&zram->init_lock);
 
 	return len;
-- 
1.7.0.4


