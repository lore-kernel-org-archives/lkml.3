Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaIYGV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 02:21:29 -0400
Received: from mailout.micron.com ([137.201.242.129]:11191 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaIYGV2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 02:21:28 -0400
From: bpqw <bpqw@micron.com>
To: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
CC: "b32955@freescale.com" <b32955@freescale.com>,
        "marex@denx.de" <marex@denx.de>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] driver:mtd:spi-nor: Add Micron quad I/O support
Thread-Topic: [PATCH 1/1] driver:mtd:spi-nor: Add Micron quad I/O support
Thread-Index: Ac/YiFuyagwG2in0R7+6ioZ2PHnYSgAADhFw
Date: Thu, 25 Sep 2014 06:20:35 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20974.005
X-TM-AS-Result: No-2.289700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For Micron spi norflash,you can enable Quad spi transfer
by clear EVCR(Enhanced Volatile Configuration Register)
Quad I/O protocol bit.

Signed-off-by: bean huo <beanhuo@micron.com>
---
 drivers/mtd/spi-nor/spi-nor.c |   45 +++++++++++++++++++++++++++++++++++++++++
 include/linux/mtd/spi-nor.h   |    6 ++++++
 2 files changed, 51 insertions(+)

diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
index b5ad6be..e72894f 100644
--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -878,6 +878,44 @@ static int spansion_quad_enable(struct spi_nor *nor)
 	return 0;
 }
 
+static int micron_quad_enable(struct spi_nor *nor)
+{
+	int ret, val;
+
+	ret = nor->read_reg(nor, SPINOR_OP_RD_EVCR, &val, 1);
+	if (ret < 0) {
+		dev_err(nor->dev, "error %d reading EVCR\n", ret);
+		return -EINVAL;
+	}
+
+	write_enable(nor);
+
+	/* set EVCR ,enable quad I/O */
+	nor->cmd_buf[0] = val & ~EVCR_QUAD_EN_MICRON;
+	ret = nor->write_reg(nor, SPINOR_OP_WD_EVCR, nor->cmd_buf, 1, 0);
+	if (ret < 0) {
+		dev_err(nor->dev,
+			"error while writing EVCR register\n");
+		return -EINVAL;
+	}
+
+	if (wait_till_ready(nor))
+		return 1;
+
+	/* read EVCR and check it */
+	ret = nor->read_reg(nor, SPINOR_OP_RD_EVCR, &val, 1);
+	if (ret < 0) {
+		dev_err(nor->dev, "error %d reading EVCR\n", ret);
+		return -EINVAL;
+	}
+	if (val & EVCR_QUAD_EN_MICRON) {
+		dev_err(nor->dev, "Micron EVCR Quad bit not clear\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int set_quad_mode(struct spi_nor *nor, u32 jedec_id)
 {
 	int status;
@@ -890,6 +928,13 @@ static int set_quad_mode(struct spi_nor *nor, u32 jedec_id)
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
index 9e6294f..d71b659 100644
--- a/include/linux/mtd/spi-nor.h
+++ b/include/linux/mtd/spi-nor.h
@@ -56,6 +56,10 @@
 /* Used for Spansion flashes only. */
 #define SPINOR_OP_BRWR		0x17	/* Bank register write */
 
+/* Used for Micron flashes only. */
+#define SPINOR_OP_RD_EVCR	0x65	/* Read EVCR register */
+#define SPINOR_OP_WD_EVCR	0x61	/* Write EVCR register */
+
 /* Status Register bits. */
 #define SR_WIP			1	/* Write in progress */
 #define SR_WEL			2	/* Write enable latch */
@@ -67,6 +71,8 @@
 
 #define SR_QUAD_EN_MX		0x40	/* Macronix Quad I/O */
 
+#define EVCR_QUAD_EN_MICRON	0x80	/* Micron Quad I/O */
+
 /* Flag Status Register bits */
 #define FSR_READY		0x80
 
-- 
1.7.9.5
