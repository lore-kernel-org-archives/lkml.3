Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbaDVOEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:04:15 -0400
Received: from mail-bl2on0118.outbound.protection.outlook.com ([65.55.169.118]:52337
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754065AbaDVOEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:04:11 -0400
From: Graham Moore <grmoore@altera.com>
To: <ggrahammoore@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>, ZY - marex <marex@denx.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Insop Song <insop.song@gainspeed.com>,
        Graham Moore <grmoore@altera.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: [PATCH V3] Add support for flag status register on Micron chips.
Date: Tue, 22 Apr 2014 09:03:16 -0500
Message-ID: <1398175396-7560-2-git-send-email-grmoore@altera.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398175396-7560-1-git-send-email-grmoore@altera.com>
References: <1398175396-7560-1-git-send-email-grmoore@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(199002)(189002)(31966008)(74662001)(53416003)(19580405001)(19580395003)(74502001)(77156001)(76482001)(20776003)(77982001)(46102001)(36756003)(47776003)(44976005)(83322001)(6806004)(76176999)(33646001)(4396001)(50226001)(87286001)(48376002)(84676001)(81542001)(92566001)(80022001)(92726001)(86362001)(62966002)(80976001)(89996001)(50466002)(2009001)(50986999)(85852003)(83072002)(87936001)(99396002)(97736001)(81342001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1AFFO11HUB033;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:E0D869D5.B8E6470B.2FF97BF6.582B837B.2042F;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 01894AD3B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some new Micron flash chips require reading the flag
status register to determine when operations have completed.

Furthermore, chips with multi-die stacks of the 65nm 256Mb QSPI also
require reading the status register before reading the flag status register.

This patch adds support for the flag status register in the n25q512ax3 and n25q00
Micron QSPI flash chips.

Signed-off-by: Graham Moore <grmoore@altera.com>
---
V3:
Rebase to l2-mtd spinor branch.
V2:
Remove leading underscore in function names.
Remove type cast in dev_err call and use the proper format
specifier instead.
---
 drivers/mtd/spi-nor/spi-nor.c |   51 +++++++++++++++++++++++++++++++++++++++++
 include/linux/mtd/spi-nor.h   |    4 ++++
 2 files changed, 55 insertions(+)

diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
index d6f44d5..24b84d8 100644
--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -48,6 +48,25 @@ static int read_sr(struct spi_nor *nor)
 }
 
 /*
+ * Read the flag status register, returning its value in the location
+ * Return the status register value.
+ * Returns negative if error occurred.
+ */
+static int read_fsr(struct spi_nor *nor)
+{
+	int ret;
+	u8 val;
+
+	ret = nor->read_reg(nor, SPINOR_OP_RDFSR, &val, 1);
+	if (ret < 0) {
+		pr_err("error %d reading FSR\n", ret);
+		return ret;
+	}
+
+	return val;
+}
+
+/*
  * Read configuration register, returning its value in the
  * location. Return the configuration register value.
  * Returns negative if error occured.
@@ -165,6 +184,32 @@ static int spi_nor_wait_till_ready(struct spi_nor *nor)
 	return -ETIMEDOUT;
 }
 
+static int spi_nor_wait_till_fsr_ready(struct spi_nor *nor)
+{
+	unsigned long deadline;
+	int sr;
+	int fsr;
+
+	deadline = jiffies + MAX_READY_WAIT_JIFFIES;
+
+	do {
+		cond_resched();
+
+		sr = read_sr(nor);
+		if (sr < 0)
+			break;
+		else if (!(sr & SR_WIP)) {
+			fsr = read_fsr(nor);
+			if (fsr < 0)
+				break;
+			if (fsr & FSR_READY)
+				return 0;			
+		}
+	} while (!time_after_eq(jiffies, deadline));
+
+	return -ETIMEDOUT;
+}
+
 /*
  * Service routine to read status register until ready, or timeout occurs.
  * Returns non-zero if error.
@@ -402,6 +447,7 @@ struct flash_info {
 #define	SECT_4K_PMC		0x10	/* SPINOR_OP_BE_4K_PMC works uniformly */
 #define	SPI_NOR_DUAL_READ	0x20    /* Flash supports Dual Read */
 #define	SPI_NOR_QUAD_READ	0x40    /* Flash supports Quad Read */
+#define	USE_FSR			0x80	/* use flag status register */
 };
 
 #define INFO(_jedec_id, _ext_id, _sector_size, _n_sectors, _flags)	\
@@ -488,6 +534,8 @@ const struct spi_device_id spi_nor_ids[] = {
 	{ "n25q128a13",  INFO(0x20ba18, 0, 64 * 1024,  256, 0) },
 	{ "n25q256a",    INFO(0x20ba19, 0, 64 * 1024,  512, SECT_4K) },
 	{ "n25q512a",    INFO(0x20bb20, 0, 64 * 1024, 1024, SECT_4K) },
+	{ "n25q512ax3",  INFO(0x20ba20, 0, 64 * 1024, 1024, USE_FSR) },
+	{ "n25q00",      INFO(0x20ba21, 0, 64 * 1024, 2048, USE_FSR) },
 
 	/* PMC */
 	{ "pm25lv512",   INFO(0,        0, 32 * 1024,    2, SECT_4K_PMC) },
@@ -965,6 +1013,9 @@ int spi_nor_scan(struct spi_nor *nor, const struct spi_device_id *id,
 	else
 		mtd->_write = spi_nor_write;
 
+	if (info->flags & USE_FSR)
+		nor->wait_till_ready = spi_nor_wait_till_fsr_ready;
+
 	/* prefer "small sector" erase if possible */
 	if (info->flags & SECT_4K) {
 		nor->erase_opcode = SPINOR_OP_BE_4K;
diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h
index 5324184..9e6294f 100644
--- a/include/linux/mtd/spi-nor.h
+++ b/include/linux/mtd/spi-nor.h
@@ -34,6 +34,7 @@
 #define SPINOR_OP_SE		0xd8	/* Sector erase (usually 64KiB) */
 #define SPINOR_OP_RDID		0x9f	/* Read JEDEC ID */
 #define SPINOR_OP_RDCR		0x35	/* Read configuration register */
+#define SPINOR_OP_RDFSR		0x70	/* Read flag status register */
 
 /* 4-byte address opcodes - used on Spansion and some Macronix flashes. */
 #define SPINOR_OP_READ4		0x13	/* Read data bytes (low frequency) */
@@ -66,6 +67,9 @@
 
 #define SR_QUAD_EN_MX		0x40	/* Macronix Quad I/O */
 
+/* Flag Status Register bits */
+#define FSR_READY		0x80
+
 /* Configuration Register bits. */
 #define CR_QUAD_EN_SPAN		0x2	/* Spansion Quad I/O */
 
-- 
1.7.9.5

