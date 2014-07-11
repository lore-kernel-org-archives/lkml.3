Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaGKH5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:57:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43413 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbaGKH52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:57:28 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: "Quadros, Roger" <rogerq@ti.com>, "tony@atomide.com" <tony@atomide.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>
CC: "javier@dowhile0.org" <javier@dowhile0.org>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 09/10] mtd: nand: omap: Use GPMC APIs for accessing
 ECC/BCH engine
Thread-Topic: [RFC PATCH 09/10] mtd: nand: omap: Use GPMC APIs for accessing
 ECC/BCH engine
Thread-Index: AQHPm3KjxrC/HTmgWE2Vme4jwcFxhZuag+7Q
Date: Fri, 11 Jul 2014 07:56:54 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EB01E1E@DBDE04.ent.ti.com>
References: <1404909450-11970-1-git-send-email-rogerq@ti.com>
 <1404909450-11970-10-git-send-email-rogerq@ti.com>
In-Reply-To: <1404909450-11970-10-git-send-email-rogerq@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roger,

>From: Quadros, Roger
>Don't access the ECC/BCH engine registers directly as they belong
>to the GPMC controller's register space. Use the relevant
>GPMC APIs instead.
>
>Signed-off-by: Roger Quadros <rogerq@ti.com>
>---
> drivers/mtd/nand/omap2.c | 191 +++++++++++++++++++----------------------------
> 1 file changed, 76 insertions(+), 115 deletions(-)
>
>diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
>index 420ef0b..6b0f953 100644
>--- a/drivers/mtd/nand/omap2.c
>+++ b/drivers/mtd/nand/omap2.c
>@@ -1123,71 +1088,67 @@ static int __maybe_unused omap_calculate_ecc_bch(struct mtd_info
>*mtd,
> 		switch (info->ecc_opt) {
> 		case OMAP_ECC_BCH8_CODE_HW_DETECTION_SW:
> 		case OMAP_ECC_BCH8_CODE_HW:
>-			bch_val1 = readl(gpmc_regs->gpmc_bch_result0[i]);
>-			bch_val2 = readl(gpmc_regs->gpmc_bch_result1[i]);
>-			bch_val3 = readl(gpmc_regs->gpmc_bch_result2[i]);
>-			bch_val4 = readl(gpmc_regs->gpmc_bch_result3[i]);
>-			*ecc_code++ = (bch_val4 & 0xFF);
>-			*ecc_code++ = ((bch_val3 >> 24) & 0xFF);
>-			*ecc_code++ = ((bch_val3 >> 16) & 0xFF);
>-			*ecc_code++ = ((bch_val3 >> 8) & 0xFF);
>-			*ecc_code++ = (bch_val3 & 0xFF);
>-			*ecc_code++ = ((bch_val2 >> 24) & 0xFF);
>-			*ecc_code++ = ((bch_val2 >> 16) & 0xFF);
>-			*ecc_code++ = ((bch_val2 >> 8) & 0xFF);
>-			*ecc_code++ = (bch_val2 & 0xFF);
>-			*ecc_code++ = ((bch_val1 >> 24) & 0xFF);
>-			*ecc_code++ = ((bch_val1 >> 16) & 0xFF);
>-			*ecc_code++ = ((bch_val1 >> 8) & 0xFF);
>-			*ecc_code++ = (bch_val1 & 0xFF);
>+			omap_gpmc_ecc_get_bch_result(4, i, bch_val);
>+			*ecc_code++ = (bch_val[3] & 0xFF);
>+			*ecc_code++ = ((bch_val[2] >> 24) & 0xFF);
>+			*ecc_code++ = ((bch_val[2] >> 16) & 0xFF);
>+			*ecc_code++ = ((bch_val[2] >> 8) & 0xFF);
>+			*ecc_code++ = (bch_val[2] & 0xFF);
>+			*ecc_code++ = ((bch_val[1] >> 24) & 0xFF);
>+			*ecc_code++ = ((bch_val[1] >> 16) & 0xFF);
>+			*ecc_code++ = ((bch_val[1] >> 8) & 0xFF);
>+			*ecc_code++ = (bch_val[1] & 0xFF);
>+			*ecc_code++ = ((bch_val[0] >> 24) & 0xFF);
>+			*ecc_code++ = ((bch_val[0] >> 16) & 0xFF);
>+			*ecc_code++ = ((bch_val[0] >> 8) & 0xFF);
>+			*ecc_code++ = (bch_val[0] & 0xFF);
> 			break;
> 		case OMAP_ECC_BCH4_CODE_HW_DETECTION_SW:
> 		case OMAP_ECC_BCH4_CODE_HW:
>-			bch_val1 = readl(gpmc_regs->gpmc_bch_result0[i]);
>-			bch_val2 = readl(gpmc_regs->gpmc_bch_result1[i]);
>-			*ecc_code++ = ((bch_val2 >> 12) & 0xFF);
>-			*ecc_code++ = ((bch_val2 >> 4) & 0xFF);
>-			*ecc_code++ = ((bch_val2 & 0xF) << 4) |
>-				((bch_val1 >> 28) & 0xF);
>-			*ecc_code++ = ((bch_val1 >> 20) & 0xFF);
>-			*ecc_code++ = ((bch_val1 >> 12) & 0xFF);
>-			*ecc_code++ = ((bch_val1 >> 4) & 0xFF);
>-			*ecc_code++ = ((bch_val1 & 0xF) << 4);
>+			omap_gpmc_ecc_get_bch_result(2, i, bch_val);
>+			*ecc_code++ = ((bch_val[1] >> 12) & 0xFF);
>+			*ecc_code++ = ((bch_val[1] >> 4) & 0xFF);
>+			*ecc_code++ = ((bch_val[1] & 0xF) << 4) |
>+				((bch_val[0] >> 28) & 0xF);
>+			*ecc_code++ = ((bch_val[0] >> 20) & 0xFF);
>+			*ecc_code++ = ((bch_val[0] >> 12) & 0xFF);
>+			*ecc_code++ = ((bch_val[0] >> 4) & 0xFF);
>+			*ecc_code++ = ((bch_val[0] & 0xF) << 4);
> 			break;
> 		case OMAP_ECC_BCH16_CODE_HW:
>-			val = readl(gpmc_regs->gpmc_bch_result6[i]);
>-			ecc_code[0]  = ((val >>  8) & 0xFF);
>-			ecc_code[1]  = ((val >>  0) & 0xFF);
>-			val = readl(gpmc_regs->gpmc_bch_result5[i]);
>-			ecc_code[2]  = ((val >> 24) & 0xFF);
>-			ecc_code[3]  = ((val >> 16) & 0xFF);
>-			ecc_code[4]  = ((val >>  8) & 0xFF);
>-			ecc_code[5]  = ((val >>  0) & 0xFF);
>-			val = readl(gpmc_regs->gpmc_bch_result4[i]);
>-			ecc_code[6]  = ((val >> 24) & 0xFF);
>-			ecc_code[7]  = ((val >> 16) & 0xFF);
>-			ecc_code[8]  = ((val >>  8) & 0xFF);
>-			ecc_code[9]  = ((val >>  0) & 0xFF);
>-			val = readl(gpmc_regs->gpmc_bch_result3[i]);
>-			ecc_code[10] = ((val >> 24) & 0xFF);
>-			ecc_code[11] = ((val >> 16) & 0xFF);
>-			ecc_code[12] = ((val >>  8) & 0xFF);
>-			ecc_code[13] = ((val >>  0) & 0xFF);
>-			val = readl(gpmc_regs->gpmc_bch_result2[i]);
>-			ecc_code[14] = ((val >> 24) & 0xFF);
>-			ecc_code[15] = ((val >> 16) & 0xFF);
>-			ecc_code[16] = ((val >>  8) & 0xFF);
>-			ecc_code[17] = ((val >>  0) & 0xFF);
>-			val = readl(gpmc_regs->gpmc_bch_result1[i]);
>-			ecc_code[18] = ((val >> 24) & 0xFF);
>-			ecc_code[19] = ((val >> 16) & 0xFF);
>-			ecc_code[20] = ((val >>  8) & 0xFF);
>-			ecc_code[21] = ((val >>  0) & 0xFF);
>-			val = readl(gpmc_regs->gpmc_bch_result0[i]);
>-			ecc_code[22] = ((val >> 24) & 0xFF);
>-			ecc_code[23] = ((val >> 16) & 0xFF);
>-			ecc_code[24] = ((val >>  8) & 0xFF);
>-			ecc_code[25] = ((val >>  0) & 0xFF);
>+			omap_gpmc_ecc_get_bch_result(7, i, bch_val);
>+			ecc_code[0]  = ((bch_val[6] >>  8) & 0xFF);
>+			ecc_code[1]  = ((bch_val[6] >>  0) & 0xFF);
>+
>+			ecc_code[2]  = ((bch_val[5] >> 24) & 0xFF);
>+			ecc_code[3]  = ((bch_val[5] >> 16) & 0xFF);
>+			ecc_code[4]  = ((bch_val[5] >>  8) & 0xFF);
>+			ecc_code[5]  = ((bch_val[5] >>  0) & 0xFF);
>+
>+			ecc_code[6]  = ((bch_val[4] >> 24) & 0xFF);
>+			ecc_code[7]  = ((bch_val[4] >> 16) & 0xFF);
>+			ecc_code[8]  = ((bch_val[4] >>  8) & 0xFF);
>+			ecc_code[9]  = ((bch_val[4] >>  0) & 0xFF);
>+
>+			ecc_code[10] = ((bch_val[3] >> 24) & 0xFF);
>+			ecc_code[11] = ((bch_val[3] >> 16) & 0xFF);
>+			ecc_code[12] = ((bch_val[3] >>  8) & 0xFF);
>+			ecc_code[13] = ((bch_val[3] >>  0) & 0xFF);
>+
>+			ecc_code[14] = ((bch_val[2] >> 24) & 0xFF);
>+			ecc_code[15] = ((bch_val[2] >> 16) & 0xFF);
>+			ecc_code[16] = ((bch_val[2] >>  8) & 0xFF);
>+			ecc_code[17] = ((bch_val[2] >>  0) & 0xFF);
>+
>+			ecc_code[18] = ((bch_val[1] >> 24) & 0xFF);
>+			ecc_code[19] = ((bch_val[1] >> 16) & 0xFF);
>+			ecc_code[20] = ((bch_val[1] >>  8) & 0xFF);
>+			ecc_code[21] = ((bch_val[1] >>  0) & 0xFF);
>+
>+			ecc_code[22] = ((bch_val[0] >> 24) & 0xFF);
>+			ecc_code[23] = ((bch_val[0] >> 16) & 0xFF);
>+			ecc_code[24] = ((bch_val[0] >>  8) & 0xFF);
>+			ecc_code[25] = ((bch_val[0] >>  0) & 0xFF);
> 			break;
> 		default:
> 			return -EINVAL;
>--
>1.8.3.2

Again same feedback.
You won't need all these changes, if you move this function
completely into GPMC driver, leaving only the wrapper here
which make the GPMC function compatible to chip->ecc.calculate.

with regards, pekon
