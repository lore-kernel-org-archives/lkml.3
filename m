Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbaGXBBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 21:01:34 -0400
Received: from mailout.micron.com ([137.201.242.129]:44497 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbaGXBBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 21:01:32 -0400
From: bpqw <bpqw@micron.com>
To: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>
CC: "b32955@freescale.com" <b32955@freescale.com>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "ron@debian.org" <ron@debian.org>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Subject: [PATCH 1/1] mtd:nand:fix nand_lock/unlock() function
Thread-Topic: Subject: [PATCH 1/1] mtd:nand:fix nand_lock/unlock() function
Thread-Index: Ac+m2phuXcgmHPdERquTjlHUZ43DKQ==
Date: Thu, 24 Jul 2014 01:00:01 +0000
Message-ID: <CB9F11E856CFD04BB18EC1C68F2598931B1112@NTXXIAMBX01.xacn.micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20836.003
X-TM-AS-Result: No--2.246200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do nand reset before write protect check
If we want to check the WP# low or high through STATUS READ and check bit 7,
we must reset the device, other operation (eg.erase/program a locked block) can
also clear the bit 7 of status register.

Signed-off-by: White Ding <bpqw@micron.com>
---
 drivers/mtd/nand/nand_base.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 41167e9..22dd3aa 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -965,6 +965,15 @@ int nand_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 
 	chip->select_chip(mtd, chipnr);
 
+	/*
+	 * Reset the chip.
+	 * If we want to check the WP through READ STATUS and check the bit 7
+	 * we must reset the chip
+	 * some operation can also clear the bit 7 of status register
+	 * eg. erase/program a locked block
+	 */
+	chip->cmdfunc(mtd, NAND_CMD_RESET, -1, -1);
+
 	/* Check, if it is write protected */
 	if (nand_check_wp(mtd)) {
 		pr_debug("%s: device is write protected!\n",
@@ -1015,6 +1024,15 @@ int nand_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 
 	chip->select_chip(mtd, chipnr);
 
+	/*
+	 * Reset the chip.
+	 * If we want to check the WP through READ STATUS and check the bit 7
+	 * we must reset the chip
+	 * some operation can also clear the bit 7 of status register
+	 * eg. erase/program a locked block
+	 */
+	chip->cmdfunc(mtd, NAND_CMD_RESET, -1, -1);
+
 	/* Check, if it is write protected */
 	if (nand_check_wp(mtd)) {
 		pr_debug("%s: device is write protected!\n",
-- 
1.7.9.5

Br
White Ding 
____________________________
EBU APAC Application Engineering
Tel:86-21-38997078
Mobile: 86-13761729112
Address: No 601 Fasai Rd, Waigaoqiao Free Trade Zone Pudong, Shanghai, China

