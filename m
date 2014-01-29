Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaA2Og6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:36:58 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:58836 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbaA2Oer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:34:47 -0500
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Boris BREZILLON <b.brezillon.dev@gmail.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: =?UTF-8?q?=5BRFC=20PATCH=20v2=2008/14=5D=20mtd=3A=20nand=3A=20add=20sunxi=20NAND=20flash=20controller=20support?=
Date: Wed, 29 Jan 2014 15:34:18 +0100
Message-Id: <1391006064-28890-9-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the sunxi NAND Flash Controller (NFC).

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 drivers/mtd/nand/Kconfig      |    6 +
 drivers/mtd/nand/Makefile     |    1 +
 drivers/mtd/nand/sunxi_nand.c |  744 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 751 insertions(+)
 create mode 100644 drivers/mtd/nand/sunxi_nand.c

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 93ae6a6..784dd42 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -510,4 +510,10 @@ config MTD_NAND_XWAY
 	  Enables support for NAND Flash chips on Lantiq XWAY SoCs. NAND is attached
 	  to the External Bus Unit (EBU).
 
+config MTD_NAND_SUNXI
+	tristate "Support for NAND on Allwinner SoCs"
+	depends on ARCH_SUNXI
+	help
+	  Enables support for NAND Flash chips on Allwinner SoCs.
+
 endif # MTD_NAND
diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index bbea7a6..e3b4a34 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -49,5 +49,6 @@ obj-$(CONFIG_MTD_NAND_JZ4740)		+= jz4740_nand.o
 obj-$(CONFIG_MTD_NAND_GPMI_NAND)	+= gpmi-nand/
 obj-$(CONFIG_MTD_NAND_XWAY)		+= xway_nand.o
 obj-$(CONFIG_MTD_NAND_BCM47XXNFLASH)	+= bcm47xxnflash/
+obj-$(CONFIG_MTD_NAND_SUNXI)		+= sunxi_nand.o
 
 nand-objs := nand_base.o nand_bbt.o
