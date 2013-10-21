Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3JUJBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:01:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39838 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754459Ab3JUIxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.784377694@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 128/149] Revert "zram: use zram->lock to protect
 zram_free_page() in swap free notify path"
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This reverts commit 9e443904906ca2b5b3ae71f34ac4a4fa6905623e, which
was commit 57ab048532c0d975538cebd4456491b5c34248f4 upstream.

Taking the semaphore here leads to sleeping in atomic context.  This
was fixed in mainline commit a0c516cbfc74 ("zram: don't grab mutex in
zram_slot_free_noity") but that is too difficult to backport.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -709,9 +709,7 @@ static void zram_slot_free_notify(struct
 	struct zram *zram;
 
 	zram = bdev->bd_disk->private_data;
-	down_write(&zram->lock);
 	zram_free_page(zram, index);
-	up_write(&zram->lock);
 	zram_stat64_inc(zram, &zram->stats.notify_free);
 }
 
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

