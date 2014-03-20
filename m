Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbaCTJeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:34:00 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:53435 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaCTJVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:21:20 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org, Angus.Clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 01/36] mtd: st_spi_fsm: Allocate resources and register with MTD framework
Date: Thu, 20 Mar 2014 09:20:33 +0000
Message-Id: <1395307268-12721-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new driver. It's used to communicate with a special type of
optimised Serial Flash Controller called the FSM. The FSM uses a subset
of the SPI protocol to communicate with supported NOR-Flash devices.

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/Kconfig      |   8 +++
 drivers/mtd/devices/Makefile     |   1 +
 drivers/mtd/devices/st_spi_fsm.c | 106 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 115 insertions(+)
 create mode 100644 drivers/mtd/devices/st_spi_fsm.c

diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 0128138..1210bc2 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -210,6 +210,14 @@ config MTD_DOCG3
 	  M-Systems and now Sandisk. The support is very experimental,
 	  and doesn't give access to any write operations.
 
+config MTD_ST_SPI_FSM
+	tristate "ST Microelectronics SPI FSM Serial Flash Controller"
+	depends on ARM || SH
+	help
+	  This provides an MTD device driver for the ST Microelectronics
+	  SPI Fast Sequence Mode (FSM) Serial Flash Controller and support
+	  for a subset of connected Serial Flash devices.
+
 if MTD_DOCG3
 config BCH_CONST_M
 	default 14
diff --git a/drivers/mtd/devices/Makefile b/drivers/mtd/devices/Makefile
index d83bd73..c68868f 100644
--- a/drivers/mtd/devices/Makefile
+++ b/drivers/mtd/devices/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_MTD_NAND_OMAP_BCH)	+= elm.o
 obj-$(CONFIG_MTD_SPEAR_SMI)	+= spear_smi.o
 obj-$(CONFIG_MTD_SST25L)	+= sst25l.o
 obj-$(CONFIG_MTD_BCM47XXSFLASH)	+= bcm47xxsflash.o
+obj-$(CONFIG_MTD_ST_SPI_FSM)    += st_spi_fsm.o
 
 
 CFLAGS_docg3.o			+= -I$(src)
diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
new file mode 100644
index 0000000..b1e6740
--- /dev/null
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -0,0 +1,106 @@
+/*
+ * st_spi_fsm.c	- ST Fast Sequence Mode (FSM) Serial Flash Controller
+ *
+ * Author: Angus Clark <angus.clark@st.com>
+ *
+ * Copyright (C) 2010-2014 STicroelectronics Limited
+ *
+ * JEDEC probe based on drivers/mtd/devices/m25p80.c
+ *
+ * This code is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/mtd.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/of.h>
+
+struct stfsm {
+	struct device		*dev;
+	void __iomem		*base;
+	struct resource		*region;
+	struct mtd_info		mtd;
+	struct mutex		lock;
+};
+
+static int stfsm_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct resource *res;
+	struct stfsm *fsm;
+
+	if (!np) {
+		dev_err(&pdev->dev, "No DT found\n");
+		return -EINVAL;
+	}
+
+	fsm = devm_kzalloc(&pdev->dev, sizeof(*fsm), GFP_KERNEL);
+	if (!fsm)
+		return -ENOMEM;
+
+	fsm->dev = &pdev->dev;
+
+	platform_set_drvdata(pdev, fsm);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "Resource not found\n");
+		return -ENODEV;
+	}
+
+	fsm->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(fsm->base)) {
+		dev_err(&pdev->dev,
+			"Failed to reserve memory region %pR\n", res);
+		return PTR_ERR(fsm->base);
+	}
+
+	mutex_init(&fsm->lock);
+
+	fsm->mtd.dev.parent	= &pdev->dev;
+	fsm->mtd.type		= MTD_NORFLASH;
+	fsm->mtd.writesize	= 4;
+	fsm->mtd.writebufsize	= fsm->mtd.writesize;
+	fsm->mtd.flags		= MTD_CAP_NORFLASH;
+
+	return mtd_device_parse_register(&fsm->mtd, NULL, NULL, NULL, 0);
+}
+
+static int stfsm_remove(struct platform_device *pdev)
+{
+	struct stfsm *fsm = platform_get_drvdata(pdev);
+	int err;
+
+	err = mtd_device_unregister(&fsm->mtd);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static struct of_device_id stfsm_match[] = {
+	{ .compatible = "st,spi-fsm", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, stfsm_match);
+
+static struct platform_driver stfsm_driver = {
+	.probe		= stfsm_probe,
+	.remove		= stfsm_remove,
+	.driver		= {
+		.name	= "st-spi-fsm",
+		.owner	= THIS_MODULE,
+		.of_match_table = stfsm_match,
+	},
+};
+module_platform_driver(stfsm_driver);
+
+MODULE_AUTHOR("Angus Clark <angus.clark@st.com>");
+MODULE_DESCRIPTION("ST SPI FSM driver");
+MODULE_LICENSE("GPL");
-- 
1.8.3.2

