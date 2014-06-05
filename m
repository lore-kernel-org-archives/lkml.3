Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaFEPvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:51:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58896 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752580AbaFEPsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:48:53 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] usb: chipidea: add Berlin USB support
Date: Thu,  5 Jun 2014 17:48:43 +0200
Message-Id: <1401983326-19205-7-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Marvell Berlin USB controllers are compatible with ChipIdea. Add a
driver using the ChipIdea common functions to support them.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 drivers/usb/chipidea/Makefile         |   1 +
 drivers/usb/chipidea/ci_hdrc_berlin.c | 108 ++++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+)
 create mode 100644 drivers/usb/chipidea/ci_hdrc_berlin.c

diff --git a/drivers/usb/chipidea/Makefile b/drivers/usb/chipidea/Makefile
index 480bd4d5710a..b3a1b0b3b7a9 100644
--- a/drivers/usb/chipidea/Makefile
+++ b/drivers/usb/chipidea/Makefile
@@ -19,4 +19,5 @@ endif
 
 ifneq ($(CONFIG_OF),)
 	obj-$(CONFIG_USB_CHIPIDEA)	+= usbmisc_imx.o ci_hdrc_imx.o
+	obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_berlin.o
 endif
diff --git a/drivers/usb/chipidea/ci_hdrc_berlin.c b/drivers/usb/chipidea/ci_hdrc_berlin.c
new file mode 100644
index 000000000000..567d83039e3e
--- /dev/null
+++ b/drivers/usb/chipidea/ci_hdrc_berlin.c
@@ -0,0 +1,108 @@
+/*
+ * Copyright (C) 2014 Marvell Technology Group Ltd.
+ *
+ * Antoine Ténart <antoine.tenart@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/usb/chipidea.h>
+#include <linux/usb/hcd.h>
+#include <linux/usb/ulpi.h>
+
+#include "ci.h"
+
+struct ci_hdrc_berlin_priv {
+	struct platform_device	*ci_pdev;
+	struct clk		*clk;
+};
+
+static int ci_hdrc_berlin_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ci_hdrc_berlin_priv *priv;
+	struct ci_hdrc_platform_data ci_pdata = {
+		.name		= "ci_hdrc_berlin",
+		.capoffset	= DEF_CAPOFFSET,
+		.flags		= CI_HDRC_REQUIRE_TRANSCEIVER |
+				  CI_HDRC_DISABLE_STREAMING,
+	};
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(priv->clk)) {
+		dev_err(dev, "failed to get clock: %ld\n", PTR_ERR(priv->clk));
+		return PTR_ERR(priv->clk);
+	}
+
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return ret;
+
+	ci_pdata.phy = devm_usb_get_phy_by_phandle(dev, "marvell,usbphy", 0);
+	if (IS_ERR(ci_pdata.phy)) {
+		ret = PTR_ERR(ci_pdata.phy);
+		goto clk_err;
+	}
+
+	priv->ci_pdev = ci_hdrc_add_device(dev, pdev->resource,
+				     pdev->num_resources, &ci_pdata);
+	if (IS_ERR(priv->ci_pdev)) {
+		ret = PTR_ERR(priv->ci_pdev);
+		dev_err(dev,
+			"failed to register ci_hdrc platform device: %d\n",
+			ret);
+		goto clk_err;
+	}
+
+	platform_set_drvdata(pdev, priv);
+
+	pm_runtime_no_callbacks(dev);
+	pm_runtime_enable(dev);
+
+	return 0;
+
+clk_err:
+	clk_disable_unprepare(priv->clk);
+	return ret;
+}
+
+static int ci_hdrc_berlin_remove(struct platform_device *pdev)
+{
+	struct ci_hdrc_berlin_priv *priv = platform_get_drvdata(pdev);
+
+	pm_runtime_disable(&pdev->dev);
+	ci_hdrc_remove_device(priv->ci_pdev);
+	clk_disable_unprepare(priv->clk);
+
+	return 0;
+}
+
+static const struct of_device_id ci_hdrc_berlin_of_match[] = {
+	{ .compatible = "marvell,berlin-usb" },
+	{ }
+};
+
+static struct platform_driver ci_hdrc_berlin_driver = {
+	.probe	= ci_hdrc_berlin_probe,
+	.remove	= ci_hdrc_berlin_remove,
+	.driver	= {
+		.name		= "berlin-usb",
+		.owner		= THIS_MODULE,
+		.of_match_table	= ci_hdrc_berlin_of_match,
+	},
+};
+module_platform_driver(ci_hdrc_berlin_driver);
+
+MODULE_DESCRIPTION("ChipIdea HDRC Berlin USB binding");
+MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
+MODULE_LICENSE("GPL");
-- 
1.9.1

