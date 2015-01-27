Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbbA0OLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:11:54 -0500
Received: from down.free-electrons.com ([37.187.137.238]:43717 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756188AbbA0OKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:10:23 -0500
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, ezequiel.garcia@free-electrons.com,
        dwmw2@infradead.org, computersforpeace@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] mtd: pxa3xx_nand: add support for the Marvell Berlin nand controller
Date: Tue, 27 Jan 2015 15:10:12 +0100
Message-Id: <1422367816-4257-6-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422367816-4257-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1422367816-4257-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nand controller on Marvell Berlin SoC reuse the pxa3xx nand driver
as it quite close. The process of sending commands can be compared to
the one of the Marvell armada 370: read and write commands are done in
chunks.

But the Berlin nand controller has some other specificities which
require some modifications of the pxa3xx nand driver:
- there are no IRQ available so we need to poll the status register: we
  have to use our own cmdfunc Berlin function, and early on the probing
  function.
- PAGEPROG are very different from the one used in the pxa3xx driver,
  so we're using a specific process for this one
- the SEQIN command is equivalent to a READ0 command
- the RNDOUT command must be used to perform a read operation, and the
  command is not NAND_CMD_RNDOUT
- the ERASE1 command is specific (0xd060)

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/mtd/nand/pxa3xx_nand.c | 287 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 261 insertions(+), 26 deletions(-)

diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index b2783b1f663c..62ea369dc524 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -109,6 +109,8 @@
 #define NDCB0_EXT_CMD_TYPE(x)	(((x) << 29) & NDCB0_EXT_CMD_TYPE_MASK)
 #define NDCB0_CMD_TYPE_MASK	(0x7 << 21)
 #define NDCB0_CMD_TYPE(x)	(((x) << 21) & NDCB0_CMD_TYPE_MASK)
+#define NDCB0_CMD_XTYPE_MASK	(0x7 << 29)
+#define NDCB0_CMD_XTYPE(x)	(((x) << 29) & NDCB0_CMD_XTYPE_MASK)
 #define NDCB0_NC		(0x1 << 20)
 #define NDCB0_DBC		(0x1 << 19)
 #define NDCB0_ADDR_CYC_MASK	(0x7 << 16)
@@ -117,13 +119,20 @@
 #define NDCB0_CMD1_MASK		(0xff)
 #define NDCB0_ADDR_CYC_SHIFT	(16)
 
-#define EXT_CMD_TYPE_DISPATCH	6 /* Command dispatch */
-#define EXT_CMD_TYPE_NAKED_RW	5 /* Naked read or Naked write */
-#define EXT_CMD_TYPE_READ	4 /* Read */
-#define EXT_CMD_TYPE_DISP_WR	4 /* Command dispatch with write */
-#define EXT_CMD_TYPE_FINAL	3 /* Final command */
-#define EXT_CMD_TYPE_LAST_RW	1 /* Last naked read/write */
-#define EXT_CMD_TYPE_MONO	0 /* Monolithic read/write */
+#define EXT_CMD_TYPE_LAST_PAGEPROG	10
+#define EXT_CMD_TYPE_CHUNK_PAGEPROG	9
+#define EXT_CMD_TYPE_LAST_RNDOUT	8
+#define EXT_CMD_TYPE_CHUNK_RNDOUT	7
+#define EXT_CMD_TYPE_DISPATCH		6 /* Command dispatch */
+#define EXT_CMD_TYPE_NAKED_RW		5 /* Naked read or Naked write */
+#define EXT_CMD_TYPE_READ		4 /* Read */
+#define EXT_CMD_TYPE_DISP_WR		4 /* Command dispatch with write */
+#define EXT_CMD_TYPE_FINAL		3 /* Final command */
+#define EXT_CMD_TYPE_LAST_RW		1 /* Last naked read/write */
+#define EXT_CMD_TYPE_MONO		0 /* Monolithic read/write */
+
+#define BERLIN_NAND_CMD_RNDOUT		0x3000
+#define BERLIN_NAND_CMD_ERASE1		0xd060
 
 /* macros for registers read/write */
 #define nand_writel(info, off, val)	\
