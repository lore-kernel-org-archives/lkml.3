Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3IFPOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:14:15 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:50147 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3IFPOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:14:14 -0400
Date: Fri, 6 Sep 2013 18:12:55 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: zram: minimize `slot_free_lock' usage (v2)
Message-ID: <20130906151255.GE2238@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling handle_pending_slot_free() for every RW operation may
cause unneccessary slot_free_lock locking, because most likely
process will see NULL slot_free_rq. handle_pending_slot_free()
only when current detects that slot_free_rq is not NULL.

v2: protect handle_pending_slot_free() with zram rw_lock.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/staging/zram/zram_drv.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 91d94b5..5bfbe0e 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -517,6 +517,7 @@ static void handle_pending_slot_free(struct zram *zram)
 {
 	struct zram_slot_free *free_rq;
 
+	down_write(&zram->lock);
 	spin_lock(&zram->slot_free_lock);
 	while (zram->slot_free_rq) {
 		free_rq = zram->slot_free_rq;
@@ -525,6 +526,7 @@ static void handle_pending_slot_free(struct zram *zram)
 		kfree(free_rq);
 	}
 	spin_unlock(&zram->slot_free_lock);
+	up_write(&zram->lock);
 }
 
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
@@ -532,14 +534,15 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 {
 	int ret;
 
+	if (zram->slot_free_rq)
+		handle_pending_slot_free(zram);
+
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

