Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab3K2MTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:19:40 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:59807 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3K2MTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:19:38 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Cc: linus.walleij@linaro.org, linux-mtd@lists.infradead.org,
        angus.clark@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v3 01/36] mtd: st_spi_fsm: Allocate resources and register with MTD framework
Date: Fri, 29 Nov 2013 12:18:50 +0000
Message-Id: <1385727565-25794-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new driver. It's used to communicate with a special type of
optimised Serial Flash Controller called the FSM. The FSM uses a subset
of the SPI protocol to communicate with supported NOR-Flash devices.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/Kconfig      |   7 +++
 drivers/mtd/devices/Makefile     |   1 +
 drivers/mtd/devices/st_spi_fsm.c | 111 +++++++++++++++++++++++++++++++++++++++
 drivers/mtd/devices/st_spi_fsm.h |  27 ++++++++++
 4 files changed, 146 insertions(+)
 create mode 100644 drivers/mtd/devices/st_spi_fsm.c
 create mode 100644 drivers/mtd/devices/st_spi_fsm.h

diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 74ab4b7..d977281 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -217,6 +217,13 @@ config MTD_DOCG3
 	  M-Systems and now Sandisk. The support is very experimental,
 	  and doesn't give access to any write operations.
 
+config MTD_ST_SPI_FSM
+	tristate "ST Microelectronics SPI FSM Serial Flash Controller"
+	help
+	  This provides an MTD device driver for the ST Microelectronics
+	  SPI FSM Serial Flash Controller and support for a subset of
+	  connected Serial Flash devices.
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
index 0000000..1e3abde
--- /dev/null
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -0,0 +1,111 @@
+/*
+ * st_spi_fsm.c	Support for ST Serial Flash Controller
+ *
+ * Author: Angus Clark <angus.clark@st.com>
+ *
+ * Copyright (C) 2010-2013 STicroelectronics Limited
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
+#include <asm/io.h>
+
+#include "st_spi_fsm.h"
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
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "Resource not found\n");
+		return -ENODEV;
+	}
+
+	fsm->region = devm_request_mem_region(&pdev->dev, res->start,
+					      resource_size(res), pdev->name);
+	if (!fsm->region) {
+		dev_err(&pdev->dev,
+			"Failed to reserve memory region [0x%08x-0x%08x]\n",
+			res->start, res->end);
+		return -EBUSY;
+	}
+
+	fsm->base = devm_ioremap_nocache(&pdev->dev,
+					 res->start, resource_size(res));
+	if (!fsm->base) {
+		dev_err(&pdev->dev, "Failed to ioremap [0x%08x]\n", res->start);
+		return -EINVAL;
+	}
+
+	mutex_init(&fsm->lock);
+
+	platform_set_drvdata(pdev, fsm);
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
+MODULE_DEVICE_TABLE(of, spi_fsm_match);
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
diff --git a/drivers/mtd/devices/st_spi_fsm.h b/drivers/mtd/devices/st_spi_fsm.h
new file mode 100644
index 0000000..df45e1a
--- /dev/null
+++ b/drivers/mtd/devices/st_spi_fsm.h
@@ -0,0 +1,27 @@
+/*
+ * st_spi_fsm.c	Support for ST Serial Flash Controller
+ *
+ * Author: Angus Clark <angus.clark@st.com>
+ *
+ * Copyright (C) 2010-2013 STicroelectronics Limited
+ *
+ * JEDEC probe based on drivers/mtd/devices/m25p80.c
+ *
+ * This code is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef ST_SPI_FSM_H
+#define ST_SPI_FSM_H
+
+struct stfsm {
+	struct device		*dev;
+	void __iomem		*base;
+	struct resource		*region;
+	struct mtd_info		mtd;
+	struct mutex		lock;
+};
+
+#endif	/* ST_SPI_FSM_H */
-- 
1.8.3.2