@@ -158,6 +167,7 @@ enum {
 enum pxa3xx_nand_variant {
 	PXA3XX_NAND_VARIANT_PXA,
 	PXA3XX_NAND_VARIANT_ARMADA370,
+	PXA3XX_NAND_VARIANT_BERLIN2,
 };
 
 struct pxa3xx_nand_host {
@@ -244,10 +254,13 @@ module_param(use_dma, bool, 0444);
 MODULE_PARM_DESC(use_dma, "enable DMA for data transferring to/from NAND HW");
 
 static struct pxa3xx_nand_timing timing[] = {
-	{ 40, 80, 60, 100, 80, 100, 90000, 400, 40, },
-	{ 10,  0, 20,  40, 30,  40, 11123, 110, 10, },
-	{ 10, 25, 15,  25, 15,  30, 25000,  60, 10, },
-	{ 10, 35, 15,  25, 15,  25, 25000,  60, 10, },
+	{ 40, 80, 60, 100, 80, 100,  90000, 400, 40, },
+	{ 10,  0, 20,  40, 30,  40,  11123, 110, 10, },
+	{ 10, 25, 15,  25, 15,  30,  25000,  60, 10, },
+	{ 10, 35, 15,  25, 15,  25,  25000,  60, 10, },
+	{  5, 20, 10,  12, 10,  12,  60000,  60, 10, },
+	{  5, 20, 10,  12, 10,  12, 200000, 120, 10, },
+	{  5, 15, 10,  15, 10,  15,  60000,  60, 10, },
 };
 
 static struct pxa3xx_nand_flash builtin_flash_types[] = {
@@ -260,6 +273,20 @@ static struct pxa3xx_nand_flash builtin_flash_types[] = {
 { "512MiB 8-bit",  0xdc2c,  64, 2048,  8,  8, 4096, &timing[2] },
 { "512MiB 16-bit", 0xcc2c,  64, 2048, 16, 16, 4096, &timing[2] },
 { "256MiB 16-bit", 0xba20,  64, 2048, 16, 16, 2048, &timing[3] },
+{ },
+};
+
+static struct pxa3xx_nand_flash berlin_builtin_flash_types[] = {
+{ "2GiB 8-bit",    0xd5ec, 128, 8192,  8,  8, 2048, &timing[4] },
+{ "2GiB 8-bit",    0xd598, 128, 8192,  8,  8, 2048, &timing[5] },
+{ "2GiB 8-bit",    0x482c, 256, 4096,  8,  8, 2048, &timing[6] },
+{ "4GiB 8-bit",    0xd7ec, 128, 8192,  8,  8, 4096, &timing[5] },
+{ "8GiB 8-bit",    0xdeec, 128, 8192,  8,  8, 4096, &timing[5] },
+{ "4GiB 8-bit",    0xd7ad, 256, 8192,  8,  8, 2048, &timing[5] },
+{ "4GiB 8-bit",    0x682c, 256, 4096,  8,  8, 4096, &timing[6] },
+{ "8GiB 8-bit",    0x882c, 256, 8192,  8,  8, 4096, &timing[6] },
+{ "8GiB 8-bit",    0xdead, 256, 8192,  8,  8, 4096, &timing[6] },
+{ },
 };
 
 static u8 bbt_pattern[] = {'M', 'V', 'B', 'b', 't', '0' };
@@ -320,6 +347,18 @@ static struct nand_ecclayout ecc_layout_4KB_bch8bit = {
 	.oobfree = { }
 };
 
+static struct nand_ecclayout ecc_layout_oob_128 = {
+        .eccbytes = 48,
+        .eccpos = {
+                   80, 81, 82, 83, 84, 85, 86, 87,
+                   88, 89, 90, 91, 92, 93, 94, 95,
+                   96, 97, 98, 99, 100, 101, 102, 103,
+                   104, 105, 106, 107, 108, 109, 110, 111,
+                   112, 113, 114, 115, 116, 117, 118, 119,
+                   120, 121, 122, 123, 124, 125, 126, 127},
+        .oobfree = { {.offset = 2, .length = 78} }
+};
+
 /* Define a default flash type setting serve as flash detecting only */
 #define DEFAULT_FLASH_TYPE (&builtin_flash_types[0])
 
@@ -346,6 +385,10 @@ static const struct of_device_id pxa3xx_nand_dt_ids[] = {
 		.compatible = "marvell,armada370-nand",
 		.data       = (void *)PXA3XX_NAND_VARIANT_ARMADA370,
 	},
+	{
+		.compatible = "marvell,berlin2-nand",
+		.data       = (void *)PXA3XX_NAND_VARIANT_BERLIN2,
+	},
 	{}
 };
 MODULE_DEVICE_TABLE(of, pxa3xx_nand_dt_ids);
@@ -378,6 +421,11 @@ static void pxa3xx_nand_set_timing(struct pxa3xx_nand_host *host,
 		NDTR1_tWHR(ns2cycle(t->tWHR, nand_clk)) |
 		NDTR1_tAR(ns2cycle(t->tAR, nand_clk));
 
+	if (info->variant == PXA3XX_NAND_VARIANT_BERLIN2) {
+		ndtr0 = 0x84840A12;
+		ndtr1 = 0x00208662;
+	}
+
 	info->ndtr0cs0 = ndtr0;
 	info->ndtr1cs0 = ndtr1;
 	nand_writel(info, NDTR0CS0, ndtr0);
@@ -644,6 +692,11 @@ static irqreturn_t pxa3xx_nand_irq(int irq, void *devid)
 		nand_writel(info, NDCB0, info->ndcb1);
 		nand_writel(info, NDCB0, info->ndcb2);
 
+		if (info->variant == PXA3XX_NAND_VARIANT_BERLIN2 &&
+				info->ndcb0 & NDCB0_LEN_OVRD)
+			nand_writel(info, NDCB0,
+					info->chunk_size + info->oob_size);
+
 		/* NDCB3 register is available in NFCv2 (Armada 370/XP SoC) */
 		if (info->variant == PXA3XX_NAND_VARIANT_ARMADA370)
 			nand_writel(info, NDCB0, info->ndcb3);
@@ -755,6 +808,19 @@ static int prepare_set_command(struct pxa3xx_nand_info *info, int command,
 	if (command == NAND_CMD_SEQIN)
 		exec_cmd = 0;
 
+	/* Berlin specific */
+	if (info->variant == PXA3XX_NAND_VARIANT_BERLIN2) {
+		if (command == NAND_CMD_READ0 || command == NAND_CMD_READOOB)
+			exec_cmd = 0;
+
+		if (command == NAND_CMD_SEQIN)
+			command = NAND_CMD_READ0;
+		else if (command == NAND_CMD_RNDOUT)
+			command = BERLIN_NAND_CMD_RNDOUT;
+		else if (command == NAND_CMD_ERASE1)
+			command = BERLIN_NAND_CMD_ERASE1;
+	}
+
 	addr_cycle = NDCB0_ADDR_CYC(host->row_addr_cycles
 				    + host->col_addr_cycles);
 
@@ -814,6 +880,34 @@ static int prepare_set_command(struct pxa3xx_nand_info *info, int command,
 			break;
 		}
 
+		if (info->variant == PXA3XX_NAND_VARIANT_BERLIN2) {
+			if (ext_cmd_type == EXT_CMD_TYPE_LAST_PAGEPROG) {
+				info->ndcb0 |= NDCB0_CMD_TYPE(0x1)
+						| NDCB0_CMD_XTYPE(0x3)
+						| NDCB0_ST_ROW_EN
+						| NDCB0_DBC
+						| 0xff
+						| (0x1080 & (0xff << 8));
+			} else if (ext_cmd_type == EXT_CMD_TYPE_CHUNK_PAGEPROG) {
+				info->ndcb0 |= NDCB0_CMD_TYPE(0x1)
+						| NDCB0_CMD_XTYPE(0x5)
+						| NDCB0_NC
+						| NDCB0_AUTO_RS
+						| NDCB0_LEN_OVRD
+						| (0x1080 & 0xff);
+			} else {
+				info->ndcb0 |= NDCB0_CMD_TYPE(0x1)
+						| NDCB0_CMD_XTYPE(0x4)
+						| NDCB0_NC
+						| NDCB0_AUTO_RS
+						| NDCB0_LEN_OVRD
+						| addr_cycle
+						| (0x1080 & 0xff);
+			}
+
+			break;
+		}
+
 		/* Second command setting for large pages */
 		if (mtd->writesize > PAGE_CHUNK_SIZE) {
 			/*
@@ -870,6 +964,27 @@ static int prepare_set_command(struct pxa3xx_nand_info *info, int command,
 
 		info->data_size = 8;
 		break;
+
+	case BERLIN_NAND_CMD_RNDOUT:
+		info->buf_start = column;
+
+		if (ext_cmd_type == EXT_CMD_TYPE_LAST_RNDOUT)
+			info->ndcb0 = NDCB0_CMD_XTYPE(0x5)
+					| NDCB0_LEN_OVRD;
+		else if (ext_cmd_type == EXT_CMD_TYPE_CHUNK_RNDOUT)
+			info->ndcb0 = NDCB0_CMD_XTYPE(0x5)
+					| NDCB0_LEN_OVRD
+					| NDCB0_NC;
+		else
+			info->ndcb0 |= NDCB0_CMD_TYPE(0)
+					| NDCB0_CMD_XTYPE(0x6)
+					| NDCB0_DBC
+					| NDCB0_NC
+					| addr_cycle
+					| command;
+
+		break;
+
 	case NAND_CMD_STATUS:
 		info->buf_count = 1;
 		info->ndcb0 |= NDCB0_CMD_TYPE(4)
@@ -880,15 +995,18 @@ static int prepare_set_command(struct pxa3xx_nand_info *info, int command,
 		break;
 
 	case NAND_CMD_ERASE1:
+	case BERLIN_NAND_CMD_ERASE1:
 		info->ndcb0 |= NDCB0_CMD_TYPE(2)
 				| NDCB0_AUTO_RS
 				| NDCB0_ADDR_CYC(3)
 				| NDCB0_DBC
-				| (NAND_CMD_ERASE2 << 8)
-				| NAND_CMD_ERASE1;
+				| command;
 		info->ndcb1 = page_addr;
 		info->ndcb2 = 0;
 
+		if (command == NAND_CMD_ERASE1)
+			info->ndcb0 |= (NAND_CMD_ERASE2 << 8);
+
 		break;
 	case NAND_CMD_RESET:
 		info->ndcb0 |= NDCB0_CMD_TYPE(5)
@@ -1078,6 +1196,102 @@ static int pxa3xx_nand_write_page_hwecc(struct mtd_info *mtd,
 	return 0;
 }
 
+static void nand_cmdfunc_berlin(struct mtd_info *mtd, const unsigned command,
+		int column, int page_addr)
+{
+	struct pxa3xx_nand_host *host = mtd->priv;
+	struct pxa3xx_nand_info *info = host->info_data;
+	unsigned long timeout;
+	unsigned int oob_size = info->oob_size;
+	int exec_cmd, ext_cmd_type = 0;
+	unsigned cmd = command;
+
+	if (info->reg_ndcr & NDCR_DWIDTH_M)
+		column /= 2;
+
+	/*
+	 * There may be different NAND chip hooked to
+	 * different chip select, so check whether
+	 * chip select has been changed, if yes, reset the timing
+	 */
+	if (info->cs != host->cs) {
+		info->cs = host->cs;
+		nand_writel(info, NDTR0CS0, info->ndtr0cs0);
+		nand_writel(info, NDTR1CS0, info->ndtr1cs0);
+	}
+
+	prepare_start_command(info, cmd);
+
+	info->need_wait = 1;
+	init_completion(&info->dev_ready);
+
+	pxa3xx_nand_start(info);
+
+	do {
+		init_completion(&info->cmd_complete);
+		info->state = STATE_PREPARED;
+		exec_cmd = prepare_set_command(info, cmd, ext_cmd_type,
+				column, page_addr);
+
+		if (cmd == NAND_CMD_READ0) {
+			cmd = NAND_CMD_RNDOUT;
+			continue;
+		}
+
+		if (!exec_cmd) {
+			info->need_wait = 0;
+			complete(&info->dev_ready);
+			break;
+		}
+
+		/* no IRQ, poll */
+		timeout = jiffies + CHIP_DELAY_TIMEOUT;
+		do {
+			pxa3xx_nand_irq(0, info);
+
+			if (cmd == NAND_CMD_PAGEPROG &&
+					ext_cmd_type != EXT_CMD_TYPE_LAST_PAGEPROG)
+				break;
+
+			if (time_after(jiffies, timeout))
+				goto berlin_timeout;
+		} while (!completion_done(&info->cmd_complete));
+
+		/* sequence completed */
+		if (info->data_size == 0)
+			break;
+
+		if (cmd == NAND_CMD_PAGEPROG &&
+				ext_cmd_type == EXT_CMD_TYPE_LAST_PAGEPROG) {
+			complete(&info->dev_ready);
+			break;
+		}
+
+		if (cmd == NAND_CMD_RNDOUT) {
+			/* last command */
+			if (info->data_size == info->chunk_size * 2) {
+				ext_cmd_type = EXT_CMD_TYPE_LAST_RNDOUT;
+				info->oob_size = oob_size;
+			} else {
+				ext_cmd_type = EXT_CMD_TYPE_CHUNK_RNDOUT;
+			}
+		}
+
+		if (cmd == NAND_CMD_PAGEPROG) {
+			/* last command */
+			if (info->data_size == info->chunk_size * 2) {
+				ext_cmd_type = EXT_CMD_TYPE_LAST_PAGEPROG;
+				info->oob_size = oob_size;
+			} else {
+				ext_cmd_type = EXT_CMD_TYPE_CHUNK_PAGEPROG;
+			}
+		}
+	} while (1);
+
+berlin_timeout:
+	info->state = STATE_IDLE;
+}
+
 static int pxa3xx_nand_read_page_hwecc(struct mtd_info *mtd,
 		struct nand_chip *chip, uint8_t *buf, int oob_required,
 		int page)
@@ -1193,8 +1407,10 @@ static int pxa3xx_nand_config_flash(struct pxa3xx_nand_info *info,
 	struct pxa3xx_nand_host *host = info->host[info->cs];
 	uint32_t ndcr = 0x0; /* enable all interrupts */
 
-	if (f->page_size != 2048 && f->page_size != 512) {
-		dev_err(&pdev->dev, "Current only support 2048 and 512 size\n");
+	if (f->page_size != 8192 && f->page_size != 2048
+			&& f->page_size != 512) {
+		dev_err(&pdev->dev,
+			"Current only support 8192, 2048 and 512 size\n");
 		return -EINVAL;
 	}
 
@@ -1401,6 +1617,16 @@ static int pxa_ecc_init(struct pxa3xx_nand_info *info,
 		ecc->size = info->chunk_size;
 		ecc->layout = &ecc_layout_4KB_bch8bit;
 		ecc->strength = 16;
+	} else if (strength == 48 && ecc_stepsize == 1024 &&
+			page_size == 8192) {
+		info->ecc_bch = 1;
+		info->chunk_size = 2048;
+		info->spare_size = 0;
+		info->ecc_size = 32;
+		ecc->mode = NAND_ECC_HW;
+		ecc->size = info->chunk_size;
+		ecc->layout = &ecc_layout_oob_128;
+		ecc->strength = 48;
 	} else {
 		dev_err(&info->pdev->dev,
 			"ECC strength %d at page size %d is not supported\n",
@@ -1420,11 +1646,11 @@ static int pxa3xx_nand_scan(struct mtd_info *mtd)
 	struct platform_device *pdev = info->pdev;
 	struct pxa3xx_nand_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct nand_flash_dev pxa3xx_flash_ids[2], *def = NULL;
-	const struct pxa3xx_nand_flash *f = NULL;
+	const struct pxa3xx_nand_flash *flash_types = NULL, *f = NULL;
 	struct nand_chip *chip = mtd->priv;
 	uint32_t id = -1;
 	uint64_t chipsize;
-	int i, ret, num;
+	int i, ret;
 	uint16_t ecc_strength, ecc_step;
 
 	if (pdata->keep_config && !pxa3xx_nand_detect_config(info))
@@ -1433,6 +1659,9 @@ static int pxa3xx_nand_scan(struct mtd_info *mtd)
 	/* Set a default chunk size */
 	info->chunk_size = 512;
 
+	if (info->variant == PXA3XX_NAND_VARIANT_BERLIN2)
+		chip->cmdfunc = nand_cmdfunc_berlin;
+
 	ret = pxa3xx_nand_sensing(info);
 	if (ret) {
 		dev_info(&info->pdev->dev, "There is no chip on cs %d!\n",
@@ -1452,19 +1681,24 @@ static int pxa3xx_nand_scan(struct mtd_info *mtd)
 		return -EINVAL;
 	}
 
-	num = ARRAY_SIZE(builtin_flash_types) + pdata->num_flash - 1;
-	for (i = 0; i < num; i++) {
-		if (i < pdata->num_flash)
-			f = pdata->flash + i;
-		else
-			f = &builtin_flash_types[i - pdata->num_flash + 1];
+	if (info->variant == PXA3XX_NAND_VARIANT_BERLIN2)
+		flash_types = berlin_builtin_flash_types;
+	else
+		flash_types = builtin_flash_types;
 
-		/* find the chip in default list */
+	for (i = 0; (f = &flash_types[i]); i++)
 		if (f->chip_id == id)
 			break;
+
+	if (f == NULL) {
+		for (i = 0; i < pdata->num_flash; i++) {
+			f = pdata->flash + i;
+			if (f->chip_id == id)
+				break;
+		}
 	}
 
-	if (i >= (ARRAY_SIZE(builtin_flash_types) + pdata->num_flash - 1)) {
+	if (f == NULL) {
 		dev_err(&info->pdev->dev, "ERROR!! flash not defined!!!\n");
 
 		return -EINVAL;
@@ -1515,7 +1749,8 @@ KEEP_CONFIG:
 	 * we are given the right variant and then switch to the extended
 	 * (aka splitted) command handling,
 	 */
-	if (mtd->writesize > PAGE_CHUNK_SIZE) {
+	if (mtd->writesize > PAGE_CHUNK_SIZE &&
+			info->variant != PXA3XX_NAND_VARIANT_BERLIN2) {
 		if (info->variant == PXA3XX_NAND_VARIANT_ARMADA370) {
 			chip->cmdfunc = nand_cmdfunc_extended;
 		} else {
-- 
2.2.2

