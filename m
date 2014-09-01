Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaIACVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 22:21:44 -0400
Received: from mailout.micron.com ([137.201.242.129]:52831 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaIACVn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 22:21:43 -0400
From: bpqw <bpqw@micron.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
CC: Christian Riesch <christian.riesch@omicron.at>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] mtd: cfi_cmdset_0002:add fixup for Micron M29EW after
 erase operation
Thread-Topic: [PATCH 1/1] mtd: cfi_cmdset_0002:add fixup for Micron M29EW
 after erase operation
Thread-Index: Ac/FirFoX5r9fafZSu+Pmx6RITsSBwAAIQmw
Date: Mon, 1 Sep 2014 02:20:52 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315DB7BE@NTXXIAMBX02.xacn.micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20920.004
X-TM-AS-Result: No--2.219900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For Micron M29EW,20ms delay is needed after erase operation.

Signed-off-by: BeanHuo <bpqw@micron.com>
---
 drivers/mtd/chips/cfi_cmdset_0002.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index 5a4bfe3..9b0de91 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -509,6 +509,16 @@ static void cfi_fixup_m29ew_delay_after_resume(struct cfi_private *cfi)
 		cfi_udelay(500);
 }
 
+static void cfi_fixup_m29ew_delay_after_erase(struct cfi_private *cfi) 
+{
+	/*
+	 * Resolving the Delay After ERASE Issue @low temperature.
+	 * 20ms delay is needed after erase operation.
+	 */
+	if (is_m29ew(cfi))
+		cfi_udelay(20000);
+}
+
 struct mtd_info *cfi_cmdset_0002(struct map_info *map, int primary)  {
 	struct cfi_private *cfi = map->fldrv_priv; @@ -2397,6 +2407,7 @@ static int __xipram do_erase_oneblock(struct map_info *map, struct flchip *chip,
 		ret = -EIO;
 	}
 
+	cfi_fixup_m29ew_delay_after_erase(cfi);
 	chip->state = FL_READY;
 	DISABLE_VPP(map);
 	put_chip(map, chip, adr);
--
1.7.9.5
