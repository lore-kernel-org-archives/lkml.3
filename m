Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030346AbaGPGvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:51:23 -0400
Received: from blu004-omc3s8.hotmail.com ([65.55.116.83]:57358 "EHLO
	BLU004-OMC3S8.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875AbaGPGvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:51:21 -0400
X-TMN: [XWY6EXQdxuTNy4KPbZU8nePBg/q49DcGlgLQ9nLwtB0=]
X-Originating-Email: [beanhuo@outlook.com]
Message-ID: <BLU185-W11C4857F0149224171239EA6F70@phx.gbl>
From: Bean Huo <beanhuo@outlook.com>
To: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>
Subject: [PATCH v4] mtd:nor:timeout:fix do_write_buffer() timeout error
Date: Wed, 16 Jul 2014 06:51:20 +0000
Importance: Normal
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Jul 2014 06:51:20.0904 (UTC) FILETIME=[59E0D480:01CFA0C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6G6pSh8025044

For some Norflashes,the size of the buffer program has been
increased from 256 bytes to 512 bytes,2ms maximum timeout can
not adapt to all the different vendor's norflash.There maximum
timeout information in the CFI area,so the best way is to choose
the result calculated according to timeout field of struct cfi_ident
that probed from norflash's CFI aera.This is also a standard defined
by CFI.If haven't probed this information,or smaller than 2000us,then
specify a defualt value 2000us.
Tested with Micron JS28F512M29EWx and Micron MT28EW512ABA flash devices.
Signed-off-by: bean huo beanhuo@outlook.com
---
changes
 v1->v2:Deleted unused parameters in this patch 
  (word_write_time_max and erase_time_max).Using usecs_to_jiffies
  instead of msecs_to_jiffies for convert timeout value into jiffies.
 v2->v3:Removed unnecessary messages form comments and deleted trailing whitespace.
 V3->v4:If haven't probed timeout information,or smaller than 2000us,specify default
        2000us.
 drivers/mtd/chips/cfi_cmdset_0002.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)
diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index e21fde9..c248a8c 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -628,6 +628,24 @@ struct mtd_info *cfi_cmdset_0002(struct map_info *map, int primary)
   cfi->chips[i].word_write_time = 1<<cfi->cfiq->WordWriteTimeoutTyp;
   cfi->chips[i].buffer_write_time = 1<<cfi->cfiq->BufWriteTimeoutTyp;
   cfi->chips[i].erase_time = 1<<cfi->cfiq->BlockEraseTimeoutTyp;
+  /*
+   * First calculate the timeout max according to timeout
+   * field of struct cfi_ident that probed from chip's CFI
+   * aera.If haven't probed this information,or smaller than
+   * 2000us,we will specify defualt value 2000us,and the time
+   * unit is us.
+   */
+  if (cfi->cfiq->BufWriteTimeoutTyp &&
+   cfi->cfiq->BufWriteTimeoutMax){
+   cfi->chips[i].buffer_write_time_max =
+    1<<(cfi->cfiq->BufWriteTimeoutTyp +
+     cfi->cfiq->BufWriteTimeoutMax);
+   } else {
+    cfi->chips[i].buffer_write_time_max = 0;
+    }
+  cfi->chips[i].buffer_write_time_max =
+   ((cfi->chips[i].buffer_write_time_max>= 2000)
+    ? cfi->chips[i].buffer_write_time_max : 2000);
   cfi->chips[i].ref_point_counter = 0;
   init_waitqueue_head(&(cfi->chips[i].wq));
  }
@@ -1462,8 +1480,14 @@ static int __xipram do_write_buffer(struct map_info *map, struct flchip *chip,
 {
  struct cfi_private *cfi = map->fldrv_priv;
  unsigned long timeo = jiffies + HZ;
- /* see comments in do_write_oneword() regarding uWriteTimeo. */
- unsigned long uWriteTimeout = ( HZ / 1000 ) + 1;
+ /*
+  * Use the result that calculated according to timeout field
+  * of struct cfi_ident that probed from norflash's CFI aera.
+  * See more comments in cfi_cmdset_0002().uWriteTimeout is
+  * used for timeout step,it must be concerted into jiffies.
+  */
+ unsigned long uWriteTimeout =
+    usecs_to_jiffies(chip->buffer_write_time_max);
  int ret = -EIO;
  unsigned long cmd_adr;
  int z, words;
-- 
1.7.9.5 		 	   		  ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
