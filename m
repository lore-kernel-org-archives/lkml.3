Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaF3H5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 03:57:19 -0400
Received: from mailout.micron.com ([137.201.242.129]:9191 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaF3H5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 03:57:18 -0400
From: =?iso-2022-jp?B?QmVhbiBIdW8gGyRCcDlJTElMGyhCIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "b32955@freescale.com" <b32955@freescale.com>
Subject: [PATCH v3] mtd:nor:timeout:fix do_write_buffer() timeout error
Thread-Topic: [PATCH v3] mtd:nor:timeout:fix do_write_buffer() timeout error
Thread-Index: Ac+UONEVkJznG3ZoSA6Lf6Wf2Z1wig==
Date: Mon, 30 Jun 2014 07:56:37 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315D75AB@NTXXIAMBX02.xacn.micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20788.005
X-TM-AS-Result: No--8.707200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of the buffer program has been increased from 256 to 512 , 2ms maximum timeout for do_write_buffer can not adapt to all the different vendor's norflash.There maximum timeout information in the CFI area,so the best way is to choose the result calculated according to timeout field of struct cfi_ident that probed from norflash's CFI aera.This is also a standard defined by CFI.

Without this change, if the size of buffer program is 512 or bigger than 256, due to timeout is the shorter than that the chip required,do_write_buffer sometimes fails.

Tested with Micron JS28F512M29EWx and Micron MT28EW512ABA flash devices.

Signed-off-by: bean huo <beanhuo@micron.com>
---
changes 
	v1->v2:Deleted unused parameters in this patch (word_write_time_max and erase_time_max).
Using usecs_to_jiffies instead of msecs_to_jiffies for convert timeout value into jiffies.
	v2->v3:Removed unnecessary messages form comments and deleted trailing whitespace.

 drivers/mtd/chips/cfi_cmdset_0002.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index e21fde9..f7098d6 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -628,10 +628,24 @@ struct mtd_info *cfi_cmdset_0002(struct map_info *map, int primary)
 		cfi->chips[i].word_write_time = 1<<cfi->cfiq->WordWriteTimeoutTyp;
 		cfi->chips[i].buffer_write_time = 1<<cfi->cfiq->BufWriteTimeoutTyp;
 		cfi->chips[i].erase_time = 1<<cfi->cfiq->BlockEraseTimeoutTyp;
+		/*
+		 * We first calculate the timeout max according to timeout
+		 * field of struct cfi_ident that probed from chip's CFI
+		 * aera,If haven't probed this information,we will specify
+		 * a default value,and the time unit is us.
+		 */
+		if (cfi->cfiq->BufWriteTimeoutTyp &&
+			cfi->cfiq->BufWriteTimeoutMax){
+			cfi->chips[i].buffer_write_time_max =
+				1<<(cfi->cfiq->BufWriteTimeoutTyp +
+					cfi->cfiq->BufWriteTimeoutMax);
+			} else {
+			/* specify maximum timeout for buffer program 2000us */
+				cfi->chips[i].buffer_write_time_max = 2000;
+				}
 		cfi->chips[i].ref_point_counter = 0;
 		init_waitqueue_head(&(cfi->chips[i].wq));
 	}
-
 	map->fldrv = &cfi_amdstd_chipdrv;
 
 	return cfi_amdstd_setup(mtd);
@@ -1462,8 +1476,15 @@ static int __xipram do_write_buffer(struct map_info *map, struct flchip *chip,  {
 	struct cfi_private *cfi = map->fldrv_priv;
 	unsigned long timeo = jiffies + HZ;
-	/* see comments in do_write_oneword() regarding uWriteTimeo. */
-	unsigned long uWriteTimeout = ( HZ / 1000 ) + 1;
+	/* There maximum timeout information in the CFI area,so the
+	 * best way is to choose the result calculated according to
+	 * timeout field of struct cfi_ident that probed from
+	 * norflash's CFI aera,see comments in cfi_cmdset_0002().
+	 * uWriteTimeout is used for timeout step,it must be concerted
+	 * into jiffies.
+	 */
+	unsigned long uWriteTimeout =
+				usecs_to_jiffies(chip->buffer_write_time_max);
 	int ret = -EIO;
 	unsigned long cmd_adr;
 	int z, words;
--
1.7.9.5
