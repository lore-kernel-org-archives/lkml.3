Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbaDKPTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 11:19:08 -0400
Received: from mail-bl2on0119.outbound.protection.outlook.com ([65.55.169.119]:15181
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757431AbaDKPTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 11:19:04 -0400
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
Subject: [PATCH V2] Add support for flag status register on Micron chips.
Date: Fri, 11 Apr 2014 10:03:13 -0500
Message-ID: <1397228593-17996-1-git-send-email-grmoore@altera.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(87286001)(47776003)(33646001)(46102001)(80022001)(80976001)(89996001)(87936001)(84676001)(20776003)(4396001)(53416003)(50226001)(81342001)(74502001)(48376002)(74662001)(31966008)(50466002)(88136002)(62966002)(76482001)(79102001)(77982001)(77156001)(81542001)(6806004)(83322001)(19580405001)(19580395003)(44976005)(97736001)(99396002)(36756003)(92566001)(86152002)(50986999)(93916002)(86362001)(83072002)(85852003)(92726001)(2009001)(575784001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1AFFO11HUB063;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:EC107057.B8C65B2A.1FD157A3.4CDB4ABA.2059B;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0178184651
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
V2:
Remove leading underscore in function names.
Remove type cast in dev_err call and use the proper format
specifier instead.
---
 drivers/mtd/devices/m25p80.c |   91 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 78 insertions(+), 13 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index ad19139..4cddbc8 100644
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
 
@@ -109,6 +113,7 @@ struct m25p {
 	u8			program_opcode;
 	u8			*command;
 	enum read_type		flash_read;
+	int (*wait_till_ready)(struct m25p *flash);
 };
 
 static inline struct m25p *mtd_to_m25p(struct mtd_info *mtd)
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
+		dev_err(&flash->spi->dev, "error %zd reading FSR\n",
+			retval);
+		return retval;
+	}
+
+	return val;
+}
+/*
  * Read configuration register, returning its value in the
  * location. Return the configuration register value.
  * Returns negative if error occured.
@@ -254,6 +280,37 @@ static int wait_till_ready(struct m25p *flash)
 }
 
 /*
+ * Service routine to read flag status register until ready, or timeout occurs.
+ * Returns non-zero if error.
+ */
+static int wait_till_fsr_ready(struct m25p *flash)
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
@@ -1206,6 +1266,11 @@ static int m25p_probe(struct spi_device *spi)
 	if (info->flags & M25P_NO_ERASE)
 		flash->mtd.flags |= MTD_NO_ERASE;
 
+	if (info->flags & USE_FSR)
+		flash->wait_till_ready = &wait_till_fsr_ready;
+	else
+		flash->wait_till_ready = &wait_till_ready;
+
 	ppdata.of_node = spi->dev.of_node;
 	flash->mtd.dev.parent = &spi->dev;
 	flash->page_size = info->page_size;
-- 
1.7.10.4

