Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaF0Dy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:54:57 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:29864
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751406AbaF0Dyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:54:55 -0400
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: <robh+dt@kernel.org>, <Peter.Chen@freescale.com>,
        <gregkh@linuxfoundation.org>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <michal.simek@xilinx.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <kpc528@gmail.com>,
        <kalluripunnaiahchoudary@gmail.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: [PATCH 2/2] usb: chipidea: Add support for zynq usb host and device controller
Date: Fri, 27 Jun 2014 09:10:09 +0530
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1403840409-5035-1-git-send-email-punnaia@xilinx.com>
References: <1403840409-5035-1-git-send-email-punnaia@xilinx.com>
X-RCIS-Action: ALLOW
Message-ID: <d5c3bf63-f860-4f59-9a9a-88fb73454be7@BL2FFO11FD031.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199002)(189002)(86362001)(77156001)(47776003)(50986999)(4396001)(104016002)(2201001)(81342001)(64706001)(20776003)(33646001)(87286001)(1496007)(104166001)(102836001)(74316001)(88136002)(99396002)(53416004)(31696002)(95666004)(46102001)(106466001)(77096002)(79102001)(85306003)(77982001)(76176999)(76482001)(21056001)(19580405001)(74662001)(74502001)(80022001)(31966008)(89996001)(44976005)(92566001)(92726001)(62966002)(50466002)(83072002)(575784001)(50226001)(85852003)(81542001)(48376002)(19580395003)(87936001)(83322001)(70736001)(93916002)(6806004)(107046002)(107986001)(23106004)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB022;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0255DF69B9
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zynq soc usb controller is a synopsys IP and it is compatible
with the chipidea spec. So, reusing chipidea drivers for zynq usb
controller.

Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
---
 drivers/usb/chipidea/Makefile       |    1 +
 drivers/usb/chipidea/ci_hdrc_zynq.c |  115 +++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+), 0 deletions(-)
 create mode 100644 drivers/usb/chipidea/ci_hdrc_zynq.c

diff --git a/drivers/usb/chipidea/Makefile b/drivers/usb/chipidea/Makefile
index 2f099c7..b0d6b6f 100644
--- a/drivers/usb/chipidea/Makefile
+++ b/drivers/usb/chipidea/Makefile
@@ -12,6 +12,7 @@ ci_hdrc-$(CONFIG_USB_OTG_FSM)		+= otg_fsm.o
 
 obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_msm.o
 obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_zevio.o
+obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_zynq.o
 
 # PCI doesn't provide stubs, need to check
 ifneq ($(CONFIG_PCI),)
diff --git a/drivers/usb/chipidea/ci_hdrc_zynq.c b/drivers/usb/chipidea/ci_hdrc_zynq.c
new file mode 100644
index 0000000..b3667da
--- /dev/null
+++ b/drivers/usb/chipidea/ci_hdrc_zynq.c
@@ -0,0 +1,115 @@
+/*
+ * Copyright (C) 2014 Xilinx, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/usb/chipidea.h>
+
+#include "ci.h"
+
+#define ZYNQ_USB_DMA_MASK	0xFFFFFFF0
+
+struct ci_hdrc_zynq_data {
+	struct platform_device *ci_pdev;
+	struct clk *clk;
+};
+
+static struct ci_hdrc_platform_data pdata = {
+	.name           = "ci_hdrc_zynq",
+	.capoffset      = DEF_CAPOFFSET,
+	.flags          = CI_HDRC_REQUIRE_TRANSCEIVER
+};
+
+static int ci_hdrc_zynq_probe(struct platform_device *pdev)
+{
+	struct ci_hdrc_zynq_data *data;
+	int ret;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&pdev->dev, "Failed to allocate ci_hdrc-imx data!\n");
+		return -ENOMEM;
+	}
+
+	data->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(data->clk)) {
+		dev_err(&pdev->dev,
+			"Failed to get clock, err=%ld\n", PTR_ERR(data->clk));
+		return PTR_ERR(data->clk);
+	}
+
+	ret = clk_prepare_enable(data->clk);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Failed to prepare or enable clock, err=%d\n", ret);
+		return ret;
+	}
+
+	ret = dma_coerce_mask_and_coherent(&pdev->dev, ZYNQ_USB_DMA_MASK);
+	if (ret)
+		goto err_clk;
+
+	data->ci_pdev = ci_hdrc_add_device(&pdev->dev,
+				pdev->resource, pdev->num_resources,
+				&pdata);
+	if (IS_ERR(data->ci_pdev)) {
+		ret = PTR_ERR(data->ci_pdev);
+		dev_err(&pdev->dev,
+			"Can't register ci_hdrc platform device, err=%d\n",
+			ret);
+		goto err_clk;
+	}
+
+	platform_set_drvdata(pdev, data);
+
+	pm_runtime_no_callbacks(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+	return 0;
+
+err_clk:
+	clk_disable_unprepare(data->clk);
+	return ret;
+}
+
+static int ci_hdrc_zynq_remove(struct platform_device *pdev)
+{
+	struct ci_hdrc_zynq_data *data = platform_get_drvdata(pdev);
+
+	pm_runtime_disable(&pdev->dev);
+	ci_hdrc_remove_device(data->ci_pdev);
+	clk_disable_unprepare(data->clk);
+
+	return 0;
+}
+
+static const struct of_device_id ci_hdrc_zynq_dt_ids[] = {
+	{ .compatible = "xlnx,zynq-usb-2.20a" },
+	{},
+};
+
+static struct platform_driver ci_hdrc_zynq_driver = {
+	.probe = ci_hdrc_zynq_probe,
+	.remove = ci_hdrc_zynq_remove,
+	.driver = {
+		.name = "zynq_usb",
+		.owner = THIS_MODULE,
+		.of_match_table = ci_hdrc_zynq_dt_ids,
+	 },
+};
+
+module_platform_driver(ci_hdrc_zynq_driver);
+
+MODULE_ALIAS("platform:zynq_usb");
+MODULE_DESCRIPTION("CI HDRC ZYNQ USB binding");
+MODULE_AUTHOR("Xilinx Inc");
+MODULE_LICENSE("GPL v2");
-- 
1.7.4


