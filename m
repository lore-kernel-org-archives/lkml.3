Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaGIBF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 21:05:57 -0400
Received: from blu004-omc3s2.hotmail.com ([65.55.116.77]:56111 "EHLO
	BLU004-OMC3S2.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaGIBF4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 21:05:56 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jul 2014 21:05:56 EDT
X-TMN: [TCL8ZEzu1LOnNDdYwJDl7A1hjTqWbXhy323gsM66Aqw=]
X-Originating-Email: [beanhuo@outlook.com]
Message-ID: <BLU185-W2144FD57B7B7D8B8C90EB4A60F0@phx.gbl>
From: bean huo <beanhuo@outlook.com>
To: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>
Subject: [PATCH v3] mtd:nor:timeout:fix do_write_buffer() timeout error
Date: Wed, 9 Jul 2014 01:00:48 +0000
Importance: High
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 09 Jul 2014 01:00:49.0012 (UTC) FILETIME=[39008B40:01CF9B11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of the buffer program has been increased from 256 to 512 , 2ms maximum timeout for do_write_buffer can not adapt to all the different vendor's norflash.There maximum timeout information in the CFI area,so the best way is to choose the result calculated according to timeout field of struct cfi_ident that probed from norflash's CFI aera.This is also a standard defined by CFI.
 
Without this change, if the size of buffer program is 512 or bigger than 256, due to timeout is the shorter than that the chip required,do_write_buffer sometimes fails.
 
Tested with Micron JS28F512M29EWx and Micron MT28EW512ABA flash devices.
 
Signed-off-by: bean huo <beanhuo@outlook.com>
---
changes
     v1->v2:Deleted unused parameters in this patch (word_write_time_max and erase_time_max).
Using usecs_to_jiffies instead of msecs_to_jiffies for convert timeout value into jiffies.
      v2->v3:Removed unnecessary messages form comments and deleted trailing whitespace.
 
 drivers/mtd/chips/cfi_cmdset_0002.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)
 
diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index e21fde9..f7098d6 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -628,10 +628,24 @@ struct mtd_info *cfi_cmdset_0002(struct map_info *map, int primary)
            cfi->chips[i].word_write_time = 1<<cfi->cfiq->WordWriteTimeoutTyp;
            cfi->chips[i].buffer_write_time = 1<<cfi->cfiq->BufWriteTimeoutTyp;
            cfi->chips[i].erase_time = 1<<cfi->cfiq->BlockEraseTimeoutTyp;
+           /*
+           * We first calculate the timeout max according to timeout
+           * field of struct cfi_ident that probed from chip's CFI
+           * aera,If haven't probed this information,we will specify
+           * a default value,and the time unit is us.
+           */
+           if (cfi->cfiq->BufWriteTimeoutTyp &&
+                 cfi->cfiq->BufWriteTimeoutMax){
+                 cfi->chips[i].buffer_write_time_max =
+                       1<<(cfi->cfiq->BufWriteTimeoutTyp +
+                             cfi->cfiq->BufWriteTimeoutMax);
+                 } else {
+                 /* specify maximum timeout for buffer program 2000us */
+                       cfi->chips[i].buffer_write_time_max = 2000;
+                       }
            cfi->chips[i].ref_point_counter = 0;
            init_waitqueue_head(&(cfi->chips[i].wq));
      }
-
      map->fldrv = &cfi_amdstd_chipdrv;
 
      return cfi_amdstd_setup(mtd);
@@ -1462,8 +1476,15 @@ static int __xipram do_write_buffer(struct map_info *map, struct flchip *chip,  {
      struct cfi_private *cfi = map->fldrv_priv;
      unsigned long timeo = jiffies + HZ;
-     /* see comments in do_write_oneword() regarding uWriteTimeo. */
-     unsigned long uWriteTimeout = ( HZ / 1000 ) + 1;
+     /* There maximum timeout information in the CFI area,so the
+     * best way is to choose the result calculated according to
+     * timeout field of struct cfi_ident that probed from
+     * norflash's CFI aera,see comments in cfi_cmdset_0002().
+     * uWriteTimeout is used for timeout step,it must be concerted
+     * into jiffies.
+     */
+     unsigned long uWriteTimeout =
+                       usecs_to_jiffies(chip->buffer_write_time_max);
      int ret = -EIO;
      unsigned long cmd_adr;
      int z, words;
--
1.7.9.5 		 	   		  