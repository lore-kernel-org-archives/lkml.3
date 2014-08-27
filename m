Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301AbaH0MnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 08:43:04 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:65161 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933994AbaH0Mm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 08:42:58 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: [PATCH 8/9] mtd: nand: stm_nand_bch: add support for ST's BCH NAND controller
Date: Wed, 27 Aug 2014 13:42:23 +0100
Message-Id: <1409143344-22458-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409143344-22458-1-git-send-email-lee.jones@linaro.org>
References: <1409143344-22458-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-By: Pekon Gupta <pekon@pek-sem.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/Kconfig        |    7 +
 drivers/mtd/nand/Makefile       |    1 +
 drivers/mtd/nand/stm_nand_bch.c | 1616 +++++++++++++++++++++++++++++++++++++++
 drivers/mtd/nand/stm_nand_dt.c  |  110 +++
 drivers/mtd/nand/stm_nand_dt.h  |   24 +
 include/linux/mtd/stm_nand.h    |  147 ++++
 6 files changed, 1905 insertions(+)
 create mode 100644 drivers/mtd/nand/stm_nand_bch.c
 create mode 100644 drivers/mtd/nand/stm_nand_dt.c
 create mode 100644 drivers/mtd/nand/stm_nand_dt.h
 create mode 100644 include/linux/mtd/stm_nand.h

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index f1cf503..2738eec 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -513,4 +513,11 @@ config MTD_NAND_XWAY
 	  Enables support for NAND Flash chips on Lantiq XWAY SoCs. NAND is attached
 	  to the External Bus Unit (EBU).
 
+config MTD_NAND_STM_BCH
+	tristate "STMicroelectronics: NANDi BCH Controller"
+	depends on ARCH_STI
+	depends on OF
+	help
+	  Adds support for the STMicroelectronics NANDi BCH Controller.
+
 endif # MTD_NAND
diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index a035e7c..60f374b 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_MTD_NAND_NUC900)		+= nuc900_nand.o
 obj-$(CONFIG_MTD_NAND_MPC5121_NFC)	+= mpc5121_nfc.o
 obj-$(CONFIG_MTD_NAND_RICOH)		+= r852.o
 obj-$(CONFIG_MTD_NAND_JZ4740)		+= jz4740_nand.o
+obj-$(CONFIG_MTD_NAND_STM_BCH)		+= stm_nand_bch.o stm_nand_dt.o
 obj-$(CONFIG_MTD_NAND_GPMI_NAND)	+= gpmi-nand/
 obj-$(CONFIG_MTD_NAND_XWAY)		+= xway_nand.o
 obj-$(CONFIG_MTD_NAND_BCM47XXNFLASH)	+= bcm47xxnflash/
diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
new file mode 100644
index 0000000..951567d
--- /dev/null
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -0,0 +1,1616 @@
+/*
+ * Support for STMicroelectronics NANDi BCH Controller
+ *
+ * Copyright (c) 2014 STMicroelectronics Limited
+ *
+ * Authors: Angus Clark <Angus.Clark@st.com>
+ *	    Lee Jones <lee.jones@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/completion.h>
+#include <linux/of_mtd.h>
+#include <linux/mtd/nand.h>
+#include <linux/mtd/stm_nand_bbt.h>
+#include <linux/mtd/stm_nand.h>
+#include <linux/mtd/partitions.h>
+
+#include "stm_nand_dt.h"
+#include "stm_nand_regs.h"
+
+/* NANDi BCH Controller properties */
+#define NANDI_BCH_SECTOR_SIZE			1024
+#define NANDI_BCH_DMA_ALIGNMENT			64
+#define NANDI_BCH_MAX_BUF_LIST			8
+#define NANDI_BCH_BUF_LIST_SIZE			(4 * NANDI_BCH_MAX_BUF_LIST)
+
+/* ONFI define 6 timing modes */
+#define ST_NAND_ONFI_TIMING_MODES		6
+
+#define PICO_TO_MILI(pico)			(pico / 1000)
+
+static int bch_ecc_strength[] = {
+	[BCH_18BIT_ECC] = 18,
+	[BCH_30BIT_ECC] = 30,
+	[BCH_NO_ECC] = 0,
+};
+
+/* BCH 'program' structure */
+struct bch_prog {
+	u32	multi_cs_addr[3];
+	u32	multi_cs_config;
+	u8	seq[16];
+	u32	addr;
+	u32	extra;
+	u8	cmd[4];
+	u32	reserved1;
+	u32	gen_cfg;
+	u32	delay;
+	u32	reserved2;
+	u32	seq_cfg;
+};
+
+/* BCH template programs (modified on-the-fly) */
+static struct bch_prog bch_prog_read_page = {
+	.cmd = {
+		NAND_CMD_READ0,
+		NAND_CMD_READSTART,
+	},
+	.seq = {
+		BCH_ECC_SCORE(0),
+		BCH_CMD_ADDR,
+		BCH_CL_CMD_1,
+		BCH_DATA_2_SECTOR,
+		BCH_STOP,
+	},
+	.gen_cfg = (GEN_CFG_DATA_8_NOT_16 |
+		    GEN_CFG_EXTRA_ADD_CYCLE |
+		    GEN_CFG_LAST_SEQ_NODE),
+	.seq_cfg = SEQ_CFG_GO_STOP,
+};
+
+static struct bch_prog bch_prog_write_page = {
+	.cmd = {
+		NAND_CMD_SEQIN,
+		NAND_CMD_PAGEPROG,
+		NAND_CMD_STATUS,
+	},
+	.seq = {
+		BCH_CMD_ADDR,
+		BCH_DATA_4_SECTOR,
+		BCH_CL_CMD_1,
+		BCH_CL_CMD_2,
+		BCH_OP_ERR,
+		BCH_STOP,
+	},
+	.gen_cfg = (GEN_CFG_DATA_8_NOT_16 |
+		    GEN_CFG_EXTRA_ADD_CYCLE |
+		    GEN_CFG_LAST_SEQ_NODE),
+	.seq_cfg = (SEQ_CFG_GO_STOP |
+		    SEQ_CFG_DATA_WRITE),
+};
+
+static struct bch_prog bch_prog_erase_block = {
+	.seq = {
+		BCH_CL_CMD_1,
+		BCH_AL_EX_0,
+		BCH_AL_EX_1,
+		BCH_AL_EX_2,
+		BCH_CL_CMD_2,
+		BCH_CL_CMD_3,
+		BCH_OP_ERR,
+		BCH_STOP,
+	},
+	.cmd = {
+		NAND_CMD_ERASE1,
+		NAND_CMD_ERASE1,
+		NAND_CMD_ERASE2,
+		NAND_CMD_STATUS,
+	},
+	.gen_cfg = (GEN_CFG_DATA_8_NOT_16 |
+		    GEN_CFG_EXTRA_ADD_CYCLE |
+		    GEN_CFG_LAST_SEQ_NODE),
+	.seq_cfg = (SEQ_CFG_GO_STOP |
+		    SEQ_CFG_ERASE),
+};
+
+/* Configure BCH read/write/erase programs */
+static void bch_configure_progs(struct nandi_controller *nandi)
+{
+	uint8_t data_opa = ffs(nandi->sectors_per_page) - 1;
+	uint8_t data_instr = BCH_INSTR(BCH_OPC_DATA, data_opa);
+	uint32_t gen_cfg_ecc = nandi->bch_ecc_mode << GEN_CFG_ECC_SHIFT;
+
+	/* Set 'DATA' instruction */
+	bch_prog_read_page.seq[3] = data_instr;
+	bch_prog_write_page.seq[1] = data_instr;
+
+	/* Set ECC mode */
+	bch_prog_read_page.gen_cfg |= gen_cfg_ecc;
+	bch_prog_write_page.gen_cfg |= gen_cfg_ecc;
+	bch_prog_erase_block.gen_cfg |= gen_cfg_ecc;
+
+	/*
+	 * Template sequences above are defined for devices that use 5 address
+	 * cycles for page Read/Write operations (and 3 for Erase operations).
+	 * Update sequences for devices that use 4 address cycles.
+	 */
+	if (!nandi->extra_addr) {
+		/* Clear 'GEN_CFG_EXTRA_ADD_CYCLE' flag */
+		bch_prog_read_page.gen_cfg &= ~GEN_CFG_EXTRA_ADD_CYCLE;
+		bch_prog_write_page.gen_cfg &= ~GEN_CFG_EXTRA_ADD_CYCLE;
+		bch_prog_erase_block.gen_cfg &= ~GEN_CFG_EXTRA_ADD_CYCLE;
+
+		/* Configure Erase sequence for 2 address cycles */
+		/* (page address) */
+		bch_prog_erase_block.seq[0] = BCH_CL_CMD_1;
+		bch_prog_erase_block.seq[1] = BCH_AL_EX_0;
+		bch_prog_erase_block.seq[2] = BCH_AL_EX_1;
+		bch_prog_erase_block.seq[3] = BCH_CL_CMD_2;
+		bch_prog_erase_block.seq[4] = BCH_CL_CMD_3;
+		bch_prog_erase_block.seq[5] = BCH_OP_ERR;
+		bch_prog_erase_block.seq[6] = BCH_STOP;
+	}
+}
+
+/*
+ * NANDi Interrupts (shared by Hamming and BCH controllers)
+ */
+static irqreturn_t nandi_irq_handler(int irq, void *dev)
+{
+	struct nandi_controller *nandi = dev;
+	unsigned int status;
+
+	status = readl(nandi->base + NANDBCH_INT_STA);
+
+	if (nandi->bch_ecc_mode && (status & NANDBCH_INT_SEQNODESOVER)) {
+		/* BCH */
+		writel(NANDBCH_INT_CLR_SEQNODESOVER,
+		       nandi->base + NANDBCH_INT_CLR);
+		complete(&nandi->seq_completed);
+		return IRQ_HANDLED;
+	}
+	if (status & NAND_INT_RBN) {
+		/* Hamming */
+		writel(NAND_INT_CLR_RBN, nandi->base + NANDHAM_INT_CLR);
+		complete(&nandi->rbn_completed);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static void nandi_enable_interrupts(struct nandi_controller *nandi,
+				    uint32_t irqs)
+{
+	uint32_t val;
+
+	val = readl(nandi->base + NANDBCH_INT_EN);
+	val |= irqs;
+	writel(val, nandi->base + NANDBCH_INT_EN);
+}
+
+static void nandi_disable_interrupts(struct nandi_controller *nandi,
+				     uint32_t irqs)
+{
+	uint32_t val;
+
+	val = readl(nandi->base + NANDBCH_INT_EN);
+	val &= ~irqs;
+	writel(val, nandi->base + NANDBCH_INT_EN);
+}
+
+/*
+ * BCH Operations
+ */
+static inline void bch_load_prog_cpu(struct nandi_controller *nandi,
+				     struct bch_prog *prog)
+{
+	void __iomem *dst = nandi->base + NANDBCH_ADDRESS_REG_1;
+	uint32_t *src = (uint32_t *)prog;
+	int i;
+
+	for (i = 0; i < 16; i++) {
+		/* Skip registers marked as "reserved" */
+		if (i != 11 && i != 14)
+			writel(*src, dst);
+		src++;
+		dst += sizeof(uint32_t *);
+	}
+}
+
+static void bch_wait_seq(struct nandi_controller *nandi)
+{
+	int ret;
+
+	ret = wait_for_completion_timeout(&nandi->seq_completed, HZ/2);
+	if (!ret)
+		dev_err(nandi->dev, "BCH Seq timeout\n");
+}
+
+uint8_t bch_erase_block(struct nandi_controller *nandi,
+			loff_t offs)
+{
+	struct nand_chip *chip = &nandi->info.chip;
+	struct bch_prog *prog = &bch_prog_erase_block;
+	uint8_t status;
+
+	dev_dbg(nandi->dev, "%s: offs = 0x%012llx\n", __func__, offs);
+
+	prog->extra = (uint32_t)(offs >> chip->page_shift);
+
+	emiss_nandi_select(nandi, STM_NANDI_BCH);
+
+	nandi_enable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
+	reinit_completion(&nandi->seq_completed);
+
+	bch_load_prog_cpu(nandi, prog);
+
+	bch_wait_seq(nandi);
+
+	nandi_disable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
+
+	status = (uint8_t)(readl(nandi->base +
+				 NANDBCH_CHECK_STATUS_REG_A) & 0xff);
+
+	return status;
+}
+EXPORT_SYMBOL(bch_erase_block);
+
+static int bch_erase(struct mtd_info *mtd, int page)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+	uint32_t page_size = mtd->writesize;
+	loff_t offs = (loff_t)page * page_size;
+
+	return bch_erase_block(nandi, offs);
+}
+
+/*
+ * Detect an erased page, tolerating and correcting up to a specified number of
+ * bits at '0'.  (For many devices, it is now deemed within spec for an erased
+ * page to include a number of bits at '0', either as a result of read-disturb
+ * behaviour or 'stuck-at-zero' failures.)  Returns the number of corrected
+ * bits, or a '-1' if we have exceeded the maximum number of bits at '0' (likely
+ * to be a genuine uncorrectable ECC error).  In the latter case, the data must
+ * be returned unmodified, in accordance with the MTD API.
+ */
+static int check_erased_page(uint8_t *data, uint32_t page_size, int max_zeros)
+{
+	uint8_t *b = data;
+	int zeros = 0;
+	int i;
+
+	for (i = 0; i < page_size; i++) {
+		zeros += hweight8(~*b++);
+		if (zeros > max_zeros)
+			return -1;
+	}
+
+	if (zeros)
+		memset(data, 0xff, page_size);
+
+	return zeros;
+}
+
+/* Returns the number of ECC errors, or '-1' for uncorrectable error */
+int bch_read_page(struct nandi_controller *nandi,
+		  loff_t offs,
+		  uint8_t *buf)
+{
+	struct nand_chip *chip = &nandi->info.chip;
+	struct bch_prog *prog = &bch_prog_read_page;
+	uint32_t page_size = nandi->info.mtd.writesize;
+	unsigned long list_phys;
+	unsigned long buf_phys;
+	uint32_t ecc_err;
+	int ret = 0;
+
+	dev_dbg(nandi->dev, "%s: offs = 0x%012llx\n", __func__, offs);
+
+	BUG_ON(offs & (NANDI_BCH_DMA_ALIGNMENT - 1));
+
+	emiss_nandi_select(nandi, STM_NANDI_BCH);
+
+	nandi_enable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
+	reinit_completion(&nandi->seq_completed);
+
+	/* Reset ECC stats */
+	writel(CFG_RESET_ECC_ALL | CFG_ENABLE_AFM,
+	       nandi->base + NANDBCH_CONTROLLER_CFG);
+	writel(CFG_ENABLE_AFM, nandi->base + NANDBCH_CONTROLLER_CFG);
+
+	prog->addr = (uint32_t)((offs >> (chip->page_shift - 8)) & 0xffffff00);
+
+	buf_phys = dma_map_single(NULL, buf, page_size, DMA_FROM_DEVICE);
+
+	memset(nandi->buf_list, 0x00, NANDI_BCH_BUF_LIST_SIZE);
+	nandi->buf_list[0] = buf_phys | (nandi->sectors_per_page - 1);
+
+	list_phys = dma_map_single(NULL, nandi->buf_list,
+				   NANDI_BCH_BUF_LIST_SIZE, DMA_TO_DEVICE);
+
+	writel(list_phys, nandi->base + NANDBCH_BUFFER_LIST_PTR);
+
+	bch_load_prog_cpu(nandi, prog);
+
+	bch_wait_seq(nandi);
+
+	nandi_disable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
+
+	dma_unmap_single(NULL, list_phys, NANDI_BCH_BUF_LIST_SIZE,
+			 DMA_TO_DEVICE);
+	dma_unmap_single(NULL, buf_phys, page_size, DMA_FROM_DEVICE);
+
+	/* Use the maximum per-sector ECC count! */
+	ecc_err = readl(nandi->base + NANDBCH_ECC_SCORE_REG_A) & 0xff;
+	if (ecc_err == 0xff) {
+		/*
+		 * Downgrade uncorrectable ECC error for an erased page,
+		 * tolerating 'bch_ecc_strength' bits at zero.
+		 */
+		ret = check_erased_page(buf, page_size, chip->ecc.strength);
+		if (ret >= 0)
+			dev_dbg(nandi->dev,
+				"%s: erased page detected: \n"
+				"  downgrading uncorrectable ECC error.\n",
+				__func__);
+	} else {
+		ret = (int)ecc_err;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(bch_read_page);
+
+static int bch_read(struct mtd_info *mtd, struct nand_chip *chip,
+			 uint8_t *buf, int oob_required, int page)
+{
+	struct nandi_controller *nandi = chip->priv;
+	uint32_t page_size = mtd->writesize;
+	loff_t offs = (loff_t)page * page_size;
+	bool bounce = false;
+	uint8_t *p;
+	int ret;
+
+	if (((unsigned int)buf & (NANDI_BCH_DMA_ALIGNMENT - 1)) ||
+	    (!virt_addr_valid(buf))) /* vmalloc'd buffer! */
+		bounce = true;
+
+	p = bounce ? nandi->page_buf : buf;
+
+	ret = bch_read_page(nandi, offs, p);
+	if (ret < 0)
+		mtd->ecc_stats.failed++;
+	else
+		mtd->ecc_stats.corrected += ret;
+
+	if (bounce)
+		memcpy(buf, p, page_size);
+
+	return ret;
+}
+
+/* Returns the status of the NAND device following the write operation */
+uint8_t bch_write_page(struct nandi_controller *nandi,
+		       loff_t offs, const uint8_t *buf)
+{
+	struct nand_chip *chip = &nandi->info.chip;
+	struct bch_prog *prog = &bch_prog_write_page;
+	uint32_t page_size = nandi->info.mtd.writesize;
+	uint8_t *p = (uint8_t *)buf;
+	unsigned long list_phys;
+	unsigned long buf_phys;
+	uint8_t status;
+	bool bounce = false;
+
+	dev_dbg(nandi->dev, "%s: offs = 0x%012llx\n", __func__, offs);
+
+	BUG_ON(offs & (page_size - 1));
+
+	if (((unsigned long)buf & (NANDI_BCH_DMA_ALIGNMENT - 1)) ||
+	    !virt_addr_valid(buf)) { /* vmalloc'd buffer! */
+		bounce = true;
+	}
+
+	if (bounce) {
+		memcpy(nandi->page_buf, buf, page_size);
+		p = nandi->page_buf;
+		nandi->cached_page = -1;
+	}
+
+	emiss_nandi_select(nandi, STM_NANDI_BCH);
+
+	nandi_enable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
+	reinit_completion(&nandi->seq_completed);
+
+	prog->addr = (uint32_t)((offs >> (chip->page_shift - 8)) & 0xffffff00);
+
+	buf_phys = dma_map_single(NULL, p, page_size, DMA_TO_DEVICE);
+	memset(nandi->buf_list, 0x00, NANDI_BCH_BUF_LIST_SIZE);
+	nandi->buf_list[0] = buf_phys | (nandi->sectors_per_page - 1);
+
+	list_phys = dma_map_single(NULL, nandi->buf_list,
+				   NANDI_BCH_BUF_LIST_SIZE, DMA_TO_DEVICE);
+
+	writel(list_phys, nandi->base + NANDBCH_BUFFER_LIST_PTR);
+
+	bch_load_prog_cpu(nandi, prog);
+
+	bch_wait_seq(nandi);
+
+	nandi_disable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
+
+	dma_unmap_single(NULL, list_phys, NANDI_BCH_BUF_LIST_SIZE,
+			 DMA_TO_DEVICE);
+	dma_unmap_single(NULL, buf_phys, page_size, DMA_FROM_DEVICE);
+
+	status = (uint8_t)(readl(nandi->base +
+				 NANDBCH_CHECK_STATUS_REG_A) & 0xff);
+
+	return status;
+}
+EXPORT_SYMBOL(bch_write_page);
+
+static int bch_write(struct mtd_info *mtd, struct nand_chip *chip,
+		     uint32_t offset, int data_len, const uint8_t *buf,
+		     int oob_required, int page, int cached, int raw)
+{
+	struct nandi_controller *nandi = chip->priv;
+	uint32_t page_size = mtd->writesize;
+	loff_t offs = (loff_t)page * page_size;
+	int ret;
+
+	ret = bch_write_page(nandi, offs, buf);
+	if (ret & NAND_STATUS_FAIL)
+		return -EIO;
+
+	return 0;
+}
+
+/*
+ * Hamming-FLEX operations
+ */
+static int flex_wait_rbn(struct nandi_controller *nandi)
+{
+	int ret;
+
+	ret = wait_for_completion_timeout(&nandi->rbn_completed, HZ/2);
+	if (!ret)
+		dev_err(nandi->dev, "FLEX RBn timeout\n");
+
+	return ret;
+}
+
+static void flex_cmd(struct nandi_controller *nandi, uint8_t cmd)
+{
+	uint32_t val;
+
+	val = (FLEX_CMD_CSN | FLEX_CMD_BEATS_1 | cmd);
+	writel(val, nandi->base + NANDHAM_FLEX_CMD);
+}
+
+static void flex_addr(struct nandi_controller *nandi,
+		      uint32_t addr, int cycles)
+{
+	addr &= 0x00ffffff;
+
+	BUG_ON(cycles < 1);
+	BUG_ON(cycles > 3);
+
+	addr |= (FLEX_ADDR_CSN | FLEX_ADDR_ADD8_VALID);
+	addr |= (cycles & 0x3) << 28;
+
+	writel(addr, nandi->base + NANDHAM_FLEX_ADD);
+}
+
+/*
+ * Partial implementation of MTD/NAND Interface, based on Hamming-FLEX
+ * operation.
+ *
+ * Allows us to make use of nand_base.c functions where possible
+ * (e.g. nand_scan_ident() and friends).
+ */
+static void flex_command_lp(struct mtd_info *mtd, unsigned int command,
+			    int column, int page)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+
+	emiss_nandi_select(nandi, STM_NANDI_HAMMING);
+
+	switch (command) {
+	case NAND_CMD_READOOB:
+		/* Emulate NAND_CMD_READOOB */
+		column += mtd->writesize;
+		command = NAND_CMD_READ0;
+		break;
+	case NAND_CMD_READ0:
+	case NAND_CMD_ERASE1:
+	case NAND_CMD_SEQIN:
+	case NAND_CMD_RESET:
+	case NAND_CMD_PARAM:
+		/* Prime RBn wait */
+		nandi_enable_interrupts(nandi, NAND_INT_RBN);
+		reinit_completion(&nandi->rbn_completed);
+		break;
+	case NAND_CMD_READID:
+	case NAND_CMD_STATUS:
+	case NAND_CMD_ERASE2:
+		break;
+	default:
+		/* Catch unexpected commands */
+		BUG();
+	}
+
+	/*
+	 * Command Cycle
+	 */
+	flex_cmd(nandi, command);
+
+	/*
+	 * Address Cycles
+	 */
+	if (column != -1)
+		flex_addr(nandi, column,
+			  (command == NAND_CMD_READID) ? 1 : 2);
+
+	if (page != -1)
+		flex_addr(nandi, page, nandi->extra_addr ? 3 : 2);
+
+	/* Complete 'READ0' command */
+	if (command == NAND_CMD_READ0)
+		flex_cmd(nandi, NAND_CMD_READSTART);
+
+	/* Wait for RBn, if required                        */
+	/* (Note, other commands may handle wait elsewhere) */
+	if (command == NAND_CMD_RESET ||
+	    command == NAND_CMD_READ0 ||
+	    command == NAND_CMD_PARAM) {
+		flex_wait_rbn(nandi);
+		nandi_disable_interrupts(nandi, NAND_INT_RBN);
+	}
+}
+
+static uint8_t flex_read_byte(struct mtd_info *mtd)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+
+	emiss_nandi_select(nandi, STM_NANDI_HAMMING);
+
+	return (uint8_t)(readl(nandi->base + NANDHAM_FLEX_DATA) & 0xff);
+}
+
+static int flex_wait_func(struct mtd_info *mtd, struct nand_chip *chip)
+{
+	struct nandi_controller *nandi = chip->priv;
+
+	emiss_nandi_select(nandi, STM_NANDI_HAMMING);
+
+	flex_wait_rbn(nandi);
+
+	flex_cmd(nandi, NAND_CMD_STATUS);
+
+	return (int)(readl(nandi->base + NANDHAM_FLEX_DATA) & 0xff);
+}
+
+/* Multi-CS devices not supported */
+static void flex_select_chip(struct mtd_info *mtd, int chipnr)
+{
+
+}
+
+static void flex_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+	int aligned;
+
+	emiss_nandi_select(nandi, STM_NANDI_HAMMING);
+
+	/* Read bytes until buf is 4-byte aligned */
+	while (len && ((unsigned int)buf & 0x3)) {
+		*buf++ = (uint8_t)(readl(nandi->base + NANDHAM_FLEX_DATA)
+				   & 0xff);
+		len--;
+	};
+
+	/* Use 'BEATS_4'/readsl */
+	if (len > 8) {
+		aligned = len & ~0x3;
+		writel(FLEX_DATA_CFG_BEATS_4 | FLEX_DATA_CFG_CSN,
+		       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
+
+		readsl(nandi->base + NANDHAM_FLEX_DATA, buf, aligned >> 2);
+
+		buf += aligned;
+		len -= aligned;
+
+		writel(FLEX_DATA_CFG_BEATS_1 | FLEX_DATA_CFG_CSN,
+		       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
+	}
+
+	/* Mop up remaining bytes */
+	while (len > 0) {
+		*buf++ = (uint8_t)(readl(nandi->base + NANDHAM_FLEX_DATA)
+				   & 0xff);
+		len--;
+	}
+}
+
+static void flex_write_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+	int aligned;
+
+	/* Write bytes until buf is 4-byte aligned */
+	while (len && ((unsigned int)buf & 0x3)) {
+		writel(*buf++, nandi->base + NANDHAM_FLEX_DATA);
+		len--;
+	};
+
+	/* USE 'BEATS_4/writesl */
+	if (len > 8) {
+		aligned = len & ~0x3;
+		writel(FLEX_DATA_CFG_BEATS_4 | FLEX_DATA_CFG_CSN,
+		       nandi->base + NANDHAM_FLEX_DATAWRITE_CONFIG);
+		writesl(nandi->base + NANDHAM_FLEX_DATA, buf, aligned >> 2);
+		buf += aligned;
+		len -= aligned;
+		writel(FLEX_DATA_CFG_BEATS_1 | FLEX_DATA_CFG_CSN,
+		       nandi->base + NANDHAM_FLEX_DATAWRITE_CONFIG);
+	}
+
+	/* Mop up remaining bytes */
+	while (len > 0) {
+		writel(*buf++, nandi->base + NANDHAM_FLEX_DATA);
+		len--;
+	}
+}
+
+int flex_read_raw(struct nandi_controller *nandi,
+			 uint32_t page_addr,
+			 uint32_t col_addr,
+			 uint8_t *buf, uint32_t len)
+{
+	dev_dbg(nandi->dev, "%s %u bytes at [0x%06x,0x%04x]\n",
+		__func__, len, page_addr, col_addr);
+
+	BUG_ON(len & 0x3);
+	BUG_ON((unsigned long)buf & 0x3);
+
+	emiss_nandi_select(nandi, STM_NANDI_HAMMING);
+	nandi_enable_interrupts(nandi, NAND_INT_RBN);
+	reinit_completion(&nandi->rbn_completed);
+
+	writel(FLEX_DATA_CFG_BEATS_4 | FLEX_DATA_CFG_CSN,
+	       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
+
+	flex_cmd(nandi, NAND_CMD_READ0);
+	flex_addr(nandi, col_addr, 2);
+	flex_addr(nandi, page_addr, nandi->extra_addr ? 3 : 2);
+	flex_cmd(nandi, NAND_CMD_READSTART);
+
+	flex_wait_rbn(nandi);
+
+	readsl(nandi->base + NANDHAM_FLEX_DATA, buf, len / 4);
+
+	nandi_disable_interrupts(nandi, NAND_INT_RBN);
+
+	writel(FLEX_DATA_CFG_BEATS_1 | FLEX_DATA_CFG_CSN,
+	       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
+
+	return 0;
+}
+EXPORT_SYMBOL(flex_read_raw);
+
+static int bch_mtd_read_oob(struct mtd_info *mtd,
+			    struct nand_chip *chip, int page)
+{
+	BUG();
+	return 0;
+}
+
+static int bch_mtd_write_oob(struct mtd_info *mtd,
+			     struct nand_chip *chip, int page)
+{
+	BUG();
+	return 0;
+}
+
+static int bch_read_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
+			     uint8_t *buf, int oob_required, int page)
+{
+	BUG();
+	return 0;
+}
+
+static int bch_write_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
+			      const uint8_t *buf, int oob_required)
+{
+	BUG();
+	return 0;
+}
+
+static void bch_hwctl(struct mtd_info *mtd, int mode)
+{
+	BUG();
+}
+
+static int bch_calculate(struct mtd_info *mtd, const uint8_t *dat,
+			 uint8_t *ecc_code)
+{
+	BUG();
+	return 0;
+}
+
+static int bch_correct(struct mtd_info *mtd, uint8_t *dat, uint8_t *read_ecc,
+		       uint8_t *calc_ecc)
+{
+	BUG();
+	return 0;
+}
+
+/*
+ * Initialisation
+ */
+static int bch_check_compatibility(struct nandi_controller *nandi,
+				   struct mtd_info *mtd,
+				   struct nand_chip *chip)
+{
+	if (chip->bits_per_cell > 1)
+		dev_warn(nandi->dev, "MLC NAND not fully supported\n");
+
+	if (chip->options & NAND_BUSWIDTH_16) {
+		dev_err(nandi->dev, "x16 NAND not supported\n");
+		return false;
+	}
+
+	if (nandi->blocks_per_device / 4 > mtd->writesize) {
+		/* Need to implement multi-page BBT support... */
+		dev_err(nandi->dev, "BBT too big to fit in single page\n");
+		return false;
+	}
+
+	if (bch_ecc_sizes[nandi->bch_ecc_mode] * nandi->sectors_per_page >
+	    mtd->oobsize) {
+		dev_err(nandi->dev, "insufficient OOB for selected ECC\n");
+		return false;
+	}
+
+	return true;
+}
+
+/* Select strongest ECC scheme compatible with OOB size */
+static int bch_set_ecc_auto(struct nandi_controller *nandi,
+			    struct mtd_info *mtd)
+{
+	int oob_bytes_per_sector = mtd->oobsize / nandi->sectors_per_page;
+	int try_ecc_modes[] = { BCH_30BIT_ECC, BCH_18BIT_ECC, -1 };
+	int m, ecc_mode;
+
+	for (m = 0; try_ecc_modes[m] >= 0; m++) {
+		ecc_mode = try_ecc_modes[m];
+		if (oob_bytes_per_sector >= bch_ecc_sizes[ecc_mode]) {
+			nandi->bch_ecc_mode = ecc_mode;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
+				   struct mtd_info *mtd, struct nand_chip *chip)
+{
+	struct nandi_info *info = &nandi->info;
+	int i;
+
+	/* ecclayout */
+	info->ecclayout.eccbytes = mtd->oobsize;
+	for (i = 0; i < 64; i++)
+		info->ecclayout.eccpos[i] = i;
+	info->ecclayout.oobfree[0].offset = 0;
+	info->ecclayout.oobfree[0].length = 0;
+	chip->ecc.mode = NAND_ECC_HW;
+
+	/* nand_chip */
+	chip->controller = &chip->hwcontrol;
+	spin_lock_init(&chip->controller->lock);
+	init_waitqueue_head(&chip->controller->wq);
+	chip->state = FL_READY;
+	chip->priv = nandi;
+	chip->ecc.layout = &info->ecclayout;
+	chip->options |= NAND_NO_SUBPAGE_WRITE;
+
+	chip->cmdfunc = flex_command_lp;
+	chip->read_byte = flex_read_byte;
+	chip->select_chip = flex_select_chip;
+	chip->waitfunc = flex_wait_func;
+	chip->read_buf = flex_read_buf;
+	chip->write_buf = flex_write_buf;
+
+	chip->bbt_options |= NAND_BBT_USE_FLASH;
+
+	/* mtd_info */
+	mtd->owner = THIS_MODULE;
+	mtd->type = MTD_NANDFLASH;
+	mtd->flags = MTD_CAP_NANDFLASH;
+	mtd->ecclayout = &info->ecclayout;
+
+	chip->ecc.hwctl = bch_hwctl;
+	chip->ecc.calculate = bch_calculate;
+	chip->ecc.correct = bch_correct;
+
+	chip->ecc.read_oob = bch_mtd_read_oob;
+	chip->ecc.write_oob = bch_mtd_write_oob;
+
+	chip->ecc.read_page = bch_read;
+	chip->ecc.read_page_raw = bch_read_page_raw;
+	chip->ecc.write_page_raw = bch_write_page_raw;
+	chip->write_page = bch_write;
+	chip->erase = bch_erase;
+
+#ifdef CONFIG_MTD_NAND_STM_BCH_BBT
+	chip->scan_bbt = bch_scan_bbt;
+	chip->block_bad = bch_block_isbad;
+	chip->block_markbad = bch_block_markbad;
+#endif
+}
+
+/*
+ * Timing and Clocks
+ */
+
+static void nandi_clk_enable(struct nandi_controller *nandi)
+{
+	clk_prepare_enable(nandi->emi_clk);
+	clk_prepare_enable(nandi->bch_clk);
+}
+
+static void nandi_clk_disable(struct nandi_controller *nandi)
+{
+	clk_disable_unprepare(nandi->emi_clk);
+	clk_disable_unprepare(nandi->bch_clk);
+}
+
+static struct clk *nandi_clk_setup(struct nandi_controller *nandi,
+				   char *clkname)
+{
+	struct clk *clk;
+	int ret;
+
+	clk = devm_clk_get(nandi->dev, clkname);
+	if (IS_ERR_OR_NULL(clk)) {
+		dev_warn(nandi->dev, "Failed to get %s clock\n", clkname);
+		return NULL;
+	}
+
+	ret = clk_prepare_enable(clk);
+	if (ret) {
+		dev_warn(nandi->dev, "Failed to enable %s clock\n", clkname);
+		return NULL;
+	}
+
+	return clk;
+}
+
+/* Derive Hamming-FLEX timing register values from 'nand_sdr_timings' data */
+static void flex_calc_timing_registers(const struct nand_sdr_timings *spec,
+				       int tCLK, int relax,
+				       uint32_t *ctl_timing,
+				       uint32_t *wen_timing,
+				       uint32_t *ren_timing)
+{
+	int tMAX_HOLD;
+	int n_ctl_setup;
+	int n_ctl_hold;
+	int n_ctl_wb;
+
+	int tMAX_WEN_OFF;
+	int n_wen_on;
+	int n_wen_off;
+
+	int tMAX_REN_OFF;
+	int n_ren_on;
+	int n_ren_off;
+
+	/*
+	 * CTL_TIMING
+	 */
+
+	/*	- SETUP */
+	n_ctl_setup = (PICO_TO_MILI(spec->tCLS_min - spec->tWP_min)
+		       + tCLK - 1) / tCLK;
+	if (n_ctl_setup < 1)
+		n_ctl_setup = 1;
+	n_ctl_setup += relax;
+
+	/*	- HOLD */
+	tMAX_HOLD = spec->tCLH_min;
+	if (spec->tCH_min > tMAX_HOLD)
+		tMAX_HOLD = spec->tCH_min;
+	if (spec->tALH_min > tMAX_HOLD)
+		tMAX_HOLD = spec->tALH_min;
+	if (spec->tDH_min > tMAX_HOLD)
+		tMAX_HOLD = spec->tDH_min;
+	n_ctl_hold = (PICO_TO_MILI(tMAX_HOLD) + tCLK - 1) / tCLK + relax;
+
+	/*	- CE_deassert_hold = 0 */
+
+	/*	- WE_high_to_RBn_low */
+	n_ctl_wb = (PICO_TO_MILI(spec->tWB_max) + tCLK - 1) / tCLK;
+
+	*ctl_timing = ((n_ctl_setup & 0xff) |
+		       (n_ctl_hold & 0xff) << 8 |
+		       (n_ctl_wb & 0xff) << 24);
+
+	/*
+	 * WEN_TIMING
+	 */
+
+	/*	- ON */
+	n_wen_on = (PICO_TO_MILI(spec->tWH_min) + tCLK - 1) / tCLK + relax;
+
+	/*	- OFF */
+	tMAX_WEN_OFF = spec->tWC_min - spec->tWH_min;
+	if (spec->tWP_min > tMAX_WEN_OFF)
+		tMAX_WEN_OFF = spec->tWP_min;
+	n_wen_off = (PICO_TO_MILI(tMAX_WEN_OFF) + tCLK - 1) / tCLK + relax;
+
+	*wen_timing = ((n_wen_on & 0xff) |
+		       (n_wen_off & 0xff) << 8);
+
+	/*
+	 * REN_TIMING
+	 */
+
+	/*	- ON */
+	n_ren_on = (PICO_TO_MILI(spec->tREH_min) + tCLK - 1) / tCLK + relax;
+
+	/*	- OFF */
+	tMAX_REN_OFF = spec->tRC_min - spec->tREH_min;
+	if (spec->tRP_min > tMAX_REN_OFF)
+		tMAX_REN_OFF = spec->tRP_min;
+	if (spec->tREA_max > tMAX_REN_OFF)
+		tMAX_REN_OFF = spec->tREA_max;
+	n_ren_off = (PICO_TO_MILI(tMAX_REN_OFF) + tCLK - 1) / tCLK + 1 + relax;
+
+	*ren_timing = ((n_ren_on & 0xff) |
+		       (n_ren_off & 0xff) << 8);
+}
+
+/* Derive BCH timing register values from 'nand_sdr_timings' data */
+static void bch_calc_timing_registers(const struct nand_sdr_timings *spec,
+				      int tCLK, int relax,
+				      uint32_t *ctl_timing,
+				      uint32_t *wen_timing,
+				      uint32_t *ren_timing)
+{
+	int tMAX_HOLD;
+	int n_ctl_setup;
+	int n_ctl_hold;
+	int n_ctl_wb;
+
+	int n_wen_on;
+	int n_wen_off;
+	int wen_half_on;
+	int wen_half_off;
+
+	int tMAX_REN_ON;
+	int tMAX_CS_DEASSERT;
+	int n_d_latch;
+	int n_telqv;
+	int n_ren_on;
+	int n_ren_off;
+
+	/*
+	 * CTL_TIMING
+	 */
+
+	/*	- SETUP */
+	if (spec->tCLS_min > spec->tWP_min)
+		n_ctl_setup = (PICO_TO_MILI(spec->tCLS_min - spec->tWP_min)
+			       + tCLK - 1) / tCLK;
+	else
+		n_ctl_setup = 0;
+	n_ctl_setup += relax;
+
+	/*	- HOLD */
+	tMAX_HOLD = spec->tCLH_min;
+	if (spec->tCH_min > tMAX_HOLD)
+		tMAX_HOLD = spec->tCH_min;
+	if (spec->tALH_min > tMAX_HOLD)
+		tMAX_HOLD = spec->tALH_min;
+	if (spec->tDH_min > tMAX_HOLD)
+		tMAX_HOLD = spec->tDH_min;
+	n_ctl_hold = (PICO_TO_MILI(tMAX_HOLD) + tCLK - 1) / tCLK + relax;
+	/*	- CE_deassert_hold = 0 */
+
+	/*	- WE_high_to_RBn_low */
+	n_ctl_wb = (PICO_TO_MILI(spec->tWB_max) + tCLK - 1) / tCLK;
+
+	*ctl_timing = ((n_ctl_setup & 0xff) |
+		       (n_ctl_hold & 0xff) << 8 |
+		       (n_ctl_wb & 0xff) << 24);
+
+	/*
+	 * WEN_TIMING
+	 */
+
+	/*	- ON */
+	n_wen_on = (2 * PICO_TO_MILI(spec->tWH_min) + tCLK - 1) / tCLK;
+	wen_half_on = n_wen_on % 2;
+	n_wen_on /= 2;
+	n_wen_on += relax;
+
+	/*	- OFF */
+	n_wen_off = (2 * PICO_TO_MILI(spec->tWP_min) + tCLK - 1) / tCLK;
+	wen_half_off = n_wen_off % 2;
+	n_wen_off /= 2;
+	n_wen_off += relax;
+
+	*wen_timing = ((n_wen_on & 0xff) |
+		       (n_wen_off & 0xff) << 8 |
+		       (wen_half_on << 16) |
+		       (wen_half_off << 17));
+
+	/*
+	 * REN_TIMING
+	 */
+
+	/*	- ON */
+	tMAX_REN_ON = spec->tRC_min - spec->tRP_min;
+	if (spec->tREH_min > tMAX_REN_ON)
+		tMAX_REN_ON = spec->tREH_min;
+
+	n_ren_on = (2 * PICO_TO_MILI(tMAX_REN_ON) + tCLK - 1) / tCLK;
+	n_ren_on /= 2;
+	n_ren_on += relax;
+
+	/*	- OFF */
+	n_ren_off = (2 * PICO_TO_MILI(spec->tREA_max) + tCLK - 1) / tCLK;
+	n_ren_off /= 2;
+	n_ren_off += relax;
+
+	/*	- DATA_LATCH */
+	if (PICO_TO_MILI(spec->tREA_max) <=
+	    (PICO_TO_MILI(spec->tRP_min) - (2 * tCLK)))
+		n_d_latch = 0;
+	else if (PICO_TO_MILI(spec->tREA_max) <=
+		 (PICO_TO_MILI(spec->tRP_min) - tCLK))
+		n_d_latch = 1;
+	else if ((spec->tREA_max <= spec->tRP_min) &&
+		 (PICO_TO_MILI(spec->tRHOH_min) >= 2 * tCLK))
+		n_d_latch = 2;
+	else
+		n_d_latch = 3;
+
+	/*	- TELQV */
+	tMAX_CS_DEASSERT = spec->tCOH_min;
+	if (spec->tCHZ_max > tMAX_CS_DEASSERT)
+		tMAX_CS_DEASSERT = spec->tCHZ_max;
+
+	n_telqv = (PICO_TO_MILI(tMAX_CS_DEASSERT) + tCLK - 1) / tCLK;
+
+	*ren_timing = ((n_ren_on & 0xff) |
+		       (n_ren_off & 0xff) << 8 |
+		       (n_d_latch & 0x3) << 16 |
+		       (wen_half_on << 18) |
+		       (wen_half_off << 19) |
+		       (n_telqv & 0xff) << 24);
+}
+
+static void flex_configure_timing_registers(struct nandi_controller *nandi,
+					    const struct nand_sdr_timings *spec,
+					    int relax)
+{
+	uint32_t ctl_timing;
+	uint32_t wen_timing;
+	uint32_t ren_timing;
+	int emi_t_ns;
+
+	/* Select Hamming Controller */
+	emiss_nandi_select(nandi, STM_NANDI_HAMMING);
+
+	/* Get EMI clock (default 100MHz) */
+	if (nandi->emi_clk)
+		emi_t_ns = 1000000000UL / clk_get_rate(nandi->emi_clk);
+	else {
+		dev_warn(nandi->dev,
+			 "No EMI clock available; assuming default 100MHz\n");
+		emi_t_ns = 10;
+	}
+
+	/* Derive timing register values from specification */
+	flex_calc_timing_registers(spec, emi_t_ns, relax,
+				   &ctl_timing, &wen_timing, &ren_timing);
+
+	dev_dbg(nandi->dev,
+		"updating FLEX timing configuration [0x%08x, 0x%08x, 0x%08x]\n",
+		ctl_timing, wen_timing, ren_timing);
+
+	/* Program timing registers */
+	writel(ctl_timing, nandi->base + NANDHAM_CTL_TIMING);
+	writel(wen_timing, nandi->base + NANDHAM_WEN_TIMING);
+	writel(ren_timing, nandi->base + NANDHAM_REN_TIMING);
+}
+
+static void bch_configure_timing_registers(struct nandi_controller *nandi,
+					   const struct nand_sdr_timings *spec,
+					   int relax)
+{
+	uint32_t ctl_timing;
+	uint32_t wen_timing;
+	uint32_t ren_timing;
+	int bch_t_ns;
+
+	/* Select BCH Controller */
+	emiss_nandi_select(nandi, STM_NANDI_BCH);
+
+	/* Get BCH clock (default 200MHz) */
+	if (nandi->bch_clk)
+		bch_t_ns = 1000000000UL / clk_get_rate(nandi->bch_clk);
+	else {
+		dev_warn(nandi->dev,
+			 "No BCH clock available; assuming default 200MHz\n");
+		bch_t_ns = 5;
+	}
+
+	/* Derive timing register values from specification */
+	bch_calc_timing_registers(spec, bch_t_ns, relax,
+				  &ctl_timing, &wen_timing, &ren_timing);
+
+	dev_dbg(nandi->dev,
+		"updating BCH timing configuration [0x%08x, 0x%08x, 0x%08x]\n",
+		ctl_timing, wen_timing, ren_timing);
+
+	/* Program timing registers */
+	writel(ctl_timing, nandi->base + NANDBCH_CTL_TIMING);
+	writel(wen_timing, nandi->base + NANDBCH_WEN_TIMING);
+	writel(ren_timing, nandi->base + NANDBCH_REN_TIMING);
+}
+
+static void nandi_configure_timing_registers(struct nandi_controller *nandi,
+					const struct nand_sdr_timings *spec,
+					int relax)
+{
+	bch_configure_timing_registers(nandi, spec, relax);
+	flex_configure_timing_registers(nandi, spec, relax);
+}
+
+static void nandi_init_hamming(struct nandi_controller *nandi, int emi_bank)
+{
+	dev_dbg(nandi->dev, "%s\n", __func__);
+
+	emiss_nandi_select(nandi, STM_NANDI_HAMMING);
+
+	/* Reset and disable boot-mode controller */
+	writel(BOOT_CFG_RESET, nandi->base + NANDHAM_BOOTBANK_CFG);
+	udelay(1);
+	writel(0x00000000, nandi->base + NANDHAM_BOOTBANK_CFG);
+
+	/* Reset controller */
+	writel(CFG_RESET, nandi->base + NANDHAM_FLEXMODE_CFG);
+	udelay(1);
+	writel(0x00000000, nandi->base + NANDHAM_FLEXMODE_CFG);
+
+	/* Set EMI Bank */
+	writel(0x1 << emi_bank, nandi->base + NANDHAM_FLEX_MUXCTRL);
+
+	/* Enable FLEX mode */
+	writel(CFG_ENABLE_FLEX, nandi->base + NANDHAM_FLEXMODE_CFG);
+
+	/* Configure FLEX_DATA_READ/WRITE for 1-byte access */
+	writel(FLEX_DATA_CFG_BEATS_1 | FLEX_DATA_CFG_CSN,
+	       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
+	writel(FLEX_DATA_CFG_BEATS_1 | FLEX_DATA_CFG_CSN,
+	       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
+
+	/* RBn interrupt on rising edge */
+	writel(NAND_EDGE_CFG_RBN_RISING, nandi->base + NANDHAM_INT_EDGE_CFG);
+
+	/* Enable interrupts */
+	nandi_enable_interrupts(nandi, NAND_INT_ENABLE);
+}
+
+static void nandi_init_bch(struct nandi_controller *nandi, int emi_bank)
+{
+	dev_dbg(nandi->dev, "%s\n", __func__);
+
+	/* Initialise BCH Controller */
+	emiss_nandi_select(nandi, STM_NANDI_BCH);
+
+	/* Reset and disable boot-mode controller */
+	writel(BOOT_CFG_RESET, nandi->base + NANDBCH_BOOTBANK_CFG);
+	udelay(1);
+	writel(0x00000000, nandi->base + NANDBCH_BOOTBANK_CFG);
+
+	/* Reset AFM controller */
+	writel(CFG_RESET, nandi->base + NANDBCH_CONTROLLER_CFG);
+	udelay(1);
+	writel(0x00000000, nandi->base + NANDBCH_CONTROLLER_CFG);
+
+	/* Set EMI Bank */
+	writel(0x1 << emi_bank, nandi->base + NANDBCH_FLEX_MUXCTRL);
+
+	/* Reset ECC stats */
+	writel(CFG_RESET_ECC_ALL, nandi->base + NANDBCH_CONTROLLER_CFG);
+	udelay(1);
+
+	/* Enable AFM */
+	writel(CFG_ENABLE_AFM, nandi->base + NANDBCH_CONTROLLER_CFG);
+
+	/* Configure Read DMA Plugs (values supplied by Validation) */
+	writel(0x00000005, nandi->dma + EMISS_NAND_RD_DMA_PAGE_SIZE);
+	writel(0x00000005, nandi->dma + EMISS_NAND_RD_DMA_MAX_OPCODE_SIZE);
+	writel(0x00000002, nandi->dma + EMISS_NAND_RD_DMA_MIN_OPCODE_SIZE);
+	writel(0x00000001, nandi->dma + EMISS_NAND_RD_DMA_MAX_CHUNK_SIZE);
+	writel(0x00000000, nandi->dma + EMISS_NAND_RD_DMA_MAX_MESSAGE_SIZE);
+
+	/* Configure Write DMA Plugs (values supplied by Validation) */
+	writel(0x00000005, nandi->dma + EMISS_NAND_WR_DMA_PAGE_SIZE);
+	writel(0x00000005, nandi->dma + EMISS_NAND_WR_DMA_MAX_OPCODE_SIZE);
+	writel(0x00000002, nandi->dma + EMISS_NAND_WR_DMA_MIN_OPCODE_SIZE);
+	writel(0x00000001, nandi->dma + EMISS_NAND_WR_DMA_MAX_CHUNK_SIZE);
+	writel(0x00000000, nandi->dma + EMISS_NAND_WR_DMA_MAX_MESSAGE_SIZE);
+
+	nandi_enable_interrupts(nandi, NAND_INT_ENABLE);
+}
+
+static void nandi_init_controller(struct nandi_controller *nandi,
+				  int emi_bank)
+{
+	nandi_init_bch(nandi, emi_bank);
+	nandi_init_hamming(nandi, emi_bank);
+}
+
+/* Initialise working buffers, accomodating DMA alignment constraints */
+static int nandi_init_working_buffers(struct nandi_controller *nandi,
+				      struct nandi_bbt_info *bbt_info,
+				      struct mtd_info *mtd)
+{
+	uint32_t bbt_buf_size;
+	uint32_t buf_size;
+
+	/*	- Page and OOB */
+	buf_size = mtd->writesize + mtd->oobsize + NANDI_BCH_DMA_ALIGNMENT;
+
+	/*	- BBT data (page-size aligned) */
+	bbt_info->bbt_size = nandi->blocks_per_device >> 2; /* 2 bits/block */
+	bbt_buf_size = ALIGN(bbt_info->bbt_size, mtd->writesize);
+	buf_size += bbt_buf_size + NANDI_BCH_DMA_ALIGNMENT;
+
+	/*	- BCH BUF list */
+	buf_size += NANDI_BCH_BUF_LIST_SIZE + NANDI_BCH_DMA_ALIGNMENT;
+
+	/* Allocate bufffer */
+	nandi->buf = devm_kzalloc(nandi->dev, buf_size, GFP_KERNEL);
+	if (!nandi->buf) {
+		dev_err(nandi->dev, "failed to allocate working buffers\n");
+		return -ENOMEM;
+	}
+
+	/* Set/Align buffer pointers */
+	nandi->page_buf = PTR_ALIGN(nandi->buf, NANDI_BCH_DMA_ALIGNMENT);
+	nandi->oob_buf  = nandi->page_buf + mtd->writesize;
+	bbt_info->bbt   = PTR_ALIGN(nandi->oob_buf + mtd->oobsize,
+				    NANDI_BCH_DMA_ALIGNMENT);
+	nandi->buf_list = (uint32_t *)PTR_ALIGN(bbt_info->bbt + bbt_buf_size,
+						NANDI_BCH_DMA_ALIGNMENT);
+	nandi->cached_page = -1;
+
+	return 0;
+}
+
+static int remap_named_resource(struct platform_device *pdev,
+				char *name,
+				void __iomem **io_ptr)
+{
+	struct resource *res, *mem;
+	resource_size_t size;
+	void __iomem *p;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, name);
+	if (!res)
+		return -ENXIO;
+
+	size = resource_size(res);
+
+	mem = devm_request_mem_region(&pdev->dev, res->start, size, name);
+	if (!mem)
+		return -EBUSY;
+
+	p = devm_ioremap_nocache(&pdev->dev, res->start, size);
+	if (!p)
+		return -ENOMEM;
+
+	*io_ptr = p;
+
+	return 0;
+}
+
+static struct nandi_controller *
+nandi_init_resources(struct platform_device *pdev)
+{
+	struct stm_nand_bch_ddata *ddata = platform_get_drvdata(pdev);
+	struct nandi_controller *nandi;
+	int irq;
+	int err;
+
+	nandi = devm_kzalloc(&pdev->dev, sizeof(*nandi), GFP_KERNEL);
+	if (!nandi) {
+		dev_err(&pdev->dev,
+			"failed to allocate NANDi controller data\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	nandi->dev = &pdev->dev;
+
+	err = remap_named_resource(pdev, "emi_nand", &nandi->base);
+	if (err)
+		return ERR_PTR(err);
+
+	err = remap_named_resource(pdev, "emiss", &nandi->emiss);
+	if (err)
+		return ERR_PTR(err);
+
+	nandi->dma = nandi->emiss + EMISS_NAND_DMA;
+	nandi->emisscfg = nandi->emiss + EMISS_CFG;
+
+	irq = platform_get_irq_byname(pdev, "nand_irq");
+	if (irq < 0) {
+		dev_err(&pdev->dev, "failed to find IRQ resource\n");
+		return ERR_PTR(irq);
+	}
+
+	err = devm_request_irq(&pdev->dev, irq, nandi_irq_handler,
+			       IRQF_DISABLED, dev_name(&pdev->dev), nandi);
+	if (err) {
+		dev_err(&pdev->dev, "irq request failed\n");
+		return ERR_PTR(err);
+	}
+
+	nandi->emi_clk = nandi_clk_setup(nandi, "emi");
+	nandi->bch_clk = nandi_clk_setup(nandi, "bch");
+
+	ddata->nandi = nandi;
+
+	return nandi;
+}
+
+static void *stm_bch_dt_get_ddata(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct stm_nand_bch_ddata *ddata;
+	int ecc_strength;
+	int ret;
+
+	ddata = devm_kzalloc(&pdev->dev, sizeof(*ddata), GFP_KERNEL);
+	if (!ddata)
+		return ERR_PTR(-ENOMEM);
+
+	ecc_strength = of_get_nand_ecc_strength(np);
+	if (ecc_strength == 0)
+		ddata->bch_ecc_cfg = BCH_NO_ECC;
+	else if (ecc_strength == 18)
+		ddata->bch_ecc_cfg = BCH_18BIT_ECC;
+	else if (ecc_strength == 30)
+		ddata->bch_ecc_cfg = BCH_30BIT_ECC;
+	else
+		ddata->bch_ecc_cfg = BCH_ECC_AUTO;
+
+	ret = stm_of_get_nand_banks(&pdev->dev, np, &ddata->bank);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	return ddata;
+}
+
+static int stm_nand_bch_probe(struct platform_device *pdev)
+{
+	const char *part_probes[] = { "cmdlinepart", "ofpart", NULL, };
+	struct device_node *np = pdev->dev.of_node;
+	struct mtd_part_parser_data ppdata;
+	struct stm_nand_bch_ddata *ddata;
+	struct stm_nand_bank_data *bank;
+	struct nandi_bbt_info *bbt_info;
+	struct nandi_controller *nandi;
+	struct nandi_info *info;
+	struct nand_chip *chip;
+	struct mtd_info *mtd;
+	int compatible, err;
+
+	if (!np) {
+		dev_err(&pdev->dev, "DT node found\n");
+		return -EINVAL;
+	}
+
+	ddata = stm_bch_dt_get_ddata(pdev);
+	if (IS_ERR(ddata))
+		return PTR_ERR(ddata);
+
+	ppdata.of_node = stm_of_get_partitions_node(np, 0);
+
+	platform_set_drvdata(pdev, ddata);
+
+	nandi = nandi_init_resources(pdev);
+	if (IS_ERR(nandi)) {
+		dev_err(&pdev->dev, "failed to initialise NANDi resources\n");
+		return PTR_ERR(nandi);
+	}
+
+	init_completion(&nandi->seq_completed);
+	init_completion(&nandi->rbn_completed);
+
+	bank = ddata->bank;
+	if (bank)
+		nandi_init_controller(nandi, bank->csn);
+
+	info            = &nandi->info;
+	chip            = &info->chip;
+	bbt_info        = &info->bbt_info;
+	mtd             = &info->mtd;
+	mtd->priv       = chip;
+	mtd->name       = dev_name(&pdev->dev);
+	mtd->dev.parent = &pdev->dev;
+
+	nandi_set_mtd_defaults(nandi, mtd, chip);
+
+	err = nand_scan_ident(mtd, 1, NULL);
+	if (err)
+		return err;
+
+	/*
+	 * Configure timing registers
+	 */
+	if (bank && bank->timing_spec) {
+		dev_info(&pdev->dev, "Using platform timing data\n");
+		nandi_configure_timing_registers(nandi, bank->timing_spec,
+						 bank->timing_relax);
+	} else if (chip->onfi_version) {
+		int mode = fls(onfi_get_async_timing_mode(chip) - 1);
+		const struct nand_sdr_timings *spec =
+			onfi_async_timing_mode_to_sdr_timings(mode);
+
+		/* Modes 4 and 5 (EDO) are not supported on our H/W */
+		if (mode > 3)
+			mode = 3;
+
+		dev_info(&pdev->dev, "Using ONFI Timing Mode %d\n", mode);
+		nandi_configure_timing_registers(nandi,	spec,
+					bank ? bank->timing_relax : 0);
+	} else {
+		dev_warn(&pdev->dev, "No timing data available\n");
+	}
+
+	if (mtd->writesize < NANDI_BCH_SECTOR_SIZE) {
+		dev_err(nandi->dev,
+			"page size incompatible with BCH ECC sector\n");
+		return -EINVAL;
+	}
+
+	/* Derive some working variables */
+	nandi->sectors_per_page = mtd->writesize / NANDI_BCH_SECTOR_SIZE;
+	nandi->blocks_per_device = mtd->size >> chip->phys_erase_shift;
+	nandi->extra_addr = ((chip->chipsize >> chip->page_shift) >
+			     0x10000) ? true : false;
+	mtd->writebufsize = mtd->writesize;
+
+	/* Set ECC mode */
+	if (ddata->bch_ecc_cfg == BCH_ECC_AUTO) {
+		err = bch_set_ecc_auto(nandi, mtd);
+		if (err) {
+			dev_err(nandi->dev, "insufficient OOB for BCH ECC\n");
+			return err;
+		}
+	} else {
+		nandi->bch_ecc_mode = ddata->bch_ecc_cfg;
+	}
+
+	chip->ecc.size = NANDI_BCH_SECTOR_SIZE;
+	chip->ecc.bytes = mtd->oobsize;
+	chip->ecc.strength = bch_ecc_strength[nandi->bch_ecc_mode];
+
+	info->ecclayout.eccbytes =
+		nandi->sectors_per_page * bch_ecc_sizes[nandi->bch_ecc_mode];
+
+	compatible = bch_check_compatibility(nandi, mtd, chip);
+	if (!compatible) {
+		dev_err(nandi->dev,
+			"NAND device incompatible with NANDi/BCH Controller\n");
+		return -EINVAL;
+	}
+
+	/* Tune BCH programs according to device found and ECC mode */
+	bch_configure_progs(nandi);
+
+	err = nandi_init_working_buffers(nandi, bbt_info, mtd);
+	if (err)
+		return err;
+
+	err = nand_scan_tail(mtd);
+	if (err)
+		return err;
+
+#ifdef CONFIG_MTD_NAND_STM_BCH_BBT
+	nandi_dump_bad_blocks(nandi);
+#endif
+	/* Add partitions */
+	return mtd_device_parse_register(mtd, part_probes, &ppdata,
+					 bank ? bank->partitions : NULL,
+					 bank ? bank->nr_partitions : 0);
+}
+
+static int stm_nand_bch_remove(struct platform_device *pdev)
+{
+	struct stm_nand_bch_ddata *ddata = platform_get_drvdata(pdev);
+	struct nandi_controller *nandi = ddata->nandi;
+
+	nand_release(&nandi->info.mtd);
+
+	nandi_clk_disable(nandi);
+
+	return 0;
+}
+
+static int stm_nand_bch_suspend(struct device *dev)
+{
+	struct stm_nand_bch_ddata *ddata = dev_get_drvdata(dev);
+	struct nandi_controller *nandi = ddata->nandi;
+
+	nandi_clk_disable(nandi);
+
+	return 0;
+}
+static int stm_nand_bch_resume(struct device *dev)
+{
+	struct stm_nand_bch_ddata *ddata = dev_get_drvdata(dev);
+	struct nandi_controller *nandi = ddata->nandi;
+
+	nandi_clk_enable(nandi);
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(stm_nand_bch_pm_ops,
+			 stm_nand_bch_suspend,
+			 stm_nand_bch_resume);
+
+static struct of_device_id nand_bch_match[] = {
+	{ .compatible = "st,nand-bch", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, nand_bch_match);
+
+static struct platform_driver stm_nand_bch_driver = {
+	.probe	= stm_nand_bch_probe ,
+	.remove	= stm_nand_bch_remove,
+	.driver	= {
+		.name	= "stm-nand-bch",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(nand_bch_match),
+		.pm	= &stm_nand_bch_pm_ops,
+	},
+};
+module_platform_driver(stm_nand_bch_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Angus Clark");
+MODULE_DESCRIPTION("STM NAND BCH driver");
diff --git a/drivers/mtd/nand/stm_nand_dt.c b/drivers/mtd/nand/stm_nand_dt.c
new file mode 100644
index 0000000..9facad6
--- /dev/null
+++ b/drivers/mtd/nand/stm_nand_dt.c
@@ -0,0 +1,110 @@
+/*
+ * drivers/mtd/nand/stm_nand_dt.c
+ *
+ * Support for NANDi BCH Controller Device Tree component
+ *
+ * Copyright (c) 2014 STMicroelectronics Limited
+ * Author: Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/byteorder/generic.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_mtd.h>
+#include <linux/mtd/nand.h>
+#include <linux/mtd/stm_nand.h>
+
+#include "stm_nand_dt.h"
+#include "stm_nand_regs.h"
+
+/**
+* stm_of_get_partitions_node - get partitions node from stm-nand type devices.
+*
+* @dev		device pointer to use for devm allocations.
+* @np		device node of the driver.
+* @bank_nr	which bank number to use to get partitions.
+*
+* Returns a node pointer if found, with refcount incremented, use
+* of_node_put() on it when done.
+*
+*/
+struct device_node *stm_of_get_partitions_node(struct device_node *np,
+					       int bank_nr)
+{
+	struct device_node *banknp, *partsnp = NULL;
+	char name[10];
+
+	sprintf(name, "bank%d", bank_nr);
+	banknp = of_get_child_by_name(np, name);
+	if (banknp)
+		return NULL;
+
+	partsnp = of_get_child_by_name(banknp, "partitions");
+	of_node_put(banknp);
+
+	return partsnp;
+}
+EXPORT_SYMBOL(stm_of_get_partitions_node);
+
+/**
+ * stm_of_get_nand_banks - Get nand banks info from a given device node.
+ *
+ * @dev			device pointer to use for devm allocations.
+ * @np			device node of the driver.
+ * @banksptr		double pointer to banks which is allocated
+ *			and filled with bank data.
+ *
+ * Returns a count of banks found in the given device node.
+ *
+ */
+int stm_of_get_nand_banks(struct device *dev, struct device_node *np,
+			  struct stm_nand_bank_data **banksptr)
+{
+	struct stm_nand_bank_data *banks;
+	struct device_node *banknp;
+	int nr_banks = 0;
+
+	if (!np)
+		return -ENODEV;
+
+	nr_banks = of_get_child_count(np);
+	if (!nr_banks) {
+		dev_err(dev, "No NAND banks specified in DT: %s\n",
+		np->full_name);
+		return -EINVAL;
+	}
+
+	*banksptr = devm_kzalloc(dev, sizeof(*banks) * nr_banks, GFP_KERNEL);
+	banks = *banksptr;
+	banknp = NULL;
+
+	for_each_child_of_node(np, banknp) {
+		int bank = 0;
+
+		of_property_read_u32(banknp, "st,nand-csn", &banks[bank].csn);
+
+		if (of_get_nand_bus_width(banknp) == 16)
+			banks[bank].options |= NAND_BUSWIDTH_16;
+		if (of_get_nand_on_flash_bbt(banknp))
+			banks[bank].bbt_options |= NAND_BBT_USE_FLASH;
+
+		banks[bank].nr_partitions = 0;
+		banks[bank].partitions = NULL;
+
+		of_property_read_u32(banknp, "st,nand-timing-relax",
+				     &banks[bank].timing_relax);
+		bank++;
+	}
+
+	return nr_banks;
+}
+EXPORT_SYMBOL(stm_of_get_nand_banks);
diff --git a/drivers/mtd/nand/stm_nand_dt.h b/drivers/mtd/nand/stm_nand_dt.h
new file mode 100644
index 0000000..0d2b920
--- /dev/null
+++ b/drivers/mtd/nand/stm_nand_dt.h
@@ -0,0 +1,24 @@
+/*
+ * drivers/mtd/nand/stm_nand_dt.h
+ *
+ * Support for NANDi BCH Controller Device Tree component
+ *
+ * Copyright (c) 2014 STMicroelectronics Limited
+ * Author: Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef STM_NAND_DT_H
+#define STM_NAND_DT_H
+
+struct device_node *stm_of_get_partitions_node(struct device_node *np,
+					       int bank_nr);
+
+int stm_of_get_nand_banks(struct device *dev, struct device_node *np,
+				 struct stm_nand_bank_data **banksp);
+
+#endif /* STM_NAND_DT_H */
diff --git a/include/linux/mtd/stm_nand.h b/include/linux/mtd/stm_nand.h
new file mode 100644
index 0000000..c3c805f
--- /dev/null
+++ b/include/linux/mtd/stm_nand.h
@@ -0,0 +1,147 @@
+/*
+ * include/linux/mtd/stm_mtd.h
+ *
+ * Support for STMicroelectronics NAND Controllers
+ *
+ * Copyright (c) 2014 STMicroelectronics Limited
+ * Author: Angus Clark <Angus.Clark@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __LINUX_STM_NAND_H
+#define __LINUX_STM_NAND_H
+
+#include <linux/io.h>
+#include <linux/mtd/nand.h>
+
+/* ECC Modes */
+enum stm_nand_bch_ecc_config {
+	BCH_18BIT_ECC = 0,
+	BCH_30BIT_ECC,
+	BCH_NO_ECC,
+	BCH_ECC_RSRV,
+	BCH_ECC_AUTO,
+};
+
+/* Bad Block Table (BBT) */
+struct nandi_bbt_info {
+	uint32_t	bbt_size;		/* Size of bad-block table */
+	uint32_t	bbt_vers[2];		/* Version (Primary/Mirror) */
+	uint32_t	bbt_block[2];		/* Block No. (Primary/Mirror) */
+	uint8_t		*bbt;			/* Table data */
+};
+
+/* Collection of MTD/NAND device information */
+struct nandi_info {
+	struct mtd_info		mtd;		/* MTD info */
+	struct nand_chip	chip;		/* NAND chip info */
+
+	struct nand_ecclayout	ecclayout;	/* MTD ECC layout */
+	struct nandi_bbt_info	bbt_info;	/* Bad Block Table */
+	int			nr_parts;	/* Number of MTD partitions */
+	struct	mtd_partition	*parts;		/* MTD partitions */
+};
+
+/* NANDi Controller (Hamming/BCH) */
+struct nandi_controller {
+	void __iomem		*base;		/* Controller base*/
+	void __iomem		*emiss;		/* EMISS control base */
+	void __iomem		*emisscfg;	/* EMISS config base */
+	void __iomem		*dma;		/* DMA control base */
+
+	struct clk		*bch_clk;
+	struct clk		*emi_clk;
+						/* IRQ-triggered Completions: */
+	struct completion	seq_completed;	/*   SEQ Over */
+	struct completion	rbn_completed;	/*   RBn */
+
+	struct device		*dev;
+
+	int			bch_ecc_mode;	/* ECC mode */
+	bool			extra_addr;	/* Extra address cycle */
+
+	uint32_t		blocks_per_device;
+	uint32_t		sectors_per_page;
+
+	uint8_t			*buf;		/* Some buffers to use */
+	uint8_t			*page_buf;
+	uint8_t			*oob_buf;
+	uint32_t		*buf_list;
+
+	int			cached_page;	/* page number of page in */
+						/* 'page_buf'             */
+
+	struct nandi_info	info;		/* NAND device info */
+};
+
+/*
+ * Board-level specification relating to a 'bank' of NAND Flash
+ */
+struct stm_nand_bank_data {
+	int			csn;
+	int			nr_partitions;
+	struct mtd_partition	*partitions;
+	unsigned int		options;
+	unsigned int		bbt_options;
+
+	struct nand_sdr_timings *timing_spec;
+
+	/*
+	 * No. of IP clk cycles by which to 'relax' the timing configuration.
+	 * Required on some boards to to accommodate board-level limitations.
+	 * Used in conjunction with 'nand_sdr_timings' and ONFI configuration.
+	 */
+	int			timing_relax;
+};
+
+struct stm_nand_bch_ddata {
+	struct nandi_controller *nandi;
+	struct stm_nand_bank_data *bank;
+	enum stm_nand_bch_ecc_config bch_ecc_cfg;
+};
+
+enum nandi_controllers {
+	STM_NANDI_UNCONFIGURED,
+	STM_NANDI_HAMMING,
+	STM_NANDI_BCH
+};
+
+extern int flex_read_raw(struct nandi_controller *nandi,
+			 uint32_t page_addr,
+			 uint32_t col_addr,
+			 uint8_t *buf, uint32_t len);
+extern uint8_t bch_write_page(struct nandi_controller *nandi,
+			      loff_t offs, const uint8_t *buf);
+extern uint8_t bch_erase_block(struct nandi_controller *nandi,
+			       loff_t offs);
+extern int bch_read_page(struct nandi_controller *nandi,
+			 loff_t offs, uint8_t *buf);
+
+#define EMISS_NAND_CONFIG_HAMMING_NOT_BCH 	(0x1 << 6)
+
+static inline void emiss_nandi_select(struct nandi_controller *nandi,
+				      enum nandi_controllers controller)
+{
+	unsigned v;
+
+	v = readl(nandi->emisscfg);
+
+	if (controller == STM_NANDI_HAMMING) {
+		if (v & EMISS_NAND_CONFIG_HAMMING_NOT_BCH)
+			return;
+		v |= EMISS_NAND_CONFIG_HAMMING_NOT_BCH;
+	} else {
+		if (!(v & EMISS_NAND_CONFIG_HAMMING_NOT_BCH))
+			return;
+		v &= ~EMISS_NAND_CONFIG_HAMMING_NOT_BCH;
+	}
+
+	writel(v, nandi->emisscfg);
+	readl(nandi->emisscfg);
+}
+
+#endif /* __LINUX_STM_NAND_H */
-- 
1.9.1