diff --git a/drivers/mtd/nand/sunxi_nand.c b/drivers/mtd/nand/sunxi_nand.c
new file mode 100644
index 0000000..d3da810
--- /dev/null
+++ b/drivers/mtd/nand/sunxi_nand.c
@@ -0,0 +1,744 @@
+/*
+ * Copyright (C) 2013 Boris BREZILLON <b.brezillon.dev@gmail.com>
+ *
+ * Derived from:
+ *	https://github.com/yuq/sunxi-nfc-mtd
+ *	Copyright (C) 2013 Qiang Yu <yuq825@gmail.com>
+ *
+ *	https://github.com/hno/Allwinner-Info
+ *	Copyright (C) 2013 Henrik Nordström <Henrik Nordström>
+ *
+ *	Copyright (C) 2013 Dmitriy B. <rzk333@gmail.com>
+ *	Copyright (C) 2013 Sergey Lapin <slapin@ossfans.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
+#include <linux/of_mtd.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/nand.h>
+#include <linux/mtd/partitions.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/dmaengine.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+
+#define NFC_REG_CTL		0x0000
+#define NFC_REG_ST		0x0004
+#define NFC_REG_INT		0x0008
+#define NFC_REG_TIMING_CTL	0x000C
+#define NFC_REG_TIMING_CFG	0x0010
+#define NFC_REG_ADDR_LOW	0x0014
+#define NFC_REG_ADDR_HIGH	0x0018
+#define NFC_REG_SECTOR_NUM	0x001C
+#define NFC_REG_CNT		0x0020
+#define NFC_REG_CMD		0x0024
+#define NFC_REG_RCMD_SET	0x0028
+#define NFC_REG_WCMD_SET	0x002C
+#define NFC_REG_IO_DATA		0x0030
+#define NFC_REG_ECC_CTL		0x0034
+#define NFC_REG_ECC_ST		0x0038
+#define NFC_REG_DEBUG		0x003C
+#define NFC_REG_ECC_CNT0	0x0040
+#define NFC_REG_ECC_CNT1	0x0044
+#define NFC_REG_ECC_CNT2	0x0048
+#define NFC_REG_ECC_CNT3	0x004c
+#define NFC_REG_USER_DATA_BASE	0x0050
+#define NFC_REG_SPARE_AREA	0x00A0
+#define NFC_RAM0_BASE		0x0400
+#define NFC_RAM1_BASE		0x0800
+
+/*define bit use in NFC_CTL*/
+#define NFC_EN				(1 << 0)
+#define NFC_RESET			(1 << 1)
+#define NFC_BUS_WIDYH			(1 << 2)
+#define NFC_RB_SEL			(1 << 3)
+#define NFC_CE_SEL			(7 << 24)
+#define NFC_CE_CTL			(1 << 6)
+#define NFC_CE_CTL1			(1 << 7)
+#define NFC_PAGE_SIZE			(0xf << 8)
+#define NFC_SAM				(1 << 12)
+#define NFC_RAM_METHOD			(1 << 14)
+#define NFC_DEBUG_CTL			(1 << 31)
+
+/*define bit use in NFC_ST*/
+#define NFC_RB_B2R			(1 << 0)
+#define NFC_CMD_INT_FLAG		(1 << 1)
+#define NFC_DMA_INT_FLAG		(1 << 2)
+#define NFC_CMD_FIFO_STATUS		(1 << 3)
+#define NFC_STA				(1 << 4)
+#define NFC_NATCH_INT_FLAG		(1 << 5)
+#define NFC_RB_STATE0			(1 << 8)
+#define NFC_RB_STATE1			(1 << 9)
+#define NFC_RB_STATE2			(1 << 10)
+#define NFC_RB_STATE3			(1 << 11)
+
+/*define bit use in NFC_INT*/
+#define NFC_B2R_INT_ENABLE		(1 << 0)
+#define NFC_CMD_INT_ENABLE		(1 << 1)
+#define NFC_DMA_INT_ENABLE		(1 << 2)
+#define NFC_INT_MASK			(NFC_B2R_INT_ENABLE | \
+					 NFC_CMD_INT_ENABLE | \
+					 NFC_DMA_INT_ENABLE)
+
+
+/*define bit use in NFC_CMD*/
+#define NFC_CMD_LOW_BYTE		(0xff << 0)
+#define NFC_CMD_HIGH_BYTE		(0xff << 8)
+#define NFC_ADR_NUM			(0x7 << 16)
+#define NFC_SEND_ADR			(1 << 19)
+#define NFC_ACCESS_DIR			(1 << 20)
+#define NFC_DATA_TRANS			(1 << 21)
+#define NFC_SEND_CMD1			(1 << 22)
+#define NFC_WAIT_FLAG			(1 << 23)
+#define NFC_SEND_CMD2			(1 << 24)
+#define NFC_SEQ				(1 << 25)
+#define NFC_DATA_SWAP_METHOD		(1 << 26)
+#define NFC_ROW_AUTO_INC		(1 << 27)
+#define NFC_SEND_CMD3			(1 << 28)
+#define NFC_SEND_CMD4			(1 << 29)
+#define NFC_CMD_TYPE			(3 << 30)
+
+/* define bit use in NFC_RCMD_SET*/
+#define NFC_READ_CMD			(0xff << 0)
+#define NFC_RANDOM_READ_CMD0		(0xff << 8)
+#define NFC_RANDOM_READ_CMD1		(0xff << 16)
+
+/*define bit use in NFC_WCMD_SET*/
+#define NFC_PROGRAM_CMD			(0xff << 0)
+#define NFC_RANDOM_WRITE_CMD		(0xff << 8)
+#define NFC_READ_CMD0			(0xff << 16)
+#define NFC_READ_CMD1			(0xff << 24)
+
+/*define bit use in NFC_ECC_CTL*/
+#define NFC_ECC_EN			(1 << 0)
+#define NFC_ECC_PIPELINE		(1 << 3)
+#define NFC_ECC_EXCEPTION		(1 << 4)
+#define NFC_ECC_BLOCK_SIZE		(1 << 5)
+#define NFC_RANDOM_EN			(1 << 9)
+#define NFC_RANDOM_DIRECTION		(1 << 10)
+#define NFC_ECC_MODE_SHIFT		12
+#define NFC_ECC_MODE			(0xf << NFC_ECC_MODE_SHIFT)
+#define NFC_RANDOM_SEED			(0x7fff << 16)
+
+
+
+enum sunxi_nand_rb_type {
+	RB_NONE,
+	RB_NATIVE,
+	RB_GPIO,
+};
+
+struct sunxi_nand_rb {
+	enum sunxi_nand_rb_type type;
+	union {
+		int gpio;
+		int nativeid;
+	} info;
+};
+
+struct sunxi_nand_chip_sel {
+	u8 cs;
+	struct sunxi_nand_rb rb;
+};
+
+#define DEFAULT_NAME_FORMAT	"nand@%d"
+#define MAX_NAME_SIZE		(sizeof("nand@") + 2)
+
+struct sunxi_nand_chip {
+	struct list_head node;
+	struct nand_chip nand;
+	struct mtd_info mtd;
+	char default_name[MAX_NAME_SIZE];
+	unsigned long clk_rate;
+	int selected;
+	int nsels;
+	struct sunxi_nand_chip_sel sels[0];
+};
+
+static inline struct sunxi_nand_chip *to_sunxi_nand(struct mtd_info *mtd)
+{
+	return container_of(mtd, struct sunxi_nand_chip, mtd);
+}
+
+struct sunxi_nfc {
+	struct nand_hw_control controller;
+	void __iomem *regs;
+	int irq;
+	struct clk *ahb_clk;
+	struct clk *sclk;
+	unsigned long assigned_cs;
+	unsigned long clk_rate;
+	struct list_head chips;
+	struct completion complete;
+};
+
+static inline struct sunxi_nfc *to_sunxi_nfc(struct nand_hw_control *ctrl)
+{
+	return container_of(ctrl, struct sunxi_nfc, controller);
+}
+
+static irqreturn_t sunxi_nfc_interrupt(int irq, void *dev_id)
+{
+	struct sunxi_nfc *nfc = dev_id;
+	u32 st = readl(nfc->regs + NFC_REG_ST);
+	u32 ien = readl(nfc->regs + NFC_REG_INT);
+
+	if (!(ien & st))
+		return IRQ_NONE;
+
+	if ((ien & st) == ien)
+		complete(&nfc->complete);
+
+	writel(st & NFC_INT_MASK, nfc->regs + NFC_REG_ST);
+	writel(~st & ien & NFC_INT_MASK, nfc->regs + NFC_REG_INT);
+
+	return IRQ_HANDLED;
+}
+
+static int sunxi_nfc_wait_int(struct sunxi_nfc *nfc, u32 flags,
+			      unsigned int timeout_ms)
+{
+	init_completion(&nfc->complete);
+
+	writel(flags, nfc->regs + NFC_REG_INT);
+	if (!timeout_ms)
+		wait_for_completion(&nfc->complete);
+	else if (!wait_for_completion_timeout(&nfc->complete,
+					      msecs_to_jiffies(timeout_ms)))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int sunxi_nfc_dev_ready(struct mtd_info *mtd)
+{
+	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(mtd);
+	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
+	struct sunxi_nand_rb *rb;
+	unsigned long timeo = (sunxi_nand->nand.state == FL_ERASING ? 400 : 20);
+	int ret;
+
+	if (sunxi_nand->selected < 0)
+		return 0;
+
+	rb = &sunxi_nand->sels[sunxi_nand->selected].rb;
+
+	switch (rb->type) {
+	case RB_NATIVE:
+		ret = !!(readl(nfc->regs + NFC_REG_ST) &
+			 (NFC_RB_STATE0 << rb->info.nativeid));
+		if (ret)
+			break;
+
+		sunxi_nfc_wait_int(nfc, NFC_RB_B2R, timeo);
+		ret = !!(readl(nfc->regs + NFC_REG_ST) &
+			 (NFC_RB_STATE0 << rb->info.nativeid));
+		break;
+	case RB_GPIO:
+		ret = gpio_get_value(rb->info.gpio);
+		break;
+	case RB_NONE:
+	default:
+		ret = 0;
+		dev_err(&mtd->dev, "cannot check R/B NAND status!");
+		break;
+	}
+
+	return ret;
+}
+
+static void sunxi_nfc_select_chip(struct mtd_info *mtd, int chip)
+{
+	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(mtd);
+	struct nand_chip *nand = &sunxi_nand->nand;
+	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
+	struct sunxi_nand_chip_sel *sel;
+	u32 ctl;
+
+	if (chip > 0 && chip >= sunxi_nand->nsels)
+		return;
+
+	if (chip == sunxi_nand->selected)
+		return;
+
+	ctl = readl(nfc->regs + NFC_REG_CTL) &
+	      ~(NFC_CE_SEL | NFC_RB_SEL | NFC_EN);
+
+	if (chip >= 0) {
+		sel = &sunxi_nand->sels[chip];
+
+		ctl |= (sel->cs << 24) | NFC_EN |
+		       (((nand->page_shift - 10) & 0xf) << 8);
+		if (sel->rb.type == RB_NONE) {
+			nand->dev_ready = NULL;
+		} else {
+			nand->dev_ready = sunxi_nfc_dev_ready;
+			if (sel->rb.type == RB_NATIVE)
+				ctl |= (sel->rb.info.nativeid << 3);
+		}
+
+		writel(mtd->writesize, nfc->regs + NFC_REG_SPARE_AREA);
+
+		if (nfc->clk_rate != sunxi_nand->clk_rate) {
+			clk_set_rate(nfc->sclk, sunxi_nand->clk_rate);
+			nfc->clk_rate = sunxi_nand->clk_rate;
+		}
+	}
+
+	writel(ctl, nfc->regs + NFC_REG_CTL);
+
+	sunxi_nand->selected = chip;
+}
+
+static void sunxi_nfc_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
+{
+	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(mtd);
+	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
+	int cnt;
+	int offs = 0;
+	u32 tmp;
+
+	while (len > offs) {
+		cnt = len - offs;
+		if (cnt > 1024)
+			cnt = 1024;
+
+		while ((readl(nfc->regs + NFC_REG_ST) & NFC_CMD_FIFO_STATUS))
+			;
+		writel(cnt, nfc->regs + NFC_REG_CNT);
+		tmp = NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD;
+		writel(tmp, nfc->regs + NFC_REG_CMD);
+		sunxi_nfc_wait_int(nfc, NFC_CMD_INT_FLAG, 0);
+		if (buf)
+			memcpy_fromio(buf + offs, nfc->regs + NFC_RAM0_BASE,
+				      cnt);
+		offs += cnt;
+	}
+}
+
+static void sunxi_nfc_write_buf(struct mtd_info *mtd, const uint8_t *buf,
+				int len)
+{
+	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(mtd);
+	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
+	int cnt;
+	int offs = 0;
+	u32 tmp;
+
+	while (len > offs) {
+		cnt = len - offs;
+		if (cnt > 1024)
+			cnt = 1024;
+
+		while ((readl(nfc->regs + NFC_REG_ST) & NFC_CMD_FIFO_STATUS))
+			;
+		writel(cnt, nfc->regs + NFC_REG_CNT);
+		memcpy_toio(nfc->regs + NFC_RAM0_BASE, buf + offs, cnt);
+		tmp = NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD |
+		      NFC_ACCESS_DIR;
+		writel(tmp, nfc->regs + NFC_REG_CMD);
+		sunxi_nfc_wait_int(nfc, NFC_CMD_INT_FLAG, 0);
+		offs += cnt;
+	}
+}
+
+static uint8_t sunxi_nfc_read_byte(struct mtd_info *mtd)
+{
+	uint8_t ret;
+
+	sunxi_nfc_read_buf(mtd, &ret, 1);
+
+	return ret;
+}
+
+static void sunxi_nfc_cmd_ctrl(struct mtd_info *mtd, int dat,
+			       unsigned int ctrl)
+{
+	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(mtd);
+	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
+	u32 tmp;
+
+	while ((readl(nfc->regs + NFC_REG_ST) & NFC_CMD_FIFO_STATUS))
+		;
+
+	if (ctrl & NAND_CTRL_CHANGE) {
+		tmp = readl(nfc->regs + NFC_REG_CTL);
+		if (ctrl & NAND_NCE)
+			tmp |= NFC_CE_CTL;
+		else
+			tmp &= ~NFC_CE_CTL;
+		writel(tmp, nfc->regs + NFC_REG_CTL);
+	}
+
+	if (dat == NAND_CMD_NONE)
+		return;
+
+	if (ctrl & NAND_CLE) {
+		writel(NFC_SEND_CMD1 | dat, nfc->regs + NFC_REG_CMD);
+	} else {
+		writel(dat, nfc->regs + NFC_REG_ADDR_LOW);
+		writel(NFC_SEND_ADR, nfc->regs + NFC_REG_CMD);
+	}
+
+	sunxi_nfc_wait_int(nfc, NFC_CMD_INT_FLAG, 0);
+}
+
+static int sunxi_nand_chip_init_timings(struct sunxi_nand_chip *chip,
+					struct device_node *np)
+{
+	const struct nand_sdr_timings *timings;
+	u32 min_clk_period = 0;
+	int ret;
+
+	ret = onfi_get_async_timing_mode(&chip->nand);
+	if (ret == ONFI_TIMING_MODE_UNKNOWN) {
+		ret = of_get_nand_onfi_timing_mode(np);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = fls(ret);
+	if (!ret)
+		return -EINVAL;
+
+	timings = onfi_async_timing_mode_to_sdr_timings(ret - 1);
+	if (IS_ERR(timings))
+		return PTR_ERR(timings);
+
+	/* NFC timings defined in Allwinner Datasheets */
+
+	/* T1 <=> tCLS */
+	if (timings->tCLS_min > min_clk_period)
+		min_clk_period = timings->tCLS_min;
+
+	/* T2 <=> tCLH */
+	if (timings->tCLH_min > min_clk_period)
+		min_clk_period = timings->tCLH_min;
+
+	/* T3 <=> tCS */
+	if (timings->tCS_min > min_clk_period)
+		min_clk_period = timings->tCS_min;
+
+	/* T4 <=> tCH */
+	if (timings->tCH_min > min_clk_period)
+		min_clk_period = timings->tCH_min;
+
+	/* T5 <=> tWP */
+	if (timings->tWP_min > min_clk_period)
+		min_clk_period = timings->tWP_min;
+
+	/* T6 <=> tWH */
+	if (timings->tWH_min > min_clk_period)
+		min_clk_period = timings->tWH_min;
+
+	/* T7 <=> tALS */
+	if (timings->tALS_min > min_clk_period)
+		min_clk_period = timings->tALS_min;
+
+	/* T8 <=> tDS */
+	if (timings->tDS_min > min_clk_period)
+		min_clk_period = timings->tDS_min;
+
+	/* T9 <=> tDH */
+	if (timings->tDH_min > min_clk_period)
+		min_clk_period = timings->tDH_min;
+
+	/* T10 <=> tRR */
+	if (timings->tRR_min > (min_clk_period * 3))
+		min_clk_period = (timings->tRR_min + 2) / 3;
+
+	/* T11 <=> tALH */
+	if (timings->tALH_min > min_clk_period)
+		min_clk_period = timings->tALH_min;
+
+	/* T12 <=> tRP */
+	if (timings->tRP_min > min_clk_period)
+		min_clk_period = timings->tRP_min;
+
+	/* T13 <=> tREH */
+	if (timings->tREH_min > min_clk_period)
+		min_clk_period = timings->tREH_min;
+
+	/* T14 <=> tRC */
+	if (timings->tRC_min > (min_clk_period * 2))
+		min_clk_period = (timings->tRC_min + 1) / 2;
+
+	/* T15 <=> tWC */
+	if (timings->tWC_min > (min_clk_period * 2))
+		min_clk_period = (timings->tWC_min + 1) / 2;
+
+
+	/* min_clk_period = (NAND-clk-period * 2) */
+	if (!min_clk_period) {
+		chip->clk_rate = 20000000;
+	} else {
+		min_clk_period /= 1000;
+		if (!min_clk_period)
+			min_clk_period = 1;
+		chip->clk_rate = (2 * 1000000000) / min_clk_period;
+	}
+
+	/* TODO: configure T16-T19 */
+
+	return 0;
+}
+
+static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
+				struct device_node *np)
+{
+	struct sunxi_nand_chip *chip;
+	struct mtd_part_parser_data ppdata;
+	struct mtd_info *mtd;
+	struct nand_chip *nand;
+	u32 strength;
+	u32 blk_size;
+	int nsels;
+	int ret;
+	int i;
+	u32 tmp;
+
+	if (!of_get_property(np, "reg", &nsels))
+		return -EINVAL;
+
+	nsels /= sizeof(u32);
+	if (!nsels)
+		return -EINVAL;
+
+	chip = devm_kzalloc(dev,
+			    sizeof(*chip) +
+			    (nsels * sizeof(struct sunxi_nand_chip_sel)),
+			    GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	chip->nsels = nsels;
+	chip->selected = -1;
+
+	for (i = 0; i < nsels; i++) {
+		ret = of_property_read_u32_index(np, "reg", i, &tmp);
+		if (ret)
+			return ret;
+
+		if (tmp > 7)
+			return -EINVAL;
+
+		if (test_and_set_bit(tmp, &nfc->assigned_cs))
+			return -EINVAL;
+
+		chip->sels[i].cs = tmp;
+
+		if (!of_property_read_u32_index(np, "allwinner,rb", i, &tmp) &&
+		    tmp < 2) {
+			chip->sels[i].rb.type = RB_NATIVE;
+			chip->sels[i].rb.info.nativeid = tmp;
+		} else {
+			ret = of_get_named_gpio(np, "rb-gpios", i);
+			if (ret >= 0) {
+				chip->sels[i].rb.type = RB_GPIO;
+				chip->sels[i].rb.info.gpio = tmp;
+				ret = devm_gpio_request(dev, tmp, "nand-rb");
+				if (ret)
+					return ret;
+			} else {
+				chip->sels[i].rb.type = RB_NONE;
+			}
+		}
+	}
+
+	ret = sunxi_nand_chip_init_timings(chip, np);
+	if (ret)
+		return ret;
+
+	nand = &chip->nand;
+	nand->controller = &nfc->controller;
+	nand->select_chip = sunxi_nfc_select_chip;
+	nand->cmd_ctrl = sunxi_nfc_cmd_ctrl;
+	nand->read_buf = sunxi_nfc_read_buf;
+	nand->write_buf = sunxi_nfc_write_buf;
+	nand->read_byte = sunxi_nfc_read_byte;
+
+	nand->ecc.mode = of_get_nand_ecc_mode(np);
+	if (of_get_nand_on_flash_bbt(np))
+		nand->bbt_options |= NAND_BBT_USE_FLASH;
+
+	mtd = &chip->mtd;
+	mtd->priv = nand;
+	mtd->owner = THIS_MODULE;
+
+	ret = nand_scan_ident(mtd, nsels, NULL);
+	if (ret)
+		return ret;
+
+	if (nand->ecc.mode == NAND_ECC_SOFT_BCH) {
+		if (!of_get_nand_ecc_level(np, &strength, &blk_size)) {
+			nand->ecc_step_ds = blk_size;
+			nand->ecc_strength_ds = strength;
+		}
+
+		nand->ecc.size = nand->ecc_step_ds;
+		nand->ecc.bytes = (((nand->ecc_strength_ds *
+				     fls(8 * nand->ecc_step_ds)) + 7) / 8);
+	}
+
+	ret = nand_scan_tail(mtd);
+	if (ret)
+		return ret;
+
+	if (of_property_read_string(np, "nand-name", &mtd->name)) {
+		snprintf(chip->default_name, MAX_NAME_SIZE,
+			 DEFAULT_NAME_FORMAT, chip->sels[i].cs);
+		mtd->name = chip->default_name;
+	}
+
+	ppdata.of_node = np;
+	ret = mtd_device_parse_register(mtd, NULL, &ppdata, NULL, 0);
+	if (!ret)
+		return ret;
+
+	list_add_tail(&chip->node, &nfc->chips);
+
+	return 0;
+}
+
+static int sunxi_nand_chips_init(struct device *dev, struct sunxi_nfc *nfc)
+{
+	struct device_node *np = dev->of_node;
+	struct device_node *nand_np;
+	int nchips = of_get_child_count(np);
+	int ret;
+
+	if (nchips > 8)
+		return -EINVAL;
+
+	for_each_child_of_node(np, nand_np) {
+		ret = sunxi_nand_chip_init(dev, nfc, nand_np);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int sunxi_nfc_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *r;
+	struct sunxi_nfc *nfc;
+	int ret;
+
+	nfc = devm_kzalloc(dev, sizeof(*nfc), GFP_KERNEL);
+	if (!nfc) {
+		dev_err(dev, "failed to allocate NFC struct\n");
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&nfc->controller.lock);
+	init_waitqueue_head(&nfc->controller.wq);
+	INIT_LIST_HEAD(&nfc->chips);
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	nfc->regs = devm_ioremap_resource(dev, r);
+	if (IS_ERR(nfc->regs)) {
+		dev_err(dev, "failed to remap iomem\n");
+		return PTR_ERR(nfc->regs);
+	}
+
+	nfc->irq = platform_get_irq(pdev, 0);
+	if (nfc->irq < 0) {
+		dev_err(dev, "failed to retrieve irq\n");
+		return nfc->irq;
+	}
+
+	nfc->ahb_clk = devm_clk_get(dev, "ahb_clk");
+	if (IS_ERR(nfc->ahb_clk)) {
+		dev_err(dev, "failed to retrieve ahb_clk\n");
+		return PTR_ERR(nfc->ahb_clk);
+	}
+
+	ret = clk_prepare_enable(nfc->ahb_clk);
+	if (ret)
+		return ret;
+
+	nfc->sclk = devm_clk_get(dev, "sclk");
+	if (IS_ERR(nfc->sclk)) {
+		dev_err(dev, "failed to retrieve nand_clk\n");
+		ret = PTR_ERR(nfc->sclk);
+		goto out_ahb_clk_unprepare;
+	}
+
+	ret = clk_prepare_enable(nfc->sclk);
+	if (ret)
+		goto out_ahb_clk_unprepare;
+
+	/* Reset NFC */
+	writel(readl(nfc->regs + NFC_REG_CTL) | NFC_RESET,
+	       nfc->regs + NFC_REG_CTL);
+	while (readl(nfc->regs + NFC_REG_CTL) & NFC_RESET)
+		;
+
+	writel(0, nfc->regs + NFC_REG_INT);
+	ret = devm_request_irq(dev, nfc->irq, sunxi_nfc_interrupt,
+			       0, "sunxi-nand", nfc);
+	if (ret)
+		goto out_sclk_unprepare;
+
+	platform_set_drvdata(pdev, nfc);
+
+	writel(0x100, nfc->regs + NFC_REG_TIMING_CTL);
+	writel(0x7ff, nfc->regs + NFC_REG_TIMING_CFG);
+
+	ret = sunxi_nand_chips_init(dev, nfc);
+	if (ret) {
+		dev_err(dev, "failed to init nand chips\n");
+		goto out_sclk_unprepare;
+	}
+
+	return 0;
+
+out_sclk_unprepare:
+	clk_disable_unprepare(nfc->sclk);
+out_ahb_clk_unprepare:
+	clk_disable_unprepare(nfc->ahb_clk);
+
+	return ret;
+}
+
+static const struct of_device_id sunxi_nfc_ids[] = {
+	{ .compatible = "allwinner,sun4i-nand" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, sunxi_nfc_ids);
+
+static struct platform_driver sunxi_nfc_driver = {
+	.driver = {
+		.name = "sunxi_nand",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(sunxi_nfc_ids),
+	},
+	.probe = sunxi_nfc_probe,
+};
+module_platform_driver(sunxi_nfc_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Boris BREZILLON");
+MODULE_DESCRIPTION("Allwinner NAND Flash Controller driver");
+MODULE_ALIAS("platform:sunxi_nfc");
-- 
1.7.9.5

