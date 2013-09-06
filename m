Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab3IFNsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 09:48:30 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:45779 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3IFNs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 09:48:29 -0400
Date: Fri, 6 Sep 2013 16:47:06 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Minchan Kim <minchan@kernel.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: zram: minimize `slot_free_lock' usage
Message-ID: <20130906134706.GA2238@swordfish.minsk.epam.com>
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

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/staging/zram/zram_drv.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 91d94b5..17386e2 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -532,14 +532,15 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
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

