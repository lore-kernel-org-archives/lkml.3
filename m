Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaAMLT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:19:26 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59546 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaAMLTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:19:20 -0500
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>, stable <stable@vger.kernel.org>
Subject: [PATCH 1/7] zram: fix race between reset and flushing pending work
Date: Mon, 13 Jan 2014 20:18:56 +0900
Message-Id: <1389611942-15544-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1389611942-15544-1-git-send-email-minchan@kernel.org>
References: <1389611942-15544-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan and Sergey reported that there is a racy between reset and
flushing of pending work so that it could make oops by freeing
zram->meta in reset while zram_slot_free can access zram->meta
if new request is adding during the race window.

This patch moves flush after taking init_lock so it prevents
new request so that it closes the race.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index f9711c5..213dfc1 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -553,14 +553,14 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 	size_t index;
 	struct zram_meta *meta;
 
-	flush_work(&zram->free_work);
-
 	down_write(&zram->init_lock);
 	if (!zram->init_done) {
 		up_write(&zram->init_lock);
 		return;
 	}
 
+	flush_work(&zram->free_work);
+
 	meta = zram->meta;
 	zram->init_done = 0;
 
-- 
1.8.4.3

