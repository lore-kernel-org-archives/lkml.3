Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaANVi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:38:56 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:59157 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaANViv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:38:51 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-mmc@vger.kernel.org
Subject: [RFC PATCH] mmc: add Toshiba PCI SD controller driver
Date: Tue, 14 Jan 2014 22:38:20 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201401142238.21879.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
this patch resurrects an old never-finished driver for Toshiba PCI SD
controllers found in some older Toshiba laptops (such as Portege R100):

02:0d.0 System peripheral [0880]: Toshiba America Info Systems SD TypA Controller [1179:0805] (rev 05)

The hardware is slow (around 2 MB/s - same in Windows) because it does not
support bus mastering (busmaster enable bit cannot be set in PCI control reg).
Also the card clock is limited to 16MHz (33MHz PCI clock divided by 2).

The driver seems to work fine except for error handling, which requires some
more work - I need to figure out how to properly (i.e. when) clear error bits
of the buffer status register.

SD, SDHC and MMC cards work. (MMC cards don't work in Windows)
SDIO is not supported (don't have any SDIO card).

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 7fc5099..29dc4ef 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -665,3 +665,8 @@ config MMC_REALTEK_PCI
 	help
 	  Say Y here to include driver code to support SD/MMC card interface
 	  of Realtek PCI-E card reader
+
+config MMC_TOSHIBA_PCI
+	tristate "Toshiba Type A SD/MMC Card Interface Driver"
+	depends on PCI
+	help
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index c41d0c3..2dd1617 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_MMC_USHC)		+= ushc.o
 obj-$(CONFIG_MMC_WMT)		+= wmt-sdmmc.o
 
 obj-$(CONFIG_MMC_REALTEK_PCI)	+= rtsx_pci_sdmmc.o
+obj-$(CONFIG_MMC_TOSHIBA_PCI)	+= toshsd.o
 
 obj-$(CONFIG_MMC_SDHCI_PLTFM)		+= sdhci-pltfm.o
 obj-$(CONFIG_MMC_SDHCI_CNS3XXX)		+= sdhci-cns3xxx.o
diff --git a/drivers/mmc/host/toshsd.c b/drivers/mmc/host/toshsd.c
new file mode 100644
index 0000000..f683ec9
--- /dev/null
+++ b/drivers/mmc/host/toshsd.c
@@ -0,0 +1,740 @@
+/*
+ *  Toshiba PCI Secure Digital Host Controller Interface driver
+ *
+ *  Copyright (C) 2013 Ondrej Zary
+ *  Copyright (C) 2007 Richard Betts, All Rights Reserved.
+ *
+ *	Based on asic3_mmc.c, copyright (c) 2005 SDG Systems, LLC and,
+ *	sdhci.c, copyright (C) 2005-2006 Pierre Ossman
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/scatterlist.h>
+#include <linux/interrupt.h>
+
+#include <linux/mmc/host.h>
+#include <linux/mmc/mmc.h>
+
+#include "toshsd.h"
+
+#define DRIVER_NAME "toshsd"
+
+static const struct pci_device_id pci_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA, 0x0805) },
+	{ /* end: all zeroes */ },
+};
+
+MODULE_DEVICE_TABLE(pci, pci_ids);
+
+static void toshsd_init(struct toshsd_host *host);
+
+static inline u16 toshsd_readw(struct toshsd_host *host, u16 reg)
+{
+	return ioread16(host->ioaddr + reg);
+}
+
+static inline void toshsd_writew(struct toshsd_host *host, u16 reg, u16 val)
+{
+	iowrite16(val, host->ioaddr + reg);
+}
+
+static inline void toshsd_readl_rep(struct toshsd_host *host, u16 reg,
+				    void *dst, unsigned long count)
+{
+	ioread32_rep(host->ioaddr + reg, dst, count);
+}
+
+static inline void toshsd_writel_rep(struct toshsd_host *host, u16 reg,
+				     const void *src, unsigned long count)
+{
+	iowrite32_rep(host->ioaddr + reg, src, count);
+}
+
+static void toshsd_set_led(struct toshsd_host *host, unsigned char state)
+{
+	toshsd_writew(host, SDIO_BASE + SDIO_LEDCTRL, state);
+}
+
+static void toshsd_finish_request(struct toshsd_host *host)
+{
+	struct mmc_request *mrq = host->mrq;
+
+	/* Write something to end the command */
+	host->mrq = NULL;
+	host->cmd = NULL;
+	host->data = NULL;
+
+	toshsd_set_led(host, 0);
+	mmc_request_done(host->mmc, mrq);
+}
+
+static void toshsd_data_transfer(unsigned long h)
+{
+	struct toshsd_host *host = (struct toshsd_host *) h;
+	struct mmc_data *data = host->data;
+	struct sg_mapping_iter *sg_miter = &host->sg_miter;
+	unsigned short *buf;
+	int count;
+	unsigned long flags;
+
+	if (!data) {
+		dev_warn(&host->pdev->dev, "Spurious Data IRQ\n");
+		return;
+	}
+	spin_lock_irqsave(&host->lock, flags);
+
+	if (!sg_miter_next(sg_miter))
+		return;
+	buf = sg_miter->addr;
+
+	/* Ensure we dont read more than one block. The chip will interrupt us
+	 * When the next block is available.
+	 */
+	count = sg_miter->length;
+	if (count > data->blksz)
+		count = data->blksz;
+
+	pr_debug("count: %08x, flags %08x\n", count, data->flags);
+
+	/* Transfer the data */
+	if (data->flags & MMC_DATA_READ)
+		toshsd_readl_rep(host, SD_DATAPORT, buf, count >> 2);
+	else
+		toshsd_writel_rep(host, SD_DATAPORT, buf, count >> 2);
+
+	sg_miter->consumed = count;
+	sg_miter_stop(sg_miter);
+
+	spin_unlock_irqrestore(&host->lock, flags);
+}
+
+static void toshsd_cmd_irq(struct toshsd_host *host, unsigned int buf_stat)
+{
+	struct mmc_command *cmd = host->cmd;
+	u8 *buf = (u8 *) cmd->resp;
+	u16 data;
+	int bmask;
+
+	if (!host->cmd) {
+		dev_warn(&host->pdev->dev, "Spurious CMD irq\n");
+		return;
+	}
+
+	host->cmd = NULL;
+	if (cmd->flags & MMC_RSP_PRESENT && cmd->flags & MMC_RSP_136) {
+		/* R2 */
+		buf[12] = 0xff;
+		data = toshsd_readw(host, SD_RESPONSE0);
+		buf[13] = data & 0xff;
+		buf[14] = data >> 8;
+		data = toshsd_readw(host, SD_RESPONSE1);
+		buf[15] = data & 0xff;
+		buf[8] = data >> 8;
+		data = toshsd_readw(host, SD_RESPONSE2);
+		buf[9] = data & 0xff;
+		buf[10] = data >> 8;
+		data = toshsd_readw(host, SD_RESPONSE3);
+		buf[11] = data & 0xff;
+		buf[4] = data >> 8;
+		data = toshsd_readw(host, SD_RESPONSE4);
+		buf[5] = data & 0xff;
+		buf[6] = data >> 8;
+		data = toshsd_readw(host, SD_RESPONSE5);
+		buf[7] = data & 0xff;
+		buf[0] = data >> 8;
+		data = toshsd_readw(host, SD_RESPONSE6);
+		buf[1] = data & 0xff;
+		buf[2] = data >> 8;
+		data = toshsd_readw(host, SD_RESPONSE7);
+		buf[3] = data & 0xff;
+	} else if (cmd->flags & MMC_RSP_PRESENT) {
+		/* R1, R1B, R3, R6, R7 */
+		data = toshsd_readw(host, SD_RESPONSE0);
+		buf[0] = data & 0xff;
+		buf[1] = data >> 8;
+		data = toshsd_readw(host, SD_RESPONSE1);
+		buf[2] = data & 0xff;
+		buf[3] = data >> 8;
+	}
+
+	if (buf_stat & SD_BUF_CMD_TIMEOUT) {
+		cmd->error = -ETIMEDOUT;
+		pr_debug("Timeout\n");
+	} else if ((buf_stat & SD_BUF_CRC_ERR)
+		   && (cmd->flags & MMC_RSP_CRC)) {
+		cmd->error = -EILSEQ;
+		dev_err(&host->pdev->dev, "BadCRC\n");
+	} else if (buf_stat & (SD_BUF_ILLEGAL_ACCESS
+				| SD_BUF_CMD_INDEX_ERR
+				| SD_BUF_STOP_BIT_END_ERR
+				| SD_BUF_OVERFLOW
+				| SD_BUF_UNDERFLOW
+				| SD_BUF_DATA_TIMEOUT)) {
+		dev_err(&host->pdev->dev, "Buffer status ERROR 0x%04x - inside check buffer\n",
+		    buf_stat);
+		dev_err(&host->pdev->dev, "detail0 error status 0x%04x\n",
+		    toshsd_readw(host, SD_ERRORSTATUS0));
+		dev_err(&host->pdev->dev, "detail1 error status 0x%04x\n",
+		    toshsd_readw(host, SD_ERRORSTATUS1));
+		cmd->error = -EIO;
+	}
+
+	pr_debug("Command IRQ complete %d %d %x\n", cmd->opcode, cmd->error,
+	    cmd->flags);
+
+	if (cmd->error) {
+		toshsd_finish_request(host);
+		return;
+	}
+
+	/* If there is data to handle we enable data IRQs here, and we will
+	 * finish the request in the mmc_data_end_irq handler.*/
+	if (host->data) {
+		bmask = toshsd_readw(host, SD_INTMASKBUFFER);
+		/* Enable the read or write enable interrupt */
+		if (host->data->flags & MMC_DATA_READ)
+			bmask &= ~SD_BUF_READ_ENABLE;
+		else
+			bmask &= ~SD_BUF_WRITE_ENABLE;
+		toshsd_writew(host, SD_INTMASKBUFFER, bmask);
+		return;
+	}
+
+	toshsd_finish_request(host);
+}
+
+static void toshsd_data_end_irq(struct toshsd_host *host)
+{
+	struct mmc_data *data = host->data;
+	int bmask;
+
+	host->data = NULL;
+
+	if (!data) {
+		dev_warn(&host->pdev->dev, "Spurious data end IRQ\n");
+		return;
+	}
+
+	if (data->error == 0)
+		data->bytes_xfered = data->blocks * data->blksz;
+	else
+		data->bytes_xfered = 0;
+
+	pr_debug("Completed data request xfr=%d\n", data->bytes_xfered);
+
+	toshsd_writew(host, SD_STOPINTERNAL, 0);
+
+	/* Make sure read enable and write enable interrupts are disabled */
+	bmask = toshsd_readw(host, SD_INTMASKBUFFER);
+	if (data->flags & MMC_DATA_READ)
+		bmask |= SD_BUF_READ_ENABLE;
+	else
+		bmask |= SD_BUF_WRITE_ENABLE;
+	toshsd_writew(host, SD_INTMASKBUFFER, bmask);
+
+	toshsd_finish_request(host);
+}
+
+static irqreturn_t toshsd_irq(int irq, void *dev_id)
+{
+	struct toshsd_host *host = dev_id;
+	unsigned int breg, bmask, bstatus, creg, cmask, cstatus;
+	bool first = true;
+
+	spin_lock(&host->lock);
+	do {
+		bstatus = toshsd_readw(host, SD_BUFFERCTRL);
+		bmask = toshsd_readw(host, SD_INTMASKBUFFER);
+		cstatus = toshsd_readw(host, SD_CARDSTATUS);
+		cmask = toshsd_readw(host, SD_INTMASKCARD);
+		breg = bstatus & ~bmask & ~IRQ_DONT_CARE_BUFFER_BITS;
+		creg = cstatus & ~cmask & ~IRQ_DONT_CARE_CARD_BITS;
+
+		pr_debug("IRQ bstatus:%x bmask:%x cstatus:%x cmask:%x\n",
+					bstatus, bmask, cstatus, cmask);
+
+		/* nothing to do right in the first pass: it's not our IRQ */
+		if (first && !breg && !creg) {
+			spin_unlock(&host->lock);
+			return IRQ_NONE;
+		}
+
+		first = false;
+
+		/* TODO: Need to handle rest of errors in breg here. */
+		if (breg & SD_BUF_CMD_TIMEOUT) {
+			toshsd_writew(host, SD_BUFFERCTRL,
+				      bstatus & ~SD_BUF_CMD_TIMEOUT);
+		}
+
+		/* Card insert/remove. The mmc controlling code is stateless. */
+		if (creg & (SD_CARD_CARD_INSERTED_0 | SD_CARD_CARD_REMOVED_0)) {
+			toshsd_writew(host, SD_CARDSTATUS, cstatus &
+				      ~(SD_CARD_CARD_REMOVED_0 |
+					SD_CARD_CARD_INSERTED_0));
+
+			if (creg & SD_CARD_CARD_INSERTED_0)
+				toshsd_init(host);
+
+			mmc_detect_change(host->mmc, 1);
+		}
+
+		/* Command completion */
+		if (creg & SD_CARD_RESP_END) {
+			toshsd_writew(host, SD_CARDSTATUS,
+				      cstatus & ~(SD_CARD_RESP_END));
+
+			toshsd_cmd_irq(host, bstatus);
+		}
+
+		/* Data transfer */
+		if (breg & (SD_BUF_READ_ENABLE | SD_BUF_WRITE_ENABLE)) {
+			toshsd_writew(host, SD_BUFFERCTRL, bstatus &
+				      ~(SD_BUF_WRITE_ENABLE |
+					SD_BUF_READ_ENABLE));
+
+			tasklet_schedule(&host->data_read_tasklet);
+		}
+
+		/* Data transfer completion */
+		if (creg & SD_CARD_RW_END) {
+			toshsd_writew(host, SD_CARDSTATUS,
+				      cstatus & ~(SD_CARD_RW_END));
+			toshsd_data_end_irq(host);
+		}
+
+		/* keep going until we've handled it all */
+	} while (breg || creg);
+
+	spin_unlock(&host->lock);
+	return IRQ_HANDLED;
+}
+
+static void toshsd_start_cmd(struct toshsd_host *host, struct mmc_command *cmd)
+{
+	struct mmc_data *data = host->data;
+	int c = cmd->opcode;
+
+	pr_debug("Command opcode: %d\n", cmd->opcode);
+
+	if (cmd->opcode == MMC_STOP_TRANSMISSION) {
+		toshsd_writew(host, SD_STOPINTERNAL,
+			      SD_STOPINT_ISSSUE_CMD12);
+
+		cmd->resp[0] = cmd->opcode;
+		cmd->resp[1] = 0;
+		cmd->resp[2] = 0;
+		cmd->resp[3] = 0;
+
+		return;
+	}
+
+	switch (mmc_resp_type(cmd)) {
+	case MMC_RSP_NONE:
+		c |= SD_CMD_RESP_TYPE_NORMAL;
+		break;
+
+	case MMC_RSP_R1:
+		c |= SD_CMD_RESP_TYPE_EXT_R1;
+		break;
+	case MMC_RSP_R1B:
+		c |= SD_CMD_RESP_TYPE_EXT_R1B;
+		break;
+	case MMC_RSP_R2:
+		c |= SD_CMD_RESP_TYPE_EXT_R2;
+		break;
+	case MMC_RSP_R3:
+		c |= SD_CMD_RESP_TYPE_EXT_R3;
+		break;
+
+	default:
+		dev_err(&host->pdev->dev, "Unknown response type %d\n",
+			mmc_resp_type(cmd));
+		break;
+	}
+
+	host->cmd = cmd;
+
+	if (cmd->opcode == MMC_APP_CMD)
+		c |= SD_CMD_TYPE_ACMD;
+
+	if (cmd->opcode == MMC_GO_IDLE_STATE)
+		c |= (3 << 8);  /* removed from ipaq-asic3.h for some reason */
+
+	if (data) {
+		c |= SD_CMD_DATA_PRESENT;
+
+		if (data->blocks > 1) {
+			toshsd_writew(host, SD_STOPINTERNAL,
+				      SD_STOPINT_AUTO_ISSUE_CMD12);
+			c |= SD_CMD_MULTI_BLOCK;
+		}
+
+		if (data->flags & MMC_DATA_READ)
+			c |= SD_CMD_TRANSFER_READ;
+
+		/* MMC_DATA_WRITE does not require a bit to be set */
+	}
+
+	/* Send the command */
+	toshsd_writew(host, SD_ARG1, cmd->arg >> 16);
+	toshsd_writew(host, SD_ARG0, cmd->arg & 0xffff);
+	toshsd_writew(host, SD_CMD, c);
+}
+
+static void toshsd_start_data(struct toshsd_host *host, struct mmc_data *data)
+{
+	unsigned int flags = SG_MITER_ATOMIC;
+
+	pr_debug("setup data transfer: blocksize %08x  nr_blocks %d, offset: %08x\n",
+				data->blksz, data->blocks, data->sg->offset);
+
+	host->data = data;
+
+	if (data->flags & MMC_DATA_READ)
+		flags |= SG_MITER_TO_SG;
+	else
+		flags |= SG_MITER_FROM_SG;
+
+	sg_miter_start(&host->sg_miter, data->sg, data->sg_len, flags);
+
+	/* Set transfer length and blocksize */
+	toshsd_writew(host, SD_BLOCKCOUNT, data->blocks);
+	toshsd_writew(host, SD_CARDXFERDATALEN, data->blksz);
+}
+
+/* Process requests from the MMC layer */
+static void toshsd_request(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	struct toshsd_host *host = mmc_priv(mmc);
+	unsigned long flags;
+
+	/* abort if card not present */
+	if (!(toshsd_readw(host, SD_CARDSTATUS) & SD_CARD_PRESENT_0)) {
+		mrq->cmd->error = -ENOMEDIUM;
+		mmc_request_done(mmc, mrq);
+		return;
+	}
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	WARN_ON(host->mrq != NULL);
+
+	host->mrq = mrq;
+
+	if (mrq->data)
+		toshsd_start_data(host, mrq->data);
+
+	toshsd_start_cmd(host, mrq->cmd);
+
+	toshsd_set_led(host, 1);
+
+	spin_unlock_irqrestore(&host->lock, flags);
+}
+
+/* Set MMC clock / power.
+ * Note: This controller uses a simple divider scheme therefore it cannot run
+ * SD/MMC cards at full speed (24/20MHz). HCLK (=33MHz PCI clock?) is too high
+ * and the next slowest is 16MHz (div=2).
+ */
+static void toshsd_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	struct toshsd_host *host = mmc_priv(mmc);
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	if (ios->clock) {
+		u16 clk;
+		int div = 1;
+
+		while (ios->clock < HCLK / div)
+			div *= 2;
+
+		clk = div >> 2;
+
+		if (div == 1) { /* disable the divider */
+			pci_write_config_byte(host->pdev, SD_PCICFG_CLKMODE,
+					      SD_PCICFG_CLKMODE_DIV_DISABLE);
+			clk |= SD_CARDCLK_DIV_DISABLE;
+		} else
+			pci_write_config_byte(host->pdev, SD_PCICFG_CLKMODE, 0);
+
+		clk |= SD_CARDCLK_ENABLE_CLOCK;
+		toshsd_writew(host, SD_CARDCLOCKCTRL, clk);
+
+		mdelay(10);
+	} else
+		toshsd_writew(host, SD_CARDCLOCKCTRL, 0);
+
+	switch (ios->power_mode) {
+	case MMC_POWER_OFF:
+		pci_write_config_byte(host->pdev, SD_PCICFG_POWER1,
+					SD_PCICFG_PWR1_OFF);
+		mdelay(1);
+		break;
+	case MMC_POWER_UP:
+		break;
+	case MMC_POWER_ON:
+		pci_write_config_byte(host->pdev, SD_PCICFG_POWER1,
+					SD_PCICFG_PWR1_33V);
+		pci_write_config_byte(host->pdev, SD_PCICFG_POWER2,
+					SD_PCICFG_PWR2_AUTO);
+		mdelay(20);
+		break;
+	}
+
+	switch (ios->bus_width) {
+	case MMC_BUS_WIDTH_1:
+		toshsd_writew(host, SD_CARDOPTIONSETUP, SD_CARDOPT_REQUIRED
+				| SD_CARDOPT_DATA_RESP_TIMEOUT(14)
+				| SD_CARDOPT_C2_MODULE_ABSENT
+				| SD_CARDOPT_DATA_XFR_WIDTH_1);
+		break;
+	case MMC_BUS_WIDTH_4:
+		toshsd_writew(host, SD_CARDOPTIONSETUP, SD_CARDOPT_REQUIRED
+				| SD_CARDOPT_DATA_RESP_TIMEOUT(14)
+				| SD_CARDOPT_C2_MODULE_ABSENT
+				| SD_CARDOPT_DATA_XFR_WIDTH_4);
+		break;
+	}
+
+	spin_unlock_irqrestore(&host->lock, flags);
+}
+
+static int toshsd_get_ro(struct mmc_host *mmc)
+{
+	struct toshsd_host *host = mmc_priv(mmc);
+
+	/* active low */
+	return !(toshsd_readw(host, SD_CARDSTATUS) & SD_CARD_WRITE_PROTECT);
+}
+
+static int toshsd_get_cd(struct mmc_host *mmc)
+{
+	struct toshsd_host *host = mmc_priv(mmc);
+
+	return !!(toshsd_readw(host, SD_CARDSTATUS) & SD_CARD_PRESENT_0);
+}
+
+static struct mmc_host_ops toshsd_ops = {
+	.request = toshsd_request,
+	.set_ios = toshsd_set_ios,
+	.get_ro = toshsd_get_ro,
+	.get_cd = toshsd_get_cd,
+};
+
+static void toshsd_init(struct toshsd_host *host)
+{
+	/* enable clock */
+	pci_write_config_byte(host->pdev, SD_PCICFG_CLKSTOP,
+					SD_PCICFG_CLKSTOP_ENABLE_ALL);
+	pci_write_config_byte(host->pdev, SD_PCICFG_CARDDETECT, 2);
+
+	/* reset */
+	toshsd_writew(host, SD_SOFTWARERESET, 0); /* assert */
+	mdelay(2);
+	toshsd_writew(host, SD_SOFTWARERESET, 1); /* deassert */
+	mdelay(2);
+
+	/* Clear card registers */
+	toshsd_writew(host, SD_CARDCLOCKCTRL, 0);
+	toshsd_writew(host, SD_CARDSTATUS, 0);
+	toshsd_writew(host, SD_BUFFERCTRL, 0);
+	toshsd_writew(host, SD_ERRORSTATUS0, 0);
+	toshsd_writew(host, SD_ERRORSTATUS1, 0);
+	toshsd_writew(host, SD_STOPINTERNAL, 0);
+
+	/* SDIO clock? */
+	toshsd_writew(host, SDIO_BASE + SDIO_CLOCKNWAITCTRL, 0x100);
+
+	/* enable LED */
+	pci_write_config_byte(host->pdev, SD_PCICFG_SDLED_ENABLE1,
+					SD_PCICFG_LED_ENABLE1_START);
+	pci_write_config_byte(host->pdev, SD_PCICFG_SDLED_ENABLE2,
+					SD_PCICFG_LED_ENABLE2_START);
+
+	/* set interrupt masks */
+	toshsd_writew(host, SD_INTMASKCARD, ~(SD_CARD_RESP_END
+					      | SD_CARD_RW_END
+					      | SD_CARD_CARD_REMOVED_0
+					      | SD_CARD_CARD_INSERTED_0));
+	/* everything except UNK7 and BUSY */
+	toshsd_writew(host, SD_INTMASKBUFFER, SD_BUF_UNK7 | SD_BUF_CMD_BUSY);
+
+	toshsd_writew(host, SD_TRANSACTIONCTRL, 0x1000);
+}
+
+static void toshsd_powerdown(struct toshsd_host *host)
+{
+	/* mask all interrupts */
+	toshsd_writew(host, SD_INTMASKCARD, 0xffff);
+	toshsd_writew(host, SD_INTMASKBUFFER, 0xffff);
+	/* disable card clock */
+	toshsd_writew(host, SDIO_BASE + SDIO_CLOCKNWAITCTRL, 0x000);
+	toshsd_writew(host, SD_CARDCLOCKCTRL, 0);
+	/* power down card */
+	pci_write_config_byte(host->pdev, SD_PCICFG_POWER1, SD_PCICFG_PWR1_OFF);
+	/* disable clock */
+	pci_write_config_byte(host->pdev, SD_PCICFG_CLKSTOP, 0);
+}
+
+#ifdef CONFIG_PM
+
+static int toshsd_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct toshsd_host *host = pci_get_drvdata(pdev);
+
+	toshsd_powerdown(host);
+
+	pci_save_state(pdev);
+	pci_enable_wake(pdev, pci_choose_state(pdev, state), 0);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+	return 0;
+}
+
+static int toshsd_resume(struct pci_dev *pdev)
+{
+	struct toshsd_host *host = pci_get_drvdata(pdev);
+	int ret;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	toshsd_init(host);
+
+	return 0;
+}
+
+#else /* CONFIG_PM */
+
+#define toshsd_suspend NULL
+#define toshsd_resume NULL
+
+#endif /* CONFIG_PM */
+
+static int toshsd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	int ret;
+	struct toshsd_host *host;
+	struct mmc_host *mmc;
+	resource_size_t base;
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	mmc = mmc_alloc_host(sizeof(struct toshsd_host), &pdev->dev);
+	if (!mmc) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	host = mmc_priv(mmc);
+	host->mmc = mmc;
+
+	host->pdev = pdev;
+	pci_set_drvdata(pdev, host);
+
+	ret = pci_request_regions(pdev, DRIVER_NAME);
+	if (ret)
+		goto free;
+
+	host->ioaddr = pci_iomap(pdev, 0, 0);
+	if (!host->ioaddr) {
+		ret = -ENOMEM;
+		goto release;
+	}
+
+	/* Set MMC host parameters */
+	mmc->ops = &toshsd_ops;
+	mmc->caps = MMC_CAP_4_BIT_DATA;
+	mmc->ocr_avail = MMC_VDD_32_33;
+
+	mmc->f_min = HCLK / 512;
+	mmc->f_max = HCLK;
+
+	spin_lock_init(&host->lock);
+
+	tasklet_init(&host->data_read_tasklet, toshsd_data_transfer,
+		     (unsigned long) host);
+
+	toshsd_init(host);
+
+	ret = request_irq(pdev->irq, toshsd_irq, IRQF_SHARED, DRIVER_NAME,
+			  host);
+	if (ret)
+		goto untasklet;
+
+	mmc_add_host(mmc);
+
+	base = pci_resource_start(pdev, 0);
+	dev_info(&pdev->dev, "MMIO %pa, IRQ %d\n", &base, pdev->irq);
+
+	return 0;
+
+untasklet:
+	tasklet_kill(&host->data_read_tasklet);
+	pci_iounmap(pdev, host->ioaddr);
+release:
+	pci_release_regions(pdev);
+free:
+	mmc_free_host(mmc);
+	pci_set_drvdata(pdev, NULL);
+err:
+	pci_disable_device(pdev);
+	return ret;
+}
+
+static void toshsd_remove(struct pci_dev *pdev)
+{
+	struct toshsd_host *host = pci_get_drvdata(pdev);
+
+	mmc_remove_host(host->mmc);
+	tasklet_kill(&host->data_read_tasklet);
+	toshsd_powerdown(host);
+	free_irq(pdev->irq, host);
+	pci_iounmap(pdev, host->ioaddr);
+	pci_release_regions(pdev);
+	mmc_free_host(host->mmc);
+	pci_set_drvdata(pdev, NULL);
+	pci_disable_device(pdev);
+}
+
+static struct pci_driver toshsd_driver = {
+	.name = DRIVER_NAME,
+	.id_table = pci_ids,
+	.probe = toshsd_probe,
+	.remove = toshsd_remove,
+	.suspend = toshsd_suspend,
+	.resume = toshsd_resume,
+};
+
+static int __init toshsd_drv_init(void)
+{
+	return pci_register_driver(&toshsd_driver);
+}
+
+static void __exit toshsd_drv_exit(void)
+{
+	pci_unregister_driver(&toshsd_driver);
+}
+
+module_init(toshsd_drv_init);
+module_exit(toshsd_drv_exit);
+
+MODULE_AUTHOR("Ondrej Zary, Richard Betts");
+MODULE_DESCRIPTION("Toshiba PCI Secure Digital Host Controller Interface driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mmc/host/toshsd.h b/drivers/mmc/host/toshsd.h
new file mode 100644
index 0000000..c56c9a0
--- /dev/null
+++ b/drivers/mmc/host/toshsd.h
@@ -0,0 +1,179 @@
+/*
+ *  Toshiba PCI Secure Digital Host Controller Interface driver
+ *
+ *  Copyright (C) 2013 Ondrej Zary
+ *  Copyright (C) 2007 Richard Betts, All Rights Reserved.
+ *
+ *      Based on asic3_mmc.c Copyright (c) 2005 SDG Systems, LLC
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ */
+
+#define HCLK	33000000	/* 33 MHz (PCI clock) */
+
+#define SD_PCICFG_CLKSTOP	0x40	/* 0x1f = clock controller, 0 = stop */
+#define SD_PCICFG_GATEDCLK	0x41	/* Gated clock */
+#define SD_PCICFG_CLKMODE	0x42	/* Control clock of SD controller */
+#define SD_PCICFG_PINSTATUS	0x44	/* R/O: read status of SD pins */
+#define SD_PCICFG_POWER1	0x48
+#define SD_PCICFG_POWER2	0x49
+#define SD_PCICFG_POWER3	0x4a
+#define SD_PCICFG_CARDDETECT	0x4c
+#define SD_PCICFG_SLOTS		0x50	/* R/O: define support slot number */
+#define SD_PCICFG_EXTGATECLK1	0xf0	/* Could be used for gated clock */
+#define SD_PCICFG_EXTGATECLK2	0xf1	/* Could be used for gated clock */
+#define SD_PCICFG_EXTGATECLK3	0xf9	/* Bit 1: double buffer/single buffer */
+#define SD_PCICFG_SDLED_ENABLE1	0xfa
+#define SD_PCICFG_SDLED_ENABLE2	0xfe
+
+#define SD_PCICFG_CLKMODE_DIV_DISABLE	(1 << 0)
+#define SD_PCICFG_CLKSTOP_ENABLE_ALL	0x1f
+#define SD_PCICFG_LED_ENABLE1_START	0x12
+#define SD_PCICFG_LED_ENABLE2_START	0x80
+
+#define SD_PCICFG_PWR1_33V	0x08	/* Set for 3.3 volts */
+#define SD_PCICFG_PWR1_OFF	0x00	/* Turn off power */
+#define SD_PCICFG_PWR2_AUTO	0x02
+
+#define SD_CMD			0x00	/* also for SDIO */
+#define SD_ARG0			0x04	/* also for SDIO */
+#define SD_ARG1			0x06	/* also for SDIO */
+#define SD_STOPINTERNAL		0x08
+#define SD_BLOCKCOUNT		0x0a	/* also for SDIO */
+#define SD_RESPONSE0		0x0c	/* also for SDIO */
+#define SD_RESPONSE1		0x0e	/* also for SDIO */
+#define SD_RESPONSE2		0x10	/* also for SDIO */
+#define SD_RESPONSE3		0x12	/* also for SDIO */
+#define SD_RESPONSE4		0x14	/* also for SDIO */
+#define SD_RESPONSE5		0x16	/* also for SDIO */
+#define SD_RESPONSE6		0x18	/* also for SDIO */
+#define SD_RESPONSE7		0x1a	/* also for SDIO */
+#define SD_CARDSTATUS		0x1c	/* also for SDIO */
+#define SD_BUFFERCTRL		0x1e	/* also for SDIO */
+#define SD_INTMASKCARD		0x20	/* also for SDIO */
+#define SD_INTMASKBUFFER	0x22	/* also for SDIO */
+#define SD_CARDCLOCKCTRL	0x24
+#define SD_CARDXFERDATALEN	0x26	/* also for SDIO */
+#define SD_CARDOPTIONSETUP	0x28	/* also for SDIO */
+#define SD_ERRORSTATUS0		0x2c	/* also for SDIO */
+#define SD_ERRORSTATUS1		0x2e	/* also for SDIO */
+#define SD_DATAPORT		0x30	/* also for SDIO */
+#define SD_TRANSACTIONCTRL	0x34	/* also for SDIO */
+#define SD_SOFTWARERESET	0xe0	/* also for SDIO */
+
+/* registers above marked "also for SDIO" and all SDIO registers below can be
+ * accessed at SDIO_BASE + reg address */
+#define SDIO_BASE	 0x100
+
+#define SDIO_CARDPORTSEL	0x02
+#define SDIO_CARDINTCTRL	0x36
+#define SDIO_CLOCKNWAITCTRL	0x38
+#define SDIO_HOSTINFORMATION	0x3a
+#define SDIO_ERRORCTRL		0x3c
+#define SDIO_LEDCTRL		0x3e
+
+#define SD_TRANSCTL_SET		(1 << 8)
+
+#define SD_CARDCLK_DIV_DISABLE	(1 << 15)
+#define SD_CARDCLK_ENABLE_CLOCK	(1 << 8)
+#define SD_CARDCLK_CLK_DIV_512	(1 << 7)
+#define SD_CARDCLK_CLK_DIV_256	(1 << 6)
+#define SD_CARDCLK_CLK_DIV_128	(1 << 5)
+#define SD_CARDCLK_CLK_DIV_64	(1 << 4)
+#define SD_CARDCLK_CLK_DIV_32	(1 << 3)
+#define SD_CARDCLK_CLK_DIV_16	(1 << 2)
+#define SD_CARDCLK_CLK_DIV_8	(1 << 1)
+#define SD_CARDCLK_CLK_DIV_4	(1 << 0)
+#define SD_CARDCLK_CLK_DIV_2	(0 << 0)
+
+#define SD_CARDOPT_REQUIRED		0x000e
+#define SD_CARDOPT_DATA_RESP_TIMEOUT(x)	(((x) & 0x0f) << 4) /* 4 bits */
+#define SD_CARDOPT_C2_MODULE_ABSENT	(1 << 14)
+#define SD_CARDOPT_DATA_XFR_WIDTH_1	(1 << 15)
+#define SD_CARDOPT_DATA_XFR_WIDTH_4	(0 << 15)
+
+#define SD_CMD_TYPE_CMD			(0 << 6)
+#define SD_CMD_TYPE_ACMD		(1 << 6)
+#define SD_CMD_TYPE_AUTHEN		(2 << 6)
+#define SD_CMD_RESP_TYPE_NORMAL		(0 << 8)
+#define SD_CMD_RESP_TYPE_EXT_R1		(4 << 8)
+#define SD_CMD_RESP_TYPE_EXT_R1B	(5 << 8)
+#define SD_CMD_RESP_TYPE_EXT_R2		(6 << 8)
+#define SD_CMD_RESP_TYPE_EXT_R3		(7 << 8)
+#define SD_CMD_RESP_TYPE_EXT_R6		(4 << 8)
+#define SD_CMD_RESP_TYPE_EXT_R7		(4 << 8)
+#define SD_CMD_DATA_PRESENT		(1 << 11)
+#define SD_CMD_TRANSFER_READ		(1 << 12)
+#define SD_CMD_MULTI_BLOCK		(1 << 13)
+#define SD_CMD_SECURITY_CMD		(1 << 14)
+
+#define SD_STOPINT_ISSSUE_CMD12		(1 << 0)
+#define SD_STOPINT_AUTO_ISSUE_CMD12	(1 << 8)
+
+#define SD_CARD_RESP_END	(1 << 0)
+#define SD_CARD_RW_END		(1 << 2)
+#define SD_CARD_CARD_REMOVED_0	(1 << 3)
+#define SD_CARD_CARD_INSERTED_0	(1 << 4)
+#define SD_CARD_PRESENT_0	(1 << 5)
+#define SD_CARD_UNK6		(1 << 6)
+#define SD_CARD_WRITE_PROTECT	(1 << 7)
+#define SD_CARD_CARD_REMOVED_3	(1 << 8)
+#define SD_CARD_CARD_INSERTED_3	(1 << 9)
+#define SD_CARD_PRESENT_3	(1 << 10)
+
+#define SD_BUF_CMD_INDEX_ERR	(1 << 0)
+#define SD_BUF_CRC_ERR		(1 << 1)
+#define SD_BUF_STOP_BIT_END_ERR	(1 << 2)
+#define SD_BUF_DATA_TIMEOUT	(1 << 3)
+#define SD_BUF_OVERFLOW		(1 << 4)
+#define SD_BUF_UNDERFLOW	(1 << 5)
+#define SD_BUF_CMD_TIMEOUT	(1 << 6)
+#define SD_BUF_UNK7		(1 << 7)
+#define SD_BUF_READ_ENABLE	(1 << 8)
+#define SD_BUF_WRITE_ENABLE	(1 << 9)
+#define SD_BUF_ILLEGAL_FUNCTION	(1 << 13)
+#define SD_BUF_CMD_BUSY		(1 << 14)
+#define SD_BUF_ILLEGAL_ACCESS	(1 << 15)
+
+#define SD_ERR0_RESP_CMD_ERR			(1 << 0)
+#define SD_ERR0_RESP_NON_CMD12_END_BIT_ERR	(1 << 2)
+#define SD_ERR0_RESP_CMD12_END_BIT_ERR		(1 << 3)
+#define SD_ERR0_READ_DATA_END_BIT_ERR		(1 << 4)
+#define SD_ERR0_WRITE_CRC_STATUS_END_BIT_ERR	(1 << 5)
+#define SD_ERR0_RESP_NON_CMD12_CRC_ERR		(1 << 8)
+#define SD_ERR0_RESP_CMD12_CRC_ERR		(1 << 9)
+#define SD_ERR0_READ_DATA_CRC_ERR		(1 << 10)
+#define SD_ERR0_WRITE_CMD_CRC_ERR		(1 << 11)
+
+#define SD_ERR1_NO_CMD_RESP		(1 << 0)
+#define SD_ERR1_TIMEOUT_READ_DATA	(1 << 4)
+#define SD_ERR1_TIMEOUT_CRS_STATUS	(1 << 5)
+#define SD_ERR1_TIMEOUT_CRC_BUSY	(1 << 6)
+
+#define IRQ_DONT_CARE_CARD_BITS (SD_CARD_PRESENT_3 \
+	| SD_CARD_WRITE_PROTECT \
+	| SD_CARD_UNK6 \
+	| SD_CARD_PRESENT_0)
+
+#define IRQ_DONT_CARE_BUFFER_BITS (SD_BUF_UNK7 \
+	| SD_BUF_CMD_BUSY)
+
+struct toshsd_host {
+	struct pci_dev *pdev;
+	struct mmc_host *mmc;
+
+	spinlock_t lock;
+
+	struct mmc_request *mrq;/* Current request */
+	struct mmc_command *cmd;/* Current command */
+	struct mmc_data *data;	/* Current data request */
+
+	struct sg_mapping_iter sg_miter; /* for PIO */
+
+	void __iomem *ioaddr; /* mapped address */
+
+	struct tasklet_struct data_read_tasklet;
+};

-- 
Ondrej Zary
