Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbaDHQ3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:29:25 -0400
Received: from mail-bn1bn0106.outbound.protection.outlook.com ([157.56.110.106]:23324
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932459AbaDHQ3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:29:21 -0400
X-Greylist: delayed 936 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2014 12:29:21 EDT
From: <grmoore@altera.com>
To: <ggrahammoore@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marex@denx.de>,
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
Subject: [PATCH] Add support for flag status register on Micron chips.
Date: Tue, 8 Apr 2014 11:12:50 -0500
Message-ID: <1396973570-13995-2-git-send-email-grmoore@altera.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1396973570-13995-1-git-send-email-grmoore@altera.com>
References: <1396973570-13995-1-git-send-email-grmoore@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?us-ascii?Q?CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(1001?=
 =?us-ascii?Q?9001)(6009001)(458001)(199002)(189002)(99396002)(44976005)(3?=
 =?us-ascii?Q?3646001)(74662001)(50466002)(31966008)(77982001)(63696002)(7?=
 =?us-ascii?Q?4706001)(46102001)(81686001)(65816001)(87266001)(80976001)(8?=
 =?us-ascii?Q?1816001)(89996001)(81342001)(19580405001)(98676001)(47776003?=
 =?us-ascii?Q?)(93136001)(81542001)(2009001)(93916002)(77096001)(79102001)?=
 =?us-ascii?Q?(53806002)(4396001)(54316003)(50986002)(20776003)(97736001)(?=
 =?us-ascii?Q?80022001)(59766001)(97336001)(83322001)(53416003)(84676001)(?=
 =?us-ascii?Q?69226001)(36756003)(76796001)(85306002)(56816005)(48376002)(?=
 =?us-ascii?Q?83072002)(92726001)(74876001)(97186001)(19580395003)(8813600?=
 =?us-ascii?Q?2)(92566001)(86362001)(76482001)(77156001)(95666003)(8793600?=
 =?us-ascii?Q?1)(76786001)(90146001)(94946001)(94316002)(50226001)(8615200?=
 =?us-ascii?Q?2)(575784001)(87286001)(74366001)(85852003)(49866001)(629660?=
 =?us-ascii?Q?02)(56776001)(95416001)(74502001)(93516002)(6806004)(4773600?=
 =?us-ascii?Q?2)(47446003)(47976002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1BFFO11?=
 =?us-ascii?Q?HUB013;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:EC117057.B?=
 =?us-ascii?Q?AC65B2A.13D157A3.8CDB4AF2.20574;MLV:sfv;PTR:InfoDomainNonexi?=
 =?us-ascii?Q?stent;A:1;MX:1;LANG:en;?=
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 017589626D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graham Moore <grmoore@altera.com>

Some new Micron flash chips require reading the flag
status register to determine when operations have completed.

Furthermore, chips with multi-die stacks of the 65nm 256Mb QSPI also
require reading the status register before reading the flag status register.

This patch adds support for the flag status register in the n25q512a1 and n25q00
Micron QSPI flash chips.

Signed-off-by: Graham Moore <grmoore@altera.com>
---
 drivers/mtd/devices/m25p80.c |   94 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 80 insertions(+), 14 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index ad19139..38306aa 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -39,6 +39,7 @@
 #define	OPCODE_WREN		0x06	/* Write enable */
 #define	OPCODE_RDSR		0x05	/* Read status register */
 #define	OPCODE_WRSR		0x01	/* Write status register 1 byte */
+#define	OPCODE_RDFSR		0x70  /* read flag status register */
 #define	OPCODE_NORM_READ	0x03	/* Read data bytes (low frequency) */
 #define	OPCODE_FAST_READ	0x0b	/* Read data bytes (high frequency) */
 #define	OPCODE_QUAD_READ        0x6b    /* Read data bytes */
@@ -81,6 +82,9 @@
 
 #define SR_QUAD_EN_MX           0x40    /* Macronix Quad I/O */
 
+/* Flag Status Register bits */
+#define FSR_READY               0x80    /* FSR ready */
+
 /* Configuration Register bits. */
 #define CR_QUAD_EN_SPAN		0x2     /* Spansion Quad I/O */
 
@@ -108,6 +112,7 @@ struct m25p {
 	u8			read_opcode;
 	u8			program_opcode;
 	u8			*command;
+	int (*wait_till_ready)(struct m25p *flash);
 	enum read_type		flash_read;
 };
 
@@ -145,6 +150,27 @@ static int read_sr(struct m25p *flash)
 }
 
 /*
+ * Read the flag status register, returning its value in the location
+ * Return the status register value.
+ * Returns negative if error occurred.
+ */
+static int read_fsr(struct m25p *flash)
+{
+	ssize_t retval;
+	u8 code = OPCODE_RDFSR;
+	u8 val;
+
+	retval = spi_write_then_read(flash->spi, &code, 1, &val, 1);
+
+	if (retval < 0) {
+		dev_err(&flash->spi->dev, "error %d reading FSR\n",
+				(int) retval);
+		return retval;
+	}
+
+	return val;
+}
+/*
  * Read configuration register, returning its value in the
  * location. Return the configuration register value.
  * Returns negative if error occured.
@@ -233,7 +259,7 @@ static inline int set_4byte(struct m25p *flash, u32 jedec_id, int enable)
  * Service routine to read status register until ready, or timeout occurs.
  * Returns non-zero if error.
  */
-static int wait_till_ready(struct m25p *flash)
+static int _wait_till_ready(struct m25p *flash)
 {
 	unsigned long deadline;
 	int sr;
@@ -254,6 +280,37 @@ static int wait_till_ready(struct m25p *flash)
 }
 
 /*
+ * Service routine to read flag status register until ready, or timeout occurs.
+ * Returns non-zero if error.
+ */
+static int _wait_till_fsr_ready(struct m25p *flash)
+{
+	unsigned long deadline;
+	int fsr;
+	int sr;
+
+	deadline = jiffies + MAX_READY_WAIT_JIFFIES;
+
+	do {
+		sr = read_sr(flash);
+		if (sr < 0)
+			break;
+		/* only check fsr if sr not busy */
+		if (!(sr & SR_WIP)) {
+			fsr = read_fsr(flash);
+			if (fsr < 0)
+				break;
+			if (fsr & FSR_READY)
+				return 0;
+		}
+
+		cond_resched();
+
+	} while (!time_after_eq(jiffies, deadline));
+
+	return 1;
+}
+/*
  * Write status Register and configuration register with 2 bytes
  * The first byte will be written to the status register, while the
  * second byte will be written to the configuration register.
@@ -280,7 +337,7 @@ static int macronix_quad_enable(struct m25p *flash)
 
 	spi_write(flash->spi, &cmd, 2);
 
-	if (wait_till_ready(flash))
+	if (flash->wait_till_ready(flash))
 		return 1;
 
 	ret = read_sr(flash);
@@ -351,7 +408,7 @@ static int erase_chip(struct m25p *flash)
 			(long long)(flash->mtd.size >> 10));
 
 	/* Wait until finished previous write command. */
-	if (wait_till_ready(flash))
+	if (flash->wait_till_ready(flash))
 		return 1;
 
 	/* Send write enable, then erase commands. */
@@ -391,7 +448,7 @@ static int erase_sector(struct m25p *flash, u32 offset)
 			__func__, flash->mtd.erasesize / 1024, offset);
 
 	/* Wait until finished previous write command. */
