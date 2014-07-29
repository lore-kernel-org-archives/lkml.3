Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaG2CvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 22:51:12 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:46418 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaG2CvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 22:51:09 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: linux-mmc@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        agross@codeaurora.org, linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v4] mmc: mmci: Add qcom dml support to the driver.
Date: Tue, 29 Jul 2014 03:50:30 +0100
Message-Id: <1406602230-18542-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406528572-5749-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1406528572-5749-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Qualcomm APQ8064 SOCs, SD card controller has an additional glue
called DML (Data Mover Local/Lite) to assist dma transfers.
This hardware needs to be setup before any dma transfer is requested.
DML itself is not a DMA engine, its just a gule between the SD card
controller and dma controller.

Most of this code has been ported from qualcomm's 3.4 kernel.

This patch adds the code necessary to intialize the hardware and setup
before doing any dma transfers.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
Changes since v3:
  - moved copyright from Code Aurora to Linux Foundation, as
    suggested by Stephen B.

Changes since v2:
  - copied missing memory barriers from 3.4 driver, spotted by Stephen B.
  - removed unecessary braceses spotted by Stephen B.
  - copied exact copyright year from 3.4 kernel.

Changes since v1:
   - Added licence text as spotted by Stephen B.
   - Simplified dma channel lookup as suggested by Stephen B.
   - Removed unnecessary parens spotted by Stephen B.
   - in general some cleanup done.

Changes since RFC:
    - Moved qcom_dml.* to mmci_qcom_dml.* as suggested by Linus W.
    - added BAM DMA dependency in Kconfig as suggested by Linus W.

 drivers/mmc/host/Kconfig         |  11 +++
 drivers/mmc/host/Makefile        |   1 +
 drivers/mmc/host/mmci.c          |  18 +++-
 drivers/mmc/host/mmci_qcom_dml.c | 177 +++++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/mmci_qcom_dml.h |  31 +++++++
 5 files changed, 237 insertions(+), 1 deletion(-)
 create mode 100644 drivers/mmc/host/mmci_qcom_dml.c
 create mode 100644 drivers/mmc/host/mmci_qcom_dml.h

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index a565254..3d9b84d 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -14,6 +14,17 @@ config MMC_ARMMMCI
 
 	  If unsure, say N.
 
+config MMC_QCOM_DML
+	tristate "Qualcomm Data Mover for SD Card Controller"
+	depends on MMC_ARMMMCI && QCOM_BAM_DMA
+	default y
+	help
+	  This selects the Qualcomm Data Mover lite/local on SD Card controller.
+	  This option will enable the dma to work correctly, if you are using
+	  Qcom SOCs and MMC, you would probably need this option to get DMA working.
+
+	  if unsure, say N.
+
 config MMC_PXA
 	tristate "Intel PXA25x/26x/27x Multimedia Card Interface support"
 	depends on ARCH_PXA
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index 7f81ddf..344c870 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_MMC_ARMMMCI)	+= mmci.o
+obj-$(CONFIG_MMC_QCOM_DML)	+= mmci_qcom_dml.o
 obj-$(CONFIG_MMC_PXA)		+= pxamci.o
 obj-$(CONFIG_MMC_MXC)		+= mxcmmc.o
 obj-$(CONFIG_MMC_MXS)		+= mxs-mmc.o
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index b66b351..9059570 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -43,6 +43,7 @@
 #include <asm/sizes.h>
 
 #include "mmci.h"
+#include "mmci_qcom_dml.h"
 
 #define DRIVER_NAME "mmci-pl18x"
 
@@ -74,6 +75,7 @@ static unsigned int fmax = 515633;
  * @pwrreg_nopower: bits in MMCIPOWER don't controls ext. power supply
  * @explicit_mclk_control: enable explicit mclk control in driver.
  * @qcom_fifo: enables qcom specific fifo pio read logic.
