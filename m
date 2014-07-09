Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaGIAn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 20:43:29 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:53701 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaGIAn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 20:43:27 -0400
MIME-Version: 1.0
Date: Wed, 9 Jul 2014 08:43:27 +0800
Message-ID: <CAB4L+8j63tS88k4hCuOc6fmH8NzjfhNAq2w44QVsyQ+v5O+Ukw@mail.gmail.com>
Subject: [PATCH v3] mtd:nor:timeout:fix do_write_buffer() timeout error
From: Bean Huo <jackyard88@gmail.com>
To: dwmw2@infradead.org, computersforpeace@gmail.com,
        paul.gortmaker@windriver.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        jg1.han@samsung.com, artem.bityutskiy@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of the buffer program has been increased from 256 to 512 ,
2ms maximum timeout for do_write_buffer can not adapt to all the
different vendor's norflash.There maximum timeout information in the
CFI area,so the best way is to choose the result calculated according
to timeout field of struct cfi_ident that probed from norflash's CFI
aera.This is also a standard defined by CFI.

Without this change, if the size of buffer program is 512 or bigger
than 256, due to timeout is the shorter than that the chip
required,do_write_buffer sometimes fails.

Tested with Micron JS28F512M29EWx and Micron MT28EW512ABA flash devices.

Signed-off-by: bean huo <jackyard88@gmail.com>
---
changes
     v1->v2:Deleted unused parameters in this patch
(word_write_time_max and erase_time_max).
Using usecs_to_jiffies instead of msecs_to_jiffies for convert timeout
value into jiffies.
      v2->v3:Removed unnecessary messages form comments and deleted
trailing whitespace.

 drivers/mtd/chips/cfi_cmdset_0002.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c
b/drivers/mtd/chips/cfi_cmdset_0002.c
index e21fde9..f7098d6 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -628,10 +628,24 @@ struct mtd_info *cfi_cmdset_0002(struct map_info
*map, int primary)
            cfi->chips[i].word_write_time = 1<<cfi->cfiq->WordWriteTimeoutTyp;
            cfi->chips[i].buffer_write_time = 1<<cfi->cfiq->BufWriteTimeoutTyp;
            cfi->chips[i].erase_time = 1<<cfi->cfiq->BlockEraseTimeoutTyp;
+           /*
+           * We first calculate the timeout max according to timeout
+           * field of struct cfi_ident that probed from chip's CFI
+           * aera,If haven't probed this information,we will specify
+           * a default value,and the time unit is us.
+           */
+           if (cfi->cfiq->BufWriteTimeoutTyp &&
+                 cfi->cfiq->BufWriteTimeoutMax){
+                 cfi->chips[i].buffer_write_time_max =
+                       1<<(cfi->cfiq->BufWriteTimeoutTyp +
+                             cfi->cfiq->BufWriteTimeoutMax);
+                 } else {
+                 /* specify maximum timeout for buffer program 2000us */
+                       cfi->chips[i].buffer_write_time_max = 2000;
+                       }
            cfi->chips[i].ref_point_counter = 0;
            init_waitqueue_head(&(cfi->chips[i].wq));
      }
-
      map->fldrv = &cfi_amdstd_chipdrv;

      return cfi_amdstd_setup(mtd);
@@ -1462,8 +1476,15 @@ static int __xipram do_write_buffer(struct
map_info *map, struct flchip *chip,  {
      struct cfi_private *cfi = map->fldrv_priv;
      unsigned long timeo = jiffies + HZ;
-     /* see comments in do_write_oneword() regarding uWriteTimeo. */
-     unsigned long uWriteTimeout = ( HZ / 1000 ) + 1;
+     /* There maximum timeout information in the CFI area,so the
+     * best way is to choose the result calculated according to
+     * timeout field of struct cfi_ident that probed from
+     * norflash's CFI aera,see comments in cfi_cmdset_0002().
+     * uWriteTimeout is used for timeout step,it must be concerted
+     * into jiffies.
+     */
+     unsigned long uWriteTimeout =
+                       usecs_to_jiffies(chip->buffer_write_time_max);
      int ret = -EIO;
      unsigned long cmd_adr;
      int z, words;
--
1.7.9.5
