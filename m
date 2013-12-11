Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab3LKME3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:04:29 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:51191 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab3LKME0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:04:26 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-mmc@vger.kernel.org
Cc: cjb@laptop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org, mark.rutland@arm.com,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v5] mmc: sdhci-moxart: Add MOXA ART SDHCI driver
Date: Wed, 11 Dec 2013 13:03:46 +0100
Message-Id: <1386763426-10158-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1375797443-5990-1-git-send-email-jonas.jensen@gmail.com>
References: <1375797443-5990-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SDHCI driver for MOXA ART SoCs.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Changes since v4:
    
    1.  remove dma_chan_cur pointer from host structure
    2.  add local dma_chan_cur pointer in moxart_transfer_dma()
    3.  add dma_async_tx_descriptor pointer (host structure)
    4.  save descriptor pointers between transfers
    5.  use [3] to check for DMA transfer error (with dmaengine_tx_status())
    6.  use !!(condition) construct in moxart_get_ro()
    7.  set both source/destination DMA transfer width early in probe,
        this fixes the problem that dst_addr_width is left uninitialized
        for dma_chan_tx
    
        both "src_addr_width" and "dst_addr_width" (dma_slave_config)
        are now assigned DMA_SLAVE_BUSWIDTH_4_BYTES
        (before configuring channels with dmaengine_slave_config())
    
    8.  remove redundant dev_err() call in moxart_probe(),
        devm_ioremap_resource() prints a similar message
    9.  use dev_err(), not pr_err() in moxart_transfer_dma()
    10. bail on irq_of_parse_and_map() failure
    11. remove unused host variable "wait_for"
    12. change driver name and compatible strings "mmc" to "sdhci"
    
    Applies to next-20131211

 .../devicetree/bindings/mmc/moxa,moxart-sdhci.txt  |  28 +
 drivers/mmc/host/Kconfig                           |   9 +
 drivers/mmc/host/Makefile                          |   1 +
 drivers/mmc/host/sdhci-moxart.c                    | 929 +++++++++++++++++++++
 4 files changed, 967 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mmc/moxa,moxart-sdhci.txt
 create mode 100644 drivers/mmc/host/sdhci-moxart.c

diff --git a/Documentation/devicetree/bindings/mmc/moxa,moxart-sdhci.txt b/Documentation/devicetree/bindings/mmc/moxa,moxart-sdhci.txt
new file mode 100644
index 0000000..020b13e
--- /dev/null
+++ b/Documentation/devicetree/bindings/mmc/moxa,moxart-sdhci.txt
@@ -0,0 +1,28 @@
+MOXA ART SD Host Controller Interface
+
+Required properties:
+
+- compatible :	Must be "moxa,moxart-sdhci"
+- reg :		Should contain registers location and length
+- interrupts :	Should contain the interrupt number
+- clocks :	Should contain phandle for the clock feeding the SDHCI controller
+
+Optional properties:
+
+These are optional but required to enable DMA transfer mode:
+
+- dmas :	Should contain two DMA channels, line request number must be 5 for
+		both channels
+- dma-names :	Must be "tx", "rx"
+
+Example:
+
+	sdhci: sdhci@98e00000 {
+		compatible = "moxa,moxart-sdhci";
+		reg = <0x98e00000 0x5C>;
+		interrupts = <5 0>;
+		clocks = <&coreclk>;
+		dmas =  <&dma 0 5>,
+			<&dma 1 5>;
+		dma-names = "tx", "rx";
+	};
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 7fc5099..3421424 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -271,6 +271,15 @@ config MMC_SDHCI_BCM2835
 
 	  If unsure, say N.
 
+config MMC_SDHCI_MOXART
+	tristate "MOXART SD Host Controller Interface support"
+	depends on ARCH_MOXART && MMC
+	help
+	  This selects the MOXART SD Host Controller Interface.
+	  MOXA provides one multi-functional card reader which can
+	  be found on some embedded hardware such as UC-7112-LX.
+	  If you have a controller with this interface, say Y here.
+
 config MMC_OMAP
 	tristate "TI OMAP Multimedia Card Interface support"
 	depends on ARCH_OMAP
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index c41d0c3..7f6ebc3 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_MMC_SDHCI_OF_ESDHC)	+= sdhci-of-esdhc.o
 obj-$(CONFIG_MMC_SDHCI_OF_HLWD)		+= sdhci-of-hlwd.o
 obj-$(CONFIG_MMC_SDHCI_BCM_KONA)	+= sdhci-bcm-kona.o
 obj-$(CONFIG_MMC_SDHCI_BCM2835)		+= sdhci-bcm2835.o
+obj-$(CONFIG_MMC_SDHCI_MOXART)		+= sdhci-moxart.o
 
 ifeq ($(CONFIG_CB710_DEBUG),y)
 	CFLAGS-cb710-mmc	+= -DDEBUG
