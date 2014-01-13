Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbaAMLVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:21:33 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36911 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaAMLTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:19:23 -0500
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 2/7] zram: delay pending free request in read path
Date: Mon, 13 Jan 2014 20:18:57 +0900
Message-Id: <1389611942-15544-3-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1389611942-15544-1-git-send-email-minchan@kernel.org>
References: <1389611942-15544-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Senozhatsky reporetd we don't need to handle pending free
request every I/O so that this patch removes it in read path while
we remain it in write path.

Let's consider below example.

Swap subsystem ask to zram "A" block free by swap_slot_free_notify
but zram had been pended it without real freeing.
Swap subsystem allocates "A" block for new data but request pended
for a long time just handled and zram blindly free new data on
the "A" block. :(

That's why we couldn't remove handle pending free request right before
zram-write.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 213dfc1..d87c7e9 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -535,7 +535,6 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	if (rw == READ) {
 		down_read(&zram->lock);
-		handle_pending_slot_free(zram);
 		ret = zram_bvec_read(zram, bvec, index, offset, bio);
 		up_read(&zram->lock);
 	} else {
-- 
1.8.4.3

