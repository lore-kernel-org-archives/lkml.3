Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab3LODfY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 22:35:24 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49481 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3LODfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 22:35:22 -0500
From: dt.tangr@gmail.com
To: linux-usb@vger.kernel.org
Cc: Daniel Tang <dt.tangr@gmail.com>, linux-kernel@vger.kernel.org,
        Peter.Chen@freescale.com
Subject: [PATCH 1/3] usb: chipidea: add support for USB OTG controller on LSI Zevio SoCs
Date: Sun, 15 Dec 2013 14:35:07 +1100
Message-Id: <1387078509-14156-1-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Tang <dt.tangr@gmail.com>

The USB controller in TI-NSPIRE calculators (LSI Zevio SoC) are based off either
Freescale's USB OTG controller or the USB controller found in the IMX233, both
of which are Chipidea compatible.

This patch adds a device tree binding for the controller.

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 drivers/usb/chipidea/Makefile        |    1 +
 drivers/usb/chipidea/ci_hdrc_zevio.c |   72 ++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)
 create mode 100644 drivers/usb/chipidea/ci_hdrc_zevio.c

diff --git a/drivers/usb/chipidea/Makefile b/drivers/usb/chipidea/Makefile
index a99d980..7635407 100644
--- a/drivers/usb/chipidea/Makefile
+++ b/drivers/usb/chipidea/Makefile
@@ -10,6 +10,7 @@ ci_hdrc-$(CONFIG_USB_CHIPIDEA_DEBUG)	+= debug.o
 # Glue/Bridge layers go here
 
 obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_msm.o
+obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_zevio.o
 
 # PCI doesn't provide stubs, need to check
 ifneq ($(CONFIG_PCI),)
diff --git a/drivers/usb/chipidea/ci_hdrc_zevio.c b/drivers/usb/chipidea/ci_hdrc_zevio.c
new file mode 100644
index 0000000..3bf6489
--- /dev/null
+++ b/drivers/usb/chipidea/ci_hdrc_zevio.c
@@ -0,0 +1,72 @@
+/*
+ *	Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ * Based off drivers/usb/chipidea/ci_hdrc_msm.c
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/usb/gadget.h>
+#include <linux/usb/chipidea.h>
+
+#include "ci.h"
+
+static struct ci_hdrc_platform_data ci_hdrc_zevio_platdata = {
+	.name			= "ci_hdrc_zevio",
+	.flags			= CI_HDRC_REGS_SHARED,
+	.capoffset		= DEF_CAPOFFSET,
+};
+
+static int ci_hdrc_zevio_probe(struct platform_device *pdev)
+{
+	struct platform_device *ci_pdev;
+
+	dev_dbg(&pdev->dev, "ci_hdrc_zevio_probe\n");
+
+	ci_pdev = ci_hdrc_add_device(&pdev->dev,
+				pdev->resource, pdev->num_resources,
+				&ci_hdrc_zevio_platdata);
+
+	if (IS_ERR(ci_pdev)) {
+		dev_err(&pdev->dev, "ci_hdrc_add_device failed!\n");
+		return PTR_ERR(ci_pdev);
+	}
+
+	platform_set_drvdata(pdev, ci_pdev);
+
+	return 0;
+}
+
+static int ci_hdrc_zevio_remove(struct platform_device *pdev)
+{
+	struct platform_device *ci_pdev = platform_get_drvdata(pdev);
+
+	ci_hdrc_remove_device(ci_pdev);
+
+	return 0;
+}
+
+static const struct of_device_id ci_hdrc_zevio_dt_ids[] = {
+	{ .compatible = "lsi,zevio-usb", },
+	{ /* sentinel */ }
+};
+
+static struct platform_driver ci_hdrc_zevio_driver = {
+	.probe = ci_hdrc_zevio_probe,
+	.remove = ci_hdrc_zevio_remove,
+	.driver = {
+		.name = "zevio_usb",
+		.owner = THIS_MODULE,
+		.of_match_table = ci_hdrc_zevio_dt_ids,
+	},
+};
+
+MODULE_DEVICE_TABLE(of, ci_hdrc_zevio_dt_ids);
+module_platform_driver(ci_hdrc_zevio_driver);
+
+MODULE_LICENSE("GPL v2");
-- 
1.7.10.4