diff --git a/drivers/mmc/host/sdhci-moxart.c b/drivers/mmc/host/sdhci-moxart.c
new file mode 100644
index 0000000..5fb854e
--- /dev/null
+++ b/drivers/mmc/host/sdhci-moxart.c
@@ -0,0 +1,929 @@
+/*
+ * MOXA ART MMC host driver.
+ *
+ * Copyright (C) 2013 Jonas Jensen
+ *
+ * Jonas Jensen <jonas.jensen@gmail.com>
+ *
+ * Based on code from
+ * Moxa Technologies Co., Ltd. <www.moxa.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/blkdev.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/sd.h>
+#include <linux/mmc/mmc.h>
+#include <linux/sched.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <linux/sizes.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/clk.h>
+#include <linux/bitops.h>
+#include <linux/of_dma.h>
+
+#include <asm/dma.h>
+#include <asm/irq.h>
+
+#define MSD_CMD_REG		0
+#define MSD_ARG_REG		4
+#define MSD_RESP0_REG		8
+#define MSD_RESP1_REG		0x0c
+#define MSD_RESP2_REG		0x10
+#define MSD_RESP3_REG		0x14
+#define MSD_RESP_CMD_REG	0x18
+#define MSD_DATA_CTRL_REG	0x1c
+#define MSD_DATA_TIMER_REG	0x20
+#define MSD_DATA_LEN_REG	0x24
+#define MSD_STATUS_REG		0x28
+#define MSD_CLEAR_REG		0x2c
+#define MSD_INT_MASK_REG	0x30
+#define MSD_POWER_CTRL_REG	0x34
+#define MSD_CLOCK_CTRL_REG	0x38
+#define MSD_BUS_WIDTH_REG	0x3c
+#define MSD_DATA_WIN_REG	0x40
+#define MSD_FEATURE_REG		0x44
+#define MSD_REVISION_REG	0x48
+
+#define MMC_RSP_SHORT		1
+#define MMC_RSP_LONG		2
+#define MMC_RSP_MASK		3
+#define MMC_ERR_NONE		0
+#define MMC_ERR_TIMEOUT		1
+#define MMC_MODE_MMC		0
+#define MMC_MODE_SD		1
+#define MMC_ERR_BADCRC		2
+#define MMC_VDD_360		23
+
+#define MSD_RETRY_COUNT		10
+
+#define REG_COMMAND		0
+#define REG_ARGUMENT		4
+#define REG_RESPONSE0		8
+#define REG_RESPONSE1		12
+#define REG_RESPONSE2		16
+#define REG_RESPONSE3		20
+#define REG_RESPONSE_COMMAND	24
+#define REG_DATA_CONTROL	28
+#define REG_DATA_TIMER		32
+#define REG_DATA_LENGTH		36
+#define REG_STATUS		40
+#define REG_CLEAR		44
+#define REG_INTERRUPT_MASK	48
+#define REG_POWER_CONTROL	52
+#define REG_CLOCK_CONTROL	56
+#define REG_BUS_WIDTH		60
+#define REG_DATA_WINDOW		64
+#define REG_FEATURE		68
+#define REG_REVISION		72
+
+/* REG_COMMAND */
+#define MSD_SDC_RST		BIT(10)
+#define MSD_CMD_EN		BIT(9)
+#define MSD_APP_CMD		BIT(8)
+#define MSD_LONG_RSP		BIT(7)
+#define MSD_NEED_RSP		BIT(6)
+#define MSD_CMD_IDX_MASK	0x3f
+
+/* REG_RESPONSE_COMMAND */
+#define MSD_RSP_CMD_APP		BIT(6)
+#define MSD_RSP_CMD_IDX_MASK	0x3f
+
+/* REG_DATA_CONTROL */
+#define MSD_DATA_EN		BIT(6)
+#define MSD_DMA_EN		BIT(5)
+#define MSD_DATA_WRITE		BIT(4)
+#define MSD_BLK_SIZE_MASK	0x0f
+
+/* REG_DATA_LENGTH */
+#define MSD_DATA_LEN_MASK	0xffffff
+
+/* REG_STATUS */
+#define MSD_WRITE_PROT		BIT(12)
+#define MSD_CARD_DETECT		BIT(11)
+/* 1-10 below can be sent to interrupt or clear register */
+#define MSD_CARD_CHANGE		BIT(10)
+#define MSD_FIFO_ORUN		BIT(9)
+#define MSD_FIFO_URUN		BIT(8)
+#define MSD_DATA_END		BIT(7)
+#define MSD_CMD_SENT		BIT(6)
+#define MSD_DATA_CRC_OK		BIT(5)
+#define MSD_RSP_CRC_OK		BIT(4)
+#define MSD_DATA_TIMEOUT	BIT(3)
+#define MSD_RSP_TIMEOUT		BIT(2)
+#define MSD_DATA_CRC_FAIL	BIT(1)
+#define MSD_RSP_CRC_FAIL	BIT(0)
+
+/* REG_POWER_CONTROL */
+#define MSD_SD_POWER_ON		BIT(4)
+#define MSD_SD_POWER_MASK	0x0f
+
+/* REG_CLOCK_CONTROL */
+#define MSD_CLK_DIS		BIT(8)
+#define MSD_CLK_SD		BIT(7)
+#define MSD_CLK_DIV_MASK	0x7f
+
+/* REG_BUS_WIDTH */
+#define MSD_WIDE_BUS_SUPPORT	BIT(3)
+#define MSD_WIDE_BUS		BIT(2)	/* bus width is 4 bytes */
+#define MSD_SINGLE_BUS		BIT(0)	/* bus width is 1 byte */
+
+/* REG_FEATURE */
+#define MSD_CPRM_FUNCTION	BIT(8)
+
+struct moxart_host {
+	spinlock_t			lock;
+	void __iomem			*base;
+	phys_addr_t			reg_phys;
+
+	struct dma_chan			*dma_chan_rx;
+	struct dma_chan			*dma_chan_tx;
+	struct dma_async_tx_descriptor	*tx_desc;
+	unsigned int			dma_direction;
+	bool				have_dma;
+	struct completion		dma_complete;
+	struct completion		pio_complete;
+
+	struct mmc_host			*mmc;
+	struct mmc_request		*mrq;
+
+	struct scatterlist		*cur_sg;
+	unsigned int			num_sg;
+	unsigned int			remain;
+	int				size;
+
+	unsigned int			timeout;
+	long				sysclk;
+	bool				removed;
+};
+
+#define MSD_FIFO_LENW	4	/* 4 words, total 4 * 4 = 16 bytes */
+#define MSD_FIFO_LENB	16	/* 16 bytes */
+
+#define DMA_FIFO_LEN_FORCE		0
+#define MIN_POWER (MMC_VDD_360 - MSD_SD_POWER_MASK)
+
+static inline void moxart_init_sg(struct moxart_host *host,
+				  struct mmc_data *data)
+{
+	host->cur_sg = data->sg;
+	host->num_sg = data->sg_len;
+	host->remain = host->cur_sg->length;
+
+	if (host->remain > host->size)
+		host->remain = host->size;
+
+	data->error = MMC_ERR_NONE;
+}
+
+static inline int moxart_next_sg(struct moxart_host *host)
+{
+	int remain;
+	struct mmc_data *data = host->mrq->cmd->data;
+
+	host->cur_sg++;
+	host->num_sg--;
+
+	if (host->num_sg > 0) {
+		host->remain = host->cur_sg->length;
+		remain = host->size - data->bytes_xfered;
+		if (remain > 0 && remain < host->remain)
+			host->remain = remain;
+	}
+
+	return host->num_sg;
+}
+
+static void moxart_send_command(struct moxart_host *host,
+	struct mmc_command *cmd)
+{
+	unsigned int status, cmdctrl;
+	int retry = 0;
+
+	dev_dbg(mmc_dev(host->mmc), "%s: cmd->opcode=%d\n",
+		__func__, cmd->opcode);
+
+	cmd->error = MMC_ERR_TIMEOUT;
+
+	writel(MSD_RSP_TIMEOUT | MSD_RSP_CRC_OK |
+	       MSD_RSP_CRC_FAIL | MSD_CMD_SENT, host->base + REG_CLEAR);
+	writel(cmd->arg, host->base + REG_ARGUMENT);
+
+	cmdctrl = cmd->opcode & MSD_CMD_IDX_MASK;
+	if (cmdctrl == SD_APP_SET_BUS_WIDTH || cmdctrl == SD_APP_OP_COND ||
+	    cmdctrl == SD_APP_SEND_SCR || cmdctrl == SD_APP_SD_STATUS ||
+	    cmdctrl == SD_APP_SEND_NUM_WR_BLKS)
+		cmdctrl |= MSD_APP_CMD;
+
+	if (cmd->flags & MMC_RSP_136)
+		cmdctrl |= (MSD_LONG_RSP | MSD_NEED_RSP);
+	else
+		cmdctrl |= MSD_NEED_RSP;
+
+	writel(cmdctrl | MSD_CMD_EN, host->base + REG_COMMAND);
+
+	while (retry++ < MSD_RETRY_COUNT) {
+		udelay(10);
+		status = readl(host->base + REG_STATUS);
+		if (status & MSD_CARD_DETECT) {
+			dev_dbg(mmc_dev(host->mmc), "%s: MSD_CARD_DETECT\n",
+				__func__);
+			cmd->error = MMC_ERR_TIMEOUT;
+			break;
+		}
+		if (cmdctrl & MSD_NEED_RSP) {
+			dev_dbg(mmc_dev(host->mmc), "%s: MSD_NEED_RSP\n",
+				__func__);
+			if (status & MSD_RSP_TIMEOUT) {
+				dev_dbg(mmc_dev(host->mmc), "%s: MSD_RSP_TIMEOUT\n",
+					__func__);
+				writel(MSD_RSP_TIMEOUT, host->base + REG_CLEAR);
+				cmd->error = MMC_ERR_TIMEOUT;
+				break;
+			}
+			if ((cmd->flags & MMC_RSP_CRC) &&
+				(status & MSD_RSP_CRC_FAIL)) {
+				dev_dbg(mmc_dev(host->mmc), "%s: MSD_RSP_CRC_FAIL\n",
+					__func__);
+				writel(MSD_RSP_CRC_FAIL, host->base +
+				       REG_CLEAR);
+				cmd->error = MMC_ERR_BADCRC;
+				break;
+			}
+			if (status & MSD_RSP_CRC_OK) {
+				dev_dbg(mmc_dev(host->mmc), "%s: MSD_RSP_CRC_OK\n",
+					__func__);
+				writel(MSD_RSP_CRC_OK, host->base + REG_CLEAR);
+
+				if (cmd->flags & MMC_RSP_136) {
+					cmd->resp[3] =
+						readl(host->base +
+						      REG_RESPONSE0);
+					cmd->resp[2] =
+						readl(host->base +
+						      REG_RESPONSE1);
+					cmd->resp[1] =
+						readl(host->base +
+						      REG_RESPONSE2);
+					cmd->resp[0] =
+						readl(host->base +
+						      REG_RESPONSE3);
+				} else {
+					cmd->resp[0] =
+						readl(host->base +
+						      REG_RESPONSE0);
+				}
+
+				cmd->error = MMC_ERR_NONE;
+				break;
+			}
+		} else {
+			dev_dbg(mmc_dev(host->mmc), "%s: !(cmdctrl & MSD_NEED_RSP)\n",
+				__func__);
+			if (status & MSD_CMD_SENT) {
+				writel(MSD_CMD_SENT, host->base + REG_CLEAR);
+				cmd->error = MMC_ERR_NONE;
+				break;
+			}
+		}
+	}
+
+	if (retry >= (MSD_RETRY_COUNT - 1)) {
+		/*
+		 * this seems to happen a lot on or after CMD25
+		 * (MMC_WRITE_MULTIPLE_BLOCK) with more than 4 blocks
+		 * (>4096), possibly because the transfer is too big
+		 * or takes too long to complete.
+		 * when this happens the controller is usually rendered
+		 * unresponsive and can only be recovered with reboot.
+		 */
+		dev_dbg(mmc_dev(host->mmc), "%s: WARNING! no valid status found!\n",
+			__func__);
+	}
+}
+
+static void moxart_dma_complete(void *param)
+{
+	struct moxart_host		*host = param;
+	struct dma_chan			*chan = host->tx_desc->chan;
+	struct dma_tx_state		txs;
+
+	if (dmaengine_tx_status(chan, chan->cookie, &txs) == DMA_ERROR)
+		dev_err_ratelimited(mmc_dev(host->mmc), "%s: DMA error\n",
+				    __func__);
+
+	dev_dbg(mmc_dev(host->mmc), "%s: host=%p\n", __func__, host);
+	complete(&host->dma_complete);
+}
+
+static void moxart_transfer_dma(struct mmc_data *data, struct moxart_host *host)
+{
+	unsigned int len, direction_dev;
+	struct dma_async_tx_descriptor *desc = NULL;
+	struct dma_chan *dma_chan_cur;
+
+	if (host->size == data->bytes_xfered)
+		return;
+
+	if (data->flags & MMC_DATA_WRITE) {
+		direction_dev = DMA_MEM_TO_DEV;
+		dma_chan_cur = host->dma_chan_tx;
+	} else {
+		direction_dev = DMA_DEV_TO_MEM;
+		dma_chan_cur = host->dma_chan_rx;
+	}
+
+	/*
+	 * because dma_map_sg takes both sg and sg_len as arguments
+	 * (and maps the entire list of buffers) data->sg does not
+	 * have to be incremented between calls (as is required
+	 * in moxart_transfer_pio)
+	 */
+	len = dma_map_sg(dma_chan_cur->device->dev, data->sg,
+			 data->sg_len, host->dma_direction);
+
+	if (len > 0) {
+		desc = dmaengine_prep_slave_sg(dma_chan_cur, data->sg,
+					       len, direction_dev,
+					       DMA_PREP_INTERRUPT |
+					       DMA_CTRL_ACK);
+	} else {
+		dev_err(mmc_dev(host->mmc),
+			"%s: dma_map_sg returned zero length\n",
+			__func__);
+	}
+
+	if (desc) {
+		host->tx_desc = desc;
+		desc->callback = moxart_dma_complete;
+		desc->callback_param = host;
+		dmaengine_submit(desc);
+		dma_async_issue_pending(dma_chan_cur);
+	}
+
+	data->bytes_xfered += host->remain;
+}
+
+/* when DMA is available this is used only for SD_APP_SEND_SCR */
+static void moxart_transfer_pio(struct moxart_host *host)
+{
+	unsigned char *buffer;
+	unsigned int wcnt, i;
+	struct mmc_data *data = host->mrq->cmd->data;
+
+	if (host->size == data->bytes_xfered)
+		goto transfer_complete;
+
+	buffer = sg_virt(host->cur_sg);
+	wcnt = host->remain >> 2;
+
+	if (data->flags & MMC_DATA_WRITE) {
+		for (i = 0; i < wcnt; i++, buffer += 4) {
+			writel(*(unsigned int *)buffer,
+			       host->base + REG_DATA_WINDOW);
+			udelay(10);
+		}
+	} else {
+		for (i = 0; i < wcnt; i++, buffer += 4) {
+			/* byte order reversed only when reading SCR */
+			if (data->mrq->cmd->opcode == SD_APP_SEND_SCR) {
+				*(unsigned int *)buffer = ioread32be(
+					host->base + REG_DATA_WINDOW);
+			} else {
+				*(unsigned int *)buffer =
+					readl(host->base + REG_DATA_WINDOW);
+			}
+			udelay(10);
+		}
+	}
+	wcnt <<= 2;
+	host->remain -= wcnt;
+	data->bytes_xfered += wcnt;
+
+	if (host->size != data->bytes_xfered) {
+		moxart_next_sg(host);
+		/*
+		 * used to goto "transfer_start" label here,
+		 * there is no need, this function will be
+		 * called again from interrupt.
+		 *
+		 * compare with DMA where sg increment is
+		 * redundant thanks to dma_map_sg
+		 */
+	} else {
+		complete(&host->pio_complete);
+	}
+
+transfer_complete:
+	dev_dbg(mmc_dev(host->mmc), "%s: host->size=%d host->remain=%u\n",
+		__func__, host->size, host->remain);
+}
+
+static void moxart_prepare_data(struct moxart_host *host)
+{
+	struct mmc_data *data = host->mrq->cmd->data;
+	unsigned int timeout, datactrl;
+	int blksz_bits;
+
+	dev_dbg(mmc_dev(host->mmc), "%s\n", __func__);
+
+	if (!data)
+		return;
+
+	host->size = data->blocks * data->blksz;
+	blksz_bits = ffs(data->blksz) - 1;
+	BUG_ON(1 << blksz_bits != data->blksz);
+
+	moxart_init_sg(host, data);
+
+	timeout = (host->mmc->f_max / 1000) * (data->timeout_ns / 1000);
+	timeout *= 2;
+
+	datactrl = (blksz_bits & MSD_BLK_SIZE_MASK) | MSD_DATA_EN;
+
+	if (data->flags & MMC_DATA_WRITE)
+		datactrl |= MSD_DATA_WRITE;
+
+	if (((host->size > MSD_FIFO_LENB) || DMA_FIFO_LEN_FORCE)
+	    && host->have_dma) {
+		datactrl |= MSD_DMA_EN;
+	}
+
+	dev_dbg(mmc_dev(host->mmc), "%s: blocks=%d blksz=%d datactrl=0x%08x\n",
+		__func__, data->blocks,	data->blksz, datactrl);
+	dev_dbg(mmc_dev(host->mmc), "%s: timeout=%u timeout_ns=%u\n",
+		__func__, timeout, data->timeout_ns);
+
+	writel(timeout, host->base + REG_DATA_TIMER);
+	writel(host->size, host->base + REG_DATA_LENGTH);
+	writel(datactrl, host->base + REG_DATA_CONTROL);
+}
+
+static void moxart_transfer_check(struct mmc_data *data,
+				  struct moxart_host *host)
+{
+	unsigned int status, count = 0;
+
+	dev_dbg(mmc_dev(host->mmc), "%s\n", __func__);
+
+	while (1) {
+		udelay(10);
+		status = readl(host->base + REG_STATUS);
+		if (status & (MSD_DATA_CRC_OK | MSD_DATA_CRC_FAIL
+			| MSD_DATA_END)	|| count > 10)
+			break;
+		dev_dbg(mmc_dev(host->mmc), "%s: waiting for status=%08x ..\n",
+			__func__, status);
+		count++;
+	}
+	if (status & MSD_DATA_CRC_OK) {
+		dev_dbg(mmc_dev(host->mmc), "%s: MSD_DATA_CRC_OK\n", __func__);
+		writel(MSD_DATA_CRC_OK, host->base + REG_CLEAR);
+	}
+	if (status & MSD_DATA_CRC_FAIL) {
+		dev_dbg(mmc_dev(host->mmc), "%s: MSD_DATA_CRC_FAIL\n",
+			__func__);
+		writel(MSD_DATA_CRC_FAIL, host->base + REG_CLEAR);
+		data->error = MMC_ERR_TIMEOUT;
+	}
+	if (status & MSD_DATA_END) {
+		dev_dbg(mmc_dev(host->mmc), "%s: MSD_DATA_END\n",
+			__func__);
+		writel(MSD_DATA_END, host->base + REG_CLEAR);
+	}
+	if (status & MSD_DATA_TIMEOUT) {
+		dev_dbg(mmc_dev(host->mmc), "%s: MSD_DATA_TIMEOUT\n",
+			__func__);
+		writel(MSD_DATA_TIMEOUT, host->base + REG_CLEAR);
+	}
+}
+
+static void moxart_card_change(struct moxart_host *host)
+{
+	int delay;
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	if (readl(host->base + REG_STATUS) & MSD_CARD_DETECT) {
+		dev_dbg(mmc_dev(host->mmc), "%s: card removed\n", __func__);
+		if (host->have_dma && host->size > MSD_FIFO_LENB) {
+			dev_dbg(mmc_dev(host->mmc), "%s: call dmaengine_terminate_all\n",
+				__func__);
+			dmaengine_terminate_all(host->dma_chan_rx);
+			dmaengine_terminate_all(host->dma_chan_tx);
+		}
+		host->removed = true;
+		delay = 0;
+	} else {
+		dev_dbg(mmc_dev(host->mmc), "%s: card inserted\n", __func__);
+		host->removed = false;
+		delay = 500;
+	}
+
+	/*
+	 * clearing FIFO interrupts here does not stop a follow up
+	 * MSD_FIFO_*RUN after MSD_CARD_CHANGE. instead, check
+	 * host->mrq != NULL in moxart_irq to avoid unnecessary calls
+	 * to moxart_transfer_pio
+	 * if this happens during transfer the mmc_request in
+	 * moxart_request should still be valid
+	 * (which is why host->mrq can be set NULL here)
+	 */
+	host->mrq = NULL;
+	writel(MSD_CARD_CHANGE | MSD_FIFO_ORUN | MSD_FIFO_URUN,
+	       host->base + REG_CLEAR);
+	writel(MSD_CARD_CHANGE, host->base + REG_INTERRUPT_MASK);
+
+	spin_unlock_irqrestore(&host->lock, flags);
+	dev_dbg(mmc_dev(host->mmc), "%s: call mmc_detect_change\n", __func__);
+	mmc_detect_change(host->mmc, msecs_to_jiffies(delay));
+}
+
+static void moxart_request(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	struct moxart_host *host = mmc_priv(mmc);
+	unsigned long dma_time, pio_time, flags;
+	unsigned int status;
+
+	dev_dbg(mmc_dev(host->mmc), "%s\n", __func__);
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	init_completion(&host->dma_complete);
+	init_completion(&host->pio_complete);
+
+	host->mrq = mrq;
+
+	if (readl(host->base + REG_STATUS) & MSD_CARD_DETECT) {
+		mrq->cmd->error = MMC_ERR_TIMEOUT;
+		goto request_done;
+	}
+
+	moxart_prepare_data(host);
+	moxart_send_command(host, host->mrq->cmd);
+
+	if (mrq->cmd->data) {
+		/* only use DMA/PIO (and wait) when there is data */
+		if (((host->size > MSD_FIFO_LENB) || DMA_FIFO_LEN_FORCE)
+			&& host->have_dma) {
+
+			writel(MSD_CARD_CHANGE, host->base +
+			       REG_INTERRUPT_MASK);
+
+			spin_unlock_irqrestore(&host->lock, flags);
+
+			host->dma_direction = (mrq->cmd->data->flags
+					      & MMC_DATA_WRITE) ?
+					      DMA_TO_DEVICE : DMA_FROM_DEVICE;
+			moxart_transfer_dma(mrq->cmd->data, host);
+
+			dma_time = wait_for_completion_interruptible_timeout(
+				   &host->dma_complete, host->timeout);
+			dev_dbg(mmc_dev(host->mmc), "%s: dma_time=%lu (DMA wait time)\n",
+				__func__, dma_time);
+
+			dma_unmap_sg(host->dma_chan_tx->device->dev,
+				     mrq->cmd->data->sg, mrq->cmd->data->sg_len,
+				     host->dma_direction);
+
+			spin_lock_irqsave(&host->lock, flags);
+		} else {
+
+			writel(MSD_FIFO_URUN | MSD_FIFO_ORUN | MSD_CARD_CHANGE,
+			       host->base + REG_INTERRUPT_MASK);
+
+			status = readl(host->base + REG_STATUS);
+			dev_dbg(mmc_dev(host->mmc), "%s: status=%08x\n",
+				__func__, status);
+
+			spin_unlock_irqrestore(&host->lock, flags);
+
+			/* PIO transfer started from interrupt */
+			pio_time = wait_for_completion_interruptible_timeout(
+				   &host->pio_complete, host->timeout);
+			dev_dbg(mmc_dev(host->mmc), "%s: pio_time=%lu (PIO wait time)\n",
+				__func__, pio_time);
+
+			spin_lock_irqsave(&host->lock, flags);
+		}
+
+		/* removed during transfer? (interrupts were just enabled..) */
+		if (host->removed) {
+			dev_dbg(mmc_dev(host->mmc), "%s: host removed during transfer!\n",
+				__func__);
+			mrq->cmd->error = MMC_ERR_TIMEOUT;
+		}
+
+		moxart_transfer_check(mrq->cmd->data, host);
+
+		if (mrq->cmd->data->stop)
+			moxart_send_command(host, mrq->cmd->data->stop);
+	}
+
+request_done:
+	spin_unlock_irqrestore(&host->lock, flags);
+	mmc_request_done(host->mmc, mrq);
+}
+
+static irqreturn_t moxart_irq(int irq, void *devid)
+{
+	struct moxart_host *host = (struct moxart_host *)devid;
+	unsigned int status;
+	unsigned long flags;
+
+	status = readl(host->base + REG_STATUS);
+
+	dev_dbg(mmc_dev(host->mmc), "%s: host=%p status=%08x\n",
+		__func__, host, status);
+
+	if (status & MSD_CARD_CHANGE) {
+		dev_dbg(mmc_dev(host->mmc), "%s: call moxart_card_change\n",
+			__func__);
+		moxart_card_change(host);
+	}
+	if (status & (MSD_FIFO_ORUN | MSD_FIFO_URUN) && host->mrq) {
+		writel(status & (MSD_FIFO_ORUN | MSD_FIFO_URUN),
+		       host->base + REG_CLEAR);
+		dev_dbg(mmc_dev(host->mmc), "%s: call moxart_transfer_pio\n",
+			__func__);
+		spin_lock_irqsave(&host->lock, flags);
+		moxart_transfer_pio(host);
+		spin_unlock_irqrestore(&host->lock, flags);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void moxart_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	struct moxart_host *host = mmc_priv(mmc);
+	unsigned long flags;
+	unsigned short power;
+	int div;
+
+	spin_lock_irqsave(&host->lock, flags);
+	if (ios->clock) {
+		div = (host->sysclk / (host->mmc->f_max * 2)) - 1;
+
+		if (div > MSD_CLK_DIV_MASK)
+			div = MSD_CLK_DIV_MASK;
+		else if (div < 0)
+			div = 0;
+
+		div |= MSD_CLK_SD;
+		writel(div, host->base + REG_CLOCK_CONTROL);
+	} else if (!(readl(host->base + REG_CLOCK_CONTROL) & MSD_CLK_DIS)) {
+		writel(readl(host->base + REG_CLOCK_CONTROL) | MSD_CLK_DIS,
+		       host->base + REG_CLOCK_CONTROL);
+	}
+
+	if (ios->power_mode == MMC_POWER_OFF) {
+		writel(readl(host->base + REG_POWER_CONTROL) & ~MSD_SD_POWER_ON,
+		       host->base + REG_POWER_CONTROL);
+	} else {
+		if (ios->vdd < MIN_POWER)
+			power = 0;
+		else
+			power = ios->vdd - MIN_POWER;
+
+		writel(MSD_SD_POWER_ON | (unsigned int) power,
+		       host->base + REG_POWER_CONTROL);
+	}
+
+	if (ios->bus_width == MMC_BUS_WIDTH_1)
+		writel(MSD_SINGLE_BUS, host->base + REG_BUS_WIDTH);
+	else
+		writel(MSD_WIDE_BUS, host->base + REG_BUS_WIDTH);
+
+	spin_unlock_irqrestore(&host->lock, flags);
+}
+
+
+static int moxart_get_ro(struct mmc_host *mmc)
+{
+	struct moxart_host *host = mmc_priv(mmc);
+
+	return !!(readl(host->base + REG_STATUS) & MSD_WRITE_PROT);
+}
+
+static struct mmc_host_ops moxart_ops = {
+	.request = moxart_request,
+	.set_ios = moxart_set_ios,
+	.get_ro = moxart_get_ro,
+};
+
+static int moxart_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node;
+	struct resource res_mmc;
+	struct mmc_host *mmc;
+	struct moxart_host *host = NULL;
+	void __iomem *reg_mmc;
+	dma_cap_mask_t mask;
+	int ret;
+	struct dma_slave_config cfg;
+	unsigned int irq;
+	struct clk *clk;
+
+	mmc = mmc_alloc_host(sizeof(struct moxart_host), dev);
+	if (!mmc) {
+		dev_err(dev, "%s: mmc_alloc_host failed\n", __func__);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = of_address_to_resource(node, 0, &res_mmc);
+	if (ret) {
+		dev_err(dev, "%s: could not get MMC base resource\n", __func__);
+		goto out;
+	}
+
+	irq = irq_of_parse_and_map(node, 0);
+	if (irq <= 0) {
+		dev_err(dev, "irq_of_parse_and_map failed\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	reg_mmc = devm_ioremap_resource(dev, &res_mmc);
+	if (IS_ERR(reg_mmc))
+		return PTR_ERR(reg_mmc);
+
+	mmc->ops = &moxart_ops;
+
+	/*
+	 * hardware does not support MMC_CAP_SD_HIGHSPEED
+	 * CMD6 will timeout and make things not work
+	 */
+	mmc->caps = MMC_CAP_4_BIT_DATA;
+
+	mmc->f_min = 400000;
+	mmc->f_max = 25000000;
+	mmc->ocr_avail = 0xffff00;	/* support 2.0v - 3.6v power */
+	mmc->max_segs = 32;
+	mmc->max_blk_size = 512;
+	mmc->max_blk_count = mmc->max_req_size / mmc->max_blk_size;
+	mmc->max_seg_size = mmc->max_req_size;
+
+	host = mmc_priv(mmc);
+	host->mmc = mmc;
+	host->base = reg_mmc;
+	host->reg_phys = res_mmc.start;
+	host->timeout = msecs_to_jiffies(1000);
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	clk = of_clk_get(node, 0);
+	if (IS_ERR(clk)) {
+		dev_err(dev, "%s: of_clk_get failed\n", __func__);
+		return PTR_ERR(clk);
+	}
+	host->sysclk = clk_get_rate(clk);
+
+	spin_lock_init(&host->lock);
+
+	/* disable all interrupt */
+	writel(0, host->base + REG_INTERRUPT_MASK);
+
+	/* reset chip */
+	writel(MSD_SDC_RST, host->base + REG_COMMAND);
+
+	/* wait for reset finished */
+	while (readl(host->base + REG_COMMAND) & MSD_SDC_RST)
+		udelay(10);
+
+	host->dma_chan_tx = of_dma_request_slave_channel(node, "tx");
+	host->dma_chan_rx = of_dma_request_slave_channel(node, "rx");
+
+	if (!host->dma_chan_rx || !host->dma_chan_tx) {
+		dev_dbg(dev, "%s: using PIO mode transfer\n", __func__);
+
+		host->have_dma = false;
+		mmc->max_blk_count = 1;
+	} else {
+		dev_dbg(dev, "%s: using 2 DMA channels rx=%p tx=%p\n",
+			__func__, host->dma_chan_rx, host->dma_chan_tx);
+
+		cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+
+		cfg.direction = DMA_MEM_TO_DEV;
+		cfg.src_addr = 0;
+		cfg.dst_addr = (unsigned int)host->reg_phys + MSD_DATA_WIN_REG;
+		dmaengine_slave_config(host->dma_chan_tx, &cfg);
+
+		cfg.direction = DMA_DEV_TO_MEM;
+		cfg.src_addr = (unsigned int)host->reg_phys + MSD_DATA_WIN_REG;
+		cfg.dst_addr = 0;
+		dmaengine_slave_config(host->dma_chan_rx, &cfg);
+
+		host->have_dma = true;
+
+		/*
+		 * there seems to be a max size on transfers so
+		 * set max_blk_count low for both DMA and PIO
+		 *
+		 * sending large chunks result either in timeout
+		 * or render the MMC controller unresponsive
+		 * (status register 0 on consecutive read retries,
+		 * also see comments in moxart_send_command)
+		 *
+		 * obviously, DMA is quicker and can handle
+		 * larger chunks but setting it higher than 16
+		 * can still bug the controller
+		 */
+		mmc->max_blk_count = 16;
+	}
+
+	ret = devm_request_irq(dev, irq, moxart_irq, 0, "moxart-mmc", host);
+
+	if (ret)
+		goto out;
+
+	dev_set_drvdata(dev, mmc);
+	mmc_add_host(mmc);
+
+	dev_dbg(dev, "%s: IRQ=%d\n", __func__, irq);
+
+	return 0;
+
+out:
+	if (mmc)
+		mmc_free_host(mmc);
+	return ret;
+}
+
+static void moxart_release_dma(struct moxart_host *host)
+{
+	if (host->dma_chan_tx) {
+		struct dma_chan *chan = host->dma_chan_tx;
+		host->dma_chan_tx = NULL;
+		dma_release_channel(chan);
+	}
+	if (host->dma_chan_rx) {
+		struct dma_chan *chan = host->dma_chan_rx;
+		host->dma_chan_rx = NULL;
+		dma_release_channel(chan);
+	}
+}
+
+static int moxart_remove(struct platform_device *pdev)
+{
+	struct mmc_host *mmc = dev_get_drvdata(&pdev->dev);
+	struct moxart_host *host = mmc_priv(mmc);
+
+	dev_set_drvdata(&pdev->dev, NULL);
+
+	if (mmc) {
+		moxart_release_dma(host);
+		mmc_remove_host(mmc);
+		mmc_free_host(mmc);
+
+		writel(0, host->base + REG_INTERRUPT_MASK);
+		writel(0, host->base + REG_POWER_CONTROL);
+		writel(readl(host->base + REG_CLOCK_CONTROL) | MSD_CLK_DIS,
+		       host->base + REG_CLOCK_CONTROL);
+	}
+
+	kfree(host);
+
+	return 0;
+}
+
+static const struct of_device_id moxart_sdhci_match[] = {
+	{ .compatible = "moxa,moxart-sdhci" },
+	{ }
+};
+
+static struct platform_driver moxart_sdhci_driver = {
+	.probe      = moxart_probe,
+	.remove     = moxart_remove,
+	.driver     = {
+		.name		= "sdhci-moxart",
+		.owner		= THIS_MODULE,
+		.of_match_table	= moxart_sdhci_match,
+	},
+};
+module_platform_driver(moxart_sdhci_driver);
+
+MODULE_ALIAS("platform:sdhci-moxart");
+MODULE_DESCRIPTION("MOXART SDHCI driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jonas Jensen <jonas.jensen@gmail.com>");
-- 
1.8.2.1