+ * @qcom_dml: enables qcom specific dma glue for dma transfers.
  */
 struct variant_data {
 	unsigned int		clkreg;
@@ -97,6 +99,7 @@ struct variant_data {
 	bool			pwrreg_nopower;
 	bool			explicit_mclk_control;
 	bool			qcom_fifo;
+	bool			qcom_dml;
 };
 
 static struct variant_data variant_arm = {
@@ -205,6 +208,7 @@ static struct variant_data variant_qcom = {
 	.f_max			= 208000000,
 	.explicit_mclk_control	= true,
 	.qcom_fifo		= true,
+	.qcom_dml		= true,
 };
 
 static int mmci_card_busy(struct mmc_host *mmc)
@@ -418,6 +422,7 @@ static void mmci_dma_setup(struct mmci_host *host)
 {
 	const char *rxname, *txname;
 	dma_cap_mask_t mask;
+	struct variant_data *variant = host->variant;
 
 	host->dma_rx_channel = dma_request_slave_channel(mmc_dev(host->mmc), "rx");
 	host->dma_tx_channel = dma_request_slave_channel(mmc_dev(host->mmc), "tx");
@@ -468,6 +473,10 @@ static void mmci_dma_setup(struct mmci_host *host)
 		if (max_seg_size < host->mmc->max_seg_size)
 			host->mmc->max_seg_size = max_seg_size;
 	}
+
+	if (variant->qcom_dml && host->dma_rx_channel && host->dma_tx_channel)
+		if (dml_hw_init(host, host->mmc->parent->of_node))
+			variant->qcom_dml = false;
 }
 
 /*
@@ -569,6 +578,7 @@ static int __mmci_dma_prep_data(struct mmci_host *host, struct mmc_data *data,
 	struct dma_async_tx_descriptor *desc;
 	enum dma_data_direction buffer_dirn;
 	int nr_sg;
+	unsigned long flags = DMA_CTRL_ACK;
 
 	if (data->flags & MMC_DATA_READ) {
 		conf.direction = DMA_DEV_TO_MEM;
@@ -593,9 +603,12 @@ static int __mmci_dma_prep_data(struct mmci_host *host, struct mmc_data *data,
 	if (nr_sg == 0)
 		return -EINVAL;
 
+	if (host->variant->qcom_dml)
+		flags |= DMA_PREP_INTERRUPT;
+
 	dmaengine_slave_config(chan, &conf);
 	desc = dmaengine_prep_slave_sg(chan, data->sg, nr_sg,
-					    conf.direction, DMA_CTRL_ACK);
+					    conf.direction, flags);
 	if (!desc)
 		goto unmap_exit;
 
@@ -644,6 +657,9 @@ static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
 	dmaengine_submit(host->dma_desc_current);
 	dma_async_issue_pending(host->dma_current);
 
+	if (host->variant->qcom_dml)
+		dml_start_xfer(host, data);
+
 	datactrl |= MCI_DPSM_DMAENABLE;
 
 	/* Trigger the DMA transfer */
diff --git a/drivers/mmc/host/mmci_qcom_dml.c b/drivers/mmc/host/mmci_qcom_dml.c
new file mode 100644
index 0000000..300ef50
--- /dev/null
+++ b/drivers/mmc/host/mmci_qcom_dml.c
@@ -0,0 +1,177 @@
+/*
+ *
+ * Copyright (c) 2011, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/of.h>
+#include <linux/of_dma.h>
+#include <linux/bitops.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/card.h>
+#include "mmci.h"
+
+/* Registers */
+#define DML_CONFIG			0x00
+#define PRODUCER_CRCI_MSK		GENMASK(1, 0)
+#define PRODUCER_CRCI_DISABLE		0
+#define PRODUCER_CRCI_X_SEL		BIT(0)
+#define PRODUCER_CRCI_Y_SEL		BIT(1)
+#define CONSUMER_CRCI_MSK		GENMASK(3, 2)
+#define CONSUMER_CRCI_DISABLE		0
+#define CONSUMER_CRCI_X_SEL		BIT(2)
+#define CONSUMER_CRCI_Y_SEL		BIT(3)
+#define PRODUCER_TRANS_END_EN		BIT(4)
+#define BYPASS				BIT(16)
+#define DIRECT_MODE			BIT(17)
+#define INFINITE_CONS_TRANS		BIT(18)
+
+#define DML_SW_RESET			0x08
+#define DML_PRODUCER_START		0x0c
+#define DML_CONSUMER_START		0x10
+#define DML_PRODUCER_PIPE_LOGICAL_SIZE	0x14
+#define DML_CONSUMER_PIPE_LOGICAL_SIZE	0x18
+#define DML_PIPE_ID			0x1c
+#define PRODUCER_PIPE_ID_SHFT		0
+#define PRODUCER_PIPE_ID_MSK		GENMASK(4, 0)
+#define CONSUMER_PIPE_ID_SHFT		16
+#define CONSUMER_PIPE_ID_MSK		GENMASK(20, 16)
+
+#define DML_PRODUCER_BAM_BLOCK_SIZE	0x24
+#define DML_PRODUCER_BAM_TRANS_SIZE	0x28
+
+/* other definitions */
+#define PRODUCER_PIPE_LOGICAL_SIZE	4096
+#define CONSUMER_PIPE_LOGICAL_SIZE	4096
+
+#define DML_OFFSET			0x800
+
+void dml_start_xfer(struct mmci_host *host, struct mmc_data *data)
+{
+	u32 config;
+	void __iomem *base = host->base + DML_OFFSET;
+
+	if (data->flags & MMC_DATA_READ) {
+		/* Read operation: configure DML for producer operation */
+		/* Set producer CRCI-x and disable consumer CRCI */
+		config = readl_relaxed(base + DML_CONFIG);
+		config = (config & ~PRODUCER_CRCI_MSK) | PRODUCER_CRCI_X_SEL;
+		config = (config & ~CONSUMER_CRCI_MSK) | CONSUMER_CRCI_DISABLE;
+		writel_relaxed(config, base + DML_CONFIG);
+
+		/* Set the Producer BAM block size */
+		writel_relaxed(data->blksz, base + DML_PRODUCER_BAM_BLOCK_SIZE);
+
+		/* Set Producer BAM Transaction size */
+		writel_relaxed(data->blocks * data->blksz,
+			       base + DML_PRODUCER_BAM_TRANS_SIZE);
+		/* Set Producer Transaction End bit */
+		config = readl_relaxed(base + DML_CONFIG);
+		config |= PRODUCER_TRANS_END_EN;
+		writel_relaxed(config, base + DML_CONFIG);
+		/* Trigger producer */
+		writel_relaxed(1, base + DML_PRODUCER_START);
+	} else {
+		/* Write operation: configure DML for consumer operation */
+		/* Set consumer CRCI-x and disable producer CRCI*/
+		config = readl_relaxed(base + DML_CONFIG);
+		config = (config & ~CONSUMER_CRCI_MSK) | CONSUMER_CRCI_X_SEL;
+		config = (config & ~PRODUCER_CRCI_MSK) | PRODUCER_CRCI_DISABLE;
+		writel_relaxed(config, base + DML_CONFIG);
+		/* Clear Producer Transaction End bit */
+		config = readl_relaxed(base + DML_CONFIG);
+		config &= ~PRODUCER_TRANS_END_EN;
+		writel_relaxed(config, base + DML_CONFIG);
+		/* Trigger consumer */
+		writel_relaxed(1, base + DML_CONSUMER_START);
+	}
+
+	/* make sure the dml is configured before dma is triggered */
+	wmb();
+}
+
+static int of_get_dml_pipe_index(struct device_node *np, const char *name)
+{
+	int index;
+	struct of_phandle_args	dma_spec;
+
+	index = of_property_match_string(np, "dma-names", name);
+
+	if (index < 0)
+		return -ENODEV;
+
+	if (of_parse_phandle_with_args(np, "dmas", "#dma-cells", index,
+				       &dma_spec))
+		return -ENODEV;
+
+	if (dma_spec.args_count)
+		return dma_spec.args[0];
+
+	return -ENODEV;
+}
+
+/* Initialize the dml hardware connected to SD Card controller */
+int dml_hw_init(struct mmci_host *host, struct device_node *np)
+{
+	u32 config;
+	void __iomem *base;
+	u32 consumer_id, producer_id;
+
+	consumer_id = of_get_dml_pipe_index(np, "tx");
+	producer_id = of_get_dml_pipe_index(np, "rx");
+
+	if (producer_id < 0 || consumer_id < 0)
+		return -ENODEV;
+
+	base = host->base + DML_OFFSET;
+
+	/* Reset the DML block */
+	writel_relaxed(1, base + DML_SW_RESET);
+
+	/* Disable the producer and consumer CRCI */
+	config = (PRODUCER_CRCI_DISABLE | CONSUMER_CRCI_DISABLE);
+	/*
+	 * Disable the bypass mode. Bypass mode will only be used
+	 * if data transfer is to happen in PIO mode and don't
+	 * want the BAM interface to connect with SDCC-DML.
+	 */
+	config &= ~BYPASS;
+	/*
+	 * Disable direct mode as we don't DML to MASTER the AHB bus.
+	 * BAM connected with DML should MASTER the AHB bus.
+	 */
+	config &= ~DIRECT_MODE;
+	/*
+	 * Disable infinite mode transfer as we won't be doing any
+	 * infinite size data transfers. All data transfer will be
+	 * of finite data size.
+	 */
+	config &= ~INFINITE_CONS_TRANS;
+	writel_relaxed(config, base + DML_CONFIG);
+
+	/*
+	 * Initialize the logical BAM pipe size for producer
+	 * and consumer.
+	 */
+	writel_relaxed(PRODUCER_PIPE_LOGICAL_SIZE,
+		       base + DML_PRODUCER_PIPE_LOGICAL_SIZE);
+	writel_relaxed(CONSUMER_PIPE_LOGICAL_SIZE,
+		       base + DML_CONSUMER_PIPE_LOGICAL_SIZE);
+
+	/* Initialize Producer/consumer pipe id */
+	writel_relaxed(producer_id | (consumer_id << CONSUMER_PIPE_ID_SHFT),
+		       base + DML_PIPE_ID);
+
+	/* Make sure dml intialization is finished */
+	mb();
+
+	return 0;
+}
diff --git a/drivers/mmc/host/mmci_qcom_dml.h b/drivers/mmc/host/mmci_qcom_dml.h
new file mode 100644
index 0000000..6e405d0
--- /dev/null
+++ b/drivers/mmc/host/mmci_qcom_dml.h
@@ -0,0 +1,31 @@
+/*
+ *
+ * Copyright (c) 2011, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef __MMC_QCOM_DML_H__
+#define __MMC_QCOM_DML_H__
+
+#ifdef CONFIG_MMC_QCOM_DML
+int dml_hw_init(struct mmci_host *host, struct device_node *np);
+void dml_start_xfer(struct mmci_host *host, struct mmc_data *data);
+#else
+static inline int dml_hw_init(struct mmci_host *host, struct device_node *np)
+{
+	return -ENOSYS;
+}
+static inline void dml_start_xfer(struct mmci_host *host, struct mmc_data *data)
+{
+}
+#endif /* CONFIG_MMC_QCOM_DML */
+
+#endif /* __MMC_QCOM_DML_H__ */
-- 
1.9.1

