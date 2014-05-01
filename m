Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbaEAKKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:10:13 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:60885 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbaEAJ5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:57:15 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/47] mtd: nand: adding ST's BCH NAND Controller driver
Date: Thu,  1 May 2014 10:56:11 +0100
Message-Id: <1398938214-17847-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First introduction of the driver. Includes the basic device struct
(some functionality isn't utilised as of yet) and supplies some of the
important resources required for basic running of the Controller.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/Kconfig        |   7 ++
 drivers/mtd/nand/Makefile       |   1 +
 drivers/mtd/nand/stm_nand_bch.c | 146 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mtd/stm_nand.h    |  33 +++++++++
 4 files changed, 187 insertions(+)
 create mode 100644 drivers/mtd/nand/stm_nand_bch.c
 create mode 100644 include/linux/mtd/stm_nand.h

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 93ae6a6..7b1352a 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -510,4 +510,11 @@ config MTD_NAND_XWAY
 	  Enables support for NAND Flash chips on Lantiq XWAY SoCs. NAND is attached
 	  to the External Bus Unit (EBU).
 
+config MTD_NAND_STM_BCH
+	tristate "STMicroelectronics: NANDi BCH Controller"
+	depends on ARM
+	depends on OF
+	help
+	  Adds support for the STMicroelectronics NANDi BCH Controller.
+
 endif # MTD_NAND
diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index 542b568..94e7737 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_MTD_NAND_NUC900)		+= nuc900_nand.o
 obj-$(CONFIG_MTD_NAND_MPC5121_NFC)	+= mpc5121_nfc.o
 obj-$(CONFIG_MTD_NAND_RICOH)		+= r852.o
 obj-$(CONFIG_MTD_NAND_JZ4740)		+= jz4740_nand.o
+obj-$(CONFIG_MTD_NAND_STM_BCH)		+= stm_nand_bch.o
 obj-$(CONFIG_MTD_NAND_GPMI_NAND)	+= gpmi-nand/
 obj-$(CONFIG_MTD_NAND_XWAY)		+= xway_nand.o
 obj-$(CONFIG_MTD_NAND_BCM47XXNFLASH)	+= bcm47xxnflash/
diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
new file mode 100644
index 0000000..09a7fdb
--- /dev/null
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -0,0 +1,146 @@
+/*
+ * drivers/mtd/nand/stm_nand_bch.c
+ *
+ * Support for STMicroelectronics NANDi BCH Controller
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/completion.h>
+#include <linux/mtd/stm_nand.h>
+
+/* NANDi Controller (Hamming/BCH) */
+struct nandi_controller {
+	void __iomem		*base;		/* Controller base*/
+	void __iomem		*dma;		/* DMA control base */
+						/* IRQ-triggered Completions: */
+	struct completion	seq_completed;	/*   SEQ Over */
+	struct completion	rbn_completed;	/*   RBn */
+
+	struct device		*dev;
+
+	int			bch_ecc_mode;	/* ECC mode */
+	bool			extra_addr;	/* Extra address cycle */
+
+	/*
+	 * The threshold at which the number of corrected bit-flips per sector
+	 * is deemed to have reached an excessive level (triggers '-EUCLEAN'
+	 * return code).
+	 */
+	int			bitflip_threshold;
+
+	uint32_t		page_shift;	/* Some working variables */
+	uint32_t		block_shift;
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
+};
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
+	struct nandi_controller *nandi;
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
+	err = remap_named_resource(pdev, "nand_mem", &nandi->base);
+	if (err)
+		return ERR_PTR(err);
+
+	err = remap_named_resource(pdev, "nand_dma", &nandi->dma);
+	if (err)
+		return ERR_PTR(err);
+
+	platform_set_drvdata(pdev, nandi);
+
+	return nandi;
+}
+
+static int stm_nand_bch_probe(struct platform_device *pdev)
+{
+	struct stm_plat_nand_bch_data *pdata = pdev->dev.platform_data;
+	struct nandi_controller *nandi;
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
+	return 0;
+}
+
+static int stm_nand_bch_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct platform_driver stm_nand_bch_driver = {
+	.probe	= stm_nand_bch_probe ,
+	.remove	= stm_nand_bch_remove,
+	.driver	= {
+		.name	= "stm-nand-bch",
+		.owner	= THIS_MODULE,
+	},
+};
+module_platform_driver(stm_nand_bch_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Angus Clark");
+MODULE_DESCRIPTION("STM NAND BCH driver");
diff --git a/include/linux/mtd/stm_nand.h b/include/linux/mtd/stm_nand.h
new file mode 100644
index 0000000..9210d5c
--- /dev/null
+++ b/include/linux/mtd/stm_nand.h
@@ -0,0 +1,33 @@
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
+struct stm_plat_nand_bch_data {
+	struct stm_nand_bank_data *bank;
+	enum stm_nand_bch_ecc_config bch_ecc_cfg;
+
+	/* The threshold at which the number of corrected bit-flips per sector
+	 * is deemed to have reached an excessive level (triggers '-EUCLEAN' to
+	 * be returned to the caller).  The value should be in the range 1 to
+	 * <ecc-strength> where <ecc-strength> is 18 or 30, depending on the BCH
+	 * ECC mode in operation.  A value of 0 is interpreted by the driver as
+	 * <ecc-strength>.
+	 */
+	unsigned int bch_bitflip_threshold;
+	bool flashss;
+};
+
+#endif /* __LINUX_STM_NAND_H */
-- 
1.8.3.2

