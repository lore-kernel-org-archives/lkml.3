Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab3IJXOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 19:14:19 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:49622 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3IJXOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 19:14:18 -0400
Date: Wed, 11 Sep 2013 02:12:50 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        driverdev-devel@linuxdriverproject.org,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: zram: fix handle_pending_slot_free() and
 zram_reset_device() race
Message-ID: <20130910231250.GA2450@swordfish>
References: <20130906151255.GE2238@swordfish.minsk.epam.com>
 <20130909123329.GZ19256@mwanda>
 <20130909124942.GA2221@swordfish.minsk.epam.com>
 <20130909132124.GY6329@mwanda>
 <522DD125.1030607@redhat.com>
 <522DF2DF.5060407@redhat.com>
 <20130910143416.GC2270@swordfish>
 <20130910145802.GD19256@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910145802.GD19256@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter noted that handle_pending_slot_free() is racy with
zram_reset_device(). Take write init_lock in zram_slot_free(), thus
preventing any concurrent zram_slot_free(), zram_bvec_rw() or
zram_reset_device(). This also allows to safely check zram->init_done
in handle_pending_slot_free().

Initial intention was to minimze number of handle_pending_slot_free()
call from zram_bvec_rw(), which were slowing down READ requests due to
slot_free_lock spin lock. Jerome Marchand suggested to remove
handle_pending_slot_free() from zram_bvec_rw().

Link: https://lkml.org/lkml/2013/9/9/172
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/staging/zram/zram_drv.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 91d94b5..7a2d4de 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -521,7 +521,8 @@ static void handle_pending_slot_free(struct zram *zram)
 	while (zram->slot_free_rq) {
 		free_rq = zram->slot_free_rq;
 		zram->slot_free_rq = free_rq->next;
-		zram_free_page(zram, free_rq->index);
+		if (zram->init_done)
+			zram_free_page(zram, free_rq->index);
 		kfree(free_rq);
 	}
 	spin_unlock(&zram->slot_free_lock);
@@ -534,16 +535,13 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	if (rw == READ) {
 		down_read(&zram->lock);
-		handle_pending_slot_free(zram);
 		ret = zram_bvec_read(zram, bvec, index, offset, bio);
 		up_read(&zram->lock);
 	} else {
 		down_write(&zram->lock);
-		handle_pending_slot_free(zram);
 		ret = zram_bvec_write(zram, bvec, index, offset);
 		up_write(&zram->lock);
 	}
-
 	return ret;
 }
 
@@ -750,12 +748,11 @@ error:
 
 static void zram_slot_free(struct work_struct *work)
 {
-	struct zram *zram;
+	struct zram *zram = container_of(work, struct zram, free_work);
 
-	zram = container_of(work, struct zram, free_work);
-	down_write(&zram->lock);
+	down_write(&zram->init_lock);
 	handle_pending_slot_free(zram);
-	up_write(&zram->lock);
+	up_write(&zram->init_lock);
 }
 
 static void add_slot_free(struct zram *zram, struct zram_slot_free *free_rq)

