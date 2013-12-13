Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab3LMFpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 00:45:19 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:64698 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab3LMFpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 00:45:17 -0500
Date: Fri, 13 Dec 2013 11:15:08 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: josh@joshtriplett.org
Subject: [PATCH 1/2] drivers: mtd: Mark functions as static and remove unused
 function in lpddr_cmds.c
Message-ID: <d0512c2bc35b27af33ad79d74d93ecc0f2b4e92c.1386912859.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the functions do_write_buffer() and do_erase_oneblock()
as static because because they are not used outside this file. It also
removes the unused function word_program() in lpddr/lpddr_cmds.c.

Thus, it also removes the following warnings in lpddr/lpddr_cmds.c:
drivers/mtd/lpddr/lpddr_cmds.c:391:5: warning: no previous prototype for ‘do_write_buffer’ [-Wmissing-prototypes]
drivers/mtd/lpddr/lpddr_cmds.c:472:5: warning: no previous prototype for ‘do_erase_oneblock’ [-Wmissing-prototypes]
drivers/mtd/lpddr/lpddr_cmds.c:751:5: warning: no previous prototype for ‘word_program’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/mtd/lpddr/lpddr_cmds.c |   32 ++------------------------------
 1 file changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/mtd/lpddr/lpddr_cmds.c b/drivers/mtd/lpddr/lpddr_cmds.c
index 2ef19aa..d38b646 100644
--- a/drivers/mtd/lpddr/lpddr_cmds.c
+++ b/drivers/mtd/lpddr/lpddr_cmds.c
@@ -388,7 +388,7 @@ static void put_chip(struct map_info *map, struct flchip *chip)
 	wake_up(&chip->wq);
 }
 
-int do_write_buffer(struct map_info *map, struct flchip *chip,
+static int do_write_buffer(struct map_info *map, struct flchip *chip,
 			unsigned long adr, const struct kvec **pvec,
 			unsigned long *pvec_seek, int len)
 {
@@ -469,7 +469,7 @@ int do_write_buffer(struct map_info *map, struct flchip *chip,
 	return ret;
 }
 
-int do_erase_oneblock(struct mtd_info *mtd, loff_t adr)
+static int do_erase_oneblock(struct mtd_info *mtd, loff_t adr)
 {
 	struct map_info *map = mtd->priv;
 	struct lpddr_private *lpddr = map->fldrv_priv;
@@ -748,34 +748,6 @@ static int lpddr_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 	return do_xxlock(mtd, ofs, len, DO_XXLOCK_UNLOCK);
 }
 
-int word_program(struct map_info *map, loff_t adr, uint32_t curval)
-{
-    int ret;
-	struct lpddr_private *lpddr = map->fldrv_priv;
-	int chipnum = adr >> lpddr->chipshift;
-	struct flchip *chip = &lpddr->chips[chipnum];
-
-	mutex_lock(&chip->mutex);
-	ret = get_chip(map, chip, FL_WRITING);
-	if (ret) {
-		mutex_unlock(&chip->mutex);
-		return ret;
-	}
-
-	send_pfow_command(map, LPDDR_WORD_PROGRAM, adr, 0x00, (map_word *)&curval);
-
-	ret = wait_for_ready(map, chip, (1<<lpddr->qinfo->SingleWordProgTime));
-	if (ret)	{
-		printk(KERN_WARNING"%s word_program error at: %llx; val: %x\n",
-			map->name, adr, curval);
-		goto out;
-	}
-
-out:	put_chip(map, chip);
-	mutex_unlock(&chip->mutex);
-	return ret;
-}
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alexey Korolev <akorolev@infradead.org>");
 MODULE_DESCRIPTION("MTD driver for LPDDR flash chips");
-- 
1.7.9.5

