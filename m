Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab3I3KOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:14:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43864 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab3I3KNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 103/104] Revert "zram: use zram->lock to protect zram_free_page() in swap free notify path"
Date: Mon, 30 Sep 2013 11:11:20 +0100
Message-Id: <1380535881-9239-104-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques <luis.henriques@canonical.com>

This reverts commit 9e443904906ca2b5b3ae71f34ac4a4fa6905623e, which
was commit 57ab048532c0d975538cebd4456491b5c34248f4 upstream.

This commit was identified as provoking system lockups when under high
memory pressure, as noted in the following bug report:

BugLink: https://bugs.launchpad.net/bugs/1215513

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/zram/zram_drv.c | 2 --
 drivers/staging/zram/zram_drv.h | 5 ++---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 2e88a68..60ffc8c 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -697,9 +697,7 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	struct zram *zram;
 
 	zram = bdev->bd_disk->private_data;
-	down_write(&zram->lock);
 	zram_free_page(zram, index);
-	up_write(&zram->lock);
 	zram_stat64_inc(zram, &zram->stats.notify_free);
 }
 
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index 1047e82..fbe8ac9 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -107,9 +107,8 @@ struct zram {
 	void *compress_buffer;
 	struct table *table;
 	spinlock_t stat64_lock;	/* protect 64-bit stats */
-	struct rw_semaphore lock; /* protect compression buffers, table,
-				   * 32bit stat counters against concurrent
-				   * notifications, reads and writes */
+	struct rw_semaphore lock; /* protect compression buffers and table
+				   * against concurrent read and writes */
 	struct request_queue *queue;
 	struct gendisk *disk;
 	int init_done;
-- 
1.8.3.2

