Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaESCmW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 22:42:22 -0400
Received: from mailout.micron.com ([137.201.242.129]:36599 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaESCmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 22:42:21 -0400
From: =?iso-2022-jp?B?QmVhbiBIdW8gGyRCcDlJTElMGyhCIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
CC: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Christian Riesch <christian.riesch@omicron.at>,
        Kees Cook <keescook@chromium.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] mtd:nor:timeout:fix do_write_buffer() timeout error
Thread-Topic: [PATCH 1/1] mtd:nor:timeout:fix do_write_buffer() timeout error
Thread-Index: Ac9zC9WvVS1si7dTS9qWoVuHEN6sWA==
Date: Mon, 19 May 2014 02:41:29 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315D03AC@NTXXIAMBX02.xacn.micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20702.004
X-TM-AS-Result: No--7.654600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of the buffer program has been increased from 256 to 512 ,
2ms maximum timeout can not adapt to all the different vendor's norflash,
There maximum timeout information in the CFI area,so the best way is to
choose the result calculated according to timeout field of struct cfi_ident
that probed from norflash's CFI aera.This is also a standard defined by CFI.

Without this change, if the size of buffer program is 512 or bigger than 256,
due to timeout is the shorter than that the chip required,do_write_buffer
sometimes fails.

Tested with Micron JS28F512M29EWx and Micron MT28EW512ABA flash devices.

Signed-off-by: bean huo <beanhuo@micron.com>
---
 drivers/mtd/chips/cfi_cmdset_0002.c |   46 ++++++++++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index e21fde9..2a08f9f 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -628,10 +628,42 @@ struct mtd_info *cfi_cmdset_0002(struct map_info *map, int primary)
 		cfi->chips[i].word_write_time = 1<<cfi->cfiq->WordWriteTimeoutTyp;
 		cfi->chips[i].buffer_write_time = 1<<cfi->cfiq->BufWriteTimeoutTyp;
 		cfi->chips[i].erase_time = 1<<cfi->cfiq->BlockEraseTimeoutTyp;
+		/*
+		 * We first calculate the timeout max according to timeout
+		 * field of struct cfi_ident that probed from chip's CFI
+		 * aera,If haven't probed this information,we will specify
+		 * a default value,and the time unit is us.
+		 */
+		if (cfi->cfiq->WordWriteTimeoutTyp &&
+			cfi->cfiq->WordWriteTimeoutMax){
+			cfi->chips[i].word_write_time_max =
+				1<<(cfi->cfiq->WordWriteTimeoutTyp +
+					cfi->cfiq->WordWriteTimeoutMax);
+			} else {
+		/* specify maximum timeout for byte/word program 2000us */
+				cfi->chips[i].word_write_time_max = 2000;
+				}
+		if (cfi->cfiq->BufWriteTimeoutTyp &&
+			cfi->cfiq->BufWriteTimeoutMax){
+			cfi->chips[i].buffer_write_time_max =
+				1<<(cfi->cfiq->BufWriteTimeoutTyp +
+					cfi->cfiq->BufWriteTimeoutMax);
+			} else {
+		/* specify maximum timeout for buffer program 2000us */
+				cfi->chips[i].buffer_write_time_max = 2000;
+				}
+		if (cfi->cfiq->BlockEraseTimeoutTyp &&
+			cfi->cfiq->BlockEraseTimeoutMax){
+			cfi->chips[i].erase_time_max =
+				1<<(cfi->cfiq->BlockEraseTimeoutTyp +
+					cfi->cfiq->BlockEraseTimeoutMax);
+			} else {
+	/* specify maximum timeout per individual block erase 3000000us */
+				cfi->chips[i].erase_time_max = 3000000;
+				}
 		cfi->chips[i].ref_point_counter = 0;
 		init_waitqueue_head(&(cfi->chips[i].wq));
 	}
-
 	map->fldrv = &cfi_amdstd_chipdrv;
 
 	return cfi_amdstd_setup(mtd);
@@ -1462,8 +1494,16 @@ static int __xipram do_write_buffer(struct map_info *map, struct flchip *chip,
 {
 	struct cfi_private *cfi = map->fldrv_priv;
 	unsigned long timeo = jiffies + HZ;
-	/* see comments in do_write_oneword() regarding uWriteTimeo. */
-	unsigned long uWriteTimeout = ( HZ / 1000 ) + 1;
+	/* The size of the buffer program has been increased from 256 to 512,
+	 * 2ms maximum timeout can not adapt to all the different vendor's
+	 * norflash.There maximum timeout information in the CFI area,so the
+	 * best way is to choose the result calculated according to timeout
+	 * field of struct cfi_ident that probed from norflash's CFI aera,see
+	 * comments in cfi_cmdset_0002().The time unit of uWriteTimeout is ms.
+	 */
+	unsigned long uWriteTimeout = (chip->buffer_write_time_max % 1000) ?
+			(chip->buffer_write_time_max / 1000 + 1) :
+			(chip->buffer_write_time_max / 1000);
 	int ret = -EIO;
 	unsigned long cmd_adr;
 	int z, words;
-- 
1.7.9.5