-	if (wait_till_ready(flash))
+	if (flash->wait_till_ready(flash))
 		return 1;
 
 	/* Send write enable, then erase commands. */
@@ -536,7 +593,7 @@ static int m25p80_read(struct mtd_info *mtd, loff_t from, size_t len,
 	mutex_lock(&flash->lock);
 
 	/* Wait till previous write/erase is done. */
-	if (wait_till_ready(flash)) {
+	if (flash->wait_till_ready(flash)) {
 		/* REVISIT status return?? */
 		mutex_unlock(&flash->lock);
 		return 1;
@@ -585,7 +642,7 @@ static int m25p80_write(struct mtd_info *mtd, loff_t to, size_t len,
 	mutex_lock(&flash->lock);
 
 	/* Wait until finished previous write command. */
-	if (wait_till_ready(flash)) {
+	if (flash->wait_till_ready(flash)) {
 		mutex_unlock(&flash->lock);
 		return 1;
 	}
@@ -628,7 +685,7 @@ static int m25p80_write(struct mtd_info *mtd, loff_t to, size_t len,
 			t[1].tx_buf = buf + i;
 			t[1].len = page_size;
 
-			wait_till_ready(flash);
+			flash->wait_till_ready(flash);
 
 			write_enable(flash);
 
@@ -668,7 +725,7 @@ static int sst_write(struct mtd_info *mtd, loff_t to, size_t len,
 	mutex_lock(&flash->lock);
 
 	/* Wait until finished previous write command. */
-	ret = wait_till_ready(flash);
+	ret = flash->wait_till_ready(flash);
 	if (ret)
 		goto time_out;
 
@@ -683,7 +740,7 @@ static int sst_write(struct mtd_info *mtd, loff_t to, size_t len,
 		/* write one byte. */
 		t[1].len = 1;
 		spi_sync(flash->spi, &m);
-		ret = wait_till_ready(flash);
+		ret = flash->wait_till_ready(flash);
 		if (ret)
 			goto time_out;
 		*retlen += m.actual_length - m25p_cmdsz(flash);
@@ -702,7 +759,7 @@ static int sst_write(struct mtd_info *mtd, loff_t to, size_t len,
 		t[1].tx_buf = buf + actual;
 
 		spi_sync(flash->spi, &m);
-		ret = wait_till_ready(flash);
+		ret = flash->wait_till_ready(flash);
 		if (ret)
 			goto time_out;
 		*retlen += m.actual_length - cmd_sz;
@@ -710,7 +767,7 @@ static int sst_write(struct mtd_info *mtd, loff_t to, size_t len,
 		to += 2;
 	}
 	write_disable(flash);
-	ret = wait_till_ready(flash);
+	ret = flash->wait_till_ready(flash);
 	if (ret)
 		goto time_out;
 
@@ -724,7 +781,7 @@ static int sst_write(struct mtd_info *mtd, loff_t to, size_t len,
 		t[1].tx_buf = buf + actual;
 
 		spi_sync(flash->spi, &m);
-		ret = wait_till_ready(flash);
+		ret = flash->wait_till_ready(flash);
 		if (ret)
 			goto time_out;
 		*retlen += m.actual_length - m25p_cmdsz(flash);
@@ -745,7 +802,7 @@ static int m25p80_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 
 	mutex_lock(&flash->lock);
 	/* Wait until finished previous command */
-	if (wait_till_ready(flash)) {
+	if (flash->wait_till_ready(flash)) {
 		res = 1;
 		goto err;
 	}
@@ -790,7 +847,7 @@ static int m25p80_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 
 	mutex_lock(&flash->lock);
 	/* Wait until finished previous command */
-	if (wait_till_ready(flash)) {
+	if (flash->wait_till_ready(flash)) {
 		res = 1;
 		goto err;
 	}
@@ -856,6 +913,7 @@ struct flash_info {
 #define	M25P_NO_FR	0x08		/* Can't do fastread */
 #define	SECT_4K_PMC	0x10		/* OPCODE_BE_4K_PMC works uniformly */
 #define	M25P80_QUAD_READ	0x20    /* Flash supports Quad Read */
+#define	USE_FSR		0x40		/* use flag status register */
 };
 
 #define INFO(_jedec_id, _ext_id, _sector_size, _n_sectors, _flags)	\
@@ -941,6 +999,8 @@ static const struct spi_device_id m25p_ids[] = {
 	{ "n25q128a13",  INFO(0x20ba18, 0, 64 * 1024,  256, 0) },
 	{ "n25q256a",    INFO(0x20ba19, 0, 64 * 1024,  512, SECT_4K) },
 	{ "n25q512a",    INFO(0x20bb20, 0, 64 * 1024, 1024, SECT_4K) },
+	{ "n25q512a1",   INFO(0x20ba20, 0, 64 * 1024, 1024, USE_FSR) },
+	{ "n25q00",      INFO(0x20ba21, 0, 64 * 1024, 2048, USE_FSR) },
 
 	/* PMC */
 	{ "pm25lv512",   INFO(0,        0, 32 * 1024,    2, SECT_4K_PMC) },
@@ -1206,6 +1266,12 @@ static int m25p_probe(struct spi_device *spi)
 	if (info->flags & M25P_NO_ERASE)
 		flash->mtd.flags |= MTD_NO_ERASE;
 
+	if (info->flags & USE_FSR)
+		flash->wait_till_ready = &_wait_till_fsr_ready;
+	else
+		flash->wait_till_ready = &_wait_till_ready;
+
+
 	ppdata.of_node = spi->dev.of_node;
 	flash->mtd.dev.parent = &spi->dev;
 	flash->page_size = info->page_size;
-- 
1.7.10.4

