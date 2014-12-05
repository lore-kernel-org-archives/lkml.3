Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbaLEHMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 02:12:01 -0500
Received: from mailout.micron.com ([137.201.242.129]:51935 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaLEHL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 02:11:59 -0500
From: =?iso-2022-jp?B?QmVhbiBIdW8gGyRCcDlJTElMGyhCIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
To: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marex@denx.de>
CC: "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-2022-jp?B?QmVhbiBIdW8gGyRCcDlJTElMGyhCIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
Subject: [V6 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for Micron
 spi nor
Thread-Topic: [V6 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Index: AdAQWnqsiImr5KpARvijPY3FrXHl/Q==
Date: Fri, 5 Dec 2014 07:09:59 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315EF2C5@NTXXIAMBX02.xacn.micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21150.005
X-TM-AS-Result: No--4.398800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code which enables Quad I/O mode on Micron SPI NOR flashes.

For Micron SPI NOR flash,enabling or disabling quad I/O protocol can be done
By two methods, which are to use EVCR(Enhanced Volatile Configuration Register)
and the ENTER QUAD I/O MODE command.There is no difference between these two
methods.Unfortunately,for some Micron spi nor flashes,there no ENTER Quad I/O
command(35h),such as n25q064.But for all current Micron spi nor,if it support
quad I/O mode,using EVCR definitely be supported.It is a recommended method to
enable Quad I/O mode by EVCR,Quad I/O protocol bit 7.When EVCR bit 7 is reset
to 0,the SPI NOR flash will operate in quad I/O mode.

This patch has been tested on N25Q512A and MT25TL256BAA1ESF.Micron spi nor of 
spi_nor_ids[] table all support this method.

Signed-off-by: bean huo <beanhuo@micron.com>
Acked-by: Marek Vasut <marex@denx.de>
---
v1-v2:
	Modified to that capture wait_till_ready()
	return value,if error,directly return its
	the value.
 v2-v3:
	Directly use the reurning error value of
	read_reg and write_reg,instead of -EINVAL.
 v3-v4:
	Modify commit logs that wraped into 80 columns.
 v4-v5:
	Rebuild new patch based on latest linux-mtd.
 v5-v6:
	Rebuild patch based on latest l2-mtd.
	add some comments.
	Add SPI_NOR_QUAD_READ flag in the spi_nor_ids[] for Micron spi nor.

 drivers/mtd/spi-nor/spi-nor.c |   61 +++++++++++++++++++++++++++++++++++------
 include/linux/mtd/spi-nor.h   |    7 +++++
 2 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
index 0f8ec3c..128941e 100644
--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -560,14 +560,14 @@ static const struct spi_device_id spi_nor_ids[] = {
 	{ "mx66l1g55g",  INFO(0xc2261b, 0, 64 * 1024, 2048, SPI_NOR_QUAD_READ) },
 
 	/* Micron */
-	{ "n25q032",	 INFO(0x20ba16, 0, 64 * 1024,   64, 0) },
-	{ "n25q064",     INFO(0x20ba17, 0, 64 * 1024,  128, 0) },
-	{ "n25q128a11",  INFO(0x20bb18, 0, 64 * 1024,  256, 0) },
-	{ "n25q128a13",  INFO(0x20ba18, 0, 64 * 1024,  256, 0) },
-	{ "n25q256a",    INFO(0x20ba19, 0, 64 * 1024,  512, SECT_4K) },
-	{ "n25q512a",    INFO(0x20bb20, 0, 64 * 1024, 1024, SECT_4K) },
-	{ "n25q512ax3",  INFO(0x20ba20, 0, 64 * 1024, 1024, USE_FSR) },
-	{ "n25q00",      INFO(0x20ba21, 0, 64 * 1024, 2048, USE_FSR) },
+	{ "n25q032",	 INFO(0x20ba16, 0, 64 * 1024,   64, SPI_NOR_QUAD_READ) },
+	{ "n25q064",     INFO(0x20ba17, 0, 64 * 1024,  128, SPI_NOR_QUAD_READ) },
+	{ "n25q128a11",  INFO(0x20bb18, 0, 64 * 1024,  256, SPI_NOR_QUAD_READ) },
+	{ "n25q128a13",  INFO(0x20ba18, 0, 64 * 1024,  256, SPI_NOR_QUAD_READ) },
+	{ "n25q256a",    INFO(0x20ba19, 0, 64 * 1024,  512, SECT_4K | SPI_NOR_QUAD_READ) },
+	{ "n25q512a",    INFO(0x20bb20, 0, 64 * 1024, 1024, SECT_4K | USE_FSR | SPI_NOR_QUAD_READ) },
+	{ "n25q512ax3",  INFO(0x20ba20, 0, 64 * 1024, 1024, SECT_4K | USE_FSR | SPI_NOR_QUAD_READ) },
+	{ "n25q00",      INFO(0x20ba21, 0, 64 * 1024, 2048, SECT_4K | USE_FSR | SPI_NOR_QUAD_READ) },
 
 	/* PMC */
 	{ "pm25lv512",   INFO(0,        0, 32 * 1024,    2, SECT_4K_PMC) },
@@ -891,6 +891,44 @@ static int spansion_quad_enable(struct spi_nor *nor)
 	return 0;
 }
 
+static int micron_quad_enable(struct spi_nor *nor)
+{
+	int ret, val;
+
+	ret = nor->read_reg(nor, SPINOR_OP_RD_EVCR, &val, 1);
+	if (ret < 0) {
+		dev_err(nor->dev, "error %d reading EVCR\n", ret);
+		return ret;
+	}
+
+	write_enable(nor);
+
+	/* set EVCR ,enable quad I/O */
+	nor->cmd_buf[0] = val & ~EVCR_QUAD_EN_MICRON;
+	ret = nor->write_reg(nor, SPINOR_OP_WD_EVCR, nor->cmd_buf, 1, 0);
+	if (ret < 0) {
+		dev_err(nor->dev, "error while writing EVCR register\n");
+		return ret;
+	}
+
+	ret = spi_nor_wait_till_ready(nor);
+	if (ret)
+		return ret;
+
+	/* read EVCR and check it */
+	ret = nor->read_reg(nor, SPINOR_OP_RD_EVCR, &val, 1);
+	if (ret < 0) {
+		dev_err(nor->dev, "error %d reading EVCR\n", ret);
+		return ret;
+	}
+	if (val & EVCR_QUAD_EN_MICRON) {
+		dev_err(nor->dev, "Micron EVCR Quad bit not clear\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int set_quad_mode(struct spi_nor *nor, struct flash_info *info)
 {
 	int status;
@@ -903,6 +941,13 @@ static int set_quad_mode(struct spi_nor *nor, struct flash_info *info)
 			return -EINVAL;
 		}
 		return status;
+	case CFI_MFR_ST:
+		status = micron_quad_enable(nor);
+		if (status) {
+			dev_err(nor->dev, "Micron quad-read not enabled\n");
+			return -EINVAL;
+		}
+		return status;
 	default:
 		status = spansion_quad_enable(nor);
 		if (status) {
diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h
index 63aeccf..4720b86 100644
--- a/include/linux/mtd/spi-nor.h
+++ b/include/linux/mtd/spi-nor.h
@@ -56,6 +56,10 @@
 /* Used for Spansion flashes only. */
 #define SPINOR_OP_BRWR		0x17	/* Bank register write */
 
+/* Used for Micron flashes only. */
+#define SPINOR_OP_RD_EVCR      0x65    /* Read EVCR register */
+#define SPINOR_OP_WD_EVCR      0x61    /* Write EVCR register */
+
 /* Status Register bits. */
 #define SR_WIP			1	/* Write in progress */
 #define SR_WEL			2	/* Write enable latch */
@@ -67,6 +71,9 @@
 
 #define SR_QUAD_EN_MX		0x40	/* Macronix Quad I/O */
 
+/* Enhanced Volatile Configuration Register bits */
+#define EVCR_QUAD_EN_MICRON    0x80    /* Micron Quad I/O */
+
 /* Flag Status Register bits */
 #define FSR_READY		0x80
 
-- 
1.7.9.5

